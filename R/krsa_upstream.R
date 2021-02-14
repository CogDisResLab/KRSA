krsa_upstream <- function(y) {
  message("...")
  set.seed(123)
  purrr::map_df(1:2000,samplingPep,chipCov ,KRSA_file,length(y)) -> temp

  temp %>% group_by(Kin) %>% summarise(SamplingAvg = mean(counts), SD= sd(counts)) -> temp2

  temp3 <- chipCov %>%
    group_by(Kin) %>%
    summarise(
      Observed = sum(Substrates %in% y)
    )

  left_join(temp2, temp3) %>% mutate(Z = (Observed-SamplingAvg)/SD) %>%
    arrange(desc(abs(Z))) %>%
    filter(!Kin %in% c("BARK1", "VRK2"))

}
