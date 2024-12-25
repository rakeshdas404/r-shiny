# Define the Sanitation Data UI Module
sanitation_module_ui <- function(id) {
  ns <- NS(id)  # Create a namespace for this module
  
  fluidPage(
    theme = bs_theme(
      version = 5,
      bg = "#212121",  # Dark background for the page
      fg = "#4CAF50",  # Greenish foreground for text
      primary = "#66BB6A",  # Green for primary elements
      secondary = "#81C784",  # Lighter green for secondary elements
      success = "#66BB6A",  # Green for success messages
      info = "#42A5F5",  # Blue for info
      warning = "#FFB74D",  # Amber for warnings
      danger = "#E53935",  # Red for danger
      base_font = font_google("Roboto")
    ),
    
    # Scoped CSS for Sanitation Dashboard
    tags$head(tags$style(HTML("
      @import url('https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;700&display=swap');
      
      .sanitation-dashboard { 
        font-family: 'Roboto', sans-serif; 
        background-color: #212121; 
        color: #4CAF50; 
      }
      .sanitation-dashboard .header-section h1 {
        color: #66BB6A; 
        font-size: 50px; 
        font-weight: 700; 
        text-align: center; 
        margin-bottom: 20px;
      }
      .sanitation-dashboard .header-section h5 {
        color: #81C784; 
        font-size: 18px; 
        text-align: center; 
        margin-bottom: 30px;
      }
      .sanitation-dashboard .key-metrics div {
        background: linear-gradient(to right, #2c2c2c, #424242);
        color: #4CAF50; 
        border-radius: 10px; 
        padding: 20px; 
        margin: 10px;
        transition: transform 0.3s ease-in-out;
        position: relative;
      }
      .sanitation-dashboard .key-metrics div:hover {
        transform: scale(1.05);
      }
      .sanitation-dashboard .key-metrics div .icon {
        position: absolute;
        top: 10px;
        right: 10px;
        font-size: 36px;
        color: #4CAF50;
      }
      .sanitation-dashboard .filters-box {
    background-color: #333333;
    border: 1px solid #424242;
    border-radius: 10px;
    padding: 15px;
    font-family: 'Roboto', sans-serif;
    line-height: 1.6;
}

.sanitation-dashboard .filters-box .pickerInput,
.sanitation-dashboard .filters-box .dropdown-menu {
    background-color: #66BB6A !important; /* Green background for dropdowns */
    color: #1e1e1e !important; /* Dark text */
}

.sanitation-dashboard .filters-box .pickerInput .btn,
.sanitation-dashboard .filters-box .btn {
    background-color: #4CAF50 !important; /* Darker green for buttons */
    color: #ffffff !important; /* White text */
    border: none !important;
}

.sanitation-dashboard .filters-box .sliderInput .slider {
    background-color: #66BB6A !important; /* Green background for slider */
}

.sanitation-dashboard .filters-box .sliderInput .slider .slider-track {
    background: linear-gradient(to right, #66BB6A, #81C784) !important; /* Gradient green */
}

.sanitation-dashboard .filters-box .btn-secondary {
    background-color: #66BB6A !important; /* Secondary button color */
    color: #1e1e1e !important; /* Dark text */
    border-color: #66BB6A !important;
    font-weight: bold;
}

.sanitation-dashboard .filters-box .btn-secondary:hover {
    background-color: #4CAF50 !important; /* Darker green on hover */
    color: #ffffff !important; /* White text */
}

.sanitation-dashboard .dropdown-menu {
    background-color: #4CAF50 !important; /* Dark green for dropdown background */
    color: #ffffff !important; /* White text for readability */
}

.sanitation-dashboard .dropdown-menu .dropdown-item:hover {
    background-color: #388E3C !important; /* Darker green on hover */
    color: #ffffff !important; /* White text */
}

.sanitation-dashboard .pickerInput .btn {
    background-color: #66BB6A !important; /* Light green for the picker button */
    color: #ffffff !important; /* White text */
    border: none !important;
}

.sanitation-dashboard .dropdown-menu .dropdown-item {
    color: #000000 !important; /* Black text for menu items */
}

.sanitation-dashboard .nav-tabs .nav-link {
    color: #66BB6A !important; /* Green text for tabs */
    font-weight: 500;
}

.sanitation-dashboard .nav-tabs .nav-link.active {
    color: #1e1e1e !important; /* Dark text for active tab */
    background-color: #4CAF50 !important; /* Green background for active tab */
}

.sanitation-dashboard .btn-secondary {
    color: #66BB6A !important; /* Green text for secondary button */
    border-color: #66BB6A; /* Green border */
}

      .sanitation-dashboard .nav-tabs .nav-link {
        color: #4CAF50 !important; 
        font-weight: 500;
      }
      .sanitation-dashboard .nav-tabs .nav-link.active {
        color: #1e1e1e !important; 
        background-color: #66BB6A !important;
      }
      .sanitation-dashboard .btn-secondary {
        color: #4CAF50 !important;
        border-color: #4CAF50;
      }
    "))),
    
    div(
      class = "sanitation-dashboard",
      # Header Section
      fluidRow(
        column(
          width = 12,
          div(
            class = "header-section",
            h1("Sanitation Access Overview"),
            h5("Explore global sanitation access metrics interactively")
          )
        )
      ),
      
      # Key Metrics Section
      fluidRow(
        class = "key-metrics",
        style = "display: flex; justify-content: space-between; align-items: center; gap: 20px;",
        
        div(
          style = "flex: 1; min-width: 300px; height: 150px;",
          h4("Access to Basic Sanitation", style = "font-weight: bold; color: #4CAF50;"),
          h2(textOutput(ns("avg_sanitation_value")), style = "font-size: 36px; font-weight: bold; color: #4CAF50;"),
          icon("toilet", class = "icon")
        ),
        
        div(
          style = "flex: 1; min-width: 300px; height: 150px;",
          h4("Most Improved Country", style = "font-weight: bold; color: #4CAF50;"),
          h2(textOutput(ns("most_improved_country_value")), style = "font-size: 36px; font-weight: bold; color: #4CAF50;"),
          icon("chart-line", class = "icon")
        ),
        
        div(
          style = "flex: 1; min-width: 300px; height: 150px;",
          h4("Total Countries", style = "font-weight: bold; color: #4CAF50;"),
          h2(textOutput(ns("total_countries_value")), style = "font-size: 36px; font-weight: bold; color: #4CAF50;"),
          icon("globe", class = "icon")
        )
      ),
      
      # Tabs Section
      fluidRow(
        tabsetPanel(
          type = "tabs",
          tabPanel(
            "Sanitation Access Map",
            fluidRow(
              column(
                width = 3,
                div(
                  class = "filters-box",
                  style = "color: #4CAF50;",
                  
                  # Map Interpretation Section
                  div(
                    style = "margin-bottom: 15px;",
                    h5(icon("map", style = "color: #4CAF50; margin-right: 10px;"), "Map Interpretation", style = "font-weight: bold;"),
                    tags$p("The map displays sanitation access levels across countries. Use color codes to identify regions.")
                  ),
                  
                  # Using Filters Section
                  div(
                    style = "margin-bottom: 15px;",
                    h5(icon("filter", style = "color: #4CAF50; margin-right: 10px;"), "Using Filters", style = "font-weight: bold;"),
                    tags$p("Refine data by continent, country, year, or sanitation access percentage.")
                  ),
                  div(
                    style = "margin-bottom: 15px;",
                    h5(icon("info-circle", style = "color: #4CAF50; margin-right: 10px;"), "Understanding Data", style = "font-weight: bold; display: inline-block;"),
                    tags$p("Refer to the legend to interpret colors: Green (safe), Yellow (moderate), Orange (high), and Red (dangerous). Each marker represents a country’s average PM2.5.")
                  )
                )
              ),
              column(
                width = 6,
                plotlyOutput(ns("sanitation_map"), height = "500px")
              ),
              column(
                width = 3,
                div(
                  class = "filters-box",
                  
                  # PickerInput for UNICEF Reporting Region
                  pickerInput(
                    ns("continent_filter"), 
                    "Select UNICEF Reporting Region:",
                    choices = c("All Regions" = "all", sort(unique(sanitation_data$unicef_reporting_region))), # Sorted alphabetically
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
                    choices = c("All Countries" = "all", sort(unique(sanitation_data$country_area_or_territory))), # Sorted alphabetically
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
                    choices = sort(unique(sanitation_data$year)), # Sorted numerically
                    multiple = TRUE, 
                    selected = max(sanitation_data$year), # Default to the latest year
                    options = list(
                      `actions-box` = TRUE,          # Enable "Select All" and "Deselect All"
                      `deselectAllText` = "Deselect All", # Custom text for "Deselect All"
                      `selectAllText` = "Select All"     # Custom text for "Select All"
                    )
                  ),
                  
                  # SliderInput for Sanitation Access
                  sliderInput(
                    ns("sanitation_filter"), 
                    "Sanitation Access (%):",
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
          ),
          tabPanel("Trends", plotlyOutput(ns("sanitation_trends"), height = "400px")),
          tabPanel("Country Rankings Table", DTOutput(ns("sanitation_rankings")))
        )
      )
    )
  )
}
