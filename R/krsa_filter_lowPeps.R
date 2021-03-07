#' Filters out peptides with low signals based on the pw data (max exposure)
#'
#' This function takes in the pw data (max exposure), signal threshold, and samples and group names (optional)
#'
#' @param data krsa pw data (max exposure)
#' @param threshold signal threshold
#' @param samples (optional) sample names
#' @param groups (optional) group names
#'
#' @return vector
#'
#' @family QC functions
#'
#'
#' @export
#'
#' @examples
#' TRUE

krsa_filter_lowPeps <- function(data, threshold,samples = NULL, groups = NULL) {

  data %>%
    {if(!is.null(samples)) dplyr::filter(.,SampleName %in% samples) else .} %>%
    {if(!is.null(groups)) dplyr::filter(.,Group %in% groups) else .} %>%
    dplyr::select(-Group) %>%
    tidyr::pivot_wider(names_from = SampleName, values_from = Signal) %>%
    dplyr::filter_at( vars(-Peptide) , dplyr::all_vars(. >= threshold)) %>%
    dplyr::pull(Peptide) -> p

  message(paste("Filtered out", length(data$Peptide %>% unique()) - length(p), "Peptides"))

  p

}
