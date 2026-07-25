# ============================================================
# Analisis final - Parte 2
# Tendencia y ciclos del precio del cobre (BCRP, 2007-2024)
#
# Pregunta de analisis:
# El precio del cobre, subio de forma sostenida entre 2007 y 2024,
# o su comportamiento responde mas a ciclos y shocks que a una
# tendencia lineal?
# ============================================================

library(dplyr)
library(ggplot2)

# Se reutiliza la base ya procesada en el EDA
cobre <- read.csv("data/cobre_procesado.csv", stringsAsFactors = FALSE)
cobre$fecha <- as.Date(cobre$fecha)

# Indice de tiempo continuo (anio con fraccion del mes) para medir la tendencia
cobre$tiempo <- cobre$anio + (cobre$mes_num - 1) / 12

# ---- Relacion entre el tiempo y el precio ----
correlacion <- cor(cobre$tiempo, cobre$precio)
modelo <- lm(precio ~ tiempo, data = cobre)
pendiente <- coef(modelo)[2]
r2 <- summary(modelo)$r.squared

cat("Correlacion tiempo-precio:", round(correlacion, 3), "\n")
cat("Pendiente estimada (cUS$/lb por anio):", round(pendiente, 2), "\n")
cat("R cuadrado del modelo lineal:", round(r2, 3), "\n\n")

# ---- Indicadores de crecimiento de punta a punta ----
prom_2007 <- mean(cobre$precio[cobre$anio == 2007])
prom_2024 <- mean(cobre$precio[cobre$anio == 2024])
crecimiento <- (prom_2024 / prom_2007 - 1) * 100

cat("Precio promedio 2007:", round(prom_2007, 1), "\n")
cat("Precio promedio 2024:", round(prom_2024, 1), "\n")
cat("Crecimiento acumulado 2007-2024 (%):", round(crecimiento, 1), "\n\n")

# ---- Volatilidad por anio (dispersion de la variacion mensual) ----
volatilidad <- cobre %>%
  filter(!is.na(var_mensual)) %>%
  group_by(anio) %>%
  summarise(volatilidad = round(sd(var_mensual), 2), .groups = "drop") %>%
  arrange(desc(volatilidad))

cat("Anios con mayor volatilidad mensual:\n")
print(head(volatilidad, 5))

# ---- Grafico final para difusion ----
azul    <- "#1f4e79"
naranja <- "#e07b39"

# Puntos clave: minimo (crisis 2008) y maximo (2022) del periodo
p_min <- cobre[which.min(cobre$precio), ]
p_max <- cobre[which.max(cobre$precio), ]

grafico_final <- ggplot(cobre, aes(x = fecha, y = precio)) +
  geom_line(color = azul, linewidth = 0.6) +
  geom_smooth(method = "lm", se = FALSE, color = naranja,
              linetype = "dashed", linewidth = 0.9) +
  geom_point(data = rbind(p_min, p_max), color = "#b3282d", size = 2.2) +
  annotate("text", x = p_min$fecha, y = p_min$precio - 22,
           label = "Crisis 2008-2009", size = 3.3, color = "#b3282d") +
  annotate("text", x = p_max$fecha, y = p_max$precio + 20,
           label = "Maximo (mar-2022)", size = 3.3, color = "#b3282d") +
  scale_x_date(date_breaks = "2 years", date_labels = "%Y") +
  labs(
    title = "El precio del cobre subio, pero no en linea recta",
    subtitle = "Cotizacion mensual LME 2007-2024: alza neta de 28% dominada por ciclos y shocks",
    x = "Anio", y = "cUS$ por libra",
    caption = "Fuente: BCRP, serie PN01652XM"
  ) +
  theme_minimal(base_size = 12)

ggsave("figures/grafico_final.png", grafico_final,
       width = 10, height = 6, dpi = 300, bg = "white")
