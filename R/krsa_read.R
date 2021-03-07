#' Read crosstab format files exported from bioNavigator and tidy them
#'
#' This function takes in paths to the median signal minus background (Median_SigmBg) and signal saturation (Signal_Saturation) files and parse and tidy them
#'
#' @param signal_file path to median signal minus background file (Median_SigmBg)
#' @param signal_saturation path to signal saturation file (Signal_Saturation)
#'
#' @return tbl_df
#'
#' @family core functions
#'
#' @export
#'
#' @examples
#' TRUE

krsa_read <- function(signal_file, signal_saturation) {
  # Read Files and return tidy tbl
  # Created 2020-02-14
  # Last Updated 2020-02-14


  sig_df <- parse_BN_crosstabFile(signal_file, "Signal")

  if(missing(signal_saturation)) {

    sig_df

  } else {

    sig_sat <- parse_BN_crosstabFile(signal_saturation, "SignalSaturation")

    if(identical(dim(sig_df), dim(sig_sat))) {
      rowsIDs <- nrow(sig_df)

      sig_df %>% dplyr::mutate(ID = rep(1:rowsIDs)) -> sig_df
      sig_sat %>% dplyr::mutate(ID = rep(1:rowsIDs)) -> sig_sat

      combined_tidy <- dplyr::left_join(sig_df, dplyr::select(sig_sat, ID, SignalSaturation), by = "ID")

      dplyr::select(combined_tidy, -ID)
    }

    else {stop("Dims are not equal")}

  }


}
