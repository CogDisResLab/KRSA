krsa_waterfall <- function(table, title) {
  ggplot(table) +
    geom_point(aes(LFC, reorder(Peptide,LFC)), color = table$colFC, size = 0.75) +
    geom_point(aes(totalMeanLFC, reorder(Peptide,totalMeanLFC)), color = table$colMean, size = 1.2) +
    geom_line(aes(LFC, reorder(Peptide,totalMeanLFC)), alpha = 1/3) +
    geom_vline(xintercept = 0) +
    geom_vline(xintercept = -2,linetype="dashed") +
    geom_vline(xintercept = 2,linetype="dashed")+
    labs(x = "Log2 Fold Change",
         y="",
         title = paste0("Log2 Fold Change of Signal Intensity Between ", title)
         #caption  = "Threshold is 15% Change"
    ) +
    theme(plot.title  = element_text(size = 7),
          axis.text.y = element_text(size= 5)
    )
}
