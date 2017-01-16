# Download and unzip

library(tools)

# Download files function
download <- function(URL){
  
  # Creates data directory if not present
  dir.create(file.path('data'), showWarnings = FALSE)
  
  fileZip<- basename(URL)
  name_data <- file_path_sans_ext(fileZip)
  
  # Downloads the file in data directory
  download.file(URL, fileZip)
  
  # Unzips the file in the folder
  unzip(fileZip, exdir = paste0('data/',name_data))
  
  # Removes zip file
  file.remove(fileZip)
  
  # Returns dataset name
  return(name_data)
}