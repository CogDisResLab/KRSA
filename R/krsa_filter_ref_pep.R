#' Filters out ref peptides
#'
#' This function takes in a list of peptides and filter out the ref peptides
#'
#' @param peptides list of peptides
#'
#' @return vector
#'
#' @import dplyr
#'
#' @export
#'
#' @examples
#' TRUE

krsa_filter_ref_pep <- function(peptides) {

  peptides[!grepl("^#REF", peptides)] -> new_pep
  new_pep[!new_pep%in% c("pVASP_150_164", "pTY3H_64_78", "ART_025_CXGLRRWSLGGLRRWSL",
                         "pVASP_150_164", "pTY3H_64_78", "ART_025_CXGLRRWSLGGLRRWSL",
                         "EFS_246_258_Y253F","ART_004_EAIYAAPFAKKKXC","ART_003_EAI(pY)AAPFAKKKXC"
                         )] -> new_pep



  message(paste("Filtered out", length(peptides) - length(new_pep), "Peptides"))

  new_pep

}
