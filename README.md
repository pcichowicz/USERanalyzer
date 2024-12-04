# USERanalyzer

<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

[![CRAN
status](https://www.r-pkg.org/badges/version/USERanalyzer)](https://CRAN.R-project.org/package=USERanalyzer)


![Markdown](https://img.shields.io/badge/markdown-%23000000.svg?style=for-the-badge&logo=markdown&logoColor=white) ![R](https://img.shields.io/badge/r-%23276DC3.svg?style=for-the-badge&logo=r&logoColor=white)

<!-- badges: end -->

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
The following steps will guide you to start producing QC plots along with further down analysis. Make sure that
the required excel file and corresponding sheets are in the correct format.

## Customizing the settings file
Changing the  `setting.R` file. In the `settings.R` file, you can customize path to excel data file,
output path for storing results, color palette, column names,treatment groups, etc.

```r
#Change/add new meta settings for scripts/functions to use

# path to data, output results
data_path <- "/path/to/R projects/Projects/USER_reduction/Data/USER_raw_data.xlsx"
plot_output <- "/path/to/R projects/Projects/USER_reduction/Plots"

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

```

## Loading data and Quality control

Once the settings have been adjusted, you can load data into the R project markdown. Using the `load_df_user` function

```r
main_data <- load_df_user(data_path)
```

will create a main dataframe where it contains a list of named dataframes from all the sheets
within the excel file.

Next you can plot quality control analysis plots to ensure no errors/problems occured during library preparation and sequencing.
The following function `qc_plot` does not group the observations based on treatment groups.

Single summary statistic variable
```r
# default plot
plot_qc(main_data, variable_col = "ReadsTrim")

# advanced plot
plot_qc(main_data, variable_col = "ReadsTrim, qc_type = "adv")
```
All summary statistic variables
```r
sapply(col_num, simplify = FALSE ,function(col_name) {
 plot_qc(complete_data, variable_col = col_name)
})
```

<img src="https://github.com/user-attachments/assets/8b053865-692c-446c-b134-cbb8f0706767" width=50% >
<img src="https://github.com/user-attachments/assets/1c08533b-13ec-4b07-b688-63147809aced" width=50% >


![plot_qc-ReadLenTrim](https://github.com/user-attachments/assets/8b053865-692c-446c-b134-cbb8f0706767)
![plot_qc-ReadLenTrim_adv](https://github.com/user-attachments/assets/1c08533b-13ec-4b07-b688-63147809aced)


In order to visualize treatment group QC, `plot_qc_group` is used in the same manner.

```r
plot_qc_group(main_data, variable_col = "TotalReads"
```
![plot_qc_group-ReadLenTrim](https://github.com/user-attachments/assets/61b12b64-a5db-4134-a6e1-6526519c5ebe)


Raincloud plots using the `plot_raincloud` can visualize raw data, probability density and other summary statistics (mean, median, confidence
intervals) in an understandable and flexible format. It combines dot plots, density plot, and box plots into one.

```r
plot_raincloud(main_data, "ReadLenTrim")
```
will result in the following plot.

![plot_raincloud](https://github.com/user-attachments/assets/0231fe8a-3c43-434c-a8f1-f958955194a5)


## aDNA damage verification

Using the [mapDamage](https://ginolhac.github.io/mapDamage/) tool for quantifying damage patterns in ancient DNA sequences, you
can plot both 5' and 3' ends of C -> T and G -> A transitions. You can plot individual mis-incorporation plots or many samples
at the same time.

```r
# Individual/single sample
plot_mapDamage(main_data, "sample_1")

# All samples store in list object and can access them by indexing
plot_mapDamage(main_data)
```
![plot_mapDamage](https://github.com/user-attachments/assets/6460b17e-b6d7-420a-9483-250e76ef73eb)

### mapDamage parameters used for validating aDNA damage

**Lambda**, the probability of termating an overhang.  
**DeltaD**, the cytosine deamination probability in double strand context.  
**DeltaS**, the cytosine deamination probability in single strand context.  
**Theta**, the mean difference rate between the reference and the sequenced sample not due to DNA damage.  

![plot_mapDamage_param-Lambda](https://github.com/user-attachments/assets/931921e3-d3f2-4530-a56d-93bc30351e65)
![plot_mapDamage_param-DeltaD](https://github.com/user-attachments/assets/b5483492-5993-4892-b078-31266269dc37)
![plot_mapDamage_param-DeltaS](https://github.com/user-attachments/assets/a22c8992-a9d2-42fb-9551-d045e5001f4a)
![plot_mapDamage_param-Theta](https://github.com/user-attachments/assets/17745535-ee25-4dd5-b68a-8f307357b6b6)
