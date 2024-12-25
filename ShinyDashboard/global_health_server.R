# Define the Global Health Data Server Module
global_health_module_server <- function(id, global_health_data) {
  moduleServer(id, function(input, output, session) {
    # Observe and handle dark mode toggle
    observeEvent(input$dark_mode, {
      if (input$dark_mode == "dark") {
        showNotification("Welcome to dark mode!")
      } else {
        showNotification("Back to light mode!")
      }
    })
    
    # Reactive function to filter the global health data based on user inputs
    filtered_data <- reactive({
      data <- global_health_data
      if (!("all" %in% input$continent_filter)) {
        data <- data %>% filter(parentlocation %in% input$continent_filter)
      }
      if (!("all" %in% input$country_filter)) {
        data <- data %>% filter(location %in% input$country_filter)
      }
      if (!is.null(input$year_filter)) {
        data <- data %>% filter(period %in% input$year_filter)
      }
      data <- data %>% filter(
        factvaluenumeric >= input$health_indicator_filter[1],
        factvaluenumeric <= input$health_indicator_filter[2]
      )
      return(data)
    })
    
    # Output the total deaths from non-communicable diseases
    output$total_deaths_value <- renderText({
      total_deaths <- sum(filtered_data()$factvaluenumeric, na.rm = TRUE)
      prettyNum(total_deaths, big.mark = ",")
    })
    
    # Output the most affected region by deaths
    output$most_affected_region_value <- renderText({
      most_affected <- filtered_data() %>%
        group_by(parentlocation) %>%
        summarize(total_deaths = sum(factvaluenumeric, na.rm = TRUE)) %>%
        arrange(desc(total_deaths)) %>%
        slice(1)
      most_affected$parentlocation
    })
    
    # Output the total number of countries reported
    output$total_countries_reported_value <- renderText({
      n_distinct(filtered_data()$location)
    })
    # Download Handler for Download Button
    output$download_data <- downloadHandler(
      filename = function() {
        paste("global_health_data-", Sys.Date(), ".csv", sep = "")
      },
      content = function(file) {
        write.csv(filtered_data(), file, row.names = FALSE)
      }
    )
    
    # Render the global health map
    output$global_health_map <- renderPlotly({
      map_data <- filtered_data() %>%
        group_by(location, spatialdimvaluecode) %>%
        summarize(total_deaths = sum(factvaluenumeric, na.rm = TRUE))
      
      plot_ly(
        data = map_data,
        type = "choropleth",
        locations = ~spatialdimvaluecode,
        z = ~total_deaths,
        text = ~paste("Country:", location, "<br>Deaths:", round(total_deaths, 2)),
        colorscale = list(
          c(0, 0.5, 1),  # Scale points (0%, 50%, 100%)
          c("#FFCDD2", "#E53935", "#B71C1C")  # Light red -> Medium red -> Dark red
        ),
        marker = list(line = list(color = "darkgray", width = 0.5)),
        colorbar = list(
          title = "Total Deaths",
          titlefont = list(color = "#FF5722"),  # Title color
          tickfont = list(color = "#FF5722")  # Tick labels color
        )
      ) %>%
        layout(
          geo = list(
            showframe = FALSE,
            showcoastlines = TRUE,
            projection = list(type = "equirectangular")
          ),
          paper_bgcolor = "#212121",  # Match dashboard background
          plot_bgcolor = "#212121"   # Match dashboard background
        )
      
    })
    
    # Render the trends for global health metrics
    output$health_trends <- renderPlotly({
      trend_data <- global_health_data %>%
        group_by(period) %>%
        summarize(total_deaths = sum(factvaluenumeric, na.rm = TRUE))
      
      plot_ly(
        trend_data,
        x = ~period,
        y = ~total_deaths,
        type = 'scatter',
        mode = 'lines+markers',
        line = list(color = '#FF5722')
      ) %>%
        layout(
          title = "Global Health Trends - Total Deaths from Non-Communicable Diseases",
          xaxis = list(title = "Year"),
          yaxis = list(title = "Total Deaths")
        )
    })
    
    # Render the rankings table for countries by total deaths
    output$health_rankings <- renderDT({
      rankings_data <- filtered_data() %>%
        group_by(location) %>%
        summarize(total_deaths = sum(factvaluenumeric, na.rm = TRUE)) %>%
        arrange(desc(total_deaths))
      datatable(rankings_data, options = list(pageLength = 10))
    })
  })
}
