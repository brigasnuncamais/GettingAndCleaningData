##########################################################################################################

## Coursera Getting and Cleaning Data Course Project
## Pierre Vettori
## 2015-03-10

# runAnalysis.r File Description:
# 
# sample run command :
#   RetDataset <- run_analysis()
# 
# The below run_analysis function will perform the following steps on the UCI HAR Dataset downloaded from 
# 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',
# (provided that this file is unzipped in the current R working directory) :
# 1. Merge the training and the test sets to create one data set,
# 2. Extract only the measurements on the mean and standard deviation for each measurement,
# 3. Use descriptive activity names to name the activities in the data set,
# 4. Appropriately label the data set with descriptive variable names,
# 5. Create a second, independent tidy data set with the average of (each variable, each activity, each subject). 

##########################################################################################################
# The below Read_Dataset function will perform the following steps
# a. calculate file names related to purpose
# b. Create test or train dataset merging subjects, activities and data
# c. Appropriately label the data set with descriptive variable names,
# Parameters:
# purpose : "test" or "train" string
# Lablname : Activity label vector
# Features : Column name data.frame

Read_Dataset <- function(purpose,Lablname,Features) {

  # a. calculate file names considering test or train directories
  SubjFilename <- sprintf("./%s/subject_%s.txt",purpose,purpose);
  ActFilename <- sprintf("./%s/y_%s.txt",purpose,purpose);
  DataFilename <- sprintf("./%s/X_%s.txt",purpose,purpose);
  
  # b. Create test or train dataset merging subjects, activities ...
  # (column names are set to "Subject","ActivityNo" and "Activity")
  CurrData <- read.table(SubjFilename, sep = " ",col.names=c("Subject"));
  CurrData <- cbind(CurrData, read.table(ActFilename, sep = " ",col.names=c("ActivityNo")));
  CurrData <- cbind(CurrData, Activity = names(Lablname[CurrData$ActivityNo]));
  colnames(CurrData)  <- c("Subject","ActivityNo","Activity");
  
  # c. ...and data. Appropriately label the data set with descriptive variable names,
  CurrXData <- read.table(DataFilename,col.names=Features[,2]);
  CurrData <- cbind(CurrData, CurrXData);
}

##########################################################################################################
# The below run_analysis function will perform the following steps
# a. calculate common files names
# b. calculate Activity label vector and Features data.frame
# c. read test and training datasets
# 1. Merge the training and the test sets to create one data set,
# 2. Extract only the measurements on the mean and standard deviation for each measurement
# Parameters: none

run_analysis <- function() {
  
  if (!require("plyr")) {
    install.packages("plyr")
  }
  
  require("plyr");
  
 # a. calculate common files names
  LablFilename <- "./activity_labels.txt";
  FeaturesFilename <- "./features.txt";
  
  # b. read them in Activity label vector and Features data.frame
  LablLookup <- 
    read.table(LablFilename, sep = " ",stringsAsFactors = FALSE, col.names=c("ActivityNo","Activity"));
  Lablnames <- as.numeric(1:length(unique(LablLookup$ActivityNo)));
  names(Lablnames) <- unique(LablLookup$Activity);
  Features = read.table(FeaturesFilename,header=FALSE);
  
  # c. call twice Read_Dataset function for test and training datasets
  TestData <- Read_Dataset("test",Lablnames,Features);
  TrainData <- Read_Dataset("train",Lablnames,Features);
  
  # 1. Merge the training and the test sets to create one data set
  FinalData = rbind(TrainData,TestData);
  
  # Create a vector for the column names from this dataset
  colNames  = colnames(FinalData);
  
  # Create a logicalVector containing:
  # TRUE values for the IDs Subject, Activity, mean & std columns,
  # FALSE for others (including meanFreq)
  KeptColumns = grepl("Subject",colNames) | grepl("Activity",colNames) |
         grepl("mean",colNames) & !grepl("meanFreq",colNames) |
         grepl("std",colNames);
  
  # 2. Extract only the measurements on the mean and standard deviation for each measurement
  FinalData = FinalData[KeptColumns==TRUE];
  
  # 5. Create a second, independent tidy data set with the average of each variable by (activity,subject).
  TidyData <- ddply(FinalData, .(Subject, Activity),
                    function(x) colMeans(x[, setdiff(names(FinalData),c("Subject","Activity","ActivityNo"))]))
  
  # write this dataset in "TidyData.txt" flat file
  write.table(TidyData, "TidyData.txt", row.names=FALSE)
  TidyData
}
