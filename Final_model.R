getWords<-function(str){
  require(quanteda)
  tokens <- tokens(x = char_tolower(str))
  tokens <- char_wordstem(rev(rev(tokens[[1]])[1:2]), language = "english")
  if(length(tokens)>=2)
  {words <- triWords(tokens[1], tokens[2], 5)
  chain_1 <- paste(tokens[1], tokens[2], words[1], sep = " ")}
  
  if(length(tokens)<2)
  {words <- biWords(tokens[1], 5)
  chain_1 <- paste(tokens[1], tokens[2], words[1], sep = " ")}
  print(words[1])
}

#The following functions represent the followback algorithms that take word and finds the most probable previous word set
# function to return random words from unigrams
uniWords <- function(n = 5) {  
  return(sample(Uni_words[, word1], size = n))
}




# function to return highly probable previous word given a word
biWords <- function(w1, n = 5) {
  pwords <- Bi_words[w1][order(-Prob)]
  if (any(is.na(pwords)))
    return(uniWords(n))
  if (nrow(pwords) > n)
    return(pwords[1:n, word2])
  count <- nrow(pwords)
  unWords <- uniWords(n)[1:(n - count)]
  return(c(pwords[, word2], unWords))
}


# function to return highly probable previous word given two successive words
triWords <- function(w1, w2, n = 5) {
  pwords <- tri_words[.(w1, w2)][order(-Prob)]
  if (any(is.na(pwords)))
    return(biWords(w2, n))
  if (nrow(pwords) > n)
    return(pwords[1:n, word3])
  count <- nrow(pwords)
  bwords <- biWords(w2, n)[1:(n - count)]
  return(c(pwords[, word3], bwords))
}










