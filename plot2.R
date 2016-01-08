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

# read dataset from data file as data frame
powConsumption <- fread(dataFile, sep = ";", header = TRUE, 
                                   na.strings = "?", data.table = FALSE)

# subset dataset on dates 1/2/2007 and 2/2/2007
powConsumption <- subset(powConsumption, 
                                    Date %in% c("1/2/2007", "2/2/2007"))

# create single POSIXlt class field from Date and Time string fields
powConsumption$datetime <- strptime(paste(powConsumption$Date, powConsumption$Time), 
                                    "%d/%m/%Y %H:%M:%S")

# launch PNG file device (i.e. create output PNG file)
png(file="plot2.png", width=480,height=480)

# create plot (will be output to PNG file)
with(powConsumption, plot(datetime, Global_active_power, type = "l", 
                          xlab = "", ylab = "Global Active Power (kilowatts)"))

# close PNG file device
dev.off()
