# Análisis Exploratorio del Precio Internacional del Cobre (BCRP, 2007-2024)

Proyecto final del curso de Ofimática. Consiste en un análisis exploratorio de
datos (EDA) sobre la cotización mensual del cobre, elaborado en R.

## Contexto

Los datos provienen del **Banco Central de Reserva del Perú (BCRP)**,
serie estadística **PN01652XM**, publicada por el Departamento de Economía
Mundial. La serie corresponde a la categoría *Cotizaciones internacionales* y
registra el promedio mensual del precio del **cobre en la Bolsa de Metales de
Londres (LME)**, expresado en **centavos de dólar por libra (¢US$/lb)**.

El cobre es el principal producto de exportación del Perú, por lo que su
cotización internacional tiene un impacto directo en la economía nacional. Ese
es el motivo para explorar cómo ha evolucionado su precio a lo largo del tiempo.

## Datos

- **Fuente:** BCRP, serie PN01652XM
- **Frecuencia:** mensual
- **Periodo:** enero 2007 – diciembre 2024 (216 observaciones)
- **Unidad:** centavos de US$ por libra
- Sin valores faltantes y con los 12 meses completos en cada año.

Variables construidas a partir de la serie original:

| Variable | Descripción |
|----------|-------------|
| `fecha` | Fecha del registro (primer día de cada mes) |
| `anio`, `mes` | Año y mes de la observación |
| `precio` | Cotización mensual del cobre |
| `var_mensual` | Variación porcentual respecto al mes anterior |
| `var_anual` | Variación porcentual respecto al mismo mes del año previo |
| `media_movil` | Media móvil de 12 meses |

## Estructura del proyecto

```
Proyecto_Final/
├── data/
│   ├── 03_BCRP_PRECIO_COBRE_MENSUAL_2007_2024.xlsx
│   └── cobre_procesado.csv
├── figures/
│   ├── collage_graficos.png
│   └── grafico_final.png
├── scripts/
│   ├── EDA.R
│   └── 04_analisis_final.R
└── README.md
```

## Cómo ejecutar

1. Abrir el proyecto en RStudio con la carpeta `Proyecto_Final` como directorio
   de trabajo.
2. Ejecutar `scripts/EDA.R`. El script importa los datos, los limpia, calcula
   las estadísticas descriptivas y genera el collage en `figures/`.
3. Ejecutar `scripts/04_analisis_final.R` para reproducir el análisis final y el
   gráfico `figures/grafico_final.png`.

## Principales hallazgos del EDA

- El precio promedio del periodo fue de **324.6 ¢US$/lb**, con una variación
  amplia (mínimo de 139.7 en diciembre de 2008 y máximo de 464.4 en marzo de
  2022).
- Se observa la fuerte caída de 2008-2009 asociada a la crisis financiera
  internacional, y una recuperación posterior.
- Desde 2021 el precio se mantiene en niveles altos, cerrando 2024 con un
  promedio anual de 415 ¢US$/lb.

## Análisis final (Parte 2)

**Pregunta:** ¿El precio del cobre subió de forma sostenida entre 2007 y 2024, o
su comportamiento responde más a ciclos y shocks que a una tendencia lineal?

Para responderla se midió la relación entre el tiempo y el precio con la
correlación de Pearson y una regresión lineal simple (`precio ~ tiempo`), y se
calculó la volatilidad mensual de cada año. El script `scripts/04_analisis_final.R`
reutiliza la base procesada en el EDA y genera `figures/grafico_final.png`.

**Resultados:**

- La correlación entre el tiempo y el precio es débil (**0.275**), y el modelo
  lineal explica apenas el **7.5%** de la variación del precio (R² = 0.075).
- La pendiente estimada es de **+3.7 ¢US$/lb por año**.
- De punta a punta el precio creció **+28.1%** (promedio de 323.6 en 2007 frente a
  414.6 en 2024).
- El año más volátil fue **2008** (crisis financiera internacional), seguido de
  2007 y 2010.

**Conclusión:** el precio del cobre sí registró un alza neta en el periodo
(+28%), pero **no describe una tendencia lineal sostenida**. La baja capacidad
explicativa del modelo lineal y la alta volatilidad de años como 2008 muestran
que su dinámica está gobernada por **ciclos y shocks** —la caída de 2008-2009, el
retroceso de 2015-2016 y el fuerte repunte desde 2021— más que por un crecimiento
constante en el tiempo.
