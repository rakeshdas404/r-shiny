library(shiny)
library(bslib)
library(shinyWidgets)
library(shinydashboard)
library(plotly)
library(DT)
library(dplyr)

# # Load datasets
# air_quality_data <- read.csv("C:\\Users\\ASUS\\Documents\\Masters - Guelph\\Fall 2024\\6200\\project\\6200 Shiny dashboard\\air_quality_data.csv")
# water_data <- read.csv("C:\\Users\\ASUS\\Documents\\Masters - Guelph\\Fall 2024\\6200\\project\\6200 Shiny dashboard\\water_data.csv")
# sanitation_data <- read.csv("C:\\Users\\ASUS\\Documents\\Masters - Guelph\\Fall 2024\\6200\\project\\6200 Shiny dashboard\\sanitation_data.csv")
# global_health_data <- read.csv("C:\\Users\\ASUS\\Documents\\Masters - Guelph\\Fall 2024\\6200\\project\\6200 Shiny dashboard\\global_health_data.csv")

# Source UI and Server modules
# source("C:\\Users\\ASUS\\Documents\\Masters - Guelph\\Fall 2024\\6200\\project\\6200 Shiny dashboard\\air_quality_ui.R")
# source("C:\\Users\\ASUS\\Documents\\Masters - Guelph\\Fall 2024\\6200\\project\\6200 Shiny dashboard\\air_quality_server.R")
# source("C:\\Users\\ASUS\\Documents\\Masters - Guelph\\Fall 2024\\6200\\project\\6200 Shiny dashboard\\water_data_ui.R")
# source("C:\\Users\\ASUS\\Documents\\Masters - Guelph\\Fall 2024\\6200\\project\\6200 Shiny dashboard\\water_data_server.R")
# source("C:\\Users\\ASUS\\Documents\\Masters - Guelph\\Fall 2024\\6200\\project\\6200 Shiny dashboard\\sanitation_ui.R")
# source("C:\\Users\\ASUS\\Documents\\Masters - Guelph\\Fall 2024\\6200\\project\\6200 Shiny dashboard\\sanitation_server.R")
# source("C:\\Users\\ASUS\\Documents\\Masters - Guelph\\Fall 2024\\6200\\project\\6200 Shiny dashboard\\global_health_ui.R")
# source("C:\\Users\\ASUS\\Documents\\Masters - Guelph\\Fall 2024\\6200\\project\\6200 Shiny dashboard\\global_health_server.R")


source("air_quality_ui.R")
source("air_quality_server.R")
source("water_data_ui.R")
source("water_data_server.R")
source("sanitation_ui.R")
source("sanitation_server.R")
source("global_health_ui.R")
source("global_health_server.R")

ui <- navbarPage(
  title = div(
    style = "display: flex; align-items: center; justify-content: space-between; width: 100%;",
    div(
      style = "display: flex; align-items: center;",
      tags$img(
        src = "https://github.com/rakeshdas404/r-shiny/blob/fd57a176166c12d3e018b4a933277dc985ac8836/logo.webp?raw=true",  # Link to the logo
        height = "40px",  # Adjust height to fit the navbar
        style = "margin-right: 10px; border-radius: 50%;"  # Rounded logo styling
      ),
      span(
        "Environmental Health Dashboard",
        style = "font-weight: bold; font-size: 24px; color: #80cbc4; text-shadow: 1px 1px 2px #000000;"
      )
    ),
    # Add Contact Us button in the top-right corner
    div(
      style = "display: flex; align-items: center; margin-left: auto;",
      actionButton(
        inputId = "contact_us", 
        label = "Contact Us",
        class = "btn btn-outline-light",
        style = "color: #80cbc4; font-weight: bold; border-color: #80cbc4; margin-left: 10px;"
      )
    )
  ),
  theme = bs_theme(
    version = 5,
    bg = "#2e2e2e",  # Neutral gray background
    fg = "#80cbc4",  # Teal foreground text
    primary = "#009688",  # Teal for primary elements
    secondary = "#b2dfdb",  # Lighter teal for secondary elements
    base_font = font_google("Roboto")
  ),
  
  # Apply additional styling to the navbar
  header = tags$style(HTML("
    .navbar {
      background-color: #2e2e2e !important; /* Navbar background */
      border-bottom: 2px solid #009688 !important; /* Navbar bottom border */
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Subtle shadow */
    }
    .navbar-brand {
      display: flex;
      align-items: center;
      font-size: 18px;
    }
    .navbar-nav > li > a {
      color: #80cbc4 !important; /* Link color */
      font-size: 16px;
      font-weight: bold;
    }
    .navbar-nav > li > a:hover {
      background-color: #009688 !important; /* Highlight on hover */
      color: #ffffff !important;
    }
    .navbar-toggler {
      background-color: #009688 !important; /* Toggler button */
      border: none;
    }
  ")),
  
  # Navigation tabs with icons
  tabPanel(
    div(
      icon("cloud"),  # Font Awesome icon
      "Air Quality"
    ), 
    air_quality_module_ui("air_quality_dashboard")
  ),
  tabPanel(
    div(
      icon("tint"),  # Font Awesome icon
      "Water Accessibility"
    ),
    water_data_module_ui("water_data_dashboard")
  ),
  tabPanel(
    div(
      icon("toilet"),  # Font Awesome icon
      "Sanitation Availability"
    ),
    sanitation_module_ui("sanitation_dashboard")
  ),
  tabPanel(
    div(
      icon("heartbeat"),  # Font Awesome icon
      "Global Health"
    ),
    global_health_module_ui("global_health_dashboard")
  )
)

server <- function(input, output, session) {
  # Call server modules for each app with dataset arguments
  air_quality_module_server("air_quality_dashboard", air_quality_data)
  water_data_module_server("water_data_dashboard", water_data)
  sanitation_module_server("sanitation_dashboard", sanitation_data)
  global_health_module_server("global_health_dashboard", global_health_data)
  
  # Contact Us modal
  observeEvent(input$contact_us, {
    showModal(modalDialog(
      title = "Contact Us",
      tagList(
        tags$p("For inquiries, please reach out to us via:"),
        tags$p(tags$b("Email:"), "contact@environmentalhealth.com"),
        tags$p(tags$b("Phone:"), "+1-234-567-8900")
      ),
      easyClose = TRUE,
      footer = modalButton("Close")
    ))
  })
}

# Run the App
shinyApp(ui, server)
