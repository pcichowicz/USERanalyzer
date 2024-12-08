% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_mapDamage.R
\name{plot_mapDamage}
\alias{plot_mapDamage}
\title{Plot mapDamage misincorporation rates}
\usage{
plot_mapDamage(
  dataframe_data,
  mapdamage_data = "mapdamage",
  sample_name = FALSE,
  sample_column = "samp",
  treatment = "Treatment",
  col_pal = NULL
)
}
\arguments{
\item{dataframe_data}{A list of data frames containing the complete data, including the mapdamage data sheet.}

\item{mapdamage_data}{A character string specifying the name of the mapdamage data sheet in `dataframe_data`. Default is "mapdamage".}

\item{sample_name}{The sample name to plot (as a character string). If set to FALSE (default), plots are generated for all samples.}

\item{sample_column}{The name of the column in the mapdamage data sheet that contains sample IDs. Default is "samp".}

\item{treatment}{The name of the column in the mapdamage data sheet that specifies treatment groups. Default is "Treatment".}

\item{col_pal}{A vector of colors to use for the treatment groups. If NULL, default colors are used.}
}
\value{
A named list of ggplot objects, where each element corresponds to a sample's combined plots.

#' @examples
# Example usage:
# Assume `complete_data` is a list containing a "mapdamage" data frame with columns
# "pos", "C_T5p", "G_A3p", "samp", and "Treatment".
plot_list <- plot_mapDamage(dataframe_data = complete_data)

# Generate plots for a specific sample
plot_list <- plot_mapDamage(dataframe_data = complete_data, sample_name = "Sample_1")
}
\description{
Visualization of damage patterns in ancient DNA, showing misincorporation rates at the 5' (left)
and 3' (right) ends of the sequences for one or multiple samples.
}
