#' Visualize the enrichr analysis
#'
#' This function takes in the Enrichr dataframe and plot the results
#'
#' @param enrichr_df the Enrichr dataframe generated from the \code{\link{krsa_enrichr}} function
#' @param terms_to_plot number of terms to plot per library. default is 10
#' @param size size of label text. default is 2.5
#'
#' @return ggplot
#'
#' @family plotting functions
#'
#' @export
#'
#'
#' @examples
#' TRUE



krsa_enrichr_plot <- function(enrichr_df, terms_to_plot = 10,size = 2.5) {

  enrichr_df %>%
    dplyr::group_by(lib) %>%
    dplyr::slice_head(n = terms_to_plot) %>%
    ggplot2::ggplot(ggplot2::aes(x = -log(pvalue), y = stats::reorder(term, -base::log(pvalue)))) +
    ggplot2::geom_col(ggplot2::aes(fill =-base::log(pvalue)), show.legend = F) +
    ggplot2::geom_text(
      ggplot2::aes(label = term),
      size = size,
      ## make labels left-aligned
      hjust = 1, nudge_x = .5
    ) +
    ggplot2::theme_minimal() +
    ggplot2::scale_fill_gradient(low = "#713939", high = "#ff6666") +
    ggplot2::theme(axis.text.y = ggplot2::element_blank()) +
    ggplot2::labs(y = "") +
    ggplot2::facet_wrap(~lib, scales = "free", ncol = 2)

}
