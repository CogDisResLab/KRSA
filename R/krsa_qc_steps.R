#' QC pre-processing of raw data (deals with negative values, and adjust signal saturation values)
#'
#' This function takes in the raw data and QC pre-processes it (deals with negative values, and adjust signal saturation values)
#'
#' @param df krsa raw data
#' @param sat_qc to filter out data point with high SignalSaturation
#'
#' @return df
#'
#' @import dplyr
#'
#' @export
#'
#' @examples
#' TRUE

krsa_qc_steps <- function(df, sat_qc = T) {

  df %>% mutate(Signal = ifelse(Signal < 1, 1, Signal)) %>%
    {if (sat_qc == T) {filter(.,!SignalSaturation>0.05)} else .}


}
