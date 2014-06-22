# run_analysis

#Load files from the working directory

xTrain <- read.table("train/X_train.txt")
xTest <- read.table("test/X_test.txt")
yTrain <- read.table("train/y_train.txt")
yTest <- read.table("test/y_test.txt")
subjectsTrain <- read.table("train/subject_train.txt")
subjectsTest <- read.table("test/subject_test.txt")
features <- read.table("features.txt")

##label the datasets
colnames(xTrain) <- features[,2]
colnames(xTest) <- features[,2]
colnames(yTrain) <- "Activity"
colnames(yTest) <- "Activity"
colnames(subjectsTrain) <- "SubjectID"
colnames(subjectsTest) <- "SubjectID"

##bind the X, Subjects, and Y Columns together for each of the Training and Testing datasets
trainDat <- cbind(xTrain, subjectsTrain, yTrain)
testDat<- cbind(xTest, subjectsTest, yTest)

##bind the training and testing dataframes
Dat <- rbind(trainDat, testDat)

# isolate the columns that refer to Means and Standard Deviation and combine to single logic vector
findMean <- grepl("mean()",names(Dat))
findStd <- grepl("std()", names(Dat))
findActivity <-grepl("Activity", names(Dat))
findSubject <- grepl("SubjectID", names(Dat))


filters <- findMean | findStd |findActivity | findSubject

# Apply the filter to the dataset 'Dat'

Dat <- Dat[,filters]

# use the reshape2 package to melt the data and find the averages
DatMelt <- melt(Dat, id.vars=c("Activity", "SubjectID"))

# cast the data into a new dataframe to get the means
DatAverages <- dcast(DatMelt, Activity + SubjectID ~ variable, mean)
tidyData <- DatAverages

write.csv(tidyData,"tidydata.txt",row.names=FALSE)

#display the final tidy file
tidyData