library(dplyr)


#### Download and read the data ####

url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

if (!(file.exists("Source_Classification_Code.rds") && 
             file.exists("summarySCC_PM25.rds"))){
        download.file(url, "Emissions.zip", method="curl")
        unzip("Emissions.zip")
}


NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


#### Make a plot showing the total PM2.5 emission from all sources ####
####    for each of the years 1999, 2002, 2005, and 2008.          ####


plotData <- NEI %>%
        group_by(year) %>%
        summarise(totalEmission = sum(Emissions))

png("plot1.png")

with(plotData,barplot(totalEmission,names.arg=year,col="tan1"))
title(main = expression('Total PM' [2.5] ~ ' emission between 1999 and 2008'),
      xlab = "Year", ylab = expression('Total PM' [2.5] ~ ' emission (tons)'))

dev.off()