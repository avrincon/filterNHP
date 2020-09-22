#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# update app with:
# rsconnect::deployApp()

# link to primate tree source?
# link to code on github?

# library(shiny)
# library(searchNHP)

# ui ----------------------------------------------------------------------


pt <-
  list(
    suborder    = unique(primate_tree$Get("Suborder")),
    infraorder  = unique(primate_tree$Get("Infraorder")),
    parvorder   = unique(primate_tree$Get("Parvorder")),
    superfamily = unique(primate_tree$Get("Superfamily")),
    family      = unique(primate_tree$Get("Family")),
    subfamily   = unique(primate_tree$Get("Subfamily")),
    tribe       = unique(primate_tree$Get("Tribe")),
    genus       = unique(primate_tree$Get("Genus"))
  )

pt <-
  lapply(pt, function(x){
    x[!is.na(x) & x != "na"]
  })


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
