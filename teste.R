# Carregar as bibliotecas necessárias
library(readxl)
library(lubridate)
library(dplyr)
library(stats)
library(echarts4r)

# Ler arquivo de dados em formato xlsx e armazenar no dataset data
data = read_xlsx("app/view/combined_data.xlsx")    
data$Data <- as.Date(data$Data, format = "%Y-%m-%d")

# Agrupando os dados por data e somando as quantidades
daily_data <- aggregate(Quantidade ~ Data, data, sum)

# Decompondo a série temporal
decomposition <- stl(ts(daily_data$Quantidade, frequency = 7), s.window = "periodic")

# Criando um dataframe para os componentes da decomposição
decomp_df <- data.frame(
  Data = daily_data$Data,
  Trend = decomposition$time.series[, "trend"],
  Seasonal = decomposition$time.series[, "seasonal"],
  Residual = decomposition$time.series[, "remainder"]
)

# Plotando a Tendência
decomp_df %>%
  e_charts(Data) %>%
  e_line(Trend, name = "Tendência") %>%
  e_title("Tendência") %>%
  e_x_axis(type = "time") %>%
  e_tooltip(trigger = "axis") 


