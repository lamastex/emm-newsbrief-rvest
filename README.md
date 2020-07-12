# emm-newsbreif-rvest

WIP rvest-based scraper for the [EMM newsbrief](https://emm.newsbrief.eu/NewsBrief/).

## To build docker

```
docker build -t lamastex/r-base-rvest:latest .
docker run --rm -it --name=emm-rvest --mount type=bind,source=${PWD},destination=/root/rvest lamastex/r-base-rvest
```

## Scrape news briefs

To scrape news articles in Swedish language press for one day into `/tmp` dir do:
```
root@e6a37cc8dd35:~/rvest# Rscript scraper_articles.R 2020-07-10 sv /tmp
```

For example:

```
root@e6a37cc8dd35:~/rvest# zcat /tmp/articles-sv-2020-07-10-200.csv.gz | head
source.name,source.country,is.duplicate,url,url.language,leadin,leadin.language
skatter,SE,FALSE,https://www.skatter.se/?q=node/87,sv,"När någon lånar ut pengar vill han gärna ha någon säkerhet, t.ex. kan han vilja ha en lös sak i pant hos sig. Så gör alla s.k. pantbanker. Vill Du ha lån där kan Du lämna in något värdefullt föremål såsom en ring eller en klocka som pant och få ett litet lån. Panten återlämnas när lånet betalts....",sv
familjeliv,SE,FALSE,https://www.familjeliv.se/forum/thread/80514111-ar-det-kort-om-man-inte-kommit-nagonvart-vid-40,sv,"Har alltid velat ha en karriär och ok lön. Har bra utbildning och har jobbat hårt och gjort bra ifrån mig. Har av olika anledningar aldrig kommit någonvart, är väl frånvaro av vassa armbågar. Nu har jag tröttnat på att aldrig bli befordrad och trots hundratals sökta jobb får jag inte heller napp....",sv
dagensopinion,SE,FALSE,https://dagensopinion.se/artikel/foretagens-anseende-volvo-tar-in-pa-ikea-bankerna-och-tre-i-botten/,sv,"Teleoperatören Tre och bankerna hamnar i botten och biltillverkarna i toppen på Kantar Sifos undersökning av företags anseende. I toppen knappar Volvo AB in på Ikea. Ikea ökar från 76 till 80 i anseende under 2020. Men Volvo AB, som tillverkar lastbilar, ökar ännu mer, från 73 till 78....",sv
Sydsvenskan,SE,FALSE,https://www.sydsvenskan.se/2020-07-09/pogba-malskytt-igen-efter-15-manader,sv,"Vi använder cookies för att förbättra funktionaliteten på våra sajter, för att kunna rikta relevant innehåll och annonser till dig och för att vi ska kunna säkerställa att tjänsterna fungerar som de ska.

Få notiser direkt i webbläsaren! Med våra nyhetsnotiser får du senaste nytt om ämnen som du följer....",sv
```

To get the URL for a specific page of a specific day to manually verify, do:
```
root@e6a37cc8dd35:~/rvest# Rscript get_url.R 2020-07-10 sv 140
[1] "https://emm.newsbrief.eu/NewsBrief/dynamic?language=en&page=140&edition=searcharticles&option=advanced&dateFrom=2020-07-10&dateTo=2020-07-10&lang=sv"

```

NOTE: Unfortunately, the scraping only works for a few days into the past from now!
