# read the data int r from the following url.
fileUrl <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# create a temporary directory
td = tempdir()

# create the placeholder file
tf = tempfile(tmpdir=td, fileext=".zip")
# download into the placeholder file
download.file(fileUrl, tf)

# get the names of the relevant files in the zip archive
fnames = unzip(tf, list=TRUE)


# extract file from file
fname = fnames$Name[1]
# unzip the files to the temporary directory
unzip(tf, files=fname, exdir=td, overwrite=TRUE)
# fpath is the full path to the extracted file
fpath = file.path(td, fname)
# read in data into R
data <- read.table("household_power_consumption.txt", header = TRUE, sep = ";", stringsAsFactors = FALSE)

# subset out the data for 1/2/2007 and 2/2/2007 in dd/mm/yyyy format
small.data1 <- data[grep("^1/2/2007", data$Date),]
small.data2 <- data[grep("^2/2/2007", data$Date),]
small.data <- rbind(small.data1, small.data2)

# fourth plot
library(datasets)

times <- paste(small.data$Date, small.data$Time, sep = " ")
x <- strptime(times, "%d/%m/%Y %H:%M:%S")
y <- as.numeric(small.data$Global_active_power)

meter1 <- as.numeric(small.data$Sub_metering_1)
meter2 <- as.numeric(small.data$Sub_metering_2)
meter3 <- as.numeric(small.data$Sub_metering_3)
max.meter <- pmax(meter1, meter2, meter3) # get max reading so we can make a plot window to fit all the data

Voltage <- as.numeric(small.data$Voltage)

# global_reactive_power versus time.
Global_reactive_power <- as.numeric(small.data$Global_reactive_power)

png("plot4.png", width = 480, height = 480)  ## Copy my plot to a PNG file

par(mfrow = c(2, 2), lwd = .2)

plot(x, y, type ="l", xlab = "", ylab = "Global Active Power")
plot(x, Voltage, type = "l", xlab = "datetime")
plot(x, max.meter, type = "n", xlab = "", ylab = "Energy sub metering")
legend("topright", 
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), # puts text in the legend
       lty=c(1,1,1), # gives the legend appropriate symbols (lines)
       lwd=c(2.5,2.5,2.5),col=c("black", "red", "blue"), bty = "n") # gives the legend lines the correct color and width

lines(x, meter1, col = "black")
lines(x, meter2, col = "red")
lines(x, meter3, col = "blue")
plot(x, Global_reactive_power, type = "l", xlab = "datetime")


dev.off()  ## Don't forget to close the PNG device!
