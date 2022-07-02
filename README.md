---
title: "Getting and Cleaning Data - project"
author: "RW"
date: '2022-06-25'
output: html_document
---

## About this repo

The "run_analysis.R" script generates a tidy dataset showing the averages of the means and standard deviations from numerous data points for physical activity as captured by smartphones. This data comes from the UCI HAR Dataset available here:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

More data about the dataset can be found here:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

(Citation: Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.)

## About the data

The final output of this script is a CSV file containing the averages of both the means and standard deviations of measures from numerous smartphone sensors collected from a number of subjects. Data was collected for 30 subjects, and both the means and standard deviations of each of the sensors is collected.

## Data transformation

### Libraries

This analysis uses three libraries:
* tidyverse
* data.table
* reshape2

### Data prep

A prompt will appear to select a working directory. Once the directory is selected, the UCI dataset is downloaded as a ZIP file and unzipped in the working directory. Inside the ZIP file are several text files and two folders. The text files utilized are features.txt and activity_labels.txt, which provide the descriptions of the data collected by the smartphone sensors and the activities being formed while the sensors are reading, respectively. These files are read into data frames using data.table::fread.

Next the contents of the folders are read into data frames and joined. The two folders are named train and test, and they contain the training and testing data, respectively, to construct a data model. Both folders contain text files with similar structures and functions: an "X" file containing the readouts for each sensor and subject, a "Y" file containing the description of the activity, and a "subject" file identifying the subjects measured in each row of the "X" file. All three files were read into data frames using data.table::fread, and all three files were merged using base::cbind. After merging, each row contains the subject, activity, and sensor readout. Columns were renamed using the base::colnames function, with the column names coming from the features.txt file. This process is used to create a tidy data frame for both the test and train datasets. Finally, both the test and train datasets are joined using base::rbind.

To get the sensor readings containing only means and standard deviations, dplyr::select was used to select only those column names containing "mean()" or "std()". After selecting only these columns, the activity descriptions from the activities.txt file are merged into the dataset using dplyr::left_join.

The final data transformation us unpivoting the data using reshape2::melt, using the activity label and subject ID numbers as the unique identifer for each row. After "melting" the data frame, dplyr::group_by and dplyr::summarize are used to group each row by activity, subject, and sensor name and get the average of the readings, respectively. This produces a tidy data frame in which each row contains the activity label, subject ID number, sensor name, and the average value of each sensor's reading from both the testing and training datasets.