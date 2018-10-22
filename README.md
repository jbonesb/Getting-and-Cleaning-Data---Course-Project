# Getting and Cleaning Data - Course Project

This is the course project for the Getting and Cleaning Data Coursera course.
The R script, `run_analysis.R`, does the following:

1. Loads both the training and test datasets from working directory as well as the activity and feature info.
2. Merge all training and test datasets.
3. Add labels into features dataset.
4. Add Subject and Activity info into features dataset with descriptive names
5. Extracts only the measurements on the mean and standard deviation for each measurement.
6. Converts the `activity` column into factor and set appropriate levels
7. Creates a tidy dataset that consists of the average (mean) value of each
   variable for each subject and activity pair and update variables names with "_Avg" suffix.

The end result in the file `HAR_Avgs.txt`.