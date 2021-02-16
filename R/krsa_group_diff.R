#' Calculates LFC based on modeled pw data and grouping
#'
#' This function takes in the modeled pw data, groups, peptides, and an option to perform the calculation per chip (byChip)
#'
#' @param data modeled pw data
#' @param groups a vector. format: (case, control)
#' @param peps peptide list
#' @param byChip T or F, to calculate per chip
#' @param Barcodes (optional) Barcodes vector
#'
#' @return LFC krsa table
#'
#' @import dplyr
#'
#' @export
#'
#' @examples
#' TRUE


krsa_group_diff  <- function(data, groups, peps, byChip = T, Barcodes = NULL) {
  data %>% filter(Group %in% groups, Peptide %in% peps) %>%
    {if (byChip == T) {group_by(.,Barcode, Peptide)} else group_by(., Peptide, Group)} %>%
    {if (byChip == T) summarise(.,LFC = slope[Group == groups[1]] - slope[Group == groups[2]]) else {
      summarise(.,slope=mean(slope)) %>% ungroup(.) %>%
        group_by(.,Peptide) %>%
        summarise(.,LFC = slope[Group == groups[1]] - slope[Group == groups[2]])
    }} %>%
    ungroup(.) %>%
    {if (byChip == T) {
      group_by(.,Peptide) %>% mutate(.,totalMeanLFC = mean(LFC)) %>%
        ungroup(.)
    } else .}
}
