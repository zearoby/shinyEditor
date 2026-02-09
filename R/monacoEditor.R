# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Render an Monaco editor on an application page.
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param value
#'    [character]: Set text to editor when initializing
#' @param enableSpellCheck
#'    [logical]: Enable check typo of spelling
#' @param fontFamily
#'    [character]: The font family
#' @param fontSize
#'    [integer]: The font size
#' @param insertSpaces
#'    [logical]: Insert spaces when pressing Tab. This setting is overridden based on the file contents when detectIndentation is on. Defaults to true.
#' @param language
#'    [character]: The initial language of the auto created model in the editor. To not automatically create a model, use model: null.
#' @param lineNumbers
#'    [character], [integer]: Control the rendering of line numbers. If it is a function, it will be invoked when rendering a line number and the return value will be rendered. Otherwise, if it is a truthy, line numbers will be rendered normally (equivalent of using an identity function). Otherwise, line numbers will not be rendered. Defaults to on.
#' @param placeholder
#'    [character]: Sets a placeholder for the editor. If set, the placeholder is shown if the editor is empty.
#' @param readOnly
#'    [logical]: Should the editor be read only. See also domReadOnly. Defaults to false.
#' @param renderWhitespace
#'    [character]: Enable rendering of whitespace. Defaults to 'selection'. Valid values: "all" | "none" | "boundary" | "selection" | "trailing"
#' @param rulers
#'    [list]: Render vertical lines at the specified columns. Defaults to empty list.
#' @param scrollBeyondLastLine
#'    [logical]: Enable that scrolling can go one screen size after the last line. Defaults to true.
#' @param showStatusBar
#'    [logical]: Show statusBar
#' @param tabSize
#'    [integer]: The number of spaces a tab is equal to. This setting is overridden based on the file contents when detectIndentation is on. Defaults to 4.
#' @param theme
#'    [character]: Initial theme to be used for rendering. The current out-of-the-box available themes are: 'vs' (default), 'vs-dark', 'hc-black', 'hc-light. You can create custom themes via monaco.editor.defineTheme. To switch a theme, use monaco.editor.setTheme. NOTE: The theme might be overwritten if the OS is in high contrast mode, unless autoDetectHighContrast is set to false.
#' @param wordWrap
#'    [character]: Control the wrapping of the editor. When wordWrap = "off", the lines will never wrap. When wordWrap = "on", the lines will wrap at the viewport width. When wordWrap = "wordWrapColumn", the lines will wrap at wordWrapColumn. When wordWrap = "bounded", the lines will wrap at min(viewport width, wordWrapColumn). Defaults to "off".
#'    Valid values: "off" | "on" | "wordWrapColumn" | "bounded"
#' @param automaticLayout
#'    [logical]: Enable that the editor will install a ResizeObserver to check if its container dom node size has changed. Defaults to TRUE.
#' @param ...
#'    For more arguments, please refer to \url{https://microsoft.github.io/monaco-editor/docs.html#interfaces/editor_editor_api.editor.IStandaloneEditorConstructionOptions.html}
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
#'     shinyEditor::monacoEditor(value = "text")
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export monacoEditor
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   monacoEditor
#' @title  Render an monaco editor
#' @rdname monacoEditor
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

monacoEditor <- function(
   value,
   enableSpellCheck = FALSE,
   fontFamily = "Consolas",
   fontSize = 16,
   insertSpaces = TRUE,
   language = "plaintext",
   lineNumbers = "on",
   placeholder = NULL,
   readOnly = FALSE,
   renderWhitespace = "boundary",
   rulers = list(80, 100, 120),
   scrollBeyondLastLine = TRUE,
   showStatusBar = TRUE,
   tabSize = 4,
   theme = "vs",
   wordWrap = "off",
   automaticLayout = TRUE,
   ...,
   width = NULL,
   height = NULL,
   elementId = NULL
) {
   if (!missing(value)) value <- paste0(unlist(value), collapse = "\n")
   if (length(fontSize) != 1 || is.na(as.numeric(fontSize)) || fontSize < 1) stop(paste0("`fontSize` must be a positive number"))
   if (length(fontFamily) != 1 || !tolower(fontFamily) %in% tolower(getSystemFontFamilies())) stop(paste0("`fontFamily` does not exist in system fonts as below list:\n", paste0("\t", getSystemFontFamilies(), collapse = ",\n")))
   if (length(language) != 1 || !language %in% getMonacoLanguages()) stop(paste0("`language` does not exist in below list:\n", paste0("\t", getMonacoLanguages(), collapse = ",\n")))
   if (length(theme) != 1 || !theme %in% getMonacoThemes()) stop(paste0("`theme` does not exist in below list:\n", paste0("\t", getMonacoThemes(), collapse = ",\n")))

   # forward options using x
   x = list(
      value = value,
      enableSpellCheck = enableSpellCheck,
      fontFamily = fontFamily,
      fontSize = fontSize,
      insertSpaces = insertSpaces,
      language = language,
      lineNumbers = lineNumbers,
      placeholder = placeholder,
      readOnly = readOnly,
      renderWhitespace = renderWhitespace,
      rulers = rulers,
      scrollBeyondLastLine = scrollBeyondLastLine,
      showStatusBar = showStatusBar,
      tabSize = tabSize,
      wordWrap = wordWrap,
      automaticLayout = automaticLayout,
      ...
   )

   # create widget
   htmlwidgets::createWidget(
      x,
      name = "monacoEditor",
      package = 'shinyEditor',
      width = width,
      height = height,
      elementId = elementId
   )
}

#' Shiny bindings for monacoEditor
#'
#' Output and render functions for using monacoEditor within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a monacoEditor
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name monacoEditor-shiny
#'
#' @returns htmlwidgets::shinyWidgetOutput
#' @export
monacoEditorOutput <- function(outputId, width = '100%', height = '400px'){
   htmlwidgets::shinyWidgetOutput(outputId, 'monacoEditor', width, height, package = 'shinyEditor')
}

#' @rdname monacoEditor-shiny
#' @returns htmlwidgets::shinyRenderWidget
#' @export
renderMonacoEditor <- function(expr, env = parent.frame(), quoted = FALSE) {
   if (!quoted) { expr <- substitute(expr) } # force quoted
   htmlwidgets::shinyRenderWidget(expr, monacoEditorOutput, env, quoted = TRUE)
}
