################# GETTING DATA #################

# Loading required library
library(data.table)
##Sys.setlocale("LC_TIME", "English")

# Relative path to the data file
file <- "data/household_power_consumption.txt"

# Dates to process
StartDate <- "2007-02-01"
EndDate <- "2007-02-02"

# Format strings for date/date & time
FormatDate <- "%d/%m/%Y"
FormatDateTime <- "%Y-%m-%d %H:%M:%S"

# Column indexes to be coerced to numeric
IndexesColumnToNumeric <- c(3,9)

# Read file in a datatable
myData <- fread(file, header=TRUE, sep=";", colClasses="character", na="?")

# format dates
myData$Date <- as.Date(myData$Date, format=FormatDate)

# Two days data (Data from StartDate and EndDate)
myData2days <- myData[myData$Date == StartDate | myData$Date == EndDate,]
myData2days <- data.frame(myData2days)

# Format DateTime
myData2days$DateTime <- paste(myData2days$Date, myData2days$Time)
myData2days$DateTime <- strptime(myData2days$DateTime, format = FormatDateTime)


# Convert some columns to numeric format
for(index in IndexesColumnToNumeric) {
  myData2days[,index] <- as.numeric(as.character(myData2days[,index]))
}


################# PLOTTING #################

# Open Graphic Device
png(filename="plot3.png", width=480, height=480, units="px", bg="white")

# Graphic margins initialization
par(mar = c(8,8,8,8))

# Graphic Plot
plot(myData2days$DateTime, myData2days$Sub_metering_1, col="black", type="l", xlab="", ylab="Energy sub metering")
lines(myData2days$DateTime, myData2days$Sub_metering_2, col="red")
lines(myData2days$DateTime, myData2days$Sub_metering_3, col="blue")
legend("topright",col=c("black", "red", "blue"), c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), lty=1)

# Close Graphic device
dev.off()
