#' Generates a heatmap based on the modeled pw data
#'
#' This function takes in the modeled pw data, peptides and produces and pheatmap
#'
#' @param data modeled pw data
#' @param peptides peptide list
#' @param samples (optional) sample names
#' @param groups (optional) group names
#' @param ... to pass to the pheatmap function
#'
#'
#' @return pheatmap object
#'
#'
#' @export
#'
#' @examples
#' TRUE

krsa_heatmap <- function(data, peptides,samples = NULL,groups = NULL, ...) {

  data %>%
    dplyr::filter(Peptide %in% peptides) %>%
    {if(!is.null(samples)) dplyr::filter(.,SampleName %in% samples) else .} %>%
    {if(!is.null(groups)) dplyr::filter(.,Group %in% groups) else .} %>%
    dplyr::select(Peptide, SampleName, slope) %>%
    tidyr::spread(key = SampleName, value = slope) %>%
    column_to_rownames("Peptide") %>%
    as.matrix() -> HM_matrix2_test1

  data %>%
    dplyr::select(SampleName, Group) %>%
    dplyr::distinct() %>%
    column_to_rownames("SampleName") -> SamplesAnnotation

  dd <- stats::dist(scale(t(HM_matrix2_test1)))
  pheatmap::pheatmap(HM_matrix2_test1, clustering_distance_cols = dd,
                     annotation_col = SamplesAnnotation,
                     color = grDevices::colorRampPalette(c("yellow", "white", "red"))(n = 50),
                     fontsize_row = 5,
                     ...
  ) -> p1


  p1

}
