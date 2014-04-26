## Getting and Cleaning Data Peer Assessment Code Book

One of the most exciting areas in all of data science right now is wearable computing - see for example this article:

http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/

Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users.
The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S
smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 


## Raw Data

### Background

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person
performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone
(Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration
and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually.
The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the
training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width
sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and
body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational
force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each
window, a vector of features was obtained by calculating variables from the time and frequency domain.


### Data Provided

* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
* Triaxial Angular velocity from the gyroscope. 
* A 561-feature vector with time and frequency domain variables. 
* Its activity label. 
* An identifier of the subject who carried out the experiment.


### Relevant Files

Raw data is pulled from the Coursera website and extracted to the raw sub-directory of the running R script.  The data itself has a high level directory defined in the zip, 'UCI HAR Dataset', so all file names listed below are relateive to the 'raw/UCI HAR Dataset' directory.

Training data exists in the train directory and test data in the test directory and is also identifiedy by the name, train or test, in the file name.  To avoid repetition, the train/test names are replaced by t* in the file names and described only once, their specific directories are assumed.

* 'activity_labels.txt': Links the class labels with their activity name.

* 'features.txt': Complete list of variables of each feature vector (column) provided in the X data files.  One variable per row.
* 'X_t*.txt': Time and frequency vector data.  Each row correlates to the activity and subject specified in the y and subject files respectively.  Each column correlates to the feature name/definition in the features file.
* 'y_t*.txt': Each row identifies the activity performed for each window sample.
* 'subject_t*.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 


### Activity Values

The individual activities are encoded using the following table:

| Code | Description |
|:----:|:------------|
|1|WALKING|
|2|WALKING_UPSTAIRS|
|3|WALKING_DOWNSTAIRS|
|4|SITTING|
|5|STANDING|
|6|LAYING|


### Feature Variables

#### Feature Selection 

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

|                |
|:---------------|
| tBodyAcc-XYZ |
| tGravityAcc-XYZ |
| tBodyAccJerk-XYZ |
| tBodyGyro-XYZ |
| tBodyGyroJerk-XYZ |
| tBodyAccMag |
| tGravityAccMag |
| tBodyAccJerkMag |
| tBodyGyroMag |
| tBodyGyroJerkMag |
| fBodyAcc-XYZ |
| fBodyAccJerk-XYZ |
| fBodyGyro-XYZ |
| fBodyAccMag |
| fBodyAccJerkMag |
| fBodyGyroMag |
| fBodyGyroJerkMag |


#### The Variables
The set of variables that were estimated from these signals are: 

|             |               |
|:------------|:--------------|
|mean()|Mean value|
|std()|Standard deviation|
|mad()|Median absolute deviation|
|max()|Largest value in array|
|min()|Smallest value in array|
|sma()|Signal magnitude area|
|energy()|Energy measure. Sum of the squares divided by the number of values.|
|iqr()|Interquartile range|
|entropy()|Signal entropy|
|arCoeff()|Autorregresion coefficients with Burg order equal to 4|
|correlation()|correlation coefficient between two signals|
|maxInds()|index of the frequency component with largest magnitude|
|meanFreq()|Weighted average of the frequency components to obtain a mean frequency|
|skewness()|skewness of the frequency domain signal|
|kurtosis()|kurtosis of the frequency domain signal|
|bandsEnergy()|Energy of a frequency interval within the 64 bins of the FFT of each window.|
|angle()|Angle between to vectors.|


Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

|                |
|:---------------|
| gravityMean |
| tBodyAccMean |
| tBodyAccJerkMean |
| tBodyGyroMean |
| tBodyGyroJerkMean |


## Tidy Data

### Background

As a final project for the 'Getting and Cleaning Data' Course we are asked to produce a tidy data set from the above raw data with the following requirements:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 


### Data Produced

While not specifically requested, given that we do have two different data sets combined into a single inclusive set; a new column, group, was added to the final data to maintain this detail.  The columns are defined as follows:

1. subject.id : The numeric id of the test subject.
2. activity.description : Activity description as defined by the raw data's activity file.
3. group : The test group the subject participated in, either Test or Train.
4. thru 69. : Mean values for the specified Mean and Standard Deviation variables defined in the raw data set.  Mean values were calculated across a specific subject/activity combination.  Given that item #3 of the requirements already covers activity.description, requirement #4 was interpreted to mean that all column names should be readable/descriptive.  Therfore, the raw variable names have been renamed according to the following table (Note: mean. was not prepended to each column name as it was deemed repetitive) :


|     |             |
|:----|:------------|
| tBodyAcc-mean()-X | time.body.acceleration.mean.x |
| tBodyAcc-mean()-Y | time.body.acceleration.mean.y |
| tBodyAcc-mean()-Z | time.body.acceleration.mean.z |
| tBodyAcc-std()-X | time.body.acceleration.std.x |
| tBodyAcc-std()-Y | time.body.acceleration.std.y |
| tBodyAcc-std()-Z | time.body.acceleration.std.z |
| tGravityAcc-mean()-X | time.gravity.acceleration.mean.x |
| tGravityAcc-mean()-Y | time.gravity.acceleration.mean.y |
| tGravityAcc-mean()-Z | time.gravity.acceleration.mean.z |
| tGravityAcc-std()-X | time.gravity.acceleration.std.x |
| tGravityAcc-std()-Y | time.gravity.acceleration.std.y |
| tGravityAcc-std()-Z | time.gravity.acceleration.std.z |
| tBodyAccJerk-mean()-X | time.body.acceleration.jerk.mean.x |
| tBodyAccJerk-mean()-Y | time.body.acceleration.jerk.mean.y |
| tBodyAccJerk-mean()-Z | time.body.acceleration.jerk.mean.z |
| tBodyAccJerk-std()-X | time.body.acceleration.jerk.std.x |
| tBodyAccJerk-std()-Y | time.body.acceleration.jerk.std.y |
| tBodyAccJerk-std()-Z | time.body.acceleration.jerk.std.z |
| tBodyGyro-mean()-X | time.body.gyro.mean.x |
| tBodyGyro-mean()-Y | time.body.gyro.mean.y |
| tBodyGyro-mean()-Z | time.body.gyro.mean.z |
| tBodyGyro-std()-X | time.body.gyro.std.x |
| tBodyGyro-std()-Y | time.body.gyro.std.y |
| tBodyGyro-std()-Z | time.body.gyro.std.z |
| tBodyGyroJerk-mean()-X | time.body.gyro.jerk.mean.x |
| tBodyGyroJerk-mean()-Y | time.body.gyro.jerk.mean.y |
| tBodyGyroJerk-mean()-Z | time.body.gyro.jerk.mean.z |
| tBodyGyroJerk-std()-X | time.body.gyro.jerk.std.x |
| tBodyGyroJerk-std()-Y | time.body.gyro.jerk.std.y |
| tBodyGyroJerk-std()-Z | time.body.gyro.jerk.std.z |
| tBodyAccMag-mean() | time.body.acceleration.magnitude.mean |
| tBodyAccMag-std() | time.body.acceleration.magnitude.std |
| tGravityAccMag-mean() | time.gravity.acceleration.magnitude.mean |
| tGravityAccMag-std() | time.gravity.acceleration.magnitude.std |
| tBodyAccJerkMag-mean() | time.body.acceleration.jerk.magnitude.mean |
| tBodyAccJerkMag-std() | time.body.acceleration.jerk.magnitude.std |
| tBodyGyroMag-mean() | time.body.gyro.magnitude.mean |
| tBodyGyroMag-std() | time.body.gyro.magnitude.std |
| tBodyGyroJerkMag-mean() | time.body.gyro.jerk.magnitude.mean |
| tBodyGyroJerkMag-std() | time.body.gyro.jerk.magnitude.std |
| fBodyAcc-mean()-X | frequency.body.acceleration.mean.x |
| fBodyAcc-mean()-Y | frequency.body.acceleration.mean.y |
| fBodyAcc-mean()-Z | frequency.body.acceleration.mean.z |
| fBodyAcc-std()-X | frequency.body.acceleration.std.x |
| fBodyAcc-std()-Y | frequency.body.acceleration.std.y |
| fBodyAcc-std()-Z | frequency.body.acceleration.std.z |
| fBodyAccJerk-mean()-X | frequency.body.acceleration.jerk.mean.x |
| fBodyAccJerk-mean()-Y | frequency.body.acceleration.jerk.mean.y |
| fBodyAccJerk-mean()-Z | frequency.body.acceleration.jerk.mean.z |
| fBodyAccJerk-std()-X | frequency.body.acceleration.jerk.std.x |
| fBodyAccJerk-std()-Y | frequency.body.acceleration.jerk.std.y |
| fBodyAccJerk-std()-Z | frequency.body.acceleration.jerk.std.z |
| fBodyGyro-mean()-X | frequency.body.gyro.mean.x |
| fBodyGyro-mean()-Y | frequency.body.gyro.mean.y |
| fBodyGyro-mean()-Z | frequency.body.gyro.mean.z |
| fBodyGyro-std()-X | frequency.body.gyro.std.x |
| fBodyGyro-std()-Y | frequency.body.gyro.std.y |
| fBodyGyro-std()-Z | frequency.body.gyro.std.z |
| fBodyAccMag-mean() | frequency.body.acceleration.magnitude.mean |
| fBodyAccMag-std() | frequency.body.acceleration.magnitude.std |
| fBodyBodyAccJerkMag-mean() | frequency.body.body.acceleration.jerk.magnitude.mean |
| fBodyBodyAccJerkMag-std() | frequency.body.body.acceleration.jerk.magnitude.std |
| fBodyBodyGyroMag-mean() | frequency.body.body.gyro.magnitude.mean |
| fBodyBodyGyroMag-std() | frequency.body.body.gyro.magnitude.std |
| fBodyBodyGyroJerkMag-mean() | frequency.body.body.gyro.jerk.magnitude.mean |
| fBodyBodyGyroJerkMag-std() | frequency.body.body.gyro.jerk.magnitude.std |


### Output Files

The following files are output in to the 'tidy' sub-directory of the running 'R' script:

* combinedData.txt: The combined data from steps 1-4.
* tidyData.txt: The final tidy data set

