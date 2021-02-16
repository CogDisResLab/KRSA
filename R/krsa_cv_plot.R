#' Generates CV (coefficient of variation) plot
#'
#' This function takes in the modeled pw data, list of peptides, and sample names (optional)
#'
#' @param data krsa modeled pw data (scaled)
#' @param peptides peptide list
#' @param samples sample names
#'
#' @return ggplot
#'
#' @import dplyr
#'
#' @export
#'
#' @examples
#' TRUE

krsa_cv_plot <- function(data, peptides,samples = NULL) {

  data %>% filter(Peptide %in% peptides) %>%
    {if(!is.null(samples)) filter(.,SampleName %in% samples) else .} %>%
    group_by(Group, Peptide) %>%
    summarise(SD = sd(slope), repMean = mean(slope), CV = SD/repMean) %>%
    ggplot(aes(repMean, CV)) + geom_point() +
    geom_smooth(method = "loess",aes(color = Group)) + facet_wrap(~Group, scales = "free") +
    ylim(0,1) + labs(title = "CV Plot") + theme_bw()

}
