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

To scrape for all languages do:

```
root@e6a37cc8dd35:~/rvest# Rscript scraper_articles.R 2020-07-10 sv /tmp
```
A sample output for all languages for a specific day is:

```
source.name,source.country,is.duplicate,url,url.language,published,original_timezone,leadin,leadin.language,entity_ids,entity_names,categories


mediafax,RO,FALSE,https://www.mediafax.ro/externe/sua-in-prag-de-razboi-civil-protestele-violente-continua-in-numeraose-orase-din-tara-19211936?utm_source=feedburner&utm_medium=feed&utm_campaign=Feed%3A+mediafax%2FQddx+%28Mediafax_ALL%29,ro,2020-05-30T23:59:00Z,CEST,"Proteste violente au loc în zeci de oraşe din Stat
ele Unite faţă de moartea unui bărbat de culoare în timp ce era imobilizat brutal de agenţi de poliţie din Minneapolis, Minnesota, relatează CNN.

efe-agencia,ES,FALSE,https://www.efe.com/efe/espana/politica/el-pnv-votara-a-favor-de-la-prorroga-del-estado-alarma/10002-4259378?utm_source=wwwefecom&utm_medium=rss&utm_campaign=rss,es,2020-05-30T23:59:00Z,CEST,"El Partido Nacionalista Vasco (PNV) votará a favor de la sexta prórroga del estado de alarma que el Gobie
rno planteará el próximo miércoles en el Congreso de los Diputados, según el acuerdo suscrito este sábado con el Ejecutivo. En dicho acuerdo se establece que la autoridad competente delegada para.......",es,189921;178120;69140;695;2054755;1407,Aitor Esteban;Pedro Sanchez;Andoni Ortuzar;Carmen Calvo;José Antonio Monti
lla;Josu Erkoreka,PublicHealth;CoronavirusInfection;CommunicableDiseases;EU-LatinAmerica
efe-agencia,ES,FALSE,https://www.efe.com/efe/espana/politica/jxcat-carga-contra-el-acuerdo-de-erc-porque-es-insuficiente-para-cataluna/10002-4259377?utm_source=wwwefecom&utm_medium=rss&utm_campaign=rss,es,2020-05-30T23:59:00Z,CEST,"La portavoz de JxCat en el Congreso, Laura Borràs, ha cargado hoy contra el acuerdo al
 que ha llegado ERC con el Gobierno para abstenerse en la votación de la prórroga del estado de alarma, ya que este pacto ""mantiene la subordinación a Madrid"" y las contraprestaciones logradas son ""claramente insuficientes para Cataluña""....",es,2082969,Laura Borras,CommunicableDiseases;CoronavirusInfection
lagaceta,AR,FALSE,https://www.lagaceta.com.ar/nota/846045/actualidad/segun-siprosa-hubo-un-error-no-se-reportaron-nuevos-casos-coronavirus-tucuman.html,es,2020-05-30T23:59:00Z,CEST,"PANDEMIA. Siguen aumentando los casos de coronavirus. FOTO LA GACETA/INÉS QUINTEROS ORIO




topics,JP,FALSE,https://www.topics.or.jp/articles/-/369152,ja,2020-05-30T23:59:00Z,CEST,"前市長の辞職に伴う小松島市長選が３１日、告示された。午前８時半の立候補の受け付け開始と同時に、いずれも無所属新人で、前副市長の孫田勤氏（６３）＝大林町宮ノ本＝と、元県議の中山俊雄氏（５６）＝横須町、建設会社役員＝の２人が届け出た
選挙戦は７年ぶり。他に立候補の動きはなく、両氏の一騎打ちとなる公算が高い。 投開票日は７日。期日前投票は１～６日の午前８時半～午後８時に市役所１階ロビーで。 ３０日時点の有権者数は３万２４０９人（男１万５６３８人、女１万６７７１人）。
nuevaya,NI,FALSE,https://nuevaya.com.ni/piloto-demuestra-el-amor-a-su-madrecita-lanzando-desde-los-aires-flores-en-carazo/,es,2020-05-30T23:59:00Z,CEST,"Demostrando el enorme amor a su madre el experimentado piloto Walter Mora sobrevoló este sábado los cielos en el municipio de Diriamba, en el departamento de Carazo
y la sorprendió lanzando flores en su casa de habitación


...
...
...

cronista,AR,FALSE,https://www.cronista.com/contenidos/2020/05/30/noticia_0016.html,es,2020-05-30T23:57:00Z,CEST,". El ministro de Economía, Martín Guzmán, confirmó desde su cuenta en Twitter que se volverá a pagar el Ingreso Familiar de Emergencia (IFE) que -aseguró- evitó que entre 2,7 y 4,5 millones de personas caigan en la pobreza por la pandemia de coronavirus....",es,1690410;126159;2385339,Martin Guzman;Paul Hewson;Santiago Cafiero,CoronavirusInfection;CommunicableDiseases
losandes,AR,FALSE,https://www.losandes.com.ar/article/view?slug=pronostico-del-tiempo-domingo-parcialmente-nublado-con-ascenso-de-temperatura,es,2020-05-30T23:56:00Z,CEST,"La máxima llegará hasta los 14 grados, mientras que el lunes continuará el ascenso de temperatura hasta los 16°C.

losandes,AR,FALSE,https://www.losandes.com.ar/article/view?slug=hubo-marchas-y-protestas-en-buenos-aires-contra-el-aislamiento-obligatorio,es,2020-05-30T23:56:00Z,CEST,"Casi un millar de personas protestaron este sábado Buenos Aires contra la cuarentena obligatoria que rige desde el 20 de marzo para frenar la propagación del coronavirus. Con banderas argentinas y sin cumplir con el distanciamiento social obligatorio, los manifestantes reclamaron el final de la.......",es,3116;2274301,Alberto Fernandez;Raul Aragon,CoronavirusInfection;CommunicableDiseases
losandes,AR,FALSE,https://www.losandes.com.ar/article/view?slug=un-dia-como-hoy-river-gano-su-tercera-recopa-y-gallardo-se-convirtio-en-el-dt-mas-ganador,es,2020-05-30T23:56:00Z,CEST,"El Millonario venció por 3-0 al Athetico Paranaense en el Monumental, levantó otro copa internacional y el Muñeco superó a Ramón Díaz.

wnp,PL,FALSE,"https://www.wnp.pl/rynki-zagraniczne/usa-trump-potepil-zamieszki-po-smierci-floyda,397691.html",pl,2020-05-30T23:56:00Z,CEST,"Prezydent Donald Trump ostro potępił w sobotę - jako ""dzieło rabusiów i anarchistów"" - zamieszki w amerykańskich miastach, które wybuchły po zabiciu w Minneapolis przez policję Afroamerykanina George'a Floyda.

tiemposur,AR,FALSE,https://www.tiemposur.com.ar/nota/record-de-contagios-795-pacientes-nuevos,es,2020-05-30T23:56:00Z,CEST,"Coronavirus Record de contagios: 795 pacientes nuevos. El ministerio de Salud confirmó ocho nuevos decesos por COVID-19 en el país. 30/05/2020 • 20:40.

gelrenieuws,NL,FALSE,https://www.gelrenieuws.nl/2020/05/man-belandt-met-fiets-in-greppel-tussen-huissen-en-arnhem.html,nl,2020-05-30T23:56:00Z,CEST,"Geplaatst op 31 mei 2020 01:48 | Laatst bijgewerkt op 31 mei 2020 01:51. HUISSEN/ARNHEM – In de nacht van zaterdag op zondag is een fietser in een greppel belandt aan het Exoduspad in Huissen. Volgens de hulpdiensten leek het op een sloot.

sipse,MX,FALSE,https://sipse.com/mexico/amlo-presidente-palenque-emergencia-sanitaria-coronavirus-covid-sat-adeudos-empresas-economia-caida-global-367034.html,es,2020-05-30T23:56:00Z,CEST,"Ciudad de México.- Al reactivar sus giras, el Presidente Andrés Manuel López Obrador agradeció a las empresas que han aceptado pagar sin litigio sus adeudos al SAT y aseguró que la economía mexicana se está recuperando a pesar de los efectos de la pandemia del Covid-19 porque “no nos agarró mal parados”....",es,2299360;293025;6863,Tren Maya;Andres Manuel;Andres Manuel Lopez Obrador,PublicHealth;CoronavirusInfection;WorldEconomy

LaTercera,CL,FALSE,https://www.latercera.com/la-tercera-domingo/noticia/zoom-a-los-femicidios-en-pandemia-cinco-rostros-de-la-violencia-de-genero-en-confinamiento/6AMOGT63T5ERXEDCFDI43PMIMY/,es,2020-05-30T23:56:00Z,CEST,"La imagen muestra a una mujer sentada junto a una figura que representa a la muerte. Adentro se lee la siguiente frase: “Ella no quería un cuento feliz, ella quería ser feliz sin tanto cuento”. Maribel Mallea Quinzacara colgó esta escena en su muro de Facebook el 7 de enero de 2018....",es,2553630;2402825;423609,Juan Carlos Muñoz;Medico Legal;Diego de Almagro,PublicHealth;CoronavirusInfection;CommunicableDiseases
LaTercera,CL,FALSE,https://www.latercera.com/pulso/noticia/el-60-de-ejecutivos-proyecta-que-crisis-durara-hasta-2021/EFPAGPNBR5A63NMOPYSO2TGWIM/,es,2020-05-30T23:56:00Z,CEST,"25 de Mayo 2020 Imagenes de preparativos y traslado de pacientes graves con Coronavirus Covid 19, pandemia que afecta al pais, por personal de la Fuerza aerea de Chile (Fach) y de ambulancias del Samu. Los contagiados fueron llevados desde el Grupo 10 del aeropuerto de Santiago a la ciudad de Puerto Montt....",es,285399,Andres Perez,PublicHealth;CoronavirusInfection;CommunicableDiseases
LaTercera,CL,TRUE,https://www.latercera.com/mundo/noticia/brasil-se-convierte-en-cuarto-pais-con-mas-fallecidos-por-covid-19-del-mundo-tras-superar-a-francia/XK3QKFCYSZCKDP4KXLDLWWPL4A/,es,2020-05-30T23:56:00Z,CEST,"Este sábado, Brasil se convirtió en el cuarto país con más muertos por el coronavirus al registrar 28.834 fallecidos, con lo que desplazó a Francia (28.771), según informó el ministerio de Salud de ese país. En el gigante sudamericano de 210 millones de habitantes, los contagios aumentaron en 33....",es,175162,Jair Bolsonaro,PublicHealth;CoronavirusInfection;CommunicableDiseases
journalducameroun,CM,TRUE,https://www.journalducameroun.com/initiative-coronavirus-global-response-le-maroc-contribue-a-hauteur-de-3-millions-deuros/,fr,2020-05-30T23:55:00Z,CEST,"Le ministère marocain de l’Education nationale, de la Formation professionnelle, de l’Enseignement supérieur et de la Recherche scientifique a contribué à hauteur de 3 millions d’euros à l’initiative mondiale « Coronavirus Global Response », selon un communiqué du ministère, parvenu à APA....",fr,16930,Ursula von der Leyen,PublicHealth;CoronavirusInfection;EIB;UrsulavonderLeyen;Science;ECnews;CommunicableDiseases;EU-Africa
syd,CN,FALSE,http://news.syd.com.cn/system/2020/05/31/011829051.shtml,zh,2020-05-30T23:55:00Z,CEST,"5月29日，和平区在沈水湾街道安泰社区举办2020年沈阳市文明家庭宣讲会。 全国五好文明家庭标兵、辽宁省道德模范、原沈阳军区后勤史馆馆长徐文涛在宣讲会上作主题宣讲，与参加活动的居民一起分享了从家庭亲情、家庭美德、优良家风和家庭价值观教育等方面促进家庭文明建设的经验，号召大家以自身带动家人、
以家庭带动邻里、以社区带动社会，积极参与文明创建。(吕良德)
syd,CN,FALSE,http://news.syd.com.cn/system/2020/05/31/011829052.shtml,zh,2020-05-30T23:55:00Z,CEST,"年近八旬的肇凤枝老人每天在路上“走走停停”，发现路边一处公厕指示牌扭转了方向，就拍下照片并传到微信工作群中，问题很快通过区文明办反馈到主管部门，当天该指示牌就被纠正了过来。 肇凤枝是铁西区城市文明巡访员之一，在日常工作生
活中随时发现问题并反馈，相关部门随即进行整改。(叶青)
syd,CN,FALSE,http://news.syd.com.cn/system/2020/05/31/011829053.shtml,zh,2020-05-30T23:55:00Z,CEST,"5月29日，记者从市残联获悉，皇姑区残联在职党员来到明廉街道明南社区，与社区干部和志愿者携手进行“擦亮自家门，摆好门前车”志愿服务活动。 活动中，党员同志积极宣传“门前三包”责任，引导广大驻区单位、商户、家庭从擦亮自家门，摆好门前车这样的小事做起，通过举手之劳，人人为提升市容环境贡献力量。
(封葑)
syd,CN,FALSE,http://news.syd.com.cn/system/2020/05/31/011829057.shtml,zh,2020-05-30T23:55:00Z,CEST,"本报讯(沈阳日报、沈报全媒体记者刘国栋)在六一国际儿童节来临之际，由辽宁九一八历史研究中心、中国《侨园》杂志社和《国歌的故事——义勇军进行曲的由来》的作者共同合作，将《国歌的故事——义勇军进行曲的由来》音乐绘本翻译成繁体字版、声音文件重新进行粤语配音并制作成动画，奉献给香港小朋友，作为儿
童节的特别礼物。
syd,CN,TRUE,http://news.syd.com.cn/system/2020/05/31/011829065.shtml,zh,2020-05-30T23:55:00Z,CEST,"比利时《布鲁塞尔时报》当地时间30日报道， 比利时约阿希姆王子近日在西班牙参加了一个私人聚会之后，其新冠病毒检测结果呈阳性。 现年28岁的约阿希姆王子是比利时阿斯特里德公主最小的儿子，同时是比利时国王菲利普的侄子。报道称，该
聚会举行地为西班牙南部城市科尔多瓦，共有27人参加聚会，违反了“禁足令”。当前，西班牙禁止15人以上的私人聚会。西班牙警方将对所有聚会参与人员进行调查，并要求所有人进行自我隔离。报道指出，约阿希姆王子于5月24日从比利时前往西班牙，他出行的理由为前往科尔多瓦的一家公司实习，属于与工作相关的正当理由，符合比利时疫情期间对于出行
的相关规定。
syd,CN,FALSE,http://news.syd.com.cn/system/2020/05/31/011829064.shtml,zh,2020-05-30T23:55:00Z,CEST,"美国约翰斯·霍普金斯大学30日发布的新冠疫情最新统计数据显示，全球累计确诊病例超过600万例。 数据显示，截至美国东部时间30日16时32分(北京时间31日4时32分)，全球累计确诊病例达到6003762例，死亡病例为367356例。 数据显示，美国是疫情最严重的国家，累计确诊病例1764671例，累计死亡病例103605例。>累计确诊病例超过20万例的国家还有巴西、俄罗斯、英国、西班牙和意大利。此外，法国、德国、印度和土耳其的累计确诊病例均超过15万例。 这些数据来自约翰斯·霍普金斯大学新冠病毒研究项目实时汇总的各个国家和地区数据。
elpais-CO,CO,FALSE,https://www.elpais.com.co/mundo/charly-garcia-fue-hospitalizado-en-buenos-aires-tras-presentar-un-cuadro-febril.html,es,2020-05-30T23:55:00Z,CEST,"El músico argentino Charly García fue hospitalizado este sábado en una clínica de Buenos Aires con un cuadro febril aunque un primer estudio descartó que padezca coronavirus, según cita la prensa local. El autor de ""Demoliendo hoteles"" y ""Los dinosaurios"", de 68 años, permanece hospitalizado en el.......",es,163412;264313,Charly Garcia;Carmen Moreno,PublicHealth;CoronavirusInfection;CommunicableDiseases
izvestia-ru,RU,FALSE,https://iz.ru/1017826/2020-05-31/ukraine-napomnili-o-ee-iskonnykh-territoriiakh,ru,2020-05-30T23:55:00Z,CEST,"Бывший премьер Украины Николай Азаров и российский сенатор Алексей Пушков напомнили украинским националистам о исконных территориях их страны.

izvestia-ru,RU,FALSE,https://iz.ru/1017828/2020-05-31/tramp-rasskazal-o-budushchem-kosmicheskoi-otrasli-posle-puska-crew-dragon,ru,2020-05-30T23:55:00Z,CEST,"Президент США Дональд Трамп, комментируя первый за девять лет запуск американского пилотируемого корабля Crew Dragon в космос, заявил, что сбылась мечта основателя компании-разработчика SpaceX Илона Маска.

jewishlifenews,IL,FALSE,https://jewishlifenews.com/uncategorized/the-economic-impact-of-coronavirus-on-naphthalene-water-reducers-market-2019-analysis-by-industry-trends-size-share-company-overview-growth-development-and-forecast-by-2024/,af,2020-05-30T23:55:00Z,CEST,Companies in the Naphthalene Water Reducers market are vying suggestive steps to tackle the challenges resulting from the COVID-19 (Coronavirus) pandemic. Exhaustive research about COVID-19 is providing present-day techniques and alternative methods to mitigate the impact on Coronavirus on the revenue of the Naphthalene Water Reducers market....,af,2501551,User Analysis,PublicHealth;CoronavirusInfection;CommunicableDiseases

```
NOTE: Unfortunately, the scraping only works for a few days into the past from now!
