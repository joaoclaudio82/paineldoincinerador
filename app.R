box::use(
  shiny,
  app/ui[ui],
  app/server[server],
)

shiny$shinyApp(ui, server)
