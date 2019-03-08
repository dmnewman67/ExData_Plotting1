# Read the data table and assign it to the variable tab
tab <- read.table("household_power_consumption.txt", header=TRUE, sep=";", na.strings = "?", colClasses = c('character','character','numeric','numeric','numeric','numeric','numeric','numeric','numeric'))

# Format date
tab$Date <- as.Date(tab$Date, "%d/%m/%Y")

# Only use data from 1Feb07 to 2Feb07
tab <- subset(tab,Date >= as.Date("2007-2-1") & Date <= as.Date("2007-2-2"))

# Remove partial data rows
tab <- tab[complete.cases(tab),]

# Combine Date column with Time column
dateTime <- paste(tab$Date, tab$Time)
dateTime <- setNames(dateTime, "DateTime") 
tab <- tab[ ,!(names(tab) %in% c("Date","Time"))]
tab <- cbind(dateTime, tab)
tab$dateTime <- as.POSIXct(dateTime)

# Create Plot 2
plot(tab$Global_active_power~tab$dateTime, type="l", ylab="Global Active Power (kilowatts)", xlab="datetime")

# Save file and close device
dev.copy(png,"plot2.png", width=480, height=480)
dev.off()
