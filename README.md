# Assignment 4 - Getting and Cleaning Data (Coursera)

### Introduction

The data collected is timeseries data from accelerometers worn by 30 subjects of the experiment perfroming 6 different activities. The goal is to build a model which uses the sensor data to predict the activity of a user. The task is to convert the timeseries data into average values for each activity (per subject).  

### Requirements for task

1. Merge the training and the test sets to create one data set.
Use command rbind to combine training and test set
2. Extract only the measurements on the mean and standard deviation for each measurement.
Use grep command to get column indexes for variable name contains "mean()" or "std()"
3. Use descriptive activity names to name the activities in the data set
Convert activity labels to characters and add a new column as factor
4. Appropriately label the data set with descriptive variable names.Give the selected descriptive names to variable columns
5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

### How to reproduce analysis

Run the "run_analsys.R" script. This will:

1. Check if a data directory exists, if not it will create one. 
2. Check if the zip file has been downloaded, if not it will download it. 
3. Check if the data has been unzipped, if not it will unzip it
4. Read the relevant files
5. Perform the analysis tasks
6. Create a df_mean dataset and save it as tidydata.txt
