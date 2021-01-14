#' Run filter_nhp() shiny app
#'
#' Runs a user-friendly shiny app that calls on `filter_nhp()`.
#'
#' @export
#'
#' @import shiny
run_filter_nhp_app <- function() {
  appDir <- system.file("app", package = "filterNHP")

  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `filterNHP`.",
         call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
