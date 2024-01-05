box::use(
  bs4Dash,
  graphics,
  shiny,
  shinyjs,
  stats
)

box::use(
  view/inicio,
  view/incineradores,
  #view/esgoto,
  view/metodologia,
  view/sobre
)


#' @export
server <- function(input, output) {
  
  set.seed(122)
  histdata <- stats$rnorm(500)

  output$plot1 <- shiny$renderPlot({
    data <- histdata[seq_len(input$slider)]
    graphics$hist(data)
  })

  # Fix navbar dark/light mode behaviour
  shiny$observeEvent(input$dark_mode, {
    if (input$dark_mode) {
      shinyjs$runjs("$('.main-header').toggleClass('navbar-light navbar-white');")
      shinyjs$runjs("$('.main-header').toggleClass('navbar-dark');")
    }
  })

  shiny$observeEvent(input$btn_sobre, {
      shiny$showModal(
        shiny$modalDialog(
          title = "Sobre o Dashboard",
          size = 'l',
          fade = TRUE,
          easyClose = TRUE,
          footer = shiny$modalButton("Fechar"),
          sobre$ui("sobre")
        )
      )
  })

  inicio$server("inicio")
  incineradores$server("incineradores")
  #esgoto$server("esgoto")
  metodologia$server("metodologia")
  

  
}
