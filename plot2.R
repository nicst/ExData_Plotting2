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


#### Have total emissions from PM2.5 decreased in the ####
####    Baltimore City, Maryland from 1999 to 2008     ####


plotData <- NEI %>%
        filter(fips == "24510") %>%
        group_by(year) %>%
        summarise(totalEmission = sum(Emissions))

png("plot2.png")

with(plotData,barplot(totalEmission,names.arg=year,col="slateblue3"))
title(main = expression('Total PM' [2.5] ~ 
                ' emission between 1999 and 2008 for Baltimore City'),
      xlab = "Year", ylab = expression('Total PM' [2.5] ~ ' emission (tons)'))

dev.off()