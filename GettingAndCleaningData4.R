## read data
features_Test  <- read.table("test/X_test.txt") 
features_Train <- read.table("train/X_train.txt") 

subject_Test  <- read.table("test/subject_test.txt")
subject_Train  <- read.table("train/subject_train.txt")

activity_Test  <- read.table("test/y_test.txt")
activity_Train <- read.table("train/y_train.txt")

data_Features  <- rbind(features_Test,features_Train)
data_Activity   <- rbind(activity_Test,activity_Train)
data_Subject   <- rbind(subject_Test,subject_Train)

names(data_Subject)<-c("subject")
names(data_Activity)<- c("activity")
features_Names <- read.table( "features.txt",head=FALSE)
names(data_Features)<- features_Names$V2

## 1. Merges the training and the test sets to create one data set.
dataCombine <- cbind(dataSubject, dataActivity)
data_all <- cbind(dataFeatures, dataCombine)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
selected_features_Names<-features_Names$V2[grep("mean\\(\\)|std\\(\\)", features_Names$V2)]
selected_Names<-c(as.character(selected_features_Names), "subject", "activity" )
data_all <-subset(data_all,select=selected_Names)

## 3. Uses descriptive activity names to name the activities in the data set
activity_Names <- read.table("activity_labels.txt",header = FALSE)
data_all$activity <-factor(data_all$activity)
data_all$activity <-factor(data_all$activity,labels=as.character(activity_Names$V2))

## 4. Appropriately labels the data set with descriptive variable names.
names(data_all)<-gsub("^t", "time", names(data_all))
names(data_all)<-gsub("^f", "frequency", names(data_all))
names(data_all)<-gsub("Acc", "Accelerometer", names(data_all))
names(data_all)<-gsub("Gyro", "Gyroscope", names(data_all))
names(data_all)<-gsub("Mag", "Magnitude", names(data_all))
names(data_all)<-gsub("BodyBody", "Body", names(data_all))

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(plyr)
data_all2<-aggregate(.~subject+activity, data_all,mean)
data_all2<-Data2[order(data_all2$subject,data_all2$activity),]
write.table(data_all2,file="Newtidydata.txt",row.name=FALSE)
