### UI ###
ui = navbarPage(title = strong("Eras: Taylor Swift"), inverse = T, 
                
                # First Panel - Introduction
                tabPanel(title = strong("Introduction"), 
                         includeCSS("www/styles.css"),
                         setBackgroundImage(src = "folkloreClearer.png"),
                         fluidPage(h2(strong("Eras: Taylor Swift - An Analysis of Taylor Swift's Discography")), 
                                   div(p("Taylor Swift is perhaps the largest pop sensation of the 2000s, and deservedly so - her music, split across 10 studio albums and 2 re-recordings, is infused with lasting melodies and thoughtful lyricism that has amassed her a colossal fanbase."), 
                                       p("Here, I offer you an opportunity to delve into the intricacies of Taylor's discography."),
                                       p(em("Baby, let the games begin.")), 
                                       style = "font-size: 16px; font-weight: bold"),
                                   br(),
                                   # Image carousel
                                   bs_carousel(id = "carousel", use_indicators = T, use_controls = F) %>%
                                     bs_append(
                                       content = bs_carousel_image(src = "speakNowImage.png"), 
                                       caption = bs_carousel_caption("Taylor Swift performing during the Speak Now World Tour in support of her 3rd studio album", "2011 - 2012")
                                     ) %>%
                                     bs_append(
                                       content = bs_carousel_image(src = "1989Image.jpg"), 
                                       caption = bs_carousel_caption("Swift performing during the 1989 World Tour in support of her 5th studio album, which marked her leap from country to pop music", "2015")
                                     ) %>%
                                     bs_append(
                                       content = bs_carousel_image(src = "repImage.png"), 
                                       caption = bs_carousel_caption("Swift at the Reputation Stadium Tour, which, according to Wikipedia, grossed $345.7 million", "2018")
                                     ) %>%
                                     bs_append(
                                       content = bs_carousel_image(src = "redTVImage.jpg"), 
                                       caption = bs_carousel_caption("Swift performing All Too Well (10 Minute Version) on Saturday Night Live in promotion of her re-recording of Red, her 4th studio album", "2021")
                                     ) %>%
                                     bs_append(
                                       content = bs_carousel_image(src = "carpetImage.jpg"), 
                                       caption = bs_carousel_caption("Swift attending the 2022 Toronto International Film Festival following the release of her 10th studio album, Midnights", "2022")), 
                                   br(),
                                   br(), 
                                   # Footnotes
                                   div(h4(strong("For those interested...")), 
                                       p("This web application was built by ", 
                                         a("jasminex21", href = "https://github.com/jasminex21"), 
                                         " using RStudio and R Shiny; its GitHub repository can be accessed ", 
                                         a("here", href = "https://github.com/jasminex21/eRasTaylorSwift")), 
                                       p("This project was strongly inspired by ", 
                                         a("this application", href = "https://committedtotape.shinyapps.io/sixtyninelovesongs/?_ga=2.108168962.164154063.1672129800-441156535.1662990872"), 
                                         " by ", 
                                         a("committedtotape", href = "https://twitter.com/committedtotape")), 
                                       p("Track audio features were obtained from ", 
                                         a("the Spotify API", href = "https://developer.spotify.com/documentation/web-api/reference/#/operations/get-audio-features")),
                                       p("Track lyrics were compiled by the R package ",
                                         a("taylor", href = "https://cran.rstudio.com/web/packages/taylor/index.html"), 
                                         " via ", 
                                         a("Genius", href = "https://genius.com")),
                                       style = "text-align: right;")
                         )), 
                
                # Second Panel - Audio Features
                tabPanel(title = strong("Album Audio Features"), 
                         fluidPage(h3(strong("Let's take a look at the audio features of Taylor's albums...")),
                                   br(),
                                   sidebarLayout(
                                     sidebarPanel(selectInput("audioFeature", 
                                                              label = "Select an audio feature", 
                                                              choices = c('Valence' = "valence", 
                                                                          "Energy" = "energy", 
                                                                          "Danceability" = "danceability")), 
                                                  hr(),
                                                  h4(strong("Info")), 
                                                  textOutput("featureDescription"),
                                                  hr(),
                                                  dataTableOutput("featureTable")
                                     ), 
                                     mainPanel(
                                       wellPanel(withLoader(plotOutput("featurePlot", height = "600px"), 
                                                            type = "image", 
                                                            loader = "tayLoading.gif"), 
                                                 hr(), 
                                                 h4(strong("Note")), 
                                                 textOutput("featureCommentary"))
                                     )
                                   ))),
                # Third Panel - Word Counts
                tabPanel(title = strong("Word Counts"), 
                         fluidPage(h3(strong("What are Taylor's most-used words in each album?")), 
                                   br(),
                                   sidebarLayout(
                                     sidebarPanel(selectInput("cloudAlbum",
                                                              label = "Select album", 
                                                              choices = albums, 
                                                              selected = "Speak Now"),
                                                  hr(),
                                                  dataTableOutput("countTable")
                                     ), 
                                     mainPanel(
                                       br(),
                                       wellPanel(wordcloud2Output("wordCloud", 
                                                                  height = "560px", 
                                                                  width = "1120px")))
                                   ))),
                # Fifth Panel - Lexical Diversity
                tabPanel(title = strong("Lexical Diversity"), 
                         fluidPage(h3(strong("How diverse is Taylor's lyricism in each album?")),
                                   br(), 
                                   sidebarLayout(
                                     sidebarPanel(h4(strong("Info")), 
                                                  div(p("Lexical diversity is defined as the ratio of unique words to the total number of words in a song. This makes it useful as a rough measure of the repetitiveness (or lack thereof) of a song."), 
                                                      p("By this definition, tracks with a higher lexical diversity are less repetitive and contain a larger proportion of unique words, whereas tracks with a low lexical diversity are more repetitive."), 
                                                      style = "font-size: 16px;"),
                                                  hr(),
                                                  dataTableOutput("lexDiversityAlbum"),
                                                  hr(), 
                                                  dataTableOutput("lexDiversitySong")
                                     ),
                                     mainPanel(
                                       br(),
                                       wellPanel(withLoader(plotOutput("lexDiversity", 
                                                                       height = "700px"), 
                                                            type = "image", 
                                                            loader = "tayLoading.gif"), 
                                                 hr(), 
                                                 h4(strong("Lexically diverse vs not lexically diverse: can you see the difference?")), 
                                                 br(),
                                                 div(fluidRow(
                                                   column(width = 6, 
                                                          p(strong(em("champagne problems"), ": Taylor's most lyrically complex song")),
                                                          HTML(paste(champagneLyrics, collapse = "<br/>"))
                                                   ), 
                                                   column(width = 6, 
                                                          p(strong(em("Out of the Woods"), ": Taylor's most repetitive song")), 
                                                          HTML(paste(woodsLyrics, collapse = "<br/>"))
                                                   )
                                                 ), 
                                                 br(),
                                                 fluidRow(
                                                   column(width = 6, 
                                                          h5(strong("Fun Fact")), 
                                                          p(em("champagne problems"), ' contains 165 unique words (out of 286 total words), with the most-repeated word being "your," which Taylor sang 16 times.')), 
                                                   column(width = 6, 
                                                          h5(strong("Fun Fact")), 
                                                          p('Taylor repeats "out of the woods" and "in the clear" 38 and 36 times, respectively, throughout the song.'),
                                                          p(em("Out of the Woods"), 
                                                            " involves 103 unique words out of the 660 total words in the song."))
                                                 ),
                                                 style = "font-size: 16px;")))))),
                # Fourth Panel - Random Lyric(s) Generator
                tabPanel(title = strong("Random Lyrics Generator"), 
                         fluidPage(h3(strong("Click the button (as many times as you'd like), you'll get something good every time ;)")),
                                   br(),
                                   sidebarLayout(
                                     sidebarPanel(
                                       radioButtons("numOfLines", 
                                                    label = "Select the number of lines you would like to generate", 
                                                    choices = c("One line" = 1, 
                                                                "Two lines" = 2, 
                                                                "Entire section" = 3), 
                                                    selected = 1), 
                                       actionButton("button", 
                                                    label = "Generate")),
                                     mainPanel(
                                       wellPanel(
                                         htmlOutput("randGenerated")))
                                   )))
)
