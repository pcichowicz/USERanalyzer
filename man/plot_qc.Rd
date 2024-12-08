% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_qc.R
\name{plot_qc}
\alias{plot_qc}
\title{Plot Quality-Control density plots}
\usage{
plot_qc(
  project_dataframe,
  qc_sheet = "Statistics",
  variable_col,
  qc_fill = "#FF8C00",
  qc_type = NULL
)
}
\arguments{
\item{project_dataframe}{project data frame (list of all dataframe).}

\item{qc_sheet}{Name of dataframe from project_dataframe. Default value = "Statistics".}

\item{variable_col}{Name of summary statistic for plotting.}

\item{qc_fill}{Color for ggplot density fill. Default = "#8FD744FF". #440154FF, #FF8C00}

\item{qc_type}{Simple or with statistics plotted. Default = NULL, simple plot.}
}
\value{
List of 2 ggplot objects
}
\description{
This function generates a density plot for quality control visualization after NGS,
prior to downstream analysis. It can optionally plot statistical information such as
mean and quantiles.
}
