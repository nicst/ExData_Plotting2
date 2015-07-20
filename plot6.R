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


#### Compare emissions from motor vehicle sources in Baltimore City ####
####   with emissions from motor vehicle sources in                 ####
####   Los Angeles County, California. Which city has seen greater  ####
####   changes over time in motor vehicle emissions?                ####



motor <- filter(SCC,grepl("[V,v]ehicle",EI.Sector))

plotData <- merge(filter(NEI,fips == "24510" | fips == "06037"),motor) %>%
        mutate(city = ifelse(fips == "24510", 
                             "Baltimore City", "Los Angeles County")) %>%
        group_by(year,city) %>%
        summarise(totalEmission = sum(Emissions))


png("plot6.png")

ggplot(data=plotData,aes(x=year,y=totalEmission,col=city)) + 
        geom_line(lwd=2) + geom_smooth(method="lm",se=F,lty=3,lwd=1.3) +
        xlab("Year") + ylab(expression('Total PM' [2.5] ~ ' emission (tons)')) +
        ggtitle(expression('Total PM' [2.5] ~ 
                                   ' emission from motor vehicles in Baltimore' ~
                                   ' and Los Angeles'))


dev.off()