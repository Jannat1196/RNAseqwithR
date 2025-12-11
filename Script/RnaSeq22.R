library(tidyverse)
library(GEOquery)
library(ggpubr)
library(openxlsx)
library(naniar)

#import raw count data data
count_data= read.csv("G:\\newRNA\\RNAseqwithR\\DATA\\GSE183947_fpkm.csv")

# get metadata
res= getGEO(GEO="GSE183947",GSEMatrix= T)
res
class(res)

#metadata
metadata= pData(phenoData(res[[1]]))
head(metadata)

library(dplyr)
#subset metadata
metadata_subset <- metadata |>
  select(c(1,10,11,17))
head(metadata_subset)
View(metadata_subset)

#data preprocessing

metadata_modified <- metadata_subset |>
  rename(
    tissue = characteristics_ch1,
    metastasis = characteristics_ch1.1
  ) |>
  mutate(
    tissue = gsub("tissue:", "", tissue),
    metastasis = gsub("metastasis:", "", metastasis)
  )

View(metadata_modified)

View(count_data)

#metadata_modified = metadata_subset |>
 # rename(tissue = characteristics_ch1, metastasis = characteristics_ch1.1) |>
  #head()
  
#mutate(tissue=gsub("tissue:","",tissue))|>
 # head()
 # mutate(metastasis=gsub("metastasis:", "", metastasis))|>
  #head()

#View(metadata_modified)

library(tidyr)

# Reshaping count data from wide to long format
count_data_long <- count_data |>
  rename(gene = X) |>
  pivot_longer(
    cols = -gene,
    names_to = "sample",
    values_to = "fpkm"
  )

View(count_data_long)


#joining data

count_final= count_data_long |>
  left_join(metadata_modified,by= c("sample"="description"))
View(count_final)

#Export data
write.csv(count_final,"G:\\newRNA\\RNAseqwithR\\DATA\\count_final.csv")

# Visualization

## bar plot 
count_final |>
  filter(gene=="BRCA1") |>
  ggplot(aes(x= sample,y =fpkm, fill= tissue))+geom_col()

# box plot
count_final |>
  filter(gene=="BRCA1") |>
  ggplot(aes(x= sample,y =fpkm, fill= tissue))+geom_boxplot()


#violin plot
count_final |>
  filter(gene=="BRCA1") |>
  ggplot(aes(x= metastasis,y =fpkm, fill= tissue))+geom_violin()

#histogram
count_final |>
  filter(gene=="BRCA1") |>
  ggplot(aes(x =fpkm, fill= tissue))+geom_histogram()


# split figure
count_final |>
  filter(gene=="BRCA1") |>
  ggplot(aes(x =fpkm, fill= tissue))+geom_histogram()+ facet_wrap(~tissue)


# Density plot
count_final |>
  filter(gene=="BRCA1") |>
  ggplot(aes(x =fpkm, fill= tissue))+geom_density()

# split figure
count_final |>
  filter(gene=="BRCA1") |>
  ggplot(aes(x =fpkm, fill= tissue))+geom_histogram()+ facet_wrap(~tissue)

# scatter plot

count_final |>
  filter(gene=="BRCA1"| gene== "BRCA2") |>
  spread(key= gene, value= fpkm) |>
  ggplot(aes(x =  BRCA1, y= BRCA2, colour = tissue))+geom_point()+geom_smooth(method = "lm",se=FALSE)

#Heatmap

gene_of_intereset= c("BRCA1","BRCA2","TP53","MKS1")
count_final |>
  filter(gene %in% gene_of_intereset) |>
  ggplot(aes(x =sample, y= gene, fill= fpkm))+geom_tile()+scale_fill_gradient(low="pink",high="blue")



