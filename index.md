---
title: "Milestone Report"
author: "Vivek Singh"
date: "8/24/2020"
output: 
  html_document:
    keep_md : true
---



# **NATURAL LANGUAGE PROCESSING - MAKING A PREDICTIVE TEXT MODEL- MILESTONE REPORT**

## **Introduction**

-This is a detailed report of my journey of making a predictive text model based on NLP using database
provided
by **Swiftkey** which is a company dedicated to making smart keyboards and other language processing
solutions

-The end result of ths project is a smart keyboard that can capably predict the next word to be typed making 
it easier for the typist.

In order to do that we need to find the pattern in general language in order to make our predictions simplar 
and draw a predictive model that has a high level of accuracy but first lets look at the data given to us on
which we will base our model building.  We are given 3 corpus in three 3 different languages – English,
German, and Finnish. Since I am proficient in English I chose to only use the English language. There are
three different documents that make up the corpus - texts from Twitter feed, news feed, and blog feed.

## **Few Points About The Data**

The line, word and character count for these documents are as follows:

1. en_US.blogs.txt- 899288 37334131 210160014

2. en_US.news.txt- 1010242 34372530 205811889

3. en_US.twitter.txt- 2360148 30373583 167105338

## **Important libraries to be used**

```r
if(!require(tm)){
  install.packages("tm")
  library(tm)
}
```

```
## Loading required package: tm
```

```
## Loading required package: NLP
```

```r
if(!require(wordcloud)){
  install.packages("wordcloud")
  library(wordcloud)
}
```

```
## Loading required package: wordcloud
```

```
## Loading required package: RColorBrewer
```

```r
if(!require(stringr)){
  install.packages("stringr")
  library(stringr)
}
```

```
## Loading required package: stringr
```

```r
if(!require(SnowballC)){
  install.packages("SnowballC")
  library(SnowballC)
}
```

```
## Loading required package: SnowballC
```


## **Importing the data into R**

-Before getting to the importing part, two things that we should take care of are , one, this dataset is
extremely huge and most of the model building can be done by using only 5-10% of the data 
Secondly, in order to randomize the data we can read random lines of data and create another text file

The function below takes care of both these parameters


```r
samplingfile<-function(count,filename){
  incon<-file(paste(count,filename,".txt",sep = ""),"r")
  sample1<-readLines(incon)
  set.seed(1234)
  sample_file<-sample1[(rbinom(n=length(sample1),size = 1,prob = 0.05))==1]
  close(incon)
  
  
  outcon<-file(paste("sample_",filename,".txt",sep = ""),"w")
  writeLines(sample_file,con = outcon)
  close(outcon)
  
}
```


This will give us sample files namely sample_twitter,sample_blogs and sample_news

But this is not a desired format for analysis what we are looking for is more like a "corpus" of words 


```r
folder<-"C:\\Users\\hp\\Desktop\\Predictive Text\\Sample Files" 
filelist<-list.files(path = folder,pattern = "*.txt")
filelist<-paste(folder,"\\",filelist,sep="")
m<-lapply(filelist,readLines)
```

```
## Warning in FUN(X[[i]], ...): incomplete final line found on 'C:
## \Users\hp\Desktop\Predictive Text\Sample Files\sample_blogs.txt'
```

```
## Warning in FUN(X[[i]], ...): incomplete final line found on 'C:
## \Users\hp\Desktop\Predictive Text\Sample Files\sample_news.txt'
```

```
## Warning in FUN(X[[i]], ...): incomplete final line found on 'C:
## \Users\hp\Desktop\Predictive Text\Sample Files\sample_twitter.txt'
```

```r
text<-lapply(m,FUN = paste,collapse=" ")
```

Finally We have a single large character object "text" containing all the words from each 3 files. We can
move on to cleaning the data

## **Cleaning the data**

Following is a checklist of what and all will be cleaned or removed fom the data to make it more
interpratable 

1. Convert all the words to lower case.
2. Remove Punctuation.
3. Remove Numbers.
4. Remove Stopwords.
5. Remove Special Characters using a custom function written to do so.
6. Strip the White Space using stripWhiteSpace.
7. Stem the Document using stemDocument.
8. Convert it to a Plain Text Document.
9. Remove Profanity
10.Remove technical acronyms such as RT(re tweet)

We will be taking care of all these one by one using gsub (alternatively tm_map can also be used)


```r
text2<-gsub(pattern = "\\W",replacement = " ",text) #Removing Punctuations
text3<-gsub(pattern = "\\d",replacement = " ",text2) #Removing Numbers
text4<-gsub(pattern = '[])(;:#%$^*\\~{}[&+=@/"`|<>_]+',replacement = " ",text3) #Removing special characters
text5<-gsub(pattern = "\\b[A-z]\\b{2}",replacement = " ",text4) #Removin single stranded words such as s,a
text6<-tolower(text5) #Converting to lower case
profanitylist<-read.csv("list.txt",header = FALSE,stringsAsFactors = FALSE) #A list of words that can be
                                                                            #considered profane
for(i in 1:nrow(profanitylist)){
    text7<- gsub(profanitylist$V1[i],"", text6)
}                                                 #Removing profane words
text8<-removeWords(text7,stopwords("english")) #Removing stop words

text9<-gsub(pattern = "rt",replacement = " ",text8) #Removing technical acronyms
text10<-stemDocument(text9) #Stemming the document
text11<-stripWhitespace(text10) #Strip WhiteSpace
```


Now that the data has been thorougly cleaned we can begin our exproratory analysis

But before that we would like to have our data in a more interpratable format like a "corpus"


```r
corpus1<-Corpus(VectorSource(text11))

tdm<-TermDocumentMatrix(corpus1)

final<-as.matrix(tdm)

 colnames(final)<-c("Blogs","News","Twitter")
 head(final)
```

```
##          Docs
## Terms     Blogs News Twitter
##   aaron       1    0       0
##   aber        1    0       0
##   abl         6    3       1
##   acceler     1    0       0
##   access      3    1       0
##   accid       2    0       0
```


The final contains the data in a more representable and explorable form

## **Exploratory Analysis**
There are a couple of ways we can perform exploratory analysis , but when it comes to natural language
processing we have 3 options that give us a wide list of the behaviour of the data we are dealing with

1.WordCloud- A plot of words with the frequency of that word represented by the size
2.Sentimental analysis
3.Naive Bayes

We will be using wordcloud to get the desired analysis


```r
comparison.cloud(final)
```

![](index_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

A histogram showing the most frequent words can be plotted to get a better idea 

![](index_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

It is pretty evident from the Wordcloud and Bar plot that

1. Words like Tweet, love , follow are most frequent in twitter database,for news its Water, office 
and for blogs we have think fun etc

2.The dataset is barely sparse i.e. A lot of words are frequent and its hard to find a clear winner


## **Next Steps for further anlysis**
1.Implement a proper smoothing technique by evaluating different smoothing techniques.

2.Implement a prediction model which utilizes low memory space ,accuracy is high and efficient performance.

3.Implement a prediction Application in Shiny.

##Bibliography and references for this report

1.Jaylayr Academy (youtube channel) *https://www.youtube.com/watch?v=pFinlXYLZ-A*
2.Introduction to the tm Package Text Mining in R by Ingo Feinerer

