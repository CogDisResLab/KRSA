#' Performs random sampling of peptides and mappped kinases
#'
#' This function takes number of iterations, coverage file, kinase-substrate mapping df, and the length of the set of peptides to resample
#'
#' @param x number of iterations
#' @param CovFile kinase coverage df
#' @param map kinase-substrate mapping df
#' @param sum_num number of peptides to resample
#'
#' @return count of kinases hits to random peptides
#'
#'
#' @export
#'
#' @examples
#' TRUE


krsa_sampling <- function(x,CovFile,map,sum_num) {
  CovFile %>%
    dplyr::group_by(Kin) %>%
    dplyr::summarise(
      counts = sum(Substrates %in% sample(map$Substrates,sum_num))
    ) %>%
    dplyr::mutate(itr = x) -> res

  return(res)
}
