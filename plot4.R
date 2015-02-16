# Exploratory Data Analysis, Project 2
# acknowledge "http://rpubs.com/geekgirl72/24156" for references.

# Go to Working directory of R studio.
# Load necessary libary.
library(ggplot2)
library(plyr) 


# Load data.
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds") 


# Subset for only specified coal-combustion type.
subset_SpecifiedCoalCombustion <- subset( SCC, EI.Sector %in% c("Fuel Comb - Comm/Instutional - Coal", 
                                          "Fuel Comb - Electric Generation - Coal", "Fuel Comb - Industrial Boilers, ICEs - Coal"))

                        
# Subset for general coal-combustion type that may be missed out in previous subset.
subset_GeneralCoalCombustion <- subset( SCC, grepl("Comb", Short.Name) & grepl("Coal", Short.Name))


# Find out the row number in both subset data.
nrow(subset_SpecifiedCoalCombustion) 
nrow(subset_GeneralCoalCombustion) 


## Find out the differences between two subset data.
dif1 <- setdiff(subset_SpecifiedCoalCombustion$SCC, subset_GeneralCoalCombustion$SCC)
dif2 <- setdiff(subset_GeneralCoalCombustion$SCC, subset_SpecifiedCoalCombustion$SCC)


# Find out the length of both array.
length(dif1)    #0
length(dif2)    #91


# Union sources of both subset data.
combinedBothCoalComb <- union(subset_SpecifiedCoalCombustion$SCC, subset_GeneralCoalCombustion$SCC)
length(combinedBothCoalComb) #91


# Final subset for what we really want.
subset_FinalData <- subset(NEI, SCC %in% combinedBothCoalComb)


# Get the final data.
coalCombustionFinalData <- ddply(subset_FinalData, .(year, type), function(x) sum(x$Emissions))


# Rename the col
colnames(coalCombustionFinalData)[3] <- "Emissions"


# Plot the outcome.
png("plot4.png")
qplot(year, Emissions, data=coalCombustionFinalData, color=type, geom="line") + stat_summary(fun.y = "sum", fun.ymin = "sum", fun.ymax = "sum", color = "purple", aes(shape="total"), geom="line") + geom_line(aes(size="total", shape = NA)) + ggtitle(expression("Coal Combustion" ~ PM[2.5] ~ "Emissions by Source Type and Year")) + xlab("Year") + ylab(expression("Total" ~ PM[2.5] ~ "Emissions (tons)"))
dev.off()


