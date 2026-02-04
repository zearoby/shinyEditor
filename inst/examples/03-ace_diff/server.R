# define server logic required to generate simple ace editor
shinyServer(function(input, output, session) {
   output1_id <- "editor1"
   output2_id <- "editor2"

   output[[output1_id]] <- shinyEditor::renderAceEditor({
      shinyEditor::aceEditor(
         value = readLines('../../../R/aceEditor.R'),
         mode = "ace/mode/r"
      )
   })

   output[[output2_id]] <- shinyEditor::renderAceEditor({
      shinyEditor::aceEditor(
         value = readLines('../../../R/aceDiffEditor.R'),
         mode = "ace/mode/r"
      )
   })

   shiny::observeEvent(input$create, {
      shinyEditor::createAceDiffView(editorAId = output1_id, editorBId = output2_id)
   })

   shiny::observeEvent(input$remove, {
      shinyEditor::removeAceDiffView(outputId = output1_id)
   })
})
