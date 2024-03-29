% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/krsa_enrichr.R
\name{krsa_enrichr}
\alias{krsa_enrichr}
\title{Runs enrichr analysis using a list of PamChip peptide IDs or genes}
\usage{
krsa_enrichr(
  peptides = NULL,
  genes = NULL,
  libs = c("GO_Biological_Process_2021", "GO_Cellular_Component_2021",
    "GO_Molecular_Function_2021", "WikiPathway_2021_Human", "Reactome_2016",
    "KEGG_2021_Human", "BioPlanet_2019")
)
}
\arguments{
\item{peptides}{a vector of PamChip peptide IDs}

\item{genes}{(optional) a vector of HGNC symbols. This will override the list of peptides}

\item{libs}{geneset libraries names from Enrichr. default: c("GO_Biological_Process_2021", "GO_Cellular_Component_2021","GO_Molecular_Function_2021", "WikiPathway_2021_Human","Reactome_2016", "KEGG_2021_Human", "BioPlanet_2019")}
}
\value{
df tidy dataframe of all geneset terms in that library
}
\description{
This function takes in a list of PamChip peptide IDs or genes and geneset libraries names and connects to Enrichr api and returns enriched terms the geneset library name from Enrichr and userListId (id created by enrichr api) sand retruns tidy dataframe of all geneset terms in that library
}
\examples{
TRUE
}
\seealso{
Other helper functions: 
\code{\link{enrichr_lib_call}()},
\code{\link{krsa_ce_output_kinases}()},
\code{\link{krsa_ce_output_peptides}()},
\code{\link{krsa_extractEndPointMaxExp}()},
\code{\link{krsa_extractEndPoint}()},
\code{\link{krsa_get_diff_byChip}()},
\code{\link{krsa_get_diff}()},
\code{\link{krsa_sampling}()},
\code{\link{krsa_show_peptides}()},
\code{\link{krsa_top_hits}()}
}
\concept{helper functions}
