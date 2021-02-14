#' Read crosstab format files exported from bioNavigator and tidy them
#'
#' This function takes in a BPNList object and returns a BPNList object
#'
#' @param data krsa tidy data
#' @param case case sample names vector
#' @param ctl control samples vector
#' @param peps peptide list
#' @param byChip T or F
#' @param chips chips vector
#'
#' @return LFC krsa table
#'
#' @import dplyr
#' @import EnvStats
#'
#' @export
#'
#' @examples
#' TRUE


krsa_group_diff  <- function(data,case, ctl, peps, byChip = F, chips = c(1,2,3)) {
  data %>% filter(Group %in% c(case, ctl), Peptide %in% peps) %>%
    {if (byChip == T) {filter(.,Chip %in% chips)} else . } %>%
    {if (byChip == T) {group_by(.,Chip, Peptide)} else group_by(., Peptide)} %>%
    summarise(FC = slope[Group == case]/slope[Group == ctl],
              LFC = slope[Group == case] - slope[Group == ctl],
              FCEd = log2(slope[Group == case])/log2(slope[Group == ctl]),
              FCP = FC * 100,
              ChangePercentage = ((slope[Group == case]- slope[Group == ctl])/slope[Group == ctl])*100
    ) %>% ungroup() %>% {if (byChip == T) {
      group_by(.,Peptide) %>% mutate(totalMean = mean(FC),totalMeanLFC = mean(LFC),
                                     totalGeoMean = EnvStats::geoMean(FC)) %>%
        ungroup() %>% mutate(totalGeoMeanLFC = log2(totalGeoMean))
    } else .}
}
