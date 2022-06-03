suppressPackageStartupMessages({
  library(tidyverse)
  library(haven)
})

# Folder -- if nextcloud is installed in user directory, this link should
# be stable
data_folder <- "~/Nextcloud/ugomelio_indonesia/IFLS/data"

# List all files/folders in the data directory, minus zip files
folders <- list.files(data_folder)
folders <- files[-grep(".zip", files)]
folders

# As a test case, take the one folder
f <- file.path(data_folder, 'hh93dta')
year_files <- list.files(f)

ff <- file.path(f, year_files[2])
d1 <- read_dta(ff)

df_list <- map(
  year_files,
  function(file) {
    full_path <- file.path(f, file)
    df <- read_dta(full_path)
    
    has_pidlink <- "pidlink" %in% tolower(names(df))
    
    message(paste0(
      file, 
      ": Has PIDLINK: ",
      has_pidlink,
      " nrow: ",
      nrow(df)
    ))
    return(df)
  }
)
