#' Determine number of peptides inside lists
#'
#' Takes in list of significant peptides and calculates length of each set
#'
#' @param sigPeps_list list of significant peptides
#'
#' @return tibble with length of peptide sets
#'
#'
#' @export
#'
#' @examples
#' TRUE


krsa_show_peptides <- function(sigPeps_list) {
  purrr::map_df(sigPeps_list, pluckPeptides) %>%
    dplyr::mutate(Method = names(sigPeps_list)) %>%
    dplyr::select(2,1)
}

pluckPeptides <- function(x) {
  dplyr::tibble(NumberOfPeptides = length(x)
  )
}


