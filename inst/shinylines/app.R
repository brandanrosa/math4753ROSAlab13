ylm <- lm(Height ~ BHDiameter, data = spruce)
sm <- summary(ylm)

##################################################################
library(ggplot2)
library(shiny)

# UI
ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "darkly"),

    # Application Title
    titlePanel("Spruce Regression Analysis"),

    # Sidebar Panel
    sidebarLayout(
      sidebarPanel(
        varSelectInput(inputId = "xvar",
                       "Explanatory variable (x):",
                       spruce[,c("Height", "BHDiameter")],
                       selected =  "BHDiameter"),

        varSelectInput(inputId = "yvar",
                       "Response variable (y):",
                       spruce[,c("Height", "BHDiameter")],
                       selected =  "Height")
                  ),

  mainPanel(

    fluidRow(
      column(12,
             wellPanel(plotOutput("scatter")))),

    fluidRow(
      column(12,
             wellPanel(plotOutput("ldat")))),

    fluidRow(
      column(12,
             wellPanel(plotOutput("qdat")))),

    fluidRow(
      column(12,
             wellPanel(plotOutput("qres"))))

     )
    )
   )

# Server
server <- function(input, output) {

  dfmod <- within(spruce, {
    resid <- ylm$residuals
    yhat <- ylm$fitted.values
    }
  )

  # Scatter with Smoother
   output$scatter <- renderPlot({
     ggplot(data = dfmod, aes(x = !!input$xvar, y = !!input$yvar)) +
       geom_point(color = "hotpink", cex = 2) +
       stat_smooth(color = "darkgreen") +
       labs(title = "Spruce Data Plot", subtitle = "LOESS Smoother")
    })

   output$ldat <- renderPlot({
     ggplot(data = dfmod, aes(x = !!input$xvar, y = !!input$yvar)) +
      geom_point(color = "navy", cex = 2) +
       stat_smooth(method = "lm", formula = y ~ x, color = "maroon") +
       labs(title = "Plot of the Data", subtitle = "Linear Model")
   })

   output$qdat <- renderPlot({
     ggplot(data = dfmod, aes(x = !!input$xvar, y = !!input$yvar)) +
       geom_point(color = "red", cex = 2) +
       stat_smooth(method = "lm", formula = y ~ x + I(x^2), color = "black") +
       labs(title = "Plot of the Data", subtitle =  "Quadratic Model")
   })

   output$qres <- renderPlot({
     ggplot(data = dfmod, aes(x = yhat, y = resid)) +
       geom_point(color = "darkgreen", cex = 2) +
       stat_smooth(color = "gold") +
       labs(title = "Plot of the Data", subtitle =  "LOESS Smoother")
   })
}

# Run the application
shinyApp(ui = ui, server = server)
