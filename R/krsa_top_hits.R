#' Extracts top kinase hits based on a Z cutoff
#'
#' Take in Z score table and extract top kinases based on a Z score cutoff
#'
#' @param zTable Z score table from krsa()
#' @param z_thr Z score cutoff
#'
#' @return vector of top kinases
#'
#' @export
#'
#' @examples
#' TRUE


krsa_top_hits <- function(zTable,z_thr) {
  zTable %>%
    dplyr::select(Kinase, AvgZ) %>%
    dplyr::distinct() %>%
    dplyr::filter(abs(AvgZ) >= z_thr) %>%
    dplyr::pull(Kinase) %>%
    unique()
}


