# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Create monaco diff view for exist editors in an exist widget
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param editorAId
#'    [character]: The element id of the first editor
#' @param editorBId
#'    [character]: The element id of the second editor
#' @param elementId
#'    [character]: The element id of the exist widget to show monacoDiffEditor
#' @param sessionA
#'    [environment]: The Shiny session object for the first editor (from the server function of the Shiny app)
#' @param sessionB
#'    [environment]: The Shiny session object for the second editor (from the server function of the Shiny app)
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @returns NULL
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'    shinyEditor::createMonacoDiffView(editorAId = "editor1", editorBId = "editor2")
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export createMonacoDiffView
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   createMonacoDiffView
#' @title  Create monaco diff view
#' @rdname createMonacoDiffView
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

createMonacoDiffView <- function(editorAId, editorBId, elementId, sessionA = shiny::getDefaultReactiveDomain(), sessionB = shiny::getDefaultReactiveDomain()) {
   check_output_id(editorAId)
   check_output_id(editorBId)
   removeMonacoDiffView(elementId)
   shinyjs::runjs(
      paste0(
         "const editorA = getMonacoEditor('", sessionA$ns(editorAId), "');",
         "const editorB = getMonacoEditor('", sessionB$ns(editorBId), "');",
         "const el = document.getElementById('", elementId, "');",
         "el.innerHTML = '';",
         "const diffEditor = monaco.editor.createDiffEditor(el, {",
         "   originalEditable: true,",
         "   ignoreTrimWhitespace: false,",
         "   renderSideBySide: true,",
         "   automaticLayout: true",
         "});",
         "diffEditor.id = el.id;",
         "diffEditor.setModel({",
         "   original: editorA.getModel(),",
         "   modified: editorB.getModel()",
         "});"
      )
   )
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Remove monaco diff view for exist editors
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param elementId
#'    [character]: The element id of the monacoDiffEditor
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @returns NULL
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'    shinyEditor::removeMonacoDiffView(elementId = "editor1")
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export removeMonacoDiffView
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   removeMonacoDiffView
#' @title  Remove monaco diff view
#' @rdname removeMonacoDiffView
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

removeMonacoDiffView <- function(elementId) {
   shinyjs::runjs(
      paste0(
         "for (const editor of monaco.editor.getDiffEditors()) {",
         "   if (editor.id && editor.id === '", elementId, "') {",
         "      editor.dispose();",
         "      editor.setModel(null);",
         "   }",
         "};"
      )
   )
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Update options to monacoEditor
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param outputId
#'    [character]: The id of the editor
#' @param options
#'    [list]: monaco editor options. Refer to \url{https://microsoft.github.io/monaco-editor/docs.html#interfaces/editor_editor_api.editor.IEditorOptions.html}
#' @param session
#'    [environment]: The Shiny session object (from the server function of the Shiny app).
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @returns NULL
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'     shinyEditor::updateMonacoOptions(outputId = "editor", options = list())
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export updateMonacoOptions
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   updateMonacoOptions
#' @title  Update options to monacoEditor
#' @rdname updateMonacoOptions
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

updateMonacoOptions <- function(outputId, options, session = shiny::getDefaultReactiveDomain()) {
   check_output_id(outputId)
   if (!is.list(options)) stop("`options` must be list")
   shinyjs::runjs(
      paste0(
         "const editor = getMonacoEditor('", session$ns(outputId), "');",
         "editor.updateOptions(", jsonlite::toJSON(options, auto_unbox = TRUE), ");"
      )
   )
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Set a new theme for the editor. theme should exist, like `vs-dark`
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param theme
#'    [character]: The theme of the monacoEditor
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @returns NULL
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'     shinyEditor::setMonacoTheme(theme = "vs")
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export setMonacoTheme
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   setMonacoTheme
#' @title  Set new theme
#' @rdname setMonacoTheme
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

setMonacoTheme <- function(theme) {
   if (length(theme) != 1 || !theme %in% c("vs", "vs-dark", "hc-black", "hc-light")) stop(paste0("`theme` does not exist in below list:\n", paste0("\t", c("vs", "vs-dark", "hc-black", "hc-light"), collapse = ",\n")))
   shinyjs::runjs(
      paste0(
         "monaco.editor.setTheme('", theme, "');"
      )
   )
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Set language to monaco editor
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param outputId
#'    [character]: The id of the editor
#' @param language
#'    [character]: The highlight of code
#' @param session
#'    [environment]: The Shiny session object (from the server function of the Shiny app).
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @returns NULL
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'     shinyEditor::setMonacoLanguage(outputId = "editor", language = "text")
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export setMonacoLanguage
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   setMonacoLanguage
#' @title  Set language
#' @rdname setMonacoLanguage
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

setMonacoLanguage <- function(outputId, language, session = shiny::getDefaultReactiveDomain()) {
   check_output_id(outputId)
   shinyjs::runjs(
      paste0(
         "const editor = getMonacoEditor('", session$ns(outputId), "');",
         "monaco.editor.setModelLanguage(editor.getModel(), '", language, "');"
      )
   )
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Replace all the lines in the current Document with the value of text.
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param outputId
#'    [character]: The id of the editor
#' @param value
#'    [character]: The text of the editor
#' @param clearChangedHistory
#'    [logical]: Clear undo/redo history
#' @param session
#'    [environment]: The Shiny session object (from the server function of the Shiny app).
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @returns NULL
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'     shinyEditor::setMonacoValue(outputId = "editor", value = "text")
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export setMonacoValue
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   setMonacoValue
#' @title  Replace text with new text
#' @rdname setMonacoValue
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

setMonacoValue <- function(outputId, value, clearChangedHistory = FALSE, session = shiny::getDefaultReactiveDomain()) {
   check_output_id(outputId)
   if (!missing(value)) value <- paste0(unlist(value), collapse = "\n")
   shinyjs::runjs(
      paste0(
         "const editor = getMonacoEditor('", session$ns(outputId), "');",
         ifelse(
            clearChangedHistory,
            paste0("editor.setValue('", value, "');"),
            paste0(
               "editor.getModel().pushEditOperations([], [",
               "   {",
               "      range: editor.getModel().getFullModelRange(),",
               "      text: '", value, "',",
               "   }",
               "], () => null);"
            )
         )
      )
   )
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Get value in monacoEditor
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param outputId
#'    [character]: The id of the editor
#' @param session
#'    [environment]: The Shiny session object (from the server function of the Shiny app).
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @section Character of editor text
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'     shinyEditor::getMonacoValue(outputId = "editor")
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export getMonacoValue
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   getMonacoValue
#' @title  Get value in monacoEditor
#' @rdname getMonacoValue
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

getMonacoValue <- function(outputId, session = shiny::getDefaultReactiveDomain()) {
   check_output_id(outputId)
   data <- session$input[[outputId]]
   return(data)
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Get cursor position in monacoEditor
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param outputId
#'    [character]: The id of the editor
#' @param session
#'    [environment]: The Shiny session object (from the server function of the Shiny app).
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @returns List of cursor position
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'     shinyEditor::getMonacoCursorPosition(outputId = "editor")
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export getMonacoCursorPosition
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   getMonacoCursorPosition
#' @title  Get cursor position in monacoEditor
#' @rdname getMonacoCursorPosition
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

getMonacoCursorPosition <- function(outputId, session = shiny::getDefaultReactiveDomain()) {
   check_output_id(outputId)
   data <- session$input[[paste0(outputId, "_cursor_changed")]]
   if (!is.null(data)) {
      data <- jsonlite::fromJSON(data)
   }
   return(data)
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Get selection range in monacoEditor
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param outputId
#'    [character]: The id of the editor
#' @param session
#'    [environment]: The Shiny session object (from the server function of the Shiny app).
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @returns List of selection range
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'     shinyEditor::getMonacoSelectionRange(outputId = "editor")
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export getMonacoSelectionRange
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   getMonacoSelectionRange
#' @title  Get selection range in monacoEditor
#' @rdname getMonacoSelectionRange
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

getMonacoSelectionRange <- function(outputId, session = shiny::getDefaultReactiveDomain()) {
   check_output_id(outputId)
   data <- session$input[[paste0(outputId, "_selection_changed")]]
   if (!is.null(data)) {
      data <- jsonlite::fromJSON(data)
   }
   return(data)
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Get selected text in monacoEditor
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param outputId
#'    [character]: The id of the editor
#' @param session
#'    [environment]: The Shiny session object (from the server function of the Shiny app).
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @section Character of selected text
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'     shinyEditor::getMonacoSelectedText(outputId = "editor")
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export getMonacoSelectedText
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   getMonacoSelectedText
#' @title  Get selected text in monacoEditor
#' @rdname getMonacoSelectedText
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

getMonacoSelectedText <- function(outputId, session = shiny::getDefaultReactiveDomain()) {
   check_output_id(outputId)
   data <- session$input[[paste0(outputId, "_selected_text")]]
   return(data)
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Fires upon monacoEditor initialisation
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param outputId
#'    [character]: The id of the editor
#' @param session
#'    [environment]: The Shiny session object (from the server function of the Shiny app).
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @section `TRUE`
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'     shinyEditor::onMonacoEditorReady(outputId = "editor")
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export onMonacoEditorReady
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   onMonacoEditorReady
#' @title  Fires upon monacoEditor initialisation
#' @rdname onMonacoEditorReady
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

onMonacoEditorReady <- function(outputId, session = shiny::getDefaultReactiveDomain()) {
   check_output_id(outputId)
   data <- session$input[[paste0(outputId, "_ready")]]
   return(data)
}
