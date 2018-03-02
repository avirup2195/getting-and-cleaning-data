x_train <- read.table("F:/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("F:/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("F:/UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("F:/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("F:/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("F:/UCI HAR Dataset/test/subject_test.txt")

features <- read.table('F:/UCI HAR Dataset/features.txt')
activityLabels = read.table('F:/UCI HAR Dataset/activity_labels.txt')

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)

colNames <- colnames(setAllInOne)

means_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) )
setForMeansAndStd <- setAllInOne[ , means_and_std == TRUE]
MergedDataSet <- merge(setForMeansAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)
secTidySet <- aggregate(MergedDataSet[,names(MergedDataSet) 
                                      != c('activityId','subjectId')],by=list
                        (activityId=MergedDataSet$activityId,
                          subjectId=MergedDataSet$subjectId),mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]
write.table(secTidySet, "secTidySet.txt", row.name=FALSE)

