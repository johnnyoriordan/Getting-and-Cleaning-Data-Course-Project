
library(dplyr)


# Downloading the data

filename <- "Coursera_DS3_Final.zip"


if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  

if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}


# Storing each file in a data frame

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")


# Merging the training data sets and test data sets into one data frame called Merged_Data

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)


# Extracting the mean and standard deviation for each measurement

Mean_Std_Data <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))


# Giving the activities descriptive names

Mean_Std_Data$code <- activities[Mean_Std_Data$code, 2]


# Giving the variables appropriate descriptive names:

names(Mean_Std_Data)[2] = "activity"
names(Mean_Std_Data) <- gsub("Acc", "Accelerometer", names(Mean_Std_Data))
names(Mean_Std_Data) <- gsub("Gyro", "Gyroscope", names(Mean_Std_Data))
names(Mean_Std_Data) <- gsub("BodyBody", "Body", names(Mean_Std_Data))
names(Mean_Std_Data) <- gsub("Mag", "Magnitude", names(Mean_Std_Data))
names(Mean_Std_Data) <- gsub("^t", "Time", names(Mean_Std_Data))
names(Mean_Std_Data) <- gsub("^f", "Frequency", names(Mean_Std_Data))
names(Mean_Std_Data) <- gsub("tBody", "TimeBody", names(Mean_Std_Data))
names(Mean_Std_Data) <- gsub("-mean()", "Mean", names(Mean_Std_Data), ignore.case = TRUE)
names(Mean_Std_Data) <- gsub("-std()", "STD", names(Mean_Std_Data), ignore.case = TRUE)
names(Mean_Std_Data) <- gsub("-freq()", "Frequency", names(Mean_Std_Data), ignore.case = TRUE)
names(Mean_Std_Data) <- gsub("angle", "Angle", names(Mean_Std_Data))
names(Mean_Std_Data) <- gsub("gravity", "Gravity", names(Mean_Std_Data))


# Creating another tidy data set with the average of each variable for each activity and each subject.

Tidy_Data <- Mean_Std_Data %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(Tidy_Data, "Tidy_Data.txt", row.name=FALSE)