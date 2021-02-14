#' Read crosstab format files exported from bioNavigator and tidy them
#'
#' This function takes in a BPNList object and returns a BPNList object
#'
#' @param data krsa tidy data
#' @param samples sample names
#' @param peptides peptide list
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

krsa_heatmap <- function(data, samples, peptides, scaled = "row") {

  data %>% dplyr::filter(Peptide %in% peptides,
                         SampleName%in% samples) %>%
    select(Peptide, SampleName, slope) %>% spread(key = SampleName, value = slope) %>%
    column_to_rownames("Peptide") %>% as.matrix() -> HM_matrix2_test1

  tidydata %>% select(SampleName, Group) %>% distinct() %>%
    column_to_rownames("SampleName") -> SamplesAnnotation

  dd <- dist(scale(t(HM_matrix2_test1)))
  pheatmap::pheatmap(HM_matrix2_test1, clustering_distance_cols = dd,
                     #clustering_callback = callback,
                     scale = scaled,
                     clustering_method = "ward.D2",
                     annotation_col = SamplesAnnotation,
                     color = colorRampPalette(c("yellow", "white", "red"))(n = 50),
                     fontsize_row = 5
  ) -> p1


  p1

}
