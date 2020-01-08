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


project_stats <- function(project_name){
  project_files <- list.files(here("repos", project_name), recursive = TRUE)
  file_sizes <- sapply(project_files, get_file_info, project_name = project_name)
  file_types <- factor(sapply(project_files, get_file_type))
  
  # Merge results
  result <- data.frame(row.names = seq.int(length(project_files)),
                       project_files, 
                       file_sizes,
                       file_types)
  
  result
}



clear_repos_dir()
clone_repo("https://github.com/kopok2/AcceleratedGradientBoosting")

(project_stats("AcceleratedGradientBoosting"))