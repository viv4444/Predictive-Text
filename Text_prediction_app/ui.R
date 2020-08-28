#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)


shinyUI(fluidPage(theme = "bootstrap.css",

  
    titlePanel("Smart Keyboard"),

    sidebarLayout(
        sidebarPanel(
           textInput("text",label = h3(strong("Text input"))),
           submitButton("Submit"),
           helpText(h6("Note: This app has been made using a text sample database which was stopwords eliminated")),
           helpText(h6("Please refrain from using only English stopwords such as 'a', 'an', 'the' only as the input ")),
           helpText(h6("Also stemmed words have been used to build the model so for example if the predicted word is probably")),
           helpText(h6("it prints as 'probabl' instead")),
           helpText(h5("Note: This app has been made using a limited data base (please see the representation slide for more info)")),
           helpText(h5("Also in order to increase the smoothness of app a reduced and simpler prediction model is used")),
           helpText(h5("Hence due to these reasons the accuracy of this app has reduced considerably")),
           helpText(h4("Thanks for using this app, Have fun!"))
           
        ),

        mainPanel(
            h4("The predicted word is"),
            verbatimTextOutput("value")
        )
    )
))
