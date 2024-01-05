box::use(
  dplyr[group_by,mutate_at,vars,funs,lag],tidyverse,metools[pct_change],
  bs4Dash,
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
    tags$h1("Dashboard DIOBS - Esgotamento sanitário"),
    tags$p("-------"),
    
    bs4Dash$box(
      title = "População urbana com esgotamento sanitário x abastecimento de água",
      width = 12,
      maximizable = TRUE,
      echarts4rOutput(ns("plot"))
    ),
    
    bs4Dash$box(
      title="População urbana com esgotamento sanitário x abastecimento de água",
    width = 12,
    maximizable = TRUE,
    echarts4rOutput(ns("plot1"))
    ),

    bs4Dash$box(
      title="Volume de esgotos coletado x faturado por ano",
      width = 12,
      maximizable = TRUE,
      echarts4rOutput(ns("plot2"))
    ),
    
    bs4Dash$box(
      title="Variação % do Volume de esgotos coletado e faturado por ano",
      width = 12,
      maximizable = TRUE,
      echarts4rOutput(ns("plot3"))
    ),
    
    
)
}


#ler arquivo de dados em formato xlsx e armazenar no dataset dados1

dados = read_xlsx("app/view/esgoto2.xlsx")   
ibge = read_xlsx("app/view/ibge.xlsx")

dadosnovos= read_xlsx("app/view/dadosSNIS.xlsx")


# df1 <- dados[,c("Ano de Referência","G06A - População urbana residente do(s) município(s) com abastecimento de água",
#                 "G06B - População urbana residente do(s) município(s) com esgotamento sanitário",
#                 "G12A - População total residente do(s) município(s) com abastecimento de água, segundo o IBGE",
#                 "G12B - População total residente do(s) município(s) com esgotamento sanitário, segundo o IBGE")]

df1 <- dadosnovos[,c("Ano de Referência","AG001 - População total atendida com abastecimento de água",
                "ES001 - População total atendida com esgotamento sanitário")]



colnames(df1) <- c('ano','abastecimento','esgoto')

df1<- df1 |>
     mutate(abastecimento =parse_number(abastecimento,locale = locale(decimal_mark = ",", grouping_mark = ".")))
df1<- df1 |>
  mutate(esgoto =parse_number(esgoto,locale = locale(decimal_mark = ",", grouping_mark = ".")))

df2<- ibge[,c("Ano de Referência","POP_URB - População urbana do município (Fonte: IBGE)",
                "IN056_AE - Índice de atendimento total de esgoto referido aos municípios atendidos com água",
                "ES026 - População urbana atendida com esgotamento sanitário")]


colnames(df2) <- c('ano','popurb','indesgoto','popesgoto')

# df2<- df2 |>
#   mutate(popurb =parse_number(popurb,locale = locale(decimal_mark = ",", grouping_mark = ".")))
# df2<- df2 |>
#   mutate(popesgoto =parse_number(popesgoto,locale = locale(decimal_mark = ",", grouping_mark = ".")))
# df2<- df2 |>
#   mutate(indesgoto =parse_number(indesgoto,locale = locale(decimal_mark = ",", grouping_mark = ".")))


df3 <- ibge[,c("Ano de Referência",
                "POP_URB - População urbana do município (Fonte: IBGE)",
                "ES005 - Volume de esgotos coletado",
                "ES007 - Volume de esgotos faturado",
                "ES004 - Extensão da rede de esgotos")]

colnames(df3) <-c('ano','popurb','volcol','volfat','extensao')
df4<-df3
df4["varvolcol"]<-100*(df4$volcol - lag(df4$volcol))/df4$volcol
df4["varvolfat"]<-100*(df4$volfat - lag(df4$volfat))/df4$volfat

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
 output$plot <- renderEcharts4r({
   df1 |>
      mutate(ano=as.character(ano))  |>
      arrange(df1)|>
      e_charts(ano)  |> # initialise and set x
      #e_line(consumido, smooth = TRUE)  %>%  # add a line
      
      #e_line(faturado, y_index = 1) |>  # add secondary axis
      e_bar(abastecimento, legend = TRUE, name = "abastecimento") |>
      e_bar(esgoto,legend = TRUE, name = "esgoto") |>
      e_axis_labels(x='ano') |>
      e_tooltip()|>
      #e_title("População urbana com esgotamento sanitário x abastecimento de água") |>
      e_y_axis(splitLine = list(show = TRUE)) |>
      e_x_axis(show = TRUE) |>
     e_toolbox_feature("restore") |>
     e_toolbox_feature("dataZoom")|>
     e_toolbox_feature("dataView")|>
     e_toolbox_feature( feature="magicType", type=list("line","bar","stack"))|> 
     e_toolbox_feature(
        feature = "saveAsImage",
        title = "Salvar imagem")})
 
 output$plot1 <- renderEcharts4r({
   df2 |>
     mutate(ano=as.character(ano))  |>
     arrange(df2)|>
     e_charts(ano)  |> # initialise and set x
     #e_line(consumido, smooth = TRUE)  %>%  # add a line
     
     e_line(indesgoto, y_index = 1) |>  # add secondary axis
     e_bar(popurb, legend = TRUE, name = "abastecimento") |>
     e_bar(popesgoto,legend = TRUE, name = "esgoto") |>
     e_axis_labels(x='ano') |>
     e_tooltip()|>
     #e_title("População urbana com esgotamento sanitário x abastecimento de água") |>
     e_y_axis(splitLine = list(show = TRUE)) |>
     e_x_axis(show = TRUE) |>
     e_toolbox_feature("restore") |>
     e_toolbox_feature("dataZoom")|>
     e_toolbox_feature("dataView")|>
     e_toolbox_feature( feature="magicType", type=list("line","bar","stack"))|>
     e_toolbox_feature(
       feature = "saveAsImage",
       title = "Salvar imagem")})
    
 
 output$plot2 <- renderEcharts4r({
   df3 |>
     mutate(ano=as.character(ano))  |>
     arrange(df3)|>
     e_charts(ano)  |> # initialise and set x
     #e_line(consumido, smooth = TRUE)  %>%  # add a line
     #e_line(indesgoto, y_index = 1) |>  # add secondary axis
     e_bar(volcol, legend = TRUE, name = "Volume Coletado") |>
     e_bar(volfat,legend = TRUE, name = "Volume Faturado") |>
     e_axis_labels(x='ano') |>
     e_tooltip()|>
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
   df4 |>
     mutate(ano=as.character(ano))  |>
     arrange(df4)|>
     e_charts(ano)  |> # initialise and set x
     #e_line(consumido, smooth = TRUE)  %>%  # add a line
     #e_line(indesgoto, y_index = 1) |>  # add secondary axis
     e_bar(varvolcol, legend = TRUE, name = "variação percentual do Volume Coletado") |>
     e_bar(varvolfat,legend = TRUE, name = "variação percentual do Volume Faturado") |>
     e_axis_labels(x='ano') |>
     e_tooltip()|>
     #e_title("variação percentual do Volume de esgotos coletado e do faturado por ano") |>
     e_y_axis(splitLine = list(show = TRUE)) |>
     e_x_axis(show = TRUE) |>
     e_toolbox_feature("restore") |>
     e_toolbox_feature("dataZoom")|>
     e_toolbox_feature("dataView")|>
     e_toolbox_feature( feature="magicType", type=list("line","bar","stack"))|>
     e_toolbox_feature(
       feature = "saveAsImage",
       title = "Salvar imagem")})
 
 
  })    
}


