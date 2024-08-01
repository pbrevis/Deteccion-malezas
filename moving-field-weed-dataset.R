
# INSTALL PACKAGES --------------------------------------------------------
library(tidyverse)
library(here)

rm(list = ls()) # Cleaning my global environment

# READING CSV FILE --------------------------------------------------------

# Reading MFWD csv file
mfwdata <- read.csv("gt.csv")

glimpse(mfwdata)


# DATA WRANGLING ----------------------------------------------------------

# Checking for missing data across columns
mfwdata %>% summarise(across(everything(), ~ sum(is.na(.))))
mfwdata %>% summarise(across(everything(), ~ sum(!is.na(.))))



# Counting number of unique values of filename:
n_distinct(mfwdata$filename)

# filename: 64.494 unique image file names. On average, 101 images per tray

# Counting number of images (filename) per genotype (label_id)
image_file_count <- mfwdata |>
  group_by(label_id) |>
  summarise(count = n_distinct(filename))

# Show image_file_count by genotype
image_file_count

# image_file_count stats
max(image_file_count$count, na.rm= TRUE) # identify max frequency
median(image_file_count$count, na.rm= TRUE) # identify median frequency
min(image_file_count$count, na.rm= TRUE) # identify min frequency


# Write image_file_count into csv
write.csv(image_file_count, "images_x_genotype.csv")


# Counting number of unique values of tray id:
n_distinct(mfwdata$tray_id)

# tray_id: 640 growing trays (on average, 17 trays per species)


# Counting number of images (filename) per genotype and tray
image_file_count2 <- mfwdata |>
                     group_by(label_id, tray_id) |>
                     summarise(count = n_distinct(filename))
                          

# Show image_file_count2 by label ids
image_file_count2

max(image_file_count2$count, na.rm= TRUE) # identify max frequency
median(image_file_count2$count, na.rm= TRUE) # identify median frequency
min(image_file_count2$count, na.rm= TRUE) # identify min frequency


# Write image_file_count into csv
write.csv(image_file_count2, "images_x_tray.csv")


# checking range of tray values
max(mfwdata$tray_id, na.rm= TRUE) # identify max tray no.
min(mfwdata$tray_id, na.rm= TRUE) # identify min tray no.








# CREATING DATA SUBSETS ---------------------------------------------------

# list of weed species present in Chile
malezas <- c("ACHMI", "AGRRE", "PLAMA", "STEME",
             "CHEAL", "SSYOF", "CIRAR", "MATCH",
             "GALAP", "CONAR", "GASPA","ECHCG",
             "POAAN", "POROL", "SOLNI", "VIOAR")

# note: use 1000 images for training and 200 for validation
# especial cases with low sample size:
# AGRRE (695 images), ECHCG (976), GASPA (875), POAAN (849)

# list of crop cultivars
crops <- c("SORFR", "SORHA", "SORKM", "SORKS", "SORRS", "SORSA",
           "ZEALP", "ZEAKJ")

# list of maize cultivars
maize <- c("ZEALP", "ZEAKJ")

weed_sel <- c("ECHCG")

# list of selected maize cultivars
maize_sel <- c("ZEAKJ") # 1.630 images

# list of sorghum cultivars
# sorghum <- c("SORFR", "SORHA", "SORKM", "SORKS", "SORRS", "SORSA")

# list of weed species not present in Chile
not_weed <- c("ALOMY", "ARTVU", "LAMAL", "POLCO", "PULDY", "THLAR", "VEROF",
              "Weed", "POLAV", "AETCY", "GERMO", "VICVI", "POLAM")



# first subset: only selected maize
mfwd_maize <- filter(mfwdata, label_id %in% maize_sel)

# re-labeling maize cultivars with generic label ZEAMX
# mfwd_maize$label_id <- "ZEAMX"

glimpse(mfwd_maize) # 3.090 maize objects in 1.630 images

# Counting number of images (unique values of filename) in mfwd_maize:
n_distinct(mfwd_maize$filename)


# second subset: only selected weed
mfwd_echcg <- filter(mfwdata, label_id %in% weed_sel)

# re-labeling maize cultivars with generic label ZEAMX
# mfwd_maize$label_id <- "ZEAMX"

glimpse(mfwd_echcg) # 4.895 echinochloa objects in 976 images

# Counting number of images (unique values of filename) in echinochloa data set:
n_distinct(mfwd_echcg$filename)




# Create first working data frame to identify useful trays ---------------------
# For the purpose of downloading, image files are grouped by species and tray
# One tray = one zip file

# merging "useful" data sets into a working data frame
working_df1 <- rbind(mfwd_maize, mfwd_echcg)
glimpse(working_df1) # 7.985 total objects in 2.606 images

working_df1 <- working_df1 %>% arrange(filename, tray_id, track_id, bbox_id)

