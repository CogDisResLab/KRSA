#' TODO
#'
#' TODO
#'
#' @param zTable krsa data_modeled$scaled
#' @param z_thr Z score cutoff
#'
#' @return vector
#'
#' @import dplyr
#'
#' @export
#'
#' @examples
#' TRUE


krsa_top_hits <- function(zTable,z_thr) {
  zTable %>%
    select(Kinase, AvgZ) %>% distinct() %>%
    filter(abs(AvgZ) >= z_thr) %>%
    pull(Kinase) %>% unique()
}


