shinyServer(function(input, output, session) {
   output_id <- "monacoDiffEditor"

   output[[output_id]] <- shinyEditor::renderMonacoDiffEditor({
      shinyEditor::monacoDiffEditor(
         valueA = readLines('../../../R/monacoEditor.R'),
         valueB = readLines('../../../R/monacoDiffEditor.R'),
         language = "r",
         automaticLayout = T
      )
   })
})
