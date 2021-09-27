#' Generates violin plots based on peptides signals intensities
#'
#' Takes in the scaled dataset from krsa_scaleModel() and plot violin figures using ggplot2
#'
#' @param data the scaled dataset from krsa_scaleModel
#' @param peptides vector of peptides
#' @param facet_factor Column used to facet by. Will be used in facet_wrap(). Needs argument facet to be True.
#' @param facet boolean to facet the plot by a variable
#' @param samples (optional) a vector of sample names
#' @param groups (optional) a vector of group names
#' @param show_legend to show legend (default = FALSE)
#'
#'
#' @return ggplot figure
#'
#' @family plots
#'
#' @export
#'
#' @examples
#' TRUE

krsa_violin_plot <- function(data, peptides,facet_factor,facet = T,samples = NULL, groups = NULL, show_legend = F) {

  data %>%
    dplyr::filter(Peptide %in% peptides) %>%
    {if(!is.null(samples)) dplyr::filter(.,SampleName %in% samples) else .} %>%
    {if(!is.null(groups)) dplyr::filter(.,Group %in% groups) else .} %>%
    ggplot2::ggplot(ggplot2::aes(if(facet_factor == "Group") SampleName else Group, slope)) +
    ggplot2::geom_violin(ggplot2::aes(fill = Group), show.legend = show_legend) +
    ggplot2::geom_point(size = 1.5)+
    ggplot2::geom_line(ggplot2::aes(group = Peptide), alpha = 1/2) +
    ggplot2::labs(
      x = "",
      y = "Signal Intensity"
    ) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(size = 6)) +
    ggplot2::theme_bw() -> gg

  if(facet == T) {gg + ggplot2::facet_wrap(facet_factor, scales = "free")}
  else {gg}

}
