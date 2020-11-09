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

png("plot1.png", width = 480, height = 480, units = "px")
hist(as.numeric(plot_df$Global_active_power), col = "red", main = "Global Active Power", xlab = "Global Active Power (Kilowatts)")
dev.off()