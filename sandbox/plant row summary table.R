tar_load(plant_row_data)


plant_row_summary <- plant_row_data %>% 
  select(cross, yield, seed_weight, oil_dry_basis, protein_dry_basis) %>% 
  pivot_longer(cols = c(yield, seed_weight, oil_dry_basis, protein_dry_basis), names_to = "pheno") %>% 
  dplyr::filter(!is.na(cross)) %>%
  group_by(cross, pheno) %>% 
  summarise(Average   = mean(value, na.rm = TRUE), 
            min_value = min(value, na.rm = TRUE), 
            max_value = max(value, na.rm = TRUE), 
            Range     = paste(min_value, max_value, sep = " - "), 
            Var       = var(value, na.rm = TRUE)) %>% 
  select(cross, pheno, Average, Range, Var) %>%
  ungroup() %>%
  mutate(pheno = recode(pheno, 
                        "oil_dry_basis"     = "Oil", 
                        "protein_dry_basis" = "Protein", 
                        "seed_weight"       = "SDWT", 
                        "yield"             = "Bulk Weight")) %>%
  pivot_wider(names_from = pheno, values_from = c(Average, Range, Var), names_sort = TRUE, names_vary = "slowest") %>% 
  arrange(desc(Average_Protein)) %>% 
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

pheno_name_test <- map(colnames(plant_row_summary)[2:ncol(plant_row_summary)], get_pheno_name)

test <- map_chr(pheno_name_test, function(x) pluck(x, "pheno")) %>% rle()

c(" ", test$lengths %>% set_names(test$values))


# A function that makes a kable table with a grouped header above each of the phenotypes
make_kable_table <- function(phenotype_summary){
  
  pheno_col_indices <- map(colnames(phenotype_summary)[2:ncol(phenotype_summary)], get_pheno_name)
  
  # Make a vector of header spans
  pheno_rle    <- test <- map_chr(pheno_col_indices, function(x) pluck(x, "pheno")) %>% rle()
  header_spans <- c(" ", test$lengths %>% set_names(test$values))
  
  # Use the footnote_marker_alphabet to add footnote symbols to the header spanners
  names(header_spans)[2] <- paste0(names(header_spans)[2], footnote_marker_alphabet(1))
  
  # The column names without the phenotypes appended
  col_names_no_pheno <- map_chr(pheno_col_indices, function(x) pluck(x, "var_type"))
  
  new_colnames <- colnames(phenotype_summary)
  new_colnames[2:ncol(phenotype_summary)] <- col_names_no_pheno

  colnames(phenotype_summary) <- new_colnames
  
  kbl_table <- phenotype_summary %>% 
    kable(booktabs = TRUE, caption = "Mian Plant Rows Cross Summary 2021", digits = 2, align = rep('c', ncol(phenotype_summary))) %>%
    kable_styling(full_width = TRUE, position = "center") %>%
    add_header_above(header = header_spans)
  
  return(kbl_table)
}

