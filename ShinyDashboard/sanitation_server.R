# Define the Sanitation Data Server Module
sanitation_module_server <- function(id, sanitation_data) {
  moduleServer(id, function(input, output, session) {
    # Observe and handle dark mode toggle
    observeEvent(input$dark_mode, {
      if (input$dark_mode == "dark") {
        showNotification("Welcome to dark mode!")
      } else {
        showNotification("Back to light mode!")
      }
    })
    
    # Reactive function to filter the sanitation data based on user inputs
    filtered_data <- reactive({
      data <- sanitation_data
      if (!("all" %in% input$continent_filter)) {
        data <- data %>% filter(sdg_region %in% input$continent_filter)
      }
      if (!("all" %in% input$country_filter)) {
        data <- data %>% filter(country_area_or_territory %in% input$country_filter)
      }
      if (!is.null(input$year_filter)) {
        data <- data %>% filter(year %in% input$year_filter)
      }
      data <- data %>% filter(
        at_least_basic >= input$sanitation_filter[1],
        at_least_basic <= input$sanitation_filter[2]
      )
      return(data)
    })
    
    # Output the average sanitation access value
    output$avg_sanitation_value <- renderText({
      avg_sanitation <- mean(filtered_data()$at_least_basic, na.rm = TRUE)
      round(avg_sanitation, 2)
    })
    
    # Output the most improved country in sanitation
    output$most_improved_country_value <- renderText({
      most_improved <- filtered_data() %>%
        group_by(country_area_or_territory) %>%
        summarize(avg_sanitation = mean(at_least_basic, na.rm = TRUE)) %>%
        arrange(desc(avg_sanitation)) %>%
        slice(1)
      most_improved$country_area_or_territory
    })
    
    # Output the total number of countries
    output$total_countries_value <- renderText({
      n_distinct(filtered_data()$country_area_or_territory)
    })
    
    # Download Handler for Download Button
    output$download_data <- downloadHandler(
      filename = function() {
        paste("sanitation_data-", Sys.Date(), ".csv", sep = "")
      },
      content = function(file) {
        write.csv(filtered_data(), file, row.names = FALSE)
      }
    )
    
    # Render the sanitation access map
    output$sanitation_map <- renderPlotly({
      map_data <- filtered_data() %>%
        group_by(country_area_or_territory, iso3) %>%
        summarize(avg_sanitation = mean(at_least_basic, na.rm = TRUE))
      
      plot_ly(
        data = map_data,
        type = "choropleth",
        locations = ~iso3,
        z = ~avg_sanitation,
        text = ~paste(
          "Country:", country_area_or_territory,
          "<br>Sanitation Access:", round(avg_sanitation, 2)
        ),
        colorscale = list(
          c(0, 0.5, 1),  # Scale points (0%, 50%, 100%)
          c("#A5D6A7", "#66BB6A", "#1B5E20")  # Light green -> Medium green -> Dark green
        ),
        marker = list(line = list(color = "darkgray", width = 0.5)),
        colorbar = list(
          title = "Sanitation Access (%)",
          titlefont = list(color = "#4CAF50"),  # Title color
          tickfont = list(color = "#4CAF50")  # Tick labels color
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
    
    # Render sanitation trends
    output$sanitation_trends <- renderPlotly({
      trend_data <- sanitation_data %>%
        group_by(year) %>%
        summarize(avg_sanitation = mean(at_least_basic, na.rm = TRUE))
      
      plot_ly(
        trend_data,
        x = ~year,
        y = ~avg_sanitation,
        type = 'scatter',
        mode = 'lines+markers',
        line = list(color = '#29B6F6')
      ) %>%
        layout(
          title = "Sanitation Access Trends",
          xaxis = list(title = "Year"),
          yaxis = list(title = "Sanitation Access (%)")
        )
    })
    
    # Render sanitation country rankings table
    output$sanitation_rankings <- renderDT({
      rankings_data <- filtered_data() %>%
        group_by(country_area_or_territory) %>%
        summarize(avg_sanitation = mean(at_least_basic, na.rm = TRUE)) %>%
        arrange(desc(avg_sanitation))
      datatable(rankings_data, options = list(pageLength = 10))
    })
  })
}
