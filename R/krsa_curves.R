krsa_curves <- function(data, samples, peptides, title) {
  data %>% filter(SampleName %in% samples, Peptide %in% peptides) %>%
    ggplot(aes(ExposureTime, Signal, group =Group)) +
    geom_smooth(method = lm, formula = y~x+0, se=F, aes(color = factor(Group))) +
    facet_wrap(~ Peptide, scales = "free") + theme_light() +
    labs(title = paste0("Linear Model Fit of Signal Intensity Relative to Exposure Time at Post-wash Cycle of ", title, " Samples")
    )
}
