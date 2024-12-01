#' Load User Reduction data
#'
#' @description
#' This function takes in the excel path and creates a list of data frames from
#' the sheet names and updates columns to have correct types
#' @param excel_path Path to the excel  file
#'
#' @importFrom  magrittr %>%
#' @importFrom dplyr across all_of mutate
#' @return List of cleaned data frames for analysis
#' @export
#'

load_df_user <- function(excel_path){

  # List of factor variables
  statistic_factors <- c("Age", "Treatment", "Haplotype", "Assignment")
  mapdamage_factors <- c("Treatment")
  mapdamage_parameters_factors <- c("Metric")
  e_u_factors <- c("Position")

  # Get names of sheets to iterate
  sheet_names <- readxl::excel_sheets(excel_path)

  # Read all sheets into a list of data frames
  complete_data <- sapply(sheet_names, function(sheet) {
    readxl::read_excel(path = excel_path, sheet = sheet)
  })

  # Create separate temp data frames for converting
  statistics_df <- complete_data[["Statistics"]]
  mapdamage_df <- complete_data[["mapdamage"]]
  mapdamage_parameters_df <- complete_data[["mapdamage_parameters"]]
  e_u_pos123_df <- complete_data[["E-U pos1-3"]]

  # Convert specific columns to factors
  statistics_df <- statistics_df %>%
    mutate(across(all_of(statistic_factors), as.factor))

  mapdamage_df <- mapdamage_df %>%
    mutate(across(all_of(mapdamage_factors), as.factor))

  mapdamage_parameters_df <- mapdamage_parameters_df %>%
    mutate(across(all_of(mapdamage_parameters_factors), as.factor))

  e_u_pos123_df <- e_u_pos123_df %>%
    mutate(across(all_of(e_u_factors), as.factor))

  # Update complete data frame with converted columns
  complete_data[["Statistics"]] <- statistics_df
  complete_data[["mapdamage"]] <- mapdamage_df
  complete_data[["mapdamage_parameters"]] <- mapdamage_parameters_df
  complete_data[["E-U pos1-3"]] <- e_u_pos123_df

  return(complete_data)
}
