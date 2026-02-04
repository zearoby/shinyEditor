# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Render an Ace diff editor on an application page.
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param valueA
#'    [character]: Set text to first editor when initializing
#' @param valueB
#'    [character]: Set text to second editor when initializing
#' @param language
#'    [character]: The initial language of the auto created model in the editor. To not automatically create a model, use model: null
#' @param ignoreTrimWhitespace
#'    [logical]: Compute the diff by ignoring leading/trailing whitespace Defaults to false
#' @param ...
#'    For more arguments, please refer to \url{https://microsoft.github.io/monaco-editor/typedoc/interfaces/editor_editor_api.editor.IDiffEditorOptions.html}
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
#'     shinyEditor::monacoDiffEditor(valueA = "text1", valueB = "text2")
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export monacoDiffEditor
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   monacoDiffEditor
#' @title  Render an Ace monacoDiffEditor
#' @rdname monacoDiffEditor
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

monacoDiffEditor <- function(
      valueA,
      valueB,
      language = "plaintext",
      ignoreTrimWhitespace = FALSE,
      ...,
      width = NULL,
      height = NULL,
      elementId = NULL
) {
   if (!missing(valueA)) valueA <- paste0(unlist(valueA), collapse = "\n")
   if (!missing(valueB)) valueB <- paste0(unlist(valueB), collapse = "\n")
   if (length(language) != 1 || !language %in% getMonacoLanguages()) stop(paste0("`language` does not exist in below list:\n", paste0("\t", getMonacoLanguages(), collapse = ",\n")))
   if (length(ignoreTrimWhitespace) != 1 || !ignoreTrimWhitespace %in% c(TRUE, FALSE)) stop("`ignoreTrimWhitespace` must be TRUE or FALSE")

   # forward options using x
   x = list(
      valueA = valueA,
      valueB = valueB,
      language = language,
      ignoreTrimWhitespace = ignoreTrimWhitespace,
      ...
   )

   # create widget
   htmlwidgets::createWidget(
      x,
      name = "monacoDiffEditor",
      package = 'shinyEditor',
      width = width,
      height = height,
      elementId = elementId
   )
}

#' Shiny bindings for monacoDiffEditor
#'
#' Output and render functions for using monacoDiffEditor within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a monacoDiffEditor
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name monacoDiffEditor-shiny
#'
#' @returns htmlwidgets::shinyWidgetOutput
#' @export
monacoDiffEditorOutput <- function(outputId, width = '100%', height = '400px'){
   htmlwidgets::shinyWidgetOutput(outputId, 'monacoDiffEditor', width, height, package = 'shinyEditor')
}

#' @rdname monacoDiffEditor-shiny
#' @returns htmlwidgets::shinyRenderWidget
#' @export
renderMonacoDiffEditor <- function(expr, env = parent.frame(), quoted = FALSE) {
   if (!quoted) { expr <- substitute(expr) } # force quoted
   htmlwidgets::shinyRenderWidget(expr, monacoDiffEditorOutput, env, quoted = TRUE)
}
