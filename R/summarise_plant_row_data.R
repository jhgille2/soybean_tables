#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param plant_row_data
#' @return
#' @author 'Jay
#' @export
summarise_plant_row_data <- function(plant_row_data) {

  # A simple summary table of average phenotype values by cross
  plant_row_summary <- plant_row_data %>% 
    select(cross, yield, seed_weight, oil_dry_basis, protein_dry_basis) %>% 
    pivot_longer(cols = c(yield, seed_weight, oil_dry_basis, protein_dry_basis), names_to = "pheno") %>% 
    group_by(cross, pheno) %>% 
    summarise(avg_value = mean(value, na.rm = TRUE)) %>% 
    ungroup() %>%
    mutate(pheno = recode(pheno, 
                          "oil_dry_basis"     = "Oil", 
                          "protein_dry_basis" = "Protein", 
                          "seed_weight"       = "SDWT", 
                          "yield"             = "Bulk Weight")) %>%
    pivot_wider(names_from = pheno, values_from = avg_value) %>% 
    arrange(desc(Protein)) %>% 
    rename(Cross = cross)
  

}
