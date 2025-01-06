library(readxl)
setwd("./surfdrive - X. Zhou@surfdrive.surf.nl/Proj-joint-green-reputation/code/Pre-exp/Data/N100")

# -----------------
# group 1
# -----------------
# ------ find the id of agents who does not transfrom till the end
T2G <- read_excel("./N100Alpha025k050_dynamicT2G.xlsx",
                  sheet = "Sheet1",
                  col_names = FALSE)
which(T2G[51*7,]==0)
# 18  65 ---- id of agents who didn't transfrom till the end

# ------ check the dynamic trend of their neighbors
adj <- read_excel("./N100Alpha025k050_dynamicAdjMatrix.xlsx",
                  sheet = "Sheet1",
                  col_names = FALSE)

jr <- read_excel("./N100Alpha025k050_dynamicJR.xlsx",
                 sheet = "Sheet1",
                 col_names = FALSE)
# expid = 7
exp_7 <- adj[(51*100*6+1):(51*100*7),]
nrow(exp_7)
# number of neighbors of id=2,10,14,49,53,77,93 in the last 
for (id in c(18, 65)) {
  print(paste0("The id of neighbors of ",
               id,
               " in the last five times steps are:"))
  for (iter in c(5:1)) {
    print(paste0("The number of neighbors is ", sum(exp_7[(100*(51-iter)+id),])))
    print(which(exp_7[(100*(51-iter)+id),] ==1))
    print(paste0("The JR is ", jr[(51*7-iter+1), id]))
  }
}


# -----------------
# group 2
# -----------------
adj <- read_excel("./N100Alpha025k025_dynamicAdjMatrix.xlsx",
                  sheet = "Sheet1",
                  col_names = FALSE)

jr <- read_excel("./N100Alpha025k025_dynamicJR.xlsx",
                 sheet = "Sheet1",
                 col_names = FALSE)

ncol(adj)
colnames(adj) <- seq(1,100,1)

exp_15 <- adj[(100*51*14+1):(100*51*15),]
nrow(exp_15)

# number of neighbors of id=2,10,14,49,53,77,93 in the last 
for (id in c(2, 10,14,49,53,77,93)) {
  print(paste0("The id of neighbors of ",
               id,
               " in the last five times steps are:"))
  for (iter in c(5:1)) {
    print(paste0("The number of neighbors is ", sum(exp_15[(100*(51-iter)+id),])))
    print(which(exp_15[(100*(51-iter)+id),] ==1))
    print(paste0("The JR is ", jr[(51*15-iter+1), id]))
  }
}

# -----------------
# group 3
# -----------------
T2G <- read_excel("./N100Alpha050k050_dynamicT2G.xlsx",
                  sheet = "Sheet1",
                  col_names = FALSE)
which(T2G[51*16,]==0)
# 44 ---- id of agents who didn't transfrom till the end
jr <- read_excel("./N100Alpha050k050_dynamicJR.xlsx",
                 sheet = "Sheet1",
                 col_names = FALSE)
jr[51*16, 44] # JR of 44 is 0.492
# ------ check the dynamic trend of their neighbors
adj <- read_excel("./N100Alpha050k050_dynamicAdjMatrix.xlsx",
                  sheet = "Sheet1",
                  col_names = FALSE)
# expid = 16
exp_16 <- adj[(51*100*15+1):(51*100*16),]
nrow(exp_16)
# number of neighbors of id=2,10,14,49,53,77,93 in the last 
for (id in c(44)) {
  print(paste0("The id of neighbors of ",
               id,
               " in the last five times steps are:"))
  for (iter in c(5:1)) {
    print(paste0("The number of neighbors is ", sum(exp_16[(100*(51-iter)+id),])))
    print(which(exp_16[(100*(51-iter)+id),] ==1))
    print(paste0("The JR is ", jr[(51*16-iter+1), id]))
  }
}