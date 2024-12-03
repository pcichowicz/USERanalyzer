#' Plots point,density and boxplots side-by-side per treatment
#'
#' @param user_dataframe data frame for plotting
#' @param stats_dataframe dataframe from main dataframe used for statistical plot
#' @param observation_name Statistical variable for plotting
#' @param treatment group-by variable for ggplot aesthetics
#' @param col_pal Color palette to be used for treatment colors
#' @param ...
#'
#' @return ggplot object
#' @export
#'
#' @examples
#' raincloud_plot(data_frame, "ReadLenTrim")
plot_raincloud <- function(user_dataframe,
                           stats_dataframe = "Statistics",
                           observation_name,
                           treatment = "Treatment",
                           col_pal = aDNA_pal,
                           ...) {

  y_axis_label <- named_columns[observation_name]

  ggplot(data = user_dataframe[[stats_dataframe]],
         aes(x = .data[[treatment]],
             y = .data[[observation_name]])) +
    geom_boxplot(
      aes(
        color = .data[[treatment]]),
      width = 0.15,
      outlier.shape = NA
    ) +
    stat_halfeye(aes(
      fill = .data[[treatment]]
    ),
    adjust = 0.75,
    width = .5,
    .width = 0,
    justification = -0.4,
    point_color = NA
    ) +
    geom_half_point(
      aes(color = .data[[treatment]]),
      side = "1",
      range_scale = 0.3,
      alpha = 0.5
    ) +
    theme_classic() +
    theme(axis.title.x = element_text(size = 15,
                                      vjust = -0.75), # adjust margin spacing between title and plot
          axis.title.y = element_text(size = 15,
                                      vjust = 3),
          plot.margin = margin(10,10,10,10)) + # add extra margin space of plot
    labs(y = y_axis_label) +
    scale_y_continuous(limits = range(pretty(user_dataframe[[stats_dataframe]][[observation_name]])),
                       breaks = pretty(user_dataframe[[stats_dataframe]][[observation_name]])) +
    scale_x_discrete(labels = treat_labs) +
    scale_color_manual(values = darken(col_pal, 0.05), guide = "none") +
    scale_fill_manual(values = darken(col_pal,0.05), guide = "none")

}
