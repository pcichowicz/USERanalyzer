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

  # If sample_name = FALSE, split data by samp (sample names)

  if (isFALSE(sample_name)) {
    split_samples <- split(dataframe_data[[mapdamage_data]],
                           dataframe_data[[mapdamage_data]][[sample_column]])
  } else {
    split_samples <- setNames(
      list(dataframe_data[[mapdamage_data]][dataframe_data[[mapdamage_data]][[sample_column]] == sample_name, ]),
      sample_name

      )
  }

  treatment_colors <- setNames(col_pal[c(1,2,3)], c("E", "U_10", "U_2.5"))

  # Determine y_limits for y axis symmetry for individual samples

  y_limit <- lapply(split_samples, function(samp_name) {
    y_axis_range <- round(range(pretty(samp_name[["C_T5p"]]),
          pretty(samp_name[["G_A3p"]])), 2)
    c(y_axis_range[1], ceiling(y_axis_range[2] / 0.05) * 0.05)
  })

  plot_list <- sapply(names(split_samples), simplify = FALSE, function(sample_id){

    anno_df <- split_samples[[sample_id]] %>%
      filter(pos == 1) %>%
      select(Treatment, C_T5p, G_A3p)

    y_limit <- y_limit[[sample_id]]

    # y_breaks_ct <- unique(c(y_limit, round(anno_df %>% pull(C_T5p), 2)))
    # y_breaks_ga <- unique(c(pretty(y_limit), round(anno_df %>% pull(G_A3p), 2)))

    # y_colors_ct <- setNames(rep("black", length(y_breaks_ct)), y_breaks_ct)
    # y_colors_ga <- setNames(rep("black", length(y_breaks_ga)), y_breaks_ga)

    # special_ct <- round(anno_df$C_T5p, 2)
    # special_ga <- round(anno_df$G_A3p, 2)

    # y_colors_ct[as.character(special_ct)] <- darken(treatment_colors[anno_df$Treatment], 0.15)
    # y_colors_ga[as.character(special_ga)] <- darken(treatment_colors[anno_df$Treatment], 0.15)


    # Create difference of C_T position 1 values df
    # difference_df <- split_samples %>%
    #   filter(pos == 1)


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
               label = "2.5") +
      annotate("text",
               x = 6,
               y = (anno_df %>%
                 filter(Treatment == "U_2.5") %>%
                 pull(C_T5p) + anno_df %>%
                 filter(Treatment == "U_10") %>%
                 pull(C_T5p)) / 2,
               label = "10") +
        theme_classic() +
        scale_x_continuous(
          limits = c(1,25),
          breaks = c(seq(1,25,
                         by = 1))) +
        scale_y_continuous(limits = y_limit,
                           breaks = seq(y_limit[1], y_limit[2], by = 0.05),
                           # labels = function(break_values) {
                           #   sapply(break_values, function(value) {
                           #     color <- y_colors_ct[as.character(value)]
                           #     paste0("<span style='color:", color, "'>", value, "</span>")
                           #   })
                           # }
        ) +
        theme(legend.position = "none",
              axis.title.x = element_text(size = 15, margin = margin(12,0,0,0)),
              axis.text.x = element_text(
                                         size = 10,
                                         angle = 90),
              axis.title.y = element_text(size = 15, margin = margin(0,12,0,0)),
              axis.text.y = ggtext::element_markdown()
               ) +
        scale_color_manual(values = darken(col_pal, 0.15)) +
        labs(x = "5' Position",
             y = "Frequency of C to T")

    # 3' G > A transitions, with reversed x-axis
    G_A <- ggplot(
      data = split_samples[[sample_id]],
      aes(
        x = pos,
        y = G_A3p
      )
    ) +
      geom_line(
        aes(
          group = .data[[treatment]],
          color = .data[[treatment]]
        ),
        linewidth = 1
      ) +
      # geom_label(
      #   data = split_samples[[sample_id]] %>%
      #     filter(pos == 1),
      #   aes(
      #     label = round(G_A3p, 3),
      #     group = .data[[treatment]],
      #     color = .data[[treatment]]
      #   ),
      #   nudge_x = -2,
      #   nudge_y = 0.01
      # ) +
      # annotate(
      #   'curve',
      #   x = 1,
      #   y = 0.02,
      #   xend = 1,
      #   yend = 0.25,
      #   linewidth = 1,
      #   curvature = -0.2,
      #   alpha = 0.5
      # ) +
      # annotate(
      #   'curve',
      #   x = 1,
      #   y = 0.072,
      #   xend = 1,
      #   yend = 0.25,
      #   linewidth = 1,
      #   linetype = "dashed",
      #   curvature = -0.2,
      #   alpha = + 0.5
      # ) +
      theme_classic() +
      theme(legend.position = "none",
            axis.title.x = element_text(size = 15, margin = margin(12,0,0,0)),
            axis.title.y = element_text(size = 15, margin = margin(0,0,0,-12)),
            axis.text.y = ggtext::element_markdown(),
            axis.text.x = element_text(angle = 90)) +
      scale_x_reverse(breaks = c(seq(1,25, by = 1))) +
      scale_y_continuous(position = "right",
                         limits = y_limit,
                         breaks = seq(y_limit[1], y_limit[2], by = 0.05)
                         # breaks = y_breaks_ga,
                         # labels = function(break_values) {
                         #   sapply(break_values, function(value) {
                         #     color <- y_colors_ga[as.character(value)]
                         #     paste0("<span style='color:", color, "'>", value, "</span>")
                         #   })
                         # }
    ) +
      scale_color_manual(values = darken(col_pal, 0.15)) +
      theme(legend.position = "none") +
      labs(x = "3' Position",
           y = "Frequency of G to A")

    combine_plot <- plot_grid(C_T, G_A,
              align = "h",
              axis = "tb",
              rel_heights = c(1,1))

    return(combine_plot)

  })

  return(plot_list)
}
