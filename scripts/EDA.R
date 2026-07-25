# ============================================================
# Analisis Exploratorio de Datos (EDA)
# Precio internacional del cobre - LME (centavos de US$ por libra)
# Fuente: BCRP, serie PN01652XM. Frecuencia mensual, 2007-2024
# ============================================================

library(readxl)
library(dplyr)
library(tidyr)
library(lubridate)
library(stringr)
library(ggplot2)
library(scales)
library(patchwork)

# ---- 1. Importacion de datos ----
# La hoja "Mensuales" trae dos filas de encabezado del BCRP (el codigo y la
# descripcion de la serie), por eso se omiten con skip = 2.
ruta <- "data/03_BCRP_PRECIO_COBRE_MENSUAL_2007_2024.xlsx"
cobre <- read_excel(ruta, sheet = "Mensuales", skip = 2, col_names = FALSE)
colnames(cobre) <- c("periodo", "precio")

# ---- 2. Limpieza y preparacion ----
# El periodo viene como texto pegado ("Ene07", "Feb07"...). Se separa el mes y
# el anio para construir una fecha real y poder ordenar y graficar la serie.
meses_es <- c(Ene = 1, Feb = 2, Mar = 3, Abr = 4, May = 5, Jun = 6,
              Jul = 7, Ago = 8, Sep = 9, Oct = 10, Nov = 11, Dic = 12)

cobre <- cobre %>%
  mutate(
    mes_abrev = str_sub(periodo, 1, 3),
    anio      = as.integer(paste0("20", str_sub(periodo, 4, 5))),
    mes_num   = as.integer(meses_es[mes_abrev]),
    fecha     = make_date(anio, mes_num, 1),
    precio    = as.numeric(precio)
  ) %>%
  arrange(fecha)

# Variables derivadas que se usaran en el analisis
cobre <- cobre %>%
  mutate(
    var_mensual = (precio / lag(precio) - 1) * 100,
    var_anual   = (precio / lag(precio, 12) - 1) * 100,
    media_movil = as.numeric(stats::filter(precio, rep(1 / 12, 12), sides = 1)),
    mes = factor(mes_abrev,
                 levels = c("Ene", "Feb", "Mar", "Abr", "May", "Jun",
                            "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"))
  )

# ---- 3. Estadisticas descriptivas ----
cat("Periodo analizado:", format(min(cobre$fecha)), "a",
    format(max(cobre$fecha)), "\n")
cat("Numero de observaciones:", nrow(cobre), "\n")
cat("Valores faltantes en precio:", sum(is.na(cobre$precio)), "\n\n")

print(summary(cobre$precio))
cat("\nDesviacion estandar:", round(sd(cobre$precio), 2), "\n")
cat("Coeficiente de variacion (%):",
    round(sd(cobre$precio) / mean(cobre$precio) * 100, 2), "\n\n")

# Mes con el precio minimo y maximo del periodo
min_row <- cobre %>% slice_min(precio, n = 1)
max_row <- cobre %>% slice_max(precio, n = 1)
cat("Precio minimo:", round(min_row$precio, 2), "en", format(min_row$fecha), "\n")
cat("Precio maximo:", round(max_row$precio, 2), "en", format(max_row$fecha), "\n\n")

# Promedio, minimo y maximo por anio
tabla_anual <- cobre %>%
  group_by(anio) %>%
  summarise(
    promedio = round(mean(precio), 2),
    minimo   = round(min(precio), 2),
    maximo   = round(max(precio), 2),
    .groups = "drop"
  )
print(tabla_anual, n = Inf)

# ---- 4. Visualizacion ----
azul    <- "#1f4e79"
naranja <- "#e07b39"

# Grafico 1: evolucion de la serie con su media movil de 12 meses
g1 <- ggplot(cobre, aes(x = fecha)) +
  geom_line(aes(y = precio, color = "Precio mensual"), linewidth = 0.6) +
  geom_line(aes(y = media_movil, color = "Media movil (12 meses)"),
            linewidth = 0.9, na.rm = TRUE) +
  scale_color_manual(values = c("Precio mensual" = azul,
                                "Media movil (12 meses)" = naranja)) +
  scale_x_date(date_breaks = "2 years", date_labels = "%Y") +
  labs(title = "Evolucion del precio internacional del cobre",
       subtitle = "Cotizacion mensual LME, 2007-2024",
       x = "Anio", y = "cUS$ por libra", color = NULL) +
  theme_minimal(base_size = 11) +
  theme(legend.position = "bottom")

# Grafico 2: precio promedio por anio
g2 <- ggplot(tabla_anual, aes(x = factor(anio), y = promedio)) +
  geom_col(fill = azul) +
  labs(title = "Precio promedio anual del cobre",
       subtitle = "Promedio de las cotizaciones mensuales de cada anio",
       x = "Anio", y = "cUS$ por libra") +
  theme_minimal(base_size = 11) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Grafico 3: distribucion de los precios mensuales
g3 <- ggplot(cobre, aes(x = precio)) +
  geom_histogram(bins = 20, fill = azul, color = "white") +
  geom_vline(xintercept = mean(cobre$precio), color = naranja,
             linetype = "dashed", linewidth = 0.8) +
  labs(title = "Distribucion del precio mensual",
       subtitle = "La linea punteada marca el promedio del periodo",
       x = "cUS$ por libra", y = "Frecuencia (meses)") +
  theme_minimal(base_size = 11)

# Grafico 4: comportamiento del precio segun el mes (estacionalidad)
g4 <- ggplot(cobre, aes(x = mes, y = precio)) +
  geom_boxplot(fill = azul, alpha = 0.7, outlier.size = 0.8) +
  labs(title = "Comportamiento del precio segun el mes",
       subtitle = "Distribucion de las cotizaciones por mes (2007-2024)",
       x = "Mes", y = "cUS$ por libra") +
  theme_minimal(base_size = 11)

# Se guarda cada grafico por separado
ggsave("figures/01_evolucion_precio.png", g1, width = 7, height = 4.5, dpi = 300, bg = "white")
ggsave("figures/02_promedio_anual.png",  g2, width = 7, height = 4.5, dpi = 300, bg = "white")
ggsave("figures/03_distribucion.png",    g3, width = 7, height = 4.5, dpi = 300, bg = "white")
ggsave("figures/04_estacionalidad.png",  g4, width = 7, height = 4.5, dpi = 300, bg = "white")

# Collage con los cuatro graficos
collage <- (g1 | g2) / (g3 | g4) +
  plot_annotation(
    title = "Analisis exploratorio del precio del cobre (BCRP, 2007-2024)",
    theme = theme(plot.title = element_text(size = 14, face = "bold"))
  )

ggsave("figures/collage_graficos.png", collage,
       width = 12, height = 8, dpi = 300, bg = "white")

# Base ya procesada para reutilizar en el analisis final
write.csv(cobre, "data/cobre_procesado.csv", row.names = FALSE)
