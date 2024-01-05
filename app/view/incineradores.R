box::use(
  stats[ts, stl, aggregate],
  dplyr[group_by,summarise],  
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
  shiny[
   fluidRow,
    fluidPage,
    moduleServer,
    NS,
    tagList,
    tags,br,sliderInput,textInput
  ],
 readxl[read_xlsx],lubridate,nycflights13,dplyr[mutate,arrange],readr[parse_number,locale],shinydashboard[box,dashboardBody]
)

#' @export
ui <- function(id) {  
  ns <- NS(id)
  fluidPage(
    tags$h1("Dashboard DIOBS - Incineradores"),
  
    
    bs4Dash$box(
      title ="Tendência",
      width = 12,
      maximizable = TRUE,
      echarts4rOutput(ns("plot1"))
    ),
    tags$p("Tendência: Esta parte do gráfico mostra a tendência de longo prazo na quantidade total ao 
    longo do tempo. Se há um aumento ou diminuição constante, isso será visível aqui."),
    
    bs4Dash$box(
      title ="Sazonalidade",
      width = 12,
      maximizable = TRUE,
      echarts4rOutput(ns("plot2"))
    ),
    
    tags$p("Tendência: Esta parte do gráfico mostra a tendência de longo prazo na quantidade total ao 
    longo do tempo. Se há um aumento ou diminuição constante, isso será visível aqui."),
    
    bs4Dash$box(
      title ="Resícuos",
      width = 12,
      maximizable = TRUE,
      echarts4rOutput(ns("plot3"))
    ),
    tags$p("Tendência: Esta parte do gráfico mostra a tendência de longo prazo na quantidade total ao 
    longo do tempo. Se há um aumento ou diminuição constante, isso será visível aqui."),
    
    bs4Dash$box(
      title ="Resícuos",
      width = 12,
      maximizable = TRUE,
      echarts4rOutput(ns("plot4"))
    ),


  )
}


#ler arquivo de dados em formato xlsx e armazenar no dataset 

dados = read_xlsx("app/view/combined_data.xlsx")    
#analisando a coluna data
dados$Data <- as.Date(dados$Data, format = "%Y-%m-%d")
# Agrupando os dados por data e somando as quantidades
daily_data <- aggregate(Quantidade ~ Data, dados, sum)

# # Decompondo a série temporal
decomposition <- stl(ts(daily_data$Quantidade, frequency = 7), s.window = "periodic")
# 
# # Criando um dataframe para os componentes da decomposição
 decomp_df <- data.frame(Data = daily_data$Data,
                         Trend = decomposition$time.series[, "trend"],
                         Seasonal = decomposition$time.series[, "seasonal"],
                         Residual = decomposition$time.series[, "remainder"])

 client_totals <- dados |>
   group_by(Cliente) |>
   summarise(Total = sum(Total))|>
   arrange(desc(Total))



#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {

       output$plot1 <- renderEcharts4r({
           decomp_df|>
              e_charts(Data) |>
              e_line(Trend, name = "Tendência") |>
              e_title("Tendência") |>
              e_x_axis(type = "time") |>
             e_tooltip(trigger = "axis") 
         })
       
       output$plot2 <- renderEcharts4r({
         decomp_df|>
           e_charts(Data) |>
           e_line(Seasonal, name = "Sazonalidade") |>
           e_title("Sazonalidade") |>
           e_x_axis(type = "time") |>
           e_tooltip(trigger = "axis") 
       })
       
       output$plot3 <- renderEcharts4r({
         decomp_df|>
           e_charts(Data) |>
           e_line(Residual, name = "Residual") |>
           e_title("Residual") |>
           e_x_axis(type = "time") |>
           e_tooltip(trigger = "axis") 
       })
      
       output$plot4 <- renderEcharts4r({
         client_totals |>
           e_charts(Cliente) |>
           e_bar(Total) |>
           e_title("Total Revenue by Client") |>
           e_x_axis(name = "Total Revenue") |>
           e_y_axis(name = "Client", axisLabel = list(rotate = -30)) |>
           e_tooltip(trigger = "axis", axisPointer = list(type = "shadow"))
           #e_grid(left = '3%', right = '4%', bottom = '3%', containLabel = TRUE)
         
       })       
      
  
      })    
}





