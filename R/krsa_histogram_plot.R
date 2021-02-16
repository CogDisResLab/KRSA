#' Read crosstab format files exported from bioNavigator and tidy them
#'
#' This function takes in a BPNList object and returns a BPNList object
#'
#' @param data krsa data_modeled$scaled
#' @param samples sample names
#' @param lfc_thr LFC cutoff for plot
#'
#' @return ggplot
#'
#' @import dplyr
#'
#' @export
#'
#' @examples
#' TRUE


krsa_histogram_plot <- function(data,data2,kinases) {
  data2 %>% rename(Kinase = Kin) %>%
    filter(Kinase %in% kinases) %>%
    ggplot() +
    geom_histogram(aes(counts),binwidth = 1,fill= "gray30", color = "black") +
    geom_rect(data=filter(data, Kinase %in% bothways),aes(xmin=SamplingAvg+(2*SD), xmax=SamplingAvg-(2*SD), ymin=0, ymax=Inf),
              fill="gray", alpha=0.5
    ) +
    geom_vline(data=filter(data, Kinase %in% bothways), aes(xintercept = Observed), color = "red", size = 1,show.legend = F) +
    facet_wrap(~ Kinase, scales = "free") + labs(x = "Hits", y = "Counts") +
    theme_bw() + theme(plot.title = element_text(hjust = 0.5))
}

