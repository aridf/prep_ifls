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


log <- as.data.frame(matrix(ncol = 3, nrow = 0))
df_list <- list()
  
for (file in year_files) {
  full_path <- file.path(f, file)
  df <- read_dta(full_path)
  
  has_pidlink <- "pidlink" %in% tolower(names(df))
  
  log_entry <- data.frame(
    "file"= file,
    "pidlink" = has_pidlink,
    "nrow" = nrow(df)
  )
  
  log <- rbind(
    log,
    log_entry
  )
  message(paste(
    '--------------------\n',
    "File:", log_entry$file, '\n',
    "Has pidlink:", log_entry$pidlink, "\n",
    "N. rows:", log_entry$nrow, '\n'
  ))
  
  df_list[[file]] <- df
}
write_csv(log, "code/merge_files_log.csv")

    
