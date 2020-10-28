#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.

library(shiny)
library(shinyWidgets)
library(kableExtra)
library(filterNHP)
# library(clipr)


primates <- readRDS("www/primte_taxa.rds")
d <- read.delim("www/primate_tree_kable.txt")

# ui ----------------------------------------------------------------------


ui <- fluidPage(
  titlePanel("filterNHP: Non-human primate search filters"),

  sidebarLayout(
    sidebarPanel("Select taxonomic group and database"),
    mainPanel("Copy search filter and paste in relevant database")
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
      choiceValues = c("nonhuman_primates")
      # selected = "nonhuman_primates"
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
    ),
    br(),
    actionButton(inputId = "include_button", "Add to include"),
    actionButton(inputId = "exclude_button", "Add to exclude"),
    br(),
    br(),


    "If you use filterNHP in publications, please cite:
               Cassidy LC, Leenaars C, Rincon AV, and Pfefferle D,.
               Comprehensive search filters for retrieving publications on non-human primates for literature reviews (filterNHP)"

  ),


  mainPanel(
    fluidRow(
      tags$a(img(src = 'packageHex_20201015.png',
                 height = '150x', width = '150px',
                 style = "float:right"),
             href="https://github.com/avrincon/filterNHP"),
      img(src = 'sw_sketch.png', height = '294px', width = '434px'),
    ),
    # img(src = 'Table_2_primate_order.png', height = '645px', width = '1080px'),
    br(),
    br(),
    textInput("include_text", label = "Taxa to include", value = " "),
    textInput("exclude_text", label = "Taxa to exclude", value = " "),
    br(),
    actionButton(inputId = "create", "Create search filter"),
    actionButton(inputId = "copy_button", "Copy search filter"),
    actionButton(inputId = "table_button", "Show primate order"),
    br(),
    textOutput(outputId = "search_terms"),
    # imageOutput(outputId = "nhp_table")
    uiOutput(outputId = "nhp_table")
  )
)


# server ------------------------------------------------------------------


server <- function(input, output, session) {

  # deselect all_nhp_input input if any other level is selected
  # cannot use reactive_taxa() in here (not sure why)
  observe({
    x <- c(input$suborder_input,
           input$infraorder_input,
           input$parvorder_input,
           input$superfamily_input,
           input$family_input,
           input$subfamily_input,
           input$tribe_input,
           input$genus_input)

    # x <- reactive_taxa()

    # Can use character(0) to remove all choices
    if (!is.null(x))
      x <- character(0)

    # Untick all NHP if another taxa is selected
    updateCheckboxGroupInput(session, inputId = "all_nhp_input",
                             label = NULL,
                             choiceNames = c("All non-human primates"),
                             choiceValues = c("nonhuman_primates"),
                             selected = x
    )
  })

  # create reactive vector of taxa input for filter_nhp()
  # will only create search filter when button is clicked
  # reactive_taxa <-
  #   eventReactive(
  #     input$include_input,
  #     {
  #       c(
  #         input$all_nhp_input,
  #         input$suborder_input,
  #         input$infraorder_input,
  #         input$parvorder_input,
  #         input$superfamily_input,
  #         input$family_input,
  #         input$subfamily_input,
  #         input$tribe_input,
  #         input$genus_input
  #       )
  #     })

  v <- reactiveValues(taxa = NULL,
                      exclude = NULL)

  observeEvent(input$create, {
    v$taxa <- c(
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
  })

  # observeEvent(input$rnorm, {
  #   v$data <- rnorm(100)
  # })

  observeEvent(input$include_button,{
    updateTextInput(session,
                    inputId = 'include_text',
                    value = paste0(input$all_nhp_input,
                                   input$suborder_input,
                                   input$infraorder_input,
                                   input$parvorder_input,
                                   input$superfamily_input,
                                   input$family_input,
                                   input$subfamily_input,
                                   input$tribe_input,
                                   input$genus_input))
  })
  observeEvent(input$exclude_button,{
    updateTextInput(session,
                    inputId = 'exclude_text',
                    value = paste0(input$all_nhp_input,
                                   input$suborder_input,
                                   input$infraorder_input,
                                   input$parvorder_input,
                                   input$superfamily_input,
                                   input$family_input,
                                   input$subfamily_input,
                                   input$tribe_input,
                                   input$genus_input))
  })


  # print search filter
  output$search_terms <-
    renderPrint(
      filter_nhp(
        database = input$database_input,
        taxa = v$taxa
        # taxa = reactive_taxa()
      )
    )

  # copy filter_nhp() output to clipboard
  observeEvent(input$copy_button, {
    clipr::write_clip(
      filter_nhp(database = input$database_input,
                 taxa = v$taxa,
                 # taxa = reactive_taxa(),
                 simplify = F))
  })

  # show primate table after clicking button
  observeEvent(input$table_button, {
    output$nhp_table <- renderUI({
      imageOutput("dynamic_plot")
    })

    output$dynamic_plot <- renderImage({
      # Return a list containing the filename and other info
      list(src = "www/Table_2_primate_order.png",
           height = '645px', width = '1080px')
    },
    deleteFile = FALSE)
  })

}

# Run the application
shinyApp(ui = ui, server = server)
