#' Generates a coverage plot (Percentage of total coverage of kinases on chip)
#'
#' This function takes in the chipCov map, Z score table, and chip type to produce a coverage plot (Percentage of total coverage of kinases on chip)
#'
#' @param chipCov df of kinase mapping for either STK or PTK chip
#' @param Ztable Z score table
#' @param chipType type of chip, either STK or PTK
#'
#' @return ggplot
#'
#' @import dplyr
#'
#' @export
#'
#' @examples
#' TRUE

krsa_coverage_plot <- function(chipCov, Ztable, chipType = c("STK", "PTK")) {
  chipCov %>% count(Kin, name = "count") %>%
    mutate(Perc = (count/ifelse(chipType == "STK", 141, 193)) *100) %>%
    rename(Kinase = Kin) %>%
    left_join(select(Ztable, -Z, -method), by = "Kinase") %>% distinct() %>%
    mutate(MeanZ =AvgZ) %>%
    filter(!Kinase %in% c("VRK2", "BARK1")) %>%
    mutate(breaks = cut(abs(MeanZ), breaks = c(0, 1, 1.5, 2, Inf), right = F,
                        labels = c("Z <= 1", "1 >= Z < 1.5", "1.5 >= Z < 2", "Z >= 2")
    )) %>%
    ggplot(aes(x = reorder(Kinase,count), Perc, fill = breaks)) + geom_col() +
    scale_fill_brewer(palette="Reds", drop = F, guide = guide_legend(reverse=TRUE, title = "")) +

    geom_text(aes(label = paste0("Z = ",round(MeanZ, 2))), hjust = -0.15, size = 2.2) +
    coord_flip() +
    geom_hline(yintercept = 25, linetype="dashed", alpha = 1/5) +
    geom_hline(yintercept = 50, linetype="dashed", alpha = 1/5) +
    geom_hline(yintercept = 75, linetype="dashed", alpha = 1/5) +
    scale_y_continuous(expand = c(0, 0),labels = function(x) paste0(x, "%"), limits = c(0,102)) +
    theme_classic() +
    labs(
      x = "Kinases",
      y = "Percentage of Chip Coverage"
    ) + theme(

      axis.text.y = element_text(size = 7),
      legend.title = element_blank()

    ) + theme_bw()
}
