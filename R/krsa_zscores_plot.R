#' TODO
#'
#' TODO
#'
#' @param Ztable Z score table
#'
#' @return vector
#'
#' @import dplyr
#'
#' @export
#'
#' @examples
#' TRUE


krsa_zscores_plot <- function(Ztable) {
  Ztable %>% filter(!Kinase %in% c("VRK2", "BARK1")) %>%
    mutate(breaks = cut(abs(AvgZ), breaks = c(0, 1, 1.5, 2, Inf), right = F,
                        labels = c("Z <= 1", "1 >= Z < 1.5", "1.5 >= Z < 2", "Z >= 2")
    )) %>%
    ggplot() +
    geom_line(aes(Z, reorder(Kinase,AvgZ)), alpha = 1/3) +
    geom_point(aes(Z, reorder(Kinase,AvgZ)), color = "grey", size = 1) +
    geom_point(aes(AvgZ, reorder(Kinase,AvgZ), color = breaks), size = 2) +
    geom_vline(xintercept = 0) +
    geom_vline(xintercept = c(-1, -1.5, -2, 1, 1.5, 2),linetype="dashed") +
    scale_color_brewer(palette="Reds", drop = F, guide = guide_legend(reverse=TRUE, title = "")) +
    labs(x = "Z",
         y="",
         shape = "cutoff"
    ) +
    theme(plot.title  = element_text(size = 7),
          axis.text.y = element_text(size= 6)

    ) + theme_bw()
}



