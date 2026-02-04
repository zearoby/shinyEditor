# Check functions in utils.R file

testthat::test_that("modes", {
   modes <- shinyEditor::getAceModes()
   testthat::expect_true(is.character(modes))
   testthat::expect_true(length(modes) > 0)
   testthat::expect_true(sum(nchar(modes)) > 500)
})

testthat::test_that("themes", {
   themes <- shinyEditor::getAceThemes()
   testthat::expect_true(is.character(themes))
   testthat::expect_true(length(themes) > 0)
   testthat::expect_true(sum(nchar(themes)) > 300)
})

testthat::test_that("fonts", {
   fonts <- shinyEditor::getSystemFontFamilies()
   testthat::expect_true(is.character(fonts))
   testthat::expect_true(length(fonts) > 0)
   testthat::expect_true(sum(nchar(fonts)) > 500)
})

testthat::test_that("status", {
   status <- shinyEditor::getPackageStatus()
   testthat::expect_true(is.list(status))
   testthat::expect_true(length(status) > 0)
})
