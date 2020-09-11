#' Format non-human primate search terms for use in databases
#'
#' @param database A string indicating which database search terms should be formated for. Current options are "PubMed" (default), "PsycInfo" or "WebOfScience".
#' @param taxa A character vector of primate taxa.
#' @param exclude A character vector of primate taxa that are higher in the taxonomic tree than those provided in the taxa argument to exclude from the search terms.
#'
#' @return A string of search terms that are associated with the specified taxa, formatted for use in the specified database.
#' @export
#'
#' @examples
#' search_nhp(database = "PsycInfo", taxa = "papio")
#' search_nhp(database = "PubMed", taxa = "cercopithecidae", exclude = "papio")
#' search_nhp(database = "WebOfScience", taxa = "Platyrrhini", exclude = "Aotus")
search_nhp <-
  function(database = "PubMed",
           taxa = NULL,
           exclude = NULL) {

    # convert tolower for greater flexibility in case of input
    if(!is.null(taxa))    taxa <- tolower(taxa)
    if(!is.null(exclude)) exclude <- tolower(exclude)

    # check input to function arguments are correct
    if(!all(taxa %in% correct_taxa_inputs)){
      xx <- setdiff(taxa, correct_taxa_inputs)
      stop(paste("These terms are not valid taxa inputs:",
                 paste(xx, collapse = ", ")))
    }

    # by default (when all taxa = NULL), function will return search terms for all non-human primates
    if(is.null(taxa)){
      taxa <- c("nhps", taxa)
    }

    if(database == "PubMed"){
      term <- format_pubmed_terms(taxa, exclude)

    } else if(database == "PsycInfo"){
      term <- format_psycinfo_terms(taxa, exclude)

    } else if(database == "WebOfScience"){
      term <- format_wos_terms(taxa, exclude)
    }

    term

  }
