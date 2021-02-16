#' TODO
#'
#' TODO
#'
#' @param sigPeps_list krsa data_modeled$scaled
#'
#' @return vector
#'
#' @import dplyr
#'
#' @export
#'
#' @examples
#' TRUE


krsa_show_peptides <- function(sigPeps_list) {
  map_df(sigPeps_list, pluckPeptides) %>% mutate(Method = names(sigPeps_list)) %>%
    select(2,1)
}

pluckPeptides <- function(x) {
  tibble(NumberOfPeptides = length(x)
  )
}


