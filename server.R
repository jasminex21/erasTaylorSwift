### Server ###
server = function(input, output) {
  
  # Function that makes it a bit less wordy to access annotations
  annotationSubsets = reactive({
    req(input$audioFeature) 
    filter(annotations, feature %in% input$audioFeature)
  })
  
  ## Panel 2 ##
  output$featureDescription = renderText({
    toString(annotationSubsets()[1,2])
  })
  
  output$featurePlot = renderPlot({
    ggplot(taylor %>% 
             group_by(album_name) %>%
             mutate(m = mean(eval(parse(text = input$audioFeature)))) %>%
             arrange(m) %>%
             ungroup() %>%
             mutate(album_name = factor(album_name, unique(album_name)))) + 
      geom_joy(aes(x = eval(parse(text = input$audioFeature)), 
                   y = fct_inorder(factor(album_name)), 
                   fill = factor(album_name)), 
               scale = 1.5, 
               color = "black", 
               size = 1) +
      theme_joy() + 
      labs(title = paste(str_to_title(input$audioFeature), "Distribution of Taylor Swift Albums"), 
           x = input$audioFeature, 
           y = "Album") + 
      scale_fill_manual(values = album_colors, breaks = albums) + 
      theme(legend.position = "none") + 
      xlim(c(0, 1)) + 
      theme(plot.title = element_text(size = 16)) 
  })
  
  output$featureTable = renderDataTable({
    table = taylor %>% 
      group_by(album_name) %>%
      summarise(!!paste("Mean", str_to_title(input$audioFeature)) := mean(eval(parse(text = input$audioFeature)))) 
    
    table %>% arrange(desc(table[2])) %>%
      rename(Album = 1) %>%
      datatable(options = list(paging = F, 
                               searching = F, 
                               lengthChange = F)) %>%
      formatRound(names(table)[2], digits = 4) 
  })
  
  output$featureCommentary = renderText({
    toString(annotationSubsets()[1,3])
  })
  
  ## Panel 3 ##
  createWordCount = reactive({
    req(input$cloudAlbum)
    albumLyrics = allLyrics %>%
      filter(album_name == input$cloudAlbum)
    text = albumLyrics$lyric
    
    words.vec = VectorSource(text)
    words.corpus = Corpus(words.vec)
    # Converting all text to lowercase
    words.corpus = tm_map(words.corpus, content_transformer(tolower))
    # Removing stop words from text 
    noStop = c("our", "ours", "yours")
    stops = stopwords("english")[!stopwords("english") %in% noStop]
    stops = c(stops, "oh", "ooh", "like", "just", "gonna", "wanna", "cause", "yeah")
    words.corpus = tm_map(words.corpus, removeWords, stops)
    # Removing punctuation, but preserving single quotations
    words.corpus = tm_map(words.corpus, removePunctuation, preserve_intra_word_contractions = T)
    # Removing extra spaces
    words.corpus = tm_map(words.corpus, stripWhitespace)
    # Creating a term-document matrix (contains word frequencies)
    dtm = TermDocumentMatrix(words.corpus)
    m = as.matrix(dtm)
    v = sort(rowSums(m), decreasing = TRUE)
    data.frame(word = names(v), freq = v)
  })
  
  output$countTable = renderDataTable({
    df = createWordCount()
    rownames(df) = NULL
    DT::datatable(df, 
                  colnames = c("Word", "Frequency"),
                  caption = 'Note that stopwords such as i, me, my, am, etc. have been excluded. Hover over the wordcloud for specific word counts, or view the table below.')
  })
  
  # I could have put the palettes in order into a dataframe, which would have made this less repetitive
  cloudPalette = reactive({
    if (input$cloudAlbum == "Taylor Swift") {
      palette = palettes$taylorSwift
    }
    else if (input$cloudAlbum == "Fearless" | input$cloudAlbum == "Fearless (Taylor's Version)") {
      palette = palettes$fearless
    }
    else if (input$cloudAlbum == "Speak Now") {
      palette = palettes$speakNow
    }
    else if (input$cloudAlbum == "Red") {
      palette = palettes$Red
    }
    else if (input$cloudAlbum == "Red (Taylor's Version)") {
      palette = palettes$taylorRed
    }
    else if (input$cloudAlbum == "1989") {
      palette = palettes$taylor1989
    }
    else if (input$cloudAlbum == "reputation") {
      palette = palettes$reputation
    }
    else if (input$cloudAlbum == "Lover") {
      palette = palettes$lover
    }
    else if (input$cloudAlbum == "folklore") {
      palette = palettes$folklore
    }
    else if (input$cloudAlbum == "evermore") {
      palette = palettes$evermore
    }
    else if (input$cloudAlbum == "Midnights") {
      palette = palettes$midnights
    }
  })
  
  output$wordCloud = renderWordcloud2({
      wordcloud2(data = createWordCount(),
                 fontFamily = "Helvetica",
                 fontWeight = "bold",
                 shape = 'circle', 
                 ellipticity = 0.70, 
                 color = rep_len(cloudPalette()[2:length(cloudPalette())], 
                                 length.out = nrow(createWordCount())), 
                 backgroundColor = cloudPalette()[1], 
                 size = 0.8,
                 minSize = 2)
    })
  
  ## Panel 4 ##
  buttonPressed = eventReactive(input$button, {
    # Single line - straightforward
    if (input$numOfLines == 1) {
      randNum = floor(runif(1, min = 1, max = nrow(allLyrics)))
      randLyric = allLyrics$lyric[randNum]
      randTrack = allLyrics$track_name[randNum]
      randSection = allLyrics$element[randNum]
      HTML(paste0(randLyric, "<br/><br/>", strong("from "), strong(em(randTrack)), em(strong(", ")), strong(randSection)))
    }
    # Two lines - both lines should come from the same section of the song
    else if (input$numOfLines == 2) {
      randNum = floor(runif(1, min = 1, max = nrow(allLyrics)))
      randLyric = allLyrics$lyric[randNum]
      randTrack = allLyrics$track_name[randNum]
      randSection = allLyrics$element[randNum]
      if (allLyrics$element[randNum + 1] == randSection) {
        start = randNum
        end = randNum + 1
      } 
      else {
        start = randNum - 1
        end = randNum
      }
      HTML(paste(allLyrics$lyric[start], "<br/>",
                 allLyrics$lyric[end], 
                 "<br/><br/>", strong("from "), strong(em(randTrack)), em(strong(", ")), strong(randSection), sep = ""))
    }
    # Entire section - initially tried filtering, but there are sections with the same title (chorus), so had to use while loops
    else if (input$numOfLines == 3) {
      randNum = floor(runif(1, min = 1, max = nrow(allLyrics)))
      randLyric = allLyrics$lyric[randNum]
      randTrack = allLyrics$track_name[randNum]
      randSection = allLyrics$element[randNum]
      entireSection = randLyric
      
      end = randNum
      while (allLyrics$element[end + 1] == randSection) {
        end = end + 1
      }
      start = randNum
      while (allLyrics$element[start - 1] == randSection) {
        start = start - 1
      }
      entireSection = allLyrics$lyric[start:end]
      HTML(paste(paste(entireSection, collapse = "<br/>"), 
                 "<br/><br/>", strong("from "), strong(em(randTrack)), em(strong(", ")), strong(randSection), sep = ""))
    }
  })
  
  output$randGenerated = renderUI({
    buttonPressed()
  })
  
  lexDivAlbum = function() {
    lexicalDiv = allLyrics %>%
      group_by(track_name, album_name) %>%
      unnest_tokens(word, lyric) %>%
      summarise(LexicalDiversity = n_distinct(word) / length(word)) %>%
      arrange(desc(LexicalDiversity))
  }
  
  output$lexDiversityAlbum = renderDataTable({
    tabl = lexDivAlbum() %>%
      group_by(album_name) %>%
      summarise(`Mean Lexical Diversity` = mean(LexicalDiversity)) %>%
      arrange(desc(`Mean Lexical Diversity`)) %>%
      rename(Album = 1)
    tabl %>%
      datatable(options = list(paging = F, 
                               searching = F, 
                               lengthChange = F), 
                caption = "Taylor's albums arranged by average lexical diversity") %>% 
      formatRound(names(tabl)[2], digits = 4) 
  })
  
  output$lexDiversitySong = renderDataTable({
    tab = allLyrics %>%
      unnest_tokens(word, lyric) %>%
      group_by(track_name) %>%
      summarise(LexicalDiversity = n_distinct(word) / length(word)) %>%
      arrange(desc(LexicalDiversity)) %>%
      rename(Track = 1, `Lexical Diversity` = 2)
    tab %>% 
      datatable(
        caption = "This table displays the lexical diversity of each track in Taylor's 12 albums"
      ) %>%
      formatRound(names(tab)[2], digits = 4)
  })
  
  output$lexDiversity = renderPlot({
    lexicalDiv = lexDivAlbum()
    
    lexicalDiv$album_name = gsub("(\\(Taylor's Version\\))", "TV", lexicalDiv$album_name)
    pirateplot(formula = LexicalDiversity ~ album_name, 
               data = lexicalDiv, 
               theme = 0, #Starting the plot from nothing so it can be fully customised
               pal = c("#B8BFE2", # 1989
                       "#727272", 
                       "#731D05", 
                       "#fdcdcd", 
                       "#841E10", 
                       "#00A3AD", 
                       "#C3B377", 
                       "#8449BB", 
                       "#F6ED95", 
                       "#526D85",
                       "#994914", 
                       "#BABABA"), # folklore
               main = "Lexical Diversity of Taylor Swift's Albums", 
               xlab = "Album", 
               ylab = "Lexical Diversity", 
               point.o = 0.6, 
               bean.f.o = 0, 
               bean.b.o = 0, 
               avg.line.o = 1, 
               point.pch = 21, 
               gl.col = "gray93", 
               sortx = "mean", 
               width.min = 1)
    
    # Arrow and text for 1989
    Arrows(x1 = 1.5, y1 = 0.40, x0 = 1.3, y0 = 0.3, 
           arr.type = "curved", 
           col = "#B8BFE2", 
           lwd = 3, 
           arr.length = 0.4)
    
    text(x = 1.5, y = 0.445, 
         labels = paste("1989 has the least lexical diversity", 
                        "\n", "of all Taylor's albums - consider", 
                        "\n", "the repetitiveness of Shake It Off", 
                        "\n", "and Welcome to New York"), 
         col = "#B8BFE2", cex = 0.92)
    
    # Arrow and text for champagne problems
    Arrows(x1 = 10.3, y1 = 0.585, x0 = 10.8, y0 = 0.577, 
           arr.type = "curved", 
           col = "#994914", 
           lwd = 3, 
           arr.length = 0.3)
    
    text(x = 9, y = 0.592, 
         labels = paste("champagne problems is Taylor's", 
                        "\n", "most lexically diverse song"), 
         col = "#994914", cex = 0.95)
    
    # Arrow and text for Out of the Woods
    Arrows(x1 = 1.5, y1 = 0.15, x0 = 1.13, y0 = 0.156, 
           arr.type = "curved", 
           col = "#B8BFE2", 
           lwd = 3, 
           arr.length = 0.3)
    
    text(x = 2.9, y = 0.15, 
         labels = paste("\"Are we out of the woods yet?", 
                        "\n", "Are we out of the woods yet?", 
                        "\n", "Are we out of the woods yet?", 
                        "\n", "Are we out of the woods?\""), 
         col = "#B8BFE2", cex = 0.95)
    
    # Arrow and text for folklore
    Arrows(x0 = 11.85, y0 = 0.33, x1 = 11.4, y1 = 0.23, 
           arr.type = "curved", 
           col = "#BABABA", 
           lwd = 3, 
           arr.length = 0.4)
    
    text(x = 11, y = 0.2, labels = paste("Taylor's lyricism really", "\n", "shines through in folklore"), col = "#BABABA", cex = 0.95)
  })
}
