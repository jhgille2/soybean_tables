# soybean_tables
Some quick examples for webscrapting/making tables using soybean data

## Overview
Some code to show some webscraping and table formatting with the rvest/gt/kableExtra packages.

## Usage
The easiest way to use this repository would be to first clone it by creating a new project in RStudio  by clicking New project... -> Version COntrol -> Git, paste this link (https://github.com/jhgille2/soybean_tables.git) into the Repository URL field, and then click Create Project. 

Once the repository is downloaded to your computer, first run all the code in the **packages.R** script, and then type and enter **tar_make()** in the console. You can also get a sense for how the pipeline fits together by running **tar_visnetwork()** in the console. 

Right now I have everything set up as a targets workflow but once I get some good examples, I'll make the same workflow in a classic script format too. For now though, the targets.R file describes the steps in the workflow, and the custom functions I used in it are stored in the R folder. You can load the output of each step by running tar_load(target_name) in the console. For example, to see the output from the soystats_gt step, you could run **tar_load(soystats_gt)** and this will load the output of that step into your environment and you can interact with it like you would normally. 
