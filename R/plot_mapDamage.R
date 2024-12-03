#' Plot mapDamage misincorporation rates
#'
#' @description Visualization of damage patterns in ancient DNA, showing misincorporation rates at the 5' (left)
#' and 3' (right) ends of the sequences for one or multiple samples.
#'
#' @param dataframe_data A list of data frames containing the complete data, including the mapdamage data sheet.
#' @param mapdamage_data A character string specifying the name of the mapdamage data sheet in `dataframe_data`. Default is "mapdamage".
#' @param sample_name The sample name to plot (as a character string). If set to FALSE (default), plots are generated for all samples.
#' @param sample_column The name of the column in the mapdamage data sheet that contains sample IDs. Default is "samp".
#' @param treatment The name of the column in the mapdamage data sheet that specifies treatment groups. Default is "Treatment".
#' @param col_pal A vector of colors to use for the treatment groups. If NULL, default colors are used.
#'
#' @return A named list of ggplot objects, where each element corresponds to a sample's combined plots.
#'
#' #' @examples
#' # Example usage:
#' # Assume `complete_data` is a list containing a "mapdamage" data frame with columns
#' # "pos", "C_T5p", "G_A3p", "samp", and "Treatment".
#' plot_list <- plot_mapDamage(dataframe_data = complete_data)
#'
#' # Generate plots for a specific sample
#' plot_list <- plot_mapDamage(dataframe_data = complete_data, sample_name = "Sample_1")
#'
#' @export

