#' Get taxonomic terms for non-human primates
#'
#'
#' @param level Specify which level to get taxonomic terms for. Defaults to
#'   "all". Other options are "suborder", "infraorder", "parvorder",
#'   "superfamily", "family", "subfamily", "tribe" or "genus".
#'
#' @return A named list with taxonomic terms for each level.
#' @export
#'
#' @examples
#' get_nhp_taxa("genus")
get_nhp_taxa <- function(level = "all") {

  level <- tolower(level)

  if(!all(level %in% c("all", names(primate_taxa)))){
    xx <- c(setdiff(level, correct_taxa_inputs))
    stop(paste0(
      c(dQuote(xx),
        "is not a valid taxonomic level. Please choose from:",
        paste0(names(primate_taxa), collapse = ", ")),
      collapse = " "))
  }

  if (level[[1]] == "all"){
    primate_taxa
  } else{
    primate_taxa[level]
  }
}
