# Eras: Taylor Swift - An Analysis of Taylor Swift's Discography

An R Shiny web application dedicated to Taylor Swift. Accounts for 225 tracks in 10 original studio albums (*Taylor Swift* to *Midnights*) and 2 re-recordings (*Fearless TV* and *Red TV*). Consists of 5 panels, each focusing on a different aspect of Swift's discography - see below for a run-down of the panels.

The app can be accessed via `runGitHub("erasTaylorSwift", "jasminex21")` or through [this link](https://jasminex21.shinyapps.io/erasTaylorSwift/_w_020d3d41/#tab-2723-3).

### Panel 2 - Track Audio Features
Insight into audio features (defined and quantified by the Spotify API) of Taylor Swift's albums. Allows users to view valence, energy, and danceability of each album in a joyplot and in tabular format. Each feature is briefly explained in the user interface.

Joyplot displaying the distribution of valence in each album:

<img src="https://user-images.githubusercontent.com/109494334/210194330-d64a8891-ed67-4d62-8faf-12fc190fc0d1.png" width=80% height=80%>


### Panel 3 - Word Cloud
Creates a word cloud for each album, displaying the album's 450 most-used words (common stop words removed).

Word cloud produced for *Speak Now*:

<img src="https://user-images.githubusercontent.com/109494334/210193868-444417da-09db-4648-a25c-dcab21586e02.png" width=80% height=80%>

### Panel 4 - Lexical Diversity
Allows for comparison of lexical diversity amongst Taylor Swift's albums in a plot and in tabular format.

### Panel 5 - Random Lyrics Generator
Generates random lyric(s) - can generate one or two lines, or the entire section of a track (e.g. chorus, verse 1, bridge, etc.). 

Single line                |  Two lines                |  Entire section           |
:-------------------------:|:-------------------------:|:-------------------------:|
![image](https://user-images.githubusercontent.com/109494334/210194138-8ccbf69d-1d75-427c-9e32-26c42cdc8306.png) |  ![image](https://user-images.githubusercontent.com/109494334/210194182-c18ca470-68f5-4e55-8008-23e765e59c3f.png) |  ![image](https://user-images.githubusercontent.com/109494334/210194240-b3897073-c0da-46ee-8ed1-b9f9d2c1e7c4.png)


### TODO
- Remove non-Taylor's versions if their Taylor's version is available! For sure Red and Fearless, probably 1989 as well.
- Add 1989 Taylor's version
- Once TTPD comes out, update the app as soon as possible to reflect it!
- Plots can honestly be improved - especially the ones that aren't as dynamic / user-friendly
- Link the lyrics generator to the tayLyrics - either implement it into the app or link it to the game app
- Maybe add more pictures (recent ones) to the slideshow in the intro panel
- Background change? Background selection option (would be cool)?
- Font change? Font selection option by era?
- More panels for more in-depth explorations

