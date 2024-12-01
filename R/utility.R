#' Compute Density Data for Plotting
#'
#' @description Calculates density data, mean, and quantile information for a specified column
#' in a dataframe, which can be used for plotting density plots with additional statistics.
#'
#' @param data A dataframe containing the data.
#' @param variable_col Name of the column for which to compute density statistics.
#' @param q1_quantile Quantile for the lower bound. Default is 0.25.
#' @param q3_quantile Quantile for the upper bound. Default is 0.75.
#' @param group_by_treatment Logical, whether to group by the "Treatment" column. Default is FALSE.
#'
#' @return A dataframe containing density data, mean, and quantile y-values.
#' @export
#'
#' @importFrom dplyr summarise mutate group_by
#' @importFrom stats density approx quantile
compute_density_data <- function(data,
                                 variable_col,
                                 group_by_treatment = FALSE,
                                 q1_quantile = 0.25,
                                 q3_quantile = 0.75) {

  # Check if function is needed for grouped plot, group_by_treatment = TRUE
  if(group_by_treatment && "Treatment" %in% colnames(data)) {
    data <- data %>% group_by(Treatment)
  }

  # Compute density, mean, and quantiles
  density_data <- data %>%
    summarise(
      density_mean = mean(.data[[variable_col]], na.rm = TRUE),
      densityframe = list(density(.data[[variable_col]])),
      q1 = quantile(.data[[variable_col]], q1_quantile),
      q3 = quantile(.data[[variable_col]], q3_quantile)
    ) %>%
    mutate(
      density_mean_at_y = approx(densityframe[[1]]$x, densityframe[[1]]$y, xout = density_mean)$y,
      q1_at_y = approx(densityframe[[1]]$x, densityframe[[1]]$y, xout = q1)$y,
      q3_at_y = approx(densityframe[[1]]$x, densityframe[[1]]$y, xout = q3)$y
    )

  # Convert to a dataframe and return
  return(as.data.frame(density_data))
}


