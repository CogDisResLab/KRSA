#' Generates a heatmap based on the modeled pw data
#'
#' This function takes in the modeled pw data, peptides and produces and pheatmap
#'
#' @param data modeled pw data
#' @param peptides peptide list
#' @param samples (optional) sample names
#' @param groups (optional) group names
#' @param scaled argument in pheatmap to scale per row
#' @param ... to pass to the pheatmap function
#'
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

krsa_heatmap <- function(data, peptides,samples = NULL,groups = NULL, scaled = "row", ...) {

  data %>%
    filter(Peptide %in% peptides) %>%
    {if(!is.null(samples)) filter(.,SampleName %in% samples) else .} %>%
    {if(!is.null(groups)) filter(.,Group %in% groups) else .} %>%
    select(Peptide, SampleName, slope) %>%
    spread(key = SampleName, value = slope) %>%
    column_to_rownames("Peptide") %>%
    as.matrix() -> HM_matrix2_test1

  data %>%
    select(SampleName, Group) %>%
    distinct() %>%
    column_to_rownames("SampleName") -> SamplesAnnotation

  dd <- dist(scale(t(HM_matrix2_test1)))
  pheatmap::pheatmap(HM_matrix2_test1, clustering_distance_cols = dd,
                     scale = scaled,
                     clustering_method = "ward.D2",
                     annotation_col = SamplesAnnotation,
                     color = colorRampPalette(c("yellow", "white", "red"))(n = 50),
                     fontsize_row = 5,
                     ...
  ) -> p1


  p1

}
