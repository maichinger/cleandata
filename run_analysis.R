# aim 150422
# clean project
#
#read everything and set names           
act_labels<-read.table("activity_labels.txt",header=FALSE,sep="")
names(act_labels)<-c("id_activity","activity")

features<-read.table("features.txt",header=FALSE,sep="")
# make names nice
features[,2]<-tolower(features[,2])
features[,2]<-gsub("\\(|\\)|\\-","",features[,2])
#

x_test<-read.table("test/X_test.txt",header=FALSE,sep="")
y_test<-read.table("test/y_test.txt",header=FALSE,sep="")
s_test<-read.table("test/subject_test.txt",header=FALSE,sep="")

x_train<-read.table("train/X_train.txt",header=FALSE,sep="")
y_train<-read.table("train/y_train.txt",header=FALSE,sep="")
s_train<-read.table("train/subject_train.txt",header=FALSE,sep="")

x<-rbind(x_test,x_train)
names(x)<-features[,2]
y<-rbind(y_test,y_train)
names(y)<-c("id_activity")
s<-rbind(s_test,s_train)

#use the descriptive activity label instead
y$id<-1:nrow(y)
y1<-merge(y,act_labels)
y2<-y1[order(y1$id),]
#head(y2)

# merge everything together
m<-cbind(s,y2$activity,x)
names(m)[1]<-"subject"
names(m)[2]<-"activity"
#head(m)

# get the required cols
sel_col<-grep("subject|activity|mean|std", names(m)) 
dat<-m[,c(sel_col)]

# get the means for each subject, activity
ag <- aggregate(.~subject+activity, dat, mean,na.RM=TRUE)

write.table(ag, "data.txt", sep=",", row.names = FALSE)

