##Getting and Cleaning Data

##checks and/or creates getdata folder and downloads file
if(!file.exists("./getdata")){dir.create("./getdata")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./getdata/Dataset.zip", method="curl")
unzip(zipfile="./data/Dataset.zip",exdir="./data")

setwd("C:/RProgramming/getdata/Dataset/UCI HAR Dataset")
dir()

##Reading from text docs
features<-read.table("./features.txt",stringsAsFactors=F)
activity_label<-read.table("./activity_labels.txt",stringsAsFactors=F)
testsubj<-read.table("./test/subject_test.txt")
trainsubj<-read.table("./train/subject_train.txt")

tidydata<-testsubj
tidydata<-rbind(tidydata,trainsubj)

colnames(tidydata)[1]<-"Subjects"

testact<-read.table("./test/Y_test.txt")
trainact<-read.table("./train/Y_train.txt")

subjact<-testact 
subjact<-rbind(subjact,trainact) 

for(i in 1:nrow(tidydata)){
      index<-which(activity_label[,1] == subjact[i,1])
      tidydata$Activity[i]<-activity_label[index,2]
    }

testfeatread<-read.table("./test/X_test.txt")
trainfeatread<-read.table("./train/X_train.txt")

featread<-testfeatread 
featread<-rbind(featread,trainfeatread) 
    
for(i in 1:ncol(featread))
    {
      tidydata<-cbind(tidydata,featread[,i])
      names(tidydata)[ncol(tidydata)]<-features[i,2]
    }
 
extract<-grep("(.*)(mean|std)[Freq]?(.*)[/(/)]$|(.*)(mean|std)(.*)()-[X|Y|Z]$",colnames(tidydata),value=T)

tidydata<-tidydata[,c("Subjects","Activity",extract)]

tidydata$Activity<-gsub("WALKING_UPSTAIRS","Walking Up",tidydata$Activity)
tidydata$Activity<-gsub("WALKING_DOWNSTAIRS","Walking Down",tidydata$Activity)
tidydata$Activity<-gsub("WALKING","Walking",tidydata$Activity)
tidydata$Activity<-gsub("SITTING","Sitting",tidydata$Activity)
tidydata$Activity<-gsub("STANDING","Standing",tidydata$Activity)
tidydata$Activity<-gsub("LAYING","Laying",tidydata$Activity)

colnames(tidydata)<-gsub("[/(/)]","",colnames(tidydata))
colnames(tidydata)<-gsub("-","_",colnames(tidydata))
    
if(!("data.table" %in% rownames(installed.packages()))){
      
      install.packages("data.table")
      library(data.table)
      
    }else{
      
      library(data.table)
    }
	
tidydata = data.table(tidydata)

tidydata<-tidydata[,lapply(.SD,mean),by='Subjects,Activity']
tidydata.<-tidydata[order(tidydata$Subjects),]
write.csv(tidydata,"Tidy_Data.csv",row.names=F)
write.table(tidydata, "TidyData.txt",row.names=F)    
    cat("\n### Tidy_Data.csv file now in working directory ###")
    

 
    