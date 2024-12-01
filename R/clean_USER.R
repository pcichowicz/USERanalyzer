#' Clean USER data
#'
#' @description Used to clean and prepare USER treatment libraries after sequencing and basic
#' statistic summaries
#' @param dataframe df containing data from USER treatment
#'
#' @return a cleaned df for plotting
#' @export

# Ensure colnames are properly named (include correct col type)
# Depending on if bash script makes the txt with all summaries,
#   add new vectors with summaries.

# Variable types ----------------------------------------------------------

var_factors <- c("Age",
                 "Treatment",
                 "Haplotype",
                 "Assignment")

# Function ----------------------------------------------------------------

clean_USER <- function(user_dataframe, clean_type = NULL) {

  if (!is.data.frame(user_dataframe)) {
    stop("`clean_USER` reqires a data.frame.", call. = FALSE)
  }

# Cleaning data.frame -----------------------------------------------------



  if (is.null(clean_type)) {
    # default cleaning --------------------------------------------------------
    cleaned <- user_dataframe %>%
      janitor::clean_names(case = "snake")
  } else {
    # arg cleaning ------------------------------------------------------------
    cleaned <- user_dataframe %>%
      janitor::clean_names(case = clean_type)
  }

}
