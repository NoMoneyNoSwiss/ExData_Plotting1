require(lubridate)
Sys.setlocale("LC_ALL","English")

# download dataset if it does not exist

if (!('household_power_consumption.txt' %in% dir())) {
    download.file('https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip', destfile = 'dataset.zip')
    unzip('dataset.zip')
    
    if (!('household_power_consumption.txt' %in% dir())) stop('cannot find household_power_consumption.txt, something has gone wrong!')
} 

# load dataset into memory if it is not already there

if (!('hpwc' %in% ls())) {
    hpwc <- read.csv('household_power_consumption.txt', header = TRUE, sep = ';', stringsAsFactors = FALSE)
    
    # set the right types for date variables
    
    hpwc$Date <- dmy(hpwc$Date)
    hpwc$Time <- hms(hpwc$Time)
    
    # cast the remaining variables to numeric (with ? to NA as a result)
    
    hpwc <- as.data.frame(lapply(hpwc, function(x) {
        if (class(x) == 'character') {
            as.numeric(x)
        } else {
            x
        }
    }))
    
    # filter only the two dates 2007-02-01 and 2007-02-02
    
    hpwc <- hpwc[hpwc$Date %in% ymd(c('2007-02-01', '2007-02-02')), ]
}


# create plot 4



png(filename = 'plot4.png', width = 480, height = 480, type = 'cairo')

par(mfrow = c(2, 2))

plot(
    hpwc$Date + hpwc$Time, hpwc$Global_active_power, type = 'l',
    xlab = '',
    ylab = 'Global Active Power'
)

plot(
    hpwc$Date + hpwc$Time, hpwc$Voltage, type = 'l',
    xlab = 'datetime',
    ylab = 'Voltage'
)

plot(
    hpwc$Date + hpwc$Time, hpwc$Sub_metering_1, type = 'l',
    xlab = '',
    ylab = 'Energy sub metering'
)

lines(
    hpwc$Date + hpwc$Time, hpwc$Sub_metering_2, type = 'l', col = 'red'
)

lines(
    hpwc$Date + hpwc$Time, hpwc$Sub_metering_3, type = 'l', col = 'blue'
)

legend('topright', legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), col = c('black', 'red', 'blue'), lwd = 1, bty = 'n') 

plot(
    hpwc$Date + hpwc$Time, hpwc$Global_reactive_power, type = 'l',
    xlab = 'datetime', ylab = 'Global_reactive_power'
)

dev.off()