# define UI for application that demonstrates a simple monaco editor
library(shiny)
library(shinyjs)
library(shinyEditor)

shinyUI(
   shiny::fluidPage(
      style = "padding: 0; height: 100vh; display: flex; flex-direction: column;",
      shinyjs::useShinyjs(),
      htmltools::div(
         # shiny::actionButton("appendCompleter", "Append Completer"),
         # shiny::actionButton("removeCompleter", "Remove Completer"),
         shiny::actionButton("enableSpellCheck", "Enable Spell Check"),
         shiny::actionButton("disableSpellCheck", "Disable Spell Check"),
         shiny::actionButton("lighttheme", "Light Theme"),
         shiny::actionButton("darktheme", "Dark Theme")
      ),
      shinyEditor::monacoEditorOutput("editor", height = "calc(100% - 34px)")

   )
)
