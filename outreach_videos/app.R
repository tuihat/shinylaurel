#Ocean Drilling Movie Database
#started: 1 December 2021
#updated: 13 May 2024
#Laurel Childress; childress@iodp.tamu.edu

###############################################################################
# Search the ocean drilling movie database by expedition and keywords/terms. 
#...Links to video content provided where available.
###############################################################################

#Packages
if(!require(dplyr)){ #check if the package is installed and sourced
  install.packages("dplyr") #if not, install the package
  library(dplyr) #and source the package 
}

if(!require(DT)){ #check if the package is installed and sourced
  install.packages("DT") #if not, install the package
  library(DT) #and source the package 
}

if(!require(shiny)){ #check if the package is installed and sourced
  install.packages("shiny") #if not, install the package
  library(shiny) #and source the package
}

if(!require(shinyjs)){ #check if the package is installed and sourced
  install.packages("shinyjs") #if not, install the package
  library(shinyjs) #and source the package
}

if(!require(shinyWidgets)){ #check if the package is installed and sourced
  install.packages("shinyWidgets") #if not, install the package
  library(shinyWidgets) #and source the package
}

if(!require(rhandsontable)){ #check if the package is installed and sourced
  install.packages("rhandsontable") #if not, install the package
  library(rhandsontable) #and source the package
}

if(!require(shinydashboard)){ #check if the package is installed and sourced
  install.packages("shinydashboard") #if not, install the package
  library(shinydashboard) #and source the package
}

if(!require(shinydashboardPlus)){ #check if the package is installed and sourced
  install.packages("shinydashboardPlus") #if not, install the package
  library(shinydashboardPlus) #and source the package
}
###############################################################################
db <- read.csv("app_outreach_database.csv")

exp_list <- unique(db$Exp.or.Group)
exp_list <- sort(exp_list, decreasing = FALSE)
keywords <- unique(db$Keywords)
keywords <- sort(keywords, decreasing = FALSE)

