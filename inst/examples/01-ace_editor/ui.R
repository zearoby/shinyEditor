# define UI for application that demonstrates a simple Ace editor
library(shiny)
library(shinyjs)
library(shinyEditor)

shinyUI(
   shiny::fluidPage(
      style = "padding: 0;",
      shinyjs::useShinyjs(),
      shiny::div(
         style = "height: 100vh; display: flex; flex-direction: column;",
         htmltools::div(
            shiny::actionButton("appendCompleter", "Append Completer"),
            shiny::actionButton("removeCompleter", "Remove Completer"),
            shiny::actionButton("enableSpellCheck", "Enable Spell Check"),
            shiny::actionButton("disableSpellCheck", "Disable Spell Check")
         ),
         shinyEditor::aceEditorOutput("editor", height = "100%")
      )
   )
)
