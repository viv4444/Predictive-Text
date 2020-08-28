# Finding count of word1-word2 combination in bigram 
tri_words[, Cn2 := Bi_words[9430, count]]

# Finding count of word1-word2 combination in trigram
n1w12 <- tri_words[, .N, by = .(word1, word2)]
setkey(n1w12, word1, word2)

# Kneser Kney Algorithm
tri_words[, Prob := (count - d) / Cn2 + d / Cn2 * n1w12[.(word1, word2), N] * Bi_words[.(word1, word2), Prob]]
