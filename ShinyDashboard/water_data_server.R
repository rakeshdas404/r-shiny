# Define the Water Data Server Module
water_data_module_server <- function(id, water_data) {
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
      data <- water_data
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
        as.numeric(at_least_basic_rural) >= input$basic_access_filter[1],
        as.numeric(at_least_basic_rural) <= input$basic_access_filter[2]
      )
      return(data)
    })
    
    # Render average basic water access
    output$avg_basic_access_value <- renderText({
      avg_access <- mean(as.numeric(filtered_data()$at_least_basic_rural), na.rm = TRUE)
      round(avg_access, 2)
    })
    
    # Render most improved country
    output$most_improved_country_value <- renderText({
      most_improved <- filtered_data() %>%
        group_by(country_area_or_territory) %>%
        summarize(avg_access = mean(as.numeric(at_least_basic_rural), na.rm = TRUE)) %>%
        arrange(desc(avg_access)) %>%
        slice(1)
      most_improved$country_area_or_territory
    })
    
    
    # Render most improved country
    output$least_improved_country_value <- renderText({
      least_improved <- filtered_data() %>%
        group_by(country_area_or_territory) %>%
        summarize(avg_access = mean(as.numeric(at_least_basic_rural), na.rm = TRUE)) %>%
        arrange(avg_access) %>%  # Ascending order (no `asc()` required)
        slice(1)
      least_improved$country_area_or_territory
    })
    
    # # Render total distinct countries
    # output$total_countries_value <- renderText({
    #   n_distinct(filtered_data()$country_area_or_territory)
    # })
    
    # Download Handler for Download Button
    output$download_data <- downloadHandler(
      filename = function() {
        paste("waterdata-", Sys.Date(), ".csv", sep = "")
      },
      content = function(file) {
        write.csv(filtered_data(), file, row.names = FALSE)
      }
    )
    
    # Render the trends for Access to Basic Water
    output$water_trends <- renderPlotly({
      trend_data <- water_data %>%
        group_by(year) %>%
        summarize(avg_access = mean(at_least_basic_rural, na.rm = TRUE))
      
      plot_ly(
        trend_data,
        x = ~year,
        y = ~avg_access,
        type = 'scatter',
        mode = 'lines+markers',
        line = list(color = '#4CAF50')
      ) %>%
        layout(
          title = "Access to Basic Water Trends Over the Years",
          xaxis = list(title = "Year"),
          yaxis = list(title = "Average Access to Basic Water (%)")
        )
    })
    
    
    # Render the rankings table for countries by Access to Basic Water
    output$water_rankings <- renderDT({
      rankings_data <- water_data %>%
        group_by(country_area_or_territory) %>%
        summarize(avg_access = mean(at_least_basic_rural, na.rm = TRUE)) %>%
        arrange(desc(avg_access))
      
      datatable(rankings_data, options = list(pageLength = 10), 
                colnames = c("Country", "Average Access to Basic Water (%)"))
    })
    
    
    
    # Render water access map
    output$water_access_map <- renderPlotly({
      map_data <- filtered_data() %>%
        group_by(country_area_or_territory, iso3) %>%
        summarize(avg_access = mean(as.numeric(at_least_basic_rural), na.rm = TRUE))
      
      plot_ly(
        data = map_data,
        type = "choropleth",
        locations = ~iso3,
        z = ~avg_access,
        text = ~paste(
          "Country:", country_area_or_territory,
          "<br>Access to Basic Water:", round(avg_access, 2)
        ),
        colorscale = "Blues",
        colorbar = list(title = "Basic Access (%)")
      ) %>%
        layout(
          geo = list(showframe = FALSE, showcoastlines = TRUE),
          paper_bgcolor = "#f8f9fa",
          plot_bgcolor = "#f8f9fa"
        )
    })
  })
}
