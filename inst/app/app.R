#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.

# library(shiny)
# library(searchNHP)

# ui ----------------------------------------------------------------------

pt <-
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


ui <- fluidPage(
  titlePanel("Primate search filter terms for database"),


  sidebarLayout(
    sidebarPanel("Select taxonomic group and database"),
    mainPanel("Copy search terms and paste in relevant database")
  ),

  sidebarPanel(
    selectInput(inputId = "database_input", label = "database",
                choices = c("PubMed", "PsycInfo", "WebOfScience"),
                selected = "PubMed"),

    checkboxGroupInput(inputId = "all_nhp_input",
                       label = NULL,
                       choices = c("all non-human primates"),
                       selected = "all non-human primates"),

    checkboxGroupInput(inputId = "suborder_input",
                       label = "suborder",
                       choices = pt$suborder),

    checkboxGroupInput(inputId = "infraorder_input",
                       label = "infraorder",
                       choices = pt$infraorder),

    checkboxGroupInput(inputId = "parvorder_input",
                       label = "parvorder",
                       choices = pt$parvorder),

    checkboxGroupInput(inputId = "superfamily_input",
                       label = "superfamily",
                       choices = pt$superfamily),

    checkboxGroupInput(inputId = "family_input",
                       label = "family",
                       choices = pt$family),

    checkboxGroupInput(inputId = "subfamily_input",
                       label = "subfamily",
                       choices = pt$subfamily),

    checkboxGroupInput(inputId = "tribe_input",
                       label = "tribe",
                       choices = pt$tribe),

    checkboxGroupInput(inputId = "genus_input",
                       label = "genus",
                       choices = pt$genus),


  ),

  # include image of primate tree?
  # tags$img(src='www/primate-order.png'))

  mainPanel(
    img(src = 'sw_sketch.png', height = '294px', width = '434px'),

    textOutput("search_terms")
  )
)

server <- function(input, output) {

  output$search_terms <-
    renderPrint(search_nhp(database = input$database_input,
                           taxa = c(
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
