# define UI for application that demonstrates a simple Ace editor
library(shiny)
library(shinyEditor)

shinyUI(
   shiny::fluidPage(
      style = "padding: 0; height: 100vh; display: flex; flex-direction: column;",
      shinyjs::useShinyjs(),
      htmltools::div(
         style = "height: 100%; width: 100%;",
         shinyEditor::aceDiffEditorOutput("aceDiffEditor", height = "100%")
      )
   )
)
