

emae_mensual <- read_csv("data/emae-valores-anuales-indice-base-2004-mensual.csv")

# Extrae el año
emae_mensual$indice_tiempo <- as.Date(emae_mensual$indice_tiempo, format = "%Y-%m-%d") 
emae_mensual$year <- year(emae_mensual$indice_tiempo)
emae_mensual$periodo <- format(emae_mensual$indice_tiempo, "%Y-%m")
# Filtro de 2010 a 2020
emae_mensual <-  emae_mensual %>%
  filter(year >= 2010 & year <= 2020)
emae_mensual$year_factor <- as.factor(emae_mensual$year)


# Me guardo   segundo semestre 2020 para predecir
values_to_predict <- tail(emae_mensual$emae_original, 12)
emae_mensual <- head(emae_mensual, 120)

# convierto a ts object
emae_mensual_ts <- emae_mensual %>%
  mutate(periodo = yearmonth(periodo)) %>%  
  as_tsibble(index = periodo)

########################## plots #######################################
#emae_mensual %>% autoplot(emae_original)

ggplot(emae_mensual_ts, aes(x = indice_tiempo, y = emae_original)) + 
  geom_line() +
  labs(title = "Serie de Tiempo EMAE (2010-2020)", x = "Fecha", y = "Valor") +
  theme_minimal()

ggplot(emae_mensual_ts, aes(x = year_factor, y = emae_original)) +
  geom_boxplot() +
  labs(title = "Boxplot de Valores por Año (2010-2020)", x = "Año", y = "EMAE") +
  theme_minimal() # no tiene variancia constante


emae_mensual_ts %>% 
  gg_tsdisplay(difference(emae_original, 12), 
               plot_type='partial',
               lag=36)

emae_mensual_ts %>% 
  gg_tsdisplay(difference(emae_original, 12) %>%  difference(),
               plot_type='partial', 
               lag=36)

fit <- emae_mensual_ts %>% 
  model( auto = ARIMA(emae_original, stepwise = FALSE, approx = FALSE))
fit

fit %>% gg_tsresiduals(lag=36)

### Test residuo

augment(fit) |>
  filter(.model == "auto") |>
  features(.innov, ljung_box, lag=24, dof=2)


### Propongo transformaciones
boxcox(lm(data = emae_mensual_ts, emae_original ~ 1), plotit = T, lambda = seq(-4, 4, by = 0.5))
# lamba 0 entones og(y)

emae_mensual_ts$log_y <- log(emae_mensual_ts$emae_original)

ggplot(emae_mensual_ts, aes(x = indice_tiempo, y = log_y)) + 
  geom_line() +
  labs(title = "Serie de Tiempo EMAE (2010-2020)", x = "Fecha", y = "Valor") +
  theme_minimal()
ggplot(emae_mensual_ts, aes(x = year_factor, y = log_y)) +
  geom_boxplot() +
  labs(title = "Boxplot de Valores por Año (2010-2020)", x = "Año", y = "EMAE") +
  theme_minimal() # no tiene variancia constante


emae_mensual_ts %>% 
  gg_tsdisplay(difference(log_y, 12), 
               plot_type='partial',
               lag=36)

emae_mensual_ts %>% 
  gg_tsdisplay(difference(log_y, 12) %>%  difference(),
               plot_type='partial', 
               lag=36)


log_fit %>% gg_tsresiduals(lag=36)

# proponer ARIMA(0,1,0)(0,1,2)[12]
# ARIMA(1,0,0)(2,1,2)[12]

log_fit <- emae_mensual_ts %>% 
  model( auto = ARIMA(log_y, stepwise = FALSE, approx = FALSE),
         auto_2 = ARIMA(log_y, stepwise = TRUE, approx = TRUE),
         arima010 = ARIMA(log_y ~ pdq(0,1,0) + PDQ(0,1,2)))

log_fit |> pivot_longer(everything(), names_to = "Model name",
                    values_to = "Orders")

glance(log_fit)

fit_select <- emae_mensual_ts %>% 
  model( auto = ARIMA(log_y, stepwise = FALSE, approx = FALSE))
fit_select |>  gg_tsresiduals(lag=36)

### Test residuo

augment(fit_select) |>
  features(.innov, ljung_box, lag=24, dof=4)

## Predict
forecast(log_fit, h=12) |>
  filter(.model=='auto') |>
  autoplot(emae_mensual_ts) +
  labs(title = "log-EMAE predicho para 2021",
       y="log()")



#################################################################3
####################### INDEC ###################################
library(seasonal)
ajuste_x13 <- emae_mensual_ts %>% seas(as_time(emae_original))