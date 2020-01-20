## Getting and Cleaning Data - Assigment for Week 4 

## Download files if needed
if (!file.exists("data")) {
    dir.create("data")
}

if (!file.exists("data/accelerometers.zip")) {
    data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    
    download.file(url = data_url,
                  destfile = "data/accelerometers.zip", 
                  method = "curl")
}

if (!file.exists("./data/UCI HAR Dataset")) {
    unzip("./data/accelerometers.zip",exdir = "./data")
}

## load libs
library(dplyr)

## Input files
features <- "./data/UCI HAR Dataset/features.txt"
activity_labels <- "./data/UCI HAR Dataset/activity_labels.txt"
x_train <- "./data/UCI HAR Dataset/train/X_train.txt"
y_train <- "./data/UCI HAR Dataset/train/y_train.txt"
subject_train <- "./data/UCI HAR Dataset/train/subject_train.txt"
x_test <- "./data/UCI HAR Dataset/test/X_test.txt"
y_test <- "./data/UCI HAR Dataset/test/y_test.txt"
subject_test <- "./data/UCI HAR Dataset/test/subject_test.txt"

# reads the data
featurelist <- read.table(features, col.names = c("index","feature"))
featurelist$feature <- cleanup_feature_names(featurelist$feature)

x_train_df <- read.table(x_train, col.names = featurelist[,"feature"])
x_test_df <- read.table(x_test, col.names = featurelist[,"feature"])

y_train_df <- read.table(y_train, col.names = "activity")
y_test_df <- read.table(y_test, col.names = "activity")

subject_train_df <- read.table(subject_train, col.names = "subject")
subject_test_df <- read.table(subject_test, col.names = "subject")

## Number 1
## Merges the training and the test sets to create one data set
accel_data <- rbind(x_train_df, x_test_df) 

## Number 2
## Extracts only the measurements on the mean and standard deviation for each 
## measurement.
feature_selected_indices <- sort(c(grep("mean\\(\\)", featurelist$feature),
                                       grep("std\\(\\)", featurelist$feature)))

accel_subset <- accel_data[,feature_selected_indices]

# Number 3
## Uses descriptive activity names to name the activities in the data set
activity_df <- rbind(y_train_df, y_test_df)

activity_labels_df <- read.table(activity_labels)
activity_df$activity <- factor(activity_df$activity, 
                               levels = activity_labels_df[,1], 
                               labels = activity_labels_df[,2]) 

## Number 4
## Appropriately labels the data set with descriptive variable names.

cleanup_feature_names <- function(f) {
    ## Takes the list of features and cleans up the formatting a bit (not overboard)
    ## Note this function is specifically for the Human Activity Recognition data
    ## and shouldn't be used generally
    f <- sub("\\.\\.","",f)
    f <- tolower(f)
} 

names(accel_subset) <- cleanup_feature_names(names(accel_subset))

## Number 5
## From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.
subject_df <- rbind(subject_train_df,subject_test_df)
subject_df$subject  <- as.factor(subject_df$subject)

df <- cbind(subject_df, activity_df, accel_subset)

df_mean <- df %>% group_by(activity, subject) %>% summarise_all(mean)

write.table(df_mean, 
            file = "./tidydata.txt", 
            row.names = FALSE, 
            col.names = TRUE)