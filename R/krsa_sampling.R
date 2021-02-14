krsa_sampling <- function(x,CovFile,file,sum_num) {
  CovFile %>%
    group_by(Kin) %>%
    summarise(
      counts = sum(Substrates %in% sample(file$Substrates,sum_num))
    ) %>% mutate(itr = x) -> res

  return(res)
}
