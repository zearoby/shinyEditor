# define UI for application that demonstrates a simple Ace editor
library(shiny)
library(shinyjs)
library(shinyEditor)
library(htmltools)

shinyUI(
   shiny::fluidPage(
      style = "padding: 0; height: 100vh;",
      shinyjs::useShinyjs(),
      htmltools::div(
         style = "display: flex; flex-direction: column; height: 100%; width: 100%;",
         htmltools::div(
            shiny::actionButton("create", "Create Diff View"),
            shiny::actionButton("remove", "Remove Diff View")
         ),
         htmltools::div(
            style = "display: flex; flex: 1;",
            shinyEditor::aceEditorOutput("editor1", height = "100%"),
            shinyEditor::aceEditorOutput("editor2", height = "100%")
         )
      )
   )
)
