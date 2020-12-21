install.packages("chron")
install.packages("tidyverse")
library(chrons)
library (tidyverse)


# Read in .txt data, seperate varaibles with " ; " semi-colon
power<- read.delim2("household_power_consumption.txt", sep = ";", dec = ",")
dim(power)

# Make date strptime into new columns. Make it as.Date into new column
power$nd <- strptime(as.character(power$Date), "%d/%m/%Y")
power$Ds <- as.Date(as.character(power$nd), "%Y-%m-%d")

# subset all dates from 2007-02-1 to 2007-02-02
tru <- subset(power, Ds == as.Date("2007-02-01") | Ds == as.Date("2007-02-02"))

#Drop unused date columns (Date, nd)
Pow <- subset(tru, select = -c(Date, nd))

# Make ActivePower, ReactivePower, Voltage, and submeters into numeric class (from character) to graph
Pow$Global_active_power <- as.numeric(Pow$Global_active_power)
Pow$Sub_metering_1 <- as.numeric(Pow$Sub_metering_1)
Pow$Sub_metering_2 <- as.numeric(Pow$Sub_metering_2)
Pow$Sub_metering_3 <- as.numeric(Pow$Sub_metering_3)
Pow$Voltage <- as.numeric(Pow$Voltage)
Pow$Global_reactive_power <- as.numeric(Pow$Global_reactive_power)

# Make Pow$Time (characters) into time class
Pow$times <- chron(times = Pow$Time )

#Drop unused Time columns (Time)
Pow <- subset(Pow, select = -c(Time))

# Merge ds and times to make DateTime
Pow$DateTime <- as.POSIXct(paste(Pow$Ds, Pow$times), format="%Y-%m-%d %H:%M:%S")


# Make a tall skinny dataframe by merging all of the sub_metering data. 
XX <- Pow %>% select(DateTime, Sub_metering_1, Sub_metering_2, Sub_metering_3) %>% pivot_longer(.,cols = c(Sub_metering_1, Sub_metering_2, Sub_metering_3), names_to = "Var", values_to = "Val")

# Data is ready for plotting. Create PNG file 
png(filename = "plot3.png", width = 480, height = 480, units = "px")

# Start with blank plot
with(XX, plot(DateTime, Val, ylab = "Energy sub metering", xlab = " ",  type = "n"))

# Add in the data for each sub_metering measure , varying by color
with(subset(XX, Var == "Sub_metering_2"), points(DateTime, Val, col = "red", type = "l"))
with(subset(XX, Var == "Sub_metering_3"), points(DateTime, Val, col = "blue", type = "l"))
with(subset(XX, Var == "Sub_metering_1"), points(DateTime, Val, col = "black", type = "l"))

# Add Legend top right
legend("topright", pch = "",lty = 1,col = c("black", "blue", "red"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# Close out file
dev.off()


