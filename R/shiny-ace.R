# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Create diff view for exist editors
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param editorAId
#'    [character]: The element id of the first editor
#' @param editorBId
#'    [character]: The element id of the second editor
#' @param sessionA
#'    [environment]: The Shiny session object for the first editor (from the server function of the Shiny app).
#' @param sessionB
#'    [environment]: The Shiny session object for the second editor (from the server function of the Shiny app).
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @returns No return value, called for side effects
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'     shinyEditor::createAceDiffView(editorAId = "editor1", editorBId = "editor2")
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export createAceDiffView
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   createAceDiffView
#' @title  Create diff view
#' @rdname createAceDiffView
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

createAceDiffView <- function(editorAId, editorBId, sessionA = shiny::getDefaultReactiveDomain(), sessionB = shiny::getDefaultReactiveDomain()) {
   check_output_id(editorAId)
   check_output_id(editorBId)
   removeAceDiffView(editorAId, sessionA)
   removeAceDiffView(editorBId, sessionB)
   shinyjs::runjs(
      paste0(
         "const editorA = ace.edit('", sessionA$ns(editorAId), "');",
         "const editorB = ace.edit('", sessionB$ns(editorBId), "');",
         "const {DiffProvider, InlineDiffView, SplitDiffView, createDiffView} = ace.require('ace/ext/diff');",
         "const diffView = new SplitDiffView({editorA, editorB});",
         "diffView?.setProvider(new DiffProvider());",
         "diffView?.onInput();",
         "editorA.diffView = diffView;"
      )
   )
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Remove ace diff view for exist editors
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param outputId
#'    [character]: The element id of the first editor
#' @param session
#'    [environment]: The Shiny session object for the editor (from the server function of the Shiny app).
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @returns No return value, called for side effects
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'     shinyEditor::removeAceDiffView(outputId = "editor")
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export removeAceDiffView
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   removeAceDiffView
#' @title  Remove ace diff view
#' @rdname removeAceDiffView
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

removeAceDiffView <- function(outputId, session = shiny::getDefaultReactiveDomain()) {
   check_output_id(outputId)
   shinyjs::runjs(
      paste0(
         "const editor = ace.edit('", session$ns(outputId), "');",
         "diffView = editor.diffView;",
         "if (diffView != null) {",
         "   diffView.detach();",
         "   diffView = undefined;",
         "   editor.diffView = undefined;",
         "}"
      )
   )
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Add completer to editor.completers. Please refer to \url{https://ace.c9.io/api/interfaces/ace.Ace.Completer.html}
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param outputId
#'    [character]: The element id of the first editor
#' @param id
#'    [list]: Completer id
#' @param completer
#'    [list]: Completer list
#' @param session
#'    [environment]: The Shiny session object for the editor (from the server function of the Shiny app).
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @returns No return value, called for side effects
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'     shinyEditor::appendAceCompleter(
#'        outputId = "editor",
#'        id = "custom_completer",
#'        completer = list(
#'           list(value = "function", caption = "function", meta = "keyword"),
#'           list(value = "if", caption = "if", meta = "keyword"),
#'           list(value = "else", caption = "else", meta = "keyword"),
#'           list(value = "for", caption = "for", meta = "keyword"),
#'           list(value = "while", caption = "while", meta = "keyword"),
#'           list(value = "console.log()", caption = "console.log", meta = "function"),
#'           list(value = "myCustomFunction()", caption = "myCustomFunction", meta = "custom")
#'        )
#'     )
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export appendAceCompleter
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   appendAceCompleter
#' @title  Add completer
#' @rdname appendAceCompleter
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

appendAceCompleter <- function(outputId, id, completer, session = shiny::getDefaultReactiveDomain()) {
   check_output_id(outputId)
   if (length(id) != 1 || !is.character(id) || id %in% c("snippetCompleter", "textCompleter", "keywordCompleter")) {
      stop('`id` must be character and not in c("snippetCompleter", "textCompleter", "keywordCompleter")')
   }
   if (!is.list(completer)) stop("`completer` must be list")
   shinyjs::runjs(
      paste0(
         "const customCompleter = {",
         "   id: '", id, "',",
         "   getCompletions: function(editor, session, pos, prefix, callback) {",
         "      const wordList = ", jsonlite::toJSON(completer, auto_unbox = T), ";",
         '      callback(null, wordList.map(function(item) {',
         '         if (item.score == null) {',
         '            item.score = 1000;',
         '         }',
         '         return {',
         '            name:    item.value,',
         '            value:   item.value,',
         '            caption: item.caption,',
         '            meta:    item.meta,',
         '            score:   item.score',
         '         };',
         '      }));',
         '   }',
         '};',
         "const editor = ace.edit('", session$ns(outputId), "');",
         'editor.completers.push(customCompleter);'
      )
   )
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Remove completer in editor.completers. Please refer to \url{https://ace.c9.io/api/interfaces/ace.Ace.Completer.html}
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param outputId
#'    [character]: The element id of the first editor
#' @param id
#'    [list]: Completer id
#' @param session
#'    [environment]: The Shiny session object for the editor (from the server function of the Shiny app).
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @returns No return value, called for side effects
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'     shinyEditor::removeAceCompleter(outputId = "editor", id = "custom_completer")
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export removeAceCompleter
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   removeAceCompleter
#' @title  Remove completer
#' @rdname removeAceCompleter
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

removeAceCompleter <- function(outputId, id, session = shiny::getDefaultReactiveDomain()) {
   check_output_id(outputId)
   if (!is.character(id) || any(id %in% c("snippetCompleter", "textCompleter", "keywordCompleter"))) {
      stop('`id` must be character and not in c("snippetCompleter", "textCompleter", "keywordCompleter")')
   }
   shinyjs::runjs(
      paste0(
         "const keys = ", jsonlite::toJSON(id, auto_unbox = TRUE), ";",
         "const editor = ace.edit('", session$ns(outputId), "');",
         "editor.completers = editor.completers.filter(item => !keys.includes(item.id));"
      )
   )
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Enable or disable spell check
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param outputId
#'    [character]: The id of the editor
#' @param enable
#'    [logical]: Set spell check TRUE or FALSE
#' @param session
#'    [environment]: The Shiny session object for the editor (from the server function of the Shiny app).
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @returns No return value, called for side effects
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'     shinyEditor::setAceEnableSpellCheck(outputId = "editor", enable = TRUE)
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export setAceEnableSpellCheck
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   setAceEnableSpellCheck
#' @title  Enable or disable spell check
#' @rdname setAceEnableSpellCheck
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

setAceEnableSpellCheck <- function(outputId, enable = TRUE, session = shiny::getDefaultReactiveDomain()) {
   check_output_id(outputId)
   if (length(enable) != 1 || !enable %in% c(TRUE, FALSE)) stop("`enable` must be TRUE or FALSE")
   shinyjs::runjs(
      paste0(
         "const editor = ace.edit('", session$ns(outputId), "');",
         "if (", tolower(enable), " == true) {",
         "   editor.spellChecker.enableSpellCheck();",
         "}",
         "else {",
         "   editor.spellChecker.disableSpellCheck();",
         "}"
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
#' @returns No return value, called for side effects
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'     shinyEditor::setAceValue(outputId = "editor", value = "text")
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export setAceValue
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   setAceValue
#' @title  Replace text with new text
#' @rdname setAceValue
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

setAceValue <- function(outputId, value, clearChangedHistory = FALSE, session = shiny::getDefaultReactiveDomain()) {
   check_output_id(outputId)
   if (!missing(value)) value <- paste0(unlist(value), collapse = "\n")
   shinyjs::runjs(
      paste0(
         "const editor = ace.edit('", session$ns(outputId), "');",
         ifelse(
            clearChangedHistory,
            paste0("editor.session.setValue(", value, ");"),
            paste0("editor.setValue(", value, ");")
         )
      )
   )
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Set a new mode for the EditSession.
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param outputId
#'    [character]: The id of the editor
#' @param mode
#'    [character]: The mode of the code language
#' @param session
#'    [environment]: The Shiny session object (from the server function of the Shiny app).
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @returns No return value, called for side effects
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'     shinyEditor::setAceMode(outputId = "editor", mode = "r")
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export setAceMode
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   setAceMode
#' @title  Set new mode
#' @rdname setAceMode
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

setAceMode <- function(outputId, mode, session = shiny::getDefaultReactiveDomain()) {
   check_output_id(outputId)
   if (length(mode) != 1 || !mode %in% getAceModes()) stop(paste0("`mode` does not exist in below list:\n", paste0("\t", getAceModes(), collapse = ",\n")))
   shinyjs::runjs(
      paste0(
         "const editor = ace.edit('", session$ns(outputId), "');",
         "editor.session.setMode('", mode, "');"
      )
   )
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Set a new theme for the editor. theme should exist, like `ace/theme/github`
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param outputId
#'    [character]: The id of the editor
#' @param theme
#'    [character]: The theme of the aceEditor
#' @param session
#'    [environment]: The Shiny session object (from the server function of the Shiny app).
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @returns No return value, called for side effects
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'     shinyEditor::setAceTheme(outputId = "editor", theme = "ace/theme/github")
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export setAceTheme
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   setAceTheme
#' @title  Set new theme
#' @rdname setAceTheme
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

setAceTheme <- function(outputId, theme, session = shiny::getDefaultReactiveDomain()) {
   check_output_id(outputId)
   if (length(theme) != 1 || !theme %in% getAceThemes()) stop(paste0("`theme` does not exist in below list:\n", paste0("\t", getAceThemes(), collapse = ",\n")))
   shinyjs::runjs(
      paste0(
         "const editor = ace.edit('", session$ns(outputId), "');",
         "editor.setTheme('", theme, "');"
      )
   )
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Show or hide line number area in aceEditor
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param outputId
#'    [character]: The id of the editor
#' @param visible
#'    [logical]: TRUE or FALSE
#' @param session
#'    [environment]: The Shiny session object (from the server function of the Shiny app).
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @returns No return value, called for side effects
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'     shinyEditor::setAceLineNumbersVisible(outputId = "editor", visible = TRUE)
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export setAceLineNumbersVisible
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   setAceLineNumbersVisible
#' @title  Show or hide line number area in aceEditor
#' @rdname setAceLineNumbersVisible
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

setAceLineNumbersVisible <- function(outputId, visible, session = shiny::getDefaultReactiveDomain()) {
   check_output_id(outputId)
   shinyjs::runjs(
      paste0(
         "const editor = ace.edit('", session$ns(outputId), "');",
         'editor.setOption("showLineNumbers", ', tolower(visible), ');',
         "editor.renderer.setShowGutter(", tolower(visible), ");"
      )
   )
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Show or hide invisible characters in aceEditor
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param outputId
#'    [character]: The id of the editor
#' @param visible
#'    [logical]: TRUE or FALSE
#' @param session
#'    [environment]: The Shiny session object (from the server function of the Shiny app).
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @returns No return value, called for side effects
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'     shinyEditor::setAceShowInvisibles(outputId = "editor", visible = TRUE)
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export setAceShowInvisibles
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   setAceShowInvisibles
#' @title  Show or hide invisible characters in aceEditor
#' @rdname setAceShowInvisibles
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

setAceShowInvisibles <- function(outputId, visible, session = shiny::getDefaultReactiveDomain()) {
   check_output_id(outputId)
   shinyjs::runjs(
      paste0(
         "const editor = ace.edit('", session$ns(outputId), "');",
         "editor.setShowInvisibles(", tolower(visible), ");"
      )
   )
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Enable or disable code completion in aceEditor
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param outputId
#'    [character]: The id of the editor
#' @param enable
#'    [logical]: TRUE or FALSE
#' @param session
#'    [environment]: The Shiny session object (from the server function of the Shiny app).
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @returns No return value, called for side effects
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'     shinyEditor::setAceEnableAutocompletion(outputId = "editor", enable = TRUE)
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export setAceEnableAutocompletion
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   setAceEnableAutocompletion
#' @title  Enable or disable code completion
#' @rdname setAceEnableAutocompletion
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

setAceEnableAutocompletion <- function(outputId, enable, session = shiny::getDefaultReactiveDomain()) {
   check_output_id(outputId)
   enable <- tolower(enable)
   shinyjs::runjs(
      paste0(
         "const editor = ace.edit('", session$ns(outputId), "');",
         "editor.setOptions({",
         "enableBasicAutocompletion: ", enable, ",",
         "enableSnippets: ", enable, ",",
         "enableLiveAutocompletion: ", enable,
         "});"
      )
   )
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Set the new line mode to aceEditor
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param outputId
#'    [character]: The id of the editor
#' @param newLineMode
#'    [character]: The new line mode in aceEditor
#'    Valid values: windows, unix, auto
#' @param session
#'    [environment]: The Shiny session object (from the server function of the Shiny app).
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @returns No return value, called for side effects
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'     shinyEditor::setAceNewLineMode(outputId = "editor", newLineMode = "windows")
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export setAceNewLineMode
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   setAceNewLineMode
#' @title  Set the new line mode to aceEditor
#' @rdname setAceNewLineMode
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

setAceNewLineMode <- function(outputId, newLineMode, session = shiny::getDefaultReactiveDomain()) {
   check_output_id(outputId)
   shinyjs::runjs(
      paste0(
         "const editor = ace.edit('", session$ns(outputId), "');",
         'editor.session.setNewLineMode("', newLineMode, '");'
      )
   )
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    If readOnly is true, then the editor is set to read-only mode, and none of the content can change.
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param outputId
#'    [character]: The id of the editor
#' @param readOnly
#'    [logical]: TRUE or FALSE
#' @param session
#'    [environment]: The Shiny session object (from the server function of the Shiny app).
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @returns No return value, called for side effects
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'     shinyEditor::setAceReadOnly(outputId = "editor", readOnly = TRUE)
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export setAceReadOnly
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   setAceReadOnly
#' @title  Set readOnly for aceEditor
#' @rdname setAceReadOnly
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

setAceReadOnly <- function(outputId, readOnly, session = shiny::getDefaultReactiveDomain()) {
   check_output_id(outputId)
   shinyjs::runjs(
      paste0(
         "const editor = ace.edit('", session$ns(outputId), "');",
         "editor.setReadOnly(", tolower(readOnly), ");"
      )
   )
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Show or hide the statusBar of aceEditor
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param outputId
#'    [character]: The id of the editor
#' @param visible
#'    [logical]: TRUE or FALSE
#' @param session
#'    [environment]: The Shiny session object (from the server function of the Shiny app).
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @returns No return value, called for side effects
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'     shinyEditor::setAceStatusBarVisible(outputId = "editor", visible = TRUE)
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export setAceStatusBarVisible
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   setAceStatusBarVisible
#' @title  Show or hide the statusBar
#' @rdname setAceStatusBarVisible
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

setAceStatusBarVisible <- function(outputId, visible, session = shiny::getDefaultReactiveDomain()) {
   check_output_id(outputId)
   shinyjs::runjs(
      paste0(
         "const status_bar_id = '", paste0(session$ns(outputId), '_statusBar'), "';",
         "const status_bar_div = document.getElementById(status_bar_id);",
         "status_bar_div.style.display = ", tolower(visible), " ? 'flex':'none';"
      )
   )
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Determines whether or not the current line should be highlighted.
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param outputId
#'    [character]: The id of the editor
#' @param visible
#'    [logical]: TRUE or FALSE
#' @param session
#'    [environment]: The Shiny session object (from the server function of the Shiny app).
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @returns No return value, called for side effects
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'     shinyEditor::setAceHighlightActiveLine(outputId = "editor", visible = TRUE)
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export setAceHighlightActiveLine
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   setAceHighlightActiveLine
#' @title  Highlight the current line
#' @rdname setAceHighlightActiveLine
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

setAceHighlightActiveLine <- function(outputId, visible, session = shiny::getDefaultReactiveDomain()) {
   check_output_id(outputId)
   shinyjs::runjs(
      paste0(
         "const editor = ace.edit('", session$ns(outputId), "');",
         "editor.setHighlightActiveLine(", tolower(visible) , ");"
      )
   )
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Set an option to aceEditor
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param outputId
#'    [character]: The id of the editor
#' @param name
#'    [character]: Option name. Refer to \url{https://ace.c9.io/api/interfaces/ace.Ace.EditorOptions.html}
#' @param value
#'    [character], [integer], [logical]: Option value. Refer to \url{https://ace.c9.io/api/interfaces/ace.Ace.EditorOptions.html}
#' @param session
#'    [environment]: The Shiny session object (from the server function of the Shiny app).
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @returns No return value, called for side effects
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'     shinyEditor::setAceOption(outputId = "editor", name = "tabSize", value = 3)
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export setAceOption
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   setAceOption
#' @title  Set an option to aceEditor
#' @rdname setAceOption
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

setAceOption <- function(outputId, name, value, session = shiny::getDefaultReactiveDomain()) {
   check_output_id(outputId)
   shinyjs::runjs(
      paste0(
         "const editor = ace.edit('", session$ns(outputId), "');",
         "editor.setOption(name = '", name, "', value = ", jsonlite::toJSON(value, auto_unbox = TRUE), ");"
      )
   )
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Set options to aceEditor
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param outputId
#'    [character]: The id of the editor
#' @param options
#'    [list]: Editor options. Refer to \url{https://ace.c9.io/api/interfaces/ace.Ace.EditorOptions.html}
#' @param session
#'    [environment]: The Shiny session object (from the server function of the Shiny app).
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @returns No return value, called for side effects
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'     shinyEditor::setAceOptions(outputId = "editor", options = list())
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export setAceOptions
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   setAceOptions
#' @title  Set options to aceEditor
#' @rdname setAceOptions
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

setAceOptions <- function(outputId, options, session = shiny::getDefaultReactiveDomain()) {
   check_output_id(outputId)
   shinyjs::runjs(
      paste0(
         "const editor = ace.edit('", session$ns(outputId), "');",
         "editor.setOptions(", jsonlite::toJSON(options, auto_unbox = TRUE), ");"
      )
   )
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Get value in aceEditor
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param outputId
#'    [character]: The id of the editor
#' @param session
#'    [environment]: The Shiny session object (from the server function of the Shiny app).
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @returns Character of editor text
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'     shinyEditor::getAceValue(outputId = "editor")
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export getAceValue
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   getAceValue
#' @title  Get value in aceEditor
#' @rdname getAceValue
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

getAceValue <- function(outputId, session = shiny::getDefaultReactiveDomain()) {
   check_output_id(outputId)
   data <- session$input[[outputId]]
   return(data)
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Get cursor position in aceEditor
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
#'     shinyEditor::getAceCursorPosition(outputId = "editor")
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export getAceCursorPosition
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   getAceCursorPosition
#' @title  Get cursor position in aceEditor
#' @rdname getAceCursorPosition
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

getAceCursorPosition <- function(outputId, session = shiny::getDefaultReactiveDomain()) {
   check_output_id(outputId)
   data <- session$input[[paste0(outputId, "_cursor_changed")]]
   if (!is.null(data)) {
      data <- jsonlite::fromJSON(data)
   }
   return(data)
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Get selection range in aceEditor
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
#'     shinyEditor::getAceSelectionRange(outputId = "editor")
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export getAceSelectionRange
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   getAceSelectionRange
#' @title  Get selection range in aceEditor
#' @rdname getAceSelectionRange
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

getAceSelectionRange <- function(outputId, session = shiny::getDefaultReactiveDomain()) {
   check_output_id(outputId)
   data <- session$input[[paste0(outputId, "_selection_changed")]]
   if (!is.null(data)) {
      data <- jsonlite::fromJSON(data)
   }
   return(data)
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Get selected text in aceEditor
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param outputId
#'    [character]: The id of the editor
#' @param session
#'    [environment]: The Shiny session object (from the server function of the Shiny app).
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @returns Character of selected text
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'     shinyEditor::getAceSelectedText(outputId = "editor")
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export getAceSelectedText
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   getAceSelectedText
#' @title  Get selected text in aceEditor
#' @rdname getAceSelectedText
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

getAceSelectedText <- function(outputId, session = shiny::getDefaultReactiveDomain()) {
   check_output_id(outputId)
   data <- session$input[[paste0(outputId, "_selected_text")]]
   return(data)
}


# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @description
#'    Fires upon aceEditor initialisation
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
# Function Arguments:
#' @param outputId
#'    [character]: The id of the editor
#' @param session
#'    [environment]: The Shiny session object (from the server function of the Shiny app).
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @returns `TRUE`
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|
#' @examples
#' if(interactive()){
#'     shinyEditor::onAceEditorReady(outputId = "editor")
#' }
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @export onAceEditorReady
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
#' @name   onAceEditorReady
#' @title  Fires upon aceEditor initialisation
#' @rdname onAceEditorReady
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%|

onAceEditorReady <- function(outputId, session = shiny::getDefaultReactiveDomain()) {
   check_output_id(outputId)
   data <- session$input[[paste0(outputId, "_ready")]]
   return(data)
}
