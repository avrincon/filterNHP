#' Check if there is only one taxonomic group below specified level
#'
#' @param taxa A character vector of primate taxa.
#'
#' @return
#'
#' @import data.tree
#'
#' @examples
#' check_higher_taxon_bracket("lepilemur")
#' check_higher_taxon_bracket("otolemur")
#'
#' @noRd
check_higher_taxon_bracket <- function(taxa) {
  # checks if there is only one taxonomic group below specified level
  x <- FindNode(primate_tree, taxa)

  # if there is more than one group, return original taxa
  if(x$height != x$Get("totalCount")[[1]]){
    return(taxa)
  }

  # if there is only one group, move down tree
  while(x$height == x$Get("totalCount")[[1]]){
    # these are the taxonomic levels that we want to exclude
    child <- x$Get("name")
    # move down to parent
    x <- Navigate(x, "..")
  }

  child[child!="na"]
}
