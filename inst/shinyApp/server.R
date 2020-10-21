server <- (function(input, output) {

  output$selectBar <- renderUI({
    selectInput("selectBar", NULL,
                choices = c(
                  "Summary" = "summary"
                  ,"Domain:Meta (source data)" = "DomainMeta"
                  ,"Domain:CDM  (OMOP-CDM)"  = "DomainCDM"
                )
    )
  })

  #Donut
  lapply(1:nrow(DonutSet), function(i) {
    output[[DonutSet[i,1]]] <- renderggiraph({
      ggiraph(ggobj = DQUEEN::drawDonutPlot(DQUEEN::donutPlot(DonutSet[i,2]),DQUEEN::scoreColorFunction(DonutSet[i,2])))
    })
  })
  #Rader
  lapply(1:length(raderSet), function(i){
    name <- paste0('rader',i)
    output[[name]] <- renderRadarChart(name, data = raderSet[[i]], shape = "circle", line.width = 3,
                                       theme = "dark-digerati",font.size.legend = 14)
  })

  #CircleBar
  lapply(1:length(circleBarSet), function(i){
    name <- paste0('circleBar',i)
    output[[name]] <-   renderPieChart(div_id = name,
                                       data = circleBarSet[[i]],
                                       radius = "90%",center_x = "50%", center_y = "50%",font.size.legend = 14)
  })

  #Bar
  lapply(1:length(barSet), function(i){
    name <- paste0('bar',i)
    output[[name]] <-   renderBarChart(div_id = name,
                                       grid_left = '1%',
                                       data = barSet[[i]])
  })

  #LineChart
  lapply(1:length(lineChartSet), function(i){
    name <- paste0('lineChart',i)
    output[[name]] <-   renderLineChart(div_id = name,
                                        theme = "shine",
                                        data = lineChartSet[[i]],
                                        stack_plot = F)
  })

  #Heatmap
  lapply(1:length(heatmapSet), function(i){
    name <- paste0('heatmap',i)
    output[[name]] <-   renderHighchart({
      hctreemap(treemap::treemap(heatmapSet[[i]],
                                 index=c("TABLE_NAME"),
                                 vSize="rows",
                                 vColor="table_size",
                                 type="value",
                                 title = "",
                                 title.legend = "Table Availability",
                                 border.col = "white",
                                 position.legend = "bottom"),
                allowDrillToNode = TRUE, allowPointSelect = TRUE) %>%
        hc_tooltip(pointFormat = "<b>{point.name}</b>
                   <br>Rows: {point.value}<br>
                   Size: {point.valuecolor} KB")
    })
    })

  #Heatmap__regression
  lapply(1:length(heatmap__regression), function(i){
    name <- paste0('heatmap__regression',i)
    output[[name]] <-   renderHighchart({
      hctreemap(treemap::treemap(heatmap__regression[[i]],
                                 index=c("concept_name"),
                                 vSize="count",
                                 vColor="concept_id",
                                 type="value",
                                 title = "",
                                 title.legend = "Table Availability",
                                 border.col = "white",
                                 position.legend = "bottom",
                                 palette = '#67a7c9'),
                allowDrillToNode = TRUE, allowPointSelect = TRUE) %>%
        hc_tooltip(pointFormat = "<b>{point.name}</b>
                   <br>Rows: {point.value}<br>
                   Concept ID: {point.valuecolor}")
    })
    })

  #Heatmap__table
  lapply(1:length(heatmapSet__table), function(i){
    name <- paste0('heatmapSet__table',i)
    output[[name]] <-   renderHighchart({
      hctreemap(treemap::treemap(heatmapSet__table[[i]],
                                 index=c("concept_name"),
                                 vSize="concept_count",
                                 vColor="concept_count",
                                 type="value",
                                 title = "",
                                 title.legend = "Table Availability",
                                 border.col = "white",
                                 position.legend = "bottom"),
                allowDrillToNode = TRUE, allowPointSelect = TRUE) %>%
        hc_tooltip(pointFormat = "<b>{point.name}</b>
                   <br>Count: {point.value}<br>")
    })
    })

  #Heatmap__table__dataframe
  lapply(1:length(heatmapSet__table), function(i){
    name <- paste0('heatmap__table__dataframe',i)
    output[[name]] <-   DT::renderDataTable({
      table <- heatmapSet__table[[i]]
      table
    },options = list(
      pageLength = 5
    ))
  })

  # heatmapTable
  lapply(1:length(heatmapSet), function(i){
    name <- paste0('heatmapTable',i)
    output[[name]] <-   DT::renderDataTable({
      table <- heatmapSet[[i]]
      table
    },options = list(
      pageLength = 5
    ))
  })

  # heatmapRowPlot
  lapply(1:length(heatmapSet), function(i){
    name <- paste0('heatmapRowPlot',i)
    output[[name]] <-   renderPlotly({
      heatmapSet[[i]]$TABLE_NAME <- tolower(heatmapSet[[i]]$TABLE_NAME)
      visitPerson[[i]]$TABLE_NAME <- tolower(visitPerson[[i]]$TABLE_NAME)
      selectedrowindex <- input[[paste0('heatmapTable',i,'_rows_selected')]]
      selectedrowindex <- as.numeric(selectedrowindex)
      tableName <- heatmapSet[[i]][selectedrowindex,'TABLE_NAME']
      visitTable <- visitPerson[[i]][visitPerson[[i]]$TABLE_NAME == tableName,]
      visitPlot <- visitTable %>% plot_ly(x = ~count_year) %>% add_lines(y = ~visit_count,name='Visit_count') %>% add_lines(y = ~count_val,name='count_val')

    })
  })



  # HeatmapTableVisitPlot
  lapply(1:length(heatmapSet), function(i){
    name <- paste0('heatmapTableVisitPlot',i)
    output[[name]] <-   renderPlotly({
      heatmapSet[[i]]$TABLE_NAME <- tolower(heatmapSet[[i]]$TABLE_NAME)
      visitType[[i]]$TABLE_NAME <- tolower(visitType[[i]]$TABLE_NAME)
      selectedrowindex <- input[[paste0('heatmapTable',i,'_rows_selected')]]
      selectedrowindex <- as.numeric(selectedrowindex)
      tableName <- heatmapSet[[i]][selectedrowindex,'TABLE_NAME']
      visitTable <- visitType[[i]][visitType[[i]]$TABLE_NAME == tableName,]
      visitTable$count_val <- as.numeric(visitTable$count_val)
      na.omit(visitTable) %>% group_by(col) %>%
        plot_ly(x= ~count_year,y= ~count_val, group=~col,type='scatter',color=~col,mode='lines')

    })
  })

  #bar__vertical
  lapply(1:length(bar__verticalSet), function(i){
    name <- paste0('bar__vertical',i)
    output[[name]] <-   renderBarChart(div_id = name, grid_left = '1%',direction = 'vertical',
                                       data = bar__verticalSet[[i]])
  })

  #visitCountPlot
  lapply(1:length(visitCountPlot), function(i){
    name <- paste0('visitCountPlot',i)
    output[[name]] <-   renderPlotly({
      plot_ly(visitCountPlot[[i]], x = ~visit_year, y = ~count_val, type='bar',name='Visit Count') %>%
        add_segments(x=visitCountPlot[[i]]$visit_year[1],xend=visitCountPlot[[i]]$visit_year[length(visitCountPlot[[i]]$visit_year)],y=unique(visitCountPlot[[i]]$p_25),yend=unique(visitCountPlot[[i]]$p_25),name='percentile 25')
    })


  })

  #visitDataPlot
  lapply(1:length(visitDataPlot), function(i){
    name <- paste0('visitDataPlot',i)
    output[[name]] <-   renderPlotly({
      visitDataPlot[[i]] %>% group_by(patfg) %>%
        plot_ly(x= ~visit_year,y= ~count_val, group=~patfg,type='scatter',color=~patfg,mode='lines') %>%
        add_segments(x=visitDataPlot[[i]]$visit_year[1],xend=visitDataPlot[[i]]$visit_year[length(visitDataPlot[[i]]$visit_year)],y=visitDataPlot[[i]]$p_25,yend=visitDataPlot[[i]]$p_25,name='percentile 25')
    })
  })

  #countBarPlot
  lapply(1:length(countBarPlot), function(i){
    name <- paste0('countBarPlot',i)
    countBarPlot[[i]] <- na.omit(countBarPlot[[i]])
    output[[name]] <-   renderPlotly({
      plot_ly(countBarPlot[[i]], x = ~visit_year, y = ~count_val, type = 'scatter', mode = 'lines',name='') %>%
        add_segments(x=countBarPlot[[i]]$visit_year[1],xend=countBarPlot[[i]]$visit_year[length(countBarPlot[[i]]$visit_year)],y=unique(countBarPlot[[i]]$p_25),yend=unique(countBarPlot[[i]]$p_25),name='percentile 25') %>%
        add_segments(x=countBarPlot[[i]]$visit_year[1],xend=countBarPlot[[i]]$visit_year[length(countBarPlot[[i]]$visit_year)],y=unique(countBarPlot[[i]]$p_75),yend=unique(countBarPlot[[i]]$p_75),name='percentile 75') %>%
        add_segments(x=countBarPlot[[i]]$visit_year[1],xend=countBarPlot[[i]]$visit_year[length(countBarPlot[[i]]$visit_year)],y=unique(countBarPlot[[i]]$median),yend=unique(countBarPlot[[i]]$median),name='median')
    })
  })

  #countBarTypePlot
  lapply(1:length(countBarTypePlot), function(i){
    name <- paste0('countBarTypePlot',i)
    countBarTypePlot[[i]] <- na.omit(countBarTypePlot[[i]])
    output[[name]] <-   renderPlotly({

      countBarTypePlot[[i]] %>% group_by(patfg) %>%
        plot_ly(x= ~visit_year,y= ~count_val, group=~patfg,type='scatter',color=~patfg,mode='lines') %>%
        add_segments(x=countBarTypePlot[[i]]$visit_year[1],xend=countBarTypePlot[[i]]$visit_year[length(countBarTypePlot[[i]]$visit_year)],y=countBarTypePlot[[i]]$p_25,yend=countBarTypePlot[[i]]$p_25,name='percentile 25') %>%
        add_segments(x=countBarTypePlot[[i]]$visit_year[1],xend=countBarTypePlot[[i]]$visit_year[length(countBarTypePlot[[i]]$visit_year)],y=countBarTypePlot[[i]]$p_75,yend=countBarTypePlot[[i]]$p_75,name='percentile 75') %>%
        add_segments(x=countBarTypePlot[[i]]$visit_year[1],xend=countBarTypePlot[[i]]$visit_year[length(countBarTypePlot[[i]]$visit_year)],y=countBarTypePlot[[i]]$median,yend=countBarTypePlot[[i]]$median,name='median')

    })
  })

  #lineChart__click
  lapply(1:length(lineChart__click), function(i){
    name <- paste0('lineChart__click',i)

    output[[name]] <-   renderPlotly({

      selectedrowindex <- input[[paste0('message__lineChart__click',i,'_rows_selected')]]
      selectedrowindex <- as.numeric(selectedrowindex)
      indexName <- message__lineChart__click[[i]][selectedrowindex,'measurement_concept_id']
      print(indexName)
      visualPlot <- lineChart__click[[i]][lineChart__click[[i]]$concept_id %in% indexName,]
      print(visualPlot)
      visualPlot <- na.omit(visualPlot)
      visualPlot$count <- as.numeric(visualPlot$count)
      visualPlot$p_25 <- as.numeric(visualPlot$p_25)
      visualPlot$p_75 <- as.numeric(visualPlot$p_75)
      visualPlot$median <- as.numeric(visualPlot$median)
      if(nrow(visualPlot) != 0){
      plot_ly(visualPlot, x = ~yyymm, y = ~count, type = 'scatter', mode = 'lines',name='') %>%
        add_segments(x=visualPlot$yyymm[1],xend=visualPlot$yyymm[length(visualPlot$yyymm)],y=unique(visualPlot$p_25),yend=unique(visualPlot$p_25),name='percentile 25') %>%
        add_segments(x=visualPlot$yyymm[1],xend=visualPlot$yyymm[length(visualPlot$yyymm)],y=unique(visualPlot$p_75),yend=unique(visualPlot$p_75),name='percentile 75') %>%
        add_segments(x=visualPlot$yyymm[1],xend=visualPlot$yyymm[length(visualPlot$yyymm)],y=unique(visualPlot$median),yend=unique(visualPlot$median),name='median')
      }
    })
  })

  #message__lineChart__click
  lapply(1:length(message__lineChart__click), function(i){
    name <- paste0('message__lineChart__click',i)
    output[[name]] <-   DT::renderDataTable({
      table <- message__lineChart__click[[i]]
      table
    },options = list(
      pageLength = 5
    ),selection='single')
  })

  # piePlot
  lapply(1:length(piePlotSet), function(i){
    name <- paste0('piePlot',i)
    output[[name]] <-   renderPlotly({
      plot_ly(piePlotSet[[i]], labels = ~category, values = ~count_val, type = "pie", source = name) %>%
        layout(showlegend = F)
    })
  })

  # barPlot
  lapply(1:length(barPlotSet), function(i){
    name <- paste0('barPlot',i)
    sourceName <- paste0('piePlot',i)
    output[[name]] <-   renderPlotly({
      d <- event_data("plotly_click",source = sourceName)
      myPoint <- d$pointNumber+1
      point <- tolower(piePlotSet[[i]]$category[myPoint])
      barPlotSet[[i]]$category <- tolower(barPlotSet[[i]]$category)
      zz <- barPlotSet[[i]][barPlotSet[[i]]$category == point,]
      zz$count_val <- as.numeric(zz$count_val)
      plot_ly(zz, x= ~stratum1,y=~count_val,type='bar')

    })
  })

  # barPlot__default
  lapply(1:length(barPlot__default), function(i){
    name <- paste0('barPlot__default',i)
    sourceName <- paste0('barPlot__default',i)
    output[[name]] <-   renderPlotly({
      plot_ly(barPlot__default[[i]], x= ~stratum1,y=~count_val,type='bar')

    })
  })


  # MassageBox
  lapply(1:length(messageBoxSet), function(i){
    name <- paste0('messageBox',i)
    output[[name]] <-   DT::renderDataTable({
      table <- messageBoxSet[[i]]
      table
    },options = list(
      pageLength = 5
    ))
  })

  # boxplot
  lapply(1:length(boxplotSet), function(i){
    name <- paste0('boxplot',i)
    output[[name]] <-   renderPlot({
      ggplot(boxplotSet[[i]],aes(factor(patfg),diff_date)) + geom_boxplot(aes(fill=(patfg))) + geom_jitter()
    })
  })

  # boxPlot__click
  lapply(1:length(boxplot__clickSet), function(i){
    name <- paste0('boxPlot__click',i)
    output[[name]] <-   renderPlot({
      selectedrowindex <- input[[paste0('messageBox__click',i,'_rows_selected')]]
      selectedrowindex <- as.numeric(selectedrowindex)
      indexName <- messageBox__click[[i]][selectedrowindex,'concept_id']
      visualPlot <- boxplot__clickSet[[i]][boxplot__clickSet[[i]]$patfg %in% indexName,]
      visualPlot$diff_date <- as.numeric(visualPlot$diff_date)


      ggplot(visualPlot,aes(factor(patfg),diff_date)) + geom_boxplot(aes(fill=(patfg))) + geom_jitter()
    })
  })

  # MassageBox__click
  lapply(1:length(messageBox__click), function(i){
    name <- paste0('messageBox__click',i)
    output[[name]] <-   DT::renderDataTable({
      table <- messageBox__click[[i]]
      table
    },options = list(
      pageLength = 5
    ))
  })

  # daliyVisitType
  lapply(1:length(daliyVisitType), function(i){
    name <- paste0('daliyVisitType',i)
    output[[name]] <-   renderPlotly({
      daliyVisitType[[i]] %>% group_by(patfg) %>%
        plot_ly(x = ~daily_visit_cnt,y=~count_val,type='scatter',color=~patfg,mode='lines')
    })
  })

  #visNetwork
  output$network <- renderVisNetwork({
    visNetwork(nodes, edges,width = '100%',height='100%') %>%
      visExport() %>%
      visOptions(selectedBy = list(variable = "group", selected = "meta")) %>%
      visEdges(arrows = "from") %>%
      addFontAwesome() %>%
      visLegend(zoom = T) %>%
      visInteraction(hover = TRUE) %>%
      visEvents(hoverNode = "function(nodes) {
                Shiny.onInputChange('current_node_id', nodes);
                ;}")
  })

  #button
  reg_data <- eventReactive(input$actionbutton1,{
    connection <- DatabaseConnector::connect(connectionDetails = ConnectionDetails)
    sqlList <- SqlRender::readSql(file.path(.libPaths()[1],'DQUEEN','sql','sql_server','Regression_Query','regression.sql'))
    sqlList <- SqlRender::splitSql(sqlList)
    concept_id <- as.numeric(input$textInput1)
    result <- c()
    for(i in 1:length(sqlList)){
      sql <- SqlRender::renderSql(sqlList[i],
                                  cdmSchema = cdmSchema,
                                  concept_id = concept_id)$sql
      sql <- SqlRender::translateSql(sql, targetDialect = attr(connection, "dbms"))$sql
      result[[i]] <- DatabaseConnector::dbGetQuery(connection,sql)
    }
    return(result)
  })

  # regression
  lapply(1:length(1:2), function(i){
    name <- paste0('regression',i)
    output[[name]] <-   renderPlot({

      visualPlot <- reg_data()[[i]]
      visualPlot <- na.omit(visualPlot)
      ggplot(data=visualPlot,aes(x=age,y=value_as_number))+geom_count()+geom_smooth(method="lm")
    })
  })

  # regression__table
  lapply(1:length(regression__table), function(i){
    name <- paste0('regression__table',i)
    output[[name]] <-   DT::renderDataTable({
      concept_id <- as.numeric(input$textInput1)
      table <- regression__table[[i]][regression__table[[i]]$concept_id %in% concept_id,]
      table
    },options = list(
      pageLength = 5
    ))
  })

  output$shiny_return <- renderTable({
    edges[edges$from==input$current_node_id,]

  },width = '120%')


  output$image2 <- renderImage({


    list(
      src = "D:/git/temp/dqueen/R/www/ajou_test.png",
      contentType = "image/png",
      alt = "Face"
    )

  }, deleteFile = FALSE)


    })
