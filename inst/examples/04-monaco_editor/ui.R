library(shiny)
library(shinyjs)
library(shinyEditor)

shinyUI(
   shiny::fluidPage(
      style = "height: 100vh; display: flex; padding: 0; flex-direction: column;",
      shinyjs::useShinyjs(),
      shinyEditor::monacoEditorOutput("editor1", height = "50%"),
      shinyEditor::monacoEditorOutput("editor2", height = "50%")
   )
)
