
install.packages("chron")
install.packages("tidyverse")
library(chron)
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

# Make Global_Active_power into numeric class (from character) to graph
Pow$Global_active_power <- as.numeric(Pow$Global_active_power)


# Make Pow$Time (characters) into time class
Pow$times <- chron(times = Pow$Time )

#Drop unused Time columns (Time)
Pow <- subset(Pow, select = -c(Time))

# Merge ds and times to make DateTime
Pow$DateTime <- as.POSIXct(paste(Pow$Ds, Pow$times), format="%Y-%m-%d %H:%M:%S")

# Data is ready to plot, create PNG file
png(filename = "plot2.png", width = 480, height = 480, units = "px")

# Plot data
plot(Pow$DateTime, Pow$Global_active_power, type = "l", ylab = "Global Active Power (killowatts)", xlab = " ")

#Close off file
dev.off()










