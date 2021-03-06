install.packages("tidyverse")
library(reshape2)
library(plyr)
library(tidyverse)

#******************************************************************************************
#Importing dataset from csv file

rawData <- read.csv("tb.csv")
rawData
#Selecting a single column
rawData$iso2

#using names function to look at the column names of the dataframe
#using index 1 to look at the first column and setting its name to "country"
#remember that the index for R is not 0 based but 1 based
names(rawData)[1] <- "country"

#Looking at all the column names and replacing the string "new_sp_" with an empty string
names(rawData) <- str_replace(names(rawData), "new_sp_", "")

#Looking at just a subset of a original dataframe
raw_subset <- subset(rawData, year ==2000)

#Deleting the extraneous columns
#in R we do this by setting them to NULL
raw_subset$new_sp <- NULL
raw_subset$m04 <- NULL
raw_subset$m514 <- NULL
raw_subset$f04 <- NULL
raw_subset$f514 <- NULL

#******************************************************************************************
#Problems with the dataset:
#1: A single variable (sex_age) is spread across multiple columns. Rule of tidy data: a single variable should belong to a single column
#2: Two variables are stored in the same column (sex_age should be split into the sex column and the age column).
#******************************************************************************************

#MELTING
#Fixing problem #1 by Melting the data by using the country and the year as our Ids
clean_data <- melt(raw_subset, id = c("country", "year"))

#Changing column names to be more accurate/descriptive
names(clean_data)[3] <- "sex_age"
names(clean_data)[4] <- "frequency"

#Sorting the data; first by the country, then sex_age and then by year)
clean_data <- arrange(clean_data, country, sex_age, year)

#clean_data$gender <- str_sub(clean_data$sex_age, 1,1)
clean_data <- separate(clean_data, col = "sex_age", into = c("sex", "age"), sep =1)

#x <- c(1,2,3,5,2,2,2,2,2,3,3,3,3,3,1,1,1,1)
#y <- factor(x)
#y

ages <- c("014" = "0-14", "1524" = "15-24", "2534" = "25-34", "3544" = "35-44", "4554" = "45-54", "5564" = "55-64", "65" = "65+", "u" = NA)
ages_factor <- factor(ages)
ages_factor

#clean_data$age <- factor(ages)
clean_data$age <- factor(ages[str_sub(clean_data$age)], levels = ages)




