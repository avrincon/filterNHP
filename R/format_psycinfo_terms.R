#' Format PscicInfo index search terms
#'
#' @param taxa A character vector of primate taxa.
#' @param exclude A character vector of primate taxa that are higher in the taxonomic tree than those provided in the taxa argument to exclude from the search terms.
#'
#' @return A string of search terms that are associated with the specified taxa, formatted for use in PscicInfo.
#' @export
#'
#' @examples
#' format_psycinfo_terms("cercopithecidae")
#' format_psycinfo_terms("cercopithecidae", exclude = "papio")
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

  return(paste0(c(index_terms,
                  tiab_terms), collapse = " OR "))
}
