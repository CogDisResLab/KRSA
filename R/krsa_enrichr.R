#' Runs enrichr analysis using a list of PamChip peptide IDs or genes
#'
#' This function takes in a list of PamChip peptide IDs or genes and geneset libraries names and connects to Enrichr api and returns enriched terms the geneset library name from Enrichr and userListId (id created by enrichr api) sand retruns tidy dataframe of all geneset terms in that library
#'
#' @param peptides a vector of PamChip peptide IDs
#' @param libs geneset libraries names from Enrichr. default: c("GO_Biological_Process_2021", "GO_Cellular_Component_2021","GO_Molecular_Function_2021", "WikiPathway_2021_Human","Reactome_2016", "KEGG_2021_Human", "BioPlanet_2019")
#' @param genes (optional) a vector of HGNC symbols. This will override the list of peptides
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


krsa_enrichr <- function(peptides = NULL, genes = NULL,
                             libs = c("GO_Biological_Process_2021", "GO_Cellular_Component_2021",
                                      "GO_Molecular_Function_2021", "WikiPathway_2021_Human",
                                        "Reactome_2016", "KEGG_2021_Human", "BioPlanet_2019")){

  if(all(c(is.null(peptides), is.null(genes)))) {
    stop("peptides and genes arguments can't be both NULL")
  }

  input_list <- NULL

  if(!is.null(genes)) {
    input_list <- genes
  } else {
    input_list <- base::rbind(KRSA::stk_pamchip_87102_mapping, KRSA::ptk_pamchip_86402_mapping) %>%
      dplyr::filter(ID %in% peptides) %>%
      dplyr::pull(HGNC) %>% base::unique()
  }

  link <- "https://maayanlab.cloud/Enrichr/addList"

  jsonlite::fromJSON(httr::content(httr::POST(link,
                                  body = list(list = paste0(input_list, collapse = "\n"))),
                             as = "text",
                             encoding = "UTF-8")) -> res

  purrr::map_df(libs, KRSA::enrichr_lib_call, res$userListId) %>%
    dplyr::select(-old1,-old2)

}
