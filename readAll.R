## This script reads all the data files into R as tables. 
## Datafiles assumed to be unzipped and in folders under the working directory.
## All files are run thru tbl_df to prep for using dplyr except features

library(dplyr)

subjectTest <- read.table("test/subject_test.txt")
subjectTest <-tbl_df(subjectTest)

xTest <- read.table("test/X_test.txt")
xTest <- tbl_df(xTest)
yTest <- read.table("test/y_test.txt")
yTest <- tbl_df(yTest)

subjectTrain <- read.table("train/subject_train.txt")
subjectTrain <- tbl_df(subjectTrain)

xTrain <- read.table("train/X_train.txt")
xTrain <- tbl_df(xTrain)
yTrain <- read.table("train/y_train.txt")
yTrain <- tbl_df(yTrain)

features <- read.table("features.txt", stringsAsFactors = FALSE)

## label columns of xTest and xTrain with feature names

featureLabels <- features[,2]
colnames(xTest) <- featureLabels
colnames(xTrain) <- featureLabels


