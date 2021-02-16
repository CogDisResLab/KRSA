#' Generates a grouped heatmap
#'
#' This function takes in the grouped modeled pw data, peptides and produces and pheatmap
#'
#' @param data grouped modeled pw data
#' @param peptides peptide list
#' @param groups (optional) group names
#' @param scaled argument in pheatmap
#'
#' @return pheatmap object
#'
#' @import dplyr
#' @import pheatmap
#'
#' @export
#'
#' @examples
#' TRUE

krsa_heatmap_grouped <- function(data, peptides,groups = NULL, scaled = "row", ...) {

  data %>%
    filter(Peptide %in% peptides) %>%
    {if(!is.null(groups)) filter(.,Group %in% group) else .} %>%
    select(Peptide, Group, slope) %>%
    spread(key = Group, value = slope) %>%
    column_to_rownames("Peptide") %>%
    as.matrix() -> HM_matrix2_test1


  dd <- dist(scale(t(HM_matrix2_test1)))
  pheatmap::pheatmap(HM_matrix2_test1, clustering_distance_cols = dd,
                     scale = scaled,
                     clustering_method = "ward.D2",
                     color = colorRampPalette(c("yellow", "white", "red"))(n = 50),
                     fontsize_row = 5,
                     ...
  ) -> p1


  p1

}
