
d<-0.75 #discounted value

# Finding number of bi-gram words
numOfBiGrams <- nrow(Bi_words[by = .(word1, word2)])

# Dividing number of times word 2 occurs as second part of bigram, by total number of bigrams.  
# ( Finding probability for a word given the number of times it was second word of a bigram)
ckn <- Bi_words[, .(Prob = ((.N) / numOfBiGrams)), by = word2]
setkey(ckn, word2)

# Assigning the probabilities as second word of bigram, to unigrams
Uni_words[, Prob := ckn[word1, Prob]]
Uni_words <- Uni_words[!is.na(Uni_words$Prob)]

# Finding number of times word 1 occurred as word 1 of bi-grams
n1wi <- Bi_words[, .(N = .N), by = word1]
setkey(n1wi, word1)

# Assigning total times word 1 occured to bigram cn1
Bi_words[, Cn1 := Uni_words[word1, count]]

# Kneser Kney Algorithm
Bi_words[, Prob := ((count - d) / Cn1 + d / Cn1 * n1wi[word1, N] * Uni_words[word2, Prob])]
