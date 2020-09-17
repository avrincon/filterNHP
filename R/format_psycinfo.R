#' Format search terms for PscicInfo
#'
#' @param taxa A character vector of primate taxa.
#' @param exclude A character vector of primate taxa that are higher in the taxonomic tree than those provided in the taxa argument to exclude from the search terms.
#'
#' @return A string of search terms that are associated with the specified taxa, formatted for use in PscicInfo.
#'
#' @examples
#' format_psicinfo_index("cercopithecidae")
#'
#' format_psicinfo_tiab("lorisidae")
#'
#' format_psycinfo_terms("cercopithecidae")
#' format_psycinfo_terms("cercopithecidae", exclude = "papio")
#'
#' @noRd
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

  psycinfo_index_terms
}

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

format_psycinfo_terms <- function(taxa, exclude = NULL) {

  # convert tolower for greater flexibility in case of input
  taxa <- tolower(taxa)
  if(!is.null(exclude)) exclude <- tolower(exclude)

  # check input to function arguments are correct
  if(!all(taxa %in% correct_taxa_inputs)){
    xx <- setdiff(taxa, correct_taxa_inputs)
    stop(paste("These terms are not valid taxa inputs:",
               paste(xx, collapse = ", ")))
  }

  # get terms
  index_terms <- format_psicinfo_index(taxa)
  tiab_terms <- format_psicinfo_tiab(taxa)

  # exclude specified terms
  if(!is.null(exclude)){

    excl <- check_higher_taxon_bracket(exclude)

    excl_index_terms <- format_psicinfo_index(excl)
    excl_tiab_terms <- format_psicinfo_tiab(excl)

    index_terms <- setdiff(index_terms, excl_index_terms)
    tiab_terms <- setdiff(tiab_terms, excl_tiab_terms)
  }

  paste0(c(index_terms,
           tiab_terms), collapse = " OR ")
}
