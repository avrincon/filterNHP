#' Format search terms for PubMed
#'
#' @param taxa A character vector of primate taxa.
#' @param exclude A character vector of primate taxa that are higher in the taxonomic tree than those provided in the taxa argument to exclude from the search terms.
#'
#' @return A string of search terms that are associated with the specified taxa, formatted for use in PubMed.
#'
#' @examples
#' format_pubmed_mesh("papio")
#' format_pubmed_mesh(c("papio", "macaca"))
#'
#' format_pubmed_tiab("papio")
#' format_pubmed_tiab(c("papio", "macaca"))
#'
#' format_pubmed_terms("papio")
#' format_pubmed_terms("cercopithecidae", exclude = "papio")
#'
#' @noRd


format_pubmed_mesh <- function(taxa) {

  pm2 <- pm[, c("term", taxa)]

  # keep rows where at least one taxa column is not NA, and is lower level taxa
  pm3 <- pm2[rowSums(sapply(pm2[ , 2:ncol(pm2), drop = FALSE],
                            function(x) x %in% c("ne", "nn")),
                     na.rm = T) > 0, ]

  # if nrow is 0, there are no mesh terms, return empty object
  if(nrow(pm3) == 0){
    return(NULL)
  }

  # otherwise check if terms should be exploded or not
  xx <- sapply(pm3[ , 2:ncol(pm3), drop = F], function(x) x == "ne")

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
  paste0(pm3$term, pm3$mesh)
}

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
  paste0(ta3$term, ta3$tiab_term)
}


format_pubmed_terms <- function(taxa, exclude = NULL) {

  # convert tolower for greater flexibility in case of input
  taxa <- tolower(taxa)
  if(!is.null(exclude)) exclude <- tolower(exclude)

  # check input to function arguments are correct
  if(!all(taxa %in% correct_taxa_inputs) &
     all(exclude %in% correct_taxa_inputs)){
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
