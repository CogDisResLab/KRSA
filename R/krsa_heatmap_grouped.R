#' Generates a grouped heatmap
#'
#' This function takes in the grouped modeled pw data, peptides and produces a pheatmap object
#'
#' @param data grouped modeled pw data
#' @param peptides peptide list
#' @param groups (optional) group names
#' @param ... arguments passed to pheatmap()
#'
#' @return pheatmap object
#'
#' @family plots
#'
#' @export
#'
#' @examples
#' TRUE

krsa_heatmap_grouped <- function(data, peptides,groups = NULL, ...) {

  data %>%
    dplyr::filter(Peptide %in% peptides) %>%
    {if(!is.null(groups)) dplyr::filter(.,Group %in% group) else .} %>%
    dplyr::select(Peptide, Group, slope) %>%
    tidyr::spread(key = Group, value = slope) %>%
    column_to_rownames("Peptide") %>%
    as.matrix() -> HM_matrix2_test1


  dd <- stats::dist(scale(t(HM_matrix2_test1)))
  pheatmap::pheatmap(HM_matrix2_test1, clustering_distance_cols = dd,
                     clustering_method = "ward.D2",
                     color = grDevices::colorRampPalette(c("yellow", "white", "red"))(n = 50),
                     fontsize_row = 5,
                     ...
  ) -> p1


  p1

}
