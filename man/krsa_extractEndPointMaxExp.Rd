% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/krsa_extractEndPointMaxExp.R
\name{krsa_extractEndPointMaxExp}
\alias{krsa_extractEndPointMaxExp}
\title{Extracts end point data at max exposure (last cycle)}
\usage{
krsa_extractEndPointMaxExp(df, type = c("STK", "PTK"))
}
\arguments{
\item{df}{krsa raw tidy data}

\item{type}{chip type}
}
\value{
end point data at max exposure df
}
\description{
This function takes in raw data and chip type and returns end point data at max exposure (last cycle)
}
\examples{
TRUE
}
\seealso{
Other helper functions: 
\code{\link{enrichr_lib_call}()},
\code{\link{krsa_ce_output_kinases}()},
\code{\link{krsa_ce_output_peptides}()},
\code{\link{krsa_enrichr}()},
\code{\link{krsa_extractEndPoint}()},
\code{\link{krsa_get_diff_byChip}()},
\code{\link{krsa_get_diff}()},
\code{\link{krsa_sampling}()},
\code{\link{krsa_show_peptides}()},
\code{\link{krsa_top_hits}()}
}
\concept{helper functions}
