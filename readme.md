### README FOR UCI HAR Dataset Project

The main file to run is run_analysis.R

It does the following:

1) Downloads the entire dataset

2) Splits the dataset into training and testing sets

3) Adds the activity names (sitting, standing, walking, etc.)

4) Drops the variables that do not contain mean or std in the title

5) Renames the variables with names that are more descriptive

6) Outputs a tidy dataset which contains the mean value for each of the variables for each subject and activity. (this is named tidy_dataset.txt)

codebook.txt - describes the variable names
