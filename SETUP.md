# Setting up for KRSA Analysis

1. Install R and RStudio
2. Create a new RStudio Project
3. Copy the Template Files
4. In the RStudio Project run the following commands:
    1. `install.packags('gt', 'furrr', 'tidyverse', 'knitr', 'rmarkdown', 'shiny', 'devtools')`
    2. `library(devtools)`
    3. `install_github('CogDisResLab/KRSA', 'v1.0.0')`
5. Change the required parts in the template files
6. Run `knit` to generate report
7. Fix any problems that come up
8. Go to 6.
