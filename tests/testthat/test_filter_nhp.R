library(testthat)
library(filterNHP)

# test_check("filterNHP")

test_that("correct index prefixes are used", {
  # when there are no PsycInfo index terms (e.g. for atelidae);
  # should not return empty DE()
  expect_false(
    grepl("DE",
          filter_nhp("PsycInfo", taxa = "atelidae", simplify = FALSE),
          fixed = TRUE)
  )

  expect_match(
    filter_nhp("PsycInfo",taxa = "atelidae",simplify = FALSE),
    "TX"
  )
  expect_match(
    filter_nhp("PsycInfo",taxa = "papio",simplify = FALSE),
    "DE"
  )

  expect_match(
    filter_nhp("PubMed",taxa = "papio",simplify = FALSE),
    "mh"
  )
  expect_match(
    filter_nhp("PubMed",taxa = "papio",simplify = FALSE),
    "tiab"
  )

  expect_match(
    filter_nhp("WebOfScience",taxa = "papio",simplify = FALSE),
    "TS="
  )
})


test_that("incorrect inputs give appropriate error message", {
  expect_error(filter_nhp("PsycInfo", taxa = "panda"),
               "These terms are not valid taxa")
  expect_error(filter_nhp("PsycInfo", taxa = c("macaca", "papio", "tiger")),
               "These terms are not valid taxa")
  expect_error(filter_nhp("PsycInfo", taxa = "platyrrhini", omit = "snake"),
               "These terms are not valid taxa")
  expect_error(filter_nhp("PsycInfo", taxa = 666),
               "These terms are not valid taxa")
  expect_error(filter_nhp("GoogleScholar", taxa = "macaca"),
               "is not a valid source")
})

