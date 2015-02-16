# Exploratory Data Analysis, Project 2
# acknowledge "http://rpubs.com/geekgirl72/24156" for references.

# Go to Working directory of R studio.
# Load necessary libary.
library(ggplot2)
library(plyr) 


# Load data.
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds") 


# Subset to find out new dataframe from the rows that constain "Vehicles" in EI.Sector colummn cell of SCC (Source Classification Code) file.
subsetVehiclesData <- unique(grep("Vehicles", SCC$EI.Sector, ignore.case = TRUE, value = TRUE))


# Subset to find out the respective row and SCC from the dataframe "subsetVehiclesData".
subsetSourceData <- SCC[SCC$EI.Sector %in% subsetVehiclesData, ]["SCC"]


# Subset to find out the list only contains the emissions from motor vehicles for Baltimore, MD.
subsetEmissionData <- NEI[NEI$SCC %in% subsetSourceData$SCC & NEI$fips == "24510", ]
 
 
# Get the final emissions data for motor vehicles in Baltimore for every year.
plotData <- ddply( subsetEmissionData, .(year), function(x) sum(x$Emissions) )


# Rename the col.
colnames(plotData)[2] <- "Emissions"


# Plot the outcome.
png("plot5.png")
qplot(  year, Emissions, data = plotData, geom = "line") + 
        ggtitle(expression("Baltimore City" ~ PM[2.5] ~ "Motor Vehicle Emissions by Year")) + 
        xlab("Year") + ylab(expression("Total" ~ PM[2.5] ~ "Emissions (tons)"))
        
dev.off()

