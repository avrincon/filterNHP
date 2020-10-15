#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.

library(shiny)
library(shinyWidgets)
library(searchNHP)

# ui ----------------------------------------------------------------------

primates <-
  list(
    suborder = c("strepsirrhini", "haplorrhini"),
    infraorder = c("lemuriformes", "chiromyiformes", "lorisiformes", "tarsiiformes", "simiiformes"),
    parvorder = c("platyrrhini", "catarrhini"),
    superfamily = c("cercopithecoidea", "hominoidea"),
    family = c("lemuridae", "lepilemuridae", "cheirogaleidae", "indriidae", "daubentoniidae", "lorisidae", "galagidae", "tarsiidae", "cebidae", "aotidae", "atelidae", "pitheciidae", "cercopithecidae", "hylobatidae", "hominidae"),
    subfamily = c("perodicticinae", "lorinae", "callitrichinae", "cebinae", "saimiriinae", "alouattinae", "atelinae", "pithecinae", "callicebinae", "cercopithecinae", "colobinae", "ponginae", "homininae"),
    tribe = c("cercopithecini", "papionini", "gorillini", "hominini"),
    genus = c("lemur", "eulemur", "varecia", "hapalemur", "prolemur", "lepilemur", "cheirogaleus", "microcebus", "mirza", "allocebus", "phaner", "indri", "avahi", "propithecus", "daubentonia", "arctocebus", "perodicticus", "pseudopotto", "loris", "nycticebus", "galago", "euoticus", "galagoides", "otolemur", "paragalago", "sciurocheirus", "carlito", "cephalopachus", "tarsius", "cebuella", "callibella", "mico", "callithrix", "callimico", "saguinus", "leontocebus", "leontopithecus", "cebus", "sapajus", "saimiri",  "aotus", "aloutta", "ateles", "brachyteles", "lagothrix", "oreonax", "cacajao", "chiropotes", "pithecia", "plecturocebus", "callicebus", "cheracebus", "allenopithecus", "miopithecus", "erythrocebus", "chlorocebus", "cercopithecus", "macaca", "cercocebus", "lophocebus", "rungwecebus", "papio", "theropithecus", "mandrillus", "colobus", "piliocolobus", "procolobus", "semnopithecus", "trachypithecus", "presbytis", "pygathrix", "rhinopithecus", "nasalis", "simias", "hoolock", "hylobates", "nomascus", "symphalangus", "pongo", "gorilla", "pan")
  )

primates <- lapply(primates, sort)


# ui ----------------------------------------------------------------------


ui <- fluidPage(
  titlePanel("SearchNHP: Non-human primate search filter terms"),


  sidebarLayout(
    sidebarPanel("Select taxonomic group and database"),
    mainPanel("Copy search terms and paste in relevant database")
  ),


  sidebarPanel(
    selectInput(
      inputId = "database_input",
      label = "Database",
      choices = c("PubMed", "PsycINFO", "Web of Science"),
      selected = "PubMed"
    ),
    checkboxGroupInput(
      inputId = "all_nhp_input",
      label = NULL,
      choiceNames = c("All non-human primates"),
      choiceValues = c("nonhuman_primates"),
      selected = "all non-human primates"
    ),
    pickerInput(
      inputId = "suborder_input",
      label = "Suborder",
      choices = primates$suborder,
      multiple = TRUE,
      options = pickerOptions(actionsBox = TRUE)
    ),
    pickerInput(
      inputId = "infraorder_input",
      label = "Infraorder",
      choices = primates$infraorder,
      multiple = TRUE,
      options = pickerOptions(actionsBox = TRUE)
    ),
    pickerInput(
      inputId = "parvorder_input",
      label = "Parvorder",
      choices = primates$parvorder,
      multiple = TRUE,
      options = pickerOptions(actionsBox = TRUE)
    ),
    pickerInput(
      inputId = "superfamily_input",
      label = "Superfamily",
      choices = primates$superfamily,
      multiple = TRUE,
      options = pickerOptions(actionsBox = TRUE)
    ),
    pickerInput(
      inputId = "family_input",
      label = "Family",
      choices = primates$family,
      multiple = TRUE,
      options = pickerOptions(actionsBox = TRUE)
    ),
    pickerInput(
      inputId = "subfamily_input",
      label = "Subfamily",
      choices = primates$subfamily,
      multiple = TRUE,
      options = pickerOptions(actionsBox = TRUE)
    ),
    pickerInput(
      inputId = "tribe_input",
      label = "Tribe",
      choices = primates$tribe,
      multiple = TRUE,
      options = pickerOptions(actionsBox = TRUE),
    ),
    pickerInput(
      inputId = "genus_input",
      label = "Genus",
      choices = primates$genus,
      multiple = TRUE,
      options = pickerOptions(actionsBox = TRUE)
    )
  ),


  mainPanel(
    img(src = 'sw_sketch.png', height = '294px', width = '434px'),

    textOutput("search_terms")

  )
)


# server ------------------------------------------------------------------


server <- function(input, output) {

  output$search_terms <-
    renderPrint(
      search_nhp(
        database = input$database_input,
        taxa = c(
          input$all_nhp_input,
          input$suborder_input,
          input$infraorder_input,
          input$parvorder_input,
          input$superfamily_input,
          input$family_input,
          input$subfamily_input,
          input$tribe_input,
          input$genus_input
        )
      )
    )
}

# Run the application
shinyApp(ui = ui, server = server)
