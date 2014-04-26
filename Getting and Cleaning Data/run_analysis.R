library( plyr )
library( data.table )
library( reshape2 )
library( stringr )

## define some constants

## We assume that the data was obtained from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
## (or in our case, a coursera copy) and conforms to their organizational format
srcURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
srcZip <- "UCI HAR dataset.zip"
srcDir <- "raw"
srcFiles <- c( "activity_labels.txt", "features.txt", "test/X_test.txt", "test/y_test.txt", "test/subject_test.txt",
               "test/Inertial Signals/body_gyro_x_test.txt", "test/Inertial Signals/body_gyro_y_test.txt", "test/Inertial Signals/body_gyro_z_test.txt",
               "test/Inertial Signals/body_acc_x_test.txt", "test/Inertial Signals/body_acc_y_test.txt", "test/Inertial Signals/body_acc_z_test.txt",
               "test/Inertial Signals/total_acc_x_test.txt", "test/Inertial Signals/total_acc_y_test.txt", "test/Inertial Signals/total_acc_z_test.txt",
               "train/X_train.txt", "train/y_train.txt", "train/subject_train.txt",
               "train/Inertial Signals/body_gyro_x_train.txt", "train/Inertial Signals/body_gyro_y_train.txt", "train/Inertial Signals/body_gyro_z_train.txt",
               "train/Inertial Signals/body_acc_x_train.txt", "train/Inertial Signals/body_acc_y_train.txt", "train/Inertial Signals/body_acc_z_train.txt",
               "train/Inertial Signals/total_acc_x_train.txt", "train/Inertial Signals/total_acc_y_train.txt", "train/Inertial Signals/total_acc_z_train.txt" )

targetDir <- "tidy"

## utility functions
##
## getFilePath - concatenates a directory and file uniformly
getFilePath <- function( dir, ... )
{
   paste( dir, "/", ..., sep = "" )
}

## getSrcFilePath - full file path in source directory
getSrcFilePath <- function( file )
{
   getFilePath( srcDir, "UCI HAR Dataset/", file )
}

## getTargetFilePath - full file path in target directory
getTargetFilePath <- function( file )
{
   getFilePath( targetDir, file )
}

## writeTarget - write the specified data to the target filename
writeTarget <- function( data, file )
{
   write.table( data, getTargetFilePath( file ), row.names = FALSE, quote = FALSE )
}

## Application functions for either removing repetition or just for readability

## initializeData - Insures that we have the data zip and then it's been extracted
## to the proper directory.  This function also insures that our target directory
## is created and removes any existing data to avoid confusion
initializeData <- function()
{
   ## if we don't have the raw zipped data, go get it
   if ( !file.exists( srcZip ) )
   {
      download.file( srcURL, destfile = srcZip, mode = "wb" )
   }
   
   ## if our raw data source dir hasn't been created yet, then unzip our data there
   if ( !file.exists( srcDir ) )
   {
      unzip( srcZip, exdir = srcDir )
   }
   
   ## We need to be sure we have all the files, start by assuming we do, then if
   ## any are missing, change srcFound to false and keep going.  Once all files
   ## checked, if srcFound == TRUE we continue, otherwise we stop
   srcFound <- TRUE
   unzipTried <- FALSE
   done <- FALSE
   
   while ( !done )
   {
      for ( f in srcFiles )
      {
         sf <- getSrcFilePath( f )
         if ( !file.exists( sf ) )
         {
            srcFound <- FALSE
            message( "Unable to locate raw file: ", sf )
         }
      }
      
      if ( !srcFound & !unzipTried )
      {
         message( "attempting to restore missing file(s)" )
         
         ## try getting the missing data from the zip file,
         ## re extract everything, just in case.
         unzip( srcZip, exdir = srcDir, overwrite = TRUE )
         srcFound <- TRUE   ## Reset so we can try the test again
         unzipTried <- TRUE ## Only try the unzip trick once
      }
      else if ( !srcFound )
      {
         stop( "Please provide the missing src files and try again" )
      }
      else
      {
         done <- TRUE
      }
   }
   
   if ( !file.exists( targetDir ) )
   {
      dir.create( targetDir )
   }
   else if ( length( list.files( targetDir ) ) > 0 )
   {
      cat( "Removing previous output in ", targetDir, "\n\n" )
      for ( f in list.files( targetDir ) )
      {
         file.remove( getTargetFilePath( f ) )
      }
   }
}

