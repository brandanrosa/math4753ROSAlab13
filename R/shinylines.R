#' shinylines
#'
#' This Shiny App displays regression analyses plots based on the Spruce data set.
#'
#' @return Four scatter plots
#' @export
#'
#' @importFrom shiny runApp
#'
#' @examples \dontrun{shinylines()}
shinylines <- function() {
  runApp(system.file("shinylines",
                     package = "math4753ROSAlab13"),
         launch.browser = TRUE)
}
