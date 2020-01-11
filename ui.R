#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


library(shiny)
library(dplyr)
library(tidyr)
library(networkD3)
library(plyr)

tabpanel1 <-tabPanel('SDM', uiOutput('page1'),sidebarLayout(
            sidebarPanel(
                sliderInput("opacity1",
                            "Opacity",
                            min = 0.1,
                            max = 1,
                            value = 1),
                
                selectInput("group1", h3("Color by"), 
                            choices = list("File type" = "file_types", "Numer of imports" = "import_counts"
                            ), selected = 2),
                #add more conrol
                checkboxInput("legend1", label = "Legenda", value = TRUE),
                sliderInput("charge1",
                            "Sila odpychania sie",
                            min = -1000,
                            max = 0,
                            value = -800),
                sliderInput("distance1",
                            "Dlugosci krawedzi",
                            min = 5,
                            max = 200,
                            value = 50)
                
            ),
        mainPanel(
            forceNetworkOutput(outputId = "net" )
        )
    ))

tabpanel2<-tabPanel('MachineLeariing', uiOutput('page2'),sidebarLayout(
    sidebarPanel(
        sliderInput("opacity2",
                    "Opacity",
                    min = 0.1,
                    max = 1,
                    value = 1),
        
        selectInput("group2", h3("Color by"), 
                    choices = list("File type" = "file_types", "Numer of imports" = "import_counts"
                    ), selected = 2),
        ##add more control
        checkboxInput("legend2", label = "Legenda", value = TRUE),
        sliderInput("charge2",
                    "Sila odpychania sie",
                    min = -1000,
                    max = 0,
                    value = -800),
        sliderInput("distance2",
                    "Dlugosci krawedzi",
                    min = 5,
                    max = 200,
                    value = 50)
        
    ),
    mainPanel(
        forceNetworkOutput(outputId = "net2" )
    )
))

tabpanel3<-tabPanel('Pyphen', uiOutput('page3'),sidebarLayout(
    sidebarPanel(
        sliderInput("opacity3",
                    "Opacity",
                    min = 0.1,
                    max = 1,
                    value = 1),
        
        selectInput("group3", h3("Color by"), 
                    choices = list("Typ pliku" = "file_types", "Liczba importow" = "import_counts", "Rozmiar pliku" = "file_sizes"
                    ), selected = 2),
        ##add more control
        checkboxInput("legend3", label = "Legenda", value = TRUE),
        sliderInput("charge3",
                    "Sila odpychania sie",
                    min = -1000,
                    max = 0,
                    value = -800),
        sliderInput("distance3",
                    "Dlugosci krawedzi",
                    min = 5,
                    max = 200,
                    value = 50)
        
    ),
    mainPanel(
        forceNetworkOutput(outputId = "net3" )
    )
))

tabpanel4<-tabPanel('python3-cookbook', uiOutput('page4'),sidebarLayout(
    sidebarPanel(
        sliderInput("opacity4",
                    "Opacity",
                    min = 0.1,
                    max = 1,
                    value = 1),
        
        selectInput("group4", h3("Color by"), 
                    choices = list("File type" = "file_types", "Numer of imports" = "import_counts"
                    ), selected = 2),
        ##add more control
        checkboxInput("legend4", label = "Legenda", value = TRUE),
        sliderInput("charge2",
                    "Sila odpychania sie",
                    min = -1000,
                    max = 0,
                    value = -800),
        sliderInput("distance4",
                    "Dlugosci krawedzi",
                    min = 5,
                    max = 200,
                    value = 50)
        
    ),
    mainPanel(
        forceNetworkOutput(outputId = "net4" )
    )
))

tabpanel5<-tabPanel('ImageAI', uiOutput('page5'),sidebarLayout(
    sidebarPanel(
        sliderInput("opacity5",
                    "Opacity",
                    min = 0.1,
                    max = 1,
                    value = 1),
        
        selectInput("group5", h3("Color by"), 
                    choices = list("File type" = "file_types", "Numer of imports" = "import_counts"
                    ), selected = 2),
        ##add more control
        checkboxInput("legend5", label = "Legenda", value = TRUE),
        sliderInput("charge5",
                    "Sila odpychania sie",
                    min = -1000,
                    max = 0,
                    value = -800),
        sliderInput("distance2",
                    "Dlugosci krawedzi",
                    min = 5,
                    max = 200,
                    value = 50)
        
    ),
    mainPanel(
        forceNetworkOutput(outputId = "net5" )
    )
))


if (interactive()) {
# Define UI for application that draws a histogram
shinyUI(fluidPage( 
    includeCSS("app_ad.css"),
    
    titlePanel("Analiza strukturalna oprogramowania"), 
    navbarPage("", collapsible = T, id = "navbar",
               tabpanel1,
               tabpanel2,
               tabpanel3,
               tabpanel4,
               tabpanel5
     )
    
    )
)
}