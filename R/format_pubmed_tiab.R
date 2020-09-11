#' Format PubMed title and abstract terms
#'
#' @param taxa A character vector of primate taxa.
#'
#' @return A character vector of search terms for the title and abstract that are associated with the specified taxa, formatted for use in PubMed.
#' @export
#'
#' @examples
#'
#' format_pubmed_tiab("papio")
#' format_pubmed_tiab(c("papio", "macaca"))
format_pubmed_tiab <- function(taxa) {

  # keep columns of taxa specified in function arguments
  ta2 <- ta[, c("term", taxa)]

  # keep rows where at least one column == 1 (narrow)
  # (indicating that search term should be used)
  ta3 <- ta2[rowSums(sapply(ta2[ , 2:ncol(ta2), drop = FALSE],
                            function(x) x == 1),
                     na.rm = TRUE) > 0, ]

  ta3$tiab_term <- "[tiab]"

  # add quotes to terms
  ta3$term <- dQuote(ta3$term)

  # add extension to search term
  ta3$tiab_search_term <- paste0(ta3$term, ta3$tiab_term)

  ta3$tiab_search_term
}
