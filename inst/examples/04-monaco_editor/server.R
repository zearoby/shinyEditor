shinyServer(function(input, output, session) {

   output_id <- "editor1"
   output[[output_id]] <- shinyEditor::renderMonacoEditor({
      shinyEditor::monacoEditor(
         value = readLines('server.R'),
         language = "python"
      )
   })

   output_id <- "editor2"
   output[[output_id]] <- shinyEditor::renderMonacoEditor({
      shinyEditor::monacoEditor(
         value = readLines('server.R'),
         language = "r"
      )
   })

   shiny::observeEvent(shinyEditor::getMonacoValue(output_id), {
      print("getMonacoValue:")
      print(shinyEditor::getMonacoValue(output_id))
   })
   shiny::observeEvent(shinyEditor::getMonacoCursorPosition(output_id), {
      print("getMonacoCursorPosition:")
      print(shinyEditor::getMonacoCursorPosition(output_id))
   })
   shiny::observeEvent(shinyEditor::getMonacoSelectionRange(output_id), {
      print("getMonacoSelectionRange:")
      print(shinyEditor::getMonacoSelectionRange(output_id))
   })
   shiny::observeEvent(shinyEditor::getMonacoSelectedText(output_id), {
      print("getMonacoSelectedText:")
      print(shinyEditor::getMonacoSelectedText(output_id))
   })
   shiny::observeEvent(shinyEditor::onMonacoEditorReady(output_id), {
      print("Monaco Editor initialized finished!")
      # shinyEditor::updateMonacoOptions(output_id, list(readOnly = TRUE))
      shinyEditor::setMonacoTheme("vs-dark")
      shinyEditor::setMonacoLanguage(output_id, "r")
   })
})
