# Please be sure that the data folder is on the working diretory
# Set working directory, if needed:
setwd("working directory path")


# Set path for the data diretory; please change path if you renamed the diretory.
data_folder<-"./UCI HAR Dataset"


# If needed please download and unzip data with the following lines:
URL<-"http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL, destfile="data_archive.zip")
unzip("data_archive.zip")


# Creates strings with the files paths
features_pth <- paste(data_folder, "features.txt", sep="/")
activity_labels_pth<-paste(data_folder, "activity_labels.txt", sep="/")
X_train_pth <- paste(data_folder, "train", "X_train.txt", sep="/")
Y_train_pth <- paste(data_folder, "train", "Y_train.txt", sep="/")
subject_train_pth <- paste(data_folder, "train", "subject_train.txt", sep="/")
X_test_pth <- paste(data_folder, "test", "X_test.txt", sep="/")
Y_test_pth <- paste(data_folder, "test", "Y_test.txt", sep="/")
subject_test_pth <- paste(data_folder, "test", "subject_test.txt", sep="/")


# Reads table with the ID of the subjects and names to the column
subject_train<-read.table(subject_train_pth)
subject_test<-read.table(subject_test_pth)
colnames(subject_train)<-"Subject"
colnames(subject_test)<-"Subject"


# Reads table with the ID of the activities and names the column
Y_train<-read.table(Y_train_pth)
Y_test<-read.table(Y_test_pth)
colnames(Y_train)<-"Activity"
colnames(Y_test)<-"Activity"


# Reads table with the name of the variables (features) 
features<-read.table(features_pth)


# Reads table with the data (train:561 variables for 7352 observations; test:561 variables for 2947 observations)
X_train<-read.table(X_train_pth)
X_test<-read.table(X_test_pth)
colnames(X_train)<-features[,2]
colnames(X_test)<-features[,2]


# Creates index vectors to subset data
train_indx_vct_mean<-grep("mean", names(X_train), ignore.case=TRUE, value=FALSE)
train_indx_vct_std<-grep("std", names(X_train), ignore.case=TRUE, value=FALSE)
train_indx_vct<-sort(unique(c(train_indx_vct_mean, train_indx_vct_std)))

test_indx_vct_mean<-grep("mean", names(X_test), ignore.case=TRUE, value=FALSE)
test_indx_vct_std<-grep("std", names(X_test), ignore.case=TRUE, value=FALSE)
test_indx_vct<-sort(unique(c(test_indx_vct_mean, test_indx_vct_std)))


# Subsets de dataframe with index vector generated on the previous step
X_train<-X_train[,train_indx_vct]
X_test<-X_test[,test_indx_vct]


# Creates a column to identify the train and test groups and names them
group_train<-as.data.frame(rep("train", 7352))
group_test<-as.data.frame(rep("test", 2947))
colnames(group_train)<-"Group"
colnames(group_test)<-"Group"


# Binds to data the following columns: subjects ID; group identification; activity ID
tiddy_train<-cbind(subject_train,group_train, Y_train, X_train)
tiddy_test<-cbind(subject_test,group_test, Y_test, X_test)

tiddy<-rbind(tiddy_train,tiddy_test)


#  Read activity_labels and prepare to merge
activity_labels<-read.table(activity_labels_pth)
colnames(activity_labels)<-c("Activity","description")


# Merge activity labels, drop activity ID and sort
tiddy<-merge(activity_labels, tiddy, by="Activity", sort=FALSE)
tiddy<-tiddy[-1]

tiddy <- tiddy[order(tiddy$Group,tiddy$Subject),]


# create flat file
write.table(tiddy, file="tiddy.txt", row.name=FALSE)
