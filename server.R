#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(tidyr)
library(networkD3)
library(here)

LoadEdges <- function(name,type){
    #set your own working directory 
    WorkingDirectory <-  paste(here::here(),"RepoAnalytics/",sep = "/")
    
    path = paste(WorkingDirectory,name,sep = "")
    print(path)
    dane <- read.csv(file = paste(path,type,sep = ""),header = TRUE)%>%as_data_frame()
    return(dane)
}
PrepareData <- function(repo_name){ # Load data
    print(repo_name)
    edges <- LoadEdges(repo_name,"/GraphEdges.csv")
    
    nodes<- LoadEdges(repo_name,"/GraphData.csv")
    
    
    #small clean up 
    edges$X = NULL   
    colnames(edges) = c("source","target")
    
    #get data frame of uniqe packed names from outside repo
    u <-unique(edges$target)%>%as.data.frame()
    ut <-unique(edges$source)%>%as.data.frame()
    u<-u[!(u$. %in% ut$.),]%>%as.data.frame()
    colnames(u) = c("project_names")
    names(nodes)
    nodes <- bind_rows(nodes,u)
    remove("u","ut")
    
    #handle all NA in data and clean up the data
    nodes <- transform(nodes,project_files = as.character(project_files),file_types = as.character(file_types))
    
    nodes <- replace_na(nodes,list(file_sizes = 5000,file_types = "Other"))
    
    nodes$project_files[is.na(nodes$project_files)] <- "Outside Package"
    
    nodes$import_counts[is.na(nodes$import_counts)] <- "External Package"
    
    edges <- transform(edges,source = as.character(source),target = as.character(target))
    
    edges$source[] <- nodes$project_names[match(edges$source,nodes$X)]
    tmp <- edges$target    
    edges$target[] <- nodes$project_names[match(edges$target,nodes$X, nomatch = edges$target)]
    for(i in seq(length(tmp))){
        if(is.na(edges$target[i])){
            edges$target[i] <- tmp[i]
        }
    }

    nodes$X = NULL
    
    #transform data to form aceptable by graph
    nodes$project_names <- as.factor(nodes$project_names)
    
    node_names <- factor(sort(unique(c(as.character(edges$source), as.character(edges$target)))))
    
    nodes_info <- data.frame(name = node_names, group = 1, size = 8)
    
    links <- data.frame(source = match(edges$source, node_names) - 1,
                        target = match(edges$target, node_names) - 1
    )
    
    nodes <- merge(nodes_info,nodes, by.x =  "name" , by.y = "project_names", all.x = T  )
    
    #seting some hyperamters
    nodes = mutate(nodes, size = file_sizes / 100 )
    nodes = mutate(nodes, group = import_counts)
    return(list(links,nodes))
}
#load all datasets into memory
graph_machine <-PrepareData("MachineLearningAlgorithms")
graph_SDM <- PrepareData("PySDM")
graph_Pyphen <- PrepareData("Pyphen")
graph_python3cookbook <- PrepareData("python3cookbook")
graph_ImageAI <- PrepareData("ImageAI")

if (interactive()) {
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
   
    output$value <- renderText({input$data})
    
    output$net <- renderForceNetwork(forceNetwork(Links =  graph_SDM[[1]] ,Nodes = graph_SDM[[2]],
              Source = "source",
              Target = "target",
              NodeID = "name",
              Group = input$group1,
              Nodesize = "size",
              charge = input$charge1,
              zoom = T,
              colourScale = JS("d3.scaleOrdinal(d3.schemeCategory10);"), fontSize = 40,
              opacity = input$opacity1,
              legend = input$legend1,
              linkDistance = input$distance1
    ))
    
    output$net2 <- renderForceNetwork(forceNetwork(Links =  graph_machine[[1]] ,Nodes = graph_machine[[2]],
              Source = "source",
              Target = "target",
              NodeID = "name",
              Group = input$group2,
              Nodesize = "size",
              charge = input$charge2,
              zoom = T,
              linkDistance = input$distance2,
              colourScale = JS("d3.scaleOrdinal(d3.schemeCategory10);"), fontSize = 40,
              opacity = input$opacity2,
              legend = input$legend2
    ))
    
    output$net3 <- renderForceNetwork(forceNetwork(Links =  graph_Pyphen[[1]] ,Nodes = graph_Pyphen[[2]],
               Source = "source",
               Target = "target",
               NodeID = "name",
               Group = input$group3,
               Nodesize = "size",
               charge = input$charge3,
               zoom = T,
               linkDistance = input$distance3,
               colourScale = JS("d3.scaleOrdinal(d3.schemeCategory10);"), fontSize = 40,
               opacity = input$opacity3,
               legend = input$legend3
    ))
    output$net4 <- renderForceNetwork(forceNetwork(Links =  graph_python3cookbook[[1]] ,Nodes = graph_python3cookbook[[2]],
               Source = "source",
               Target = "target",
               NodeID = "name",
               Group = input$group4,
               Nodesize = "size",
               charge = input$charge4,
               zoom = T,
               linkDistance = input$distance4,
               colourScale = JS("d3.scaleOrdinal(d3.schemeCategory10);"), fontSize = 40,
               opacity = input$opacity4,
               legend = input$legend4
    ))
    output$net5 <- renderForceNetwork(forceNetwork(Links =  graph_ImageAI[[1]] ,Nodes = graph_ImageAI[[2]],
               Source = "source",
               Target = "target",
               NodeID = "name",
               Group = input$group5,
               Nodesize = "size",
               charge = input$charge5,
               zoom = T,
               linkDistance = input$distance5,
               colourScale = JS("d3.scaleOrdinal(d3.schemeCategory10);"), fontSize = 40,
               opacity = input$opacity5,
               legend = input$legend5
    ))
    
})

}