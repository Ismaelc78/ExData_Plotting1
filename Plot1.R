
install.packages("tidyverse")
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

# Make Global_Active_power into numeric class (from character) to place into histogram
Pow$Global_active_power <- as.numeric(Pow$Global_active_power)

# Plot is ready to be made. Call png() to make to png
png(filename = "plot1.png", width = 480, height = 480, units = "px")

# Produce histogram with labels and color
hist(Pow$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", ylab = "Frequency", main = "Global Active Power")

# Call dev.off() to complete graph and close it off
dev.off()

