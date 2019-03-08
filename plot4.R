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

# Create Plot 4
par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))
with(tab, {
  plot(Global_active_power~dateTime, type="l", 
       ylab="Global_active_power", xlab="datetime")
  plot(Voltage~dateTime, type="l", 
       ylab="Voltage", xlab="datetime")
  plot(Sub_metering_1~dateTime, type="l", 
       ylab="Energy_sub_metering", xlab="datetime")
  lines(Sub_metering_2~dateTime,col='Red')
  lines(Sub_metering_3~dateTime,col='Blue')
  legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, bty="n",
         legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
  plot(Global_reactive_power~dateTime, type="l", 
       ylab="Global_reactive_power",xlab="datetime")
})

# Save file and close device
dev.copy(png, file="plot4.png", height=480, width=480)
dev.off()
