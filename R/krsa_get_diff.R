#' Extract differential peptides based on LFC cutoff
#'
#' This function takes in the LFC table, column name, and an LFC cutoff to extracts differentially phosphorylated peptides
#'
#' @param data LFC table
#' @param col LFC column name
#' @param lfc_thr LFC cutoffs
#' @param sd_thr SD cutoff
#'
#' @return peptides
#'
#' @family helper functions
#'
#'
#' @export
#'
#' @examples
#' TRUE


krsa_get_diff <- function(data,col, lfc_thr, sd_thr = Inf) {
  peplist <- vector("list", length(lfc_thr))
  for (i in 1:length(lfc_thr)) {
    dplyr::filter(data, {{ col }} >= lfc_thr[i] | {{ col }} <= lfc_thr[i]*-1) %>%
      dplyr::filter(LFC_SD <= sd_thr | is.na(LFC_SD)) %>%
      dplyr::pull(Peptide) %>%
      unique() -> peplist[[i]]
  }
  names(peplist) <- as.character(lfc_thr)
  peplist
}
