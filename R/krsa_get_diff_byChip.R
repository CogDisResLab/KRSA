#' TODO
#'
#' TODO
#'
#' @param data krsa tidy data
#' @param col case sample names vector
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


krsa_get_diff_byChip <- function(data, col, lfc_thr) {
  x<- split(data, data$Barcode)
  map(x, krsa_get_diff, {{ col }}, lfc_thr)
}
