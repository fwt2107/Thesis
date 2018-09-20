# This file cleans the dataset containing crude rates of suicide for all
#  US counties for the time period 2012-2016
# 
# These are the major tasks for cleaning this dataset:
#  1. Transforming suppressed values into NA's
#  2. Removing supressed and unreliability notes from the data
#  3. Creating variables to note which rates were suppressed/unreliable
#  4. In conjunction with steps 1 - 3, also creating a new tibble dataframe
#      with only vectors (no factors) for ease of use during analyses

# Read in dataset
usa_suicides <- as.tibble(
  read.delim(file = './Raw Data/2012-2016 US counties suicides.txt', header = T))

# When read, the dataframe contains an empty column for notes, so it's removed
usa_suicides <- usa_suicides[ , -1]

# Rename columns for ease of use
colnames(usa_suicides) <- c('county', 'code', 'deaths', 'pop', 'crude_rate', 
                            'ci_low95', 'ci_up95', 'se')

# 1. Transforming suppressed values into NA's 
# Will be our deaths vector in the future tibble dataframe
deaths_vector <- vector(mode = "numeric")

for (i in 1:nrow(usa_suicides)) {
  if (usa_suicides$deaths[i] == "Suppressed")
    deaths_vector[i] <- NA
  else
    deaths_vector[i] <- as.numeric(usa_suicides$deaths[i])
}


