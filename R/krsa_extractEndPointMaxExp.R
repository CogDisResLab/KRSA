#' Extracts end point data at max exposure (last cycle)
#'
#' This function takes in raw data and chip type and returns end point data at max exposure (last cycle)
#'
#' @param df krsa raw tidy data
#' @param type chip type
#'
#' @return end point data at max exposure df
#'
#' @family helper functions
#'
#'
#' @export
#'
#' @examples
#' TRUE

krsa_extractEndPointMaxExp <- function(df, type = c("STK", "PTK")) {

  df %>% dplyr::filter(
    if (type == "STK") {Cycle == 124} else {Cycle == 94},
                ExposureTime == 200) %>%
    dplyr::select(SampleName, Peptide ,Signal, Group)


}
