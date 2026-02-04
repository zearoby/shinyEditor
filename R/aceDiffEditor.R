# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Render an Ace diff editor on an application page.
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param valueA
#'    [character]: Set text to first editor when initializing
#' @param valueB
#'    [character]: Set text to second editor when initializing
#' @param mode
#'    [character]: The Ace \code{shinyEditor::getAceModes()} to be used by the editor
#' @param enableSpellCheck
#'    [logical]: Enable check typo of spelling
#' @param ...
#'    For more `EditorOption`, please refer to \url{https://ace.c9.io/api/interfaces/ace.Ace.EditorOptions.html}
#' @param width
#'    [integer], [character]: Width in pixels (optional, defaults to automatic sizing)
#' @param height
#'    [integer], [character]: Height in pixels (optional, defaults to automatic sizing)
#' @param elementId
#'    [character]: An element id for the widget (a random character by default)
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @returns Widget for shiny application
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'     shinyEditor::aceDiffEditor(valueA = "text1", valueB = "text2")
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export aceDiffEditor
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   aceDiffEditor
#' @title  Render an Ace aceDiffEditor
#' @rdname aceDiffEditor
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

aceDiffEditor <- function(
      valueA,
      valueB,
      mode = "ace/mode/text",
      enableSpellCheck = FALSE,
      ...,
      width = NULL,
      height = NULL,
      elementId = NULL
) {
   if (!missing(valueA)) valueA <- paste0(unlist(valueA), collapse = "\n")
   if (!missing(valueB)) valueB <- paste0(unlist(valueB), collapse = "\n")
   if (length(mode) != 1 || !mode %in% getAceModes()) stop(paste0("`mode` does not exist in below list:\n", paste0("\t", getAceModes(), collapse = ",\n")))
   if (length(enableSpellCheck) != 1 || !enableSpellCheck %in% c(TRUE, FALSE)) stop("`enableSpellCheck` must be TRUE or FALSE")

   # forward options using x
   x = list(
      valueA = valueA,
      valueB = valueB,
      mode = mode,
      enableSpellCheck = enableSpellCheck,
      ...
   )

   # create widget
   htmlwidgets::createWidget(
      x,
      name = "aceDiffEditor",
      package = 'shinyEditor',
      width = width,
      height = height,
      elementId = elementId
   )
}

#' Shiny bindings for aceDiffEditor
#'
#' Output and render functions for using aceDiffEditor within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a aceDiffEditor
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @returns htmlwidgets::shinyWidgetOutput
#' @name aceDiffEditor-shiny
#'
#' @export
aceDiffEditorOutput <- function(outputId, width = '100%', height = '400px'){
   htmlwidgets::shinyWidgetOutput(outputId, 'aceDiffEditor', width, height, package = 'shinyEditor')
}

#' @rdname aceDiffEditor-shiny
#' @returns htmlwidgets::shinyRenderWidget
#' @export
renderAceDiffEditor <- function(expr, env = parent.frame(), quoted = FALSE) {
   if (!quoted) { expr <- substitute(expr) } # force quoted
   htmlwidgets::shinyRenderWidget(expr, aceDiffEditorOutput, env, quoted = TRUE)
}
