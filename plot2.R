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

# first plot
library(datasets)
times <- paste(small.data$Date, small.data$Time, sep = " ")

x <- strptime(times, "%d/%m/%Y %H:%M:%S")
y <- as.numeric(small.data$Global_active_power)
plot(x, y, type ="l", xlab = "", ylab = "Global Active Power (kilowatts)")

dev.copy(png, file = "plot2.png")  ## Copy my plot to a PNG file
dev.off()  ## Don't forget to close the PNG device!
