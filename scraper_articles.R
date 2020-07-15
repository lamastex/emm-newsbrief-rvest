## MIT License
## Copyright (c) 2020 Tilo Wiklund
##
## Permission is hereby granted, free of charge, to any person obtaining a copy
## of this software and associated documentation files (the "Software"), to deal
## in the Software without restriction, including without limitation the rights
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
## copies of the Software, and to permit persons to whom the Software is
## furnished to do so, subject to the following conditions:
##
## The above copyright notice and this permission notice shall be included in all
## copies or substantial portions of the Software.
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
## SOFTWARE.

suppressMessages(library(magrittr))
suppressMessages(library(tidyverse))
suppressMessages(library(rvest))
suppressMessages(library(fs))
suppressMessages(library(lubridate))

argv <- commandArgs(trailingOnly = TRUE)

if(length(argv) != 3) {
  stop("Usage: RScript scraper_articles.R DATE LANGUAGE OUTPUT_PATH")
}

DATE <- argv[1] # "2020-05-01"
LANGUAGE <- argv[2] # "sv"
BASE_OUTPUT_PATH <- argv[3] # "/tmp"
VERBOSE <- FALSE

## String template for search results URL
emm.url.template <- function(i, from, to=from, language="all", page.language="en")
  str_c("https://emm.newsbrief.eu/NewsBrief/dynamic",
        "?language=", page.language,
        "&page=", i,
        "&edition=searcharticles&option=advanced",
        "&dateFrom=", from,
        "&dateTo=", to,
        "&lang=", language)

## String templates for output file names
general.file.template <- function(type, i, from, to=from, language="all") {
  date_block <- if(from == to) from else str_c(from, "--", to)
  file_name <- str_c(type, "-", language, "-", date_block, "-", i, ".csv.gz")
  fs::path(BASE_OUTPUT_PATH, file_name)
}

articles.file.template <- function(i, from, to=from, language="all")
  general.file.template("articles", i, from, to, language)

entities.file.template <- function(i, from, to=from, language="all")
  general.file.template("entities", i, from, to, language)

categories.file.template <- function(i, from, to=from, language="all")
  general.file.template("categories", i, from, to, language)

merged.file.template <- function(i, from, to=from, language="all")
  general.file.template("merged-articles", i, from, to, language)

## x %>% f  === f(x)
## x %>% f %>% g === g(f(x))

## Extract page count from document/DOM
get_page_count <- function(doc) {
  doc %>%
    html_node(xpath="//input[@name = 'page_count']") %>%
    html_attr("value") %>%
    as.numeric()
}

## Extract current page from documnet/DOM
get_current_page <- function(doc) {
  doc %>%
    html_node(xpath="//input[@name = 'current_page']") %>%
    html_attr("value") %>%
    as.numeric()
}

## Predicate that is TRUE If tags has (CSS) class cls
has_class <- function(tags, cls) {
  tags %>%
    html_attr("class") %>%
    str_detect(str_c("(^| )", cls, "( |$)"))
}

## Parses 'category' annotations in doc
parse_categories <- function(doc) {
  doc %>%
    html_nodes(xpath="./a[starts-with(@href, '/NewsBrief/alertedition')]") %>%
    html_attr("href") %>%
    str_match("/NewsBrief/alertedition/[a-zA-Z0-9]+/(.+)\\.html") %>%
    magrittr::extract(,2)
}

## Parses 'entity' annotations in doc
parse_entities <- function(doc) {
  entity.nodes <- doc %>%
    html_nodes(xpath="./a[starts-with(@href, '/NewsBrief/entityedition')]")

  entity.ids <- entity.nodes %>%
    html_attr("href") %>%
    str_match("/NewsBrief/entityedition/[a-zA-Z0-9]+/([0-9]+)\\.html") %>%
    magrittr::extract(,2) %>% ## [,2]
    as.integer()

  entity.names <- entity.nodes %>% html_text() %>%
    str_replace_all("$[^[:alpha:]]*", "") %>%
    str_replace_all("[^[:alpha:]]*$", "")

  tibble(id = entity.ids, name = entity.names)
}

normalise_string <- function(str)
  str_trim(str_replace_all(str, "\\s+", " "))

