# Exploratory Data Analysis, Project 2


plot2 = function()
{
    # Go to Working directory of R studio.
    # Load necessary libary.
    library("plyr") 
    
    
    # Load data.
    NEI <- readRDS("summarySCC_PM25.rds")
    SCC <- readRDS("Source_Classification_Code.rds")    

    
    # Create new "subsetData" by Subsetting based on row "fips" of "24510".
    subsetData  <- subset (NEI, fips == "24510")
    
    
    # Apply sum function on the specified cells of "Emissions" and "year" of "subsetData".
    plotInfo    <- tapply(subsetData$Emissions, subsetData$year, sum)    
    
    
    # "subsetData" to be splited by "year" variable and a new dataframe "plotInfo" created by using "summarize" formule on summation of "Emissions".
    plotInfo <- ddply( subsetData, .(year), summarize, sum = sum(Emissions) )
    
    
    # Plot the graph
    png("plot2.png")
    
    
    # Parameters setting:
    # type = "n"                                : develop the plot without points.
    # xlab = "year"                             : name "year" as the title for the x axis.
    # ylab = "total PM2.5 Emission"             : name "total PM2.5 Emission" as the title for the y axis.
    # boxwex= 0.05                              : a scale factor of 0.05 to be applied to all the box.
    # main = PM2.5 emission in Baltimore City"  : an overall title for the plot is "PM2.5 emission in Baltimore City".
    plot( plotInfo$year, plotInfo$sum, type = "n", xlab = "year",  ylab = expression("Total" ~ PM[2.5] ~ "Emissions (tons)"),  
          main = expression("Total for Baltimore City" ~ PM[2.5] ~ "Emissions by Year") )
          
    lines( plotInfo$year, plotInfo$sum)
    dev.off()

}