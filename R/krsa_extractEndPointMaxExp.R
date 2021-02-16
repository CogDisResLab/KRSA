#' Extracts end point data at max exposure (last cycle)
#'
#' This function takes in raw data and chip type and returns end point data at max exposure (last cycle)
#'
#' @param df krsa raw tidy data
#' @param type chip type
#'
#' @return df
#'
#' @import dplyr
#'
#' @export
#'
#' @examples
#' TRUE

krsa_extractEndPointMaxExp <- function(df, type = c("STK", "PTK")) {

  df %>% filter(
    if (type == "STK") {Cycle == 124} else {Cycle == 94},
                ExposureTime == 200) %>%
    select(SampleName, Peptide ,Signal, Group)


}