## Parses one search results page
parse_page <- function(doc, normalise_strings = FALSE) {
  article.nodes <- doc %>%
    html_nodes(xpath="/html/body/div[contains(@class, 'articlebox_big')]")

  is.duplicate <- article.nodes %>%
    has_class("duplicate_article")

  headline.links.nodes <- article.nodes %>%
    html_node(xpath="./p[contains(@class, 'center_story') and contains(@class, 'center_headline_top')]/a[contains(@class, 'headline_link')]")

  url <- headline.links.nodes %>%
    html_attr("href")
  url.language <- headline.links.nodes %>%
    html_attr("lang")

  headline.source.nodes <- article.nodes %>%
    html_node(xpath="./p[contains(@class, 'center_headline_source')]")

  source.country <- headline.source.nodes %>%
    html_node(xpath="./img[@alt='Source country']") %>%
    html_attr("src") %>%
    str_match("/NewsBrief/web/flags/small/([A-Z]+)\\.gif") %>%
    magrittr::extract(,2)

  source.name <- headline.source.nodes %>%
    html_node(xpath="./a[1]") %>%
    html_text()

  weekday.pattern <- "(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)"
  month.pattern <- "(January|February|March|April|May|June|July|August|September|October|November|December)"
  day.of.month.pattern <- "[0-9]{1,2}"
  year.pattern <- "(19|20)[0-9]{2}"
  date.pattern <- str_c(month.pattern, " ", day.of.month.pattern, ", ", year.pattern)
  time.pattern <- "1?[0-9]:[0-5][0-9]:[0-5][0-9] (A|P)M [A-Z]{1,6}"
  datetime.pattern <- str_c(weekday.pattern, ", ", date.pattern, " ", time.pattern)

  datetime.strings <- headline.source.nodes %>%
    html_text() %>%
    str_extract(datetime.pattern)

  datetime.no_timezone <- datetime.strings %>%
    parse_date_time(orders="A, B d, Y I:M:S p")

  datetime.timezones <- datetime.strings %>%
    str_extract("[A-Z]{1,6}$")

  if(VERBOSE) {
    print(datetime.timezones)
  }

  published <- force_tzs(datetime.no_timezone, datetime.timezones)
  original_timezone <- datetime.timezones

  leadin.nodes <- article.nodes %>%
    html_node(xpath="./p[contains(@class, 'center_leadin')]")

  leadin.language <- leadin.nodes %>%
    html_attr("lang")

  leadin <- leadin.nodes %>%
    html_text()

  more.nodes <- article.nodes %>%
    html_node(xpath="./div[contains(@class, 'alert_more')]")

  entity.lists <- more.nodes %>%
    html_node(xpath="./p[contains(@class, 'center_also') and starts-with(., 'Entities:')]") %>%
    map(parse_entities)

  category.lists <- more.nodes %>%
    html_node(xpath="./p[contains(@class, 'center_also') and starts-with(., 'Other categories:')]") %>%
    map(parse_categories)

  articles <- tibble(source.name, source.country, is.duplicate, url,
                     url.language, published, original_timezone, leadin,
                     leadin.language)

  entities <- tibble(url = url, entity = entity.lists) %>%
    unnest(one_of("entity"))

  categories <- tibble(url = url, category = category.lists) %>%
    unnest(one_of("category"))

  if(normalise_strings) {
    articles   <-   articles %>% mutate_if(is.character, normalise_string)
    entities   <-   entities %>% mutate_if(is.character, normalise_string)
    categories <- categories %>% mutate_if(is.character, normalise_string)
  }

  list(articles=articles, entities=entities, categories=categories)
}

## Write results to file
dump_parsed <- function(i, parse_results, merged=FALSE, appended=FALSE) {
  if(appended) {
    i <- "all"
  }
  if(!merged) {
    articles.file   <-   articles.file.template(i, DATE, language=LANGUAGE)
    entities.file   <-   entities.file.template(i, DATE, language=LANGUAGE)
    categories.file <- categories.file.template(i, DATE, language=LANGUAGE)
    articles.exists   <-   file.exists(articles.file)
    entities.exists   <-   file.exists(entities.file)
    categories.exists <- file.exists(categories.file)
    write_csv(parse_results$articles, articles.file,
              col_names=!(appended & articles.exists),
              append=appended)
    write_csv(parse_results$entities, entities.file,
              col_names=!(appended & entities.exists),
              append=appended)
    write_csv(parse_results$categories, categories.file,
              col_names=!(appended & categories.exists),
              append=appended)
  } else {
    merged.file <- merged.file.template(i, DATE, language=LANGUAGE)
    already.exists <- file.exists(merged.file)
    collapsed.entities <- parse_results$entities %>%
      group_by(url) %>%
      summarise(entity_ids = str_c(id, collapse = ";"),
                entity_names= str_c(name, collapse=";"), .groups="drop_last")
    collapsed.categories <- parse_results$categories %>%
      group_by(url) %>%
      summarise(categories = str_c(category, collapse=";"), .groups="drop_last")
    parse_results$articles %>%
      left_join(collapsed.entities, by="url") %>%
      left_join(collapsed.categories, by="url") %>%
      write_csv(merged.file, col_names = !(appended & already.exists),
                append=appended)
  }
}

read_html_retry <- function(..., max_retries=10, wait_time=2, wait_increment=2) {
  page <- NA
  while(is.na(page) & max_retries > 0) {
    page <- tryCatch(
      expr={
        read_html(emm.url.template(1, DATE, language=LANGUAGE))
      },
      error=function(e) {
        warning(e)
        warning(str_c("Retries remaining: ", max_retries))
        max_retries <<- max_retries - 1
        Sys.sleep(wait_time)
        wait_time <<- wait_time + wait_increment
        NA
      })
  }
  if(!is.na(page))
    page
  else
    stop("Failed after max_retries")
}

page <- read_html_retry(emm.url.template(1, DATE, language=LANGUAGE))

## Theory:
## page_count ==  0 if no search results
## page_count == -1 if more pages available
## page_count == -2 if on last page
## page_count == -3 if past last page
page_count <- get_page_count(page)
curr_page <- get_current_page(page)

max_page_count <- Inf

if(page_count != 0) {
  if(VERBOSE) {
    print(curr_page)
  }
  dump_parsed(curr_page,
              parse_page(page, normalise_strings=TRUE),
              merged=TRUE,
              appended=TRUE)
} else {
  warning("No search results!")
}

while(page_count == -1 && curr_page <= max_page_count) {
  page <- read_html_retry(emm.url.template(curr_page + 1, DATE, language=LANGUAGE))
  if(VERBOSE) {
    print(curr_page + 1)
  }
  page_count <- get_page_count(page)
  curr_page  <- get_current_page(page)
  ##
  if(page_count > -3) {
    dump_parsed(curr_page,
                parse_page(page, normalise_strings=TRUE),
                merged=TRUE,
                appended=TRUE)
  }
}

