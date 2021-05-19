#' It prepares a KRSA peptide file (log2 FC) to be used for creedenzymatic
#'
#' Takes in the Z score table and output kinase with their scores
#'
#' @param peptide_table a df of the log2 FC scores of peptides
#' @param metric which col to use as the score (totalMeanLFC, LFC, ... etc)
#' @param file_name file name and path to save file as txt tab delimited file
#'
#' @return saved txt file to be used in creedenzymatic
#'
#' @export
#'
#'

krsa_ce_output_peptides <- function(peptide_table, metric, file_name) {

  peptide_table %>%
    dplyr::select(Peptide, {{ metric }}) %>%
    dplyr::rename(Score = {{ metric }}) %>%
    readr::write_delim(file=file_name)

}
