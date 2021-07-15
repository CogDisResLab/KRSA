## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(KRSA)
library(knitr)
library(tidyverse)

library(gt) # can be used to view tables
library(furrr) # can be used for parallel computing 

## ----cvPlot, echo=T,fig.height=8, fig.width=8, fig.align="center", cache=TRUE----

# Plot a CV figure using the modeled scaled data
krsa_cv_plot(data_modeled$scaled, new_pep)

# Plot a CV figure using the modeled normalized data
krsa_cv_plot(data_modeled$normalized, new_pep)

## ----violinPlot, echo=T,fig.height=8, fig.width=8, fig.align="center", cache=TRUE----
# Plot a violin figure and facet by the (Group) variable
krsa_violin_plot(data_modeled$scaled, new_pep, "Group")

# Plot a violin figure and facet by the (Barcode) variable
krsa_violin_plot(data_modeled$scaled, new_pep, "Barcode")


## ----heatmapPlot, echo=T,fig.height=8, fig.width=8, fig.align="center", cache=TRUE----

# Generates a heatmap using the modeled scaled data
krsa_heatmap(data_modeled$scaled, new_pep, scale = "row")

# Generates a heatmap using the modeled normalized data
krsa_heatmap(data_modeled$normalized, new_pep, scale = "row")

# Generates a heatmap using the modeled grouped data
krsa_heatmap_grouped(data_modeled$grouped, new_pep, scale = "row")



## ----violinIndPlot,echo=T, fig.align="center", fig.height=6, fig.width=8, cache=TRUE, message=FALSE----
# generates a violin plot using the selected groups and peptides
krsa_violin_plot(data_modeled$scaled, sigPeps$meanLFC$`0.2`, "Barcode", groups = comparisons$Comp1)

# generate a grouped violin/boxplot plot using the selected groups and peptides with more options, like a statistical test. check krsa_violin_plot_grouped() arguments for more options

krsa_violin_plot_grouped(data_modeled$scaled, sigPeps$meanLFC$`0.2`, comparisons, 
                         byGroup = F, dots = F,
                         groups = comparisons$Comp1, avg_line = T)

krsa_violin_plot_grouped(data_modeled$grouped, sigPeps$meanLFC$`0.2`, comparisons, 
                         groups = comparisons$Comp1, avg_line = T)


## ----curvePlot, echo=T,fig.align="center", fig.height=8, fig.width=8, cache=TRUE----
# generates a curve plot representing the linear model fit for the selected peptide (top peptides)
krsa_curve_plot(data_pw, sigPeps$meanLFC$`0.2`, groups = comparisons$Comp1)

## ----krsa, echo=T, warning=F, message=FALSE, fig.align="center", fig.height=6, fig.width=6, cache=TRUE----


# load in chip coverage and kinase-substrate files OR upload your own files
# if PTK chip, use:
# chipCov <- KRSA_coverage_PTK_PamChip_86402_v1
# KRSA_file <- KRSA_Mapping_PTK_PamChip_86402_v1

# STK chip
chipCov <- KRSA_coverage_STK_PamChip_87102_v1
KRSA_file <- KRSA_Mapping_STK_PamChip_87102_v1



# run the KRSA function to do the random sampling analysis, set seed that can be used later to reproduce results, and choose number of iterations
krsa(sigPeps$meanLFC$`0.2`, return_count = T, seed = 123, itr = 2000,
     map_file = KRSA_file, cov_file = chipCov) -> fin

# View the Z score table
kable(head(fin$KRSA_Table,25), digits = 3)

# to save file
#fin$KRSA_Table %>% write_delim("acrossChip_KRSA_FullTable_comp1.txt", delim = "\t")

# find top and bottom kinases
bothways <- c(pull(head(fin$KRSA_Table, 10), Kinase), pull(tail(fin$KRSA_Table, 10), Kinase))

# Use these kinase to generate histogram plots for each selected kinase
krsa_histogram_plot(fin$KRSA_Table, fin$count_mtx, bothways)


# For parallel computing, load the furrr package:
# opens multiple R sessions to run faster
plan(multisession)

# Run the KRSA function across the different sets of peptides using the furrr package for parallel computing
future_map(sigPeps_total, krsa) -> mutiple_krsa_outputs


# For none parallel computing:
# Run KRSA function across the different sets of peptides
#map(sigPeps_total, krsa) -> mutiple_krsa_outputs

# Tidy output
df <- data.frame(matrix(unlist(mutiple_krsa_outputs), ncol = max(lengths(mutiple_krsa_outputs)), byrow = TRUE))
df <- setNames(do.call(rbind.data.frame, mutiple_krsa_outputs), names(mutiple_krsa_outputs$meanLFC.0.2))

df %>% rownames_to_column("method") %>% select(Kinase, Z, method) %>% 
  mutate(method = str_extract(method, "\\w+\\.\\w+\\.\\w+")) %>% 
  mutate(method = gsub("(^\\w+)[\\.]", "\\1>", method)) %>% 
  mutate_if(is.numeric, round, 2) -> df

df %>% 
  pivot_wider(names_from = method, values_from = Z) -> df2
  
# Generates a table of the Z scores across the different sets of peptides
# df2 %>% 
#   gt() %>% tab_spanner_delim(delim = ">")

# Creates an average Z score table using the across chip analysis
df %>% 
  filter(grepl("mean", method)) %>% 
  select(Kinase, Z, method) %>% group_by(Kinase) %>% mutate(AvgZ = mean(Z)) -> AvgZTable

# save file
#AvgZTable %>% write_delim("acrossChip_KRSA_Table_comp1.txt", delim = "\t")

# Creates an average Z score table using the within chip analysis
df %>% 
  filter(!grepl("mean", method)) %>% 
  select(Kinase, Z, method) %>% group_by(Kinase) %>% mutate(AvgZ = mean(Z)) -> AvgZTable2

# save file
#AvgZTable %>% write_delim("withinChip_KRSA_Table_comp1.txt", delim = "\t")

# Extract top kinases based on abs(Z) score
krsa_top_hits(AvgZTable2, 2) -> kinases_hits

#krsa_top_hits(AvgZTable2, 1.75)
#krsa_top_hits(AvgZTable2, 1.5)

# Show the number of peptides per each set in atable
krsa_show_peptides(sigPeps_total)


## ----zscoresPlot, echo=T, warning=F, fig.align="center", fig.height=8,fig.width=6, cache=TRUE----

# Generates Z scores waterfall plots
krsa_zscores_plot(AvgZTable)
krsa_zscores_plot(AvgZTable2)


## -----------------------------------------------------------------------------
installed.packages()[names(sessionInfo()$otherPkgs), "Version"]

