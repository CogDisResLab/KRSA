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


krsa <- function(y, itr = 2000, seed = 123, return_count = F) {
  message("Running KRSA ...")
  set.seed(seed)
  purrr::map_df(1:itr,krsa_sampling,chipCov ,KRSA_file,length(y)) -> temp
  temp %>% group_by(Kin) %>% summarise(SamplingAvg = mean(counts), SD= sd(counts)) -> temp2

  temp3 <- chipCov %>%
    group_by(Kin) %>%
    summarise(
      Observed = sum(Substrates %in% y)
    )

  left_join(temp2, temp3) %>% mutate(Z = (Observed-SamplingAvg)/SD) %>%
    arrange(desc(abs(Z))) %>%
    filter(!Kin %in% c("BARK1", "VRK2")) %>%
    select(Kin, Observed, SamplingAvg, SD, Z) %>%
    rename(Kinase = Kin) -> fin

  if(return_count == T) {return(list(count_mtx = temp, KRSA_Table = fin))}
  else {fin}

}
