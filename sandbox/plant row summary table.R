tar_load(plant_row_data)


plant_row_summary <- plant_row_data %>% 
  select(cross, yield, seed_weight, oil_dry_basis, protein_dry_basis) %>% 
  pivot_longer(cols = c(yield, seed_weight, oil_dry_basis, protein_dry_basis), names_to = "pheno") %>% 
  group_by(cross, pheno) %>% 
  summarise(avg_value = mean(value, na.rm = TRUE), 
            min_value = min(value, na.rm = TRUE), 
            max_value = max(value, na.rm = TRUE), 
            Range     = paste(min_value, max_value, sep = " - "), 
            Var       = var(value, na.rm = TRUE)) %>% 
  select(cross, pheno, avg_value, Range, Var) %>%
  ungroup() %>%
  mutate(pheno = recode(pheno, 
                        "oil_dry_basis"     = "Oil", 
                        "protein_dry_basis" = "Protein", 
                        "seed_weight"       = "SDWT", 
                        "yield"             = "Bulk Weight")) %>%
  pivot_wider(names_from = pheno, values_from = c(avg_value, Range, Var), names_sort = TRUE, names_vary = "slowest") %>% 
  arrange(desc(avg_value_Protein)) %>% 
  rename(Cross = cross)


# A function to get the phenotype name from a column name
get_pheno_name <- function(column_name){
  
  # Split the column name using underscores
  split_name <- str_split(column_name, 
                          pattern = "_")[[1]]
  
  # The phenotype name 
  pheno_name <- split_name[[length(split_name)]]
  
  # And remove this phenotype from the column name
  column_name_no_pheno <- str_remove(column_name, paste0("_", pheno_name))
  
  return(list(pheno    = pheno_name, 
              var_type = column_name_no_pheno))
}
