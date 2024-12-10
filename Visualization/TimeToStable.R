getwd()
setwd("../Pre-exp/Data/N100")

# Package
library(data.table)
library(ggplot2)
library(gridExtra)
library(readxl)

# library(facetscales)
library(tidyr)
library(scales)
library(patchwork)
library(latex2exp)
library(stringr)
library(forstringr)

## Calculate the time that it take to reach the stable state
# Idea: make use of the dynamicJR file, when it reaches to [1, 1, ..., 1] => stable
time_stable_cal <- function(T) { # T is the termination step when N=100, T=50
  # read files
  file_names = get_file_names_helper("dynamicJR")
  
  N = get_N_helper(file_names[1])
  
  # Ini
  alpha = c(rep(0, length(file_names)))
  k = c(rep(0, length(file_names)))
  aveTime = c(rep(0, length(file_names)))
  
  # prepare the dataframe for visualization
  for (i in 1:length(file_names)){
    alpha[i] = get_Alpha_helper(file_names[i])
    k[i] = get_K_helper(file_names[i])
    aveTime[i] = average_Time_helper(file_names[i], T, N)
  }
  
  df_ave_time <- data.frame(alpha,
                            k,
                            aveTime)
  
  # Create the heat map
  myplot <- ggplot(df_ave_time, aes(x = factor(k), y = factor(alpha), fill = aveTime)) +
    geom_tile(color = "black") +
    geom_text(aes(label = round(aveTime, 0)), color = "black") +
    scale_fill_gradient(low = "white", high = "red") +
    labs(
      title = "Time to Stable State",
      x = "k",
      y = "alpha",
      fill = "Time"
    ) +
    theme_minimal()
  fileName <- paste('N', N, "Time_to_Stable.pdf", sep = "_")
  ggsave(fileName, plot = myplot, height = 4.2, width = 7)
}

# helper functions
get_file_names_helper <- function(keywords){
  list.files(path = '.',
             pattern = paste(keywords,".*\\.xlsx", sep = ""),
             full.names = TRUE)
}

get_N_helper <- function(fullName){
  s = str_extract_part(fullName, pattern = "N", before = FALSE)
  s = str_extract_part(s, before = TRUE, pattern = "Alpha")
  return(as.numeric(s))
}

get_Alpha_helper <- function(fileName){
  s = str_extract_part(fileName, before = FALSE, pattern = "Alpha")
  s = str_extract_part(s, before = TRUE, pattern = "k")
  return(as.numeric(s)/100)
}

get_K_helper <- function(fileName){
  s = str_extract_part(fileName, before = FALSE, pattern = "k")
  s = str_extract_part(s, before = TRUE, pattern = "_")
  return(as.numeric(s)/100)
}

average_Time_helper <- function(fileName, T, N){
  fileName <- sub("\\~\\$", "", fileName)
  myDataframe <- read_excel(fileName, col_names = FALSE)
  
  repeatTimes <- nrow(myDataframe)/(T+1)
  
  time_to_stable <- c(rep(0, repeatTimes))
  
  for (i in 1:repeatTimes){
    # subDataFrame <- myDataframe[((i-1)*T+1):(T*i+1),]
    subDataFrame <- myDataframe[((i-1)*(T+1)+1):((T+1)*i),]
    row_sum <- rowSums(subDataFrame)
    t_to_stable <- which(row_sum == N)
    if (length(t_to_stable) == 0){ # not reaching the stable state yet
      time_to_stable[i] <- T
    }else{
      time_to_stable[i] <- t_to_stable[1]
    }
  }
  return(mean(time_to_stable))
}

time_stable_cal(50)

