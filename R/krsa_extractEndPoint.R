#' Extracts end point data (last cycle)
#'
#' This function takes in raw data and chip type and returns end point data (last cycle)
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

krsa_extractEndPoint <- function(df, type = c("STK", "PTK")) {

  df %>% filter(
    if (type == "STK") {Cycle == 124} else {Cycle == 94}) %>%
    select(SampleName,Peptide ,ExposureTime, Signal, Barcode, Group)

}
