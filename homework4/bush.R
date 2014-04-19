require(tm)        # corpus
require(SnowballC) # stemming

#TODO(deeksha): Remove this before submission
setwd("/home/deeksha/github/msan622/homework4")

sotu_source <- DirSource(
  # indicate directory
  directory = file.path("Bush"),
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
#print(sotu_corpus)
#summary(sotu_corpus)
#inspect(sotu_corpus)


# Transform Corpus #####

getTransformations()
# sotu_corpus[[1]][3]
#stemDocument(sotu_corpus[[1]])
sotu_corpus <- tm_map(sotu_corpus, tolower)
sotu_corpus <- tm_map(sotu_corpus, removeNumbers)

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
  c("will", "can", "get", "that", "year", "let","must"),mc.cores=1)



# Calculate Frequencies
sotu_tdm <- TermDocumentMatrix(sotu_corpus)


# Inspect Frequencies
#print(sotu_tdm)

# Convert to term/frequency format
sotu_matrix <- as.matrix(sotu_tdm)


sotu_bush_df <- data.frame(
  word = rownames(sotu_matrix), 
  # necessary to call rowSums if have more than 1 document
  freq = rowSums(sotu_matrix),
  stringsAsFactors = FALSE) 

# Sort by frequency
sotu_bush_df <- sotu_bush_df[with(
  sotu_bush_df, 
  order(freq, decreasing = TRUE)), ]

# Do not need the row names anymore
rownames(sotu_bush_df) <- NULL

# Check out final data frame
#View(sotu_bush_df)
