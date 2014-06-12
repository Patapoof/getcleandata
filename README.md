getcleandata
============

## Instructions ##
* Grab the dataset given with this exercise at [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](this location) and unzip it in your working directory.
* Take the script run_analysis.R from this repo and place it in your working folder.
As such, the script expects the unzipped data to be located in a child folder called "UCI HAR Dataset", containing the "test" and "train" folders. If your setup is different, update the *pathTopFolder* variable in line 2.
* Make sure that the Reshape2 package is installed. If not, issue the command `install.packages('reshape2')` in your console.
* Set your working directory, `setwd('XXX')`, where *XXX* is the local directory containing the R script from this repo.
* Source the script (CTRL+Maj+S).
* Issue the command `tidy(XXX)`, where *XXX* is the name of the resulting file containing the clean dataset.