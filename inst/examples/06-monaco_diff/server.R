shinyServer(function(input, output, session) {
   output1_id <- "editor1"
   output2_id <- "editor2"

   output[[output1_id]] <- shinyEditor::renderMonacoEditor({
      shinyEditor::monacoEditor(
         value = readLines('../../../R/aceEditor.R'),
         language = "r"
      )
   })

   output[[output2_id]] <- shinyEditor::renderMonacoEditor({
      shinyEditor::monacoEditor(
         value = readLines('../../../R/aceDiffEditor.R'),
         language = "r"
      )
   })

   shiny::observeEvent(input$create, {
      shinyEditor::createMonacoDiffView(editorAId = output1_id, editorBId = output2_id, elementId = "editor3")
   })

   shiny::observeEvent(input$remove, {
      shinyEditor::removeMonacoDiffView(elementId = "editor3")
   })

})
