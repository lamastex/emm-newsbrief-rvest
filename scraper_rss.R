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

library(magrittr)
library(tidyverse)
library(rvest)
library(fs)

LANGUAGE  <- "en"
COUNTRY   <- "US"
DATE_FROM <- URLencode("2020-05-05T11:59:00Z")
DATE_TO   <- URLencode("2020-05-05T11:59:59Z")

rss <- read_xml(str_c("https://emm.newsbrief.eu/rss/rss",
                      "?language=", LANGUAGE,
                      "&type=search&mode=advanced",
                      "&dateto=", DATE_TO,
                      "&country=", COUNTRY,
                      "&datefrom=", DATE_FROM))

rss.channel <- rss %>% xml_node(xpath="/rss/channel")

rss.title       <- rss.channel %>% xml_node(xpath="./title")       %>% xml_text()
rss.url         <- rss.channel %>% xml_node(xpath="./link")        %>% xml_text()
rss.description <- rss.channel %>% xml_node(xpath="./description") %>% xml_text()

rss.item.nodes  <- rss.channel %>% xml_nodes(xpath="./item")

get_text <- function(field)
  rss.item.nodes %>% xml_node(xpath=str_c("./", field)) %>% xml_text()

get_attr <- function(field, attr)
  rss.item.nodes %>% xml_node(xpath=str_c("./", field)) %>% xml_attr(attr),

items <- tibble(title             = get_text("title"),
                link              = get_text("link"),
                description       = get_text("description"),
                pubDate           = get_text("pubDate"),
                guid              = get_text("guid"),
                isPermaLink       = get_attr("guid",          "isPermaLink"),
                source.text       = get_text("source"),
                source.url        = get_attr("source",        "url"),
                language          = get_text("iso:language"),
                point             = get_text("georss:point"),
                bns.text          = get_text("emm:bns"),
                bns.level         = get_attr("emm:bns",       "level"),
                title_trans       = get_text("emm:title"),
                description_trans = get_text("emm:description"))

parse_entities <- function(node) {
  entity.nodes <- node %>%
    xml_nodes(xpath="./emm:entity")
  tibble(  id = entity.nodes %>% xml_attr("id") %>% as.integer(),
         name = entity.nodes %>% xml_attr("name"),
         text = entity.nodes %>% xml_text())
}

parse_categories <- function(node) {
  node %>%
    xml_nodes(xpath="./category") %>%
    xml_text() %>%
    enframe(NULL, "category")
}

entities <-
  tibble(guid = items$guid,
         entities = map(rss.item.nodes, parse_entities)) %>%
  unnest(entities)

categories <-
  tibble(guid = items$guid,
         categories = map(rss.item.nodes, parse_categories)) %>%
  unnest(categories)
