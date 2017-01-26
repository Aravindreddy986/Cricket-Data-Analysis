library(shinythemes)
library(shinydashboard)
library(yaml) 
library(xlsx)
library(tcltk)
library(stats)
library(sqldf)
library(tidyr)
library(dplyr)
library(downloader)
library(RODBC)
library(mailR)
library(rpart)
library(ggplot2)
library(sendmailR)
#library(gmailr)
library(beepr)
library(devtools)
library(gmailR)
library(mygmailR)
library(mail)
library(mailR)
library(neuralnet)
#library(RMySQL)
library(party)
library(RODBC)
library(rsconnect)
library(shiny)
library(nnet)
library(caret)
library(raster)
library(rgdal)
library(png)
library(imager)
library(EBImage)
library("colorspace")
library(RcppEigen)
library(rsconnect)
library(rdrop2)

rsconnect::setAccountInfo(name='myimageanalysis',
                          token='457B2F530E0C134DA91052AFAF375B4B',
                          secret='iBoVU42oqmwwrQMZdqIdtZH7XlHB2XoRQV3+QeVk')

token <- drop_auth()
saveRDS(token, "droptoken.rds")

load_image_file <- function(filename) {
  ret = list()
  f = file(filename,'rb')
  readBin(f,'integer',n=1,size=4,endian='big')
  ret$n = readBin(f,'integer',n=1,size=4,endian='big')
  nrow = readBin(f,'integer',n=1,size=4,endian='big')
  ncol = readBin(f,'integer',n=1,size=4,endian='big')
  x = readBin(f,'integer',n=ret$n*nrow*ncol,size=1,signed=F)
  ret$x = matrix(x, ncol=nrow*ncol, byrow=T)
  close(f)
  ret
}

load_label_file <- function(filename) {
  f = file(filename,'rb')
  readBin(f,'integer',n=1,size=4,endian='big')
  n = readBin(f,'integer',n=1,size=4,endian='big')
  y = readBin(f,'integer',n=n,size=1,signed=F)
  close(f)
  y
}

transformation <- function(){
  
  train1 <- load_image_file('A:/Projects/Image/Digital recognizer/mnist/train-images.idx3-ubyte')
  test1 <- load_image_file('A:/Projects/Image/Digital recognizer/mnist/t10k-images.idx3-ubyte')
  
  train1$y <- load_label_file('A:/Projects/Image/Digital recognizer/mnist/train-labels.idx1-ubyte')
  test1$y <- load_label_file('A:/Projects/Image/Digital recognizer/mnist/t10k-labels.idx1-ubyte')  
  
  trainx <- train1$x
  trainy <- train1$y
  testx  <- test1$x
  testy  <- test1$y
  
  trainx <<- data.frame(trainx)
  trainy <<- data.frame(trainy)
  testx  <<- data.frame(testx)
  testy  <<- data.frame(testy)
  
  ##############################################################
  trainingdataset <- cbind(trainx,trainy)
  testdataset     <- cbind(testx,testy)
  
  Shuffledtrainingdataset <<- trainingdataset[sample(1:nrow(trainingdataset)), ]
  Shuffledtestdataset <<- testdataset[sample(1:nrow(testdataset)), ]
  
}

write_data <- function(){
  
  train1 <- load_image_file('A:/Projects/Image/Digital recognizer/mnist/train-images.idx3-ubyte')
  test1 <- load_image_file('A:/Projects/Image/Digital recognizer/mnist/t10k-images.idx3-ubyte')
  
  train1$y <- load_label_file('A:/Projects/Image/Digital recognizer/mnist/train-labels.idx1-ubyte')
  test1$y <- load_label_file('A:/Projects/Image/Digital recognizer/mnist/t10k-labels.idx1-ubyte')  
  
  trainx <- train1$x
  trainy <- train1$y
  testx  <- test1$x
  testy  <- test1$y
  
  trainx <<- data.frame(trainx)
  trainy <<- data.frame(trainy)
  testx  <<- data.frame(testx)
  testy  <<- data.frame(testy)
  
  write.csv(trainx, "C:/Users/aravi/Dropbox/Image Analysis/mnist/trainx.csv", row.names = FALSE)
  write.csv(trainy, "C:/Users/aravi/Dropbox/Image Analysis/mnist/trainy.csv", row.names = FALSE)
  write.csv(testx, "C:/Users/aravi/Dropbox/Image Analysis/mnist/testx.csv", row.names = FALSE)
  write.csv(testy, "C:/Users/aravi/Dropbox/Image Analysis/mnist/testy.csv",row.names = FALSE)
  
}

## please run the below methods when running the app in the local machine

#transformation()
#write_data()

load_data <- function(){
  
  trainx <- drop_read_csv("/Image Analysis/Digits recognizer/MNIST Dataset/trainx.csv",dest = tempdir(), sep= ",", dtoken= token)
  trainy <- drop_read_csv("/Image Analysis/Digits recognizer/MNIST Dataset/trainy.csv",dest = tempdir(), sep= ",", dtoken= token)
  testx  <- drop_read_csv("/Image Analysis/Digits recognizer/MNIST Dataset/testx.csv",dest = tempdir(), sep= ",", dtoken= token)
  testy  <- drop_read_csv("/Image Analysis/Digits recognizer/MNIST Dataset/testy.csv",dest = tempdir(), sep= ",", dtoken= token)
  
  trainx <<- data.frame(trainx)
  trainy <<- data.frame(trainy)
  testx  <<- data.frame(testx)
  testy  <<- data.frame(testy)
  
  ##############################################################
  trainingdataset <- cbind(trainx,trainy)
  testdataset     <- cbind(testx,testy)
  
  Shuffledtrainingdataset <<- trainingdataset[sample(1:nrow(trainingdataset)), ]
  Shuffledtestdataset <<- testdataset[sample(1:nrow(testdataset)), ]
  
}
  
load_data()

mnistpreprocessing <- function(){
  
  
  trainytest  <- trainy 
  
  trainy <- matrix(0, 60000, 10) 
  for (i in 1:60000)
  { 
    trainy[i, trainytest[i,] + 1 ] <- 1
  }
  
  trainy <<- as.matrix(trainy)
  #remove(trainytest)
  
  testytest  <- testy 
  testy <- matrix(0, 10000, 10) 
  for (i in 1:10000)
  {  
    testy[i, testytest[i,] + 1 ] <- 1 
  }
  testy <<- as.matrix(testy)
  #remove(testytest)
  
  ##################################################################
  
  nzv <- nearZeroVar(trainx)
  nzv.nolabel <- nzv-1 
  
  trainxreduced <- trainx[, -nzv.nolabel ]/max(trainx)
  testxreduced  <- testx[,  -nzv.nolabel ]/ max(testx)
  
  trainxreduced <<- as.matrix(trainxreduced)
  testxreduced <<- as.matrix(testxreduced)
  
}

mnistpreprocessing()
