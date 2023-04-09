
library(shiny)
library(plotly)
library(ggplot2)
library(data.table)
library(dplyr)

stud_perf_melt <- fread("https://raw.githubusercontent.com/oyogo/data/main/student_performance_preprocessed_data.csv") #the data is stored inside the data folder in the app directory. The two dots mean the folder is two steps up 


# Define UI for application
ui <- fluidPage(

    # Application title
    titlePanel("Student performance analysis app"),

    # Layout of the app 
    sidebarLayout(
        
        # sidebar section
        sidebarPanel(
            p("This tool was developed to aid teachers and parents and other stakeholders to analyze student performance 
              , get insights and do necessary interventions to better the students' performance."), # for a paragraph text I've used p tag.
            
           
            strong(em("Dataset use in this app was obtained from kaggle, click on the link below to see the data")), # I have used strong to make the text bold and em for italisizing
            
            br(), #This inserts breaks between items
            
            a(href="https://www.kaggle.com/spscientist/students-performance-in-exams?select=StudentsPerformance.csv","Kaggle dataset"), # the a tag is used for links
            
            br(),
            br(),
            
            img(src="rstudio.jpg", height=70,width=70) # img tag is for reading images
        ),

        
        # main section , where we display the two plots.
        mainPanel(
            fluidRow( 
                column(12,
                    column(6,
                          div(h4("Subject performance analysis according to gender"), style="color:blue"), 
                           
                       p("The graph below suggests to us that females generally perform better in reading and writing than their male counterparts.
                         On the flip of it, the males are better at math than their female counterparts."),
                       br(), # this is for putting a space between the text and the plot which will appear below it
                       plotlyOutput("barplot_ggplot")
                       
                ),
                column(6,
                       div(h4("Performance analysis according to ethnic groups"),style="color:green"),
                       p("Its interesting to see how student performance varies according to their ethnic groups.
                         Group C is leading with a huge gap with those of group A."),
                       em("The diagram below is a bubble plot, please note that the size of the bubble corresponds to the mean score of the group."),
                       br(),
                       br(), 
                       plotlyOutput("bubble_plot")  
                       
                )
              )
            )
        )
        
        
    )
)


# Define server logic required to draw a histogram
server <- function(input, output) {

    
    # server code for the barplot
    output$barplot_ggplot <- renderPlotly({
        
        # calculating data summaries for plotting the barplot
        barplot_data <- stud_perf_melt[,.(mean_score=mean(score)),by=c("gender","subject")]
        
        # build the plot with plotly
           plot_ly( barplot_data,
               y = ~mean_score,
               x = ~subject,
               color = ~gender,
               text = ~paste0("Gender: ", gender, "\n", "Subject: ", subject,"\n","Mean score: ",mean_score)) %>%
           add_bars(showlegend=TRUE, hoverinfo='text' ) %>%
           layout(title="Mean gender performance",yaxis=list(title="Mean score"))#,
                  #xaxis = list(title = "Subject"),
                  #legend = list( title = list(text = "<b>Gender</b>"),orientation = "h"))
           
            
    })
    
    # server code for the density ridges plot 
    
    output$bubble_plot <- renderPlotly({
        
     # calculating data summaries for plotting the bubble plot
      bubbleplot_data <-  stud_perf_melt[,.(mean_score=mean(score)),by=c("race_ethnicity")] 
        
            plot_ly(bubbleplot_data) %>%
            add_trace(x = ~reorder(race_ethnicity, mean_score), 
                      y = ~mean_score,
                      size = ~mean_score,
                      color = ~race_ethnicity,
                      alpha = 4.5,
                      type = "scatter",
                      mode = "markers",
                      marker = list(symbol = 'circle', sizemode = 'diameter',
                                    line = list(width = 2, color = '#FFFFFF'), opacity=2.4)) %>%
            add_text(x = ~reorder(race_ethnicity, -mean_score), 
                     y = ~race_ethnicity, text = ~mean_score,
                     showarrow = FALSE,
                     color = I("black")) %>%
            layout(
                showlegend = FALSE,
                title="Mean score with respect to ethnic groups",
                xaxis = list(
                    title = "Race/Ethnic group"
                ),
                yaxis = list(
                    title = "Mean score"
                )
            ) 
    })
    
    
    # radar chart
    
    output$radar_chart <- renderPlotly({

        parents_edlevel <- stud_perf_melt[,.(mean_score=round(mean(score),0)),by=c("parent_edulevel")]
        
        plot_ly(parents_edlevel,type = "scatterpolar", mode = "lines+markers", colors = 'RdYlGn') %>%
            add_trace(r=~mean_score, 
                      theta = ~parent_edulevel, 
                      fill = 'toself',
                      text = ~paste0("Parents' education level: ", parent_edulevel, "\n", "mean score: ", mean_score),
                      hoverinfo = 'text'
            ) %>%
            layout(
                showlegend = FALSE,
                polar = list(
                    radialaxis = list(
                        range = c(0,100),
                        angle = 90,
                        tickangle = 90,
                        color = "red",
                        size = 20
                    ),
                    angularaxis = list(
                        rotation = 90,
                        direction = 'clockwise',
                        size = 26
                    )
                )
            ) %>%
            config(displayModeBar = FALSE, displaylogo = FALSE, 
                   scrollZoom = FALSE, showAxisDragHandles = TRUE, 
                   showSendToCloud = FALSE)
    })
   
}

# Run the application 
shinyApp(ui = ui, server = server)
