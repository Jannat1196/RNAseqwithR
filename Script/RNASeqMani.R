# Install required R package
library(tidyverse)
library(ggpubr)
library(openxlsx)
install.packages('openxlsx')
library(GEOquery)
install.packages('naniar')
library(naniar) #missing data

#Install Bioconductor packages
BiocManager::install(c('TCGAbiolinks','airway','DESeq2'))
library(TCGAbiolinks)

#DT manipulation
#1. select
#Import data
data<-read.csv("G:\\newRNA\\RNAseqwithR\\DATA\\GSE183947_fpkm.csv")

#----------------------------------------------
# select col by col num
select(data,1)
# select multiple col by col num
select(data,c(1,3,4))
#Select by range
select(data, 1:3)
#select by col name
select(data,CA.102548)
#-----------------------------------------------
#dimention
dim(data)
ncol(data)
nrow(data)
#=================================
#data exploration
#1. first few raws
head(data)
#2. last few data
tail(data,2)
#sampling
sample(data)
sample_frac(data,0.025) #25% data
#---------------------------------------------------
#missing value check
is.na(data)
sum(is.na(data))
miss_var_summary(data) #table wise
gg_miss_var(data)  #visualize missing data
miss_var_which(data) #which var is missing


#2. filter
names(data) # column name showing

#2.1 filter by data using (>)
filter(data,CA.105094>10)

## chainig method using piping operator (|>)
data |>
  select(X,CA.102548)
  filter(CA.102548>10)|>
  head()


#3. Mutate
#4. Grouping and summerizing