#' KRSA kinase-substrate mapping file for PamChip 86402 PTK (v1 mapping)
#'
#' A data frame of the built-in KRSA kinase-substrate mapping file for PamChip 86402 PTK (v1 mapping)
#'
#' @format A data frame with 192 rows and 2 variables:
#' \describe{
#'   \item{Substrates}{Peptide IDs}
#'   \item{Kinases}{mapped kinases separated by spaces}
#' }
#'
"KRSA_Mapping_PTK_PamChip_86402_v1"


#' KRSA kinase-substrate mapping file for PamChip 87102 STK (v1 mapping)
#'
#' A data frame of the built-in KRSA kinase-substrate mapping file for PamChip 87102 STK (v1 mapping)
#'
#' @format A data frame with 141 rows and 2 variables:
#' \describe{
#'   \item{Substrates}{Peptide IDs}
#'   \item{Kinases}{mapped kinases separated by spaces}
#' }
#'
"KRSA_Mapping_STK_PamChip_87102_v1"

#' KRSA kinase coverage file for PamChip 86402 PTK (v1 mapping)
#'
#' A data frame of the built-in KRSA kinase coverage file for PamChip 86402 PTK (v1 mapping)
#'
#' @format A data frame with 1278 rows and 2 variables:
#' \describe{
#'   \item{Kin}{Kinase Family Name}
#'   \item{Substrates}{Peptides IDs}
#' }
#'
"KRSA_coverage_PTK_PamChip_86402_v1"

#' KRSA kinase coverage file for PamChip 87102 STK (v1 mapping)
#'
#' A data frame of the built-in KRSA kinase coverage file for PamChip 87102 STK (v1 mapping)
#'
#' @format A data frame with 2423 rows and 2 variables:
#' \describe{
#'   \item{Kin}{Kinase Family Name}
#'   \item{Substrates}{Peptides IDs}
#' }
#'
"KRSA_coverage_STK_PamChip_87102_v1"


#' Protein-Protein Interactions based on PhosphositePlus database
#'
#' A data frame of the known Protein-Protein Interactions based on PhosphositePlus database
#'
#' @format A data frame with 179 rows and 2 variables:
#' \describe{
#'   \item{FinName}{Kinase Family Name}
#'   \item{count}{Number of collapsed kinases under that kinase family, it's not used in package}
#' }
#'
"ballModel_nodes"


#' Protein-Protein Interactions based on PhosphositePlus database
#'
#' A data frame of the known Protein-Protein Interactions based on PhosphositePlus database
#'
#' @format A data frame with 592 rows and 2 variables:
#' \describe{
#'   \item{Source}{Kinase Family Name Source}
#'   \item{Target}{Kinase Family Name Target}
#' }
#'
"ballModel_edges"



