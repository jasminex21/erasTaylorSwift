library(tidyverse)
# The "taylor" package is an extremely useful that makes it a 
# lot easier to deal with Taylor Swift's lyrics
library(taylor)

# Original dataframe created by taylorData.R
taylor = read_csv("taylorRevised_2024.csv")

# Making slight changes to track names in both dataframes such
# that the track names match perfectly
taylor_all_songs$track_name = gsub("\\[", "(", taylor_all_songs$track_name)
taylor_all_songs$track_name = gsub("\\]", ")", taylor_all_songs$track_name)
taylor$track_name = gsub("<U\\+2019>", "'", taylor$track_name)
taylor$track_name = gsub("<U\\+2018>", "'", taylor$track_name)
taylor$track_name = gsub('\"', '', taylor$track_name)
taylor_all_songs$track_name = gsub('\"', '', taylor_all_songs$track_name)
taylor$track_name = gsub("’", "'", taylor$track_name)
taylor$track_name = gsub("‘", "'", taylor$track_name)
taylor$track_name = str_trim(gsub("\\s\\(feat[^()]*\\)", "", taylor$track_name))
taylor$track_name = str_trim(gsub("- bonus track", "", taylor$track_name))

taylor$track_name[taylor$track_name == "A Place in this World"] = "A Place In This World" 
taylor$track_name[taylor$track_name == "Tied Together with a Smile"] = "Tied Together With A Smile"
taylor$track_name[taylor$track_name == "I Knew You Were Trouble."] = "I Knew You Were Trouble"
taylor$track_name[taylor$track_name == "Superstar (Taylor's Version)"] = "SuperStar (Taylor's Version)" 
taylor$track_name[taylor$track_name == "When Emma Falls in Love (Taylor's Version) (From The Vault)"] = "When Emma Falls In Love (Taylor's Version) (From The Vault)" 

taylor_all_songs$album_name[taylor_all_songs$track_name == "I'm Only Me When I'm With You"] = "Taylor Swift"

# Filtering out songs from taylor_all_songs that are *not* included
# in taylor
taylor_all_songs = taylor_all_songs %>% 
  filter(taylor_all_songs$track_name %in% taylor$track_name)

# Unnesting taylor_all_songs to create a "tall" dataframe where
# each line from a song corresponds to a row in the dataframe
allLyrics = taylor_all_songs %>% 
  select("lyrics", 
         "track_name", 
         "album_name") %>%
  unnest(lyrics) %>%
  select(-(element_artist))

write.csv(allLyrics, "allTaylorLyrics_2024.csv")
