# Load datasets
# air_quality_data <- read.csv("C:\\Users\\ASUS\\Documents\\Masters - Guelph\\Fall 2024\\6200\\project\\6200 Shiny dashboard\\air_quality_data.csv")
# water_data <- read.csv("C:\\Users\\ASUS\\Documents\\Masters - Guelph\\Fall 2024\\6200\\project\\6200 Shiny dashboard\\water_data.csv")
# sanitation_data <- read.csv("C:\\Users\\ASUS\\Documents\\Masters - Guelph\\Fall 2024\\6200\\project\\6200 Shiny dashboard\\sanitation_data.csv")
# global_health_data <- read.csv("C:\\Users\\ASUS\\Documents\\Masters - Guelph\\Fall 2024\\6200\\project\\6200 Shiny dashboard\\global_health_data.csv")

air_quality_data <- read.csv("air_quality_data.csv")
water_data <- read.csv("water_data.csv")
sanitation_data <- read.csv("sanitation_data.csv")
global_health_data <- read.csv("global_health_data.csv")


# Define the Air Quality UI Module
air_quality_module_ui <- function(id) {
  ns <- NS(id)  # Namespace to ensure unique IDs
  fluidPage(
    theme = bs_theme(
      version = 5,
      bg = "#1e1e1e",
      fg = "#ffc107",
      primary = "#ffb300",
      secondary = "#ffcc80",
      success = "#66bb6a",
      info = "#42a5f5",
      warning = "#ffa726",
      danger = "#e53935",
      base_font = font_google("Roboto")
    ),
    
    # Scoped CSS for Air Quality Dashboard
    tags$head(tags$style(HTML("
      @import url('https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;700&display=swap');
      .air-quality-dashboard { 
        font-family: 'Roboto', sans-serif; 
        background-color: #1e1e1e; 
        color: #ffc107; 
      }
      .air-quality-dashboard .header-section h1 {
        color: #ffb300; 
        font-size: 50px; 
        font-weight: 700; 
        text-align: center; 
        margin-bottom: 20px;
      }
      .air-quality-dashboard .header-section h5 {
        color: #ffcc80; 
        font-size: 18px; 
        text-align: center; 
        margin-bottom: 30px;
      }
      .air-quality-dashboard .key-metrics div {
        background: linear-gradient(to right, #2c2c2c, #424242);
        color: #ffc107; 
        border-radius: 10px; 
        padding: 20px; 
        margin: 10px;
        transition: transform 0.3s ease-in-out;
        position: relative;
      }
      .air-quality-dashboard .key-metrics div:hover {
        transform: scale(1.05);
      }
      .air-quality-dashboard .key-metrics div .icon {
    position: absolute;
    top: 20%; /* Center vertically */
    right: 10px; /* Align to the right with padding */
    transform: translateY(-50%); /* Adjust for centering */
    font-size: 36px;
    color: #ffc107;
}
      .air-quality-dashboard .filters-box .pickerInput .btn,
.air-quality-dashboard .filters-box .btn {
    background-color: #ffc107 !important; /* Yellow for buttons */
    color: #1e1e1e !important; /* Dark text */
    border: none !important;
}

.air-quality-dashboard .filters-box .sliderInput .slider {
    background-color: #ffb300 !important; /* Yellow background for slider */
}

.air-quality-dashboard .filters-box .sliderInput .slider .slider-track {
    background: linear-gradient(to right, #ffb300, #ffcc80) !important; /* Gradient yellow */
}

.air-quality-dashboard .filters-box .btn-secondary {
    background-color: #ffb300 !important; /* Secondary button color */
    color: #1e1e1e !important; /* Dark text */
    border-color: #ffb300 !important;
    font-weight: bold;
}

.air-quality-dashboard .filters-box .btn-secondary:hover {
    background-color: #ffc107 !important; /* Lighter yellow on hover */
    color: #ffffff !important; /* White text */
}

.air-quality-dashboard .dropdown-menu {
    background-color: #ffb300 !important; /* Yellow for dropdown background */
    color: #1e1e1e !important; /* Dark text for readability */
}

.air-quality-dashboard .dropdown-menu .dropdown-item:hover {
    background-color: #e6a800 !important; /* Darker yellow on hover */
    color: #ffffff !important; /* White text */
}

.air-quality-dashboard .pickerInput .btn {
    background-color: #ffc107 !important; /* Yellow for the picker button */
    color: #1e1e1e !important; /* Dark text */
    border: none !important;
}

.air-quality-dashboard .dropdown-menu .dropdown-item {
    color: #1e1e1e !important; /* Dark text for menu items */
}

.air-quality-dashboard .nav-tabs .nav-link {
    color: #ffc107 !important; /* Yellow text for tabs */
    font-weight: 500;
}

.air-quality-dashboard .nav-tabs .nav-link.active {
    color: #1e1e1e !important; /* Dark text for active tab */
    background-color: #ffb300 !important; /* Yellow background for active tab */
}

.air-quality-dashboard .btn-secondary {
    color: #ffc107 !important; /* Yellow text for secondary button */
    border-color: #ffc107; /* Yellow border */
}

.air-quality-dashboard .nav-tabs .nav-link {
    color: #ffc107 !important; 
    font-weight: 500;
}

.air-quality-dashboard .nav-tabs .nav-link.active {
    color: #1e1e1e !important; 
    background-color: #ffb300 !important;
}

.air-quality-dashboard .btn-secondary {
    color: #ffc107 !important;
    border-color: #ffc107;
}

      .air-quality-dashboard .nav-tabs .nav-link {
        color: #ffc107 !important; 
        font-weight: 500;
      }
      .air-quality-dashboard .nav-tabs .nav-link.active {
        color: #1e1e1e !important; 
        background-color: #ffb300 !important;
      }
    "))),
    
    div(
      class = "air-quality-dashboard",
      # Header Section
      fluidRow(
        column(
          width = 12,
          div(
            class = "header-section",
            h1("Air Quality Overview"),
            h5("Explore global air quality metrics interactively")
          )
        )
      ),
      
      # Key Metrics Section
      fluidRow(
        class = "key-metrics",
        style = "display: flex; justify-content: space-between; align-items: center; gap: 20px;",
        
        div(
          style = "flex: 1; background: linear-gradient(to right, #2c2c2c, #424242); color: #ffc107;  min-width: 300px; height: 150px;",
          h4("Average PM2.5", style = "font-weight: bold;"),
          h2(textOutput(ns("avg_pm25_value")), style = "font-size: 36px; font-weight: bold;"),
          icon("cloud", class = "icon")
        ),
        
        div(
          style = "flex: 1; background: linear-gradient(to right, #2c2c2c, #424242); color: #ffc107;  min-width: 300px; height: 150px;",
          h4("Most Polluted Country", style = "font-weight: bold;"),
          h2(textOutput(ns("most_polluted_country_value")), style = "font-size: 36px; font-weight: bold;"),
          icon("fire", class = "icon")
        ),
        
        div(
          style = "flex: 1; background: linear-gradient(to right, #2c2c2c, #424242); color: #ffc107;  min-width: 300px; height: 150px;",
          h4("Average PM10", style = "font-weight: bold;"),
          h2(textOutput(ns("avg_pm10_value")), style = "font-size: 36px; font-weight: bold;"),
          icon("globe", class = "icon")
        )
      ),
      
      # Tabs Section
      fluidRow(
        tabsetPanel(
          type = "tabs",
          tabPanel(
            "Air Quality Map",
            fluidRow(
              column(
                width = 3,
                div(
                  class = "filters-box",
                  style = "color: #ffc107;",
                  # Map Interpretation Section
                  div(
                    style = "margin-bottom: 15px;",
                    h5(icon("map", style = "color: #ffc107; margin-right: 10px;"), "Map Interpretation", style = "font-weight: bold;"),
                    tags$p("The map displays air quality levels (PM2.5) across countries. Use color codes to identify pollution severity. Hover over markers for detailed metrics, or click for additional data.")
                  ),
                  # Using Filters Section
                  div(
                    style = "margin-bottom: 15px;",
                    h5(icon("filter", style = "color: #ffc107; margin-right: 10px;"), "Using Filters", style = "font-weight: bold;"),
                    tags$p("Filter data by continent, country, or year using dropdowns. Adjust sliders to focus on specific pollution ranges. Filters help narrow down insights.")
                  ),
                  # Understanding Data Section
                  div(
                    style = "margin-bottom: 15px;",
                    h5(icon("info-circle", style = "color: #ffc107; margin-right: 10px;"), "Understanding Data", style = "font-weight: bold; display: inline-block;"),
                    tags$p("Refer to the legend to interpret colors: Each marker represents a country’s average PM2.5, with darker shades indicating safer air quality and lighter shades indicating more unsafe conditions.")
                  )
                )
              ),
              column(
                width = 6,
                plotlyOutput(ns("air_quality_map"), height = "500px")
              ),
              column(
                width = 3,
                div(
                  class = "filters-box",
                  
                  # PickerInput for WHO Region
                  pickerInput(
                    ns("continent_filter"), 
                    "Select WHO Region:",
                    choices = c("All WHO Regions" = "all", sort(unique(air_quality_data$continent))), # Sorted alphabetically
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
                    choices = c("All Countries" = "all", sort(unique(air_quality_data$country_name))), # Sorted alphabetically
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
                    choices = sort(unique(air_quality_data$year)), # Sorted numerically
                    multiple = TRUE, 
                    selected = max(air_quality_data$year), # Default to the latest year
                    options = list(
                      `actions-box` = TRUE,          # Enable "Select All" and "Deselect All"
                      `deselectAllText` = "Deselect All", # Custom text for "Deselect All"
                      `selectAllText` = "Select All"     # Custom text for "Select All"
                    )
                  ),
                  
                  # SliderInput for PM2.5 Concentration
                  sliderInput(
                    ns("pm25_filter"), 
                    "PM2.5 Concentration Range:",
                    min = min(air_quality_data$pm25_concentration, na.rm = TRUE),
                    max = max(air_quality_data$pm25_concentration, na.rm = TRUE),
                    value = c(
                      min(air_quality_data$pm25_concentration, na.rm = TRUE), 
                      max(air_quality_data$pm25_concentration, na.rm = TRUE)
                    )
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
          # ,
           ,tabPanel("Air quality trends", plotlyOutput(ns("air_quality_trends"), height = "400px")),
           tabPanel("Country Rankings Table", DTOutput(ns("air_quality_rankings")))
        )
      )
    )
  )
}
