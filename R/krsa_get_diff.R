#' Extract differential peptides based on LFC cutoff
#'
#' This function takes in the LFC table, column name, and LFC cutoff
#'
#' @param data LFC table
#' @param col LFC column name
#' @lfc_thr LFC cutoffs
#'
#' @return peptides
#'
#' @import dplyr
#'
#' @export
#'
#' @examples
#' TRUE


krsa_get_diff <- function(data,col, lfc_thr) {
  peplist <- vector("list", length(lfc_thr))
  for (i in 1:length(lfc_thr)) {
    filter(data, {{ col }} >= lfc_thr[i] | {{ col }} <= lfc_thr[i]*-1) %>%
      pull(Peptide) %>% unique() -> peplist[[i]]
  }
  names(peplist) <- as.character(lfc_thr)
  peplist
}
