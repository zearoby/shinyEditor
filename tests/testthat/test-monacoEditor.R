# Check monacoEditor

testthat::test_that("monacoEditor", {
   testthat::expect_error(shinyEditor::monacoEditor())
})
