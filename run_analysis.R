# Merge components of UCI HAR dataset on smartphone data for
# activity and output as summarized tidy dataset

# Get feature names
features <- 
  read.table("./UCI HAR Dataset/features.txt"
  ,header = FALSE
  ,sep = "")

# Translate feature names to unique column names
colNames <- 
  gsub(
    "[.]{2}"
    ,""
    ,make.names(
      names = features[,2]
      ,unique = TRUE))

# Train data load starts here
  # Read train data file, assigning column names from colNames
  X_train <- 
    read.table(
      "./UCI HAR Dataset/train/X_train.txt"
      ,header = FALSE
      ,sep = ""
      ,col.names = colNames)
  # Load train activity labels
  y_train <-
    read.table(
      "./UCI HAR Dataset/train/y_train.txt"
      ,header = FALSE
      ,sep = "")
  names(y_train) <-
    "activity_label"
  # Load train subject labels
  subject_train <-
    read.table(
      "./UCI HAR Dataset/train/subject_train.txt"
      ,header = FALSE
      ,sep = "")
  names(subject_train) <- "subject"
  # Bind all train-related columns in one data frame
  allTrainData <- cbind(X_train,y_train,subject_train)
# Train data load ends here

# Test data load starts here
  # Read test data file, assigning column names from colNames
  X_test <- 
    read.table(
      "./UCI HAR Dataset/test/X_test.txt"
      ,header = FALSE
      ,sep = ""
      ,col.names = colNames)
  # Load test activity labels
  y_test <-
    read.table(
      "./UCI HAR Dataset/test/y_test.txt"
      ,header = FALSE
      ,sep = "")
  names(y_test) <- "activity_label"
  # Load test subject labels
  subject_test <-
    read.table(
      "./UCI HAR Dataset/test/subject_test.txt"
      ,header = FALSE
      ,sep = "")
  names(subject_test) <- "subject"
  # Bind all test-related columns in one data frame
  allTestData <- cbind(X_test,y_test,subject_test)
  
# Test data load ends here

# Combine training and test data
allData <- rbind(allTrainData,allTestData)

# Load activity labels
activity_labels <-
  read.table(
    "./UCI HAR Dataset/activity_labels.txt"
    ,header = FALSE
    ,sep = ""
    ,col.names =
      c("activity_label","activity"))

# Incorporate activity labels into results data frame
allData <- merge(allData,activity_labels)

# Determine mean and standard deviation columns
colsMeanAndStd <- grep("([.]std|[.]mean)", names(allData))

# Prefix column indexes with last two columns
colsToSelect <- c(ncol(allData),ncol(allData)-1,colsMeanAndStd)

# Select columns
tidyDS <- allData[,colsToSelect]

# Now use dplyr package to summarize
library(dplyr)
outputTidyDS <- 
  tidyDS %>%
  group_by(activity,subject) %>% 
  summarise_each(funs(mean))

# Output the summary dataset
write.table(
  outputTidyDS
  ,"SummaryUCIHAR.txt"
  ,row.name=FALSE
  ,sep = ","
  ,quote = FALSE)
