#' TODO
#'
#' TODO
#'
#' @param data krsa data_modeled$scaled
#' @param samples sample names
#' @param peptides vector of peptides
#'
#' @return vector
#'
#' @import dplyr
#' @import rlang
#'
#' @export
#'
#' @examples
#' TRUE

krsa_violin_plot <- function(data, peptides,facet_factor,facet = T,samples = NULL, groups = NULL) {

  data %>% dplyr::filter(Peptide %in% peptides) %>%
    {if(!is.null(samples)) filter(.,SampleName %in% samples) else .} %>%
    {if(!is.null(groups)) filter(.,Group %in% groups) else .} %>%
    ggplot(aes(SampleName, slope)) + geom_violin(aes(fill = Group), show.legend = F) +
    geom_point(size = 1.5)+ geom_line(aes(group = Peptide), alpha = 1/2) +
    labs(
      x = "",
      y = "Signal Intensity"
    ) + theme(
      axis.text.x = element_text(size = 6)

    ) + theme_bw() -> gg

  {if(facet == T) facet_wrap(facet_factor, scales = "free")}
  if(facet == T) {gg + facet_wrap(facet_factor, scales = "free")}
  else {gg}

}
