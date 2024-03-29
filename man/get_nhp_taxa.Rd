% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_nhp_taxa.R
\name{get_nhp_taxa}
\alias{get_nhp_taxa}
\title{Get taxonomic terms for non-human primates}
\usage{
get_nhp_taxa(level = "all")
}
\arguments{
\item{level}{Specify which level to get taxonomic terms for. Defaults to
"all". Other options are "suborder", "infraorder", "parvorder",
"superfamily", "family", "subfamily", "tribe" or "genus".}
}
\value{
A named list with taxonomic terms for each level.
}
\description{
Get taxonomic terms for non-human primates
}
\examples{
get_nhp_taxa("genus")
}
