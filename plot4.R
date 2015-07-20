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


#### Across the United States, how have emissions from        ####
####   coal combustion-related sources changed from 1999–2008 ####
              

coal <- filter(SCC,grepl("[C,c]oal",EI.Sector))
                  
plotData <- merge(NEI,coal) %>%
        group_by(year,EI.Sector) %>%
        summarise(totalEmission = sum(Emissions)) 

png("plot4.png")

ggplot(data=plotData,aes(x=factor(year),y=totalEmission)) + 
        geom_bar(aes(fill=EI.Sector),stat="identity") + 
        xlab("Year") + ylab(expression('Total PM' [2.5] ~ ' emission (tons)')) +
        ggtitle(expression('Total PM' [2.5] ~ 
                                   ' emission from coal combustion-related sources'))


dev.off()