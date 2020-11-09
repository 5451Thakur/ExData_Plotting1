inputFile <- "C://data//household_power_consumption.txt"
in_fileConnection  <- file(inputFile, open = "r")


header <- TRUE
plot_df <- data.frame(matrix(ncol = 9, nrow = FALSE))

while (length(oneLine <- readLines(in_fileConnection, n = 1, warn = FALSE)) > 0) {
  if(header) { #Use the first line as a header for the dataframe
    row_names <- unlist(strsplit(oneLine, ";"))
    colnames(plot_df) <- c(row_names)
    header <- FALSE
  }
  else if (grepl("^[1-2]/2/2007", oneLine)){
    plot_df[nrow(plot_df) + 1, ] <- unlist(strsplit(oneLine, ";" ))
  }
}

plot_df <- cbind(strptime(paste(plot_df$Date, plot_df$Time),"%d/%m/%Y %H:%M:%S"), plot_df)
colnames(plot_df)[1] <- "Date_time"
plot_df <- plot_df[ , -c(2, 3)]
close(in_fileConnection)

png("plot4.png", width = 480, height = 480, units = "px")
par(mfcol = c(2, 2))

plot(plot_df$Date_time, as.numeric(plot_df$Global_active_power), xlab = "" , ylab = "Global Active Power (Kilowatts)", pch = '.:')
lines(plot_df$Date_time, as.numeric(plot_df$Global_active_power))

plot(plot_df$Date_time, plot_df$Sub_metering_1, pch = ".:", xlab = "" , ylab = "Energy sub metering")
lines(plot_df$Date_time, plot_df$Sub_metering_1)
lines(plot_df$Date_time, plot_df$Sub_metering_2, col = "red" )
lines(plot_df$Date_time, plot_df$Sub_metering_3, col = "blue" )
legend("topright",legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c( "black", "red", "blue"), lty = 1)
# 
# 
plot(plot_df$Date_time, as.numeric(plot_df$Voltage), xlab = "datetime" , ylab = "Voltage", pch = '.:')
lines(plot_df$Date_time, plot_df$Voltage)

plot(plot_df$Date_time, as.numeric(plot_df$Global_reactive_power), xlab = "datetime" , ylab = "Global_reactive_power", pch = '.:')
lines(plot_df$Date_time, plot_df$Global_reactive_power)

dev.off()