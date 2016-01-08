library(utils)
library(data.table)

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
householdPowerConsumption <- fread(dataFile, sep = ";", header = TRUE, na.strings = "?")

# extract data for dates 1/2/2007 and 2/2/2007
householdPowerConsumption <- householdPowerConsumption[Date %in% c("1/2/2007", "2/2/2007"),]

# launch PNG file device (i.e. create output PNG file)
png(file="plot1.png", width=480,height=480)

# create histogram (will be output to PNG file)
hist(householdPowerConsumption$Global_active_power, col = "red", main = "Global Active Power", xlab="Global Active Power (kilowatts)")

# close PNG file device
dev.off()
