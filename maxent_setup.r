# running Maxent in R
# https://github.com/shandongfx/workshop_maxent_R/blob/master/code/Appendix1_case_study.md

##1. Set up the working environment

###1.1 Load packages

library("raster")
library("dismo")
library("rgeos")
library("rJava") # need to install java separately, download and install from https://www.java.com/zh-CN/download/


###1.2 Set up the Maxent path
# download maxent.jar 3.3.3k, and place the file in the
# desired folder
utils::download.file(url = "https://raw.githubusercontent.com/mrmaxent/Maxent/master/ArchivedReleases/3.3.3k/maxent.jar", 
                     destfile = paste0(system.file("java", package = "dismo"), 
                                       "/maxent.jar"), mode = "wb")  ## wb for binary file, otherwise maxent.jar can not execute

### 我建议，去网站单独下载新版maxent然后手动放到相应文件夹
###### download maxent separately from https://biodiversityinformatics.amnh.org/open_source/maxent/
####### then copy the maxent jar file into the dismo package of R which can be found with:
system.file("java", package="dismo") #go into the folder this code returns and put the maxent java file in there
