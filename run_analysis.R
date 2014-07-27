install.packages("reshape2")
library(reshape2)
setwd("~/UCI HAR Dataset")

## Read all the file names 

## Read all activities and their names and label the aproppriate columns
act_lab <- read.table("activity_labels.txt",col.names=c("activity_id","activity_name"))

## Read the dataframe's column names
feat <- read.table("features.txt")
feat_names <- feat[,2]

## Read the test data and label the dataframe's columns
test <- read.table("./test/X_test.txt")
colnames(test) <- feat_names

## Read the training data and label the dataframe's columns
train <- read.table("./train/X_train.txt")
colnames(train) <- feat_names

## Read the subject ids and activity idsof the test subjects and label the the dataframe's columns
test_sub_id <- read.table("./test/subject_test.txt",col.names=c("subject_id"))
test_act_id <- read.table("./test/y_test.txt",col.names=c("activity_id"))


## Read the subject ids and activity ids of the train subjects and label the the dataframe's columns
train_sub_id <- read.table("./train/subject_train.txt",col.names=c("subject_id"))
train_act_id <- read.table("./train/y_train.txt",col.names=c("activity_id"))

##Combine the test and train subject id's, the test activity id's
##and the test/train data into one dataframe

test <- cbind(test_sub_id , test_act_id , test)
train <- cbind(train_sub_id , train_act_id , train)

##Combine train and test data set
train_test <- rbind(train,test)

##Extract columns with mean() or std() values
mean_tt<- grep("mean",colnames(train_test),ignore.case=TRUE)
mean_colnam <- colnames(train_test)[mean_tt]
std_tt <- grep("std",names(train_test),ignore.case=TRUE)
std_colnam <- colnames(train_test)[std_tt]
data <-train_test[,c("subject_id","activity_id",mean_colnam,std_colnam)]

##Merge activity labels and extracted dataset
data_merge <- merge(act_lab,data,by.x="activity_id",by.y="activity_id",all=TRUE)

##Melt and cast the dataset with activityid and name
data_melt <- melt(data_merge,id=c("activity_id","activity_name","subject_id"))
data_mean<- dcast(data_melt,activity_id + activity_name + subject_id ~ variable,mean)

## Creat final file
write.table(data_mean,"./final_tidy.txt")
