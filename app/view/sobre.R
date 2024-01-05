box::use(
  shiny[
    NS,
    tagList,
    tags
  ]
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  tagList(
    tags$p("Insira aqui uma breve descrição do dashboard------")
  )
  
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
  })    
}


