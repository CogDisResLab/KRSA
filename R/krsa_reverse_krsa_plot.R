#' Generates the reverse krsa plot (to examine kinase activity)
#'
#' This function takes in chipCov df, the LFC table, kinases, LFC threshold, and generates the reverse krsa plot (to examine kinase activity)
#'
#' @param chipCov chipCov df for eaither STK or PTK
#' @param lfc_table the LFC table
#' @param kinases vector of kinases
#' @param lfc_thr LFC threshold
#' @param byChip will facet by Barcode
#' @param facet facet by chip
#'
#' @return ggplot object
#'
#' @family plots
#'
#' @export
#'
#' @examples
#' TRUE

krsa_reverse_krsa_plot <- function(chipCov, lfc_table, kinases, lfc_thr, byChip =  T, facet = F) {

  if(byChip == T) {
    lfc_table$colMean <- cut(lfc_table$totalMeanLFC, breaks = c(-Inf,-1*lfc_thr, lfc_thr, Inf), labels = c("red", "black", "red"))
    lfc_table$colFC <- cut(lfc_table$LFC, breaks = c(-Inf,-1*lfc_thr, lfc_thr, Inf), labels = c("black", "gray", "black"))
  }
  else {
    lfc_table$colFC <- cut(lfc_table$LFC, breaks = c(-Inf,-1*lfc_thr, lfc_thr, Inf), labels = c("red", "black", "red"))
  }

  chipCov %>%
    dplyr::filter(Kin %in% kinases) %>%
    dplyr::rename(Peptide = "Substrates") -> KinHitPeps

  dplyr::left_join(KinHitPeps, lfc_table, by = "Peptide") -> combined_data

  if(byChip == T && facet == T) {
    combined_data %>%
      dplyr::filter(!is.na(totalMeanLFC)) %>%
      dplyr::select(Kin, Peptide,totalMeanLFC, colMean, Barcode) %>%
      dplyr::rename(LFC = totalMeanLFC, colFC = colMean) %>%
      dplyr::distinct() -> combined_data
  }
  else if(byChip == T && facet == F) {
    combined_data %>%
      dplyr::filter(!is.na(totalMeanLFC)) %>%
      dplyr::select(Kin, Peptide,totalMeanLFC, colMean) %>%
      dplyr::rename(LFC = totalMeanLFC, colFC = colMean) %>%
      dplyr::distinct() -> combined_data
  }
  else {
    combined_data %>%
      dplyr::select(Kin, Peptide,LFC, colFC) %>%
      dplyr::distinct() -> combined_data
  }


  combined_data %>%
    ggplot2::ggplot(ggplot2::aes(Kin, LFC)) +
    ggplot2::geom_jitter(ggplot2::aes(color = colFC), position = ggplot2::position_jitter(width = .1), show.legend = F) +
    ggplot2::geom_hline(yintercept = lfc_thr,linetype="dashed") +
    ggplot2::geom_hline(yintercept = -1 * lfc_thr,linetype="dashed") +
    ggplot2::labs(y = "Log2 Fold Change",
         x= "") +
    ggplot2::theme(
      axis.text.x = ggplot2::element_text(size = 4, angle = 30)
    ) +
    ggplot2::scale_colour_identity() +
    ggplot2::theme_bw() -> gg

  if(byChip == T && facet == T) {gg + ggplot2::facet_wrap(~Barcode)} else gg

}
