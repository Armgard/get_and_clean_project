# R Script for the Course Project of Getting and Cleaning Data

# The purpose of this project is to demonstrate the ability to collect, 
# work with, and clean a data set. The goal is to prepare tidy data that can be 
# used for later analysis. 

# The data used for this project represent data collected from the
# accelerometers from the Samsung Galaxy S smartphone.


# Load raw data.
library(plyr)

X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
raw_col_names <- read.table("UCI HAR Dataset/features.txt")
raw_col_names <- raw_col_names[,2]
activities_test <- read.table("UCI HAR Dataset//test//y_test.txt")
subjects_test <- read.table("UCI HAR Dataset//test//subject_test.txt")
activities_train <- read.table("UCI HAR Dataset//train//y_train.txt")  
subjects_train<- read.table("UCI HAR Dataset//train//subject_train.txt") 
activity_names <- read.table("UCI HAR Dataset//activity_labels.txt")



# Merge the training and the test sets to create one data set.
full_raw_data <- rbind(X_train, X_test)
activities <- rbind(activities_train,activities_test)
subjects <- rbind(subjects_train, subjects_test)



rm(X_test, X_train,activities_train,activities_test, subjects_test, 
   subjects_train)

# Give raw names to rows and columns
colnames(full_raw_data) <- raw_col_names

# Extract the measurements on the mean and standard deviation 
# for each measurement.

# vector of rows, containing mean and standard deviation for each measuresment
# This vector has been created by hand, after inspection of the data set.
vector <- c(1:6,41:46,81:86,121:126,161:166,201:202,214:215,227:228,
             240:241,253:254,266:271,345:350,424:429,503:504,516:517,
             529:530,542:543)
reduced_raw_data <- full_raw_data[,vector]

# Use descriptive activity names to name the activities in the data set:

activities <- factor(activities$V1,labels= activity_names$V2)
subjects <- factor(subjects$V1)    

# Add activities and subjects to reduced data set. Checked before that there are
# no missing values
reduced_raw_data <- cbind(activities, subjects, reduced_raw_data)


# Appropriately label the data set with descriptive variable name-> create 
# nice descriptive new colnames

new_colnames <- colnames(reduced_raw_data)
new_colnames <- gsub("BodyBody","Body", new_colnames)
new_colnames <- gsub("\\(|\\)|\\-", "", new_colnames)
new_colnames <- gsub("mean","Mean", new_colnames)
new_colnames <- gsub("std","StandardDeviation", new_colnames)
new_colnames <- gsub("tBody","TimeDomainBody", new_colnames)
new_colnames <- gsub("fBody","FrequencyDomainBody", new_colnames)
new_colnames <- gsub("tGravity","TimeDomainGravity", new_colnames)
new_colnames <- gsub("fGravity","FrequencyDomainGravity", new_colnames)
new_colnames <- gsub("Y","AxisY", new_colnames)
new_colnames <- gsub("X","AxisX", new_colnames)
new_colnames <- gsub("Z","AxisZ", new_colnames)
new_colnames <- gsub("Acc","Acceleration", new_colnames)
new_colnames <- gsub("Mag","Magnitude", new_colnames)
new_colnames <- gsub("Gyr","Gyroscope", new_colnames)

colnames(reduced_raw_data) <- new_colnames
# take the mean for each activity and subject

tidy_data <- ddply(reduced_raw_data, c("activities","subjects"), 
                   numcolwise(mean))
  



#Save
write.table(tidy_data,"tidy_data.txt")
