# Getting and Cleaning Data Course Project

## Project Description
In this project, you are given a dataset consists of different measurements
colelcted by the accelerometers from Samsung Galaxy S smartphones of 30
different individuals. The objective of the project is to transform the
measurements into a tidy dataset.

The dataset can be downloaded from:
[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

The specific instructions from the course project is to create one R script
called run_analysis.R that does the following:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## Descriptions for *run_analysis.R*
In this section, we will walk through the codes in *run_analysis.R*. In *run_analysis.R*, it is divided into various chunks with comments. The comments in the codes should pretty much give the ideas what each chunks is trying to achieve.

1. **Loading datasets.**
Two datasets called *train* and *test* are created by loading the *X_train.txt* and *X_test.txt*. The two data files will populate 561 columns. In addition to these two files, two new columns at index positions 562 and 563 are added to record the types of activities and the subject ID of the measurements. Then, the file containing the activities types is loaded as *act_labels* and the information on the measurement types (features) is loaded on *features*.

2. **Merging datasets.** We have added another column on each of the *train* and *test* datasets to which populate with the keywords "train" or "test". When both of the data sets are combined into just one *all* dataset, this column will be an indicator that identify if a particular row of measurement is coming from the training set or testing set. (Not used in this project though, thus is redundant and can be omitted.)

3. **Extract features labels with "means" and "std".** The next step is to identify which columns containing measurements on the mean and standard deviation for each measurement. We achieve this by using regular expression with *grep*. Note that we convert the features into lower case first before we fish out "mean" and "std". The indices returned by *grep* is then merged with the last 3 columns (562, 563, 564) to form a list of all the indices of the columns that we wish to extract. Then, extract the data and store it as a new data frame called *selected_data*.

4. **Label each of the columns.** This chunk of the code does two things: label all the columns in *selected_data*; and rename some of the names that with bracket () or 't' and 'f' prefix. For example, it change "fBodyAccMag-mean()" into "Frequency-BodyAccMag-mean".

5. **Declare Activity, Subject and Category are factors.** The last three columns of our data frame are ID for activities, subjects and categories. Thus, this section convert the 3 columns into factors.

6. **Change Activity Labels from 1,2,3 to laying, walking, sitting etc.** The for loop will go through six different IDs of the activities. They are
  * 1 WALKING
  * 2 WALKING_UPSTAIRS
  * 3 WALKING_DOWNSTAIRS
  * 4 SITTING
  * 5 STANDING
  * 6 LAYING

7. **Create tidy dataset as required by Step 5.** The last chunk of the code is create the *tidy* dataset by using *ddply* command. It gives the mean of each measurement and is grouped by *Activity* and then *Subject*.