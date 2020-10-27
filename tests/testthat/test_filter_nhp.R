library(testthat)
library(filterNHP)

context("Search terms formatting")

# test_check("filterNHP")

test_that("correct index prefixes are used", {
  # when there are no PsycInfo index terms (e.g. for atelidae);
  # should not return empty DE()
  expect_false(
    grepl("DE",
          filter_nhp(database = "PsycInfo",
                     taxa = "atelidae",
                     simplify = FALSE),
          fixed = TRUE)
    )

})


# NB: we may not want only the parent search terms to be used in case taxonomic groupings change?
test_that("parent search terms are included when all children are present",{
  expect_equal(
    filter_nhp("PubMed",
               taxa = c("simiiformes"),
               simplify = FALSE),
    filter_nhp("PubMed",
               taxa = c("platyrrhini", "catarrhini"),
               simplify = FALSE)
    )

  expect_equal(
    filter_nhp("PubMed", taxa = c("aotus"), simplify = FALSE),
    filter_nhp("PubMed", taxa = c("aotidae"), simplify = FALSE)
  )

  # this does not give equal output because the use of parent taxa is coded in
  # filter_nhp(), not the format helpers
  # expect_equal(format_pubmed_terms(taxa = c("aotus")),
  #              format_pubmed_terms(taxa = c("aotidae")))

  expect_equal(
    filter_nhp("PubMed", taxa = c("Daubentonia"), simplify = FALSE),
    filter_nhp("PubMed", taxa = c("Daubentoniidae"), simplify = FALSE),
    filter_nhp("PubMed", taxa = c("Chiromyiformes"), simplify = FALSE)
  )

  expect_equal(
    filter_nhp("PsycInfo",
               taxa = c("Papionini"),
               simplify = FALSE),
    filter_nhp("PsycInfo",
               taxa = c("macaca", "cercocebus","lophocebus", "rungwecebus",
                        "papio", "theropithecus", "mandrillus"),
               simplify = FALSE),
    filter_nhp("PsycInfo",
               taxa = c("Papionini",
                        "macaca", "cercocebus","lophocebus", "rungwecebus",
                        "papio", "theropithecus", "mandrillus"),
               simplify = FALSE)
    )

  # happens because it is looking for parent when there are not any?
  expect_equal(
    filter_nhp("PubMed",
               taxa = c("strepsirrhini", "haplorrhini"),
               simplify = FALSE),
    filter_nhp("PubMed", taxa = "nonhuman_primates", simplify = FALSE),
    filter_nhp("PubMed", simplify = FALSE)
  )
})

test_that("exclude argument is working properly", {
  # the broad term (e.g. great apes) should not be included when one of them
  # e.g. pongo is excluded
  expect_equal(
    filter_nhp("WebOfScience",
               taxa = "hominidae",
               exclude = "pongo",
               simplify = FALSE),
    filter_nhp("WebOfScience",
               taxa = c("gorilla", "pan"),
               simplify = FALSE)
  )
  expect_equal(
    filter_nhp("WebOfScience",
               taxa = "Hylobatidae",
               exclude = "Hoolock",
               simplify = FALSE),
    filter_nhp("WebOfScience",
               taxa = c("Hylobates",
                        "Nomascus",
                        "Symphalangus"),
               simplify = FALSE)
  )

  # give warning when excluding the only child of a parent
  # e.g. Daubentonia is the only genus of the family Daubentoniidae
  # therefore it does not make sense for Daubentonia to be excluded
  expect_warning(
    filter_nhp(taxa = "Daubentoniidae",
               exclude = "Daubentonia",
               simplify = FALSE)
  )
})

test_that("incorrect inputs give appropriate warnings"{

  # give warning when all_nonhuman_primates is selected with other taxa

})
