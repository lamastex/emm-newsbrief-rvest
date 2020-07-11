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

argv <- commandArgs(trailingOnly = TRUE)

if(length(argv) != 3) {
  stop("Usage: RScript get_url.R DATE LANGUAGE PAGE")
}

DATE <- argv[1] # "2020-05-01"
LANGUAGE <- argv[2] # "sv"
PAGE <- argv[3] # "/tmp"

## String template for search results URL
emm.url.template <- function(i, from, to=from, language="all", page.language="en")
  str_c("https://emm.newsbrief.eu/NewsBrief/dynamic",
        "?language=", page.language,
        "&page=", i,
        "&edition=searcharticles&option=advanced",
        "&dateFrom=", from,
        "&dateTo=", to,
        "&lang=", language)

print(emm.url.template(PAGE, DATE, DATE, LANGUAGE))

