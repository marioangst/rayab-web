library(shiny)
library(rayab)
library(magick)

# Specify the application port
options(shiny.host = "0.0.0.0")
options(shiny.port = 3000)

# Define UI for app that draws a histogram ----
ui <- fluidPage(

  # App title ----
  titlePanel("🤖 🧶"),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(

      # Input: Text -----
      h2("Knit text"),
      textInput(inputId = "text",
                label = "Enter text. Use \\n to break lines.",
                value = "AYAB"),
      numericInput(inputId = "textWidth",
                   value = 200,
                   label = "desired text image width"),
      numericInput(inputId = "textHeight",
                   value = 100,
                   label = "desired text image height"),
      downloadButton("downloadTextImage",
                     "Download text image"),
      h2("Upload and convert image"),
      fileInput("upload", "Upload image to convert for knitting",
                accept = c('image/png', 'image/jpeg')),
      numericInput(inputId = "convertWidth",
                   value = 200,
                   label = "desired converted image width"),
      numericInput(inputId = "convertHeight",
                   value = 100,
                   label = "desired converted image height"),
      downloadButton("downloadConvertImage",
                     "Download converted image"),
    ),

    # Main panel for displaying outputs ----
    mainPanel(

      # Output: Image ----
      imageOutput(outputId = "textImage"),
      imageOutput(outputId = "convertImage")

    )
  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output, session) {

  # text conversion section -----------

  textImage <- reactive({
    # write image to tmpfile to send out again
    tmpfile <-
      rayab::text_to_ayab(input_text = input$text,
                          width = input$textWidth,
                          height = input$textHeight) |>
      image_write(tempfile(fileext='png'), format = 'png')
    list(src = tmpfile, contentType = "image/png")
  })

  output$textImage <- renderImage({
    textImage()
  },deleteFile = FALSE)

  output$downloadTextImage <- downloadHandler(
    filename = function() {
      "knit_me.png"
    },
    content = function(file) {
      img <- textImage()$src
      file.copy(img, file)
    }
  )

  # image conversion section ----------

  # Start with placeholder imae
  uploadedImage <- magick::logo

  # When uploading new image
  observeEvent(input$upload, {
    if (length(input$upload$datapath))
      uploadedImage <<- image_read(input$upload$datapath)
  })

  convertImage <- reactive({
    # write image to tmpfile to send out again
    tmpfile <-
      uploadedImage |>
      rayab::magick_to_ayab(
        width = input$convertWidth,
        height = input$convertHeight) |>
      image_write(tempfile(fileext='png'), format = 'png')
    list(src = tmpfile, contentType = "image/png")
  })

  output$convertImage <- renderImage({
    convertImage()
  },deleteFile = FALSE)

  output$downloadConvertImage <- downloadHandler(
    filename = function() {
      "knit_me.png"
    },
    content = function(file) {
      img <- convertImage()$src
      file.copy(img, file)
    }
  )
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
