#' Parse bionavigator crosstab files
#'
#' Main function that parses bionavigator crosstab view files. Takes in path to file and type (either Signal or SignalSaturation)
#'
#' @param file_path path to BN crosstab file
#' @param type Name of the value (either Signal or SignalSaturation)
#'
#' @return tbl_df
#'
#' @export
#'
#' @examples
#' TRUE

parse_BN_crosstabFile <- function(file_path, type = c("Signal", "SignalSaturation")) {
  # Parse a BN crosstab file
  # Created 2020-02-14
  # Last Updated 2020-02-14

  df <- utils::read.csv(file_path,
                 sep = "\t", header = F, stringsAsFactors = F)

  meta_rows <- which(df[,1] == "")
  epmty_col <- which(df[meta_rows[1],] == "")

  meta_info <- df[meta_rows,(epmty_col[length(epmty_col)]+1):ncol(df)]

  rows_end <- nrow(df)
  rows_start <- meta_rows[(length(meta_rows))]+2

  data <- df[rows_start:rows_end,]
  data <- data[,c(1,(epmty_col[length(epmty_col)]+2):ncol(data))]

  df2 <- data.frame(t(data[-1]), stringsAsFactors = F)
  colnames(df2) <- data[, 1]
  colnames(df2) <- make.unique(colnames(df2))

  df3 <- data.frame(t(meta_info[-1]), stringsAsFactors = F)
  colnames(df3) <- meta_info[, 1]
  cbind(df3,df2) -> df4

  df4 %>%
    tidyr::pivot_longer(cols = (length(meta_rows)+1):ncol(.), names_to = "Peptide", values_to = type) -> tidydata

  tidydata$`Exposure time` <- as.numeric(tidydata$`Exposure time`)
  tidydata$Cycle <- as.numeric(tidydata$Cycle)

  if(type == "Signal") {
    tidydata$Signal <- as.numeric(tidydata$Signal)
  }

  else {
    tidydata$SignalSaturation <- as.numeric(tidydata$SignalSaturation)
  }

  tidydata %>%
    dplyr::rename(SampleName = `Sample name`,ExposureTime = `Exposure time`) -> tidydata

  return(tidydata)

}
