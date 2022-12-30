library(spotifyr)

# Setting up Spotify client ID and client secret
Sys.setenv(SPOTIFY_CLIENT_ID = 'your ID')
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'your secret')
access_token <- get_spotify_access_token()

# Creating a tibble/df containing Taylor's Spotify data
taylor = get_artist_audio_features('taylor swift') %>% 
  as_tibble()

# Selecting relevant information from tibble
taylor$album_release_date = ymd(taylor$album_release_date)
taylor = taylor %>%
  select(track_name, 
         danceability, 
         energy, 
         loudness, 
         speechiness, 
         acousticness, 
         instrumentalness, 
         liveness, 
         valence, 
         tempo, 
         time_signature, 
         duration_ms, 
         explicit, 
         key_name, 
         mode_name, 
         key_mode, 
         album_name, 
         album_release_date, 
         track_id, 
         album_id) %>%
  arrange(album_release_date) %>%
  filter(album_name %in% c("Midnights (3am Edition)",
                           "Taylor Swift", 
                           "Fearless Platinum Edition",
                           "Fearless (Taylor's Version)",
                           "Speak Now (Deluxe Edition)",
                           "Red (Deluxe Edition)",
                           "Red (Taylor's Version)", 
                           "1989 (Deluxe Edition)",
                           "folklore (deluxe version)", 
                           "evermore (deluxe version)",
                           "reputation", 
                           "Lover")) %>%
  filter(!duplicated(track_name))

# Changing the deluxe edition titles to the original title (aesthetic purposes)
taylor$album_name[taylor$album_name == "Midnights (3am Edition)"] = "Midnights"
taylor$album_name[taylor$album_name == "Fearless Platinum Edition"] = "Fearless"
taylor$album_name[taylor$album_name == "Speak Now (Deluxe Edition)"] = "Speak Now"
taylor$album_name[taylor$album_name == "Red (Deluxe Edition)"] = "Red"
taylor$album_name[taylor$album_name == "1989 (Deluxe Edition)"] = "1989"
taylor$album_name[taylor$album_name == "folklore (deluxe version)"] = "folklore"
taylor$album_name[taylor$album_name == "evermore (deluxe version)"] = "evermore"

# Removing remixes and demos
taylor = taylor %>% filter(!str_detect(taylor$track_name, "Acoustic"), 
                           !str_detect(taylor$track_name, "Voice Memo"), 
                           !str_detect(taylor$track_name, "Demo"), 
                           !str_detect(taylor$track_name, "Piano"),
                           !str_detect(taylor$track_name, "POP"), 
                           !str_detect(taylor$track_name, "Pop"))

taylor$track_name[taylor$track_name == "Teardrops On My Guitar - Radio Single Remix"] = "Teardrops On My Guitar"

write.csv(taylor, "taylorRevised.csv")
