library(reshape2)  
pathTopFolder   = "./UCI HAR Dataset/"

loadDataFile <- function(directory, suffix) {
  pathDataFolder  = paste0(pathTopFolder, directory)
  pathX           = paste0(pathDataFolder, "X_", suffix, ".txt")
  pathY           = paste0(pathDataFolder, "y_", suffix, ".txt")
  pathSubject     = paste0(pathDataFolder, "subject_", suffix, ".txt")
  
  # First, read the cols names
  dfColNames <- read.table(file.path(paste0(pathTopFolder, "features.txt")), col.names = c("MeasureID", "MeasureName"))
  
  # Then read the X data    
  dfData <- read.table(file.path(pathX), col.names = dfColNames$MeasureName)
  
  # In the end, we'll only be interested in the mean and standard deviations
  # So, let's discard the rest right now
  onlyMeanStdCols <- grep(".*mean\\(\\)|.*std\\(\\)", dfColNames$MeasureName)
  dfData <- dfData[,onlyMeanStdCols]
  
  # Finally (1/2), read and append the y data
  dfDataY <- read.table(file.path(pathY), col.names = c("ActivityID"))
  dfData$ActivityID <- dfDataY$ActivityID
  
  # Finally (2/2), read and append the subject data
  dfDataSubject <- read.table(file.path(pathSubject), col.names = c("SubjectID"))
  dfData$SubjectID <- dfDataSubject$SubjectID
  
  dfData
}

tidy <- function(outputFilename) {
  print('About to create the clean data set...')
  
  # Merge test and train data
  data <- rbind(loadDataFile("test/", "test"), loadDataFile("train/", "train"))
  
  # Turn 'tBodyAcc.mean...X' into 'tBodyAccMeanX'
  niceNames <- colnames(data)
  niceNames <- gsub("\\.+mean\\.+", niceNames, replacement="Mean")
  niceNames <- gsub("\\.+std\\.+", niceNames, replacement="Std")
  colnames(data) <- niceNames
  
  # Apply activity labels
  activity <- read.table(paste0(pathTopFolder, "activity_labels.txt"), as.is = TRUE, col.names=c("ActivityID", "ActivityName"))
  activity$ActivityName <- as.factor(activity$ActivityName)
  data_labeled <- merge(data, activity)
  
  # Create the tidy dataset
  allIDs <- c("ActivityID", "ActivityName", "SubjectID")
  measures <- setdiff(colnames(data_labeled), allIDs)
  melted_data <- melt(data_labeled, id = allIDs, measure.vars = measures)
  tidyDataset <- dcast(melted_data, ActivityName + SubjectID ~ variable, mean)   
  
  head(tidyDataset)
  # Write the output
  write.table(tidyDataset, outputFilename)
  print('Done.')
}

# tidy('clean.txt')