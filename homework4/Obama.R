require(tm)        # corpus
require(SnowballC) # stemming


sotu_source <- DirSource(
  # indicate directory
  directory = file.path("Obama"),
  encoding = "UTF-8",     # encoding
  pattern = "*.txt",      # filename pattern
  recursive = FALSE,      # visit subdirectories?
  ignore.case = FALSE)    # ignore case in pattern?

sotu_corpus <- Corpus(
  sotu_source, 
  readerControl = list(
    reader = readPlain, # read as plain text
    language = "en"))
 ##Inspect Corpus #####
# print(sotu_corpus)
 #summary(sotu_corpus)
 #inspect(sotu_corpus)
 

# Transform Corpus #####
#getTransformations()
#sotu_corpus[[4]]

sotu_corpus <- tm_map(sotu_corpus, tolower)

sotu_corpus <- tm_map(
  sotu_corpus, 
  removePunctuation,
  preserve_intra_word_dashes = TRUE,mc.cores=1)

sotu_corpus <- tm_map(
  sotu_corpus, 
  removeWords, 
  stopwords("english"),mc.cores=1)

# getStemLanguages()
sotu_corpus <- tm_map(
  sotu_corpus, 
  stemDocument,
  lang = "english",mc.cores=1) # try porter or english

sotu_corpus <- tm_map(
  sotu_corpus, 
  stripWhitespace,mc.cores=1)

#Remove specific words
sotu_corpus <- tm_map(
  sotu_corpus, 
  removeWords, 
  c("will", "can", "get", "that", "year", "let","now","new"),mc.cores=1)



# Calculate Frequencies
sotu_tdm <- TermDocumentMatrix(sotu_corpus)

# Inspect Frequencies
# print(sotu_tdm)

# Convert to term/frequency format
sotu_matrix <- as.matrix(sotu_tdm)
sotu_obama_df <- data.frame(
  word = rownames(sotu_matrix), 
  # necessary to call rowSums if have more than 1 document
  freq = rowSums(sotu_matrix),
  stringsAsFactors = FALSE) 

# Sort by frequency
sotu_obama_df <- sotu_obama_df[with(
  sotu_obama_df, 
  order(freq, decreasing = TRUE)), ]

# Do not need the row names anymore
rownames(sotu_obama_df) <- NULL

# Check out final data frame
#View(sotu_obama_df)

