# Exploratory Data Analysis, Project 2


plot1 = function()
{
    # Go to Working directory of R studio.
    # Load necessary libary.
    library("plyr") 
    
    
    # Load data.
    NEI <- readRDS("summarySCC_PM25.rds")
    SCC <- readRDS("Source_Classification_Code.rds")    

    
    # Transform the "NEI" to "dataFrame" with a vector of "year" factor values.
    dataFrame <- transform( NEI, year = factor(year) )
  
    
    # "dataFrame" to be splited by "year" variable and a new dataframe "plotInfo" created by using "summarize" formule on summation of "Emissions".
    plotInfo <- ddply( dataFrame, .(year), summarize, sum = sum(Emissions) )
    
    
    # Plot the graph
    png("plot1.png")
    
    
    # Parameters setting:
    # type = "n"                    : develop the plot without points.
    # xlab = "year"                 : name "year" as the title for the x axis.
    # ylab = "total PM2.5 Emission" : name "total PM2.5 Emission" as the title for the y axis.
    # boxwex= 0.05                  : a scale factor of 0.05 to be applied to all the box.
    plot( plotInfo$year, plotInfo$sum, type = "n", xlab = "year", ylab = expression("Total" ~ PM[2.5] ~ "Emissions (tons)"), 
          main = expression("Total US" ~ PM[2.5] ~ "Emissions by Year"), boxwex = 0.01)
         
    lines( plotInfo$year, plotInfo$sum)
    dev.off()

}


