# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Render an Ace editor on an application page.
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param value
#'    [character]: Set text to editor when initializing
#' @param enableBasicAutocompletion
#'    [logical]: Enable basic code automatically completion when editing
#' @param enableSnippets
#'    [logical]: Enable code snippets automatically completion when editing
#' @param enableLiveAutocompletion
#'    [logical]: Enable live code automatically completion when editing
#' @param enableSpellCheck
#'    [logical]: Enable check typo of spelling
#' @param fontFamily
#'    [character]: System font name
#' @param fontSize
#'    [integer]: Font size
#' @param highlightActiveLine
#'    [logical]: Highlight the current line
#' @param mode
#'    [character]: The Ace \code{shinyEditor::getAceModes()} to be used by the editor
#' @param newLineMode
#'    [character]: Set the end of line character
#'    Valid values: windows, unix, auto
#' @param highlightActiveLine
#'    [logical]: Highlight the current line
#' @param placeholder
#'    [character]: A string to use a placeholder when the editor has no content
#' @param printMarginColumn
#'    [integer]: The print margin column width
#' @param readOnly
#'    [logical]: Set editor to readOnly
#' @param scrollPastEnd
#'    [integer]: Scroll past end
#'    Valid values: 0 to 1, TRUE, FALSE
#' @param showInvisibles
#'    [logical]: Show invisible characters
#' @param showLineNumbers
#'    [logical]: Show line number area
#' @param showPrintMargin
#'    [logical]: Show print margin
#' @param showStatusBar
#'    [logical]: Show statusBar
#' @param tabSize
#'    [integer]: Tab size
#' @param theme
#'    [character]: The Ace \code{shinyEditor::getAceThemes()} to be used by the editor
#' @param useSoftTabs
#'    [logical]: Replace tabs by spaces
#' @param wrap
#'    [logical]: If set to \code{TRUE}, Ace will enable word wrapping
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
#'     shinyEditor::aceEditor(value = "text")
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export aceEditor
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   aceEditor
#' @title  Render an Ace editor
#' @rdname aceEditor
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

