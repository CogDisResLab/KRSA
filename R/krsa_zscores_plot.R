#' Generates a waterfall figure based on the Z score table
#'
#' Takes in the Z score table and generates a waterfall plot using a ggplot.
#'
#' @param Ztable Z score table
#'
#' @return ggplot object
#'
#' @family plots
#'
#'
#' @export
#'
#' @examples
#' TRUE


krsa_zscores_plot <- function(Ztable) {
  Ztable %>%
    dplyr::filter(!Kinase %in% c("VRK2", "BARK1")) %>%
    dplyr::mutate(
      breaks = cut(
        abs(AvgZ),
        breaks = c(0, 1, 1.5, 2, Inf),
        right = F,
        labels = c("Z <= 1", "1 >= Z < 1.5", "1.5 >= Z < 2", "Z >= 2")
        )) %>%
    ggplot2::ggplot() +
    ggplot2::geom_line(ggplot2::aes(Z, stats::reorder(Kinase,AvgZ)), alpha = 1/3) +
    ggplot2::geom_point(ggplot2::aes(Z, stats::reorder(Kinase,AvgZ)), color = "grey", size = 1) +
    ggplot2::geom_point(ggplot2::aes(AvgZ, stats::reorder(Kinase,AvgZ), color = breaks), size = 2) +
    ggplot2::geom_vline(xintercept = 0) +
    ggplot2::geom_vline(xintercept = c(-1, -1.5, -2, 1, 1.5, 2),linetype="dashed") +
    ggplot2::scale_color_brewer(palette="Reds", drop = F, guide = ggplot2::guide_legend(reverse=TRUE, title = "")) +
    ggplot2::labs(
      x = "Z",
      y="",
      shape = "cutoff"
    ) +
    ggplot2::theme(
      plot.title  = ggplot2::element_text(size = 7),
      axis.text.y = ggplot2::element_text(size= 6)
    ) +
    ggplot2::theme_bw()
}



