#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param soystats_oil_data
#' @return
#' @author 'Jay
#' @export
make_soystats_gt <- function(soystats_oil_data) {

  soystats_gt <- soystats_oil_data$oil_table %>% # First assign the old column names back to the data
    set_names(soystats_oil_data$old_names) %>% 
    gt() %>%                                                      # Make the gt object
    tab_header(title = "U.S. Soybean Meal Production 1992-2020",  # Add a header with a title and subtitle
               subtitle = "Source: USDA, WAOB") %>% 
    tab_spanner(                                                  # Add a couple spanners to groups of columns that were in the data, 
      label = "Weights",                                          # one for weights and one for money
      columns = c(`Million Short Tons`, `Million Metric Tons`)
    ) %>%
    tab_spanner(
      label = "Money",
      columns = c(`Avg $ Per Short Ton`, `Avg $ Per Metric Ton`)
    ) %>% 
    tab_footnote(                                                          # Now, add some footnotes to describe columns/column groups. 
      footnote = "The numbers in this column are talking about the year",  # This first one identifies the column directly with the 'cells_column_labels' function
      locations = cells_column_labels(
        columns = Year
      )
    ) %>% 
    tab_footnote(                                                          # You can also pass multiple columns for the same footnote using the same function. 
      footnote = "And these ones are talking about cash money.",           # You do have to use the backticks ` ` for these column names since they have spaces and fancy characters
      locations = cells_column_labels(
        columns = c(`Avg $ Per Short Ton`, `Avg $ Per Metric Ton`)
      )
    ) %>%
    tab_footnote(                                                         # Footnotes can also be added to the column spanners instead by giving the name of the spanner to the
      footnote = "These columns are talking about weights or something.", # 'cells_column_spanners' function
      locations = cells_column_spanners(
        spanners = "Weights"
      )
    )
  
  # The table can also be converted to latex 
  soystats_gt_latex <- as_latex(soystats_gt)
  
  # Return both in a list
  res <- list(soystats_html_table  = soystats_gt, 
              soystats_latex_table = soystats_gt_latex)
  
  # And return this list
  return(res)
}
