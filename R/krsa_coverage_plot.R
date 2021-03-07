#' Generates a coverage plot (Percentage of total coverage of kinases on chip)
#'
#' This function takes in the chipCov map, Z score table, and chip type to produce a coverage plot (Percentage of total coverage of kinases on chip)
#'
#' @param chipCov df of kinase mapping for either STK or PTK chip
#' @param Ztable Z score table
#' @param chipType type of chip, either STK or PTK
#'
#' @return ggplot object
#'
#' @family plots
#'
#' @export
#'
#' @examples
#' TRUE

krsa_coverage_plot <- function(chipCov, Ztable, chipType = c("STK", "PTK")) {
  chipCov %>%
    dplyr::count(Kin, name = "count") %>%
    dplyr::mutate(Perc = (count/ifelse(chipType == "STK", 141, 193)) *100) %>%
    dplyr::rename(Kinase = Kin) %>%
    dplyr::left_join(dplyr::select(Ztable, -Z, -method), by = "Kinase") %>%
    dplyr::distinct() %>%
    dplyr::mutate(MeanZ =AvgZ) %>%
    dplyr::filter(!Kinase %in% c("VRK2", "BARK1")) %>%
    dplyr::mutate(breaks = cut(abs(MeanZ), breaks = c(0, 1, 1.5, 2, Inf), right = F,
                        labels = c("Z <= 1", "1 >= Z < 1.5", "1.5 >= Z < 2", "Z >= 2")
    )) %>%
    ggplot2::ggplot(ggplot2::aes(x = stats::reorder(Kinase,count), Perc, fill = breaks)) +
    ggplot2::geom_col() +
    ggplot2::scale_fill_brewer(palette="Reds", drop = F, guide = ggplot2::guide_legend(reverse=TRUE, title = "")) +
    ggplot2::geom_text(ggplot2::aes(label = paste0("Z = ",round(MeanZ, 2))), hjust = -0.15, size = 2.2) +
    ggplot2::coord_flip() +
    ggplot2::geom_hline(yintercept = 25, linetype="dashed", alpha = 1/5) +
    ggplot2::geom_hline(yintercept = 50, linetype="dashed", alpha = 1/5) +
    ggplot2::geom_hline(yintercept = 75, linetype="dashed", alpha = 1/5) +
    ggplot2::scale_y_continuous(expand = c(0, 0),labels = function(x) paste0(x, "%"), limits = c(0,102)) +
    ggplot2::labs(
      x = "Kinases",
      y = "Percentage of Chip Coverage"
    ) + ggplot2::theme(
      axis.text.y = ggplot2::element_text(size = 7),
      legend.title = ggplot2::element_blank()

    ) + ggplot2::theme_bw()
}
