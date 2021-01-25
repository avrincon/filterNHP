#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.

library(shiny)
library(shinyjs)
library(shinyBS)
library(filterNHP)

primates <- readRDS("www/primte_taxa.rds")

# ui ----------------------------------------------------------------------


ui <-
  fluidPage(
    shinyjs::useShinyjs(),
    includeCSS("www/style.css"),
    titlePanel(
      title = div(
        a(img(src = 'packageHex_v2_20210121.png',
              height = '75px', width = '75px'),
          href="https://github.com/avrincon/filterNHP"),
        "filterNHP: Non-human primate (NHP) search filter generator"
      ),
      windowTitle = "filterNHP: Non-human primate (NHP) search filter generator"
    ),

    h5("version 0.0.1"),

    tabsetPanel(
      tabPanel(
        title = "App",

        flowLayout(
          cellArgs = list(
            # id = "instruction_inputs",
            style = "min-width:650px;
                 word-wrap:break-word;"
          ),
          wellPanel(
            class = "instruction_well",
            fluidRow(
              p("Identifying all of the relevant research on a particular topic for literature reviews involving non-human primates (NHPs) can be difficult and time consuming. filterNHP automatizes the creation of search filters for the taxonomic levels of NHPs for three bibliographic databases (",
                a("PubMed",
                  href = "https://pubmed.ncbi.nlm.nih.gov/",
                  .noWS = "outside"),
                ", ",
                a("PsycINFO",
                  href = "http://search.ebscohost.com/Login.aspx?profile=web&defaultdb=psyh&lp=login.asp&ref=https%3A%2F%2Fwww%2Egoogle%2Ecom%2F&authtype=ip,uid",
                  .noWS = "outside"),
                ", and ",
                a("Web of Science",
                  href = "http://login.webofknowledge.com/error/Error?Error=IPError&PathInfo=%2F&RouterURL=http%3A%2F%2Fwww.webofknowledge.com%2F&Domain=.webofknowledge.com&Src=IP&Alias=WOK5",
                  .noWS = "outside"),
                ").",
                "These search filters can be combined with topic search strings using the Boolean operator 'AND' to facilitate the retrieval of all publications related to NHPs and the topic within the specified database."
                # style="min-width:1000px; word-wrap:break-word;"
              )
            ),
            fluidRow(
              p(
                em("Usage:"),
                br(),
                tags$ul(
                  tags$li("Select the database of interest."),
                  tags$li('Determine the broadest taxonomic level(s) of NHP desired (see primate order table) and type it in the space below "Taxa to include" in the panel to the right. Take care to use the correct spelling as shown in the primate order table below.',
                          tags$ul(
                            tags$li('If a search filter for all non-human primates is desired, simply tick the checkbox.'),
                            tags$li('Exclusion of a sub-group can be specified by typing in the space below "Taxa to exclude".')
                          )
                  ),
                  tags$li('Hit "Create!"'),
                  tags$li('Copy and paste the generated search filter into the corresponding database.')
                )
              )
            ),
            fluidRow(
              p("Please cite: Cassidy LC, Leenaars CHC, Rincon AV, Pfefferle D,",
                '(', em("in review", .noWS = c("outside")), ').',
                '"Comprehensive search filters for retrieving publications on non-human primates for literature reviews (filterNHP)".',
                em('American Journal of Primatology', .noWS = c("after")),
                '.'
              )
            )
          ),

          wellPanel(
            # id = "input_well",
            selectInput(
              inputId = "database_input",
              label = "Database",
              choices = c("PubMed", "PsycINFO", "Web of Science"),
              selected = "PubMed"
            ),

            textInput("include_text", label = "Taxa to include", value = ""),
            shinyBS::bsTooltip(
              id = "include_text",
              title = "Separate multiple with comma and/or space"
            ),

            checkboxGroupInput(
              inputId = "all_nhp_input",
              label = NULL,
              choiceNames = c("All non-human primates"),
              choiceValues = c("nonhuman_primates"),
            ),
            shinyBS::bsPopover(
              id = "all_nhp_input",
              title = "Create search filter for all non-human primates"
            ),

            textInput("exclude_text", label = "Taxa to exclude", value = ""),
            shinyBS::bsTooltip(
              id = "exclude_text",
              title = "Separate multiple with comma and/or space"
            ),

            br(),
            actionButton(inputId = "create", "Create!"),
            actionButton(inputId = "clear_button", "Clear", icon("eraser"))
          )
        ),

        div(
          h3(
            "Search Filter",
            actionButton(inputId = "copy_button",
                         "Copy",
                         icon("copy"))
          ),
          h4("Copy search filter and paste in relevant database"),
          div(
            # id = "search_filter",
            textOutput(outputId = "search_filter")
          )
        ),

        div(
          h3(
            "Primate order",
            actionButton(inputId = "table_button",
                         label = "",
                         icon = icon("minus"))
          ),
          div(
            id = 'primate_order_table',
            includeHTML("www/primate-order-table.html")
          )
        ),
      ),
      tabPanel(
        title = "Version History",
        h5("version 0.0.1"),
        p("Initial release.")
      )
    )
  )


# server ------------------------------------------------------------------


server <- function(input, output, session) {

  # deselect all_nhp_input input if any text is added to include_text input
  # cannot use reactive_taxa() in here (not sure why)
  observe({
    x <- c(input$include_text)

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
  # takes the input from the text boxes
  # if include text box is empty, it will take input from all nhp checkbox
  v <- reactiveValues(taxa = NULL,
                      exclude = NULL)

  split_string <- function(string) {
    # split strings from text input by comma, space and semicolon
    xx <- unlist(strsplit(string, split = ",|\\s|;"))
    xx[xx != ""]
  }
  observeEvent(input$create, {

    if (nchar(input$include_text) > 0){
      v$taxa <-
        split_string(input$include_text)
    }
    if (nchar(input$include_text) == 0){
      v$taxa <- input$all_nhp_input
    }
    if (nchar(input$exclude_text) > 0){
      v$exclude <-
        split_string(input$exclude_text)
    }
    if (nchar(input$exclude_text) == 0){
      v$exclude <- NULL
    }
  })

  # print search filter
  output$search_filter <-
    renderPrint(
      filter_nhp(
        database = input$database_input,
        taxa = v$taxa,
        exclude = v$exclude
      )
    )

  # copy filter_nhp() output to clipboard
  observeEvent(input$copy_button, {
    clipr::write_clip(
      filter_nhp(database = input$database_input,
                 taxa = v$taxa,
                 exclude = v$exclude,
                 simplify = FALSE))
  })

  # clear text boxes and search filter
  observeEvent(input$clear_button, {
    updateTextInput(session,
                    inputId = "include_text",
                    value = "")
    updateTextInput(session,
                    inputId = "exclude_text",
                    value = "")
    v$taxa <- NULL
    v$exclude <- NULL
  })

  # hide/show primate table after clicking button
  observeEvent(input$table_button, {
    toggle('primate_order_table')
  })

}

# Run the application
shinyApp(ui = ui, server = server)
