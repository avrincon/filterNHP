#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.

library(shiny)
library(shinyjs)
library(shinyBS)
library(filterNHP)
library(rclipboard)

primates <- readRDS("www/primte_taxa.rds")
taxa_options <- sort(as.vector(unlist(primates)))

# ui ----------------------------------------------------------------------

ui <-
  fluidPage(
    shinyjs::useShinyjs(),
    rclipboardSetup(),
    includeCSS("www/style.css"),
    style = "font-size: 15px;",
    titlePanel(
      title = div(
        a(img(src = 'packageHex_v2_20210121.png',
              height = '75px', width = '75px'),
          href="https://github.com/avrincon/filterNHP"),
        "filterNHP: Non-human primate (NHP) search filter generator"
      ),
      windowTitle = "filterNHP: Non-human primate (NHP) search filter generator"
    ),

    h5("version 0.1.2"),

    tabsetPanel(
      tabPanel(
        title = "App",

        flowLayout(
          cellArgs = list(
            style = "min-width:650px;
                     word-wrap:break-word"
          ),
          wellPanel(
            id = "instruction_well",
            fluidRow(
              p("Identifying all of the relevant research on a particular topic for literature reviews involving non-human primates (NHPs) can be difficult and time consuming. filterNHP automatizes the creation of search filters for the taxonomic levels of NHPs for three bibliographic sources (",
                a("PubMed",
                  href = "https://pubmed.ncbi.nlm.nih.gov/",
                  .noWS = "outside"),
                ", ",
                a("PsycINFO via EBSCOhost",
                  href = "http://search.ebscohost.com/Login.aspx?profile=web&defaultdb=psyh&lp=login.asp&ref=https%3A%2F%2Fwww%2Egoogle%2Ecom%2F&authtype=ip,uid",
                  .noWS = "outside"),
                ", and ",
                a("Web of Science",
                  href = "http://login.webofknowledge.com/error/Error?Error=IPError&PathInfo=%2F&RouterURL=http%3A%2F%2Fwww.webofknowledge.com%2F&Domain=.webofknowledge.com&Src=IP&Alias=WOK5",
                  .noWS = "outside"),
                ").",
                "These search filters can be combined with topic search strings using the Boolean operator 'AND' to facilitate the retrieval of all publications related to NHPs and the topic within the specified database/platform."
              )
            ),
            fluidRow(
              p(
                em("Usage:"),
                br(),
                tags$ul(
                  tags$li("Select the bibliographic source of interest."),
                  tags$li('Determine the broadest taxonomic level(s) of NHP desired (see primate order table) and select option(s) from "Taxa to include" in the panel to the right.',
                          tags$ul(
                            tags$li('If a search filter for all non-human primates is desired, simply tick the checkbox.'),
                            tags$li('Omission of a sub-group can be specified by selecting from "Taxa to omit".')
                          )
                  ),
                  tags$li('Hit "Create!"'),
                  tags$li('Copy and paste the search filter into the search box of the corresponding source.',
                          tags$ul(
                            tags$li('For Web of Science, use the', em("Advanced Search"), 'page.')
                          )
                  )
                )
              )
            ),
            fluidRow(
              p("We encourage users to review the search filters and adapt them to their own needs. For further details, please see ",
                a("Cassidy et al., (2021)",
                  href = "https://doi.org/10.1002/ajp.23287",
                  .noWS = "outside"),".",
                "To report a bug or request a new feature, please use the ",
                a("GitHub repository",
                  href = "https://github.com/avrincon/filterNHP/issues",
                  .noWS = "outside"),
                ".")
            )
          ),

          wellPanel(
            id = "input_well",
            selectInput(
              inputId = "source_input",
              label = "Bibliographic source",
              choices = c("PubMed", "PsycINFO", "Web of Science"),
              selected = "PubMed"
            ),

            selectizeInput(inputId = "include_text",
                           label = "Taxa to include",
                           choices = taxa_options,
                           selected = NULL,
                           multiple = TRUE,
                           options = list(closeAfterSelect = TRUE)),

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

            selectizeInput(inputId = "omit_text",
                           label = "Taxa to omit",
                           choices = taxa_options,
                           selected = NULL,
                           multiple = TRUE,
                           options = list(closeAfterSelect = TRUE)),

            actionButton(inputId = "create", "Create!"),
            actionButton(inputId = "clear_button", "Clear", icon("eraser")),

            br(),
            br(),

            p("Please cite: Cassidy LC, Leenaars CHC, Rincon AV, & Pfefferle D. (2021). Comprehensive search filters for retrieving publications on non-human primates for literature reviews (filterNHP).",
              em('American Journal of Primatology', .noWS = c("after")),
              ", 83(7), e23287.",
              a("https://doi.org/10.1002/ajp.23287",
                     href = "https://doi.org/10.1002/ajp.23287",
                     .noWS = "after"))
          )
        ),

        div(
          h3(
            p("Search Filter",
              uiOutput(outputId = "clip", inline = TRUE)
            )
          ),
          h4("Copy search filter and paste into search box of corresponding bibliographic source"),
          div(
            textOutput(outputId = "search_filter")
          )
        ),

        div(
          h3(
            "Primate order",
            actionButton(inputId = "table_button",
                         label = "",
                         icon = icon("chevron-up"))
          ),
          div(
            id = 'primate_order_div',
            includeHTML("www/primate-order-table.html")
          )
        ),
      ),

# FAQ panel ---------------------------------------------------------------

      tabPanel(
        title = "FAQ",
        # h1("Frequently Asked Questions"),
        h4("Why is the search filter syntax different for each bibliographic source?",
           class = "faq_head",
           actionButton(inputId = "faq1_button",
                        label = "",
                        icon = icon("chevron-down"))),
        hidden(
          div(class = "faq", id = "faq1_answer",
              includeHTML("www/FAQ-1.html")
          )
        ),

        h4("What are index terms?",
           class = "faq_head",
           actionButton(inputId = "faq2_button",
                        label = "",
                        icon = icon("chevron-down"))),
        hidden(
          div(class = "faq", id = "faq2_answer",
              includeHTML("www/FAQ-2.html")
          )
        ),

        h4("Why do I detect publications that are not related to NHPs?",
           class = "faq_head",
           actionButton(inputId = "faq3_button",
                        label = "",
                        icon = icon("chevron-down"))),
        hidden(
          div(class = "faq", id = "faq3_answer",
              includeHTML("www/FAQ-3.html")
          )
        ),

        h4("How can I combine an NHP filter with a topic search?",
           class = "faq_head",
           actionButton(inputId = "faq4_button",
                        label = "",
                        icon = icon("chevron-down"))),
        hidden(
          div(class = "faq", id = "faq4_answer",
              includeHTML("www/FAQ-4.html")
          )
        ),

        h4("More resources for searching PubMed, PsycINFO (via EBSCOhost), and Web of Science",
           class = "faq_head",
           actionButton(inputId = "faq5_button",
                        label = "",
                        icon = icon("chevron-down"))),
        hidden(
          div(class = "faq", id = "faq5_answer",
              includeHTML("www/FAQ-5.html")
          )
        )
      ),

# revision history --------------------------------------------------------

      tabPanel(
        title = "Version History",
        div(id = "version_history",
            includeHTML("www/version-history.html")
        )
      )
    )
  )


