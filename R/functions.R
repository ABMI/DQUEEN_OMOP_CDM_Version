raderFunction <- function(dataSet){
  tempList <- list()
  for(i in 1:nrow(dataSet)){
    tempRaderScore <- melt(dataSet[i,])
    row.names(tempRaderScore) <- tempRaderScore$variable
    tempList[[i]] <- data.frame(tempRaderScore[-1],'perfect score'=rep(100,nrow(tempRaderScore)))
  }
  return(tempList)
}

circleBarFunction <- function(dataSet){
  tempList <- list()
  tempVector <- c()
  for(i in 1:nrow(dataSet)){
    for(k in 1:ncol(dataSet)){
      tempVector <- c(tempVector,rep(names(dataSet)[k],dataSet[i,k]))
    }
    tempList[[i]] <- tempVector
    tempVector <- c()
  }
  return(tempList)
}

barFunction <- function(dataSet){

  for(i in 1:length(dataSet)){
    dataSet[[i]] <- reshape2::melt(dataSet[[i]])
    dataSet[[i]] <- reshape::cast(data = dataSet[[i]],stage ~ stratum1)
    rownames(dataSet[[i]]) <- dataSet[[i]]$stage
    dataSet[[i]] <- dataSet[[i]][-1]
  }
  return(dataSet)
}

bar__verticalFunction <- function(dataSet){
  for(i in 1:length(dataSet)){
    rownames(dataSet[[i]]) <- dataSet[[i]]$'stratum1'
    dataSet[[i]] <- dataSet[[i]][-1]
  }

  return(dataSet)
}

lineChartFunction <- function(dataSet){
  for(i in 1:length(dataSet)){
    dataSet[[i]] <- na.omit(dataSet[[i]])
    dataSet[[i]] <- plyr::arrange(dataSet[[i]],cnt_yy)
    rownames(dataSet[[i]]) <- dataSet[[i]]$cnt_yy
    dataSet[[i]] <- dataSet[[i]][-1]
  }
  return(dataSet)
}

heatmapFunction <- function(dataSet){
  threshold = 100 # define not Available.
  for(i in 1:length(dataSet)){
    threshold_df <- data.frame('status' = dataSet[[i]]$rows < threshold,'index' = rep(1,nrow(dataSet[[i]])))
    dataSet[[i]] <- cbind(dataSet[[i]],threshold_df)
    tmpStatus <- gsub('FALSE','Avaliable',dataSet[[i]]$status)
    tmpStatus <- gsub('TRUE','not Avaliable',tmpStatus)
    dataSet[[i]]$status = tmpStatus
  }
  return(dataSet)
}

donutPlot <- function(score){
  scoreDonut <- data.frame(type = c("blank", 'score'), value = c(100-score, score)) %>%
    mutate(
      percentage = value / sum(value),
      hover_text = paste0(type, ": ", value)
    ) %>%
    mutate(percentage_label = paste0(round(100 * percentage, 1), "%"))
  return(scoreDonut)
}

donutPlotNoPer <- function(score){
  scoreDonut <- data.frame(type = c("blank", 'score'), value = c(100-score, score)) %>%
    mutate(
      percentage = value / sum(value),
      hover_text = paste0(type, ": ", value)
    ) %>%
    mutate(percentage_label = paste0(round(100 * percentage, 1), ""))
  return(scoreDonut)
}

drawDonutPlot <- function(scoreDonut,scoreColor){
  scoreDonutPlot <- ggplot(scoreDonut, aes(y = value, fill = type)) +
    geom_bar_interactive(
      aes(x = 1, tooltip = hover_text),
      width = 0.1,
      stat = "identity",
      show.legend = FALSE
    ) +
    ggplot2::annotate(
      geom = "text",
      x = 0,
      y = 0,
      label = scoreDonut[["value"]][scoreDonut[["type"]] == "score"],
      size = 20,
      color = scoreColor
    ) +
    scale_fill_manual(values = c(blank = "#ede4e4", score = scoreColor)) +
    coord_polar(theta = "y") +
    theme_void()
  return(scoreDonutPlot)
}

scoreColorFunction <- function(score){
  if(score >= 80){
    scoreColor = 'Green'
  }
  else if(score < 80 & score >= 50){
    scoreColor = 'Orange'
  }
  else{
    scoreColor = 'Red'
  }
  return(scoreColor)
}
