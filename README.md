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
│   └── collage_graficos.png
├── scripts/
│   └── EDA.R
└── README.md
```

## Cómo ejecutar

1. Abrir el proyecto en RStudio con la carpeta `Proyecto_Final` como directorio
   de trabajo.
2. Ejecutar `scripts/EDA.R`. El script importa los datos, los limpia, calcula
   las estadísticas descriptivas y genera el collage en `figures/`.

## Principales hallazgos del EDA

- El precio promedio del periodo fue de **324.6 ¢US$/lb**, con una variación
  amplia (mínimo de 139.7 en diciembre de 2008 y máximo de 464.4 en marzo de
  2022).
- Se observa la fuerte caída de 2008-2009 asociada a la crisis financiera
  internacional, y una recuperación posterior.
- Desde 2021 el precio se mantiene en niveles altos, cerrando 2024 con un
  promedio anual de 415 ¢US$/lb.
