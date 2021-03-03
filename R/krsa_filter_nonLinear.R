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
#' @export
#'
#' @examples
#' TRUE

krsa_filter_nonLinear <- function(data, threshold,samples = NULL, groups = NULL) {

  data %>%
    {if(!is.null(samples)) dplyr::filter(.,SampleName %in% samples) else .} %>%
    {if(!is.null(groups)) dplyr::filter(.,Group %in% groups) else .} %>%
    dplyr::select(SampleName, Peptide, r.seq) %>%
    tidyr::spread(SampleName, r.seq) %>%
    dplyr::filter_at( vars(-Peptide) , dplyr::all_vars(. >= threshold)) %>%
    dplyr::pull(Peptide) -> p



  message(paste("Filtered out", length(data$Peptide %>% unique()) - length(p), "Peptides"))

  p

}
