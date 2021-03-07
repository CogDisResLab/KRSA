#' Fits, scales, transforms, and normalize kinome array data
#'
#' Runs a linear model on the tidy kinome array data of the signal as a function of exposure time. It also scales, transforms, and normalize kinome array data based on the barcode
#'
#' @param df kinome array data tidy data
#' @param pep Peptide List
#'
#' @return list of scaled , normalized and grouped modeled data
#'
#' @family core functions
#'
#' @export
#'
#' @examples
#' TRUE

krsa_scaleModel <- function(df, pep) {

  df %>%
    dplyr::filter(Peptide %in% pep) %>%
    dplyr::select(SampleName, Peptide, Group, Barcode, Signal, ExposureTime) %>%
    tidyr::nest(-SampleName, -Peptide,-Group, -Barcode) %>%
    dplyr::group_by(SampleName, Peptide) %>%
    dplyr::mutate(
      fit = purrr::map(data,~ stats::lm(Signal ~ ExposureTime + 0, data = .x)),
      coefs = purrr::map(fit, broom::tidy),
      summary = purrr::map(fit, broom::glance),
      #.default argument to replace NA/NaN values
      slope = purrr::map_dbl(coefs,purrr::pluck,2,.default = 0),
      r.seq = purrr::map_dbl(summary, "r.squared")
    ) %>%
    dplyr::ungroup() %>%
    dplyr::select(Group, Barcode, SampleName, Peptide, slope, r.seq) %>%
    dplyr::mutate(slope = log2(slope*100), slope = ifelse(slope < 0, 0, slope)) -> df_model

  df_model %>%
    dplyr::group_by(Barcode, Peptide) %>%
    dplyr::mutate(Mean = mean(slope)) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(slope = slope/Mean) -> df_model_norm

  df_model %>%
    dplyr::group_by(Group, Peptide) %>%
    dplyr::summarise(slope =  EnvStats::geoMean(slope),r.seq=EnvStats::geoMean(r.seq)) -> df_model_grouped

  return(list(scaled = df_model, normalized = df_model_norm, grouped = df_model_grouped))

}
