box::use(
  bs4Dash,  
  shiny[
    br,
    column,
    hr,
    p,
    h4,
    h5,
    tabPanel,
    fluidPage,
    tagList,
    tags,
    moduleServer,
    NS
  ],
  randomNames
)



#' @export
ui <- function(id) {  
  ns <- NS(id)
  
  fluidPage(
    tags$h1("Metodologia"),
    tags$p(" "),
    tags$p("O Governo Federal administra o Sistema Nacional de Informações sobre Saneamento - SNIS no âmbito da Secretaria Nacional de Saneamento (SNS) do Ministério do Desenvolvimento Regional.
"),
    tags$p("O SNIS se constitui no maior e mais importante sistema de informações do setor saneamento no Brasil, apoiando-se em um banco de dados que contém informações de caráter institucional, administrativo, operacional, gerencial, econômico-financeiro, contábil e de qualidade sobre a prestação de serviços de água, de esgotos e de manejo de resíduos sólidos urbanos. "),
    tags$p("Dentre os objetivos do SNIS destacam-se: (i) planejamento e execução de políticas públicas; (ii) orientação da aplicação de recursos; (iii) conhecimento e avaliação do setor saneamento; (iv) avaliação de desempenho dos serviços; (v) aperfeiçoamento da gestão; (vi) orientação de atividades regulatórias e de fiscalização; e (vii) exercício do controle social. Além disso, a consolidação do SNIS, desde 1995, permite a utilização dos seus indicadores como referência para comparação e como guia para medição de desempenho da prestação de serviços. "),
    tags$p("O SNIS atualmente está dividido em dois componentes: água e esgotos (SNIS-AE) e resíduos sólidos (SNIS-RS). As informações do SNIS são coletadas anualmente e provêm de prestadores de serviços ou órgãos municipais encarregados da gestão dos serviços, sendo a base de dados totalmente pública e disponibilizada gratuitamente no sítio www.snis.gov.br. "),
    tags$p("A metodologia do SNIS considera uma tipologia de prestadores de serviços apoiada em três características básicas:
 "),
    tags$p("a) a abrangência da sua atuação (diferenciando os prestadores pela quantidade e complexidade dos sistemas de provimento dos serviços, tanto os sistemas físicos como os político/institucionais e os espaciais/geográficos);
b) a natureza jurídico-administrativa (diferenciando os prestadores do ponto de vista da formalidade legal e administrativa a que estão submetidos em todas as dimensões da sua atuação); e
c) os tipos de serviços de saneamento que são oferecidos aos usuários (água, água e esgotos, esgotos, resíduos sólidos urbanos)."),
    tags$p("Link de acesso: http://app4.mdr.gov.br/serieHistorica/ "),
    tags$p("Data de acesso: 12/12/2022"),
    tags$p("*Os dados foram coletados, através da Opção Água e Esgoto, em seguida selecionamos a opção Informações e indicadores agregados:
Essa busca tem como base os dados agregados dos prestadores de serviços. Permite filtrar por Ano de referência, Abrangência, Tipo de serviço, Natureza jurídica, Região, Estado, Prestador de serviço, Família de informações e indicadores e Informações e Indicadores propriamente ditos."),
    tags$p("O portal gerou um arquivo de dados que foi tratado em nosso dashboard, utilizando-se o R.
"),
    
  )
  
}


#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    print("Iniciando servidor do módulo 'sobre'")
  })
}
