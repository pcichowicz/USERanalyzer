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

# Usage

## 1. Change setting.R file
