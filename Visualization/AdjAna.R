#---------- Load Packages ---------
# Install and load pacman if not already installed
if (!require("pacman")) install.packages("pacman")

# Use pacman to install and load the required packages
pacman::p_load(
  data.table,
  dplyr,
  latex2exp,
  ggplot2,
  gridExtra,
  readxl,
  readr,
  tidyr,
  scales,
  patchwork,
  stringr,
  forstringr
)


#----------- Visualize the distribution of the distribution of Adj at t -------
# Load the dataset
setwd("../Pre-exp/Data/N100")
Alpha = "025"
K = "025"
n = 100
fileName = paste0("N100Alpha", Alpha, "k", K, "_dynamicAdjMatrix.xlsx")
adj <- read_excel(fileName, col_names = FALSE)

terminationTime = nrow(adj)/(100*20) # 51
repeatTime = 20

# When reaching the stable state, adj fixed;
# Idea: Compare the initial distribution (t=1) with the final distribution
#       Order the degree of each type decrementally, and get the average of exps
#       Write the organized data in a CSV and visualize it

# ----- data praperation -----
t_series = seq(1, terminationTime, by = 1)
exp_series = seq(1, repeatTime, by = 1)

# Convert adj to a dataframe if it's not already one
adj_df <- as.data.frame(adj)

# Initialize adj_exp_t1 as a dataframe with the correct dimensions
adj_exp_t1 <- data.frame(matrix(0, nrow = length(exp_series) * n, ncol = ncol(adj_df)))
adj_exp_T <- data.frame(matrix(0, nrow = length(exp_series) * n, ncol = ncol(adj_df)))

# get the adj_matrix of t=1 over the exps
for (exp in exp_series) {
  adj_start = (exp-1)*terminationTime*n
  adj_exp_t1[(n*(exp-1)+1):(n*exp),] = adj_matrix[(adj_start+1):(adj_start+n),]
}

# get the adj_matrix of t=terminationTime over the exps
for (exp in exp_series) {
  adj_end = exp*terminationTime*n
  adj_exp_T[(n*(exp-1)+1):(n*exp),] = adj_matrix[(adj_end-n+1):adj_end,]
}

# Order the degree of each type decrementally, and get the average of exps
exp_id = rep(c(1:repeatTime), each = n)
agent_id = rep(c(1:n), times = repeatTime)
role = rep(c("Supplier", "Manufacturer", "Retailer"), each = round(n/3))
role = c(role, rep(c("Retailer"), times = n-(round(n/3))*3))
role = rep(role, times = repeatTime)
degree_t1 = rowSums(adj_exp_t1)
degree_T = rowSums(adj_exp_T)
df_degree_t1 = data.frame(degree_t1, exp_id, role, agent_id)
df_degree_T = data.frame(degree_T, exp_id, role, agent_id)

df_ordered_t1 <- df_degree_t1 %>%
  group_by(exp_id, role) %>% 
  arrange(desc(degree_t1), .by_group = TRUE)

df_ordered_t1_ave <- df_ordered_t1 %>%
  group_by(agent_id, role) %>%
  summarize(avg_ordered_degree = mean(degree_t1))

# ***********************
df_ordered_T <- df_degree_T %>%
  group_by(exp_id, role) %>% 
  arrange(desc(degree_T), .by_group = TRUE)