# server ------------------------------------------------------------------


server <- function(input, output, session) {

  # Add clipboard button so it is visible on launch, copy blank
  output$clip <- renderUI({
    rclipButton(inputId = "clip_button", label = "Copy",
                clipText = "",
                icon("clipboard"))
  })

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
                      omit = NULL,
                      source = "PubMed")

  # update clipboard when changing taxa
  observeEvent(input$create, {

    if (length(input$include_text) > 0){
      v$taxa <- input$include_text
    }
    if (length(c(input$include_text, input$omit_text)) == 0){
      v$taxa <- input$all_nhp_input
    }
    if (length(input$omit_text) > 0){
      v$omit <- input$omit_text
    }
    if (length(input$omit_text) == 0 & length(input$include_text) > 0){
      v$taxa <- input$include_text
      v$omit <- input$omit_text
    }

    v$source <- input$source_input

    # create search filter to copy
    res <-
      filter_nhp(source = input$source_input,
                 taxa = v$taxa,
                 omit = v$omit,
                 simplify = FALSE)

    # copy search filter to clipboard
    output$clip <- renderUI({
      rclipButton(inputId = "clip_button", label = "Copy",
                  clipText = res,
                  icon("clipboard"))
    })
  })

  # update clipboard when changing source
  observeEvent(input$source_input, {

    if (length(input$include_text) > 0){
      v$taxa <- input$include_text
    }
    if (length(c(input$include_text, input$omit_text)) == 0){
      v$taxa <- input$all_nhp_input
    }
    if (length(input$omit_text) > 0){
      v$omit <- input$omit_text
    }
    if (length(input$omit_text) == 0 & length(input$include_text) > 0){
      v$taxa <- input$include_text
      v$omit <- input$omit_text
    }

    v$source <- input$source_input

    # create search filter to copy
    res <-
      filter_nhp(source = input$source_input,
                 taxa = v$taxa,
                 omit = v$omit,
                 simplify = FALSE)

    # copy search filter to clipboard
    output$clip <- renderUI({
      rclipButton(inputId = "clip_button", label = "Copy",
                  clipText = res,
                  icon("clipboard"))
    })
  })

  # print search filter to screen
  output$search_filter <-
    renderPrint(
      filter_nhp(
        source = input$source_input,
        taxa = v$taxa,
        omit = v$omit
      )
    )

  # clear text boxes and search filter
  observeEvent(input$clear_button, {
    updateTextInput(session,
                    inputId = "include_text",
                    value = "")
    updateTextInput(session,
                    inputId = "omit_text",
                    value = "")
    v$taxa <- NULL
    v$omit <- NULL

    # clear clipboard
    output$clip <- renderUI({
      rclipButton(inputId = "clip_button", label = "Copy",
                  clipText = " ",
                  icon("clipboard"))
    })
  })

  # hide/show primate table and FAQ after clicking button
  # toggle icon arrows for show/hide
  observeEvent(input$table_button, {
    toggle('primate_order_div')
    if(input$table_button %% 2 == 1){
      updateActionButton(session,
                         inputId = "table_button",
                         icon = icon("chevron-down"))
    }else{
      updateActionButton(session,
                         inputId = "table_button",
                         icon = icon("chevron-up"))
    }
  })
  observeEvent(input$faq1_button, {
    toggle('faq1_answer')
    if(input$faq1_button %% 2 == 1){
      updateActionButton(session,
                         inputId = "faq1_button",
                         icon = icon("chevron-up"))
    }else{
      updateActionButton(session,
                         inputId = "faq1_button",
                         icon = icon("chevron-down"))
    }
  })
  observeEvent(input$faq2_button, {
    toggle('faq2_answer')
    if(input$faq2_button %% 2 == 1){
      updateActionButton(session,
                         inputId = "faq2_button",
                         icon = icon("chevron-up"))
    }else{
      updateActionButton(session,
                         inputId = "faq2_button",
                         icon = icon("chevron-down"))
    }
  })
  observeEvent(input$faq3_button, {
    toggle('faq3_answer')
    if(input$faq3_button %% 2 == 1){
      updateActionButton(session,
                         inputId = "faq3_button",
                         icon = icon("chevron-up"))
    }else{
      updateActionButton(session,
                         inputId = "faq3_button",
                         icon = icon("chevron-down"))
    }
  })
  observeEvent(input$faq4_button, {
    toggle('faq4_answer')
    if(input$faq4_button %% 2 == 1){
      updateActionButton(session,
                         inputId = "faq4_button",
                         icon = icon("chevron-up"))
    }else{
      updateActionButton(session,
                         inputId = "faq4_button",
                         icon = icon("chevron-down"))
    }
  })
  observeEvent(input$faq5_button, {
    toggle('faq5_answer')
    if(input$faq5_button %% 2 == 1){
      updateActionButton(session,
                         inputId = "faq5_button",
                         icon = icon("chevron-up"))
    }else{
      updateActionButton(session,
                         inputId = "faq5_button",
                         icon = icon("chevron-down"))
    }
  })
}

# Run the application
shinyApp(ui = ui, server = server)
