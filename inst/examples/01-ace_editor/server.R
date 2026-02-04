# define server logic required to generate simple ace editor
shinyServer(function(input, output, session) {

   typo_text <- c(
      "# The study of cosmology and astrophysics has allways presented humanity with profound and",
      "# humbling quesions about our place in the univerce. From the earilest civilizations that",
      "# painstakingly chartted the movments of celestal bodys, to the sophistcated observatories and",
      "# space-borne telescopes of the modren era, our quest for comprehention has been defind by both",
      "# briliant insights and persistant mysteries. One of the most fundemental achievments in",
      "# twentith-century sceince was the formulation and subseqent confrimation of the Big Bang",
      "# theory, which posits that the univerce begain in an exeedingly hot, dense state aproximately",
      "# 13.8 billion years ago and has been expanding and coolin ever since. Crucial evidance for this",
      "# model includes the cosmic microwave background radiation—a faint relic glow permeating all of",
      "# space—and the observed abundence of light elements like hydrogen and helium, which were",
      "# synthesized in the first few minuets after the inital explosion.",
      "# However, this triumph of scientfic explanation is far from complete. Astronomers and physicists",
      "# are currently grapling with several perplexing conundrums that challenge our most basic",
      "# assumptions. Foremost among these is the nature of so-called “dark matter” and “dark energy.”",
      "# Obersvations of galaxy rotation curves, gravitatonal lensing, and the large-scale structure of",
      "# the cosmos comvincingly suggest that visble matter—the stars, planets, and gas we can see—",
      "# comprises a mere 5% of the total mass-energy content of the univerce. The remaing 95% is",
      "# attributed to these enigmatic components: dark matter, an invisble substance that interacts",
      "# primarly through gravity and apperently holds galaxies together; and dark energy, a repulsive",
      "# force that seems to be causing the expansion of the univerce to acclerate. Despite decades of",
      "# intense reserch and numerus expirements, the true idenity of these phenomena remians elusive\n\n"
   )

   output_id <- "editor"

   output[[output_id]] <- shinyEditor::renderAceEditor({
      shinyEditor::aceEditor(
         value = readLines('server.R'),
         fontFamily = "consolas",
         fontSize = 16,
         tabSize = 3,
         showInvisibles = TRUE,
         printMarginColumn = "120",
         showStatusBar = TRUE,
         mode = "ace/mode/r",
         placeholder = "This is placeholder message"
      )
   })

   shiny::observeEvent(input$appendCompleter, {
      shinyEditor::appendAceCompleter(
         output_id, id = "custom_completer",
         completer = list(
            list(caption = "if", value = "if () {\n\n}\nelse {\n\n}", meta = "keyword"),
            list(caption = "observe", value = "shiny::observe({\n\n})", meta = "keyword"),
            list(caption = "observeEvent", value = "shiny::observeEvent(, {\n\n})", meta = "keyword")
         )
      )
   })
   shiny::observeEvent(input$removeCompleter, {
      shinyEditor::removeAceCompleter(output_id, id = "custom_completer")
   })

   shiny::observeEvent(input$enableSpellCheck, {
      shinyEditor::setAceEnableSpellCheck(output_id, enable = TRUE)
   })
   shiny::observeEvent(input$disableSpellCheck, {
      shinyEditor::setAceEnableSpellCheck(output_id, enable = FALSE)
   })

   shiny::observeEvent(shinyEditor::getAceValue(output_id), {
      print("getAceValue:")
      print(shinyEditor::getAceValue(output_id))
   })
   shiny::observeEvent(shinyEditor::getAceCursorPosition(output_id), {
      print("getAceCursorPosition:")
      print(shinyEditor::getAceCursorPosition(output_id))
   })
   shiny::observeEvent(shinyEditor::getAceSelectionRange(output_id), {
      print("getAceSelectionRange:")
      print(shinyEditor::getAceSelectionRange(output_id))
   })
   shiny::observeEvent(shinyEditor::getAceSelectedText(output_id), {
      print("getAceSelectedText:")
      print(shinyEditor::getAceSelectedText(output_id))
   })
   shiny::observeEvent(shinyEditor::onAceEditorReady(output_id), {
      print("Ace Editor initialized finished!")
   })
})
