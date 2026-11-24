Estadísticas de muertes viales en Colombia.

Equipo E2 · Análisis de Datos Intermedio · Estud-IA (Capa 2)

## Brief v1

| Campo | Respuesta |
|---|---|
| Usuario y decisión | Gerencia de Seguridad Vial de la Gobernación de Antioquia, decide la focalización de operativos de control vial (alcoholemia, velocidad, uso de casco), priorización de infraestructura segura (pasos peatonales, ilumicación, señalización) y diseño de campañas preventivas dirigidas a los actores más vulnerables. Cada cuanto: Estratégico/presupuestal (anual): para asignar recursos de infraestructura y planes locales de seguridad vial tras el cierre estadístico anual de Medicina Legal. |
| Pregunta | ¿Cuales son los perfiles demográficos, geográficos y circunstanciales más recurrentes en las muertes por eventos de transporte en Antioquia? |
| Fuente con API |[ Enlace al endpoint (…/resource/xxxx-xxxx.json)](https://www.datos.gov.co/resource/s65h-7665.json) |
| Qué representa una fila | Un registro individual consolidado de una muerte por evento de transporte en el país. |
| Campo que la identifica | id|
| Cada cuánto se actualiza |Anual. |
| Dato a confirmar |El año esta como texto, convertir formato |
| Tres indicadores | 1.Total de muertes por año y municipio· 2.Vulnerabilidad por condición de la víctima · 3.Índice de peligrosidad nocturna y de fin de semana |
| Terminó bien si… | Se logra consultar la API exitosamente, entender la estructura de las variables y utilizarlas para generar análisis claros sobre la siniestralidad vial. |
| No vamos a construir | Un sistema de monitore o alertas en tiempo real, un modelo predictivo de accidentes individuales o culpabilidad legal, un mapa exacto georreferenciado por dirección o intersección. |

## Contrato de datos

- Una fila es: Cada fila es un accidente. 
- La identifica: un id único. 
- Si llega una fila repetida: Debemos eliminarla porque sería un accidente suplicado. 
- Si falta un campo: Lo dejaremos en null. 

## Bitácora de decisiones

| Fecha | Decisión | Por qué |
|19/11/2026| Filtrar por Antioquia | Dado que el volumen de datos a nivel de Colombia es grande, entonces respondió a una cuestión de eficiencia |
| | | |

## Reglas del repositorio

- Es público: nada de datos personales, contraseñas, tokens ni llaves.
- Las credenciales van en un archivo `.env`, que Git ignora (ver `.gitignore`). `.env.example` muestra qué variables hacen falta, sin valores.
- Cada commit explica en su mensaje qué se decidió y por qué.

## Carga y staging

- **Tabla en bruto:** `bruto.s65h_7665` (9.756 filas, 43 columnas cargadas como texto desde Socrata).
- **Vista en staging:** `staging.stg_s65h_7665` (`sql/stg_s65h_7665.sql`).

### Cifras de control (`sql/controles_stg.sql`)

| Control | Bruto | Staging | ¿Es lo esperado? |
|---|---|---|---|
| Filas totales | 9.756 | 9.756 | Sí: el staging no filtra ni elimina filas |
| T1: Año del hecho sin convertir (`anio_hecho IS NULL`) | — | 0 | Sí: las 9.756 filas convirtieron `a_o_del_hecho` a entero (`INT64`) sin errores |
| T2: Valores distintos en medio de desplazamiento | 35 | 34 | Sí: T2 convirtió `'Sin información'` a `NULL` (1 categoría distinta menos) |

### Diccionario de columnas en `staging.stg_s65h_7665`

| Columna en el staging | Viene de (bruto) | Regla |
|---|---|---|
| `socrata_id` | `socrata_id` | Sin cambio (identificador de fila en Socrata) |
| `id` | `id` | Sin cambio |
| `a_o_del_hecho` | `a_o_del_hecho` | Sin cambio (se conserva el texto original) |
| `anio_hecho` | `a_o_del_hecho` | **T1:** texto a entero con `SAFE_CAST(TRIM(a_o_del_hecho) AS INT64)` |
| `codigo_dane_municipio` | `codigo_dane_municipio` | Sin cambio |
| `municipio_del_hecho_dane` | `municipio_del_hecho_dane` | Limpieza de espacios extremos con `TRIM(...)` |
| `departamento_del_hecho_dane` | `departamento_del_hecho_dane` | Sin cambio |
| `sexo_de_la_victima` | `sexo_de_la_victima` | Sin cambio |
| `condicion_de_la_victima_at` | `condicion_de_la_victima_at` | Sin cambio |
| `medio_transporte_limpio` | `medio_de_desplazamiento_o_transporte` | **T2:** `'Sin información'` pasa a `NULL` con `NULLIF(TRIM(...), 'Sin información')` |
| `clase_o_tipo_de_accidente_de_transporte` | `clase_o_tipo_de_accidente_de_transporte` | Sin cambio |
| `archivo_origen` | `archivo_origen` | Sin cambio (trazabilidad del archivo bruto) |
