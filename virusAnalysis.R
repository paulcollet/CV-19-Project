library(ggplot2)

# applies to all graphs
total_df <- read.csv("https://covid.ourworldindata.org/data/owid-covid-data.csv", header=TRUE)
total_df$date<-as.Date(as.character(total_df$date), "%Y-%m-%d")
caption<-str_replace_all(toString(c("https://ourworldindata.org -", format(Sys.Date(), format="%m/%d/%y"))), ",", "")

# Testing Ratio
top_10 <- c("United States", "Italy", "Spain", "Germany", "China", "France", "Iran", "United Kingdom", "Switzerland", "Turkey")
total_df <- subset(total_df, total_df$location%in%top_10)
total_df <- subset(total_df, total_df$date > "2020-02-26")

req_columns <- c("location", "date", "total_cases", "total_tests")
test_ratios <- subset(total_df[req_columns], total_df$total_tests > 0)
test_ratios["ratio"] <- round(test_ratios$total_cases/test_ratios$total_tests * 100, 2)

countries<- c(str_split(unique(test_ratios$location), ","))

for (country in countries)
{
  test_ratios[,country] <- ""
}

for (row in 1:nrow(test_ratios))
{
  test_ratios[row, paste(test_ratios[row, "location"])] <- test_ratios[row, "ratio"]
}
test_ratios <- select(test_ratios,-c("location", "total_cases", "total_tests", "ratio"))

write.csv(test_ratios, "TestRatios.csv", row.names = FALSE)

#ggplot(test_ratios, aes(y = test_ratios$ratio, x = test_ratios$date)) + 
#  labs(title="Percentage of Positive Cases Over Time", y = "Test (Pos/Total) in %", x = "", caption = caption)

#ggsave("virus_ratios.png", units="in", width=10, height=5, dpi=300)