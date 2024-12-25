# Define the Global Health Data UI Module
global_health_module_ui <- function(id) {
  ns <- NS(id)  # Create a namespace for this module
  
  fluidPage(
    theme = bs_theme(
      version = 5,
      bg = "#212121",  # Dark background for the page
      fg = "#FFEB3B",  # Yellow foreground for text
      primary = "#FF5722",  # Orange for primary elements
      secondary = "#FF9800",  # Lighter orange for secondary elements
      success = "#4CAF50",  # Green for success messages
      info = "#2196F3",  # Blue for info
      warning = "#FFEB3B",  # Yellow for warnings
      danger = "#E53935",  # Red for danger
      base_font = font_google("Roboto")
    ),
    
    # Scoped CSS for Global Health Dashboard
    tags$head(tags$style(HTML("
      @import url('https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;700&display=swap');
      
      .global-health-dashboard { 
        font-family: 'Roboto', sans-serif; 
        background-color: #212121; 
        color: #FFEB3B; 
      }
      .global-health-dashboard .header-section h1 {
        color: #FF5722; 
        font-size: 50px; 
        font-weight: 700; 
        text-align: center; 
        margin-bottom: 20px;
      }
      .global-health-dashboard .header-section h5 {
        color: #FF9800; 
        font-size: 18px; 
        text-align: center; 
        margin-bottom: 30px;
      }
      .global-health-dashboard .key-metrics div {
        background: linear-gradient(to right, #2c2c2c, #424242);
        color: #FFEB3B; 
        border-radius: 10px; 
        padding: 20px; 
        margin: 10px;
        transition: transform 0.3s ease-in-out;
        position: relative;
      }
      .global-health-dashboard .key-metrics div:hover {
        transform: scale(1.05);
      }
      .global-health-dashboard .key-metrics div .icon {
        position: absolute;
        top: 10px;
        right: 10px;
        font-size: 36px;
        color: #FFEB3B;
      }
      .global-health-dashboard .filters-box {
        background-color: #333333; 
        border: 1px solid #424242; 
        border-radius: 10px; 
        padding: 15px; 
        height: 500px;
      }
      .global-health-dashboard .nav-tabs .nav-link {
        color: #FF5722 !important; 
        font-weight: 500;
      }
      .global-health-dashboard .nav-tabs .nav-link.active {
        color: #212121 !important; 
        background-color: #FF5722 !important;
      }
      .global-health-dashboard .btn-secondary {
        color: #FF5722 !important;
        border-color: #FF5722;
      }
      .global-health-dashboard .filters-box {
    background-color: #333333; /* Dark background */
    border: 1px solid #424242; /* Subtle border */
    border-radius: 10px;
    padding: 15px;
    font-family: 'Roboto', sans-serif;
    line-height: 1.6;
}

.global-health-dashboard .filters-box .pickerInput,
.global-health-dashboard .filters-box .dropdown-menu {
    background-color: #E53935 !important; /* Red background for dropdowns */
    color: #FFFFFF !important; /* White text */
}

.global-health-dashboard .filters-box .pickerInput .btn,
.global-health-dashboard .filters-box .btn {
    background-color: #D32F2F !important; /* Darker red for buttons */
    color: #FFFFFF !important; /* White text */
    border: none !important;
}

.global-health-dashboard .filters-box .sliderInput .slider {
    background-color: #E53935 !important; /* Red background for slider */
}

.global-health-dashboard .filters-box .sliderInput .slider .slider-track {
    background: linear-gradient(to right, #E53935, #FFCDD2) !important; /* Gradient red */
}

.global-health-dashboard .filters-box .btn-secondary {
    background-color: #E53935 !important; /* Secondary button color */
    color: #FFFFFF !important; /* White text */
    border-color: #E53935 !important;
    font-weight: bold;
}

.global-health-dashboard .filters-box .btn-secondary:hover {
    background-color: #D32F2F !important; /* Darker red on hover */
    color: #FFFFFF !important; /* White text */
}

.global-health-dashboard .dropdown-menu {
    background-color: #E53935 !important; /* Red background for dropdown */
    color: #FFFFFF !important; /* White text for readability */
}

.global-health-dashboard .dropdown-menu .dropdown-item:hover {
    background-color: #C62828 !important; /* Darker red on hover */
    color: #FFFFFF !important; /* White text */
}

.global-health-dashboard .pickerInput .btn {
    background-color: #FF5252 !important; /* Bright red for picker button */
    color: #FFFFFF !important; /* White text */
    border: none !important;
}

.global-health-dashboard .dropdown-menu .dropdown-item {
    color: #000000 !important; /* Black text for menu items */
}

.global-health-dashboard .nav-tabs .nav-link {
    color: #E53935 !important; /* Red text for tabs */
    font-weight: 500;
}

.global-health-dashboard .nav-tabs .nav-link.active {
    color: #1e1e1e !important; /* Dark text for active tab */
    background-color: #D32F2F !important; /* Dark red background for active tab */
}

.global-health-dashboard .btn-secondary {
    color: #E53935 !important; /* Red text for secondary button */
    border-color: #E53935; /* Red border */
}

.global-health-dashboard .nav-tabs .nav-link {
    color: #E53935 !important;
    font-weight: 500;
}

.global-health-dashboard .nav-tabs .nav-link.active {
    color: #1e1e1e !important;
    background-color: #D32F2F !important;
}

.global-health-dashboard .btn-secondary {
    color: #E53935 !important;
    border-color: #E53935;
}


    "))),
    
    div(
      class = "global-health-dashboard",
      # Header Section
      fluidRow(
        column(
          width = 12,
          div(
            class = "header-section",
            h1("Global Health Overview"),
            h5("Explore global health metrics interactively")
          )
        )
      ),
      
      # Key Metrics Section
      fluidRow(
        class = "key-metrics",
        style = "display: flex; justify-content: space-between; align-items: center; gap: 20px;",
        
        div(
          style = "flex: 1; min-width: 300px; height: 150px;",
          h4("Deaths: Diseases", style = "font-weight: bold; color: #FF5722;"),
          h2(textOutput(ns("total_deaths_value")), style = "font-size: 30px; font-weight: bold; color: #FF5722;"),
          icon("heartbeat", class = "icon")
        ),
        
        div(
          style = "flex: 1; min-width: 300px; height: 150px;",
          h4("Most Affected Region", style = "font-weight: bold; color: #FF5722;"),
          h2(textOutput(ns("most_affected_region_value")), style = "font-size: 30px; font-weight: bold; color: #FF5722;"),
          icon("globe", class = "icon")
        ),
        
        div(
          style = "flex: 1; min-width: 300px; height: 150px;",
          h4("Total Countries Reported", style = "font-weight: bold; color: #FF5722;"),
          h2(textOutput(ns("total_countries_reported_value")), style = "font-size: 30px; font-weight: bold; color: #FF5722;"),
          icon("map-marker-alt", class = "icon")
        )
      ),
      
      # Tabs Section
      fluidRow(
        tabsetPanel(
          type = "tabs",
          tabPanel(
            "Global Health Map",
            fluidRow(
              column(
                width = 3,
                div(
                  class = "filters-box",
                  style = "color: #FF5722;",
                  # Map Interpretation Section
                  div(
                    style = "margin-bottom: 15px;",
                    h5(icon("map", style = "color: #FF5722; margin-right: 10px;"), "Map Interpretation", style = "font-weight: bold;"),
                    tags$p("The map displays death rates and health metrics by region and country.")
                  ),
                  # Using Filters Section
                  div(
                    style = "margin-bottom: 15px;",
                    h5(icon("filter", style = "color: #FF5722; margin-right: 10px;"), "Using Filters", style = "font-weight: bold;"),
                    tags$p("Filter data by continent, country, year, or health indicator.")
                  ),
                  div(
                    style = "margin-bottom: 15px;",
                    h5(icon("info-circle", style = "color: #FF5722; margin-right: 10px;"), "Understanding Data", style = "font-weight: bold; display: inline-block;"),
                    tags$p("Refer to the legend to interpret colors: Green (safe), Yellow (moderate), Orange (high), and Red (dangerous). Each marker represents a country’s average PM2.5.")
                  )
                )
              ),
              column(
                width = 6,
                plotlyOutput(ns("global_health_map"), height = "500px")
              ),
              column(
                width = 3,
                div(
                  class = "filters-box",
                  
                  # PickerInput for Continent
                  pickerInput(
                    ns("continent_filter"), 
                    "Select Continent:",
                    choices = c("All Continents" = "all", sort(unique(global_health_data$parentlocation))), # Sorted alphabetically
                    multiple = TRUE, 
                    selected = "all",
                    options = list(
                      `actions-box` = TRUE,          # Enable "Select All" and "Deselect All"
                      `deselectAllText` = "Deselect All", # Custom text for "Deselect All"
                      `selectAllText` = "Select All"     # Custom text for "Select All"
                    )
                  ),
                  
                  # PickerInput for Country
                  pickerInput(
                    ns("country_filter"), 
                    "Select Country:",
                    choices = c("All Countries" = "all", sort(unique(global_health_data$location))), # Sorted alphabetically
                    multiple = TRUE, 
                    selected = "all",
                    options = list(
                      `actions-box` = TRUE,          # Enable "Select All" and "Deselect All"
                      `deselectAllText` = "Deselect All", # Custom text for "Deselect All"
                      `selectAllText` = "Select All"     # Custom text for "Select All"
                    )
                  ),
                  
                  # PickerInput for Year
                  pickerInput(
                    ns("year_filter"), 
                    "Select Year(s):",
                    choices = sort(unique(global_health_data$period)), # Sorted numerically
                    multiple = TRUE, 
                    selected = max(global_health_data$period), # Default to the latest year
                    options = list(
                      `actions-box` = TRUE,          # Enable "Select All" and "Deselect All"
                      `deselectAllText` = "Deselect All", # Custom text for "Deselect All"
                      `selectAllText` = "Select All"     # Custom text for "Select All"
                    )
                  ),
                  
                  # SliderInput for Health Indicator Values
                  sliderInput(
                    ns("health_indicator_filter"), 
                    "Health Indicator Values:",
                    min = 0, 
                    max = max(global_health_data$factvaluenumeric, na.rm = TRUE),
                    value = c(0, max(global_health_data$factvaluenumeric, na.rm = TRUE))
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
          ),
          tabPanel("Trends", plotlyOutput(ns("health_trends"), height = "400px")),
          tabPanel("Country Rankings Table", DTOutput(ns("health_rankings")))
        )
      )
    )
  )
}
