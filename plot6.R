# Exploratory Data Analysis, Project 2
# acknowledge "http://rpubs.com/geekgirl72/24156" for references.

# Go to Working directory of R studio.
# Load necessary libary.
library(ggplot2)
library(plyr) 
library(grid)


# Load data.
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds") 


# Subset to find out new dataframe from the rows that constain "Vehicles" in EI.Sector colummn cell of SCC (Source Classification Code) file.
VehiclesData <- unique(grep("Vehicles", SCC$EI.Sector, ignore.case = TRUE, value = TRUE))


# Subset to find out the respective row and SCC from the dataframe "VehiclesData".
SourceData <- SCC[SCC$EI.Sector %in% VehiclesData, ]["SCC"]


# Subset to find out the list only contains the emissions from motor vehicles for Baltimore, MD.
Baltimore_Data <- NEI[NEI$SCC %in% SourceData$SCC & NEI$fips == "24510", ]


# Subset to find out the list only contains the emissions from motor vehicles for Baltimore, MD.
LosAngeles_Data <- NEI[NEI$SCC %in% SourceData$SCC & NEI$fips == "06037", ]


# Bind both city data.
BothCity_Data <- rbind( Baltimore_Data, LosAngeles_Data )


# Find the emmissions of the motor vehicles in both cities, Baltimore and Los Angeles.
BothCityEmission_Data           <- aggregate( Emissions ~ fips * year, data = BothCity_Data, FUN = sum ) 


# Refill the county code with readable noun.
BothCityEmission_Data$county    <- ifelse( BothCityEmission_Data$fips == "06037", "Los Angeles", "Baltimore")


# Plotting the outcome.
png("plot6.png", width = 800)

qplot(  year, Emissions, data = BothCityEmission_Data, geom = "line", color=county) + 
        ggtitle(expression("Motor Vehicle Emission Levels" ~ PM[2.5] ~ "  from 1999 to 2008 in  Baltimore, MD and Los Angeles, CA")) + 
        xlab("Year") + ylab(expression("Levels of" ~ PM[2.5] ~ " Emissions"))
        
dev.off()

