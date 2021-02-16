#' TODO
#'
#' TODO
#'
#' @param data krsa data_modeled$scaled
#' @param samples sample names
#' @param lfc_thr LFC cutoff for plot
#'
#' @return ggplot
#'
#' @import dplyr
#'
#' @export
#'
#' @examples
#' TRUE


krsa_sampling <- function(x,CovFile,file,sum_num) {
  CovFile %>%
    group_by(Kin) %>%
    summarise(
      counts = sum(Substrates %in% sample(file$Substrates,sum_num))
    ) %>% mutate(itr = x) -> res

  return(res)
}
