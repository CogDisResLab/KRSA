#' It prepares a KRSA kinase file to be used for creedenzymatic
#'
#' Takes in the Z score table and output kinase with their scores
#'
#' @param krsa_table a df of the Z score table
#' @param file_name file name and path to save file as txt tab delimited file
#'
#' @return saved txt file to be used in creedenzymatic
#'
#'
#'
#' @export
#'
#'
#'

krsa_ce_output_kinases <- function(krsa_table, file_name) {

  krsa_table %>%
    dplyr::select(Kinase, Z) %>%
    dplyr::rename(Score = Z) %>%
    readr::write_delim(file=file_name)

}
