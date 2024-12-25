# Define the Water Data UI Module
water_data_module_ui <- function(id) {
  ns <- NS(id)  # Create a namespace for this module
  
  fluidPage(
    theme = bs_theme(
      version = 5,
      bg = "#1e1e1e",
      fg = "#4FC3F7",
      primary = "#29B6F6",
      secondary = "#81D4FA",
      success = "#66BB6A",
      info = "#42A5F5",
      warning = "#FFA726",
      danger = "#E53935",
      base_font = font_google("Roboto")
    ),
    
    tags$head(tags$style(HTML("
      @import url('https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;700&display=swap');
      
      .water-dashboard { 
        font-family: 'Roboto', sans-serif; 
        background-color: #1e1e1e; 
        color: #4FC3F7; 
      }
      .water-dashboard .header-section {
        text-align: center; 
        margin-bottom: 30px;
      }
      .water-dashboard .header-section h1 {
        color: #29B6F6;
        font-size: 50px; 
        font-weight: 700; 
        text-align: center; 
        margin-bottom: 20px;
      }
      .water-dashboard .header-section h5 {
        color: #81D4FA;
        font-size: 18px; 
        text-align: center; 
        margin-bottom: 30px;
      }
      .water-dashboard .key-metrics div {
        background: linear-gradient(to right, #2c2c2c, #424242); 
        color: #4FC3F7; 
        border-radius: 10px; 
        padding: 20px; 
        margin: 10px; 
        position: relative; 
        transition: transform 0.3s ease-in-out;
      }
      .water-dashboard .key-metrics div:hover {
        transform: scale(1.05);
      }
      .water-dashboard .key-metrics div .icon {
        position: absolute;
        top: 10px;
        right: 10px;
        font-size: 36px;
        color: #4FC3F7;
      }
     .water-dashboard {
    font-family: 'Roboto', sans-serif;
    background-color: #1e1e1e;
    color: #4FC3F7;
}

.water-dashboard .filters-box {
    background-color: #333333;
    border: 1px solid #424242;
    border-radius: 10px;
    padding: 15px;
    font-family: 'Roboto', sans-serif;
    line-height: 1.6;
}

.water-dashboard .filters-box .pickerInput,
.water-dashboard .filters-box .dropdown-menu {
    background-color: #4FC3F7 !important;
    color: #1e1e1e !important;
}

.water-dashboard .filters-box .pickerInput .btn,
.water-dashboard .filters-box .btn {
    background-color: #29B6F6 !important;
    color: #ffffff !important;
    border: none !important;
}

.water-dashboard .filters-box .sliderInput .slider {
    background-color: #4FC3F7 !important;
}

.water-dashboard .filters-box .sliderInput .slider .slider-track {
    background: linear-gradient(to right, #29B6F6, #4FC3F7) !important;
}

.water-dashboard .filters-box .btn-secondary {
    background-color: #4FC3F7 !important;
    color: #1e1e1e !important;
    border-color: #4FC3F7 !important;
    font-weight: bold;
}

.water-dashboard .filters-box .btn-secondary:hover {
    background-color: #29B6F6 !important;
    color: #ffffff !important;
}
.water-dashboard .dropdown-menu {
      background-color: #1e90ff !important; /* Bright blue background */
      color: #ffffff !important; /* White text for readability */
  }
  .water-dashboard .dropdown-menu .dropdown-item:hover {
      background-color: #4682b4 !important; /* Slightly darker blue on hover */
      color: #ffffff !important; /* White text for hover */
  }
  .water-dashboard .pickerInput .btn {
      background-color: #4FC3F7 !important; /* Light blue for the picker button */
      color: #ffffff !important; /* White text */
      border: none !important;
  }
  .water-dashboard .dropdown-menu .dropdown-item {
      color: #000000 !important; /* Black text for menu items */
  }

      .water-dashboard .nav-tabs .nav-link {
        color: #4FC3F7 !important; 
        font-weight: 500;
      }
      .water-dashboard .nav-tabs .nav-link.active {
        color: #1e1e1e !important; 
        background-color: #29B6F6 !important;
      }
      .water-dashboard .btn-secondary {
        color: #4FC3F7 !important;
        border-color: #4FC3F7;
      }
    "))),
    
    class = "water-dashboard",
    
    # Header Section
    fluidRow(
      column(
        width = 12,
        div(
          class = "header-section",
          h1("Water Access Overview"),
          h5("Explore global water access metrics interactively")
        )
      )
    ),
    
    # Key Metrics Section
    fluidRow(
      class = "key-metrics",
      style = "display: flex; justify-content: space-between; align-items: center; gap: 20px;",
      
      div(
        style = "flex: 1; min-width: 300px; height: 150px; position: relative;",
        h4("Average Access to Basic Water", style = "font-weight: bold; color: #4FC3F7;"),
        h2(textOutput(ns("avg_basic_access_value")), style = "font-size: 36px; font-weight: bold; color: #4FC3F7;"),
        icon("tint", class = "icon")
      ),
      
      div(
        style = "flex: 1; min-width: 300px; height: 150px; position: relative;",
        h4("Most Improved Country", style = "font-weight: bold; color: #4FC3F7;"),
        h2(textOutput(ns("most_improved_country_value")), style = "font-size: 36px; font-weight: bold; color: #4FC3F7;"),
        icon("chart-line", class = "icon")
      ),
      
      div(
        style = "flex: 1; min-width: 300px; height: 150px; position: relative;",
        h4("Least Improved Country", style = "font-weight: bold; color: #4FC3F7;"),
        h2(textOutput(ns("least_improved_country_value")), style = "font-size: 36px; font-weight: bold; color: #4FC3F7;"),
        icon("globe", class = "icon")
      )
    ),
    
    # Tabs Section
    fluidRow(
      tabsetPanel(
        type = "tabs",
        tabPanel(
          "Water Access Map",
          fluidRow(
            column(
              width = 3,
              div(
                class = "filters-box",
                style = "color: #4FC3F7;",
                # Map Interpretation Section
                div(
                  style = "margin-bottom: 15px;",
                  h5(icon("map", style = "color: #4FC3F7; margin-right: 10px;"), "Map Interpretation", style = "font-weight: bold;"),
                  tags$p("The map visualizes water access metrics across countries. Use the color scale to identify regions with better or worse access. Hover over the countries for specific values, or click for more details.")
                ),
                # Using Filters Section
                div(
                  style = "margin-bottom: 15px;",
                  h5(icon("filter", style = "color: #4FC3F7; margin-right: 10px;"), "Using Filters", style = "font-weight: bold;"),
                  tags$p("Use filters to refine the data by continent, country, year, or access percentage. Filters allow for a focused analysis of specific regions or years.")
                ),
                div(
                  style = "margin-bottom: 15px;",
                  h5(icon("info-circle", style = "color: #4FC3F7; margin-right: 10px;"), "Understanding Data", style = "font-weight: bold; display: inline-block;"),
                  tags$p("Refer to the legend to interpret colors: Green (safe), Yellow (moderate), Orange (high), and Red (dangerous). Each marker represents a country’s average PM2.5.")
                )
              )
            ),
            column(
              width = 6,
              plotlyOutput(ns("water_access_map"), height = "500px")
            ),
            column(
              width = 3,
              div(
                class = "filters-box",
                
                # PickerInput for UNICEF reporting region
                pickerInput(
                  ns("continent_filter"), 
                  "Select UNICEF Reporting Region:",
                  choices = c("All regions" = "all", sort(unique(water_data$unicef_reporting_region))), # Sorted choices
                  multiple = TRUE, 
                  selected = "all",
                  options = list(
                    `actions-box` = TRUE,          # Enables select/deselect all buttons
                    `deselectAllText` = "Deselect All", # Custom text for deselect
                    `selectAllText` = "Select All"     # Custom text for select
                  )
                ),
                
                # PickerInput for country
                pickerInput(
                  ns("country_filter"), 
                  "Select Country:",
                  choices = c("All Countries" = "all", sort(unique(water_data$country_area_or_territory))), # Sorted choices
                  multiple = TRUE, 
                  selected = "all",
                  options = list(
                    `actions-box` = TRUE,          # Enables select/deselect all buttons
                    `deselectAllText` = "Deselect All", # Custom text for deselect
                    `selectAllText` = "Select All"     # Custom text for select
                  )
                ),
                
                # PickerInput for year
                pickerInput(
                  ns("year_filter"), 
                  "Select Year(s):",
                  choices = sort(unique(water_data$year)), # Sorted years
                  multiple = TRUE, 
                  selected = max(water_data$year),
                  options = list(
                    `actions-box` = TRUE,          # Enables select/deselect all buttons
                    `deselectAllText` = "Deselect All", # Custom text for deselect
                    `selectAllText` = "Select All"     # Custom text for select
                  )
                ),
                
                # SliderInput for access to basic water
                sliderInput(
                  ns("basic_access_filter"), 
                  "Access to Basic Water (%):",
                  min = 0, 
                  max = 100, 
                  value = c(0, 100)
                ),
                
                # Download Button
                downloadButton(
                  ns("download_data"), 
                  "Download Data", 
                  class = "btn btn-secondary"
                )
              )
              
            )
          )
        )
         ,
         tabPanel("Trends", plotlyOutput(ns("water_trends"), height = "400px")),
         tabPanel("Country Rankings Table", DTOutput(ns("water_rankings")))
      )
    )
  )
}
