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



#### Of the four types of sources indicated by the type           ####
####    (point, nonpoint, onroad, nonroad) variable,              ####
#### which of these four sources have seen decreases in emissions ####
####    from 1999–2008 for Baltimore City?                        ####
#### Which have seen increases in emissions from 1999–2008?       ####


plotData <- NEI %>%
        filter(fips == "24510") %>%
        group_by(year,type) %>%
        summarise(totalEmission = sum(Emissions)) 

png("plot3.png")

ggplot(data=plotData,aes(x=year,y=totalEmission,fill=type))+
        scale_x_continuous(breaks=c(1999,2002,2005,2008)) + 
        facet_grid(.~type) +
        geom_bar(stat="identity") +
        geom_smooth(method="lm",se=FALSE,lwd=2,col="Black") + 
        xlab("Year") + ylab(expression('Total PM' [2.5] ~ ' emission (tons)')) +
        ggtitle(expression('Total PM' [2.5] ~ 
                        ' emission between 1999 and 2008 for Baltimore City'))

dev.off()