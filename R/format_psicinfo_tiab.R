#' Format PscicInfo title and abstract search terms
#'
#' @param taxa A character vector of primate taxa.
#'
#' @return A string of search terms that are associated with the specified taxa, formatted for use in PscicInfo.
#'
#'
#' @examples
#' format_psicinfo_tiab("lorisidae")
format_psicinfo_tiab <- function(taxa) {

  # keep columns of taxa specified in function arguments
  ta2 <- ta[, c("term", taxa)]

  # keep rows where at least one column == 1 (narrow)
  # (indicating that search term should be used)
  ta3 <- ta2[rowSums(sapply(ta2[ , 2:ncol(ta2), drop = FALSE], `==`, 1),
                     na.rm = T) > 0, ]

  ta3$tiab_term <- "[tiab]"

  # add quotes to terms
  ta3$term <- dQuote(ta3$term)

  general_terms <- paste0(ta3$term, collapse = " OR ")

  psycinfo_title_terms <- paste0("TI(", general_terms, ")")
  psycinfo_abtract_terms <- paste0("AB(", general_terms, ")")

  psycinfo_tiab_terms <- paste0(c(psycinfo_title_terms,
                                  psycinfo_abtract_terms), collapse = " OR ")

  psycinfo_tiab_terms
}
