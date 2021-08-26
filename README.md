<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R-CMD-check](https://github.com/CogDisResLab/KRSA/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/CogDisResLab/KRSA/actions/workflows/R-CMD-check.yaml)
[![pkgdown](https://github.com/CogDisResLab/KRSA/actions/workflows/pkgdown.yml/badge.svg)](https://github.com/CogDisResLab/KRSA/actions/workflows/pkgdown.yml)
[![Build
Status](https://www.travis-ci.com/CogDisResLab/KRSA.svg?branch=master)](https://www.travis-ci.com/CogDisResLab/KRSA)
[![Repo
Status](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)

<!-- badges: end -->

## Installation

``` r
# install.packages("devtools")
devtools::install_github("CogDisResLab/KRSA")
```

The KRSA Vignette is now available in R (using browseVignettes(“KRSA”)).
To have the KRSA Vignette locally accessible, the build_vignettes
argument must be set as TRUE when installing the package:

``` r
devtools::install_github(build_vignettes = T)
```

### Installation Requirements

R (\>= 3.5.0) version

For Windows users:  
installment of Rtools
(<https://cran.r-project.org/bin/windows/Rtools/>).

## KRSA <img src="man/figures/logo.png" align="right" height="280"/>

Kinome Random Sampling Analyzer, or KRSA, is an R Shiny application that
automates many of the steps required to analyze
[PamChip](%22https://pamgene.com/technology/%22) datasets, including
peptide filtering, random sampling, heatmap generation, and kinase
network generation. This new software makes analyzing kinome array
datasets accessible and eliminates much of the human workload that the
previous method required. More importantly, KRSA represents the results
in a bigger biological context by visualizing altered kinome signaling
networks instead of individual kinases.

More info on the PamStation12 platform can be found here:
[PamGene](%22https://pamgene.com/%22)

## Package Website

<https://CogDisResLab.github.io/KRSA/>

## Access

KRSA Shiny App GitHub Repository:
[Link](https://github.com/CogDisResLab/KRSA_App)

KRSA preprint is available here:
[BioRxiv](https://www.biorxiv.org/content/10.1101/2020.08.26.268581v1)

## Workflow

![KRSA Workflow](man/figures/workflow.png)

## Random Sampling Approach

###### Running Random Sampling

<p align="center">
<img src="man/figures/rand_sampling_DMPK.gif"/>
</p>

<br /> <br />

###### Calculating Mean, Standard Deviations, and Z Scores

<p align="center">
<img src="man/figures/rand_explain_new.png"/>
</p>

<br /><br />

## Input Files

The user-supplied kinase-peptide association file and the raw kinome
array data file are selected as input. The kinase-peptide associations
should be based on the known/predicted interactions found in databases
like GPS 3.0 and Kinexus Phosphonet. Expected inputs should be formatted
as shown in the example files:
vignettes/data_files/example_Median_SigmBg.txt

# Contact

For technical issues, please start a new issue on this repo:
[Link](https://github.com/CogDisResLab/KRSA/issues)

For biological interpretation questions please email:
<khaled.alganem@rockets.utoledo.edu>
