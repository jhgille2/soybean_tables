#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param soystats_oil_url
#' @return
#' @author 'Jay
#' @export
get_soystats_oil_table <- function(soystats_oil_url) {

  # Use the 'read_html' function to read the whole webpage and then the 'html_table' function to 
  # get all the tables from the webpage. This returns a list of all the tables from the page. In this 
  # case, there is only one table on the page
  oil_production_table <- soystats_oil_url %>% 
    read_html() %>% 
    html_table()
  
  # Get the first (and only) table in the list
  oil_production_table <- oil_production_table[[1]] 
  
  # Hold on to the original, computer unfriendly names for later
  old_colnames <- colnames(oil_production_table)
  
  # Now, clean up the names with the janitor clean_names function to make it easier to 
  # work with the columns in the meantime
  
  oil_production_table %<>% # This %<>% operator means assign whatever you do back to the starting variable.
    clean_names()           # In this case, it's equivalent to:
                            # oil_production_table <- clean_names(oil_production_table)
  
  # Put the old column names, and the table into a list that can be passed onto later functions for cleaning/display
  res <- list(old_names = old_colnames, 
              oil_table = oil_production_table)
  
  # And return this list
  return(res)
}
