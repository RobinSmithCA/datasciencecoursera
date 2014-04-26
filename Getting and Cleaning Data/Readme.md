## Getting and Cleaning Data Peer Assessment README

This assement consists of the following three files:

* README.md - This file
* CodeBook.md - The Code book for the raw and tidy data sets
* run_analysis.R - The R code for cleaning the raw data and creating a tidy data set


## Codebook.md

This file provides all of the information on where the raw data for this assignment came from, how it was created and
ultimately what was done to clean it up to produce the tidy data set provided for the solution.


## run_analysis.R

This R script will fetch the raw data from the Coursera website, extract it and then read in the main feature data.  The
test and training data will be combined and reduced to just the -mean and -std feature values.  Once we have all of the
data combined and reduced, we will create a tidy data set consisting of the mean value for each feature set per subject
and activity.
