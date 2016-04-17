#Read Data from txt
##Read Activity File    Y. Files
dActivityTest  <- read.table(file.choose(),header = FALSE)
dActivityTrain <- read.table(file.choose(),header = FALSE)
##Read Subject Files    Subject. Files
dSubjectTest  <- read.table(file.choose(),header = FALSE)
dSubjectTrain <- read.table(file.choose(),header = FALSE)
##Read Features Files   X. Files
dFeaturesTest  <- read.table(file.choose(),header = FALSE)
dFeaturesTrain <- read.table(file.choose(),header = FALSE)

#Merge Training and the test sets
dSubject <- rbind(dSubjectTrain, dSubjectTest)
dActivity<- rbind(dActivityTrain, dActivityTest)
dFeatures<- rbind(dFeaturesTrain, dFeaturesTest)

names(dSubject)<-c("subject")
names(dActivity)<- c("activity")
##read names from features.txt
dFeaturesNames <- read.table(file.choose(),head=FALSE)
names(dFeatures)<- dFeaturesNames$V2

dCombine <- cbind(dSubject, dActivity)
Data <- cbind(dFeatures, dCombine)

#Extracts only the measurements on the mean and standard deviation for each measurement
##Subset Name of Features by measurements on the mean and standard deviation
subdFeaturesNames<-dFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dFeaturesNames$V2)]
##Subset the data frame Data by seleted names of Features
Data<-subset(Data,select=c(as.character(subdFeaturesNames), "subject", "activity" ))

#Uses descriptive activity names to name the activities in the data set
##read from activity_label.text
activityLabels <- read.table(file.choose(),header = FALSE)
Data$activity<-factor(Data$activity, levels = c(1,2,3,4,5,6), labels = c('WALKING','WALKING_UPSTAIRS','WALKING_DOWNSTAIRS','SITTING','STANDING','LAYING'))
#Appropriately labels the data set with descriptive variable names

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
library(plyr)
d2<-aggregate(. ~subject + activity, Data, mean)
d2<-d2[order(d2$subject,d2$activity),]
write.table(d2, file = "tidydata.txt",row.name=FALSE)

#Write Codebook
library(memisc)
Write(codebook(d2),file="TidyData_CodeBook.txt")

