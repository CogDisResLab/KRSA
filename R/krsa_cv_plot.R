#' Generates CV (coefficient of variation) plot
#'
#' This function takes in the modeled pw data, list of peptides, and sample names (optional)
#'
#' @param data krsa modeled pw data (scaled)
#' @param peptides peptide list
#' @param samples sample names
#'
#' @return ggplot object
#'
#'
#' @export
#'
#' @examples
#' TRUE

krsa_cv_plot <- function(data, peptides,samples = NULL) {

  data %>%
    dplyr::filter(Peptide %in% peptides) %>%
    {if(!is.null(samples)) dplyr::filter(.,SampleName %in% samples) else .} %>%
    dplyr::group_by(Group, Peptide) %>%
    dplyr::summarise(SD = stats::sd(slope), repMean = mean(slope), CV = SD/repMean) %>%
    ggplot2::ggplot(aes(.data$repMean, .data$CV)) +
    ggplot2::geom_point() +
    ggplot2::geom_smooth(method = "loess",aes(color = Group)) +
    ggplot2::facet_wrap(~Group, scales = "free") +
    ggplot2::ylim(0,1) +
    ggplot2::labs(title = "CV Plot") +
    ggplot2::theme_bw()

}
