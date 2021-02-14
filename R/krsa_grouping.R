#' Define Groups in the data
#'
#' This function takes tidy krsa table and creates a grouping a column
#'
#' @param df tidy krsa format
#' @param sm_col SampleName column
#'
#' @return tbl_df
#'
#' @import dplyr
#' @import rlang
#'
#' @export
#'
#' @examples
#' TRUE

krsa_grouping <- function(df, sm_col) {
  # Read tidy krsa table and creates a grouping column (Group)
  # Created 2020-02-14
  # Last Updated 2020-02-14

  df %>% mutate("Group" = {{ sm_col }})


}
