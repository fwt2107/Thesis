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
library('stringr')

# Read in dataset
usa_suicides <- as.tibble(
  read.delim(file = './Raw Data/2012-2016 US counties suicides.txt', header = T))

# When read, the dataframe contains an empty column for notes, so it's removed
usa_suicides <- usa_suicides[ , -1]

# Rename columns for ease of use
colnames(usa_suicides) <- c('county', 'code', 'deaths', 'pop', 'crude_rate', 
                            'ci_low95', 'ci_up95', 'se')



# Convert data from factors to numeric vectors for ease of use in analyses

# Death counts
# Identify suppressed values and convert to NA's
deaths_vector <- as.character(usa_suicides$deaths)
suppressed_indexes <- which(grepl(pattern = "Suppressed", x = deaths_vector))
deaths_vector[suppressed_indexes] <- NA
deaths_vector <- as.numeric(deaths_vector)


# Crude rates
# Identify which values are unreliable and remove their labels
crude_rate_vector <- as.character(usa_suicides$crude_rate)
unreliable_indexes <- which(grepl(pattern = " \\(Unreliable\\)", 
                                  x = crude_rate_vector))
crude_rate_vector[unreliable_indexes] <- str_remove(
  string = crude_rate_vector[unreliable_indexes], pattern = " \\(Unreliable\\)")
crude_rate_vector <- as.numeric(crude_rate_vector)
  

# 95% CI and standard errors
ci_low95_vector <- as.character(usa_suicides$ci_low95)
ci_low95_vector[suppressed_indexes] <- NA
ci_low95_vector <- as.numeric(ci_low95_vector)

ci_up95_vector <- as.character(usa_suicides$ci_up95)
ci_up95_vector[suppressed_indexes] <- NA
ci_up95_vector <- as.numeric(ci_up95_vector)

se_vector <- as.character(usa_suicides$se)
se_vector[suppressed_indexes] <- NA
se_vector <- as.numeric(se_vector)


# Vectors for noting which entries are unreliable or surpressed
suppressed_vector <- rep.int(0, nrow(usa_suicides))
suppressed_vector[suppressed_indexes] <- 1

unreliable_vector <- rep.int(0, nrow(usa_suicides))
unreliable_vector[unreliable_indexes] <- 1



# Create new tibble dataframe with the vectors and rename columns
usa_suicides_tibble <- data_frame(
  as.character(usa_suicides$county),
  usa_suicides$code,
  deaths_vector,
  usa_suicides$pop,
  crude_rate_vector,
  ci_low95_vector,
  ci_up95_vector,
  se_vector,
  suppressed_vector,
  unreliable_vector
)

colnames(usa_suicides_tibble) <- c("county", "code", "deaths", "pop",
                                   "crude_rate", "ci_low95", "ci_up95",
                                   "se", "suppressed", "unreliable")

# Ready to output the cleaned dataset. Waiting in case other changes need
#  to be made
# write.csv(x = usa_suicides_tibble, file = 
#             "./Cleaned data/2012-2016 USA suicides by county")