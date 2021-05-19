#' Calculates LFC based on modeled pw data and grouping
#'
#' This function takes in the modeled pw data, groups, peptides, and an option to perform the calculation per chip (byChip)
#'
#' @param data modeled pw data
#' @param groups a vector. format: (case, control)
#' @param peps peptide list
#' @param samples sample names
#' @param byChip T or F, to calculate per chip
#' @param Barcodes (optional) Barcodes vector
#'
#' @return LFC krsa table
#'
#' @family core functions
#'
#' @export
#'
#' @examples
#' TRUE


krsa_group_diff  <- function(data, groups, peps, samples = NULL,  byChip = T, Barcodes = NULL) {
  data %>%
    {if(!is.null(samples)) dplyr::filter(.,SampleName %in% samples) else .} %>%
    dplyr::filter(Group %in% groups, Peptide %in% peps) %>%
    {if (byChip == T) {dplyr::group_by(.,Barcode, Peptide)} else dplyr::group_by(., Peptide, Group)} %>%
    {if (byChip == T) dplyr::summarise(.,LFC = slope[Group == groups[1]] - slope[Group == groups[2]]) else {
      dplyr::summarise(.,slope=mean(slope)) %>% ungroup(.) %>%
        dplyr::group_by(.,Peptide) %>%
        dplyr::summarise(.,LFC = slope[Group == groups[1]] - slope[Group == groups[2]])
    }} %>%
    dplyr::ungroup(.) %>%
    {if (byChip == T) {
      dplyr::group_by(.,Peptide) %>%
        dplyr::mutate(.,totalMeanLFC = mean(LFC)) %>%
        dplyr::ungroup(.)
    } else .}
}
