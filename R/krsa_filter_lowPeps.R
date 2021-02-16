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
#' @import dplyr
#'
#' @export
#'
#' @examples
#' TRUE

krsa_filter_lowPeps <- function(data, threshold,samples = NULL, groups = NULL) {

  data %>%
    {if(!is.null(samples)) filter(.,SampleName %in% samples) else .} %>%
    {if(!is.null(groups)) filter(.,Group %in% groups) else .} %>%
    select(-Group) %>%
    pivot_wider(names_from = SampleName, values_from = Signal) %>%
    dplyr::filter_at( vars(-Peptide) , all_vars(. >= threshold)) %>%
    pull(Peptide) -> p

  message(paste("Filtered out", length(data$Peptide %>% unique()) - length(p), "Peptides"))

  p

}
