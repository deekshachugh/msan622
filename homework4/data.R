require(tm)        # corpus
require(SnowballC) # stemming


sotu_source <- DirSource(
  # indicate directory
  directory = file.path("data"),
  encoding = "UTF-8",     # encoding
  pattern = "*.txt",      # filename pattern
  recursive = FALSE,      # visit subdirectories?
  ignore.case = FALSE)    # ignore case in pattern?

speeches <- Corpus(
  sotu_source, 
  readerControl = list(
    reader = readPlain, # read as plain text
    language = "en"))

obama.wc<-length(unlist(strsplit(speeches[[1]], " ")))
print(obama.wc)
bush.wc<-length(unlist(strsplit(speeches[[2]], " ")))

# Create a Term-Document matrix
add.stops=c("applause","will", "can", "get", "that", "year", "let","must")
speech.control=list(stopwords=c(stopwords(),add.stops), removeNumbers=TRUE, removePunctuation=TRUE)
speeches.matrix<-TermDocumentMatrix(speeches, control=speech.control)

# Create data frame from matrix
speeches.df<-as.data.frame(inspect(speeches.matrix))

speeches.df<-subset(speeches.df, obama.txt>0 & bush.txt>0)
speeches.df<-transform(speeches.df, freq.dif=obama.txt-bush.txt)    


### Step 2: Create values for even y-axis spacing for each vertical
#           grouping of word freqeuncies

# Create separate data frames for each frequency type
obama.df<-subset(speeches.df, freq.dif > 23)   # Said more often by Obama
bush.df<-subset(speeches.df, freq.dif < -12)   # Said more often by Bush

equal.df<-head(subset(speeches.df, freq.dif == 0),30)  # Said equally

# This function takes some number as spaces and returns a vector
# of continuous values for even spacing centered around zero
optimal.spacing<-function(spaces) {
  if(spaces>1) {
    spacing<-1/spaces
    if(spaces%%2 > 0) {
      lim<-spacing*floor(spaces/2)
      return(seq(-lim,lim,spacing))
    }
    else {
      lim<-spacing*(spaces-1)
      return(seq(-lim,lim,spacing*2))
    }
  }
  else {
    return(0)
  }
}

# Get spacing for each frequency type
obama.spacing<-sapply(table(obama.df$freq.dif), function(x) optimal.spacing(x))
bush.spacing<-sapply(table(bush.df$freq.dif), function(x) optimal.spacing(x))
equal.spacing<-sapply(table(equal.df$freq.dif), function(x) optimal.spacing(x))

# Add spacing to data frames
obama.optim<-rep(0,nrow(obama.df))
for(n in names(obama.spacing)) {
  obama.optim[which(obama.df$freq.dif==as.numeric(n))]<-obama.spacing[[n]]
}
obama.df<-transform(obama.df, Spacing=obama.optim)

bush.optim<-rep(0,nrow(bush.df))
for(n in names(bush.spacing)) {
  bush.optim[which(bush.df$freq.dif==as.numeric(n))]<-bush.spacing[[n]]
}
bush.df<-transform(bush.df, Spacing=bush.optim)

equal.df$Spacing<-as.vector(equal.spacing)
