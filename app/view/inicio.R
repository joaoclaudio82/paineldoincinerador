box::use(
  dplyr[group_by],
  echarts4r[
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
    fluidPage,
    moduleServer,
    NS,
    tagList,
    tags
  ],
 readxl[read_xlsx],lubridate,nycflights13,dplyr[mutate,arrange],readr[parse_number,locale]
)

#' @export
ui <- function(id) {  
  ns <- NS(id)

  fluidPage(
    tags$h1("Dashboard DIOBS - Incineradores"),
    tags$p(" "),
    tags$p("O saneamento básico é um direito garantido pela Constituição com o objetivo de proporcionar salubridade ambiental e desenvolvimento socioeconômicas De forma simplificada, a cadeia do saneamento tem início na captação em reservatórios de água, onde acontece o tratamento e distribuição aos pontos de consumo, sejam eles residenciais ou industriais."),
    tags$p("Em nossos dashboards aqui, apresentamos os dados de abastecimento de água e coleta de esgoto para a cidade de Fortaleza, desde o ano de 2003 até o ano de 2020. "),
    
    #tags$img(src='app/view/imagem.jpg'),
    
  )
  
}


#ler arquivo de dados em formato xlsx e armazenar no dataset dados1

dados1 = read_xlsx("app/view/agua.xlsx")     


agua<- dados1[,c("Ano de Referência","AG006 - Volume de água produzido", "AG015 - Volume de água tratada por simples desinfecção")]
colnames(agua) <- c('ano','produzido','tratado')
agua<- agua |>
  mutate(produzido =parse_number(produzido,locale = locale(decimal_mark = ",", grouping_mark = ".")))

agua<- agua |>
  mutate(tratado =parse_number(tratado,locale = locale(decimal_mark = ",", grouping_mark = "."))) 







#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
  output$plot <- renderEcharts4r({
   agua |>
      mutate(ano=as.character(ano))  |>
      arrange(agua)|>
      e_charts(ano)  |> # initialise and set x
      #e_line(consumido, smooth = TRUE)  %>%  # add a line
      
      #e_line(faturado, y_index = 1) |>  # add secondary axis
      e_bar(produzido, legend = TRUE, name = "produzido") |>
      e_bar(tratado,legend = TRUE, name = "tratado") |>
      e_axis_labels(x='ano') |>
      e_tooltip()|>
      e_title("volume por ano") |>
      e_y_axis(splitLine = list(show = TRUE)) |>
      e_x_axis(show = TRUE) |>
      e_toolbox_feature("restore") |>
      e_toolbox_feature("dataZoom")|>
      e_toolbox_feature("dataView")|>
      e_toolbox_feature( feature="magicType", type=list("line","bar","stack"))|>
       e_toolbox_feature(
        feature = "saveAsImage",
        title = "Salvar imagem"
      ) }
    )
    })    
}


