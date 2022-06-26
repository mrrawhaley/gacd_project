# load libraries

library(tidyverse); library(data.table); library(reshape2)

# set working directory

setwd(choose.dir())

# download, unzip, and import training and testing data
# select only mean and standard deviation columns

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
              "UCI HAR Dataset.zip")

unzip("UCI HAR Dataset.zip")

activities <-
  fread("UCI HAR Dataset/activity_labels.txt") %>% 
  rename(activity_id = V1, activity = V2)

features <-
  fread(file = "UCI HAR Dataset/features.txt") %>% 
  select(V2) %>%
  rename(feature = V2)

test_labels <-
  fread(file = "UCI HAR Dataset/test/y_test.txt") %>% 
  rename(activity_id = V1)
test_subjects <- 
  fread(file = "UCI HAR Dataset/test/subject_test.txt") %>% 
  rename(subject = V1)
test_data <-
  fread(file = "UCI HAR Dataset/test/X_test.txt")
colnames(test_data) <- features$feature
test_data <- 
  cbind(test_subjects, test_labels, test_data)

train_labels <-
  fread(file = "UCI HAR Dataset/train/y_train.txt") %>% 
  rename(activity_id = V1)
train_subjects <- 
  fread(file = "UCI HAR Dataset/train/subject_train.txt") %>% 
  rename(subject = V1)
train_data <-
  fread(file = "UCI HAR Dataset/train/X_train.txt")
colnames(train_data) <- features$feature
train_data <- 
  cbind(train_subjects, train_labels, train_data)

data <- rbind(train_data, test_data) %>% 
  select(subject, activity_id, contains("mean()") | contains("std()")) %>% 
  left_join(activities) %>% 
  select(-activity_id) %>% 
  select(subject, activity, 3:ncol(data)-2)

# create tidy dataset for averages by subject and activity and output to CSV

data_averages <-
  data %>% 
  melt(c("subject", "activity"), 3:ncol(data), variable.name = "sensor") %>% 
  group_by(subject, activity, sensor) %>% 
  summarize(average = mean(as.numeric(value)))

write.csv(data_averages, "averages.csv")