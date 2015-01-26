### GETTING AND CLEANING DATA COURSE PROJECT
### ERIC GIAMBATTISTA
### JAN 11, 2014

install.packages("RCurl")
library(RCurl)
download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip','all_data.zip',method='curl')
unzip('all_data.zip')
setwd('UCI HAR Dataset')

setwd('test')
test_sub <- read.table('subject_test.txt',stringsAsFactors=FALSE)  ### 2947 X 1
test_X <- read.table('X_test.txt',stringsAsFactors=FALSE)   ### 2947 X 561
test_y <- read.table('y_test.txt',stringsAsFactors=FALSE)   ### 2947 X 1

setwd('..')
setwd('train')
train_sub <- read.table('subject_train.txt',stringsAsFactors=FALSE)  ###  7352 X 1
train_X <- read.table('X_train.txt',stringsAsFactors=FALSE)   ###  7352 X 561
train_y <- read.table('y_train.txt',stringsAsFactors=FALSE)   ###  7352 X 1

setwd('..')
feature_names <- read.table('features.txt',stringsAsFactors=FALSE) ### 561 X 2
activity_labels <- read.table('activity_labels.txt',stringsAsFactors=FALSE)  ### 6 X 2
setwd('..')

### ADD THE VARIABLE NAMES
colnames(train_X) <- feature_names$V2
colnames(test_X)  <- feature_names$V2

### Merge in the subjects and labels
train_X$subjects <- train_sub$V1
test_X$subjects  <- test_sub$V1
train_X$activities <- train_y$V1
test_X$activities  <- test_y$V1

### Merges the training and the test sets to create one data set
merge_data <- rbind(test_X,train_X)

### Extracts only the measurements on the mean and standard deviation for each measurement. 
keep_index <- grepl("mean",colnames(merge_data),fixed=TRUE) | grepl("std",colnames(merge_data),fixed=TRUE) | grepl("subjects",colnames(merge_data),fixed=TRUE) | grepl("activities",colnames(merge_data),fixed=TRUE)
merge_data <- merge_data[,keep_index]

### Uses descriptive activity names to name the activities in the data set
for (row_num in 1:dim(merge_data)[1]) {
  act_num <- merge_data$activities[row_num]
  merge_data[row_num,'activities'] <- activity_labels[act_num,"V2"]
}

### Appropriately labels the data set with descriptive variable names. 
orig_col_names <- colnames(merge_data)
freq_fixed <- gsub("f","frequency_",orig_col_names,ignore.case=FALSE)
ba_fixed <- gsub('Body',"Body_",freq_fixed,ignore.case=FALSE)
acc_fixed <- gsub('Acc','Acceleromter',ba_fixed,ignore.case=FALSE)

time_fixed1 <- gsub("tBody","time_Body",acc_fixed,ignore.case=FALSE)
time_fixed2 <- gsub("tGravity","time_Gravity",time_fixed1,ignore.case=FALSE)
gyro_fixed <- gsub('Gyro','Gyrometer',time_fixed2,ignore.case=FALSE)

paren_fixed <- gsub('()-','_',gyro_fixed,ignore.case=FALSE,fixed=TRUE)
jerk_fixed <- gsub('Jerk','Jerk_',paren_fixed,ignore.case=FALSE)
mag_fixed <- gsub('Mag','Magnitude',jerk_fixed,ignore.case=FALSE)
dash_fixed <- gsub('-','_',mag_fixed,ignore.case=FALSE,fixed=TRUE)
final_colnames <- gsub("()","",dash_fixed,ignore.case=FALSE,fixed=TRUE)

colnames(merge_data) <- final_colnames

### From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_data_avg <- aggregate(merge_data,by=list(merge_data$subjects,merge_data$activities),FUN=mean,na.rm=TRUE)
tidy_data_avg <- subset(tidy_data_avg,select=-c(subjects,activities))
names(tidy_data_avg)[names(tidy_data_avg)=="Group.1"] <- "Subjects"
names(tidy_data_avg)[names(tidy_data_avg)=="Group.2"] <- "Activities"

write.table(tidy_data_avg,row.names = FALSE, file = "tidy_dataset.txt")



