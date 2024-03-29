#' Generates a waterfall figure based on the LFC table
#'
#' Takes in the LFC table and a LFC cuttoff and generates a waterfall plot using a ggplot.
#'
#' @param data LFC table
#' @param lfc_thr LFC cutoff for plot
#' @param byChip boolean Select T if the LFC is based on a byChip analysis
#' @param sd_thr SD cutoff for plot
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


krsa_waterfall <- function(data, lfc_thr, byChip =  T, sd_thr =Inf) {

  if(byChip == T) {

    data %>%
      dplyr::filter(LFC_SD <= sd_thr) -> data

    data$colMean <- cut(data$totalMeanLFC, breaks = c(-Inf,-1*lfc_thr, lfc_thr, Inf), labels = c("red", "black", "red"))
    data$colFC <- cut(data$LFC, breaks = c(-Inf,-1*lfc_thr, lfc_thr, Inf), labels = c("black", "gray", "black"))

  }
  else {
    data$colFC <- cut(data$LFC, breaks = c(-Inf,-1*lfc_thr, lfc_thr, Inf), labels = c("red", "black", "red"))
  }

  ggplot2::ggplot(data) -> gg



  if(byChip == T) {
    gg <- gg +
      ggplot2::geom_point(ggplot2::aes(LFC, stats::reorder(Peptide,LFC)), color = data$colFC, size = 0.75) +
      ggplot2::geom_point(ggplot2::aes(totalMeanLFC, stats::reorder(Peptide,totalMeanLFC)), color = data$colMean, size = 2) +
      ggplot2::geom_line(ggplot2::aes(LFC, stats::reorder(Peptide,totalMeanLFC)), alpha = 1/3)
  }

  else {
    gg <- gg +
      ggplot2::geom_segment(ggplot2::aes(x=0, xend= LFC, y= stats::reorder(Peptide,LFC), yend= stats::reorder(Peptide,LFC)), color="grey") +
      ggplot2::geom_point(ggplot2::aes(LFC, stats::reorder(Peptide,LFC)), color = data$colFC, size = 2)
  }




  gg +
    ggplot2::geom_vline(xintercept = 0) +
    ggplot2::geom_vline(xintercept = -1 * lfc_thr,linetype="dashed") +
    ggplot2::geom_vline(xintercept = lfc_thr,linetype="dashed")+
    ggplot2::labs(x = "Log2 Fold Change",
         y=""
    ) +
    ggplot2::theme(
      plot.title  = ggplot2::element_text(size = 7),
      axis.text.y = ggplot2::element_text(size= 5)
    ) +
    ggplot2::theme_bw()
}
