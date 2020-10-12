library(testthat)
library(searchNHP)

context("Search terms formatting")

# test_check("searchNHP")

test_that("correct index prefixes are used", {
  # there are no PsycInfo index terms for atelidae;
  # therefore should not return empty DE()
  expect_false(
    grepl("DE",
          search_nhp(database = "PsycInfo",
                     taxa = "atelidae",
                     simplify = FALSE),
          fixed = TRUE)
    )

})


test_that("parent search terms are included when all children are present",{
  expect_equal(
    search_nhp("PubMed", taxa = c("simiiformes"), simplify = FALSE),
    search_nhp("PubMed", taxa = c("platyrrhini", "catarrhini"), simplify = FALSE)
    )

  expect_equal(
    search_nhp("PubMed", taxa = c("aotus"), simplify = FALSE),
    search_nhp("PubMed", taxa = c("aotidae"), simplify = FALSE)
  )

  # this does not give equal output because the use of parent taxa is coded in
  # search_nhp(), not the format helpers
  # expect_equal(format_pubmed_terms(taxa = c("aotus")),
  #              format_pubmed_terms(taxa = c("aotidae")))

  expect_equal(
    search_nhp("PubMed", taxa = c("Daubentonia"), simplify = FALSE),
    search_nhp("PubMed", taxa = c("Daubentoniidae"), simplify = FALSE),
    search_nhp("PubMed", taxa = c("Chiromyiformes"), simplify = FALSE)
  )

  expect_equal(
    search_nhp("PsycInfo",
               taxa = c("Papionini"),
               simplify = FALSE),
    search_nhp("PsycInfo",
               taxa = c("macaca", "cercocebus","lophocebus", "rungwecebus",
                        "papio", "theropithecus", "mandrillus"),
               simplify = FALSE),
    search_nhp("PsycInfo",
               taxa = c("Papionini",
                        "macaca", "cercocebus","lophocebus", "rungwecebus",
                        "papio", "theropithecus", "mandrillus"),
               simplify = FALSE)
    )
})
