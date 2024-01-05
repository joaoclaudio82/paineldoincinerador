box::use(
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
      title ="Volume de água tratada x volume de água produzido",
      width = 12,
      maximizable = TRUE,
      echarts4rOutput(ns("plot"))
    ),
    tags$p("Volume de água produzido: Volume anual de água disponível para consumo, compreendendo a água captada pelo prestador de serviços e a água bruta importada, ambas tratadas na(s) unidade(s) de tratamento do prestador de serviços, medido ou estimado na(s) saída(s) da(s) ETA(s) ou UTS(s). Inclui também os volumes de água captada pelo prestador de serviços ou de água bruta importada, que sejam disponibilizados para consumo sem tratamento, medidos na(s) respectiva(s) entrada(s) do sistema de distribuição.
"),
    tags$p("Volume de água tratada:Volume anual de água captada de manancial subterrâneo ou fonte de cabeceira, ou de água bruta importada, que apresenta naturalmente características físicas, químicas e organolépticas que a qualificam como água potável e, por isto, é submetida apenas a simples desinfecção, medido ou estimado na(s) saída(s) da(s) UTS(s). Deve estar computado no volume de água produzido. Não inclui o volume de água tratada em ETA(s)e nem o volume de água tratada importada."),
 
    
    bs4Dash$box(
      title ="Quantidade de ligações totais x população atendida",
      width = 12,
      maximizable = TRUE,
      echarts4rOutput(ns("plot2"))
    ),
  tags$p("Quantidade de ligações totais: Quantidade de ligações totais (ativas e inativas) de água à rede pública, providas ou não de hidrômetro, existente no último dia do ano de referência."),
  tags$p("População atendida: Valor da população total atendida com abastecimento de água pelo prestador de serviços, no último dia do ano de referência."),

   bs4Dash$box(
     title ="Extensão da rede de água x população atendida",
     width = 12,
     maximizable = TRUE,
   echarts4rOutput(ns("plot3"))
   ),
   tags$p("Extensão da rede: Comprimento total da malha de distribuição de água, incluindo adutoras, subadutoras e redes distribuidoras e excluindo ramais prediais, operada pelo prestador de serviços, no último dia do ano de referência"),
   tags$p("População atendida: Valor da população total atendida com abastecimento de água pelo prestador de serviços, no último dia do ano de referência."),

   bs4Dash$box(
     title ="Extensão da rede de água x ano",
     width = 12,
    maximizable = TRUE,
     echarts4rOutput(ns("plot4"))
       ),
   tags$p("Extensão da rede de água: Comprimento total da malha de distribuição de água, incluindo adutoras, subadutoras e redes distribuidoras e excluindo ramais prediais, operada pelo prestador de serviços, no último dia do ano de referência"),

   bs4Dash$box(
     title ="Volume de água produzido, consumido e que sobra",
   width = 12,
   maximizable = TRUE,
   echarts4rOutput(ns("plot5"))
   ),

   tags$p("Volume de água produzido: Volume anual de água disponível para consumo, compreendendo a água captada pelo prestador de serviços e a água bruta importada, ambas tratadas na(s) unidade(s) de tratamento do prestador de serviços, medido ou estimado na(s) saída(s) da(s) ETA(s) ou UTS(s). Inclui também os volumes de água captada pelo prestador de serviços ou de água bruta importada, que sejam disponibilizados para consumo sem tratamento, medidos na(s) respectiva(s) entrada(s) do sistema de distribuição.
 "),
     tags$p("Volume de água consumido: Volume anual de água consumido por todos os usuários, compreendendo o volume micromedido, o volume de consumo estimado para as ligações desprovidas de hidrômetro ou com hidrômetro parado, acrescido do volume de água tratada exportado para outro prestador de serviços."),

   bs4Dash$box(
     title ="População total atendida com abastecimento de água x esgoto",
   width = 12,
   maximizable = TRUE,
   echarts4rOutput(ns("plot6"))
  ),

   tags$p("População atendida com abastecimento de água: Valor da população total atendida com abastecimento de água pelo prestador de serviços, no último dia do ano de referência."),
   tags$p("População atendida com esgoto: Valor da população total atendida com esgoto pelo prestador de serviços, no último dia do ano de referência.")

  )
}


#ler arquivo de dados em formato xlsx e armazenar no dataset dados1

dados1 = read_xlsx("app/view/agua.xlsx")    
agua1<- dados1[,c("Ano de Referência","AG006 - Volume de água produzido", "AG015 - Volume de água tratada por simples desinfecção")]
colnames(agua1) <- c('ano','produzido','tratado')
agua1<- agua1 |>
  mutate(produzido =parse_number(produzido,locale = locale(decimal_mark = ",", grouping_mark = ".")))

