#' Filters out peptides with none linear signals based on the pw data
#'
#' This function takes in the pw data, r2 threshold, and samples and group names (optional)
#'
#' @param data krsa modeled pw data (scaled)
#' @param threshold r2 threshold
#' @param samples (optional) sample names
#' @param groups (optional) group names
#'
#' @return vector
#'
#' @import dplyr
#'
#' @export
#'
#' @examples
#' TRUE

krsa_filter_nonLinear <- function(data, threshold,samples = NULL, groups = NULL) {

  data %>%
    {if(!is.null(samples)) filter(.,SampleName %in% samples) else .} %>%
    {if(!is.null(groups)) filter(.,Group %in% groups) else .} %>%
    select(SampleName, Peptide, r.seq) %>%
    spread(SampleName, r.seq) %>%
    filter_at( vars(-Peptide) , all_vars(. >= threshold)) %>%
    pull(Peptide) -> p



  message(paste("Filtered out", length(data$Peptide %>% unique()) - length(p), "Peptides"))

  p

}
