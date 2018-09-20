# This file cleans the dataset containing crude rates of suicide for all
#  US counties for the time period 2012-2016
# 
# These are the major tasks for cleaning this dataset:
#  1. Transforming suppressed values into NA's
#  2. Removing supressed and unreliability notes from the data
#  3. Creating variables to note which rates were suppressed/unreliable
#  4. In conjunction with steps 1 - 3, also creating a new tibble dataframe
#      with only vectors (no factors) for ease of use during analyses

library('tibble')


# Read in dataset
usa_suicides <- as.tibble(
  read.delim(file = './Raw Data/2012-2016 US counties suicides.txt', header = T))

# When read, the dataframe contains an empty column for notes, so it's removed
usa_suicides <- usa_suicides[ , -1]

# Rename columns for ease of use
colnames(usa_suicides) <- c('county', 'code', 'deaths', 'pop', 'crude_rate', 
                            'ci_low95', 'ci_up95', 'se')


# Will be our vectors in the future tibble dataframe
# Create variables to keep track of which values are suppressed/unreliable
#  Data are suppressed if counts are less than 10(?), unreliable if < 20
deaths_vector <- vector(mode = "numeric")
crude_rate_vector <- vector(mode = "numeric")
suppressed_vector <- vector()
unreliable_vector <- vector()

# Go through the original dataframe to extract data
for (i in 1:nrow(usa_suicides)) {
  
  # Obtains death counts and transforms suppressed values into NA's
  if (usa_suicides$deaths[i] == "Suppressed") {
    deaths_vector[i] <- NA
    suppressed_vector[i] <- 1
  }
  else
    deaths_vector[i] <- as.numeric(usa_suicides$deaths[i])
  
  if (usa_suicides$crude_rate[i] == "Suppressed")
    crude_rate_vector[i] <- NA
  else if (grepl(pattern = "(Unreliable)", x = usa_suicides$crude_rate[i]))
    crude_rate_vector[i] <- as.numeric(
      str_remove(pattern = " \\(Unreliable\\)", 
                 string = usa_suicides$crude_rate[i]))
  
  
    
}


