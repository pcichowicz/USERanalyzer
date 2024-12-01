#' Plot Quality-Control density plots
#' @description This function generates a density plot for quality control visualization after NGS,
#' prior to downstream analysis. It can optionally plot statistical information such as
#' mean and quantiles.
#'
#' @param project_dataframe project data frame (list of all dataframe).
#' @param qc_sheet Name of dataframe from project_dataframe. Default value = "Statistics".
#' @param qc_fill Color for ggplot density fill. Default = "#8FD744FF". #440154FF, #FF8C00
#' @param qc_type Simple or with statistics plotted. Default = NULL, simple plot.
#' @param variable_col Name of summary statistic for plotting.
#'
#' @importFrom dplyr summarise mutate filter
#' @importFrom colorspace darken
#' @import ggplot2
#' @return List of 2 ggplot objects
#' @export

plot_qc <- function(project_dataframe,
                    qc_sheet = "Statistics",
                    variable_col,
                    qc_fill = "#FF8C00",
                    qc_type = NULL
                    ) {

  # Create density data frame
  density_data <- compute_density_data(project_dataframe[[qc_sheet]], variable_col, group_by_treatment = FALSE)

  # Base density plot
  distribution_plot <- project_dataframe[[qc_sheet]] %>%
    ggplot(
      aes(x = .data[[variable_col]]
      )) +
    geom_density(fill =  if (is.null(qc_fill)) NA else qc_fill) +
    theme_classic() +
    labs(x = named_columns[variable_col],
         y = "Density / Proportion") +
    scale_y_continuous(limits = range(pretty(density_data[["densityframe"]][[1]]$y)),
                       breaks = pretty(density_data[["densityframe"]][[1]]$y)) +
    scale_x_continuous(limits = range(pretty(project_dataframe[[qc_sheet]][[variable_col]], n = 11)),
                       breaks = pretty(project_dataframe[[qc_sheet]][[variable_col]], n = 10),
                       guide = guide_axis(angle = 45)) +
    theme(legend.position = "none")

  # Plot more advanced statistics QC plot, when qc_type != NULL

  density_fill <- data.frame(x = density_data[["densityframe"]][[1]]$x,
                             y = density_data[["densityframe"]][[1]]$y) %>%
    filter(x >= quantile(project_dataframe[[qc_sheet]][[variable_col]], 0.25) & x <= quantile(project_dataframe[[qc_sheet]][[variable_col]], 0.75))

  if (!is.null(qc_type)) {
    distribution_plot <- distribution_plot +
      geom_area(data = density_fill,
                aes(x = x,
                    y = y),
                fill = darken(qc_fill, 0.4)) +
      geom_segment(data = density_data,
                   aes(x = density_mean,
                       xend = density_mean,
                       y = 0,
                       yend = density_mean_at_y),
                   linetype = "dashed") +
      geom_segment(data = density_data,
                   aes(x = q1,
                       xend = q1,
                       y = 0,
                       yend = q1_at_y),
                   linetype = "dotted") +
      geom_segment(data = density_data,
                   aes(x = q3,
                       xend = q3,
                       y = 0,
                       yend = q3_at_y),
                   linetype = "dotted")


  }

  return(distribution_plot) # Returns either base or adv plot based on passed argument

}
