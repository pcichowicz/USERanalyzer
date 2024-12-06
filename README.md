# USERanalyzer

<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

[![CRAN status](https://www.r-pkg.org/badges/version/USERanalyzer)](https://CRAN.R-project.org/package=USERanalyzer)

![Markdown](https://img.shields.io/badge/markdown-%23000000.svg?style=for-the-badge&logo=markdown&logoColor=white) ![R](https://img.shields.io/badge/r-%23276DC3.svg?style=for-the-badge&logo=r&logoColor=white)

<!-- badges: end -->

# OVERVIEW

Introducing `{USERanalyzer}`: an R package designed for the visualization of ancient DNA (aDNA) data that use [Uracil-Specific Excision Reagent (USER)](https://www.neb.com/en/products/m5505-user-enzyme?srsltid=AfmBOoordQF4RPNq2kBKbjeCeduoI3ZSdnunjRjbHpMAlWL1RzIOoMD7) enzyme treatment during library preparations. `{USERanalyzer}` offers an RStudio project template to facilitate the creation of reproducible workflows for visualizing various summary statistics.

This package is tailored for scientists working with aDNA analysis, enabling them to seamlessly process next-generation sequencing data and generate QC plots. These plots cover both raw sequencing summary statistics and downstream analyses. Integrating outputs from existing aDNA tools, `{USERanalyzer}` organizes information in one place, allowing users to produce clean, informative visualizations, with options for basic plots or additional annotations for enhanced detail.

# Installation

``` r
install.packages("USERanalyzer")
```

``` r
library(USERanalyzer)
```

# Requirements for data

The data file should be an excel file with multiple sheets for different summary statistics plots to be generated from. The `load_df_use` function will automatically separate these sheets into a main dataframe list object where all the data is stored for analysis.

## Basic Summary statistics

The `{USERanalyzer}` package requires summary statistics (Descriptive statistics), of course there are the main important ones like below:

| Library      | Sample  | Treatment | TotalReads | ReadsTrim | ReadLenTrim | MappingReads | DuplicateReads | UniqueReads | ReadLen | ... |
|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|
| Sample1_E    | Sample1 | E         | 34914482   | 29356325  | 58          | 2323584      | 183943         | 2125338     | 61.2    | ... |
| Sample1_U10  | Sample1 | U_10      | 34537679   | 26293482  | 46          | 22487632     | 1789034        | 19876423    | 63.4    | ... |
| Sample1_U2.5 | Sample1 | U_2.5     | 4108052    | 3689098   | 63          | 2987637      | 239877         | 2656372     | 57.7    | ... |
| Sample2_E    | Sample2 | E         | 24510694   | 19098767  | 49          | 14987733     | 903463         | 11987573    | 67.5    | ... |
| ...          | ...     | ...       | ...        | ...       | ...         | ...          | ...            | ...         | ...     | ... |

however, a wide variety of plots can be produced with a wide range of statistics as long as the `settings.R` file is update with the header name as well as the axis title plot.

## mapDamage plots

For aDNA damage patterns and analysiz from `mapDamage` tool, you are required to extract the `5pCtoT_freq.txt` and `3pGtoA_freq.txt` values of the position and values respectively to use the `plot_mapdamage` function. Required headers are as followed:

| Library       | samp    | Treatment | Position | C_T5p      | G_A3p       |
|---------------|---------|-----------|----------|------------|-------------|
| Sample1-E     | Sample1 | E         | 1        | 0.01991125 | 0.018833521 |
| Sample1-U_10  | Sample1 | U_10      | 1        | 0.2898129  | 0.308544995 |
| Sample1-U_2.5 | Sample1 | U_2.5     | 1        | 0.01263771 | 0.013739463 |
| ...           | ...     | ...       | ...      | ...        | ...         |
| Sample1-E     | Sample1 | E         | 3        | 0.01839293 | 0.017583054 |
| Sample1-U_10  | Sample1 | U_10      | 3        | 0.16545549 | 0.017583054 |
| Sample1-U2.5  | Sample1 | U_2.5     | 3        | 0.00420404 | 0.174235332 |
| ...           | ...     | ...       | ...      | ...        | ...         |

If you're interested in the `mapDamage` approximate bayesian estimation of damage parameters that summarizes the damage patterns then also extract the individual `Stats_out_MCMC_iter_summ_stat.csv` for each sample.

| Library | Metric | Theta      | DeltaD     | DeltaS     | Lambda     |
|---------|--------|------------|------------|------------|------------|
| Sample1 | Mean   | 0.00440026 | 0.00203226 | 0.08400489 | 0.49931619 |
| Sample1 | Std.   | 8.37E-06   | 1.19E-05   | 0.00045203 | 0.00181073 |
| Sample2 | Mean   | 0.00434127 | 0.0029448  | 0.999835   | 0.86235534 |
| Sample2 | Std.   | 6.99E-06   | 7.67E-06   | 0.00016727 | 0.00015424 |
| Sample3 | Mean   | 0.00523887 | 0.03993745 | 0.66667149 | 0.34830837 |
| Sample3 | Std.   | 9.11E-06   | 5.79E-05   | 0.00072327 | 0.00044449 |
| ...     | ...    | ...        | ...        | ...        | ...        |

# Usage

The following steps will guide you to start producing QC plots along with further down analysis. Make sure that the required excel file and corresponding sheets are in the correct format.

## Customizing the settings file

Changing the `setting.R` file. In the `settings.R` file, you can customize path to excel data file, output path for storing results, color palette, column names,treatment groups, etc.

``` r
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

``` r
main_data <- load_df_user(data_path)
```

will create a main dataframe where it contains a list of named dataframes from all the sheets within the excel file.

Next you can plot quality control analysis plots to ensure no errors/problems occurred during library preparation and sequencing. The following function `qc_plot` does not group the observations based on treatment groups.

### Summary statistic visualizations

There are a variety of plots used withing `USERanalyzer` that can help visualize and interpret the data, such as:

-   **Density plots** representing the distribution of the collected data
-   **raincloud plots** incorporating different plots to provide clear and concise summary of the distribution, central tendency, and the spread of a dataset
-   **ridge plots** to show the distribution values for several groups
-   **lineplots** for data observations that are continuous

#### Density plots

Single summary statistic variable

``` r
# default plot
plot_qc(main_data, variable_col = "ReadsTrim")

# advanced plot
plot_qc(main_data, variable_col = "ReadsTrim, qc_type = "adv")
```

All summary statistic variables

``` r
sapply(col_num, simplify = FALSE ,function(col_name) {
 plot_qc(complete_data, variable_col = col_name)
})
```

<div>

<img src="https://github.com/user-attachments/assets/8b053865-692c-446c-b134-cbb8f0706767" width="48%&quot;"/> <img src="https://github.com/user-attachments/assets/1c08533b-13ec-4b07-b688-63147809aced" width="48%&quot;"/>

</div>

In order to visualize treatment group QC, `plot_qc_group` is used in the same manner.

``` r
plot_qc_group(main_data, variable_col = "TotalReads"
```

<div>

<img src="https://github.com/user-attachments/assets/61b12b64-a5db-4134-a6e1-6526519c5ebe" width="98%"/>

</div>

#### raincloud plots

Raincloud plots using the `plot_raincloud` can visualize raw data, probability density and key summary statistics (mean, median, confidence intervals) in an understandable and flexible format. It combines dot plots, density plot, and box plots into one.

``` r
plot_raincloud(main_data, "ReadLenTrim")
```

![plot_raincloud](https://github.com/user-attachments/assets/0231fe8a-3c43-434c-a8f1-f958955194a5)

### aDNA damage verification

Using the [mapDamage](https://ginolhac.github.io/mapDamage/) tool for quantifying damage patterns in ancient DNA sequences, you can plot both 5' and 3' ends of C -\> T and G -\> A transitions. You can plot individual mis-incorporation plots or many samples at the same time.

``` r
# Individual/single sample
plot_mapDamage(main_data, "sample_1")

# All samples store in list object and can access them by indexing
plot_mapDamage(main_data)
```

![plot_mapDamage-Sample1](https://github.com/user-attachments/assets/2c0c1465-2748-40f5-9cbd-d2217df69305)

<div>

<img src="https://github.com/user-attachments/assets/3f0a5392-4803-4857-98d1-f31e9b51f1b6" width="49%"/>

</div>

#### mapDamage parameters Lambda, Theta, DeltaS, and DeltaD

**Lambda** - average length of overhand  
**Theta** - the mean difference rate between the reference and the sequenced sample not due to DNA damage

<div>

<img src="https://github.com/user-attachments/assets/931921e3-d3f2-4530-a56d-93bc30351e65" width="49%"/> <img src="https://github.com/user-attachments/assets/17745535-ee25-4dd5-b68a-8f307357b6b6" width="49%"/>

</div>

**DeltaD**, the cytosine deamination probability in double strand context\
**DeltaS**, the cytosine deamination probability in single strand context

<div>

<img src="https://github.com/user-attachments/assets/b5483492-5993-4892-b078-31266269dc37" width="49%"/> <img src="https://github.com/user-attachments/assets/a22c8992-a9d2-42fb-9551-d045e5001f4a" width="49%"/>

</div>
