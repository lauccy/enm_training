library(dismo)
library(rJava)
# biomod2
#read the data from the CSV files
occ<-read.csv("Data/occ.csv", stringsAsFactors = F)
#Load the environmental variables
getwd()
# env_vars<-list.files("Data/bioclim/10minus", pattern="\\.asc", full.names=T) #
# env_vars
# predictors<-stack(env_vars) # does not work, ljx will modify to make the code run

setwd("D:/工作/2013 PFS-Tropical Asia/PFS_Fixed_AFEC-X/AFEC-X 2021/PPTs etc/1111-12 QiaoHJ_SDM/enm_training/Data/bioclim/10minus")
env_vars<-list.files(pattern="\\.asc")
env_vars
predictors<-stack(env_vars)
plot(predictors) # plot the stacked environmental variables to have a look
bg <- randomPoints(predictors, 1000)
# maxent_model<-maxent(predictors, occ[, 2:3])
maxent_model<-maxent(predictors, occ[, 2:3], a = bg)

# plot showing importance of each variable
plot(maxent_model)

# response curves
response(maxent_model)

# predict to entire dataset
r <- predict(maxent_model, predictors) 

# with some options:
# r <- predict(me, predictors, args=c("outputformat=raw"), progress='text', 
#      filename='maxent_prediction.grd')

plot(r)
points(occ[, 2:3])
points(occ$x, occ$y, pch = ".")

#testing
# background data
bg <- randomPoints(predictors, 1000)

#simplest way to use 'evaluate'
e1 <- evaluate(maxent_model, p=occ[,2:3], a=bg, x=predictors)
plot(e1, 'ROC')
threshold(e1)
