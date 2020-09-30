#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.

# library(shiny)
# library(searchNHP)

# ui ----------------------------------------------------------------------



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

    checkboxGroupInput(inputId = "taxon_input", label = "taxon",
                       # choices = names(ta)[6:length(names(ta))],
                       choices = c("NHPs"),
                       selected = "NHPs"),

    checkboxGroupInput(inputId = "suborder_input", label = "suborder",
                       choices = c("strepsirrhini", "haplorrhini")),

    checkboxGroupInput(inputId = "infraorder_input", label = "infraorder",
                       choices = c("lorisiformes", "chiromyiformes", "lemuriformes", "tarsiiformes", "simiiformes")),

    checkboxGroupInput(inputId = "parvorder_input", label = "parvorder",
                       choices = c("platyrrhini", "catarrhini")),

    checkboxGroupInput(inputId = "superfamily_input", label = "superfamily",
                       choices = c("lemuroidea", "lorisoidea", "cercopithecoidea", "hominoidea")),

    checkboxGroupInput(inputId = "family_input", label = "family",
                       choices = c("cercopithecidae", "hominidae", "hylobatidae", "cebidae", "aotidae", "atelidae", "pitheciidae", "tarsiidae", "lemuridae", "cheirogaleidae", "lepilemuridae", "indriidae", "daubentoniidae", "lorisidae", "galagidae")),

    checkboxGroupInput(inputId = "subfamily_input", label = "subfamily",
                       choices = c("callitrichinae", "cebinae", "alouattinae", "atelinae", "callicebinae", "saimirinae", "pithecinae", "cercopithecinae", "colobinae", "perodicticinae", "lorinae", "ponginae", "homininae")),

    checkboxGroupInput(inputId = "tribe_input", label = "tribe",
                       choices = c("hominini", "gorillini", "cercopithecini", "papionini")),

    checkboxGroupInput(inputId = "genus_input", label = "genus",
                       choices = c("cheirogaleus", "microcebus", "mirza", "allocebus", "phaner", "daubentonia", "indri", "avahi", "propithecus", "eulemur", "varecia", "hapalemur", "prolemur", "lepilemur", "lemur", "arctocebus", "perodicticus", "pseudopotto", "loris", "nycticebus", "galago", "euoticus", "otolemur", "paragalago", "sciurocheirus", "galagoides", "carlito", "cephalopachus", "tarsius", "cebuella", "callibella", "mico", "callithrix", "callimico", "saguinus", "leontocebus", "leontopithecus", "cebus", "sapajus", "saimiri", "aotus", "plecturocebus", "callicebus", "cheracebus", "cacajao", "chiropotes", "pithecia", "aloutta", "ateles", "brachyteles", "lagothrix", "oreonax", "allenopithecus", "miopithecus", "erythrocebus", "chlorocebus", "cercopithecus", "macaca", "cercocebus", "lophocebus", "rungwecebus", "papio", "theropithecus", "mandrillus", "colobus", "piliocolobus", "procolobus", "semnopithecus", "trachypithecus", "presbytis", "pygathrix", "rhinopithecus", "nasalis", "simias", "hoolock", "hylobates", "nomascus", "symphalangus", "pongo", "gorilla", "pan")),


  ),

  mainPanel(
    # imageOutput("primate_tree"),
    img(src = 'sw_sketch.png', height = '294px', width = '434px'),

    textOutput("search_terms")
  )
)

server <- function(input, output) {

  # output$results <- renderPrint(search_terms)
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
