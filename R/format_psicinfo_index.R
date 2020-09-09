#' Format PscicInfo index search terms
#'
#' @param taxa A character vector of primate taxa.
#'
#' @return A string of index search terms that are associated with the specified taxa, formatted for use in PscicInfo.
#'
#' @examples
#' format_psicinfo_index("cercopithecidae")
format_psicinfo_index <- function(taxa) {

  # keep columns specified in function arguments
  pii2 <- pii[, c("term", taxa)]

  # keep rows where at least one column == 1 (narrow)
  # (indicating that search term should be used)
  pii3 <- pii2[rowSums(sapply(pii2[ , 2:ncol(pii2), drop = FALSE], `==`, 1),
                     na.rm = T) > 0, ]

  # add quotes to all terms regardless of spaces
  pii3$term <- dQuote(pii3$term)

  psycinfo_index_terms <- paste(pii3$term, collapse = " OR ")
  psycinfo_index_terms <- paste0("DE(", psycinfo_index_terms, ")")

  return(psycinfo_index_terms)
}