agua1<- agua1 |>
  mutate(tratado =parse_number(tratado,locale = locale(decimal_mark = ",", grouping_mark = "."))) 

ibge = read_xlsx("app/view/ibge.xlsx") 
abastecimento<- ibge[,c('Ano de Referência','AG001 - População total atendida com abastecimento de água',
                        'AG005 - Extensão da rede de água','AG021 - Quantidade de ligações totais de água','AG006 - Volume de água produzido',
                        'AG010 - Volume de água consumido','AG015 - Volume de água tratada por simples desinfecção',"ES001 - População total atendida com esgotamento sanitário")]
colnames(abastecimento) <- c('ano','populacao','rede','ligacoes','produzido','consumido','desinfeccao','atendida')

abastecimento["sobra"]<-abastecimento$produzido - abastecimento$consumido



rede <-abastecimento
rede2 <-abastecimento
rede3 <-abastecimento
rede4 <-abastecimento
rede5 <-abastecimento
#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
      output$plot <- renderEcharts4r({
      agua1 |>
      mutate(ano=as.character(ano))  |>
      arrange(agua1)|>
      e_charts(ano)  |> # initialise and set x
      #e_line(consumido, smooth = TRUE)  |>  # add a line
      #e_line(faturado, y_index = 1) |>  # add secondary axis
      e_bar(produzido, legend = TRUE, name = "produzido") |>
      e_bar(tratado,legend = TRUE, name = "tratado") |>
      e_color(c("blueviolet", "brown"))|> 
      e_axis_labels(x='ano') |>
      e_tooltip()|>
      #e_title("volume por ano") |>
      e_y_axis(splitLine = list(show = TRUE)) |>
      e_x_axis(show = TRUE) |>
          e_toolbox_feature("restore") |>
          e_toolbox_feature("dataZoom")|>
          e_toolbox_feature("dataView")|>
          e_toolbox_feature( feature="magicType", type=list("line","bar","stack"))|>
          e_toolbox_feature(
            feature = "saveAsImage",
            title = "Salvar imagem" )})
     
      output$plot2 <- renderEcharts4r({
        abastecimento |>
          mutate(ano=as.character(ano)) |> 
          arrange(abastecimento)|>
          e_charts(ano) |> # initialise and set x
          e_line(ligacoes, smooth = TRUE) |>  # add a line
          #e_line(faturado, y_index = 1)|>  # add secondary axis
          #e_bar(ligace, legend = TRUE, name = "produzido") |>
          e_bar(populacao,legend = TRUE, name = "populacao", y_index = 2) |> # add a bar
          e_color(c("red", "green"))|> 
          e_axis_labels(x='ano') |>
          e_tooltip()|> 
          #e_title("Ligações totais de água x População atendida")|>
          e_y_axis(splitLine = list(show = TRUE)) |>
          e_x_axis(show = TRUE) |>
          e_toolbox_feature("restore") |>
          e_toolbox_feature("dataZoom")|>
          e_toolbox_feature("dataView")|>
          e_toolbox_feature( feature="magicType", type=list("line","bar","stack"))|>
          e_toolbox_feature(
            feature = "saveAsImage",
            title = "Salvar imagem")})
      
      
      output$plot3 <- renderEcharts4r({
        rede   |>
          mutate(ano=as.character(ano))  |> 
          arrange(rede) |>
          e_charts(ano)   |> # initialise and set x
          e_line(rede, name = "rede", smooth = TRUE)   |>  # add a line
          
          #e_line(faturado, y_index = 1) |>  # add secondary axis
          #e_bar(ligace, legend = TRUE, name = "produzido") |> 
          e_bar(populacao,legend = TRUE, name = "populacao", y_index = 2)   |>  # add a bar
          e_color(c("blue", "green"))|> 
          e_axis_labels(x='ano')  |>
          e_tooltip() |>
          #e_title("Extensão da rede de água x população atendida") |>
          e_y_axis(splitLine = list(show = TRUE)) |>
          e_x_axis(show = TRUE)  |>
          e_toolbox_feature("restore") |>
          e_toolbox_feature("dataZoom")|>
          e_toolbox_feature("dataView")|>
          e_toolbox_feature( feature="magicType", type=list("line","bar","stack"))|>
          e_toolbox_feature(
            feature = "saveAsImage",
            title = "Salvar imagem")})
      
      output$plot4 <- renderEcharts4r({
        rede2 |>
          mutate(ano=as.character(ano)) |>
          arrange(rede2)|> 
          e_charts(ano)  |> # initialise and set x
          e_line(rede, name = "rede", smooth = TRUE) |>  # add a line
          
          #e_line(faturado, y_index = 1) |>  # add secondary axis
          #e_bar(ligace, legend = TRUE, name = "produzido") |>
          #e_bar(populacao,legend = TRUE, name = "populacao", y_index = 2) |>  # add a bar
          e_color(c("blue"))|> 
          e_axis_labels(x='ano') |>
          e_tooltip()|> 
          #e_title("Extensão da rede de água x ano") |>
          e_y_axis(splitLine = list(show = TRUE)) |>
          e_x_axis(show = TRUE) |>
          e_toolbox_feature("restore") |>
          e_toolbox_feature("dataZoom")|>
          e_toolbox_feature("dataView")|>
          e_toolbox_feature( feature="magicType", type=list("line","bar","stack"))|>
          e_toolbox_feature(
            feature = "saveAsImage",
            title = "Salvar imagem" )})
      
      # output$plot5 <- renderEcharts4r({
      #   rede3  |>
      #     mutate(ano=as.character(ano))  |> 
      #     arrange(rede3)|> 
      #     e_charts(ano)  |> # initialise and set x
      #     e_line(ligacoes, name = "ligacoes", smooth = TRUE)  |>  # add a line
      #     #e_line(faturado, y_index = 1) |>  # add secondary axis
      #     #e_bar(ligace, legend = TRUE, name = "produzido") |> 
      #     e_bar(populacao,legend = TRUE, name = "populacao")  |>  # add a bar
      #     e_axis_labels(x='ano') |> 
      #     e_tooltip()|> 
      #     e_title("Extensão da rede de água x ano") |> 
      #     e_y_axis(splitLine = list(show = TRUE)) |> 
      #     e_x_axis(show = TRUE) |> 
      #     e_toolbox_feature(
      #       feature = "saveAsImage",
      #       title = "Salvar imagem" )})
  
      output$plot5 <- renderEcharts4r({
        rede4  |>
          mutate(ano=as.character(ano))  |> 
          arrange(rede4)|> 
          e_charts(ano)  |> # initialise and set x
          #e_line(rede, name = "rede", smooth = TRUE)  |>  # add a line
          #e_line(faturado, y_index = 1) |>  # add secondary axis
          e_bar(consumido, legend = TRUE, name = "consumido") |> 
          e_bar(produzido,legend = TRUE, name = "produzido")  |>  # add a bar
          e_bar(sobra,legend = TRUE, name = "sobra")  |>
          e_color(c("red", "blue","green"))|> 
          e_axis_labels(x='ano') |> 
          e_tooltip()|> 
          #e_title("Extensão da rede de água x ano") |> 
          e_y_axis(splitLine = list(show = TRUE)) |> 
          e_x_axis(show = TRUE) |> 
          e_toolbox_feature("restore") |>
          e_toolbox_feature("dataZoom")|>
          e_toolbox_feature("dataView")|>
          e_toolbox_feature( feature="magicType", type=list("line","bar","stack"))|>
          e_toolbox_feature(
            feature = "saveAsImage",
            title = "Salvar imagemm" )})

  output$plot6 <- renderEcharts4r({
  rede5  |>
    mutate(ano=as.character(ano))  |> 
    arrange(rede5)|> 
    e_charts(ano)  |> # initialise and set x
    #e_line(rede, name = "rede", smooth = TRUE)  |>  # add a line
    #e_line(faturado, y_index = 1) |>  # add secondary axis
    e_bar(populacao, legend = TRUE, name = "consumido") |> 
    e_bar(atendida,legend = TRUE, name = "produzido")  |>  # add a bar
    #e_bar(sobra,legend = TRUE, name = "sobra")  |>
    e_color(c("blue","green"))|> 
    e_axis_labels(x='ano') |> 
    e_tooltip()|> 
    #e_title("Extensão da rede de água x ano") |> 
    e_y_axis(splitLine = list(show = TRUE)) |> 
    e_x_axis(show = TRUE) |> 
      e_toolbox_feature("restore") |>
      e_toolbox_feature("dataZoom")|>
      e_toolbox_feature("dataView")|>
      e_toolbox_feature( feature="magicType", type=list("line","bar","stack"))|>
    e_toolbox_feature(
      feature = "saveAsImage",
      title = "Salvar imagemm" )})


      
  
      })    
}





