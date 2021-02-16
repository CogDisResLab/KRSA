#' Filters out low signal peptides AND none linear peptides
#'
#' This function takes in pw data max exposure, modeled pw data, signal threshold, R2 threshold, and samples and groups names (optional) and returns peptides that passed these conditions
#'
#' @param data pw data max exposure
#' @param data2 modeled pw data
#' @param signal_threshold signal threshold
#' @param r2_threshold R2 threshold
#' @param samples sample names
#' @param groups group names
#'
#' @return vector
#'
#' @import dplyr
#'
#' @export
#'
#' @examples
#' TRUE

krsa_quick_filter <- function(data,data2, signal_threshold,r2_threshold,samples = NULL, groups = NULL) {

  krsa_filter_lowPeps(data, signal_threshold, samples, groups) -> p

  data2 %>% filter(Peptide %in% p) %>%
    krsa_filter_nonLinear(r2_threshold, samples, groups) -> p2

  krsa_filter_ref_pep(p2) -> p3

  p3

}
