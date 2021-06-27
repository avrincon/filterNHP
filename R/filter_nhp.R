#' Format non-human primate search terms for use in databases
#'
#' Function will return search terms for all taxa below the specified taxonomic
#' level. Search terms for humans are always omitted, even if they are part of
#' that taxonomic group.
#'
#' @param source A string indicating which bibliographic source search terms
#'   should be formatted for. Current options are "PubMed" (default), "PsycInfo"
#'   or "WebOfScience".
#' @param taxa A character vector of primate taxa. If \code{taxa =
#'   "nonhuman_primates"} (default), function will return search terms for all
#'   non-human primates. Use \code{\link{get_nhp_taxa}} to print a list of valid
#'   taxa.
#' @param omit An optional character vector of primate taxonomic groups that
#'   occur within taxa to omit from the search terms. This is useful for example
#'   when you need search terms for all species of one family except one genus.
#' @param simplify Logical. Should printed output be simplified?
#'
#' @details If \code{simplify = TRUE} (default), then function will print search
#'   terms to the console that can be directly copy-pasted into the relevant
#'   bibliographic source as is. However, the object returned is \code{NULL}. If
#'   \code{simplify = FALSE}, then function returns a character vector of length
#'   == 1. This may be useful if the user wants to assign the output to an r
#'   object for further manipulation.
#'
#' @return \code{NULL} or a string of search terms that are associated with the
#'   specified taxa, formatted for use in the specified bibliographic source.
#'
#' @export
#'
#' @import data.tree
#'
#' @examples
#' filter_nhp(source = "PsycInfo", taxa = "papio")
#' filter_nhp(source = "PsycInfo", taxa = "hominidae")
#' filter_nhp(source = "PubMed", taxa = "cercopithecidae", omit = c("papio", "macaca"))
#' filter_nhp(source = "PubMed", taxa = "platyrrhini", omit = "aotus")
filter_nhp <-
  function(source = "PubMed",
           taxa = "nonhuman_primates",
           omit = NULL,
           simplify = TRUE) {

    # remove _ - and " "
    db <- tolower(source)
    db <- gsub("|_|-| ", "", db)

    # convert tolower so that input is case insensitive
    if(!is.null(taxa)) taxa <- tolower(taxa)
    if(!is.null(omit)) omit <- tolower(omit)

    # check input to function arguments are valid
    if(!db %in% c("pubmed", "psycinfo", "webofscience")){
      stop(paste(source,
                 "is not a valid source. Please choose one from: PubMed, PsycInfo or WebOfScience."))
    }

    # check that taxa inputs are valid
    if(!all(taxa %in% correct_taxa_inputs) |
       !all(omit %in% correct_taxa_inputs)){
      xx <- c(setdiff(taxa, correct_taxa_inputs),
              setdiff(omit, correct_taxa_inputs))
      stop(paste0("These terms are not valid taxa: ",
                  paste(xx, collapse = ", "),
                  ". Use get_nhp_taxa() for get a list of valid options."))
    }

    # if("nonhuman_primates" %in% taxa & length(taxa) > 1){
    #   warning("nonhuman_primates selected with other taxa.")
    # }

    # if taxa = NULL, return nothing. This behavior is useful for the shiny app.
    if(is.null(taxa)){
      return(cat(""))
    }

    if(db == "pubmed"){
      term <- format_pubmed_terms(taxa, omit)

    } else if(db == "psycinfo"){
      term <- format_psycinfo_terms(taxa, omit)

    } else if(db == "webofscience"){
      term <- format_wos_terms(taxa, omit)
    }

    if (simplify == TRUE)  return(cat(term))
    if (simplify == FALSE) return(term)
  }

# helpers -----------------------------------------------------------------

format_general_terms <- function(d, taxa) {
  # keep columns of taxa specified in function arguments
  d2 <- d[, c("term", taxa)]

  # keep rows where at least one column == 1 (narrow)
  # (indicating that search term should be used)
  d3 <- d2[rowSums(sapply(d2[ , 2:ncol(d2), drop = FALSE],
                          function(x) x == 1),
                   na.rm = TRUE) > 0, ]

  # add quotes to terms
  dQuote(d3$term)
}

