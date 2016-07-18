
if(!file.exists("./data")) dir.create("./data")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/projectData_getCleanData.zip")


listZip <- unzip("./data/projectData_getCleanData.zip", exdir = "./data")


train.x <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
train.y <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
train.subject <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
test.x <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
test.y <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
test.subject <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")


trainData <- cbind(train.subject, train.y, train.x)
testData <- cbind(test.subject, test.y, test.x)
fullData <- rbind(trainData, testData)



featureName <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[,2]


featureIndex <- grep(("mean\\(\\)|std\\(\\)"), featureName)
finalData <- fullData[, c(1, 2, featureIndex+2)]
colnames(finalData) <- c("subject", "activity", featureName[featureIndex])


activityName <- read.table("./data/UCI HAR Dataset/activity_labels.txt")


finalData$activity <- factor(finalData$activity, levels = activityName[,1], labels = activityName[,2])



names(finalData) <- gsub("\\()", "", names(finalData))
names(finalData) <- gsub("^t", "time", names(finalData))
names(finalData) <- gsub("^f", "frequence", names(finalData))
names(finalData) <- gsub("-mean", "Mean", names(finalData))
names(finalData) <- gsub("-std", "Std", names(finalData))


library(dplyr)
groupData <- finalData %>%
        group_by(subject, activity) %>%
        summarise_each(funs(mean))

write.table(groupData, "./Getting_and_Cleaning_data_Project/MeanData.txt", row.names = FALSE)
