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

# Create Plot 3
with(tab, {
  plot(Sub_metering_1~dateTime, type="l",
       ylab="Energy_sub_metering", xlab="datetime")
  lines(Sub_metering_2~dateTime,col='Red')
  lines(Sub_metering_3~dateTime,col='Blue')
})
legend("topright", col=c("black", "red", "blue"), lwd=c(1,1,1), 
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))


# Save file and close device
dev.copy(png, file="plot3.png", height=480, width=480)
dev.off()
