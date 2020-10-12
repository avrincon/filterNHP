library(testthat)
library(searchNHP)

context("Search terms formatting")

# test_check("searchNHP")

test_that("correct index prefixes are used", {
  # there are no PsycInfo index terms for atelidae;
  # therefore should not return empty DE()
  expect_false(
    grepl("DE",
          search_nhp(database = "PsycInfo", taxa = "atelidae"),
          fixed = TRUE))

})


test_that("parent search terms are included when all children are present",{
  expect_equal(search_nhp("PubMed", taxa = c("simiiformes")),
               search_nhp("PubMed", taxa = c("platyrrhini", "catarrhini")))

  expect_equal(search_nhp("PubMed", taxa = c("aotus")),
               search_nhp("PubMed", taxa = c("aotidae")))

  # this does not give equal output because the use of parent taxa is coded in
  # search_nhp(), not the format helpers
  # expect_equal(format_pubmed_terms(taxa = c("aotus")),
  #              format_pubmed_terms(taxa = c("aotidae")))

  expect_equal(search_nhp("PubMed", taxa = c("Daubentonia")),
               search_nhp("PubMed", taxa = c("Daubentoniidae")),
               search_nhp("PubMed", taxa = c("Chiromyiformes")))

  expect_equal(
    search_nhp("PsycInfo", taxa = c("Papionini")),
    search_nhp("PsycInfo", taxa = c("macaca", "cercocebus","lophocebus",
                                    "rungwecebus","papio", "theropithecus",
                                    "mandrillus")),
    search_nhp("PsycInfo", taxa = c("Papionini",
                                    "macaca", "cercocebus","lophocebus",
                                    "rungwecebus","papio", "theropithecus",
                                    "mandrillus")))
})
