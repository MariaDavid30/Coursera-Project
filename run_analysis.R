#Getting and cleaning data course project

#downloading the data using download.file()

url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
path<-"F:/online_courses/cleaning_project.zip"
download.file(url,path)

#Unzipping the zipped file 

unzip(zipfile="F:/online_courses/cleaning_project.zip",exdir="F:/online_courses")

#Reading train dataset

x_train <- read.table("F:/online_courses/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("F:/online_courses/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("F:/online_courses/UCI HAR Dataset/train/subject_train.txt")

#Reading test dataset

x_test <- read.table("F:/online_courses/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("F:/online_courses/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("F:/online_courses/UCI HAR Dataset/test/subject_test.txt")

#Reading feature file(contains all the variables)

feature <- read.table("F:/online_courses/UCI HAR Dataset/features.txt")

#Reading activity labels
activity_labels = read.table("F:/online_courses/UCI HAR Dataset/activity_labels.txt")

#Q1:

#Merging train datset using cbind()

train_merged<-cbind(x_train,y_train,subject_train)
train_merged

#Merging test dataset using cbind()

test_merged<-cbind(x_test,y_test,subject_test)
test_merged

#Merging x and y using rbind()

x_merged <- rbind(x_train, x_test)
y_merged <- rbind(y_train, y_test)
subject_merged <- rbind(subject_train, subject_test)

#Merging train and test datasets to create one single dataset using rbind()

merged_data<-rbind(train_merged,test_merged)
merged_data

#Q2:To extract only the measurements on the mean and standard deviation for each measurement.using grep()

names(merged_data)
mean_sd <- feature[grep("mean\\(\\)|std\\(\\)",feature[,2]),]
mean_sd
x_merged <- x_merged[,mean_sd[,1]]
x_merged


#Q3:Uses descriptive activity names to name the activities in the data set

names(y_merged) <- "activity"
y_merged$activitylabel <- factor(y_merged$activity, labels = as.character(activity_labels[,2]))
activitylabel <- y_merged[,-1]
activitylabel

#Q4:assigning variable names fron the feature file

colnames(x_merged) <- feature[mean_sd[,1],2]

#Q5:From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(dplyr)
names(subject_merged) <- "subject"

#creating the final dataset using cbind()

final_data<- cbind(x_merged,activitylabel,subject_merged)
final_data
final_data_mean <- final_data %>% group_by(activitylabel,subject) %>% summarize_each(funs(mean))
final_data_mean

#creating a table

write.table(final_data_mean, file = "F:/online_courses/UCI HAR Dataset/final_data.txt", row.names = FALSE)