# count total number of images (number of unique file names)
n_distinct(working_df1$filename) # 2.606 image file names

# list of genotypes included in working data frame
genolist <- unique(working_df1$label_id)
length(genolist) # 2 selected genotypes

# Show genotype list (sorted in alphabetical order)
print(sort(genolist, decreasing = FALSE))


# list of trays included in working data frame
traylist <- unique(working_df1$tray_id)
length(traylist) # 63 trays

# Show tray list (sorted in alphabetical order)
print(sort(traylist, decreasing = FALSE))




# Inspecting annotation data: bounding box coordinates

# variable: xmax
max(working_df1$xmax, na.rm= TRUE) # identify max value
median(working_df1$xmax, na.rm= TRUE) # identify median value
min(working_df1$xmax, na.rm= TRUE) # identify min value

# variable: ymax
max(working_df1$ymax, na.rm= TRUE) # identify max value
median(working_df1$ymax, na.rm= TRUE) # identify median value
min(working_df1$ymax, na.rm= TRUE) # identify min value




# Exporting annotation data for YOLO model training -----------------------

# creating a 'class' variable to represent plant species with a number
# 2 classes going from 0 to 1
working_df1$class = ifelse(working_df1$label_id == "ECHCG", 0,
                         1) # ZEAKJ gets 1 by default



glimpse(working_df1)


# Checking for frequency of new 'class' variable
freq_table4 <- data.frame(table(working_df1$class))

# Show frequency table of class in descending order
freq_table4 %>% arrange(desc(Freq))


# Creating new columns with normalized coordinates
# Image dimensions: width(x) = 2.454 and height(y) = 2.056
working_df1$c_x_norm <- ((working_df1$xmin + working_df1$xmax)/2)/2454
working_df1$c_y_norm <- ((working_df1$ymin + working_df1$ymax)/2)/2056

working_df1$l_x_norm <- (working_df1$xmax - working_df1$xmin)/2454
working_df1$l_y_norm <- (working_df1$ymax - working_df1$ymin)/2056

# Adding new column with image file name
# Takes full path string from variable 'filename' and removes directories
working_df1$image_name <- substr(working_df1$filename, 14, nchar(working_df1$filename))

glimpse(working_df1)


# Create subset of working data frame by selecting only useful columns, then sort
working_df2 <- working_df1[c("image_name", "class",
                             "c_x_norm", "c_y_norm", "l_x_norm", "l_y_norm")]
working_df2 <- working_df2 %>% arrange(image_name, class)


glimpse(working_df2)
print(head(working_df2, 10))



  


# Split dataframes by file names, then export multiple csvs --------------------
# itirate by dataframe within a list


# apply split function to create a list of data frames based on image file names
# as many data frames as image file names
# full package: 107.162 total objects in 38.164 images
# two species package: 7.985 objects in 2.606 images
my_split_list <-split(working_df2, working_df2$image_name)

# str(my_split_list)
#glimpse(my_split_list) # list of 38.164

# Inspecting first data frame
head(my_split_list, 1)


# checking name of 1st data frame within list
names(my_split_list[1])


# Define target directory for text file export
target_dir <- here("mfwd_labels2/")
target_dir

dir.create(target_dir) # creates directory

# function iteration across lists, to write 2.606 dataframes exported out of my_split_list
for (i in 1:length(my_split_list)) {
  write.table(my_split_list[[i]][-1], # choosing data to write: all columns
              # within the i-th dataframe, except
              # the first one (image_name)
              file = paste0(target_dir, names(my_split_list[i]), ".txt"),
              sep = " ",
              col.names = FALSE,
              row.names = FALSE,
              qmethod = "double")}



# Copying label files ----------------------------------------------------------

# Define image directories

dir1 <- paste0(getwd(), "/datasets/train/images") 
dir1
dir2 <- paste0(getwd(), "/datasets/valid/images") 
dir2

# creating vector with a list of all jpeg files within specified directory
full_list_train <- list.files(path = dir1, pattern=".jpeg", all.files=FALSE, 
                         full.names=FALSE)

full_list_valid <- list.files(path = dir2, pattern=".jpeg", all.files=FALSE, 
                         full.names=FALSE)

# Train images
length(full_list_train)

# Valid images
length(full_list_valid)


# Creating lists of labels (txt files)

lab_train <- str_replace(full_list_train, ".jpeg", ".txt")
lab_val <- str_replace(full_list_valid, ".jpeg", ".txt")


# Copy annotation labels to respective folders

setwd("/Users/brevis/Documents/Portfolio/weed-detection-MFWD/mfwd_labels2")
getwd()

file.copy(lab_train,
          "/Users/brevis/Documents/Portfolio/weed-detection-MFWD/datasets/train/labels") # copy to train
file.copy(lab_val,
          "/Users/brevis/Documents/Portfolio/weed-detection-MFWD/datasets/valid/labels") # copy to valid




