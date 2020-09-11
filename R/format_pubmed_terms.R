#' Format PubMed search terms
#'
#' @param taxa A character vector of primate taxa.
#' @param exclude A character vector of primate taxa that are higher in the taxonomic tree than those provided in the taxa argument to exclude from the search terms.
#'
#' @return A string of search terms that are associated with the specified taxa, formatted for use in PubMed.
#'
#' @export
#'
#' @examples
#' format_pubmed_terms("papio")
#' format_pubmed_terms("cercopithecidae", exclude = "papio")
format_pubmed_terms <- function(taxa, exclude = NULL) {

  # convert tolower for greater flexibility in case of input
  taxa <- tolower(taxa)
  if(!is.null(exclude)) exclude <- tolower(exclude)

  # check input to function arguments are correct
  if(!all(taxa %in% correct_taxa_inputs)){
    xx <- setdiff(taxa, correct_taxa_inputs)
    stop(paste("These terms are not valid taxa inputs:",
               paste(xx, collapse = ", ")))
  }

  mesh_terms <- format_pubmed_mesh(taxa)
  tiab_terms <- format_pubmed_tiab(taxa)

  if(!is.null(exclude)){

    excl <- check_higher_taxon_bracket(exclude)

    excl_mesh_terms <- format_pubmed_mesh(excl)
    excl_tiab_terms <- format_pubmed_tiab(excl)

    mesh_terms <- setdiff(mesh_terms, excl_mesh_terms)
    tiab_terms <- setdiff(tiab_terms, excl_tiab_terms)
  }

  paste0(c(sort(mesh_terms),
           sort(tiab_terms)), collapse = " OR ")

}
