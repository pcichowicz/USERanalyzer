#' Plot Quality-Control density plots
#'
#' @description This function generates a density plot for quality control visualization after NGS,
#' prior to downstream analysis grouped by Treatment. It can optionally plot statistical information such as
#' mean and quantiles.
#'
#' @param data_frame_user project data frame
#' @param qc_sheet Name of dataframe from project_dataframe. Default value = "Statistics".
#' @param variable_col Name of summary statistic for plotting.
#' @param treatment_group Logical, whether to group by the "Treatment" column. Default is TRUE.
# #' @param qc_type Simple or with statistics plotted. Default = NULL, simple plot.
#'
#' @importFrom dplyr summarise mutate filter
#' @importFrom colorspace darken
#' @import ggplot2
#' @return Single ggplot object. Distribution of selected summary statistic for Quality control
#' @export

plot_qc_group <- function(data_frame_user,
                    qc_sheet = "Statistics",
                    variable_col,
                    treatment_group = TRUE
) {


  # Create density data frame (grouped by Treatment)
  # Calculate means for each Treatment group, density data and mean value at y

  density_data <- compute_density_data(data_frame_user[[qc_sheet]], variable_col, group_by_treatment = treatment_group)

  # Base density plot
  distribution_plot <- data_frame_user[[qc_sheet]] %>%
    ggplot(
      aes(x = .data[[variable_col]],
          color = Treatment
      )) +
    geom_density(
      aes(fill = factor(Treatment)), alpha = 0.4) +
    theme_classic() +
    labs(#title = paste0("Quality Control Distribution plot - ", variable_col),
         x = named_columns[variable_col],
         y = "Density / Proportion",
         fill = "Treatment") +
    scale_y_continuous(limits = range(pretty(density_data[["densityframe"]][[1]]$y)),
                       breaks = pretty(density_data[["densityframe"]][[1]]$y)) +
    scale_x_continuous(limits = range(pretty(data_frame_user[[qc_sheet]][[variable_col]], n = 11)),
                       breaks = pretty(data_frame_user[[qc_sheet]][[variable_col]], n = 10),
                       guide = guide_axis(angle = 45)) +
    theme(legend.position = c(.9,.75)) +
    scale_fill_manual(values = darken(c("#440154FF", "#8FD744FF", "#FF8C00"), 0.4),
                      labels = treat_labs) +
    scale_color_manual(values = darken(c("#440154FF", "#8FD744FF", "#FF8C00")), 0.4) +
    guides(color = "none")


  return(distribution_plot) # Returns either base or adv plot based on passed arguments

}