## loadData - loads the feature, activity, and subject data sets into
## a single data set. A group column w/the specified name, as well as
## a unique data.window count for each data row is also added to the data set
## The data set returned is restricted to just the specified feature cols, if provided
## Note: the activity id is replaced by it's more helpful description
loadData <- function( groupName, featureFile, activityFile, subjectFile, featureCols = "" )
{
   ## get the activity id info and subject id info
   baseData <- read.table( getSrcFilePath( activityFile ) )
   baseData <- cbind(baseData, read.table( getSrcFilePath( subjectFile ) ) )
   
   ## add a column describing this as test data
   baseData <- cbind( baseData, groupName )
   
   ## name the columns we have
   names( baseData ) <- c( "activity.id", "subject.id", "group" )
   
   # replace the activity id w/the description for readability
   baseData <- data.table( join( baseData, activities )[, c( "subject.id", "activity.description", "group" ) ] )
   
   # make sure we have a unique value for each data window set.
   baseData <- baseData[ , "data.window" := 1:.N, by = c( "subject.id", "activity.description", "group" ) ]
   
   ## now get the feature data and it's column names
   featureData <- read.table( getSrcFilePath( featureFile ) )
   names( featureData ) <- features
   
   ## merge the feature data into the test data
   ## we only want -mean and -std values
   cbind( baseData, featureData[ , grep( featureCols, names( featureData ), perl = TRUE ) ] )
}

cat( "\nRaw data will be extracted to the directory '", srcDir, "'.\nOutput will be generated to the directory '", targetDir, "'.\n\n", sep = "" )

# start by initializing the data and directories
initializeData()

## we start w/the simple stuff - the activy labels need no tidying, just a header added.
## we'll use these later to make the activity data more readable (i.e. avoid numbers for categorical data )
activities <- read.table( getSrcFilePath( srcFiles[ 1 ] ) )
names( activities ) <- c( "activity.id", "activity.description" )

## get the data feature names
features <- read.table( getSrcFilePath( srcFiles[ 2 ] ) )

## make the feature names a bit more readable/understandable
## 1. all hyphens become periods
## 2. t and f references will become time or frequency
## 3. Acc is expanded to acceleration
## 4. Mag is expanded to magnitude
## 5. Body, Gravity, Gryo and Jerk are lowercases
## 6. X, Y and Z are lowercase
## 7. () are removed
features <- gsub( "-", ".", features$V2 )
features <- sub( "^t", "time", features )
features <- sub( "^f", "frequency", features )
features <- sub( "Acc", ".acceleration", features )
features <- sub( "Mag", ".magnitude", features )
features <- gsub( "([BGJ])", ".\\L\\1", features, perl = TRUE )
features <- gsub( "([XYZ])", "\\L\\1", features, perl = TRUE )
features <- sub( "\\(\\)", "", features )

## load up the test data - we only want the mean and std data columns (don't include meanFreq)
testData <- loadData( "Test", srcFiles[ 3 ], srcFiles[ 4 ], srcFiles[ 5 ], "\\.(mean|std)(\\.|$)" )

## load up the train data - we only want the mean and std data columns (don't include meanFreq)
trainData <- loadData( "Train", srcFiles[ 15 ], srcFiles[ 16 ], srcFiles[ 17 ], "\\.(mean|std)(\\.|$)" )

## now that we have both sets, bind them together and summarize
## Note: we summarizing across all data windows, so just strip that from the combined set first
comboData <- data.frame( rbind( trainData, testData ), check.names = FALSE )
tidyData <- dcast( melt( comboData[ , grep( "data.window", names( comboData ), invert = TRUE ) ],
                         id = c( "subject.id", "activity.description", "group" ) ),
                   formula = subject.id + activity.description + group ~ variable, mean )

writeTarget( comboData, "combinedData.txt" )
writeTarget( tidyData, "tidyData.txt" )