ui <- dashboardPage(
  title = "JR Outreach Videos", #website title
  header = dashboardHeader(title = "JR Outreach Videos"),
  sidebar = dashboardSidebar(width = "0px"),
  body = dashboardBody(
    fluidRow(
    box(width = 3,
        pickerInput('input1', 'Choose by expedition (or generic type):', choices = exp_list, options = list(`actions-box` = TRUE), multiple = T),
       hr(),
       pickerInput('input2', 'Choose by keyword:', choices = keywords, options = list(`actions-box` = TRUE), multiple = T),
       br(), br(),
       h5("If you identify an error in this database or know of additional video footage please
          contact the JRSO Media liason, http://iodp.tamu.edu/outreach/index.html")),
    box(width = 9,
        h5("Choose an expedition(s) and keyword(s) to search the database."),
        h5("To word search the entire database select all expeditions/generic types and all keywords. Then use the 'Search' function in
           the upper right of the output table."),
        DT::dataTableOutput("results_table"),
        br(),br(), br(),
        downloadButton("download1", "Download results"))),
    br(),
    downloadButton("downloadall", "Download entire database"), br(), br(),
    tags$i("These are not official IODP-JRSO applications and functionality is 
           not guaranteed. User assumes all risk."), #italic disclaimer
    br(),
    tags$i("Questions, comments, concerns, compliments: shinylaurelwebmaster@gmail.com"),
    br(),
    tags$i("This app can be cited by https://doi.org/10.5281/zenodo.10498831"),
    tags$head(tags$style(HTML('
        /* logo */
        .skin-blue .main-header .logo {
                              background-color: #f4b943;width: 400px;
                              }

        /* logo when hovered */
        .skin-blue .main-header .logo:hover {
                              background-color: #f4b943;
                              }

        /* navbar (rest of the header) */
        .skin-blue .main-header .navbar {
                              background-color: #f4b943;margin-left: 400px;
                              }
        /* main sidebar */
        .skin-blue .main-sidebar {
                              background-color: #325669;
                              }
         .box-header{ display: none}'))),
    tags$head(includeHTML(("google_analytics.html"))),
    tags$script("document.getElementsByClassName('sidebar-toggle')[0].style.visibility = 'hidden';")
  )
)

server <- function(input, output, session) {
  ########REACTIVE SEARCHED DATAFRAME#############################################
  chosen_Exp_keyword <- reactive({
    validate(
      need(input$input1 != "", "Please select expedition(s). If no specific expedition is desired, select all."),
      need(input$input2 != "", "Please select keywords(s). If no specific keyword is desired, select all.")
    )
    df1 <- db[db$Exp.or.Group %in% input$input1,]
    df1 <- df1[df1$Keywords %in% input$input2,]
    kwlist <- list()
    for(i in unique(df1$Title)){
      temp <- subset(df1, Title == i)
      all_keywords <- unique(temp$Keywords)
      all_keywords2 <- paste(all_keywords, sep = ', ', collapse = ', ')
      temp2 <- temp[1,]
      temp2$KeywordGroup <- all_keywords2
      kwlist[[i]] <- temp2
    }
    df2 <- do.call("rbind", kwlist)
    df3 <- df2[,c(1,3:10)]
    df3$YouTube.Link <- paste0("<a href='",df3$YouTube.Link,"' target='_blank'>",df3$YouTube.Link,"</a>")
    df4 <- df3[,c(8,1,4,5,2,3,6,7,9)]
    names(df4)[1] <- "Exp or Generic Type"
    names(df4)[3] <- "Duration (hh:mm:ss)"
    names(df4)[4] <- "Special/Other video elements"
    names(df4)[7] <- "YouTube Link"
    names(df4)[8] <- "YouTube Channel"
    names(df4)[9] <- "List of Keywords"
    df4 <- df4[with(df4, order(`Exp or Generic Type`, Title)),]
  })
  
  ########RENDER SEARCH TABLE####################################################
  output$results_table <- DT::renderDataTable({
    DT::datatable(chosen_Exp_keyword(), options = list(pageLength = 10, scrollX = TRUE,
                                                       columnDefs = list(list(className = 'dt-center', targets="_all"))), 
                  rownames= FALSE, escape = FALSE)
  })
  ########REACTIVE SEARCHED DATAFRAME - DOWNLOAD VERSION WITHOUT SPECIAL LINK ADDONS####################
  chosen_Exp_keyword2 <- reactive({
    validate(
      need(input$input1 != "", "Please select expedition(s). If no specific expedition is desired, select all."),
      need(input$input2 != "", "Please select keywords(s). If no specific keyword is desired, select all.")
    )
    df1 <- db[db$Exp.or.Group %in% input$input1,]
    df1 <- df1[df1$Keywords %in% input$input2,]
    kwlist <- list()
    for(i in unique(df1$Title)){
      temp <- subset(df1, Title == i)
      all_keywords <- unique(temp$Keywords)
      all_keywords2 <- paste(all_keywords, sep = ', ', collapse = ', ')
      temp2 <- temp[1,]
      temp2$KeywordGroup <- all_keywords2
      kwlist[[i]] <- temp2
    }
    df2 <- do.call("rbind", kwlist)
    df3 <- df2[,c(1,3:10)]
    df4 <- df3[,c(8,1,4,5,2,3,6,7,9)]
    names(df4)[1] <- "Exp or Generic Type"
    names(df4)[3] <- "Duration (hh:mm:ss)"
    names(df4)[4] <- "Special/Other video elements"
    names(df4)[7] <- "YouTube Link"
    names(df4)[8] <- "YouTube Channel"
    names(df4)[9] <- "List of Keywords"
    df4 <- df4[with(df4, order(`Exp or Generic Type`, Title)),]
  })
  # Downloadable csv of searched dataset ----
  output$download1 <- downloadHandler(
    filename = function() {
      paste("searched_moviedb", ".csv", sep = "")
    },
    content = function(file) {
      write.csv(chosen_Exp_keyword2(), file, row.names = FALSE)
    })
  
  # Downloadable csv of the entire dataset -----
  output$downloadall <- downloadHandler(
    filename <- function() {
      paste("IODP-JR_movie_log", "xlsx", sep=".")
    },
    
    content <- function(file) {
      file.copy("IODP-JR_movie_log.xlsx", file)
    })
   
}

shinyApp(ui = ui, server = server)