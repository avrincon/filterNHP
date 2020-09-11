#' Format WebOfScience search terms
#'
#' @param taxa A character vector of primate taxa.
#' @param exclude A character vector of primate taxa that are higher in the taxonomic tree than those provided in the taxa argument to exclude from the search terms.
#'
#' @return A string of search terms that are associated with the specified taxa, formatted for use in WebOfScience.
#' @export
#'
#' @examples
#' format_wos_terms("cercopithecidae")
#' format_wos_terms("cercopithecidae", exclude = "papio")
format_wos_terms <- function(taxa, exclude = NULL) {

  # convert tolower for greater flexibility in case of input
  taxa <- tolower(taxa)
  if(!is.null(exclude)) exclude <- tolower(exclude)

  # check input to function arguments are correct
  if(!all(taxa %in% correct_taxa_inputs)){
    xx <- setdiff(taxa, correct_taxa_inputs)
    stop(paste("These terms are not valid taxa inputs:",
               paste(xx, collapse = ", ")))
  }

  general_terms <- format_wos_general_terms(taxa)

  # exclude specified terms
  if(!is.null(exclude)){

    excl <- check_higher_taxon_bracket(exclude)
    excl_general_terms <- format_wos_general_terms(excl)
    general_terms <- setdiff(general_terms, excl_general_terms)
  }

  general_terms <- paste0(general_terms, collapse = " OR ")

  wos_title_terms <- paste0("TI=(", general_terms, ")")
  wos_abtract_terms <- paste0("AB=(", general_terms, ")")
  wos_author_keywords_terms <- paste0("AK=(", general_terms, ")")


  paste0(c(wos_title_terms,
           wos_abtract_terms,
           wos_author_keywords_terms), collapse = " OR ")

}
