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
    fluidRow,
    tagList,
    tags,
    moduleServer,
    NS
  ],
  randomNames
)

nome_cargo <- function(nome, cargo) {
  tagList(
    h5(class = "mb-0", nome),
    p(cargo)
  )
}

titulo_integrantes <- function(titulo, ...) {
  tagList(
    h5(class = "mb-0", titulo),
    lapply(list(...), function(x) {
      p(class = "mb-0", x)
    }),
    p(class = "mb-2", "")
  )
}

#' @export
ui <- function(id) {
  ns <- NS(id)

  nomes <- randomNames$randomNames(10)
  
  tagList(
    column(
      width = 12,
      bs4Dash$tabBox(
        title = 'Ficha Técnica',
        side = 'right',
        id = 'ficha-tecnica',
        type = 'tabs',
        elevation = 2,
        width = 12,
        maximizable = TRUE,
        selected = 'equipe-tecnica',
        tabPanel(
          title = "Equipe Técnica",
          value = "equipe-tecnica",
          class = "p-2",
          fluidRow(
            class = "align-center justify-content-center text-center mb-3",
            column(
              width = 2,
              titulo_integrantes(
                "Coordenado por",
                nomes[1],
                nomes[2]
              ),
              titulo_integrantes(
                "Edição",
                nomes[1]
              )
            ),
            column(
              width = 2,
              titulo_integrantes(
                "Autores principais",
                nomes[1],
                nomes[3],
                nomes[2]
              )
            ),
            column(
              width = 2,
              titulo_integrantes(
                "Equipe de pesquisa",
                nomes[4],
                nomes[5],
                nomes[6],
                nomes[7]
              ),
              titulo_integrantes(
                "Coordenação de dados",
                nomes[2]
              )
            ),
            column(
              width = 2,
              titulo_integrantes(
                "Análise Estatística",
                nomes[3],
                nomes[9],
                nomes[10]
              ),
              titulo_integrantes(
                "Diagramação",
                nomes[6],
                nomes[8]
              )
            ),
            column(
              width = 2,              
              titulo_integrantes(
                "Revisão",
                nomes[4]
              ),
              titulo_integrantes(
                "Imprensa",
                nomes[6],
                nomes[7]
              )
            ),
            column(
              width = 2,
              titulo_integrantes(
                "Suporte técnico",
                nomes[3],
                nomes[7]
              ),             
              titulo_integrantes(
                "Design",
                nomes[5]
              )
            )
          ),
          fluidRow(
            class = 'align-center justify-content-center text-center mt-2',
            column(
              width = 12,
              h4("Realização"),
              hr(class = "divider mt-1 mb-1")
            )
          ),
          fluidRow(
            class = 'align-center justify-content-center text-center mt-2',
            column(
              width = 12,
              p("Diretoria do Observatório de Governança Municipal"),
              p("Instituto de Planejamento de Fortaleza"),
              p("Prefeitura Municipal de Fortaleza")
            )
          ),
          fluidRow(
            class = "align-center justify-content-center text-center mt-2",
            column(
              width = 12,
              h4("Colaboração"),
              hr(class = "divider mt-1 mb-1")
            )
          ),
          fluidRow(
            class = "align-center justify-content-center text-center mt-2",
            column(
              width = 4,
              p(nomes[5]),
              p(nomes[4]),
              p(nomes[7]),
              p(nomes[2])
            ),
            column(
              width = 4,
              p(nomes[5]),
              p(nomes[9]),
              p(nomes[10]),
              p(nomes[1])
            ),
            column(
              width = 4,
              p(nomes[5]),
              p(nomes[7]),
              p(nomes[3]),
              p(nomes[2])
            )
          )
        ),
        tabPanel(
          title = "Secretariado",
          value = "secretariado",
          fluidRow(
            column(
              width = 12,
              class = "mt-2 text-center",
              h4("José Sarto Nogueira Moreira"),
              p("Prefeito de Fortaleza"),
              br(),
              h4("José Élcio Batista"),
              p("Vice-Prefeito de Fortaleza"),
              hr(class = "divider")
            )
          ),
          fluidRow(
            class = "text-center",
            column(
              width = 4,
              nome_cargo("Renato Carvalho Borges", "Secretário Chefe do Gabinete do Prefeito"),
              nome_cargo("Renato César Pereira Lima", "Secretário Municipal de Governo"),
              nome_cargo("Fernando Antônio Costa De Oliveira", "Procurador Geral do Município"),
              nome_cargo("Maria Christina Machado Publio", "Secretária Chefe da Controladoria e Ouvidoria Geral do Município"),
              nome_cargo("Luis Eduardo Soares de Holanda", "Secretário Municipal da Segurança Cidadã"),
              nome_cargo("Flávia Roberta Bruno Teixeira", "Secretária Municipal das Finanças"),
              nome_cargo("Marcelo Jorge Borges Pinheiro", "Secretário Municipal do Planejamento, Orçamento e Gestão")
            ),
            column(
              width = 4,
              nome_cargo("Antonia Dalila Saldanha de Freitas", "Secretária Municipal da Educação"),
              nome_cargo("Ana Estela Fernandes Leite", "Secretária Municipal da Saúde"),
              nome_cargo("Samuel Antonio Silva Dias", "Secretário Municipal da Infraestrutura"),                            
              nome_cargo("Ferruccio Petri Feitosa", "Secretário Municipal da Conservação e Serviços Públicos"),
              nome_cargo("Ozires Andrade Pontes", "Secretário Municipal do Esporte e Lazer"),                           
              nome_cargo("Rodrigo Nogueira Diogo de Siqueira", "Secretário Municipal do Desenvolvimento Econômico")
            ),
            column(
              width = 4,
              nome_cargo("Luciana Mendes Lobo", "Secretária Municipal do Urbanismo e Meio Ambiente"),              
              nome_cargo("Alexandre Pereira Lima", "Secretário Municipal do Turismo de Fortaleza"),
              nome_cargo("José Ilário Gonçalves Marques", "Secretário Municipal dos Direitos Humanos e Desenvolvimento Social"),
              nome_cargo("Francisco Adail de Carvalho Fontenele", "Secretário Municipal de Desenvolvimento Habitacional"),              
              nome_cargo("Elpídio Nogueira Moreira", "Secretário Municipal da Cultura"),              
              nome_cargo("Davi Gomes Barroso", "Secretário Municipal da Juventude"),
              nome_cargo("João De Aguiar Pupo", "Secretário Municipal da Gestão Regional")
            )
          )
        )        
      )
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    print("Iniciando servidor do módulo 'sobre'")
  })
}
