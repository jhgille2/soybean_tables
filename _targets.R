## Load your packages, e.g. library(targets).
source("./packages.R")

## Load your R files
lapply(list.files("./R", full.names = TRUE), source)

## tar_plan supports drake-style targets and also tar_target()
tar_plan(
  
 ## Section: Input files/urls
 ##################################################
  
  # The plant row file
  tar_target(plant_row_file,
             here("data", "merged_plant_rows_2021.csv"), 
             format = "file"), 
  
  # A url to the soystats page on historic soybean oil production
  tar_target(soystats_oil_url, 
             "http://soystats.com/soybean-meal-u-s-production-history/"), 
  
  ## Section: Read in data from files/url
  ##################################################
  tar_target(plant_row_data, 
             read_csv(plant_row_file)), 
  
  tar_target(soystats_oil_data, 
             get_soystats_oil_table(soystats_oil_url)),
 
 ## Section: Data summaries
 ##################################################
 
 # Some quick summary tables of the plant row data
 tar_target(plant_row_summaries, 
            summarise_plant_row_data(plant_row_data)),
  
  
  ## Section: Making tables
  ##################################################
 
 # Use gt to make a formatted table from the soystats table.....
 # basically making the same table as what was on the website but whatever
 tar_target(soystats_gt, 
            make_soystats_gt(soystats_oil_data))
  
  
  



)
