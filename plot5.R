library(dplyr)
library(ggplot2)

#### Download and read the data ####

url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

if (!(file.exists("Source_Classification_Code.rds") && 
      file.exists("summarySCC_PM25.rds"))){
        download.file(url, "Emissions.zip", method="curl")
        unzip("Emissions.zip")
}


NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


#### How have emissions from motor vehicle sources changed from ####
####    1999–2008 in Baltimore City?                            ####


motor <- filter(SCC,grepl("[V,v]ehicle",EI.Sector))

plotData <- merge(filter(NEI,fips == "24510"),motor) %>%
        group_by(year,EI.Sector) %>%
        summarise(totalEmission = sum(Emissions)) 


png("plot5.png")

ggplot(data=plotData,aes(x=factor(year),y=totalEmission)) + 
        geom_bar(aes(fill=EI.Sector),stat="identity") + 
        xlab("Year") + ylab(expression('Total PM' [2.5] ~ ' emission (tons)')) +
        ggtitle(expression('Total PM' [2.5] ~ 
                                   ' emission from motor vehicles in Baltimore City'))


dev.off()