require(reshape2) # melt
# EXPLORE DATASET #####################
data(Seatbelts)
# creates x-axis for time series
times <- time(Seatbelts)

# extract years for grouping later
years <- floor(times)
years <- factor(years, ordered = TRUE)
# extract months by looking at time series cycle
cycle(times)        # 1 through 12 for each year

# store month abbreviations as factor
months <- factor(
  month.abb[cycle(times)],
  levels = month.abb,
  ordered = TRUE
)

# MOLTEN DATASET ######################

deaths <- data.frame(
  year   = years,
  month  = months,
  time   = as.numeric(times),
  DriversKilled  = as.numeric(Seatbelts[,"DriversKilled"]),
  Total_Drivers  = as.numeric(Seatbelts[,"drivers"]),
  Front_Seat  = as.numeric(Seatbelts[,"front"]),
  Rear_Seat  = as.numeric(Seatbelts[,"rear"]),
  kms  = as.numeric(Seatbelts[,"kms"]),
  PetrolPrice  = as.numeric(Seatbelts[,"PetrolPrice"]),
  VanKilled  = as.numeric(Seatbelts[,"VanKilled"]),
  law = as.numeric(Seatbelts[,"law"])
)


molten <- melt(
  deaths,
  id = c("year", "month", "time")
)