plot_mapDamage <- function(dataframe_data,
                           mapdamage_data = "mapdamage",
                           sample_name = FALSE,
                           sample_column = "samp",
                           treatment = "Treatment",
                           col_pal = aDNA_pal) {

  # Index into mapdamge dataframe and create new dataframe containing individual samples
  # If sample_name = FALSE, split data by `sample_column`

  if (isFALSE(sample_name)) {
    split_samples <- split(dataframe_data[[mapdamage_data]],
                           dataframe_data[[mapdamage_data]][[sample_column]])
  } else {
    split_samples <- setNames(
      list(dataframe_data[[mapdamage_data]][dataframe_data[[mapdamage_data]][[sample_column]] == sample_name, ]),
      sample_name

    )
  }

  # Create named vector for setting Treatment colors

  treatment_colors <- setNames(col_pal[c(1,2,3)], c("E", "U_10", "U_2.5"))

  # Determine y_limits for y axis symmetry for each individual samples

  y_limit <- lapply(split_samples, function(samp_name) {
    y_axis_range <- round(range(pretty(samp_name[["C_T5p"]]),
                                pretty(samp_name[["G_A3p"]])), 2)
    c(y_axis_range[1], ceiling(y_axis_range[2] / 0.05) * 0.05)
  })

  # Dataframe containing list of individual ggplots
  plot_list <- sapply(names(split_samples), simplify = FALSE, function(sample_id){

    anno_df <- split_samples[[sample_id]] %>%
      filter(pos == 1) %>%
      select(Treatment, C_T5p, G_A3p)

    y_limit <- y_limit[[sample_id]]

    pos1_diff <- split_samples[[sample_id]]

    # ggplot for C to T transitions, 5 prime end
    C_T <- ggplot(
      data = split_samples[[sample_id]],
      aes(
        x = pos,
        y = C_T5p
      )
    ) +
      geom_line(
        aes(
          group = .data[[treatment]],
          color = .data[[treatment]]
        ),
        linewidth = 1
      ) +
      annotate("path",
               x = c(2,4,4,2),
               y =c(anno_df %>%
                      filter(Treatment == "E") %>%
                      pull(C_T5p),
                    anno_df %>%
                      filter(Treatment == "E") %>%
                      pull(C_T5p),
                    anno_df %>%
                      filter(Treatment == "U_2.5") %>%
                      pull(C_T5p),
                    anno_df %>%
                      filter(Treatment =="U_2.5") %>%
                      pull(C_T5p)),
               color = "black",
               size = 1,
               alpha = 0.5,
               linetype = "22") +
      annotate("path",
               x = c(4, 4, 2),
               y =c(anno_df %>%
                      filter(Treatment == "U_2.5") %>%
                      pull(C_T5p),
                    anno_df %>%
                      filter(Treatment == "U_10") %>%
                      pull(C_T5p),
                    anno_df %>%
                      filter(Treatment == "U_10") %>%
                      pull(C_T5p)),
               color = "black",
               size = 1,
               alpha = 0.25,
               linetype = "22") +
      annotate("text",
               x = 6,
               y = (anno_df %>%
                      filter(Treatment == "E") %>%
                      pull(C_T5p) + anno_df %>%
                      filter(Treatment == "U_2.5") %>%
                      pull(C_T5p)) / 2,
               label = round(((anno_df[["C_T5p"]][3] - anno_df[["C_T5p"]][1]) / anno_df[["C_T5p"]][3]) * 100, digits = 1)
               ) +
      annotate("text",
               x = 6,
               y = (anno_df %>%
                      filter(Treatment == "U_2.5") %>%
                      pull(C_T5p) + anno_df %>%
                      filter(Treatment == "U_10") %>%
                      pull(C_T5p)) / 2,
              label = round(((anno_df[["C_T5p"]][3] - anno_df[["C_T5p"]][2]) / anno_df[["C_T5p"]][3]) * 100, digits = 1)) +
      theme_classic() +
      scale_x_continuous(
        limits = c(1,25),
        breaks = c(seq(1,25, by = 1))
      ) +
      scale_y_continuous(limits = y_limit,
                         breaks = seq(y_limit[1], y_limit[2], by = 0.05)
      ) +
      theme(legend.position = "none",
            axis.title.x = element_text(size = 15, margin = margin(12,0,0,0)),
            axis.text.x = element_text(
              angle = 90),
            axis.title.y = element_text(size = 15, margin = margin(0,12,0,0)),
            axis.text.y = ggtext::element_markdown()
      ) +
      scale_color_manual(values = darken(col_pal, 0.15)) +
      labs(x = "5' Position",
           y = "Frequency of C to T")

    # ggplot for G to A transitions, 3 prime end, with reversed x-axis
    G_A <- ggplot(
      data = split_samples[[sample_id]],
      aes(x = pos,
          y = G_A3p
      )
    ) +
      geom_line(
        aes(group = .data[[treatment]],
            color = .data[[treatment]]
        ),
        linewidth = 1
      ) +
      theme_classic() +
      theme(legend.position = "none",
            axis.title.x = element_text(size = 15, margin = margin(12,0,0,0)),
            axis.title.y = element_text(size = 15, margin = margin(0,0,0,-12)),
            # axis.text.y = ggtext::element_markdown(),
            axis.text.x = element_text(angle = 90)
            ) +
      scale_x_reverse(breaks = c(seq(1,25, by = 1))
                      ) +
      scale_y_continuous(position = "right",
                         limits = y_limit,
                         breaks = seq(y_limit[1], y_limit[2], by = 0.05)
                         ) +
      scale_color_manual(values = darken(col_pal, 0.15)) +
      theme(legend.position = "none") +
      labs(x = "3' Position",
           y = "Frequency of G to A") +
    annotate("path",
             x = c(2,4,4,2),
             y =c(anno_df %>%
                    filter(Treatment == "E") %>%
                    pull(G_A3p),
                  anno_df %>%
                    filter(Treatment == "E") %>%
                    pull(G_A3p),
                  anno_df %>%
                    filter(Treatment == "U_2.5") %>%
                    pull(G_A3p),
                  anno_df %>%
                    filter(Treatment =="U_2.5") %>%
                    pull(G_A3p)),
             color = "black",
             size = 1,
             alpha = 0.5,
             linetype = "22") +
      annotate("path",
               x = c(4, 4, 2),
               y =c(anno_df %>%
                      filter(Treatment == "U_2.5") %>%
                      pull(G_A3p),
                    anno_df %>%
                      filter(Treatment == "U_10") %>%
                      pull(G_A3p),
                    anno_df %>%
                      filter(Treatment == "U_10") %>%
                      pull(G_A3p)),
               color = "black",
               size = 1,
               alpha = 0.25,
               linetype = "22") +
      annotate("text",
               x = 6,
               y = (anno_df %>%
                      filter(Treatment == "E") %>%
                      pull(G_A3p) + anno_df %>%
                      filter(Treatment == "U_2.5") %>%
                      pull(G_A3p)) / 2,
               label = round(((anno_df[["G_A3p"]][3] - anno_df[["G_A3p"]][1]) / anno_df[["G_A3p"]][3]) * 100, digits = 1)
      ) +
      annotate("text",
               x = 6,
               y = (anno_df %>%
                      filter(Treatment == "U_2.5") %>%
                      pull(G_A3p) + anno_df %>%
                      filter(Treatment == "U_10") %>%
                      pull(G_A3p)) / 2,
               label = round(((anno_df[["G_A3p"]][3] - anno_df[["G_A3p"]][2]) / anno_df[["G_A3p"]][3]) * 100, digits = 1)
      )

    # Merge both 5 and 3 prime ggplots together
    combine_plot <- plot_grid(C_T, G_A,
                              align = "h",
                              axis = "tb",
                              rel_heights = c(1,1))

    return(combine_plot)

  })

  return(plot_list)
}
