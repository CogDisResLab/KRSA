krsa_violinBox <- function(data, samples, peptides, ctl, case) {
  data %>% dplyr::filter(SampleName %in% samples, Peptide %in% peptides) %>%
    ggplot(aes(Group, slope)) +
    labs(
      x="",
      y=""
    ) +
    theme_light() + facet_wrap(~Chip) +
    theme(axis.text.y = element_text(size = 6)) -> GenPlot

  GenPlot + geom_violin(aes(fill = Group), show.legend = F) +
    geom_point(size = 2.5) +
    geom_line(aes(Group, slope, group = Peptide), alpha = 1/5) -> p1

  GenPlot + stat_summary(fun.data = min.mean.sd.max, geom = "boxplot", aes(fill = Group), show.legend = F)+
    stat_compare_means(comparisons = list(c(case, ctl)), paired = F, method = "wilcox.test") -> p2

  return(list(p1,p2))
}

min.mean.sd.max <- function(x) {
  r <- c(min(x), mean(x) - sd(x), mean(x), mean(x) + sd(x), max(x))
  names(r) <- c("ymin", "lower", "middle", "upper", "ymax")
  r
}
