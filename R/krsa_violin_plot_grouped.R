#' Generates grouped violin plots based on peptides signals intensities with t tests options
#'
#' Takes in the scaled dataset from krsa_scaleModel() and plot violin figures using ggplot2
#'
#' @param data the scaled dataset from krsa_scaleModel
#' @param peptides vector of peptides
#' @param grp_comp list of group comparison names
#' @param groups (optional) a vector of group names
#' @param test perform two group test
#' @param test_method type of test (default is wilcox.test)
#' @param violin add violin layer
#' @param dots add dotplot layer
#' @param lines add lines layer
#' @param avg_line draw averaged line across the two groups
#' @param ... arguments passed to ggsignif
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

krsa_violin_plot_grouped <- function(data, peptides,grp_comp,groups = NULL,test = T, test_method = "wilcox.test",
                               violin = TRUE, dots = TRUE, lines = T, avg_line = F, ...) {

  data %>%
    dplyr::filter(Peptide %in% peptides) %>%
    {if(!is.null(groups)) dplyr::filter(.,Group %in% groups) else .} -> data

  data %>%
    ggplot2::ggplot(ggplot2::aes(Group, slope)) -> gg

  if(violin) {
    gg <- gg + ggplot2::geom_violin(ggplot2::aes(fill = Group), show.legend = F, trim = F, width=0.4)
  }


  gg <- gg + ggplot2::geom_boxplot(ggplot2::aes(fill = Group),width=0.1)

  if(dots) {
    gg <- gg + ggplot2::geom_dotplot(binaxis='y', stackdir='center', dotsize=1, alpha = 1/2)
  }

  if(lines) {
    gg <- gg + ggplot2::geom_line(ggplot2::aes(group = Peptide), alpha = 1/2)
  }
  if(test) {
    gg <- gg + ggsignif::geom_signif(
      margin_top  =0.5,
      comparisons = grp_comp,
      map_signif_level = F, textsize = 6,
      test = test_method,
      ...
    )
  }

  if(avg_line) {
    data %>%
      group_by(Group) %>%
      summarise(slopeM = mean(slope)) -> avg_data

    gg <- gg + ggplot2::geom_line(data = avg_data, ggplot2::aes(Group, slopeM, group = 1),
                                  color = "black", size = 3)
  }

  gg +
    ggplot2::labs(
      x = "",
      y = "Signal Intensity"
    ) +
    ggplot2::theme_bw()

}
