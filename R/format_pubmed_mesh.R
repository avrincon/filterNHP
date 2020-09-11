#' Format PubMed mesh terms
#'
#' @param taxa A character vector of primate taxa.
#'
#' @return A character vector of mesh search terms that are associated with the specified taxa, formatted for use in PubMed.
#' @export
#'
#' @examples
#' format_pubmed_mesh("papio")
#' format_pubmed_mesh(c("papio", "macaca"))
format_pubmed_mesh <- function(taxa) {

  pm2 <- pm[, c("term", taxa)]

  # keep rows where at least one taxa column is not NA, and is lower level taxa
  pm3 <- pm2[rowSums(sapply(pm2[ , 2:ncol(pm2), drop = FALSE],
                            function(x) x %in% c("NE", "NN")),
                     na.rm = T) > 0, ]

  # if nrow is 0, there are no mesh terms, return empty object
  if(nrow(pm3) == 0){
    return(NULL)
  }

  # otherwise check if terms should be exploded or not
  xx <- sapply(pm3[ , 2:ncol(pm3), drop = F], function(x) x == "NE")

  # cannot do rowSums when matrix/vector has length 1, so use regular sum()
  if(length(xx) == 1){
    pm3$mesh <- ifelse(sum(xx, na.rm = T) > 0, "[mh]", "[mh:noexp]")
  }
  if(length(xx) > 1){
    pm3$mesh <- ifelse(rowSums(xx, na.rm = T) > 0, "[mh]", "[mh:noexp]")
  }

  # quote terms
  pm3$term <- dQuote(pm3$term)

  # add extension to search term
  pm3$search_term <- paste0(pm3$term, pm3$mesh)

  pm3$search_term
}
