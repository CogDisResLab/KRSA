#' Fits, scales, transforms, and normalize kinome array data
#'
#' Runs a linear model on the tidy kinome array data of the signal as a function of exposure time. It also scales, transforms, and normalize kinome array data based on the barcode
#'
#' @param df kinome array data tidy data
#' @param pep Peptide List
#'
#' @return list of scaled , normlaized and grouped modeled data
#'
#' @import dplyr
#'
#' @export
#'
#' @examples
#' TRUE

krsa_scaleModel <- function(df, pep) {

  df %>% filter(Peptide %in% pep) %>%
    select(SampleName, Peptide, Group, Barcode, Signal, ExposureTime) %>%
    nest(-SampleName, -Peptide,-Group, -Barcode) %>%
    group_by(SampleName, Peptide) %>%
    mutate(
      fit = map(data,~ lm(Signal ~ ExposureTime + 0, data = .x)),
      coefs = map(fit, tidy),
      summary = map(fit, glance),
      #.default argument to replace NA/NaN values
      slope = map_dbl(coefs,pluck,2,.default = 0),
      r.seq = map_dbl(summary, "r.squared")
    ) %>%
    ungroup() %>%
    select(Group, Barcode, SampleName, Peptide, slope, r.seq) %>%
    mutate(slope = log2(slope*100), slope = ifelse(slope < 0, 0, slope)) -> df_model

  df_model %>% group_by(Barcode, Peptide) %>% mutate(Mean = mean(slope)) %>%
    ungroup() %>% mutate(slope = slope/Mean) -> df_model_norm

  df_model %>%
    group_by(Group, Peptide) %>%
    summarise(slope =  EnvStats::geoMean(slope),r.seq=EnvStats::geoMean(r.seq)) -> df_model_grouped

  return(list(scaled = df_model, normalized = df_model_norm, grouped = df_model_grouped))

}
