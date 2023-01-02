library(ggplot2)
library(ggridges)
library(tidyverse)
library(shiny)
library(dplyr)
library(lubridate)
library(ggjoy)
library(knitr)
library(DT)
library(shinycustomloader)
library(htmltools)
library(bsplus)
library(shinyWidgets)
library(tayloRswift)
library(wordcloud2)
library(tm)
library(SnowballC)
library(yarrr)
library(shape)
library(tidytext)

# CSV file created by taylorData.R
taylor = read_csv("taylorRevised.csv")
# CSV file created by lyrics.R
allLyrics = read_csv("allTaylorLyrics.csv")

albums = unique(taylor$album_name)
album_colors = c("#00A3AD", # Debut
                 "#F6ED95", # Fearless
                 "#8449BB", # Speak Now
                 "#841E10", # Red
                 "#B8BFE2", # 1989
                 "#727272", # reputation
                 "#fdcdcd", # Lover
                 "#BABABA", # folklore
                 "#994914", # evermore
                 "#C3B377", # Fearless TV
                 "#731D05", # Red TV
                 "#526D85") # Midnights

# Palettes from tayloRswift::swift_palettes:
# Made slight changes to make wordclouds more visually appealing
palettes = swift_palettes
palettes$midnights = c("#586891", "#8897A4", "#B3A6A3", "#2B152C", "#F1F3F2")
palettes$taylor1989[1] = "#9BB8D8"
palettes$speakNow = c(palettes$speakNow[-1], palettes$speakNow[1])
palettes$speakNow[1] = "#883689"
palettes$Red[1] = "#782B2B"
palettes$reputation = c(palettes$reputation[-1], palettes$reputation[1])

# Definitions and annotations for features in Panel 2
annotations = tibble(feature = c("valence", 
                                 "energy", 
                                 "danceability"), 
                     description = c('Valence is defined by Spotify to be a measure between 0.0 and 1.0 that conveys the "positiveness" of a track. Tracks with a higher valence (e.g. 0.85) sound more positive, while tracks with a lower (e.g. 0.25) valence sound moodier.', 
                                     'Energy is defined by Spotify to be a measure between 0.0 and 1.0 that serves as a "perceptual measure of intensity and activity." More energetic tracks, such as hard metal, tend to be faster and louder, while less energetic tracks, such as classical music, are perceptably calmer.' , 
                                     'Danceability is defined by Spotify to be a measure between 0.0 and 1.0 that indicates how "danceable" a track is based on elements such as tempo, regularity, and rhythm.'), 
                     note = c('Lover, with an average valence of 0.481, is ranked as Taylor\'s most "positive" album. While the album includes mellower songs such as The Archer (valence = 0.166) and Cornelia Street (valence = 0.248), cheerful tracks such as Paper Rings (valence = 0.865) and ME! (valence = 0.728) largely epitomise the carefree, spirited nature of Lover. Perhaps surprisingly, Taylor\'s most recent release, Midnights, is considered her least positive album, with 10 of its 20 tracks having a valence below 0.200.',
                              "Taylor's self-titled debut album comes in as her most energetic album, with an average energy rating of 0.664. Interestingly, Taylor's albums appear to get less energetic over time, which perhaps reflects her gradual maturation from youthful, emotional music to calmer, more thoughtful music (which is especially seen with folklore and evermore).",
                              'Lover is Taylor\'s most "danceable" album, just barely inching reputation by 0.003. It can be noted that, on the plot, Lover displays a long, trailing tail on the left of its peak, suggesting that while the album has the highest average danceability, it also includes a proportion of "less danceable" songs (such as The Archer, Lover, and Soon You\'ll Get Better). In contrast, reputation\'s plot is much more symmetrical, indicating its more consistent danceability.'))

# Case study lyrics for Panel 5
woodsLyrics = allLyrics$lyric[6000:6008]
champagneLyrics = allLyrics$lyric[9513:9520]
