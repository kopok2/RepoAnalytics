# Load project repo module.

library(here)


clone_repo <- function(repo_url){
  dir.create(here("repos"), showWarnings = FALSE)
  repo_name <- tail(unlist(strsplit(repo_url, "/")), n=1)
  print(repo_name)
  system(paste("git clone ", repo_url, " ", here("repos"), "/", repo_name, sep = ""))
}


clear_repos_dir <- function(){
  unlink(here("repos"), recursive = TRUE)
}


get_file_info <- function(file_path, project_name){
  file.info(here("repos", project_name, file_path))$size
}


get_project_name <- function(file_path){
  tail(unlist(strsplit(head(unlist(strsplit(file_path, "[.]")), n=1), "/")), n=1)
}

get_file_type <- function(file_path){
  extension <- tail(unlist(strsplit(file_path, "[.]")), n=1)
  file_type <- switch(extension,
                      "py" = "Python",
                      "R" = "R",
                      "c" = "C",
                      "js" = "JavaScript",
                      "Other")

  file_type
}


get_file_imports <- function(file_path, project_name){
  file_type <- get_file_type(file_path)
  if(file_type == "Other"){
    return(character())
  } else {
    if(file_type == "Python"){
      imports <- character()
      con = file(here("repos", project_name, file_path), "r")
      while ( TRUE ) {
        line = readLines(con, n = 1)
        if ( length(line) == 0 ) {
          break
        }
        if(grepl("import", line))
        {
          if(grepl("from", line)){
            import_statement <- head(unlist(strsplit(tail(unlist(strsplit(line, "from")), n=1), "import")), n=1)
          } else {
            if(grepl("as", line)){
              import_statement <- head(unlist(strsplit(tail(unlist(strsplit(line, "import")), n=1), "as")), n=1)
            } else {
              import_statement <- head(unlist(strsplit(tail(unlist(strsplit(line, "import")), n=1), "\n")), n=1)
            }
          }
          import_statement <- gsub(" ", "", import_statement)
          imports <- c(imports, import_statement)
        }
      }
      
      close(con)
      return(imports)
    }
  }
}



make_graph <- function(imports, vertex){
  edges <- matrix(nrow = 0, ncol = 2)
  names(vertex) <- seq(length(vertex))
  for(source_vertex in seq(length(imports))){
    for(target_vertex in imports[source_vertex][[1]]){
      target_id = which(target_vertex == vertex)
      if(length(target_id) != 0){
        edges <- rbind(edges, c(source_vertex, target_id))
      } else {
        edges <- rbind(edges, c(source_vertex, target_vertex))
      }
    }
  }
  colnames(edges) <- c('importer', 'imported')
  edges
}



project_stats <- function(project_name){
  project_files <- list.files(here("repos", project_name), recursive = TRUE)
  project_names <- sapply(project_files, get_project_name)
  file_sizes <- sapply(project_files, get_file_info, project_name = project_name)
  file_types <- factor(sapply(project_files, get_file_type))
  file_imports <- sapply(project_files, get_file_imports, project_name = project_name)
  import_counts <- sapply(file_imports, length)
  names(file_imports) <- sapply(names(file_imports), get_project_name)
  graph <- make_graph(file_imports, project_names)
  
  print(graph)
  # Merge results
  result <- data.frame(row.names = seq.int(length(project_files)),
                       project_files,
                       project_names,
                       file_sizes,
                       file_types,
                       import_counts)
  
  
  result
}



clear_repos_dir()
clone_repo("https://github.com/kopok2/MachineLearningAlgorithms")

head(project_stats("MachineLearningAlgorithms"))