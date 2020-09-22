#' Run search_nhp() shiny app
#'
#' Runs a user-friendly shiny app that call on `search_nhp()`.
#'
#' @export
#'
#' @import shiny
run_search_nhp_app <- function() {
  appDir <- system.file("app", package = "searchNHP")

  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `searchNHP`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
