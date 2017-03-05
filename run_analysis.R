path1<-file.path("C:/Users/marie/Desktop/Data science/Week4/project")
setwd(path1)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",path1)
#get the working directory to the "test" folder then merge, with cbind, all the txt files together in a data frame called "test_data"
path_test<-file.path("C:/Users/marie/Desktop/Data science/Week4/project/UCI HAR Dataset/test")
setwd(path_test)
filelist = list.files(pattern = ".*.txt")
test_data<-read.table(filelist[1])
for (i in 2:length(filelist)){
  test_data<-cbind(test_data,read.table(filelist[i]))
}
#get the working directory to the "train" folder then merge, with cbind, all the txt files together in a data frame called "train_data"
path_train<-file.path("C:/Users/marie/Desktop/Data science/Week4/project/UCI HAR Dataset/train")
setwd(path_train)
filelist2 = list.files(pattern = ".*.txt")
train_data<-read.table(filelist2[1])
for (i in 2:length(filelist2)){
  train_data<-cbind(train_data,read.table(filelist2[i]))
}
#Name the columns of each data frame; the first columns of both data sets is obviously the subject number, extracted from the subject_test and subject_train files
colnames(test_data)[1]<-c("subject")
colnames(train_data)[1]<-c("subject")
#Merge both data sets with rbind
full_data<-rbind(test_data,train_data)
#name the rest of the columns from the data frame; 
#extract the column names from the "feature" file
path_to_features<-file.path("C:/Users/marie/Desktop/Data science/Week4/project/UCI HAR Dataset/features.txt")
col_names<-read.table(path_to_features)
#attributes the column names to the "V1" to "V561" columns
names<-as.character(col_names[,2])
colnames(full_data)[2:562]<-names
#by logic, since there are six different type of activities and the last column has 6 unique different values, it must indicate the type of activity
colnames(full_data)[563]<-c("activity")
#create a data frame, final_data with only the means and standard deviation, as well as the activity and subject
final_data<-data.frame(full_data$subject,full_data$activity)
library(dplyr)
final_data<-rename(final_data,activity=full_data.activity,subject=full_data.subject)
#The meanFreq columns are deliberately included
mean_col<-grep("mean",names(full_data))
std_col<-grep("std",names(full_data))  
all_col<-c(mean_col,std_col)
x<-3
for (i in all_col) {
  final_data<-cbind(final_data,full_data[,i,drop=FALSE])
}
#Replace the numbers of the Activity column by descriptions
final_data$activity<-gsub("1","walking",final_data$activity)
final_data$activity<-gsub("2","walking_upstairs",final_data$activity)
final_data$activity<-gsub("3","walking_downstairs",final_data$activity)
final_data$activity<-gsub("4","sitting",final_data$activity)
final_data$activity<-gsub("5","standing",final_data$activity)
final_data$activity<-gsub("6","laying",final_data$activity)
#Tidying the variable names: how to rename several columns at once?
noms<-names(final_data)
#Replace all the "Gyro" by "Gyroscope" and the Acc by "Accelerometer"
noms<-gsub("Acc","Accelerometer", noms)
noms<-gsub("Gyro","Gyroscope", noms)
noms<-gsub("fBody","FastFourierTransform",noms)
noms<-gsub("tBody","TimeBody",noms)
noms<-gsub("tGravity","TimeGravity",noms)
noms<-gsub("Mag","EuclideanNorm",noms)
noms<-gsub("MeanFreq","MeanFrequency",noms)
noms<-gsub("-std()","StandardDev",noms)
noms<-gsub("-mean()","Mean",noms)
noms<-gsub("-X","AxisX",noms)
noms<-gsub("-Y","AxisY",noms)
noms<-gsub("-Z","AxisZ",noms)
names(final_data)<-noms
#create the final tidy data set with the mean for each activity and subject
inter_data<-group_by(final_data,subject,activity)
tidy_data_set<-summarise_each(inter_data,funs(mean))
#Save the tidy data set in the working directory in a Tab delimited text file
path_test3<-file.path("C:/Users/marie/Desktop/Data science/Week4/project")
setwd(path_test3)
write.table(tidy_data_set, "./tidy_data_set.txt", sep="\t")
