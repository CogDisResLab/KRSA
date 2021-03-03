#' Main KRSA function. It performs the random sampling analysis and generates a Z score table and a count matrix
#'
#' Takes in a vector of the peptides that are considered "hits" and kinase-substrate and coverage dataframes and returns the Z score table
#'
#' @param peptides a vector of the peptides that are considered "hits"
#' @param itr number of iterations for the random sampling (default  = 2000)
#' @param seed seed number (default  = 123)
#' @param return_count boolean to return the kinase count matrix
#' @param map_file kinase-substrate dataframe
#' @param cov_file kinase coverage dataframe
#'
#' @return Z score tibble or list if return_count = TRUE
#'
#'
#' @export
#'
#' @examples
#' TRUE


krsa <- function(peptides, itr = 2000, seed = 123, return_count = F, map_file = KRSA_file, cov_file = chipCov) {
  message("Running KRSA ...")
  set.seed(seed)

  purrr::map_df(1:itr,krsa_sampling,cov_file ,map_file,length(peptides)) -> temp

  temp %>%
    dplyr::group_by(Kin) %>%
    dplyr::summarise(SamplingAvg = mean(counts), SD= stats::sd(counts)) -> temp2

  cov_file %>%
    dplyr::group_by(Kin) %>%
    dplyr::summarise(
      Observed = sum(Substrates %in% peptides)
    ) -> temp3

  dplyr::left_join(temp2, temp3) %>%
    dplyr::mutate(Z = (Observed-SamplingAvg)/SD) %>%
    dplyr::arrange(dplyr::desc(abs(Z))) %>%
    dplyr::filter(!Kin %in% c("BARK1", "VRK2")) %>%
    dplyr::select(Kin, Observed, SamplingAvg, SD, Z) %>%
    dplyr::rename(Kinase = Kin) -> fin

  if(return_count == T) {return(list(count_mtx = temp, KRSA_Table = fin))}
  else {fin}

}
