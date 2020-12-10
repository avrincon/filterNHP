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
    "TI"
  )
  expect_match(
    filter_nhp("WebOfScience",taxa = "papio",simplify = FALSE),
    "AB"
  )

})

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
    filter_nhp("WebOfScience", taxa = c("aotus"), simplify = FALSE),
    filter_nhp("WebOfScience", taxa = c("aotidae"), simplify = FALSE)
  )

  expect_equal(
    filter_nhp("PubMed", taxa = c("Daubentonia"), simplify = FALSE),
    filter_nhp("PubMed", taxa = c("Daubentoniidae"), simplify = FALSE)
  )
  expect_equal(
    filter_nhp("PsycInfo", taxa = c("Daubentonia"), simplify = FALSE),
    filter_nhp("PsycInfo", taxa = c("Chiromyiformes"), simplify = FALSE)
  )

  expect_equal(
    filter_nhp("PsycInfo",
               taxa = c("Papionini"),
               simplify = FALSE),
    filter_nhp("PsycInfo",
               taxa = c("macaca", "cercocebus","lophocebus", "rungwecebus",
                        "papio", "theropithecus", "mandrillus"),
               simplify = FALSE)
    )
  expect_equal(
    filter_nhp("PsycInfo",
               taxa = c("Papionini"),
               simplify = FALSE),
    filter_nhp("PsycInfo",
               taxa = c("Papionini",
                        "macaca", "cercocebus","lophocebus", "rungwecebus",
                        "papio", "theropithecus", "mandrillus"),
               simplify = FALSE)
    )

  expect_equal(
    filter_nhp("PubMed",
               taxa = c("strepsirrhini", "haplorrhini"),
               simplify = FALSE),
    filter_nhp("PubMed",
               taxa = "nonhuman_primates",
               simplify = FALSE)
  )
  expect_equal(
    filter_nhp("PubMed",
               taxa = c("strepsirrhini", "haplorrhini"),
               simplify = FALSE),
    filter_nhp("PubMed",
               simplify = FALSE)
  )
})

test_that("incorrect inputs give appropriate error message", {
  expect_error(filter_nhp("PsycInfo", taxa = "panda"),
               "These terms are not valid taxa")
  expect_error(filter_nhp("PsycInfo", taxa = c("macaca", "papio", "tiger")),
               "These terms are not valid taxa")
  expect_error(filter_nhp("PsycInfo", taxa = "platyrrhini", exclude = "snake"),
               "These terms are not valid taxa")
  expect_error(filter_nhp("PsycInfo", taxa = 666),
               "These terms are not valid taxa")
  expect_error(filter_nhp("GoogleScholar", taxa = "macaca"),
               "is not a valid database")
})

# # give warning when excluding the only child of a parent
# # e.g. Daubentonia is the only genus of the family Daubentoniidae
# # therefore it does not make sense for Daubentonia to be excluded
# test_that("warning is given when excluding the only child of a parent", {
#   expect_warning(
#     filter_nhp(taxa = "Daubentoniidae", exclude = "Daubentonia"),
#     "is the only taxa within"
#   )
# })


# give warning when all_nonhuman_primates is selected with other taxa
