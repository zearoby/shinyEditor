library(shiny)
library(shinyjs)
library(shinyEditor)
library(htmltools)

shinyUI(
   shiny::fluidPage(
      style = "padding: 0; height: 100vh;",
      shinyjs::useShinyjs(),
      htmltools::div(
         style = "height: 30px;",
         shiny::actionButton("create", "Create Diff View", class = "btn-sm btn-primary"),
         shiny::actionButton("remove", "Remove Diff View", class = "btn-sm btn-primary")
      ),
      htmltools::div(
         style = "height: 60%; display: flex; flex-direction: row;",
         shinyEditor::monacoEditorOutput("editor1", height = "100%"),
         shinyEditor::monacoEditorOutput("editor2", height = "100%")
      ),
      htmltools::div(id = "editor3", style = "height: calc(40% - 30px);")
   )
)
