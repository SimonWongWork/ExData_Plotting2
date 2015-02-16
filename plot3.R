# Exploratory Data Analysis, Project 2

# Go to Working directory of R studio.
# Load necessary libary.
library(ggplot2)
library(plyr) 


# Load data.
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")    


# Create new "subsetData" by Subsetting based on row "fips" of "24510".    
subsetData <- subset (NEI, fips == "24510")


# "subsetData" to be splited by "year" and "type" variable and a new dataframe "plotInfo" created by using "summarize" formule on summation of "Emissions".
plotInfo <- ddply(subsetData, .(year, type), function(x) sum(x$Emissions))    

# Rename the col: Emissions
colnames(plotInfo)[3] <- "Emissions"

# Plot the graph
png("plot3.png")


qplot(  year, Emissions, data = plotInfo, color = type, geom = "line") + 
        ggtitle(expression("Baltimore City" ~ PM[2.5] ~ "Emmission by source, type and year")) + 
        xlab("Year") + ylab(expression("Total" ~ PM[2.5] ~ "Emissions (in tons)"))    

dev.off()
    
