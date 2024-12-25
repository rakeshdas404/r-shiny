# Define the Air Quality Server Module
air_quality_module_server <- function(id, air_quality_data) {
  moduleServer(id, function(input, output, session) {
    # Observe and handle dark mode toggle
    observeEvent(input$dark_mode, {
      if (input$dark_mode == "dark") {
        showNotification("Welcome to dark mode!")
      } else {
        showNotification("Back to light mode!")
      }
    })
    
    # Reactive data filtering
    filtered_data <- reactive({
      data <- air_quality_data
      if (!("all" %in% input$continent_filter)) {
        data <- data %>% filter(continent %in% input$continent_filter)
      }
      if (!("all" %in% input$country_filter)) {
        data <- data %>% filter(country_name %in% input$country_filter)
      }
      if (!is.null(input$year_filter)) {
        data <- data %>% filter(year %in% input$year_filter)
      }
      data <- data %>% filter(
        pm25_concentration >= input$pm25_filter[1],
        pm25_concentration <= input$pm25_filter[2]
      )
      return(data)
    })
    
    # Render average PM2.5 value
    output$avg_pm25_value <- renderText({
      avg_pm25 <- mean(filtered_data()$pm25_concentration, na.rm = TRUE)
      round(avg_pm25, 2)
    })
    
    # Render most polluted country
    output$most_polluted_country_value <- renderText({
      most_polluted <- filtered_data() %>%
        group_by(country_name) %>%
        summarize(avg_pm25 = mean(pm25_concentration, na.rm = TRUE)) %>%
        arrange(desc(avg_pm25)) %>%
        slice(1)
      most_polluted$country_name
    })
    
    # # Render total countries or PM10 average (choose appropriate output logic)
    # output$total_countries_value <- renderText({
    #   n_distinct(filtered_data()$country_name)
    # })
    
    
    output$avg_pm10_value <- renderText({
      avg_pm10 <- mean(filtered_data()$pm10_concentration, na.rm = TRUE)
      round(avg_pm10, 2)
    })
    
    # Download Handler for Download Button
    output$download_data <- downloadHandler(
      filename = function() {
        paste("air_quality_data-", Sys.Date(), ".csv", sep = "")
      },
      content = function(file) {
        write.csv(filtered_data(), file, row.names = FALSE)
      }
    )
    # Render the trends for PM2.5
    output$air_quality_trends <- renderPlotly({
      trend_data <- air_quality_data %>%
        group_by(year) %>%
        summarize(avg_pm25 = mean(pm25_concentration, na.rm = TRUE))
      
      plot_ly(
        trend_data,
        x = ~year,
        y = ~avg_pm25,
        type = 'scatter',
        mode = 'lines+markers',
        line = list(color = '#FFC107')
      ) %>%
        layout(
          title = "PM2.5 Concentration Trends Over the Years",
          xaxis = list(title = "Year"),
          yaxis = list(title = "Average PM2.5 Concentration")
        )
    })
    
    # Render the rankings table for countries by PM2.5 levels
    output$air_quality_rankings <- renderDT({
      rankings_data <- air_quality_data %>%
        group_by(country_name) %>%
        summarize(avg_pm25 = mean(pm25_concentration, na.rm = TRUE)) %>%
        arrange(desc(avg_pm25))
      
      datatable(rankings_data, options = list(pageLength = 10), 
                colnames = c("Country", "Average PM2.5"))
    })
    
    
    # Render air quality map
    output$air_quality_map <- renderPlotly({
      map_data <- filtered_data() %>%
        group_by(country_name, iso3) %>%
        summarize(avg_pm25 = mean(pm25_concentration, na.rm = TRUE))
      
      plot_ly(
        data = map_data,
        type = "choropleth",
        locations = ~iso3,
        z = ~avg_pm25,
        text = ~paste("Country:", country_name, "<br>PM2.5:", round(avg_pm25, 2)),
        colorscale = "Blues",
        zmin = 1,   # Minimum PM2.5 value
        zmax = 440, # Maximum PM2.5 value
        marker = list(line = list(color = "darkgray", width = 0.5)),
        colorbar = list(
          title = "PM2.5",
          tickvals = c(1, 110, 220, 440),
          ticktext = c("Safe", "Moderate", "High", "Dangerous")
        )
      ) %>%
        layout(
          geo = list(
            showframe = FALSE,
            showcoastlines = TRUE,
            projection = list(type = "equirectangular")
          ),
          paper_bgcolor = "#f8f9fa",
          plot_bgcolor = "#f8f9fa"
        )
    })
    
    
    
  })
}
