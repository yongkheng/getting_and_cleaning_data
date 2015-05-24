library(plyr)

##################################################################
# Loading data sets and labels
##################################################################
train       = read.csv("./UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
train[,562] = read.csv("./UCI HAR Dataset/train/y_train.txt", sep="", header=FALSE)
train[,563] = read.csv("./UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

test        = read.csv("./UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
test[,562]  = read.csv("./UCI HAR Dataset/test/y_test.txt", sep="", header=FALSE)
test[,563]  = read.csv("./UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

act_labels  = read.csv("./UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)
features    = read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)

##################################################################
# Merging the data sets
##################################################################
train[, 564] = 'train'              # column 564 indicates if data is from training set or testing set
test [, 564] = 'test'
all          = rbind(train, test)   # bind two datasets

##################################################################
# Extract features labels with "mean" or "std"
##################################################################
features_lower <- tolower(features[, 2])               # convert into lowercase
selected       <- grep('*mean*|*std*' ,features_lower) # returns a list of indices with "mean" or "std"
selected       <- c(selected, 562, 563, 564)           # include Activity, Subject and Category
selected_data  <- all[, selected]                      # extract data out of specified list


##################################################################
# Label each of the columns, 
##################################################################
selected_names <- c(as.character(features$V2), "Activity","Subject","Category")
selected_names <- selected_names[selected]                           # labels for all selected columns
names(selected_data) <- c(selected_names)                            # set the name of the labels
names(selected_data) <- gsub('\\()','',names(selected_data))         # remove () in labels
names(selected_data) <- gsub('^t','Time-',names(selected_data))      # replace 't' with 'Time-'
names(selected_data) <- gsub('^f','Frequency-',names(selected_data)) # replace 'f' with 'Frequency-'

##################################################################
# Declare Activity, Subject and Category are factors
##################################################################
selected_data$Activity <- as.factor(selected_data$Activity)
selected_data$Subject  <- as.factor(selected_data$Subject)
selected_data$Category <- as.factor(selected_data$Category)

##################################################################
# Change Activity Labels from 1,2,3 to laying, walking, sitting etc
##################################################################
act_labels$V2 <- tolower(act_labels$V2)
for (i in act_labels$V1) {
        selected_data$Activity <- gsub(i, act_labels[i,]$V2, selected_data$Activity)
}


##################################################################
# Create tidy dataset as required by Step 5.
##################################################################
tidy<-ddply(selected_data, c("Activity","Subject"), numcolwise(mean))
write.table(tidy, file = "tidy.txt",row.name=FALSE)

