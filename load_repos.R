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


project_stats <- function(project_name){
  project_files <- list.files(here("repos", project_name), recursive = TRUE)
  file_sizes <- sapply(project_files, get_file_info, project_name = project_name)
  print(file_infos)
  
  # Merge results
  result <- data.frame(project_files, file_infos)
  print(result)
  
  result
}



clear_repos_dir()
clone_repo("https://github.com/kopok2/AcceleratedGradientBoosting")

project_stats("AcceleratedGradientBoosting")