## This script reads all the data files into R as tables. 
## Datafiles assumed to be unzipped and in folders under the working directory.
## All files are run thru tbl_df to prep for using dplyr except features

library(dplyr)
library(tidyr)

print("Reading test data files")

subjectTest <- read.table("test/subject_test.txt")
subjectTest <-tbl_df(subjectTest)

xTest <- read.table("test/X_test.txt")
xTest <- tbl_df(xTest)
yTest <- read.table("test/y_test.txt")
yTest <- tbl_df(yTest)

print("Reading training data files")
subjectTrain <- read.table("train/subject_train.txt")
subjectTrain <- tbl_df(subjectTrain)

xTrain <- read.table("train/X_train.txt")
xTrain <- tbl_df(xTrain)
yTrain <- read.table("train/y_train.txt")
yTrain <- tbl_df(yTrain)

print("labelling columns of test and training DFs with feature names")
features <- read.table("features.txt", stringsAsFactors = FALSE)

## label columns of xTest and xTrain with feature names

featureLabels <- features[,2]
colnames(xTest) <- featureLabels
colnames(xTrain) <- featureLabels

## The original data dictionary contained duplicate feature names for data
## separated into energy bands. These columns are not required for this 
## project and are deleted to avoid duplicate column name errors.

xTest <- xTest[, !duplicated(colnames(xTest))] 
xTrain <- xTrain[, !duplicated(colnames(xTrain))]


print("adding activity and subject code columns")

colnames(yTest) <- "activityCode"
xTestC <- cbind(yTest, xTest)

colnames(yTrain) <- "activityCode"
xTrainC <- cbind(yTrain, xTrain)

colnames(subjectTest) <- "subjectCode"
xTestC <- cbind(subjectTest, xTestC)

colnames(subjectTrain) <- "subjectCode"
xTrainC <- cbind(subjectTrain, xTrainC)



print("Merging test and train data")

## Add type column to distinguish between test and traning")

xTestC <- mutate(xTestC, type = "test")
xTrainC <- mutate(xTrainC, type = "train")

harComp <- merge(xTestC, xTrainC, all = TRUE)

## add meaningful activity labels
activityKey = c(walking=1, walkingUpstairs=2, walkingDownstairs=3,
                sitting=4, standing=5, laying=6)
harComp$activity <- names(activityKey)[match(harComp$activityCode,activityKey)]

##select requested subset of data

meancols <- grep("mean[^F]", names(harComp))
stdcols <- grep("std[^F]", names(harComp))
harsub <- select(harComp, c(1,2,481,480,meancols, stdcols))

## tidy up the data

print("Tidy and summarize the data")

har <- harsub %>% gather(measure, value, 5:70) %>% 
    separate(measure, c("measure", "summary", "coord"))

harSummary <- har %>% 
    group_by(activity, subjectCode, type, measure, summary, coord) %>% 
    summarize(mean(value))
