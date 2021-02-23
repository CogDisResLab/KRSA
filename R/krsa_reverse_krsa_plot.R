#' Generates the reverse krsa plot (to examine kinase activity)
#'
#' This function takes in chipCov df, the LFC table, kinases, LFC threshold, and generates the reverse krsa plot (to examine kinase activity)
#'
#' @param chipCov chipCov df for eaither STK or PTK
#' @param lfc_table the LFC table
#' @param kinases vector of kinases
#' @param lfc_thr LFC threshold
#'
#' @return vector
#'
#' @import dplyr
#'
#' @export
#'
#' @examples
#' TRUE

krsa_reverse_krsa_plot <- function(chipCov, lfc_table, kinases, lfc_thr, byChip =  T) {

  if(byChip == T) {
    lfc_table$colMean <- cut(lfc_table$totalMeanLFC, breaks = c(-Inf,-1*lfc_thr, lfc_thr, Inf), labels = c("red", "black", "red"))
    lfc_table$colFC <- cut(lfc_table$LFC, breaks = c(-Inf,-1*lfc_thr, lfc_thr, Inf), labels = c("black", "gray", "black"))
  }
  else {
    lfc_table$colFC <- cut(lfc_table$LFC, breaks = c(-Inf,-1*lfc_thr, lfc_thr, Inf), labels = c("red", "black", "red"))
  }

  chipCov %>% filter(Kin %in% kinases) %>% rename(Peptide = "Substrates") -> KinHitPeps

  left_join(KinHitPeps, lfc_table, by = "Peptide") -> combined_data

  if(byChip == T) {
    combined_data %>%
      filter(!is.na(totalMeanLFC)) %>%
      select(Kin, Peptide,LFC, colFC, Barcode) %>% distinct() -> combined_data
  }
  else {
    combined_data %>%
      select(Kin, Peptide,LFC, colFC) %>% distinct() -> combined_data
  }


  combined_data %>%
    ggplot(aes(Kin, LFC)) + geom_jitter(aes(color = colFC), position = position_jitter(width = .1), show.legend = F) +
    geom_hline(yintercept = lfc_thr,linetype="dashed") +
    geom_hline(yintercept = -1 * lfc_thr,linetype="dashed") +
    labs(y = "Log2 Fold Change",
         x= "") +
    theme(
      axis.text.x = element_text(size = 4, angle = 30)
    ) +
    scale_colour_identity() +
    theme_bw() -> gg

  if(byChip == T) {gg + facet_wrap(~Barcode)} else gg

}
