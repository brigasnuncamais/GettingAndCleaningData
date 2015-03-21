---  
title: "Getting and Cleaning Data Course Project"
author: "brigasnuncamais"
date: "Saturday, March 21, 2015"
output: html_document
---  


- `CodeBook.md` describes the variables, the data, and any transformations or work that was performed to clean up the data.  
- It also contains some R code to generate part of its own content.  

### One R script called `run_analysis.R` does the following.  

- Merges the training and the test sets to create one data set.  
- Extracts only the measurements on the mean and standard deviation for each measurement.  
- Uses descriptive activity names to name the activities in the data set  
- Appropriately labels the data set with descriptive activity names.  
- Creates a second, independent tidy data set with the average of each variable for each activity and each subject.  

### Steps to reproduce this course project

- Download the data source and put into the R working directory
- Open the zipped file `getdata-projectfiles-UCI HAR Dataset.zip`  
- Go into `UCI HAR Dataset` subfolder  
- Select all and extract them in your R working directory  
- You'll have `test` and `train` folders and other project files there.
- Put `run_analysis.R` in the same place.
- `run_analysis.R` can be launched in RStudio by just importing the file:  
`source("run_analysis.R")`  
`RetDataset <- run_analysis()` 

### Dependencies

`run_analysis.R` file will install for you the dependencies automatically. It depends on `plyr`.