aceEditor <- function(
   value,
   enableBasicAutocompletion = TRUE,
   enableSnippets = TRUE,
   enableLiveAutocompletion = TRUE,
   enableSpellCheck = FALSE,
   fontFamily = "Consolas",
   fontSize = 16,
   highlightActiveLine = TRUE,
   mode = "ace/mode/text",
   newLineMode = "auto",
   placeholder  = NULL,
   printMarginColumn = 120,
   readOnly = FALSE,
   scrollPastEnd = 0.5,
   showInvisibles = TRUE,
   showLineNumbers = TRUE,
   showPrintMargin = TRUE,
   showStatusBar = TRUE,
   tabSize = 4,
   theme = "ace/theme/xcode",
   useSoftTabs = TRUE,
   wrap = FALSE,
   ...,
   width = NULL,
   height = NULL,
   elementId = NULL
) {
   if (!missing(value)) value <- paste0(unlist(value), collapse = "\n")
   if (length(enableBasicAutocompletion) != 1 || !enableBasicAutocompletion %in% c(TRUE, FALSE)) stop("`enableBasicAutocompletion` must be TRUE or FALSE")
   if (length(enableSnippets) != 1 || !enableSnippets %in% c(TRUE, FALSE)) stop("`enableSnippets` must be TRUE or FALSE")
   if (length(enableLiveAutocompletion) != 1 || !enableLiveAutocompletion %in% c(TRUE, FALSE)) stop("`enableLiveAutocompletion` must be TRUE or FALSE")
   if (length(enableSpellCheck) != 1 || !enableSpellCheck %in% c(TRUE, FALSE)) stop("`enableSpellCheck` must be TRUE or FALSE")
   if (length(fontFamily) != 1 || !tolower(fontFamily) %in% tolower(getSystemFontFamilies())) stop(paste0("`fontFamily` does not exist in system fonts as below list:\n", paste0("\t", getSystemFontFamilies(), collapse = ",\n")))
   if (length(fontSize) != 1 || is.na(as.numeric(fontSize)) || fontSize < 1) stop(paste0("`fontSize` must be a positive number"))
   if (length(highlightActiveLine) != 1 || !highlightActiveLine %in% c(TRUE, FALSE)) stop("`highlightActiveLine` must be TRUE or FALSE")
   if (length(mode) != 1 || !mode %in% getAceModes()) stop(paste0("`mode` does not exist in below list:\n", paste0("\t", getAceModes(), collapse = ",\n")))
   if (length(newLineMode) != 1 || !newLineMode %in% c("windows", "unix", "auto")) stop(paste0("`newLineMode` does not exist in below list:\n", paste0(c("windows", "unix", "auto"), collapse = ",\n")))
   if (length(printMarginColumn) != 1 || is.na(as.numeric(printMarginColumn)) || printMarginColumn < 1) stop("`printMarginColumn` must be a positive number")
   if (length(readOnly) != 1 || !readOnly %in% c(TRUE, FALSE)) stop("`readOnly` must be TRUE or FALSE")
   if (length(scrollPastEnd) != 1 || is.na(as.numeric(scrollPastEnd))) stop(paste0("`scrollPastEnd` must be a number (0 to 1) or TRUE, FALSE"))
   if (length(showInvisibles) != 1 || !showInvisibles %in% c(TRUE, FALSE)) stop("`showInvisibles` must be TRUE or FALSE")
   if (length(showLineNumbers) != 1 || !showLineNumbers %in% c(TRUE, FALSE)) stop("`showLineNumbers` must be TRUE or FALSE")
   if (length(showPrintMargin) != 1 || !showPrintMargin %in% c(TRUE, FALSE)) stop("`showPrintMargin` must be TRUE or FALSE")
   if (length(showStatusBar) != 1 || !showStatusBar %in% c(TRUE, FALSE)) stop("`showStatusBar` must be TRUE or FALSE")
   if (length(tabSize) != 1 || is.na(as.numeric(tabSize)) || tabSize < 1) stop("`tabSize` must be a positive number")
   if (length(theme) != 1 || !theme %in% getAceThemes()) stop(paste0("`theme` does not exist in below list:\n", paste0("\t", getAceThemes(), collapse = ",\n")))
   if (length(useSoftTabs) != 1 || !useSoftTabs %in% c(TRUE, FALSE)) stop("`useSoftTabs` must be TRUE or FALSE")
   if (length(wrap) != 1 || !wrap %in% c(TRUE, FALSE)) stop("`wrap` must be TRUE or FALSE")

   # forward options using x
   x = list(
      value = value,
      enableBasicAutocompletion = enableBasicAutocompletion,
      enableSnippets = enableSnippets,
      enableLiveAutocompletion = enableLiveAutocompletion,
      enableSpellCheck = enableSpellCheck,
      fontFamily = fontFamily,
      fontSize = fontSize,
      highlightActiveLine = highlightActiveLine,
      mode = mode,
      newLineMode = newLineMode,
      placeholder = placeholder,
      printMarginColumn = printMarginColumn,
      readOnly = readOnly,
      scrollPastEnd = scrollPastEnd,
      showInvisibles = showInvisibles,
      showLineNumbers = showLineNumbers,
      showPrintMargin = showPrintMargin,
      showStatusBar = showStatusBar,
      tabSize = tabSize,
      theme = theme,
      useSoftTabs = useSoftTabs,
      wrap = wrap,
      ...
   )

   # create widget
   htmlwidgets::createWidget(
      x,
      name = "aceEditor",
      package = 'shinyEditor',
      width = width,
      height = height,
      elementId = elementId
   )
}

#' Shiny bindings for aceEditor
#'
#' Output and render functions for using aceEditor within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a aceEditor
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name aceEditor-shiny
#'
#' @returns htmlwidgets::shinyWidgetOutput
#' @export
aceEditorOutput <- function(outputId, width = '100%', height = '400px'){
   htmlwidgets::shinyWidgetOutput(outputId, 'aceEditor', width, height, package = 'shinyEditor')
}

#' @rdname aceEditor-shiny
#' @returns htmlwidgets::shinyRenderWidget
#' @export
renderAceEditor <- function(expr, env = parent.frame(), quoted = FALSE) {
   if (!quoted) { expr <- substitute(expr) } # force quoted
   htmlwidgets::shinyRenderWidget(expr, aceEditorOutput, env, quoted = TRUE)
}
