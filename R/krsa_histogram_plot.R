#' Generates kinase histogram plots based on the KRSA function output
#'
#' This function takes in Z score table, and count matrix (an output from krsa()) and generates distribution histograms for a list of kinases
#'
#' @param data Z score table from krsa()
#' @param data2 count matrix from krsa()
#' @param kinases a vector of kinases
#'
#' @return ggplot object
#'
#' @export
#'
#' @examples
#' TRUE


krsa_histogram_plot <- function(data,data2,kinases) {
  data2 %>%
    dplyr::rename(Kinase = Kin) %>%
    dplyr::filter(Kinase %in% kinases) %>%
    ggplot2::ggplot() +
    ggplot2::geom_histogram(aes(counts),binwidth = 1,fill= "gray30", color = "black") +
    ggplot2::geom_rect(data=dplyr::filter(data, Kinase %in% kinases),aes(xmin=SamplingAvg+(2*SD), xmax=SamplingAvg-(2*SD), ymin=0, ymax=Inf),
              fill="gray", alpha=0.5) +
    ggplot2::geom_vline(data=dplyr::filter(data, Kinase %in% kinases), aes(xintercept = Observed), color = "red", size = 1,show.legend = F) +
    ggplot2::facet_wrap(~ Kinase, scales = "free") +
    ggplot2::labs(x = "Hits", y = "Counts") +
    ggplot2::theme_bw() +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
}

