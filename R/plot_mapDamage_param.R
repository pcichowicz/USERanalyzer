#' Plotting mapDamage parameters used to characterize ancient DNA
#'
#' @description Plots the 4 damage parameters used for the bayesian statistics for determining
#' the aDNA damage characterisitics.
#'
#' @param mapdam_params df
#' @param parameter parameter to plot
#' @param metric using mean metric
#'
#' @return
#' @export

plot_mapDamage_param <- function(mapdam_params, parameter, metric = "Mean"){

  limits <- c(min(mapdam_params[[parameter]]), max(mapdam_params[[parameter]]))

  params_plot <- ggplot(data = subset(mapdam_params %>% filter(Metric == metric)),
         aes(y = .data[["Treatment"]],
             x = .data[[parameter]],
             fill = Treatment)) +
    geom_density_ridges(scale = 0.9) +
    scale_y_discrete(labels = treat_labs) +
    scale_fill_manual(values = darken(aDNA_pal, 0.3)) +
    theme_classic() +
    guides(fill = "none")

  return(params_plot)
}
