# This script trasform data, that collected from the accelerometers 
# from the Samsung Galaxy S, in the manner that described below in comments.
# Dataset described at  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# and downloaded from   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# Scrip estimate that downloaded file unziped to the R work directory
# Comments numbered as in assignment on Coursera, where applicable

# load data to R
X_test <- read.csv("UCI HAR Dataset/test/X_test.txt", sep = "", header=F)
subject_test <- read.csv("UCI HAR Dataset/test/subject_test.txt", sep = "", header = F)
y_test <- read.csv("UCI HAR Dataset/test/y_test.txt", sep = "", header = F)

X_train <- read.csv("UCI HAR Dataset/train/X_train.txt", sep = "", header=F)
subject_train <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep = "", header = F)
y_train <- read.csv("UCI HAR Dataset/train/y_train.txt", sep = "", header = F)

features_names <- read.csv("UCI HAR Dataset/features.txt", sep = "", header = F)
activity_labels <- read.csv("UCI HAR Dataset/activity_labels.txt", sep = "", header = F)


# 1. Merges the training and the test sets to create one data set for Human Activity Recognition.
HAR_features <- rbind(X_train, X_test)
HAR_subject <- rbind(subject_train, subject_test)
HAR_activity_code <- rbind(y_train, y_test)


# 4. Appropriately labels the data set with descriptive variable names.
names(HAR_features) <- features_names[[2]]

# Add two variables that were in separate object and give them descriptive names
HAR_features$Activity <- HAR_activity_code[[1]]
HAR_features$Subject <- HAR_subject[[1]]

# Remove objects that take a lot of memory and not will not used in future
rm("X_train","subject_train","y_train","X_test","subject_test","y_test", "HAR_activity_code", "HAR_subject")


# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
HAR_features_mean_std <- HAR_features[, c("Subject", "Activity", 
                                          grep("mean|std",features_names[[2]], value = T))]
# Give to variable names more suitable form
names(HAR_features_mean_std) <- gsub("std","Std",gsub("mean","Mean",gsub("\\(\\)|-", "", 
                                         names(HAR_features_mean_std)))) 

# Remove objects that take a lot of memory and not will not used in future
rm("HAR_features")

# 3. Uses descriptive activity names to name the activities in the data set
HAR_features_mean_std$Activity <- as.factor(HAR_features_mean_std$Activity)
levels(HAR_features_mean_std$Activity)<- activity_labels[[2]]

# 5. From the "HAR_features_mean_std", creates a second, independent tidy data set with the 
# average of each variable for each activity and each subject.
# I use "dplyr" package to resolve this point.
# To names of aggragated varibales I add suffix "_Avg".
library(dplyr)
HAR_Avgs <- HAR_features_mean_std %>% 
    group_by(Subject, Activity) %>%
    summarise_all(funs(Avg = mean))

# Write result tidy dataset to the file
write.table(HAR_Avgs, "HAR_Avgs.txt", row.name=FALSE)             
    