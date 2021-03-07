#' Extract differential peptides based on LFC cutoff by chip/barcode
#'
#' This function takes in the LFC table, column name, and an LFC cutoff to extracts differentially phosphorylated peptides per chip/barcode
#'
#' @param data LFC table
#' @param col LFC column name
#' @param lfc_thr LFC cutoffs
#'
#' @return peptides
#'
#' @family helper functions
#'
#' @export
#'
#' @examples
#' TRUE


krsa_get_diff_byChip <- function(data, col, lfc_thr) {
  x<- split(data, data$Barcode)
  purrr::map(x, krsa_get_diff, {{ col }}, lfc_thr)
}
