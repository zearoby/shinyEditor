# define server logic required to generate simple ace editor
shinyServer(function(input, output, session) {
   output_id <- "aceDiffEditor"

   output[[output_id]] <- shinyEditor::renderAceDiffEditor({
      shinyEditor::aceDiffEditor(
         valueA = readLines('../../../R/aceEditor.R'),
         valueB = readLines('../../../R/aceDiffEditor.R'),
         mode = "ace/mode/r",
         showStatusBar = TRUE
      )
   })
})
