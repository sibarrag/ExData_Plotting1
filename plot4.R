################# GETTING DATA #################

# Loading required library
library(data.table)
##Sys.setlocale("LC_TIME", "English")

# Relative path to the data file
file <- "data/household_power_consumption.txt"

# Dates to process
startDate <- "2007-02-01"
endDate <- "2007-02-02"

# Format strings for date/date & time
formatDate <- "%d/%m/%Y"
formatDateTime <- "%Y-%m-%d %H:%M:%S"

# Column indexes to be coerced to numeric
indexesColumnToNumeric <- c(3,9)

# Read file in a datatable
myData <- fread(file, header=TRUE, sep=";", colClasses="character", na="?")

# format dates
myData$Date <- as.Date(myData$Date, format=formatDate)

# Two days data (Data from StartDate and EndDate)
myData2days <- myData[myData$Date == startDate | myData$Date == endDate,]
myData2days <- data.frame(myData2days)

# Format DateTime
myData2days$DateTime <- paste(myData2days$Date, myData2days$Time)
myData2days$DateTime <- strptime(myData2days$DateTime, format=formatDateTime)


# Convert some columns to numeric format
for(index in indexesColumnToNumeric) {
  myData2days[,index] <- as.numeric(as.character(myData2days[,index]))
}


################# PLOTTING #################

# Open Graphic Device
png(filename="plot4.png", width=480, height=480, units="px", bg="white")

# Graphic initialization with 2 rows and 2 columns
par(mfrow=c(2,2))


# Plot 1
plot(myData2days$DateTime, myData2days$Global_active_power, type="l", xlab="", ylab="Global Active Power")


# Plot 2
plot(myData2days$DateTime, myData2days$Voltage, type="l", xlab="datetime", ylab="Voltage")


# Plot 3
plot(myData2days$DateTime, myData2days$Sub_metering_1, col="black", type="l", xlab="", ylab="Energy sub metering")
lines(myData2days$DateTime, myData2days$Sub_metering_2, col="red")
lines(myData2days$DateTime, myData2days$Sub_metering_3, col="blue")
legend("topright",col=c("black", "red", "blue"), c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1)


# Plot 4
plot(myData2days$DateTime, myData2days$Global_reactive_power, type="n", xlab="datetime", ylab="Global_reactive_power")
lines(myData2days$DateTime, myData2days$Global_reactive_power)


# Close Graphic device
dev.off()
