# This file cleans the dataset containing crude rates of suicide for all
#  US counties for the time period 2012-2016

# Read in dataset
usa_suicides <- read.delim(file = '2012-2016 US counties suicides.txt', header = T)

# When read, the dataframe contains an Remove empty column
usa_suicides <- usa_suicides[ , -1]

# Rename columns for ease of use
colnames(usa_suicides) <- c('county', 'code', 'deaths', 'pop', 'rate', 
                            'ci_low95', 'ci_up95', 'se')