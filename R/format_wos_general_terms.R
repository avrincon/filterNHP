#' Format WebOfScience general search terms
#'
#' @param taxa A character vector of primate taxa.
#'
#' @return A string of search terms that are associated with the specified taxa, formatted for use in WebOfScience.
#'
#' @examples
#' format_wos_general_terms("papio")
format_wos_general_terms <- function(taxa) {

  # keep columns of taxa specified in function arguments
  ta2 <- ta[, c("term", taxa)]

  # keep rows where at least one column == 1 (narrow)
  # (indicating that search term should be used)
  ta3 <- ta2[rowSums(sapply(ta2[ , 2:ncol(ta2), drop = FALSE], `==`, 1),
                     na.rm = TRUE) > 0, ]

  # add quotes to terms
  ta3$term <- dQuote(ta3$term)

  ta3$term
}
