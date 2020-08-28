#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(quanteda)
setwd("C:/Users/hp/Desktop/Predictive Text")
Bi_words<-read.csv("Bigrams.csv")

Uni_words<-read.csv("Unigrams.csv")

tri_words<-read.csv("Trigrams.csv")

source("Final_model.R")


shinyServer(function(input, output) {
    
    output$value<- renderText({
        
        hope<-getWords(as.character(input$text))
        
        
    })

    

})
