krsa_qc_steps <- function(df, sat_qc = T) {

  df %>% mutate(Signal = ifelse(Signal < 1, 1, Signal)) %>%
    {if(sat_qc & "SignalSaturation" %in% colnames(.)) {filter(!SignalSaturation>0.05)}}

}
