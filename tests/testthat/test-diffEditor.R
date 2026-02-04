# Check aceDiffEditor

testthat::test_that("aceDiffEditor", {
   testthat::expect_error(shinyEditor::aceDiffEditor())
   testthat::expect_error(shinyEditor::aceDiffEditor(1))
})
