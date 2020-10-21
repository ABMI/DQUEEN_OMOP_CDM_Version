ui <-
  tagList(
    tags$head(tags$script(type="text/javascript", src = "logo.js")),
    navbarPage(
      theme = shinytheme("cerulean"),
      title = 'DQUEEN',
      tabPanel('DQ Summary'
               ,includeCSS(file.path(.libPaths()[1],'DQUEEN','www/style.css'))
               ,tabsetPanel(type = "tabs"
                            #Page 1-1
                            ,tabPanel("Summary",icon = icon('table',lib = 'font-awesome')
                                      ,fluidRow(
                                        column(2,align='center',tags$h3('Check Level'))
                                        ,column(2,align='center',tags$h3('DQ Score'))
                                        ,column(2,align='center',tags$h3('Data Status'))
                                        ,column(2,align='center',tags$h3('Data population'))
                                        ,column(2,align='center',tags$h3('Data period'))
                                        ,column(2,align='center',tags$h3('Data Volumn'))
                                      )
                                      ,fluidRow(
                                        column(2,align='center',tags$h3(checkLevel))
                                        ,column(2,align='center',tags$h3(totalDqScore))
                                        ,column(2,align='center',tags$h3(dataStatus[1]),tags$h3(dataStatus[2]))
                                        ,column(2,align='center',tags$h3(dataPopulation[1]),tags$h3(dataPopulation[2]))
                                        ,column(2,align='center',tags$h3(dataPeriod))
                                        ,column(2,align='center',tags$h4(dataVolume[1]),tags$h4(dataVolume[2]))
                                      )
                                      ,fluidRow(
                                        column(4,align='center'
                                               ,tags$h2('Data Quality Score'))
                                        ,tags$h2('Data Quality Proportion')
                                      )
                                      ,fluidRow(
                                        column(4,align='right'
                                               ,shinyBS::bsButton("s1", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "s1", title = "Data Quality Score"
                                                                   ,content = 'This score is average of the source data and OMOP-CDM data quality score'
                                                                   ,placement = "right"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                        ,column(4,align='right'
                                                ,shinyBS::bsButton("s2", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                                ,shinyBS::bsPopover(id = "s2", title = "Source data DQ error proportion"
                                                                    ,content = 'Rate of DQ error data by Data Quality Assessment category in the data'
                                                                    ,placement = "right"
                                                                    ,trigger = "focus"
                                                                    ,options = list(container = "body")
                                                )
                                        )
                                        ,column(4,align='right'
                                                ,shinyBS::bsButton("s3", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                                ,shinyBS::bsPopover(id = "s3", title = "CDM DQ error proportion"
                                                                    ,content = 'Rate of DQ error data by Data Quality Assessment category in the data'
                                                                    ,placement = "left"
                                                                    ,trigger = "focus"
                                                                    ,options = list(container = "body")
                                                )
                                        )

                                      )
                                      ,fluidRow(
                                        column(offset = 4,4,align='center',tags$h3('META')
                                        )
                                        ,column(4,align='center',tags$h3('CDM')
                                        )
                                      )
                                      ,fluidRow(
                                        column(4,align = 'center'
                                               ,ggiraphOutput('totalscoredount',width="80%",height = '400px')

                                        )
                                        ,column(4
                                                ,tags$div(id="rader1", style="height:400px;")  # Specify the div for the chart. Can also be considered as a space holder
                                                ,deliverChart(div_id = "rader1")  # Deliver the plotting
                                        )
                                        ,column(4
                                                ,tags$div(id="rader2", style="height:400px;")  # Specify the div for the chart. Can also be considered as a space holder
                                                ,deliverChart(div_id = "rader2")  # Deliver the plotting
                                        )

                                      )

                                      ,fluidRow(
                                        column(4,align='center',tags$h2('DQ Error Propotion'))
                                        ,column(4,align='center',tags$h2('Person Count'))
                                        ,column(4,align='center',tags$h2('Operation Period'))
                                      )
                                      ,fluidRow(
                                        column(4,align='right'
                                               ,shinyBS::bsButton("s4", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "s4", title = "Sum of the Data Quality error propotion"
                                                                   ,content = 'Sum of data error by data quality assessment category from the source and CDM data. through this plot you would know what is major cause of data quality error'
                                                                   ,placement = "right"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                        ,column(4,align='right'
                                                ,shinyBS::bsButton("s5", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                                ,shinyBS::bsPopover(id = "s5", title = 'Number of patients by gender'
                                                                    ,content = 'The comparison of the number of the patients can check the CDM conversion error'
                                                                    ,placement = "right"
                                                                    ,trigger = "focus"
                                                                    ,options = list(container = "body")
                                                )
                                        )
                                        ,column(4,align='right'
                                                ,shinyBS::bsButton("s6", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                                ,shinyBS::bsPopover(id = "s6", title = 'The number of patients per year that can be observed'
                                                                    ,content = 'The number of observation patients per year in the oprating period also you can compared source and CDM data'
                                                                    ,placement = "left"
                                                                    ,trigger = "focus"
                                                                    ,options = list(container = "body")
                                                )
                                        )
                                      )
                                      ,fluidRow(
                                        column(4,align = 'center'
                                               ,tags$div(id="circleBar1", style="width:100%;height:300px;") # Specify the div for the chart. Can also be considered as a space holder
                                               ,deliverChart(div_id = "circleBar1") # Deliver the plotting
                                        )
                                        ,column(4,align = 'center'
                                                ,tags$div(id="bar1", style="width:100%;height:300px;")
                                                ,deliverChart(div_id = "bar1")

                                        )
                                        ,column(4,align = 'center'
                                                ,tags$div(id="lineChart1", style="width:100%;height:300px;")
                                                ,deliverChart(div_id = "lineChart1")
                                        )
                                      )

                                      ,tags$h2('Source to CDM Data Network')
                                      ,column(12
                                              ,align='right'
                                              ,shinyBS::bsButton("s7", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                              ,shinyBS::bsPopover(id = "s7", title = "Source to CDM data flow"
                                                                  ,content = 'You can check the relationship and conversion flow between source to Meta data also you can compared row number source data and CDM data'
                                                                  ,placement = "left"
                                                                  ,trigger = "focus"
                                                                  ,options = list(container = "body")
                                              )
                                      )
                                      #visNetwork
                                      ,fluidRow(
                                        column(8,
                                               visNetworkOutput("network")
                                        )
                                        ,column(4,
                                                tableOutput("shiny_return")
                                        )
                                      )
                            )

               )

      ),
      #DQ Summary---------------------------------------------------------------

      #Meta DQ Information------------------------------------------------------
      tabPanel('Meta DQ Information'
               ,tabsetPanel(type = "tabs"
                            ,id = 'metaTabs'
                            ,tabPanel("Main",icon = icon('table',lib = 'font-awesome')
                                      ,fluidRow(
                                        column(12,tags$h2('DQ Summary - Meta(Source)'))
                                      )
                                      #Common UI#######
                                      ,fluidRow(
                                        column(2,align='center',tags$h3('Check Level'))
                                        ,column(2,align='center',tags$h3('DQ Score'))
                                        ,column(2,align='center',tags$h3('Data Status'))
                                        ,column(2,align='center',tags$h3('Data population'))
                                        ,column(2,align='center',tags$h3('Data period'))
                                        ,column(2,align='center',tags$h3('Data Capacity'))
                                      )
                                      ,fluidRow(
                                        column(2,align='center',tags$h3(checkLevel))
                                        ,column(2,align='center',tags$h3(metaScore))
                                        ,column(2,align='center',tags$h3(dataStatus[2]))
                                        ,column(2,align='center',tags$h3(dataPopulation[2]))
                                        ,column(2,align='center',tags$h3(dataPeriod))
                                        ,column(2,align='center',tags$h3(dataVolume[1]))
                                      )
                                      ,fluidRow(
                                        column(12,align='right'
                                               ,shinyBS::bsButton("m1", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "m1", title = "Meta schema information"
                                                                   ,content = 'you can know brief information about the meta schema '
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                      )

                                      #Common UI#######
                                      ,fluidRow(
                                        lapply(2:length(validationType), function(i){
                                          column(2,ggiraphOutput(paste0('meta','main',validationType[i],'donut')),style="height:200px;")
                                        })
                                      )
                                      ,fluidRow(
                                        lapply(2:length(validationType), function(i){
                                          column(2,align='center',tags$h3(validationType[i]))
                                        })
                                      )

                                      ,fluidRow(
                                        column(4,align='center',tags$h2('DQ error proportion')
                                        )
                                        ,column(8,align = 'left',tags$h2('DQ error distribution')
                                        )
                                      )
                                      ,fluidRow(
                                        column(4,align='right'
                                               ,shinyBS::bsButton("m2", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "m2", title = "DQA category error propotion"
                                                                   ,content = 'if you choose DQA concept you can see how many DQ concept distributed in initial table'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                        ,column(8,align = 'right'
                                                ,shinyBS::bsButton("m3", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                                ,shinyBS::bsPopover(id = "m3", title = "distribution of DQA error in table"
                                                                    ,content = 'You can know how many DQA error in initial table'
                                                                    ,placement = "left"
                                                                    ,trigger = "focus"
                                                                    ,options = list(container = "body")
                                                )
                                        )
                                      )
                                      ,fluidRow(
                                        column(4,align='center'
                                               ,plotlyOutput("piePlot1")
                                        )
                                        ,column(8,align = 'left'
                                                ,plotlyOutput("barPlot1")
                                        )
                                      )

                                      ,fluidRow(
                                        column(12,tags$h2('DQ error message box')
                                        )
                                      )
                                      ,fluidRow(
                                        column(12,align='right'
                                               ,shinyBS::bsButton("m4", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "m4", title = "DQA error message box"
                                                                   ,content = 'You can check the DQA rules and how many errors occurred'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )

                                        )
                                      )
                                      ,fluidRow(
                                        column(12
                                               ,DT::dataTableOutput('messageBox1'))
                                      )

                                      ,fluidRow(
                                        column(12,tags$h2('Schema information'))
                                      )
                                      ,fluidRow(
                                        column(12,align='right'
                                               ,shinyBS::bsButton("m5", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "m5", title = "visualized schema information"
                                                                   ,content = 'You can know schema volume and row information'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                      )
                                      ,fluidRow(
                                        column(12,highchartOutput('heatmap1')
                                        )
                                      )

                                      ,fluidRow(
                                        column(12,align='right'
                                               ,shinyBS::bsButton("m6", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "m6", title = "schema information"
                                                                   ,content = 'You can check volume and table rows'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )

                                      )
                                      ,fluidRow(
                                        column(12,DT::dataTableOutput('heatmapTable1')
                                        )
                                      )

                                      ,fluidRow(
                                        column(6,tags$h2('Table yearly row count')
                                        )
                                        ,column(6,tags$h2('Table yearly row count by visit type')
                                        )
                                      )
                                      ,fluidRow(
                                        column(6,align='right'
                                               ,shinyBS::bsButton("m7", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "m7", title = "yearly row count with yearly visit"
                                                                   ,content = 'The number of visits of patients and the rate of change of data should be proportional. if one of the year is not proportional it may you need check'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                        ,column(6,align='right'
                                                ,shinyBS::bsButton("m8", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                                ,shinyBS::bsPopover(id = "m8", title = "yearly row count by visit type with patients yearly visit type"
                                                                    ,placement = "left"
                                                                    ,trigger = "focus"
                                                                    ,options = list(container = "body")
                                                )
                                        )
                                      )
                                      ,fluidRow(
                                        column(6,plotlyOutput('heatmapRowPlot1')
                                        )
                                        ,column(6,plotlyOutput('heatmapTableVisitPlot1')
                                        )
                                      )

                            )
                            ,tabPanel("Person",    icon = icon('user-alt',lib = 'font-awesome')
                                      ,tags$h2('DQ info')
                                      ,fluidRow(
                                        column(12,align='right'
                                               ,shinyBS::bsButton("mp1", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "mp1", title = "DQA error proportion in person table"
                                                                   ,content = 'You can check DQA error proportion and DQ score'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                      )
                                      #Common UI#######
                                      ,fluidRow(
                                        lapply(2:length(validationType), function(i){
                                          column(2,ggiraphOutput(paste0('meta','person',validationType[i],'donut')),style="height:200px;")
                                        })
                                      )
                                      ,fluidRow(
                                        lapply(2:length(validationType), function(i){
                                          column(2,align='center',tags$h3(validationType[i]))
                                        })
                                      )


                                      ,fluidRow(
                                        column(4,align='center',tags$h2('DQ error proportion')
                                        )
                                        ,column(8,align = 'left',tags$h2('DQ error distribution')
                                        )
                                      )
                                      ,fluidRow(
                                        column(4,align='right'
                                               ,shinyBS::bsButton("mp2", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "mp2", title = "Error rate by DQA category"
                                                                   ,content = 'If you click the DQA category then you can see how many errors in this table with hist and hist shows based on DQA subcategory'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                        ,column(8,align = 'right'
                                                ,shinyBS::bsButton("mp3", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                                ,shinyBS::bsPopover(id = "mp3", title = "DQA error distibution in table"
                                                                    ,content = 'Hist shows based on DQA subcategory'
                                                                    ,placement = "left"
                                                                    ,trigger = "focus"
                                                                    ,options = list(container = "body")
                                                )
                                        )
                                      )
                                      ,fluidRow(
                                        column(4,align='center'
                                               ,plotlyOutput("piePlot2")
                                        )
                                        ,column(8,align = 'left'
                                                ,plotlyOutput("barPlot2")
                                        )
                                      )

                                      ,fluidRow(
                                        column(12
                                               ,column(12,tags$h2('DQ error message box'))
                                        )
                                      )
                                      ,fluidRow(
                                        column(12,align='right'
                                               ,shinyBS::bsButton("mp4", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "mp4", title = "DQA error message box"
                                                                   ,content = 'you can see DQA rules and how many errors occurred in table '
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                      )
                                      ,fluidRow(
                                        column(12
                                               ,column(12
                                                       ,DT::dataTableOutput('messageBox2'))
                                        )
                                      )

                                      #Common UI#######
                                      ,fluidRow(
                                        column(6,tags$h2('Person count')
                                        )
                                        ,column(6,tags$h2('Year of birth distribution')
                                        )
                                      )
                                      ,fluidRow(
                                        column(6,align='right'
                                               ,shinyBS::bsButton("mp5", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "mp5", title = "Person count"
                                                                   ,content = 'Y means exlcude patinets and N means include patients so you can see click Y or N'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                        ,column(6,align='right'
                                                ,shinyBS::bsButton("mp6", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                                ,shinyBS::bsPopover(id = "mp6", title = "Year of birth distribution"
                                                                    ,content = 'You can check birth date error and distribution of patinets age'
                                                                    ,placement = "left"
                                                                    ,trigger = "focus"
                                                                    ,options = list(container = "body")
                                                )
                                        )
                                      )
                                      ,fluidRow(
                                        column(6
                                               ,tags$div(id="bar2", style="width:100%;height:300px;")
                                               ,deliverChart(div_id = "bar2")
                                        )
                                        ,column(6
                                                ,tags$div(id="bar__vertical1", style="width:100%;height:300px;")
                                                ,deliverChart(div_id = "bar__vertical1")
                                        )
                                      )

                                      ,fluidRow(
                                        column(12,tags$h2('Table basic DQ information')
                                        )
                                      )
                                      ,fluidRow(
                                        column(12,align='right'
                                               ,shinyBS::bsButton("mp7", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "mp7", title = "It's basic information about table"
                                                                   ,content = 'You can check dupliclated row or column and missing data also special char '
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                      )
                                      ,fluidRow(
                                        column(12
                                               ,DT::dataTableOutput('messageBox7')
                                        )
                                      )


                            )
                            ,tabPanel("Visit",icon = icon('hospital',lib = 'font-awesome')
                                      ,tags$h2('DQ info')
                                      ,fluidRow(
                                        column(12,align='right'
                                               ,shinyBS::bsButton("mv1", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "mv1", title = "title_title"
                                                                   ,content = 'text_text_text'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                      )
                                      #Common UI#######
                                      ,fluidRow(
                                        lapply(2:length(validationType), function(i){
                                          column(2,ggiraphOutput(paste0('meta','visit',validationType[i],'donut')),style="height:200px;")
                                        })
                                      )
                                      ,fluidRow(
                                        lapply(2:length(validationType), function(i){
                                          column(2,align='center',tags$h3(validationType[i]))
                                        })
                                      )

                                      ,fluidRow(
                                        column(4,align='center',tags$h2('DQ error proportion')
                                        )
                                        ,column(8,align = 'left',tags$h2('DQ error distribution')
                                        )
                                      )
                                      ,fluidRow(
                                        column(4,align='right'
                                               ,shinyBS::bsButton("mv2", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "mv2", title = "Visit table DQ information"
                                                                   ,content = 'You can know DQ score and DQA error rate'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )

                                        )
                                        ,column(8,align = 'right'
                                                ,shinyBS::bsButton("mv3", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                                ,shinyBS::bsPopover(id = "mv3", title = "Error rate by DQA category"
                                                                    ,content = 'if you choose DQA category you can see how many DQA errors in this table through the hist'
                                                                    ,placement = "left"
                                                                    ,trigger = "focus"
                                                                    ,options = list(container = "body")
                                                )
                                        )
                                      )
                                      ,fluidRow(
                                        column(4,align='center'
                                               ,plotlyOutput("piePlot3")

                                        )
                                        ,column(8,align = 'left'
                                                ,plotlyOutput("barPlot3")
                                        )
                                      )

                                      ,fluidRow(
                                        column(12,tags$h2('DQ error message box')
                                        )
                                      )
                                      ,fluidRow(
                                        column(12,align='right'
                                               ,shinyBS::bsButton("mv4", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "mv4", title = "DQA errror hist"
                                                                   ,content = 'Th9is hist shows how many DQA errors in the table based on DQA subcategory'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                      )
                                      ,fluidRow(
                                        column(12,DT::dataTableOutput('messageBox3'))
                                      )
                                      ,fluidRow(
                                        column(12,align='right'
                                               ,shinyBS::bsButton("mv11", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "mv11", title = "Table basic information"
                                                                   ,content = 'You can check dupliclated row or column and missing data also special char '
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )

                                        )
                                      )
                                      ,fluidRow(
                                        column(12,tags$h2('Table basic DQ information')
                                        )
                                      )
                                      ,fluidRow(
                                        column(12
                                               ,DT::dataTableOutput('messageBox8')
                                        )
                                      )

                                      #Common UI#######
                                      ,fluidRow(
                                        column(6,tags$h2('Visit count by year ')
                                        )
                                        ,column(6,tags$h2('Visit type count by year')
                                        )
                                      )
                                      ,fluidRow(
                                        column(6,align='right'
                                               ,shinyBS::bsButton("mv5", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "mv5", title = "DQ error message box about this table"
                                                                   ,content = 'You can check DQA rules and how many DQA errors occurred in this table'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                        ,column(6,align='right'
                                                ,shinyBS::bsButton("mv6", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                                ,shinyBS::bsPopover(id = "mv6", title = "yearly visit count"
                                                                    ,content = 'we provieds the observed percentile 10 based on the number of yearly count. please check for value below 10 percentile or change treds year data'
                                                                    ,placement = "left"
                                                                    ,trigger = "focus"
                                                                    ,options = list(container = "body")
                                                )
                                        )
                                      )
                                      ,fluidRow(
                                        column(6
                                               ,plotlyOutput('visitCountPlot1')
                                        )
                                        ,column(6
                                                ,plotlyOutput('visitDataPlot1')
                                        )
                                      )

                                      ,fluidRow(
                                        column(6,tags$h2('visit length of one patient')
                                        )
                                        ,column(6,tags$h2('Descriptive statistics')
                                        )
                                      )
                                      ,fluidRow(
                                        column(6,align='right'
                                               ,shinyBS::bsButton("mv7", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "mv7", title = "visit type count by year"
                                                                   ,content = 'we provieds the observed percentile 25 based on the number of yearly count. please check for value below 25 percentile or change treds year data'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                        ,column(6,align='right'
                                                ,shinyBS::bsButton("mv8", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                                ,shinyBS::bsPopover(id = "mv8", title = "visit length check by visit type "
                                                                    ,content = 'If the observed value is abnormal by checking the minimum, maximum, or median values, check the error.'
                                                                    ,placement = "left"
                                                                    ,trigger = "focus"
                                                                    ,options = list(container = "body")
                                                )
                                        )
                                      )
                                      ,fluidRow(
                                        column(6
                                               ,plotOutput('boxplot1')
                                        )
                                        ,column(6
                                                ,DT::dataTableOutput('messageBox11')
                                        )
                                      )

                                      ,fluidRow(
                                        column(6,tags$h2('Daily visit count by visit type')
                                        )
                                        ,column(6,tags$h2('Descriptive statistics')
                                        )
                                      )
                                      ,fluidRow(
                                        column(6,align='right'
                                               ,shinyBS::bsButton("mv9", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "mv9", title = "Daily visit count per patinets"
                                                                   ,content = 'we are check initial patients how many visit in hospital one days'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                        ,column(6,align='right'
                                                ,shinyBS::bsButton("mv10", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                                ,shinyBS::bsPopover(id = "mv10", title = "Descriptive statics of daily visit"
                                                                    ,content = 'If you fined a outlier value, please check the data'
                                                                    ,placement = "left"
                                                                    ,trigger = "focus"
                                                                    ,options = list(container = "body")
                                                )
                                        )
                                      )
                                      ,fluidRow(
                                        column(6
                                               ,plotlyOutput('daliyVisitType1')
                                        )
                                        ,column(6
                                                ,DT::dataTableOutput('messageBox12')
                                        )
                                      )



                            )
               )
      ),




      #Meta DQ Information------------------------------------------------------
      #CDM DQ Information-------------------------------------------------------
      tabPanel('CDM DQ Information'
               # Page 5-1
               ,tabsetPanel(type = "tabs"
                            ,id = 'cdmTabs'
                            ,tabPanel("Main",icon = icon('table',lib = 'font-awesome')
                                      ,tags$h2('DQ Summary - OMOP CDM(v5.3)')
                                      #Common UI#######
                                      ,fluidRow(
                                        column(2,align='center',tags$h3('Check Level'))
                                        ,column(2,align='center',tags$h3('DQ Score'))
                                        ,column(2,align='center',tags$h3('Data Status'))
                                        ,column(2,align='center',tags$h3('Data population'))
                                        ,column(2,align='center',tags$h3('Data period'))
                                        ,column(2,align='center',tags$h3('Data Capacity'))
                                      )
                                      ,fluidRow(
                                        column(2,align='center',tags$h3(checkLevel))
                                        ,column(2,align='center',tags$h3(cdmScore))
                                        ,column(2,align='center',tags$h3(dataStatus[1]))
                                        ,column(2,align='center',tags$h3(dataPopulation[1]))
                                        ,column(2,align='center',tags$h3(dataPeriod))
                                        ,column(2,align='center',tags$h3(dataVolume[2]))
                                      )
                                      ,fluidRow(
                                        column(12,align='right'
                                               ,shinyBS::bsButton("c1", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "c1", title = "title_title"
                                                                   ,content = 'text_text_text'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                      )

                                      #Common UI#######
                                      ,fluidRow(
                                        lapply(2:length(validationType), function(i){
                                          column(2,ggiraphOutput(paste0('cdm','main',validationType[i],'donut')),style="height:200px;")
                                        })
                                      )
                                      ,fluidRow(
                                        lapply(2:length(validationType), function(i){
                                          column(2,align='center',tags$h3(validationType[i]))
                                        })
                                      )

                                      ,fluidRow(
                                        column(4,align='center',tags$h2('DQ error proportion')
                                        )
                                        ,column(8,align = 'left',tags$h2('DQ error distribution')
                                        )
                                      )
                                      ,fluidRow(
                                        column(4,align='right'
                                               ,shinyBS::bsButton("c2", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "c2", title = "title_title"
                                                                   ,content = 'text_text_text'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                        ,column(8,align='right'
                                                ,shinyBS::bsButton("c3", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                                ,shinyBS::bsPopover(id = "c3", title = "title_title"
                                                                    ,content = 'text_text_text'
                                                                    ,placement = "left"
                                                                    ,trigger = "focus"
                                                                    ,options = list(container = "body")
                                                )
                                        )
                                      )
                                      ,fluidRow(
                                        column(4,align='centear'
                                               ,plotlyOutput("piePlot4")
                                        )
                                        ,column(8,align = 'left'
                                                ,plotlyOutput("barPlot4")
                                        )
                                      )

                                      ,fluidRow(
                                        column(12,tags$h2('DQ error message box'))
                                      )
                                      ,fluidRow(
                                        column(12,align='right'
                                               ,shinyBS::bsButton("c4", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "c4", title = "title_title"
                                                                   ,content = 'text_text_text'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                      )
                                      ,fluidRow(
                                        column(12,DT::dataTableOutput('messageBox4'))
                                      )

                                      ,fluidRow(
                                        column(12,tags$h2('Schema information')
                                        )
                                      )
                                      ,fluidRow(
                                        column(12,align='right'
                                               ,shinyBS::bsButton("c5", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "c5", title = "title_title"
                                                                   ,content = 'text_text_text'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                      )
                                      ,fluidRow(
                                        column(12
                                               ,highchartOutput('heatmap2')
                                        )
                                      )
                                      ,fluidRow(
                                        column(12
                                               ,align='right'
                                               ,shinyBS::bsButton("c6", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "c6", title = "title_title"
                                                                   ,content = 'text_text_text'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                      )
                                      ,fluidRow(
                                        column(12
                                               ,DT::dataTableOutput('heatmapTable2')
                                        )
                                      )

                                      ,fluidRow(
                                        column(6,tags$h2('Table yearly row count')
                                        )
                                        ,column(6,tags$h2('Table yearly row count by visit type')
                                        )
                                      )
                                      ,fluidRow(
                                        column(6,align='right'
                                               ,shinyBS::bsButton("c7", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "c7", title = "title_title"
                                                                   ,content = 'text_text_text'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                        ,column(6,align='right'
                                                ,shinyBS::bsButton("c8", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                                ,shinyBS::bsPopover(id = "c8", title = "title_title"
                                                                    ,content = 'text_text_text'
                                                                    ,placement = "left"
                                                                    ,trigger = "focus"
                                                                    ,options = list(container = "body")
                                                )
                                        )
                                      )
                                      ,fluidRow(
                                        column(6
                                               ,plotlyOutput('heatmapRowPlot2')
                                        )
                                        ,column(6
                                                ,plotlyOutput('heatmapTableVisitPlot2')
                                        )
                                      )

                            )

                            ,tabPanel("Person",    icon = icon('user-alt',lib = 'font-awesome')
                                      ,tags$h2('DQ info')
                                      ,fluidRow(
                                        column(12,align='right'
                                               ,shinyBS::bsButton("cp1", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "cp1", title = "title_title"
                                                                   ,content = 'text_text_text'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                      )
                                      #Common UI#######
                                      ,fluidRow(
                                        lapply(2:length(validationType), function(i){
                                          column(2,ggiraphOutput(paste0('cdm','person',validationType[i],'donut')),style="height:200px;")
                                        })
                                      )
                                      ,fluidRow(
                                        lapply(2:length(validationType), function(i){
                                          column(2,align='center',tags$h3(validationType[i]))
                                        })
                                      )

                                      ,fluidRow(
                                        column(4,align='center',tags$h2('DQ error proportion')
                                        )
                                        ,column(8,align = 'left',tags$h2('DQ error distribution')
                                        )
                                      )
                                      ,fluidRow(
                                        column(4,align='right'
                                               ,shinyBS::bsButton("cp2", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "cp2", title = "title_title"
                                                                   ,content = 'text_text_text'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                        ,column(8,align='right'
                                                ,shinyBS::bsButton("cp3", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                                ,shinyBS::bsPopover(id = "cp3", title = "title_title"
                                                                    ,content = 'text_text_text'
                                                                    ,placement = "left"
                                                                    ,trigger = "focus"
                                                                    ,options = list(container = "body")
                                                )
                                        )
                                      )
                                      ,fluidRow(
                                        column(4
                                               ,plotlyOutput("piePlot5")
                                        )
                                        ,column(8,align = 'left'
                                                ,plotlyOutput("barPlot5")
                                        )
                                      )

                                      ,fluidRow(
                                        column(12,tags$h2('DQ error message box'))
                                      )
                                      ,fluidRow(
                                        column(12,align='right'
                                               ,shinyBS::bsButton("cp4", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "cp4", title = "title_title"
                                                                   ,content = 'text_text_text'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                      )
                                      ,fluidRow(
                                        column(12,DT::dataTableOutput('messageBox5'))
                                      )
                                      ,fluidRow(
                                        column(12,tags$h2('Table basic DQ information')
                                        )
                                      )
                                      ,fluidRow(
                                        column(12,align='right'
                                               ,shinyBS::bsButton("cp7", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "cp7", title = "title_title"
                                                                   ,content = 'text_text_text'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                      )
                                      ,fluidRow(
                                        column(12
                                               ,DT::dataTableOutput('messageBox9'))
                                      )

                                      #Common UI#######
                                      ,fluidRow(
                                        column(6,tags$h2('Person count')
                                        )
                                        ,column(6,tags$h2('Year of birth distribution')
                                        )
                                      )
                                      ,fluidRow(
                                        column(6,align='right'
                                               ,shinyBS::bsButton("cp5", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "cp5", title = "title_title"
                                                                   ,content = 'text_text_text'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                        ,column(6,align='right'
                                                ,shinyBS::bsButton("cp6", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                                ,shinyBS::bsPopover(id = "cp6", title = "title_title"
                                                                    ,content = 'text_text_text'
                                                                    ,placement = "left"
                                                                    ,trigger = "focus"
                                                                    ,options = list(container = "body")
                                                )
                                        )
                                      )
                                      ,fluidRow(
                                        column(6
                                               ,tags$div(id="bar3", style="width:100%;height:300px;")
                                               ,deliverChart(div_id = "bar3")
                                        )
                                        ,column(6
                                                ,tags$div(id="bar__vertical2", style="width:100%;height:300px;")
                                                ,deliverChart(div_id = "bar__vertical2")
                                        )
                                      )



                            )
                            ,tabPanel("Visit",icon = icon('hospital',lib = 'font-awesome')
                                      ,tags$h2('DQ info')
                                      ,fluidRow(
                                        column(12,align='right'
                                               ,shinyBS::bsButton("cv1", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "cv1", title = "title_title"
                                                                   ,content = 'text_text_text'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                      )
                                      #Common UI#######
                                      ,fluidRow(
                                        lapply(2:length(validationType), function(i){
                                          column(2,ggiraphOutput(paste0('cdm','visit',validationType[i],'donut')),style="height:200px;")
                                        })
                                      )
                                      ,fluidRow(
                                        lapply(2:length(validationType), function(i){
                                          column(2,align='center',tags$h3(validationType[i]))
                                        })
                                      )

                                      ,fluidRow(
                                        column(4,align='center',tags$h2('DQ error proportion')
                                        )
                                        ,column(8,align = 'left',tags$h2('DQ error distribution')
                                        )
                                      )
                                      ,fluidRow(
                                        column(4,align='right'
                                               ,shinyBS::bsButton("cv2", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "cv2", title = "title_title"
                                                                   ,content = 'text_text_text'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                        ,column(8,align='right'
                                                ,shinyBS::bsButton("cv3", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                                ,shinyBS::bsPopover(id = "cv3", title = "title_title"
                                                                    ,content = 'text_text_text'
                                                                    ,placement = "left"
                                                                    ,trigger = "focus"
                                                                    ,options = list(container = "body")
                                                )
                                        )
                                      )
                                      ,fluidRow(
                                        column(4,align='center'
                                               ,plotlyOutput("piePlot6")
                                        )
                                        ,column(8,align = 'left'
                                                ,plotlyOutput("barPlot6")
                                        )
                                      )

                                      ,fluidRow(
                                        column(12,tags$h2('DQ error message box')
                                        )
                                      )
                                      ,fluidRow(
                                        column(12,align='right'
                                               ,shinyBS::bsButton("cv4", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "cv4", title = "title_title"
                                                                   ,content = 'text_text_text'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                      )
                                      ,fluidRow(
                                        column(12,DT::dataTableOutput('messageBox6'))
                                      )
                                      ,fluidRow(
                                        column(12,tags$h2('Table basic DQ information')
                                        )
                                      )
                                      ,fluidRow(
                                        column(12,align='right'
                                               ,shinyBS::bsButton("cv10", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "cv10", title = "title_title"
                                                                   ,content = 'text_text_text'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                      )
                                      ,fluidRow(
                                        column(12
                                               ,DT::dataTableOutput('messageBox10')
                                        )
                                      )

                                      #Common UI#######
                                      ,fluidRow(
                                        column(6,tags$h2('Visit count by year')
                                        )
                                        ,column(6,tags$h2('Visit type count by year')
                                        )
                                      )
                                      ,fluidRow(
                                        column(6,align='right'
                                               ,shinyBS::bsButton("cv5", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "cv5", title = "title_title"
                                                                   ,content = 'text_text_text'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                        ,column(6,align='right'
                                                ,shinyBS::bsButton("cv6", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                                ,shinyBS::bsPopover(id = "cv6", title = "title_title"
                                                                    ,content = 'text_text_text'
                                                                    ,placement = "left"
                                                                    ,trigger = "focus"
                                                                    ,options = list(container = "body")
                                                )
                                        )
                                      )
                                      ,fluidRow(
                                        column(6
                                               ,plotlyOutput('visitCountPlot2')
                                        )
                                        ,column(6
                                                ,plotlyOutput('visitDataPlot2')
                                        )
                                      )

                                      ,fluidRow(
                                        column(6,tags$h2('visit length of one patient')
                                        )
                                        ,column(6,tags$h2('Descriptive statistics')
                                        )
                                      )
                                      ,fluidRow(
                                        column(6,align='right'
                                               ,shinyBS::bsButton("cv7", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "cv7", title = "title_title"
                                                                   ,content = 'text_text_text'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                        ,column(6,align='right'
                                                ,shinyBS::bsButton("cv8", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                                ,shinyBS::bsPopover(id = "cv8", title = "title_title"
                                                                    ,content = 'text_text_text'
                                                                    ,placement = "left"
                                                                    ,trigger = "focus"
                                                                    ,options = list(container = "body")
                                                )
                                        )
                                      )
                                      ,fluidRow(
                                        column(6
                                               ,plotOutput('boxplot2')
                                        )
                                        ,column(6
                                                ,DT::dataTableOutput('messageBox13')
                                        )
                                      )

                                      ,fluidRow(
                                        column(6,tags$h2('Daily visit count by visit type')
                                        )
                                        ,column(6,tags$h2('Descriptive statistics')
                                        )
                                      )
                                      ,fluidRow(
                                        column(6,align='right'
                                               ,shinyBS::bsButton("cv9", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                               ,shinyBS::bsPopover(id = "cv9", title = "title_title"
                                                                   ,content = 'text_text_text'
                                                                   ,placement = "left"
                                                                   ,trigger = "focus"
                                                                   ,options = list(container = "body")
                                               )
                                        )
                                        ,column(6,align='right'
                                                ,shinyBS::bsButton("cv10", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                                ,shinyBS::bsPopover(id = "cv10", title = "title_title"
                                                                    ,content = 'text_text_text'
                                                                    ,placement = "left"
                                                                    ,trigger = "focus"
                                                                    ,options = list(container = "body")
                                                )
                                        )
                                      )
                                      ,fluidRow(
                                        column(6
                                               ,plotlyOutput('daliyVisitType2')
                                        )
                                        ,column(6
                                                ,DT::dataTableOutput('messageBox14')
                                        )
                                      )



                            )



                            ,tabPanel("Provider",icon = icon('hospital',lib = 'font-awesome')
                                      ,tags$h2('DQ info')
                                      #Common UI#######
                                      ,fluidRow(
                                        lapply(2:length(validationType), function(i){
                                          column(2,ggiraphOutput(paste0('cdm','provider',validationType[i],'donut')),style="height:200px;")
                                        })
                                      )
                                      ,fluidRow(
                                        lapply(2:length(validationType), function(i){
                                          column(2,align='center',tags$h3(validationType[i]))
                                        })
                                      )

                                      ,fluidRow(
                                        column(4,align='center',tags$h2('DQ error proportion')
                                        )
                                        ,column(8,align = 'left',tags$h2('DQ error distribution')
                                        )
                                      )
                                      ,fluidRow(
                                        column(4,align='center'
                                               ,plotlyOutput("piePlot7")
                                        )
                                        ,column(8,align = 'left'
                                                ,plotlyOutput("barPlot7")
                                        )
                                      )

                                      ,fluidRow(
                                        column(12,tags$h2('DQ error message box')
                                        )
                                      )
                                      ,fluidRow(
                                        column(12,DT::dataTableOutput('messageBox15'))
                                      )
                                      ,fluidRow(
                                        column(12,tags$h2('Table basic DQ information')
                                        )
                                      )
                                      ,fluidRow(
                                        column(12
                                               ,DT::dataTableOutput('messageBox31')
                                        )
                                      )

                                      ,fluidRow(
                                        column(6, tags$h2('count of provider(Gender_concept_id)'))
                                        ,column(6, tags$h2('Distribution of DOB'))
                                      )
                                      ,fluidRow(
                                        column(6
                                               ,tags$div(id="bar4", style="width:100%;height:300px;")
                                               ,deliverChart(div_id = "bar4")
                                        )
                                        ,column(6,align = 'center'
                                                ,tags$div(id="lineChart2", style="width:100%;height:300px;")
                                                ,deliverChart(div_id = "lineChart2")
                                        )

                                      )
                                      ,fluidRow(
                                        column(6,tags$h2('Proportion of foreginkey(provider)'))
                                        ,column(3,align = 'center', tags$h3('Proportion of specialty_concept_id'))
                                        ,column(3,align = 'center', tags$h3('Proportion of care_site_id'))
                                      )
                                      ,fluidRow(
                                        column(6,plotlyOutput("barPlot__default1"))
                                        ,column(3,plotlyOutput("piePlot15"))
                                        ,column(3,plotlyOutput("piePlot16"))
                                      )
                            )
                            ,tabPanel("Death",icon = icon('hospital',lib = 'font-awesome')
                                      ,tags$h2('DQ info')
                                      ,fluidRow(
                                        lapply(2:length(validationType), function(i){
                                          column(2,ggiraphOutput(paste0('cdm','death',validationType[i],'donut')),style="height:200px;")
                                        })
                                      )
                                      ,fluidRow(
                                        lapply(2:length(validationType), function(i){
                                          column(2,align='center',tags$h3(validationType[i]))
                                        })
                                      )

                                      ,fluidRow(
                                        column(4,align='center',tags$h2('DQ error proportion')
                                        )
                                        ,column(8,align = 'left',tags$h2('DQ error distribution')
                                        )
                                      )
                                      ,fluidRow(
                                        column(4,align='center'
                                               ,plotlyOutput("piePlot8")
                                        )
                                        ,column(8,align = 'left'
                                                ,plotlyOutput("barPlot8")
                                        )
                                      )

                                      ,fluidRow(
                                        column(12,tags$h2('DQ error message box')
                                        )
                                      )
                                      ,fluidRow(
                                        column(12,DT::dataTableOutput('messageBox16'))
                                      )
                                      ,fluidRow(
                                        column(12,tags$h2('Table basic DQ information')
                                        )
                                      )
                                      ,fluidRow(
                                        column(12
                                               ,DT::dataTableOutput('messageBox32')
                                        )
                                      )

                                      ,fluidRow(
                                        column(4,align='center',tags$h2('proportion of death_type_concept_id'))
                                        ,column(8,tags$h2('distribution of Death date')
                                        )
                                      )
                                      ,fluidRow(
                                        column(4,align='center',plotlyOutput("piePlot17"))
                                        ,column(8,align = 'center'
                                                ,tags$div(id="lineChart3", style="width:100%;height:300px;")
                                                ,deliverChart(div_id = "lineChart3")
                                        )
                                      )
                                      ,fluidRow(
                                        column(4,align='center',tags$h2('proportion of cause_concept_id'))
                                        ,column(8,tags$h2('age distribution of Death table')
                                        )
                                      )
                                      ,fluidRow(
                                        column(4,align='center',plotlyOutput("piePlot18"))
                                        ,column(8,align = 'center'
                                                ,tags$div(id="lineChart4", style="width:100%;height:300px;")
                                                ,deliverChart(div_id = "lineChart4")
                                        )
                                      )
                            )
                            ,tabPanel("CareSite",icon = icon('hospital',lib = 'font-awesome')
                                      ,tags$h2('DQ info')
                                      ,fluidRow(
                                        lapply(2:length(validationType), function(i){
                                          column(2,ggiraphOutput(paste0('cdm','caresite',validationType[i],'donut')),style="height:200px;")
                                        })
                                      )
                                      ,fluidRow(
                                        lapply(2:length(validationType), function(i){
                                          column(2,align='center',tags$h3(validationType[i]))
                                        })
                                      )

                                      ,fluidRow(
                                        column(4,align='center',tags$h2('DQ error proportion')
                                        )
                                        ,column(8,align = 'left',tags$h2('DQ error distribution')
                                        )
                                      )
                                      ,fluidRow(
                                        column(4,align='center'
                                               ,plotlyOutput("piePlot9")
                                        )
                                        ,column(8,align = 'left'
                                                ,plotlyOutput("barPlot9")
                                        )
                                      )

                                      ,fluidRow(
                                        column(12,tags$h2('DQ error message box')
                                        )
                                      )
                                      ,fluidRow(
                                        column(12,DT::dataTableOutput('messageBox17'))
                                      )
                                      ,fluidRow(
                                        column(12,tags$h2('Table basic DQ information')
                                        )
                                      )
                                      ,fluidRow(
                                        column(12
                                               ,DT::dataTableOutput('messageBox33')
                                        )
                                      )
                            )
                            ,tabPanel("ConditionOccurrence",icon = icon('hospital',lib = 'font-awesome')
                                      ,tags$h2('DQ info')
                                      ,fluidRow(
                                        lapply(2:length(validationType), function(i){
                                          column(2,ggiraphOutput(paste0('cdm','conditionoccurrence',validationType[i],'donut')),style="height:200px;")
                                        })
                                      )
                                      ,fluidRow(
                                        lapply(2:length(validationType), function(i){
                                          column(2,align='center',tags$h3(validationType[i]))
                                        })
                                      )

                                      ,fluidRow(
                                        column(4,align='center',tags$h2('DQ error proportion')
                                        )
                                        ,column(8,align = 'left',tags$h2('DQ error distribution')
                                        )
                                      )
                                      ,fluidRow(
                                        column(4,align='center'
                                               ,plotlyOutput("piePlot10")
                                        )
                                        ,column(8,align = 'left'
                                                ,plotlyOutput("barPlot10")
                                        )
                                      )

                                      ,fluidRow(
                                        column(12,tags$h2('DQ error message box')
                                        )
                                      )
                                      ,fluidRow(
                                        column(12,DT::dataTableOutput('messageBox18'))
                                      )
                                      ,fluidRow(
                                        column(12,tags$h2('Table basic DQ information')
                                        )
                                      )
                                      ,fluidRow(
                                        column(12
                                               ,DT::dataTableOutput('messageBox34')
                                        )
                                      )

                                      ,fluidRow(
                                        column(3,align='left',tags$h2('Proportion of Foregin key')
                                        )
                                        ,column(3,align = 'left',tags$h3('Missing proportion of condition occurrence')
                                        )
                                        ,column(6,align = 'left',tags$h2('Age distribution of condition occurrence')
                                        )
                                      )
                                      ,fluidRow(
                                        column(3,align='center'
                                               ,plotlyOutput("piePlot19"))
                                        ,column(3,align='center'
                                                ,plotlyOutput("piePlot20"))
                                        ,column(6,align = 'center'
                                                ,tags$div(id="lineChart5", style="width:100%;height:300px;")
                                                ,deliverChart(div_id = "lineChart5"))
                                      )
                                      ,fluidRow(
                                        column(6,align = 'left',tags$h2('Monthly trend of Condition occurrence')
                                        )
                                        ,column(6,align = 'left',tags$h2('Monthly trend of Condition occurrence with visit type')
                                        )
                                      )
                                      ,fluidRow(
                                        column(6,align = 'center'
                                               ,plotlyOutput('countBarPlot1'))
                                        ,column(6,align = 'center'
                                                ,plotlyOutput('countBarTypePlot1'))
                                      )
                                      ,fluidRow(
                                        column(6,align = 'left',tags$h2('Patients diagnosis per one day')
                                        )
                                        ,column(6,align = 'left',tags$h2('Descriptive statics')
                                        )
                                      )
                                      ,fluidRow(
                                        column(6,plotOutput('boxplot3'))
                                        ,column(6,DT::dataTableOutput('messageBox24'))
                                      )
                                      ,fluidRow(
                                        column(6,align = 'left',tags$h2('Disease period of once diagnosis with visit_type')
                                        )
                                        ,column(6,align = 'left',tags$h2('Descriptive statics')
                                        )
                                      )
                                      ,fluidRow(
                                        column(6,plotOutput('boxplot4'))
                                        ,column(6,DT::dataTableOutput('messageBox25'))
                                      )
                                      ,fluidRow(
                                        column(6,align = 'left',tags$h2('Disease period of once diagnosis by concept level')
                                        )
                                        ,column(6,align = 'left',tags$h2('Descriptive statics')
                                        )
                                      )
                                      ,fluidRow(
                                        column(6,plotOutput('boxPlot__click1'))
                                        ,column(6,DT::dataTableOutput('messageBox__click1'))
                                      )
                                      ,fluidRow(
                                        column(6,align = 'left',tags$h2('Conditionoccurrence proportion '))
                                      )
                                      ,fluidRow(
                                        column(12,highchartOutput('heatmapSet__table1'))
                                      )
                                      ,fluidRow(
                                        column(12,DT::dataTableOutput('heatmap__table__dataframe1'))
                                      )

                            )
                            ,tabPanel("DrugExposure",icon = icon('hospital',lib = 'font-awesome')
                                      ,tags$h2('DQ info')
                                      ,fluidRow(
                                        lapply(2:length(validationType), function(i){
                                          column(2,ggiraphOutput(paste0('cdm','drugexposure',validationType[i],'donut')),style="height:200px;")
                                        })
                                      )
                                      ,fluidRow(
                                        lapply(2:length(validationType), function(i){
                                          column(2,align='center',tags$h3(validationType[i]))
                                        })
                                      )

                                      ,fluidRow(
                                        column(4,align='center',tags$h2('DQ error proportion')
                                        )
                                        ,column(8,align = 'left',tags$h2('DQ error distribution')
                                        )
                                      )
                                      ,fluidRow(
                                        column(4,align='center'
                                               ,plotlyOutput("piePlot11")
                                        )
                                        ,column(8,align = 'left'
                                                ,plotlyOutput("barPlot11")
                                        )
                                      )

                                      ,fluidRow(
                                        column(12,tags$h2('DQ error message box')
                                        )
                                      )
                                      ,fluidRow(
                                        column(12,DT::dataTableOutput('messageBox19'))
                                      )
                                      ,fluidRow(
                                        column(12,tags$h2('Table basic DQ information')
                                        )
                                      )
                                      ,fluidRow(
                                        column(12
                                               ,DT::dataTableOutput('messageBox35')
                                        )
                                      )

                                      ,fluidRow(
                                        column(3,align = 'left',tags$h2('Proportion of foregin key')
                                        )
                                        ,column(3,align = 'left',tags$h2('Missing proportion of Drug_exposure')
                                        )
                                        ,column(6,align = 'left',tags$h2('Drug_exposure age distribution')
                                        )
                                      )
                                      ,fluidRow(
                                        column(3,align='center'
                                               ,plotlyOutput("piePlot21"))
                                        ,column(3,align='center'
                                                ,plotlyOutput("piePlot22"))
                                        ,column(6,align = 'center'
                                                ,tags$div(id="lineChart6", style="width:100%;height:300px;")
                                                ,deliverChart(div_id = "lineChart6"))
                                      )
                                      ,fluidRow(
                                        column(6,align = 'left',tags$h2('Monthly trend of Drug_exposure')
                                        )
                                        ,column(6,align = 'left',tags$h2('Drug_exposure monthly trend with visit type')
                                        )
                                      )
                                      ,fluidRow(
                                        column(6,align = 'center'
                                               ,plotlyOutput('countBarPlot2'))
                                        ,column(6,align = 'center'
                                                ,plotlyOutput('countBarTypePlot2'))
                                      )
                                      ,fluidRow(
                                        column(6,align = 'left',tags$h2('day length of drug exposure by visit type ')
                                        )
                                        ,column(6,align = 'left',tags$h2('Descriptive statics')
                                        )
                                      )
                                      ,fluidRow(
                                        column(6,plotOutput('boxplot6'))
                                        ,column(6,DT::dataTableOutput('messageBox26'))
                                      )
                                      ,fluidRow(
                                        column(6,align = 'left',tags$h2('Drug_exposure day length check by drug concept_level')
                                        )
                                        ,column(6,align = 'left',tags$h2('Descriptive statics')
                                        )
                                      )
                                      ,fluidRow(
                                        column(6,plotOutput('boxPlot__click2'))
                                        ,column(6,DT::dataTableOutput('messageBox__click2'))
                                      )
                                      ,fluidRow(
                                        column(6,align = 'left',tags$h2('Drug_exposure quantity check by concept level')
                                        )
                                        ,column(6,align = 'left',tags$h2('Descriptive statics')
                                        )
                                      )
                                      ,fluidRow(
                                        column(6,plotOutput('boxPlot__click3'))
                                        ,column(6,DT::dataTableOutput('messageBox__click3'))
                                      )
                                      ,fluidRow(
                                        column(6,align = 'left',tags$h2('Quantity of drug exposure with visit_type')
                                        )
                                        ,column(6,align = 'left',tags$h2('Descriptive statics')
                                        )
                                      )
                                      ,fluidRow(
                                        column(6,plotOutput('boxplot9'))
                                        ,column(6,DT::dataTableOutput('messageBox27'))
                                      )
                                      ,fluidRow(
                                        column(12,align = 'left',tags$h2('Drug_exposure proportion')
                                        )
                                      )
                                      ,fluidRow(
                                        column(12,highchartOutput('heatmapSet__table2'))
                                      )
                                      ,fluidRow(
                                        column(12,DT::dataTableOutput('heatmap__table__dataframe2'))
                                      )
                            )
                            ,tabPanel("DeviceExposure",icon = icon('hospital',lib = 'font-awesome')
                                      ,tags$h2('DQ info')
                                      ,fluidRow(
                                        lapply(2:length(validationType), function(i){
                                          column(2,ggiraphOutput(paste0('cdm','deviceexposure',validationType[i],'donut')),style="height:200px;")
                                        })
                                      )
                                      ,fluidRow(
                                        lapply(2:length(validationType), function(i){
                                          column(2,align='center',tags$h3(validationType[i]))
                                        })
                                      )

                                      ,fluidRow(
                                        column(4,align='center',tags$h2('DQ error proportion')
                                        )
                                        ,column(8,align = 'left',tags$h2('DQ error distribution')
                                        )
                                      )
                                      ,fluidRow(
                                        column(4,align='center'
                                               ,plotlyOutput("piePlot12")
                                        )
                                        ,column(8,align = 'left'
                                                ,plotlyOutput("barPlot12")
                                        )
                                      )

                                      ,fluidRow(
                                        column(12,tags$h2('DQ error message box')
                                        )
                                      )
                                      ,fluidRow(
                                        column(12,DT::dataTableOutput('messageBox20'))
                                      )
                                      ,fluidRow(
                                        column(12,tags$h2('Table basic DQ information')
                                        )
                                      )
                                      ,fluidRow(
                                        column(12
                                               ,DT::dataTableOutput('messageBox36')
                                        )
                                      )

                                      ,fluidRow(
                                        column(3,align = 'left',tags$h2('Proportion of foregin key')
                                        )
                                        ,column(3,align = 'left',tags$h2('Missing proportion of device_exposure')
                                        )
                                        ,column(6,align = 'left',tags$h2('Device_exposure age distribution')
                                        )
                                      )
                                      ,fluidRow(
                                        column(3,align='center'
                                               ,plotlyOutput("piePlot23"))
                                        ,column(3,align='center'
                                                ,plotlyOutput("piePlot24"))
                                        ,column(6,align = 'center'
                                                ,tags$div(id="lineChart7", style="width:100%;height:300px;")
                                                ,deliverChart(div_id = "lineChart7"))
                                      )
                                      ,fluidRow(
                                        column(6,align = 'left',tags$h2('Device_exposure Monthly trend ')
                                        )
                                        ,column(6,align = 'left',tags$h2('Device_exposure monthly trend with visit type')
                                        )
                                      )
                                      ,fluidRow(
                                        column(6,align = 'center'
                                               ,plotlyOutput('countBarPlot3'))
                                        ,column(6,align = 'center'
                                                ,plotlyOutput('countBarTypePlot3'))
                                      )
                                      ,fluidRow(
                                        column(6,align = 'left',tags$h2('device exposure daily prescribe concept level')
                                        )
                                        ,column(6,align = 'left',tags$h2('Descriptive statics')
                                        )
                                      )
                                      ,fluidRow(
                                        column(6,plotOutput('boxPlot__click4'))
                                        ,column(6,DT::dataTableOutput('messageBox__click4'))
                                      )
                                      ,fluidRow(
                                        column(6,align = 'left',tags$h2('Device_exposure quantity check by concept level')
                                        )
                                        ,column(6,align = 'left',tags$h2('Descriptive statics')
                                        )
                                      )
                                      ,fluidRow(
                                        column(6,plotOutput('boxplot11'))
                                        ,column(6,DT::dataTableOutput('messageBox28'))
                                      )
                                      ,fluidRow(
                                        column(12,align = 'left',tags$h2('Device_exposure proportion')
                                        )
                                      )
                                      ,fluidRow(
                                        column(12,highchartOutput('heatmapSet__table3'))
                                      )
                                      ,fluidRow(
                                        column(12,DT::dataTableOutput('heatmap__table__dataframe3'))
                                      )
                            )
                            ,tabPanel("ProcedureOccurrence",icon = icon('hospital',lib = 'font-awesome')
                                      ,tags$h2('DQ info')
                                      ,fluidRow(
                                        lapply(2:length(validationType), function(i){
                                          column(2,ggiraphOutput(paste0('cdm','procedureoccurence',validationType[i],'donut')),style="height:200px;")
                                        })
                                      )
                                      ,fluidRow(
                                        lapply(2:length(validationType), function(i){
                                          column(2,align='center',tags$h3(validationType[i]))
                                        })
                                      )

                                      ,fluidRow(
                                        column(4,align='center',tags$h2('DQ error proportion')
                                        )
                                        ,column(8,align = 'left',tags$h2('DQ error distribution')
                                        )
                                      )
                                      ,fluidRow(
                                        column(4,align='center'
                                               ,plotlyOutput("piePlot13")
                                        )
                                        ,column(8,align = 'left'
                                                ,plotlyOutput("barPlot13")
                                        )
                                      )

                                      ,fluidRow(
                                        column(12,tags$h2('DQ error message box')
                                        )
                                      )
                                      ,fluidRow(
                                        column(12,DT::dataTableOutput('messageBox21'))
                                      )
                                      ,fluidRow(
                                        column(12,tags$h2('Table basic DQ information')
                                        )
                                      )
                                      ,fluidRow(
                                        column(12
                                               ,DT::dataTableOutput('messageBox37')
                                        )
                                      )

                                      ,fluidRow(
                                        column(3,align = 'left',tags$h2('Proportion of foregin key')
                                        )
                                        ,column(3,align = 'left',tags$h2('Missing proportion of procedure_occurrence')
                                        )
                                        ,column(6,align = 'left',tags$h2('Procedure_occurrence age distribution')
                                        )
                                      )
                                      ,fluidRow(
                                        column(3,align='center'
                                               ,plotlyOutput("piePlot25"))
                                        ,column(3,align='center'
                                                ,plotlyOutput("piePlot26"))
                                        ,column(6,align = 'center'
                                                ,tags$div(id="lineChart8", style="width:100%;height:300px;")
                                                ,deliverChart(div_id = "lineChart8"))
                                      )
                                      ,fluidRow(
                                        column(6,align = 'left',tags$h2('Procedure_occurrence monthly trend')
                                        )
                                        ,column(6,align = 'left',tags$h2('Procedure_occurrence monthly trend with visit type')
                                        )
                                      )
                                      ,fluidRow(
                                        column(6,align = 'center'
                                               ,plotlyOutput('countBarPlot4'))
                                        ,column(6,align = 'center'
                                                ,plotlyOutput('countBarTypePlot4'))
                                      )
                                      ,fluidRow(
                                        column(6,align = 'left',tags$h2('Daily procedure check by concept level')
                                        )
                                        ,column(6,align = 'left',tags$h2('Descriptive statics')
                                        )
                                      )
                                      ,fluidRow(
                                        column(6,plotOutput('boxPlot__click5'))
                                        ,column(6,DT::dataTableOutput('messageBox__click5'))
                                      )
                                      ,fluidRow(
                                        column(6,align = 'left',tags$h2('Procedure quantity of initial visit_type')
                                        )
                                        ,column(6,align = 'left',tags$h2('Descriptive statics')
                                        )
                                      )
                                      ,fluidRow(
                                        column(6,plotOutput('boxplot12'))
                                        ,column(6,DT::dataTableOutput('messageBox29'))
                                      )
                                      ,fluidRow(
                                        column(12,align = 'left',tags$h2('Procedure_occurrence proportion')
                                        )
                                      )
                                      ,fluidRow(
                                        column(12,highchartOutput('heatmapSet__table4'))
                                      )
                                      ,fluidRow(
                                        column(12,DT::dataTableOutput('heatmap__table__dataframe4'))
                                      )
                            )
                            ,tabPanel("Measurement",icon = icon('hospital',lib = 'font-awesome')
                                      ,tags$h2('DQ info')
                                      ,fluidRow(
                                        lapply(2:length(validationType), function(i){
                                          column(2,ggiraphOutput(paste0('cdm','measurement',validationType[i],'donut')),style="height:200px;")
                                        })
                                      )
                                      ,fluidRow(
                                        lapply(2:length(validationType), function(i){
                                          column(2,align='center',tags$h3(validationType[i]))
                                        })
                                      )

                                      ,fluidRow(
                                        column(4,align='center',tags$h2('DQ error proportion')
                                        )
                                        ,column(8,align = 'left',tags$h2('DQ error distribution')
                                        )
                                      )
                                      ,fluidRow(
                                        column(4,align='center'
                                               ,plotlyOutput("piePlot14")
                                        )
                                        ,column(8,align = 'left'
                                                ,plotlyOutput("barPlot14")
                                        )
                                      )

                                      ,fluidRow(
                                        column(12,tags$h2('DQ error message box')
                                        )
                                      )
                                      ,fluidRow(
                                        column(12,DT::dataTableOutput('messageBox22'))
                                      )
                                      ,fluidRow(
                                        column(12,tags$h2('Table basic DQ information')
                                        )
                                      )
                                      ,fluidRow(
                                        column(12
                                               ,DT::dataTableOutput('messageBox38')
                                        )
                                      )
                                      ,fluidRow(
                                        column(3,align = 'left',tags$h2('Proportion of foregin key')
                                        )
                                        ,column(3,align = 'left',tags$h2('Missing proportion of measurement')
                                        )
                                        ,column(6,align = 'left',tags$h2('Measurement age distribution')
                                        )
                                      )
                                      ,fluidRow(
                                        column(3,align = 'center'
                                               ,plotlyOutput('piePlot27'))
                                        ,column(3,align = 'center'
                                                ,plotlyOutput('piePlot28'))
                                        ,column(6,align = 'center'
                                                ,tags$div(id="lineChart9", style="width:100%;height:300px;")
                                                ,deliverChart(div_id = "lineChart9"))
                                      )
                                      ,fluidRow(
                                        column(6,align = 'left',tags$h2('Measurement monthly trend')
                                        )
                                        ,column(6,align = 'left',tags$h2('Measurement monthly trend with visit type')
                                        )
                                      )
                                      ,fluidRow(
                                        column(6,align = 'center'
                                               ,plotlyOutput('countBarPlot5'))
                                        ,column(6,align = 'center'
                                                ,plotlyOutput('countBarTypePlot5'))
                                      )
                                      ,fluidRow(
                                        column(6,align = 'left',tags$h2('Monthly trend of measurement concept level'))
                                        ,column(6,align = 'left',tags$h2('Descriptive statistics'))
                                      )
                                      ,fluidRow(
                                        column(6,plotlyOutput('lineChart__click1'))
                                        ,column(6,DT::dataTableOutput('message__lineChart__click1'))
                                      )
                                      ,fluidRow(
                                        column(6,align = 'left',tags$h2('Measurement boxplot by concept level'))
                                        ,column(6,align = 'left',tags$h2('Descriptive statistics'))
                                      )
                                      ,fluidRow(
                                        column(6,plotOutput('boxPlot__click6'))
                                        ,column(6,DT::dataTableOutput('messageBox__click6'))
                                      )
                                      ,fluidRow(
                                        column(12,align = 'left',tags$h2('Measurment proportion'))
                                      )
                                      ,fluidRow(
                                        column(12,highchartOutput('heatmap__regression1'))
                                      )
                                      ,fluidRow(
                                        column(11,align= 'right',textInput('textInput1','',placeholder = 'Input concept ID'))
                                        ,column(1,align='center',actionButton('actionbutton1','OK'))
                                      )
                                      ,fluidRow(
                                        column(6,align = 'left',tags$h2('measurment result value distribution of male'))
                                        ,column(6,align = 'left',tags$h2('measurment result value distribution of female'))
                                      )
                                      ,fluidRow(
                                        column(6,plotOutput('regression1'))
                                        ,column(6,plotOutput('regression2'))
                                      )
                                      ,fluidRow(
                                        column(6,align = 'left',tags$h2('Descriptive statistics of male'))
                                        ,column(6,align = 'left',tags$h2('Descriptive statistics of female'))
                                      )
                                      ,fluidRow(
                                        column(6,dataTableOutput('regression__table1'))
                                        ,column(6,dataTableOutput('regression__table2'))
                                      )
                            )


               )
      )
      ,tabPanel('Author'
                ,tabsetPanel(type = "tabs"
                             ,id = 'AuthorTabs'
                             ,tabPanel("Contact us ",icon = icon('user-friends',lib = 'font-awesome')
                                       ,tags$h1('Contact Information',style = 'color:black;')

                                       ,tags$h2('DQUEEN Team',style = 'color:black;')
                                       ,tags$h3('Department of Biomedical informatics, Ajou University School of Medicine',style = 'color:black;')

                                       ,tags$h4('Address:',style = 'color:black;')
                                       ,tags$h4('443-721, Hongjae bld 507, Ajou University',style = 'color:black;')
                                       ,tags$h4('Wonchun-dong, Suwon City, Republic of Korea',style = 'color:black;')
                                       ,tags$h4('Telephone: +82-31-219-4471',style = 'color:black;')
                                       ,tags$h4('FAX: +82-31-219-4472',style = 'color:black;')
                                       ,tags$h4('E-mail: lance.byun@gmail.com',style = 'color:black;')
                                       ,tags$h4('E-mail: dongsu2005@naver.com',style = 'color:black;')

                                       ,tags$h2('Contribution : ',style = 'color:black;')
                                       ,tags$h4('Project manager                 : Rae Woong Park',style = 'color:black;')
                                       ,tags$h4('Project leader                  : Jung hyun Byun',style = 'color:black;')
                                       ,tags$h4('Back-end developer  -(sql, R)   : Jung hyun Byun',style = 'color:black;')
                                       ,tags$h4('Front-end developer -(R, shiny) : Dong su Park',style = 'color:black;')
                                       ,tags$h4('System architecture             : Oh Song heui, Jung hyun Byun',style = 'color:black;')


                                       ,tags$h2('Acknowledgement',style = 'color:black;')
                                       ,tags$h5('This work was supported by a grant of the Korea Health Technology R&D Project through the Korea Health Industry Development Institute (KHIDI),',style = 'color:black;')
                                       ,tags$h5('funded by the Ministry of Health & Welfare, Republic of Korea [grant number : HI16C0992] and the Bio Industrial Strategic Technology ',style = 'color:black;')
                                       ,tags$h5('Development Program (20003883) funded By the Ministry of Trade, Industry & Energy (MOTIE, Korea).',style = 'color:black;')









                             )
                )
      )



      ,tabPanel(
        loadEChartsLibrary() # for ECharts2Shiny package
        ,loadEChartsTheme('shine') # for ECharts2Shiny package
        ,loadEChartsTheme('vintage') # for ECharts2Shiny package
        ,tags$style('
                    .custom{
                    width:50%;
                    text-align: center;
                    color: white;
                    background: green;
                    margin-bottom : 10px;
                    }')
      )
      #CDM DQ Information-------------------------------------------------------

        )
      )
