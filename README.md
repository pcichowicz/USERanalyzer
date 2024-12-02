# USERanalyzer

[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

[![CRAN
status](https://www.r-pkg.org/badges/version/USERanalyzer)](https://CRAN.R-project.org/package=USERanalyzer)


![Markdown](https://img.shields.io/badge/markdown-%23000000.svg?style=for-the-badge&logo=markdown&logoColor=white) ![R](https://img.shields.io/badge/r-%23276DC3.svg?style=for-the-badge&logo=r&logoColor=white)


# OVERVIEW

Introducing `{USERanalyzer}`: an R package designed for the visualization of ancient DNA (aDNA) data that use [Uracil-Specific 
Excision Reagent (USER)](https://www.neb.com/en/products/m5505-user-enzyme?srsltid=AfmBOoordQF4RPNq2kBKbjeCeduoI3ZSdnunjRjbHpMAlWL1RzIOoMD7) 
enzyme treatment during library preparations. `{USERanalyzer}` offers an
RStudio project template to facilitate the creation of reproducible workflows for visualizing various summary statistics.

This package is tailored for scientists working with aDNA analysis, enabling them to seamlessly process next-generation 
sequencing data and generate QC plots. These plots cover both raw sequencing summary statistics and downstream analyses. 
Integrating outputs from existing aDNA tools, `{USERanalyzer}` organizes information in one place, 
allowing users to produce clean, informative visualizations, with options for basic plots or additional annotations for 
enhanced detail.

# Installation

```r
install.packages("USERanalyzer")
```

```r
library(USERanalyzer)
```
# Requirements

The data file should be an excel file with multiple sheets for different summary statistics plots to be generated
from. The `load_df_use` function will automatically 


# Usage

## 1. Change setting.R file

In the `settings.R` file, you can customize the color palette, column names, treatment groups, etc.

```r
# Color palette
aDNA_pal <- c(
  "#440154FF",
  "#FDE725FF",
  "#159090",
  "#FF8C00",
  "#8FD744FF",
  "#A034F0"
  )

# Columns order and names for labeling
named_columns <- c("TotalReads" = "Total Number of Reads",
             "ReadsTrim" = "Number of Reads after Trimming",
             "ReadLenTrim" = "Length of Trimmed Reads",
             "MappingReads" = "Number of Mapping Reads",
             "DuplicateReads" = "Number of Duplicate Reads",
             "UniqueReads" = "Number of Unique Reads",
             "ReadLengthMean" = "Mean Length of Reads",
             "AutosomeDepth" = " Autosome Depth",
             "MTdepth" = "Mitochondiral Depth",
             "XDepth" = "Chromosome X Depth",
             "YDepth" = "Chromosome Y Depth",
             "CtoT5bp1" = "C to T Misincorporation posiiton 1",
             "CtoT5bp2"= "C to T Misincorporation position 2",
             "GtoA3bp1" = "G to A Misincorporation position 1",
             "GtoA3bp2" = "G to A Misincorporation position 2"
)

# Vector for treatment group labels
treat_labs <- c(
                "U_2.5" = "2.5mL USER",
                "U_10" = "10mL USER",
                "E" = "Non USER"
)
```
## 2. Load data from excel file

Using the `load_df_user` function

```r
main_data <- load_df_user(data_path)
```

will create a main dataframe where it contains a list of named dataframes from all the sheets
within the excel file.

## 3. QC plots from NGS data

First quality control plots to ensure no errors/problems occured during library preparation and sequencing.

Single summary statistic variable
```r
plot_qc(complete_data, variable_col = "ReadsTrim")
```
All summary statistic variables
```r

```

