# Check aceEditor

testthat::test_that("aceEditor", {
   testthat::expect_error(shinyEditor::aceEditor())
})
