box::use(
  base,
  dplyr[group_by],  
  bs4Dash,
  echarts4r[
    e_color,
    e_charts,
    e_title,
    e_line,
    e_bar,
    e_toolbox_feature,
    e_x_axis,
    e_axis_labels,
    e_y_axis,
    echarts4rOutput,
    e_tooltip,
    renderEcharts4r],
  shiny,
 readxl,lubridate,dplyr[mutate,arrange],readr[parse_number,locale],shinydashboard[box,dashboardBody]
)

#' @export
ui <- function(id) {  
  ns <- NS(id)
  # fluidPage(
  #   tags$h1("Dashboard DIOBS - Incineradoes"),
  # 
  #     bs4Dash$box(
  #     title ="teste",
  #     width = 12,
  #     maximizable = TRUE,
  #     echarts4rOutput(ns("plot"))
  #   )
  #   # tags$p("xxxxx"),
  #   #
  #   # tags$p("yyyyyyyy")
  #   #
  # 
  # )
}


#ler arquivo de dados em formato xlsx e armazenar no dataset dados1

dados = read_xlsx("app/view/combined_data.xlsx")    
#analisando a coluna data
#dados$Data <- as.Date(dados$Data, format = "%Y-%m-%d")
# Agrupando os dados por data e somando as quantidades
#daily_data <- stats::aggregate(Quantidade ~ Data, dados, sum)

# # Decompondo a série temporal
# decomposition <- stl(ts(daily_data$Quantidade, frequency = 7), s.window = "periodic")
# 
# # Criando um dataframe para os componentes da decomposição
# decomp_df <- data.frame(Data = daily_data$Data,
#                         Trend = decomposition$time.series[, "trend"],
#                         Seasonal = decomposition$time.series[, "seasonal"],
#                         Residual = decomposition$time.series[, "remainder"])


#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
      
 # output$plot <- renderEcharts4r({
 #      decomp_df|>
 #        e_charts(Data) |>
 #        e_line(Trend, name = "Tendência") |>
 #        e_title("Tendência") |>
 #        e_x_axis(type = "time") |>
 #        e_tooltip(trigger = "axis") 
 #    })
      })    
}





