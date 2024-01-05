box::use(
  bs4Dash,
  fresh,
  shiny[
    icon,
    includeCSS,
    tagList,
    tags
  ],
  shinyjs,
)

box::use(
  view/inicio,
  view/incineradores,
  #view/esgoto,
  view/metodologia,
  view/ficha_tecnica,
)

set_ui <- function() {
  ############################
  ## Personalização do tema ##
  ############################
  # Paleta de cores
  color_atlas_navy_blue <- '#071d49'
  color_atlas_light_blue <- '#014ffd'
  color_atlas_green <- '#42eb76'
  color_atlas_purple <- '#9417e5'
  color_atlas_red <- '#ff585d'
  ## Do manual de identidade visual da PMF
  color_atlas_yellow <- '#fbb81c'
  color_atlas_cyan <- '#1eb1e7'
  iplanfor_yellow <- "#e68301"
  ## Cores extras
  color_white <- '#ffffff'
  font_header <- 'Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900'
  font_text <- "Raleway"

  # Paleta gerada em:
  # https://m2.material.io/resources/color/#!/?view.left=0&view.right=1
  iplanfor_primary <- "#e68301"
  iplanfor_primary_light <- "#ffb343"
  iplanfor_primary_dark <- "#ae5500"
  iplanfor_secondary <- "#00916e"
  iplanfor_secondary_light <- "#4ec29c"
  iplanfor_secondary_dark <- "#006243"
  

  primary_color <- iplanfor_primary
  secondary_color <- iplanfor_secondary
  tema <- fresh$create_theme(
    theme = 'default',
    fresh$bs4dash_font(
      ## family_base = google_font,
      ## size_base = '1rem',
      ## weight_bold = 500,
      size_base = '1rem',
      ## size_lg = NULL,
      ## size_sm = NULL,
      ## size_xs = NULL,
      ## size_xl = NULL,
      ## weight_light = 500,
      ## weight_normal = 400,
      ## weight_bold = 700,
      ## family_sans_serif = NULL,
      family_monospace = font_text,
      family_base = font_text
    ),
    fresh$bs4dash_status(
      primary = primary_color,
      secondary = secondary_color,
      danger = color_atlas_red,
      light = iplanfor_primary_light,
      ##dark = iplanfor_primary_dark
    ),
    fresh$bs4dash_vars(
      `main-footer-bg` = primary_color
      ##`main-header-bg` = secondary_color
      ##`main-header-bottom-border-color` = "ff0000"
      ##`navbar-light-background-color` = "#ff0000"
      ## `navbar-light-active-color` = "#FF0000",
      ## `navbar-light-hover-color` = "#FFF"
    )
   ## ,
   ##  fresh$bs4dash_yiq(
   ##    contrasted_threshold = 10,
   ##    text_dark = "#FFF", 
   ##    text_light = "#272c30"
   ##  )
  )

  # Título do painel
  title <- "Dashboard DIOBS"

  tagList(
    shinyjs$useShinyjs(),  # Set up shinyjs
    fresh$use_googlefont(font_header),
    fresh$use_googlefont(font_text),    
    bs4Dash$dashboardPage(
      fullscreen = TRUE,
      scrollToTop = TRUE,
      header = bs4Dash$dashboardHeader(
        title = bs4Dash$dashboardBrand(
          title = title,
          color = "primary",
          href = "https://observatoriodefortaleza.fortaleza.ce.gov.br/",
          image = "/logo.png", # Localizado em assets/static/logo.png
          opacity = 1
        ),
        leftui = tags$div(          
        ),
        rightUi = tags$li(
          class = "dropdown",
          bs4Dash$actionButton(
            inputId = "btn_sobre",
            label = "Saiba mais",
            icon = icon("info-circle"),
            class = "btn-primary bg-secondary"
          )
        )
      ),
      sidebar = bs4Dash$dashboardSidebar(
        minified = TRUE,
        skin = "light",
        bs4Dash$sidebarMenu(
          id = "menu_principal",
          bs4Dash$menuItem(
            "Início",
            tabName = "inicio",
            icon = icon("home")          
          ),
           bs4Dash$menuItem(
             "Incineradores",
             tabName = "incineradores",
            icon = icon("users")          
           ),
         # bs4Dash$menuItem(
         #   "Esgoto",
         #   tabName = "esgoto",
         #   icon = icon("users")
         # ),
         bs4Dash$menuItem(
            "Ficha técnica",
            tabName = "ficha_tecnica",
            icon = icon("users")          
          ),
          bs4Dash$menuItem(
            "Metodologia",
            tabName = "metodologia",
            icon = icon("book")          
          )
        )
      ),
      body = bs4Dash$dashboardBody(
        fresh$use_theme(
          theme = tema
        ),
        bs4Dash$tabItems(
          bs4Dash$tabItem(tabName = "inicio", inicio$ui("inicio")),
          bs4Dash$tabItem(tabName = "incineradores", incineradores$ui("incineradores")),
          #bs4Dash$tabItem(tabName = "esgoto", esgoto$ui("esgoto")),
          bs4Dash$tabItem(tabName = "ficha_tecnica", ficha_tecnica$ui("ficha_tecnica")),
          bs4Dash$tabItem(tabName = "metodologia", metodologia$ui("metodologia"))
        )
      ),
      controlbar = bs4Dash$dashboardControlbar(
        skin = "light"
      ),
      footer = bs4Dash$dashboardFooter(
        left = '2022, Diretoria do Observatório da Governança Municipal',
        right = tags$div(
          tags$ul(
            tags$li(
              tags$a(
                href = "https://observatoriodefortaleza.fortaleza.ce.gov.br/",
                target = "_blank",
                alt = "Diretoria do Observatório de Fortaleza",
                tags$img(src = '/img/marca-branca-diobs.svg')
              )          
            ),        
            tags$li(
              tags$img(src = '/img/marca-branca-iplanfor.svg')
            ),
            tags$li(
              tags$a(
                href = "https://www.fortaleza.ce.gov.br/",
                target = "_blank",
                alt = "Prefeitura Municipal de Fortaleza",
                tags$img(src = '/img/marca-branca-pmf.svg')
              )          
            )
          )      
        )
      ),
      title = title
    ),
    tags$head(tags$script(src="/js/index.js")),
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")      
    ),
  )
}

#' @export
ui <- set_ui()
