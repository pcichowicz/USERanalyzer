# Direct path to excel file of data
data_path <- "/Users/Patrick/Desktop/R projects/Projects/USER_reduction/Data/USER_raw_data.xlsx"
plot_output <- "/Users/Patrick/Desktop/R projects/Projects/USER_reduction/Plots"


qc_names <- c("TotalReads" = "Total Number of Reads",
              "ReadsTrim" = "Number of Reads after Trimming",
              "ReadLenTrim" = "Length of Trimmed Reads",
              "MappingReads" = "Number of Mapping Reads",
              "DuplicateReads" = "Number of Duplicate Reads",
              "UniqueReads" = "Number of Unique Reads",
              "ReadLengthMean" = "Mean Length of Reads",
              "AutosomeDepth" = " Autosome Depth",
              "MTdepth" = "Mitochondiral Depth",
              "XDepth" = "Chromosome X Depth",
              "YDepth" = "Chromosome Y Depth")

aDNA_pal <- c(
  "#440154FF",
  "#FDE725FF",
  "#159090",
  "#FF8C00",
  "#8FD744FF",
  "#A034F0"
  )

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
             "GtoA3bp2" = "G to A Misincorporation position 2")

treat_labs <- c(
                "U_2.5" = "2.5mL USER",
                "U_10" = "10mL USER",
                "E" = "Non USER")