check_single_higher_taxon <- function(taxon) {
  # taxon: single length character
  # checks if there is only one taxonomic group below specified level
  x <- FindNode(primate_tree, taxon)

  # if there is more than one group, then this group should not be omitted so return original taxon
  if(x$height != x$Get("totalCount")[[1]]){
    return(taxon)
  }

  # if there is only one group, move down tree
  while(x$height == x$Get("totalCount")[[1]]){
    # these are the taxonomic levels that we want to omit
    child <- x$Get("name")
    # move down to parent
    x <- Navigate(x, "..")
  }

  child[child!="na"]
}

check_higher_taxon_bracket <- function(taxa) {
  # loops over check_single_higher_taxon() in case user wants to omit multiple taxa
  out <- vector("list", length = length(taxa))

  for (i in seq_along(taxa)){
    out[[i]] <- check_single_higher_taxon(taxa[i])
  }
  unlist(out, use.names = FALSE)
}

# format pubmed -----------------------------------------------------------

format_pubmed_mesh <- function(taxa) {

  pm2 <- pm[, c("term", taxa)]

  # keep rows where at least one taxa column is not NA, and is lower level taxa
  pm3 <- pm2[rowSums(sapply(pm2[ , 2:ncol(pm2), drop = FALSE],
                            function(x) x %in% c("explosion", "noexplosion")),
                     na.rm = TRUE) > 0, ]

  # if nrow is 0, there are no mesh terms, return empty object
  if(nrow(pm3) == 0){
    return(NULL)
  }

  # otherwise check if terms should be exploded or not
  xx <- sapply(pm3[ , 2:ncol(pm3), drop = F], function(x) x == "explosion")

  # cannot do rowSums when matrix/vector has length 1, so use regular sum()
  if(is.vector(xx)){
    pm3$mesh <- ifelse(sum(xx, na.rm = TRUE) > 0, "[mh]", "[mh:noexp]")
  }
  if(is.matrix(xx)){
    pm3$mesh <- ifelse(rowSums(xx, na.rm = TRUE) > 0, "[mh]", "[mh:noexp]")
  }

  # quote terms
  pm3$term <- dQuote(pm3$term)

  # add extension to search term
  paste0(pm3$term, pm3$mesh)
}

format_pubmed_terms <- function(taxa, omit = NULL) {

  mesh_terms <- format_pubmed_mesh(taxa)
  tiab_terms <- paste0(format_general_terms(ta, taxa),
                       "[tiab]")

  if(!is.null(omit)){

    excl <- check_higher_taxon_bracket(omit)

    excl_mesh_terms <- format_pubmed_mesh(excl)
    excl_tiab_terms <- paste0(format_general_terms(ta, excl),
                              "[tiab]")

    mesh_terms <- setdiff(mesh_terms, excl_mesh_terms)
    tiab_terms <- setdiff(tiab_terms, excl_tiab_terms)
  }

  paste0(c(sort(mesh_terms),
           sort(tiab_terms)),
         collapse = " OR ")
}


# format psycinfo ---------------------------------------------------------

format_psycinfo_terms <- function(taxa, omit = NULL) {

  index_terms <- format_general_terms(pii, taxa)
  tiab_terms <- format_general_terms(ta, taxa)

  # omit specified terms
  if(!is.null(omit)){

    excl <- check_higher_taxon_bracket(omit)

    excl_index_terms <- format_general_terms(pii, excl)
    excl_tiab_terms <- format_general_terms(ta, excl)

    index_terms <- setdiff(index_terms, excl_index_terms)
    tiab_terms <- setdiff(tiab_terms, excl_tiab_terms)
  }

  it <- paste0(sort(index_terms), collapse = " OR ")
  tt <- paste0(sort(tiab_terms), collapse = " OR ")

  # if there are no index terms, do not include it in the output
  if (length(index_terms) == 0){
    # message("Note: no index terms are available for the specified taxa.")
    paste0(paste0("TX(", tt, ")"),
           collapse = " OR ")

  } else{
    paste0(c(paste0("DE(", it, ")"),
             paste0("TX(", tt, ")")),
           collapse = " OR ")
  }
}


# format web of science ---------------------------------------------------

format_wos_terms <- function(taxa, omit = NULL) {

  general_terms <- format_general_terms(ta, taxa)

  # omit specified terms
  if(!is.null(omit)){

    excl <- check_higher_taxon_bracket(omit)
    excl_general_terms <- format_general_terms(ta, excl)
    general_terms <- setdiff(general_terms, excl_general_terms)
  }

  general_terms <- paste0(sort(general_terms), collapse = " OR ")

  wos_terms <- paste0("TS=(", general_terms, ")")

  paste0(wos_terms,
         collapse = " OR ")
}
