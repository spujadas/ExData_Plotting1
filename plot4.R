library(utils)
library(data.table)
Sys.setlocale("LC_TIME", "C")  ## avoid possible issues with dates on some systems

dataFile <- "household_power_consumption.txt"

# if data file doesn't exist, download and unzip it
if (!file.exists(dataFile)) {
  dataUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  temp <- tempfile()
  download.file(dataUrl, temp)
  unzip(temp, dataFile)
  unlink(temp)
}

# read dataset from data file
powConsumption <- fread(dataFile, sep = ";", header = TRUE, 
                        na.strings = "?", data.table = FALSE)

# subset dataset on dates 1/2/2007 and 2/2/2007
powConsumption <- subset(powConsumption, 
                         Date %in% c("1/2/2007", "2/2/2007"))

# create single POSIXlt class field from Date and Time string fields
powConsumption$datetime <- strptime(paste(powConsumption$Date, powConsumption$Time), 
                                    "%d/%m/%Y %H:%M:%S")

# launch PNG file device (i.e. create output PNG file)
png(file="plot4.png", width=480,height=480)

# initialise 2x2 plot window
par(mfrow=c(2,2))

# create subplot 1
with(powConsumption, plot(datetime, Global_active_power, type = "l", 
                          xlab = "", ylab = "Global Active Power"))

# create subplot 2
with(powConsumption, plot(datetime, Voltage, type = "l"))

# create subplot 3
with(powConsumption, plot(datetime, Sub_metering_1, type = "l", 
                          xlab = "", ylab = "Energy sub metering"))
with(powConsumption, lines(datetime, Sub_metering_2, type = "l", col = "red"))
with(powConsumption, lines(datetime, Sub_metering_3, type = "l", col = "blue"))
legend("topright", col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lty = c(1, 1, 1), bty = "n")

# create subplot 4
with(powConsumption, plot(datetime, Global_reactive_power, type = "l"))

# close PNG file device
dev.off()