# @file Achilles
#
# Copyright 2018 Observational Health Data Sciences and Informatics
#
# This file is part of Achilles
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# @author Jung hyun Byun
# @author Dongsu Park

#' The main DQUEEN 0analyses (for v5.3.1)
#'
#' @description

#' @param connectionDetails                An R object of type \code{connectionDetails} created using the function \code{createConnectionDetails} in the \code{DatabaseConnector} package.
dqueen <- function(ConnectionDetails,
                   level = 3,
                   etl_stdt = '2005-01-01',
                   etl_endt = '2015-12-31',
                   cdmSchema,
                   metaSchema ='',
                   resultSchema,
                   useRandomExtraction = FALSE,
                   extractioncdmSchema,
                   randParameter = 1000,
                   createddl = TRUE,
                   cdmAnalysis = TRUE,
                   makeShinyData = TRUE,
                   useVisnetwork=TRUE,
                   visnetworkCsvPath = c(),
                   runShiny =TRUE,
                   outputFolder = getwd(),
                   verboseMode = TRUE
){

  ParallelLogger::clearLoggers()
  unlink(file.path(outputFolder, "duqeen_log.txt"))

  if (verboseMode) {
    appenders <- list(ParallelLogger::createConsoleAppender(),
                      ParallelLogger::createFileAppender(layout = ParallelLogger::layoutParallel,
                                                         fileName = file.path(outputFolder, "duqeen_log.txt")))
  } else {
    appenders <- list(ParallelLogger::createFileAppender(layout = ParallelLogger::layoutParallel,
                                                         fileName = file.path(outputFolder, "duqeen_log.txt")))
  }

  logger <- ParallelLogger::createLogger(name = "dqueen",
                                         threshold = "INFO",
                                         appenders = appenders)
  ParallelLogger::registerLogger(logger)

  connection <- DatabaseConnector::connect(connectionDetails = ConnectionDetails)

  # RandomExtraction
  if(useRandomExtraction ==T){

    if(randParameter%%1!=0){
      stop('randparameter format is integer!')
    }
    sql <- readSql(file.path(.libPaths()[1],'DQUEEN','sql','sql_server','randomExtraction','extraction.sql'))
    sql <- SqlRender::render(sql,
                             warnOnMissingParameters=F,
                             targetCdmSchema = extractioncdmSchema,
                             originCdmSchema = cdmSchema,
                             randParameter = randParameter)
    sql <- SqlRender::translate(sql, targetDialect = attr(connection, "dbms"))
    startTime <- Sys.time()

    DatabaseConnector::executeSql(connection,sql)
    ParallelLogger::logInfo(sprintf("\n Extract data of %1.0f persons in %s -- COMPLETE (%f secs)",randParameter,extractioncdmSchema, Sys.time() - startTime))

  }

  ##cdm or randomExtraction cdm
  if(useRandomExtraction ==T){
    cdmSchema <- extractioncdmSchema
  }

  cdm <- substr(cdmSchema,1,gregexpr(pattern = '\\.',cdmSchema)[[1]]-1)
  if(metaSchema != ''){
    meta <- substr(metaSchema,1,gregexpr(pattern = '\\.',metaSchema)[[1]]-1)
  }

  ## CREATE DDL
  if(createddl == T){
    ddlFileList <- list.files(file.path(.libPaths()[1],'DQUEEN','ddl'),full.names = T)
    ddlFilenameList <- list.files(file.path(.libPaths()[1],'DQUEEN','ddl'),full.names = F)
    if(metaSchema == ''){
      includeMetaSchema <- c('04_dqueen_schema_capacity_data_ddl_meta')
      for(i in includeMetaSchema){
        ddlFileList <- ddlFileList[-grep(pattern = i,ddlFileList,fixed	=T)]
        ddlFilenameList <- ddlFilenameList[-grep(pattern = i,ddlFilenameList,fixed	=T)]
      }
    }
    for(i in 1:length(ddlFileList)){
      sql <- readSql(ddlFileList[i])
      sql <- SqlRender::render(sql,
                               warnOnMissingParameters=F,
                               resultSchema = resultSchema,
                               cdmSchema = cdmSchema,
                               metaSchema = metaSchema,
                               cdm = cdm)
      sql <- SqlRender::translate(sql, targetDialect = attr(connection, "dbms"))
      startTime <- Sys.time()

      DatabaseConnector::executeSql(connection,sql)
      ParallelLogger::logInfo(sprintf("\n Create DDL : %s -- COMPLETE (%f secs)",ddlFilenameList[i], Sys.time() - startTime))

    }
  }

  ## EXECUTE QUERY
  fileList <- list.files(file.path(.libPaths()[1],'DQUEEN','sql','sql_server'),full.names = T)
  sqlFileList <- fileList[grep(pattern = 'DQA',fileList)]

  if(cdmAnalysis == T){

    sqlList <- list()
    sqlListName <- list()
    for(i in 1:length(sqlFileList)){
      sqlList[[i]] <- list.files(file.path(sqlFileList[i],'cdm'),full.names = T)
      sqlListName[[i]] <- list.files(file.path(sqlFileList[i],'cdm'),full.names = F)
    }
    if(level >= 1 ){
      cdmQueryFile <- sqlList[[1]]
      for(i in 1:length(cdmQueryFile)){
        sql <- readSql(cdmQueryFile[i])
        sql <- SqlRender::render(sql,
                                 warnOnMissingParameters=F,
                                 resultSchema = resultSchema,
                                 cdmSchema = cdmSchema,
                                 cdm = cdm)
        startTime <- Sys.time()
        tryCatch({
          DatabaseConnector::executeSql(connection,sql)
          ParallelLogger::logInfo(sprintf("\n Analysis Lv.1 : %s -- COMPLETE (%f secs)",sqlListName[[1]][i], Sys.time() - startTime))
        },error = function(e){
          ParallelLogger::logError(sprintf("\n %s -- ERROR %s", sqlListName[[1]][i] , e))
        })
      }
    }
    if(level >= 2 ){
      if(metaSchema == ''){
        includeMetaSchema <- c('2125_277','2121_275','2120_274','2044_52')
        for(i in includeMetaSchema){
          sqlList[[2]] <- sqlList[[2]][-grep(pattern = i,sqlList[[2]],fixed	=T)]
          sqlListName[[2]] <- sqlListName[[2]][-grep(pattern = i,sqlListName[[2]],fixed	=T)]
        }
      }
      cdmQueryFile <- sqlList[[2]]
      for(i in 1:length(cdmQueryFile)){
        sql <- SqlRender::readSql(cdmQueryFile[i])
        sql <- SqlRender::render(sql,
                                 warnOnMissingParameters=F,
                                 resultSchema = resultSchema,
                                 cdmSchema = cdmSchema,
                                 metaSchema= metaSchema,
                                 etl_stdt = etl_stdt,
                                 etl_endt = etl_endt,
                                 cdm = cdm)
        startTime <- Sys.time()
        tryCatch({
          DatabaseConnector::executeSql(connection,sql)
          ParallelLogger::logInfo(sprintf("\n Analysis Lv.2 : %s -- COMPLETE (%f secs)",sqlListName[[2]][i], Sys.time() - startTime))
        },error = function(e){
          ParallelLogger::logError(sprintf("\n %s -- ERROR %s", sqlListName[[2]][i], e))
        })
      }
    }
    if(level >= 3 ){
      cdmQueryFile <- sqlList[[3]]
      for(i in 1:length(cdmQueryFile)){
        sql <- SqlRender::readSql(cdmQueryFile[i])
        sql <- SqlRender::render(sql,
                                 warnOnMissingParameters=F,
                                 resultSchema = resultSchema,
                                 cdmSchema = cdmSchema,
                                 etl_stdt = etl_stdt,
                                 etl_endt = etl_endt,
                                 cdm = cdm)
        startTime <- Sys.time()
        tryCatch({
          DatabaseConnector::executeSql(connection,sql)
          ParallelLogger::logInfo(sprintf("\n Analysis Lv.3 : %s -- COMPLETE (%f secs)",sqlListName[[3]][i], Sys.time() - startTime))
        },error = function(e){
          ParallelLogger::logError(sprintf("\n %s -- ERROR %s", sqlListName[[3]][i], e))
        })
      }
    }

  }

  if(level == 3 & cdmAnalysis == T){
    scoreData <- list.files(file.path(.libPaths()[1],'DQUEEN','sql','sql_server','score_script','02_cdm_score'),full.names = T)
    scoreDataName <- list.files(file.path(.libPaths()[1],'DQUEEN','sql','sql_server','score_script','02_cdm_score'),full.names = F)
    for(i in 1:length(scoreData)){
      sql <- SqlRender::readSql(scoreData[i])
      sql <- SqlRender::render(sql,
                               warnOnMissingParameters=F,
                               resultSchema = resultSchema,
                               cdmSchema = cdmSchema
      )
      sql <- SqlRender::translate(sql, targetDialect = attr(connection, "dbms"))
      startTime <- Sys.time()
      tryCatch({
        DatabaseConnector::executeSql(connection,sql)
        ParallelLogger::logInfo(sprintf("\n Analysis CDM Score : %s -- COMPLETE (%f secs)",scoreDataName, Sys.time() - startTime))
      },error = function(e){
        ParallelLogger::logError(sprintf("\n %s -- ERROR %s", scoreDataName, e))
      })
    }

    ShinyData <- file.path(.libPaths()[1],'DQUEEN','sql','sql_server','Shiny_Data','01_Save_the_dqueen_shiny_data.sql')
    sql <- SqlRender::readSql(ShinyData)
    sql <- SqlRender::render(sql,
                             warnOnMissingParameters=F,
                             resultSchema = resultSchema,
                             cdmSchema = cdmSchema,
                             metaSchema= metaSchema,
                             check_level = level,
                             Stdt = etl_stdt,
                             Endt = etl_endt)
    sql <- SqlRender::translate(sql, targetDialect = attr(connection, "dbms"))
    startTime <- Sys.time()
    tryCatch({
      DatabaseConnector::executeSql(connection,sql)
      ParallelLogger::logInfo(sprintf("\n Create Shiny Data : %s -- COMPLETE (%f secs)","01_Save_the_dqueen_shiny_data.sql", Sys.time() - startTime))
    },error = function(e){
      ParallelLogger::logError(sprintf("\n %s -- ERROR %s", "01_Save_the_dqueen_shiny_data.sql", e))
    })
  }

  if(makeShinyData == T){

    #Save Variable
    tmpRdsFile <- c()
    rdsFile <- c()
    filePath <- file.path(.libPaths()[1],'DQUEEN','sql','sql_server','Shiny_SQL')
    fileList <- list.files(filePath,full.names = F)
    variableName <- unlist(lapply(fileList, function(x) substr(x,1,gregexpr(pattern = '\\.',x)[[1]]-1)))

    fileFullNameList <- list.files(filePath,full.names = T)
    for(i in 1:length(fileFullNameList)){

      sql <- SqlRender::splitSql(SqlRender::readSql(fileFullNameList[i]))

      for(k in 1:length(sql)){

        sqlQuery <- SqlRender::render(sql[k],
                                      warnOnMissingParameters=F,
                                      resultSchema = resultSchema,
                                      cdmSchema = cdmSchema)
        startTime <- Sys.time()
        tryCatch({
          tmpRdsFile[[k]] <-DatabaseConnector::dbGetQuery(connection,sqlQuery)
          ParallelLogger::logInfo(sprintf("\n Create Plot Data : %s -- COMPLETE (%f secs)",fileList[k], Sys.time() - startTime))
        },error = function(e){
          ParallelLogger::logError(sprintf("\n %s -- ERROR %s", fileList[k], e))
        })

      }

      rdsFile[[variableName[i]]] <- tmpRdsFile
      tmpRdsFile <- c()
    }

    rdsFile <<- rdsFile

    #Rader
    raderSet <<- raderFunction(rdsFile$rader[[1]])

    #CircleBar
    circleBarSet <<-circleBarFunction(rdsFile$circleBar[[1]])

    #bar
    barSet <<- barFunction(rdsFile$bar)


    #bar__vertical
    bar__verticalSet <<- bar__verticalFunction(rdsFile$bar__vertical)

    #lineChart
    lineChartSet <<- lineChartFunction(rdsFile$lineChart)

    #piePlot
    piePlotSet <<- rdsFile$piePlot

    #barPlot (* Must be paired with piePlot)
    barPlotSet <<- rdsFile$barPlot

    #barPlot__default
    barPlot__default <<- rdsFile$barPlot__default

    #MessageBox (* Change column Name, Number of Column Ok)
    messageBoxSet <<- rdsFile$messageBox

    #HeatmapSet
    heatmapSet <<- heatmapFunction(rdsFile$heatmap)


    #heatmapSet__table
    heatmapSet__table <<- rdsFile$heatmap__table

    #HeatmapTable
    heatmapSet

    #heatmapRowPlot
    visitPerson <<- rdsFile$heatmapRowPlot

    #HeatmapTableVisitPlot
    visitType <<- rdsFile$heatmapVisitPlot

    #visitCountPlot
    visitCountPlot <<- rdsFile$visitCountPlot


    #visitDataPlot
    visitDataPlot <<- rdsFile$visitDataPlot

    ##countBarPlot
    countBarPlot <<- rdsFile$countBarPlot

    #countBarTypePlot
    countBarTypePlot <<- rdsFile$countBarTypePlot


    #daliyVisitType
    daliyVisitType <<- rdsFile$daliyVisitType

    #boxplot
    boxplotSet <<- rdsFile$boxPlot

    #lineChart__click
    lineChart__click <<- rdsFile$lineChart__click

    #message__lineChart__click
    message__lineChart__click <<- rdsFile$message__lineChart__click

    #boxplot__click
    boxplot__clickSet <<- rdsFile$boxPlot__click

    #messageBox__click
    messageBox__click <<- rdsFile$messageBox__click

    #heatmap__regression
    heatmap__regression <<- rdsFile$heatmap__regression

    #regression__table
    regression__table <<- rdsFile$regression__table

    #donut
    DonutSet <- rdsFile$donut[[1]]
    DonutSet$name <- tolower(DonutSet$name)

    dataType <- c('meta','cdm')
    tableType <- c('Main','Person','Visit','Provider','Death','CareSite','Conditionoccurrence','DrugExposure','DeviceExposure','ProcedureOccurrence','Measurement')
    validationType <<- c('score','atemporal','relation','accuracy','value','completeness','uniqueness')
    outputId<- c()
    for(i in 1:length(dataType)){
      for(k in 1:length(tableType)){
        for(n in 1:length(validationType)){
          outputId <- c(outputId,paste0(dataType[i],tableType[k],validationType[n],'Donut'))
        }
      }
    }
    DonutSet <- rbind(DonutSet,data.frame('name' = setdiff(tolower(outputId),DonutSet$name),'value' = 0))
    DonutSet$value <- as.numeric(DonutSet$value)
    DonutSet <- rbind(DonutSet,data.frame('name' = 'totalscoredount','value' = sum(DonutSet[DonutSet$name == 'cdmmainscoredonut',2],DonutSet[DonutSet$name == 'metamainscoredonut',2])/2))
    DonutSet <<- DonutSet


    #etc
    checkLevel <- rdsFile$etc[[1]]
    checkLevel <<- paste0('Lv. ', checkLevel$check_level)

    dqScore <- rdsFile$etc[[2]]
    totalScoreDountPlot <- data.frame("name" = 'mainScore', 'value' = sum(as.numeric(dqScore[,2]))/nrow(dqScore))
    totalDqScore <<- sum(dqScore[,2])/nrow(dqScore)
    metaScore <<- dqScore[dqScore$stage_gb=='META',2]
    cdmScore <<- dqScore[dqScore$stage_gb=='CDM',2]

    dataStatus <- rdsFile$etc[[3]]
    dataStatus <<- paste(dataStatus$stage_gb,":",dataStatus$txt_val)

    dataPopulation <- rdsFile$etc[[4]]
    dataPopulation <<- paste(dataPopulation$stage_gb,":",dataPopulation$count_val)

    dataPeriod <- rdsFile$etc[[5]]
    dataPeriod <<- paste(dataPeriod$endt,"~",dataPeriod$stdt)

    dataVolume <- rdsFile$etc[[6]]
    dataVolume <<- paste(dataVolume$stratum2,":",dataVolume$num_val,dataVolume$stratum3)
  }


  if(useVisnetwork == T){
    myTable <- read.csv(visnetworkCsvPath[1],stringsAsFactors = F)
    myTable$META_TABLE <- tolower(myTable$META_TABLE)
    myTable$SOURCE_TABLE <- tolower(myTable$SOURCE_TABLE)

    myTable2 <- read.csv(visnetworkCsvPath[2],stringsAsFactors = F)
    myTable2$META_TABLE <- tolower(myTable2$META_TABLE)
    myTable2$CDM_TABLE <- tolower(myTable2$CDM_TABLE)

    metaNodes <- data.frame(id = unique(myTable$META_TABLE),label = unique(myTable$META_TABLE),group = 'meta')
    sourceNodes <- data.frame(id = unique(myTable$SOURCE_TABLE),label = unique(myTable$SOURCE_TABLE),group = 'source')
    cdmNodes <- data.frame(id = unique(myTable2$CDM_TABLE),label = unique(myTable2$CDM_TABLE),group = 'cdm')

    nodes <<- rbind(metaNodes,sourceNodes,cdmNodes)

    edges <- data.frame(from = myTable$META_TABLE, to = myTable$SOURCE_TABLE)
    edges2 <- data.frame(from = myTable2$CDM_TABLE, to = myTable2$META_TABLE)

    edges <- merge(edges,metaNodes,by.x ='from',by.y='id',all.x = T) %>% select(from,to) %>% 'colnames<-'(c("from", "to"))
    edges <- merge(edges,sourceNodes,by.x ='to',by.y='id',all.x = T) %>% select(from,to) %>% 'colnames<-'(c("from", "to"))
    edges$Rows <- NA

    edges2 <- merge(edges2,metaNodes,by.x ='to',by.y='id',all.x = T) %>% select(from,to) %>% 'colnames<-'(c("from", "to"))
    edges2 <- merge(edges2,cdmNodes,by.x ='from',by.y='id',all.x = T) %>% select(from,to) %>% 'colnames<-'(c("from", "to"))
    edges2$Rows <- NA

    edges <<- rbind(edges,edges2)
  }

  if(runShiny == T){
    path <- file.path(.libPaths()[1],"DQUEEN","shinyApp")
    shiny::runApp(path)
  }


}
