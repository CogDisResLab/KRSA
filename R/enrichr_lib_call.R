#' Runs enrichr api (single GET call for a geneset library)
#'
#' This function takes in the geneset library name from Enrichr and userListId (id created by enrichr api) sand retruns tidy dataframe of all geneset terms in that library
#'
#' @param lib geneset library name from Enrichr
#' @param userListId id created by the POST enrichr api call
#'
#' @return df tidy dataframe of all geneset terms in that library
#'
#' @family helper functions
#'
#' @export
#'
#'
#' @examples
#' TRUE


enrichr_lib_call <- function(lib, userListId) {

  ENRICHR_URL = 'https://maayanlab.cloud/Enrichr/enrich'
  query_string = '?userListId=%s&backgroundType=%s'


  full_link <- base::paste0(ENRICHR_URL,
                      "?userListId=",
                      userListId,
                      "&backgroundType=",
                      lib)

  base::message(base::paste0(lib, " ..."))

  res <- base::suppressMessages(jsonlite::fromJSON(httr::content(httr::GET(full_link), as="text")))

  purrr::map(res[[1]], process_output) %>%
    purrr::map_df(dplyr::bind_rows) %>%
    dplyr::mutate(lib = lib)

}

process_output <- function(x) {
  x <- stats::setNames(x, c("index", "term", "pvalue", "odds_ratio", "combined_score",
                     "genes", "adjusted_pvalue", "old1", "old2"))

  x[["genes"]] <- base::paste0(x[["genes"]], collapse = ", ")

  x

}

