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

- Tabla en bruto: `bruto.s65h_7665` (9.756 filas, 43 columnas cargadas como texto desde Socrata).
- Vista en staging: `staging.stg_s65h_7665` (`sql/stg_s65h_7665.sql`).
- Una fila = una víctima (no un accidente: la fuente no trae identificador de accidente).
- El bruto trae todas las condiciones de la víctima (conductor, peatón, pasajero), no solo peatones.

### Reglas

- T1 Tipos: año e id a entero, mes de texto a número 1-12, código DANE a 5 dígitos.
- T2 Catálogo: 9 municipios tenían dos nombres (ej. Itagui/Itagüí); queda uno por código.
- T3 «Sin información», en cualquier mayúscula, pasa a nulo.
- T4 Día y hora en un solo formato (minúsculas, sin paréntesis).

### Cifras de control (`sql/controles_stg.sql`)

| Control | Bruto | Staging | ¿Es lo esperado? |
|---|---|---|---|---|
| Filas | 9.756 | 9.756 | Sí: el staging no quita filas |
| Municipios distintos (T2) | 131 | 122 | Sí: coincide con los 122 códigos DANE distintos |
| Año sin convertir (T1) | — | 0 | Sí: los 10 años (2015-2024) son numéricos |
| Mes sin convertir (T1) | — | 1 | Sí: 1 fila traía «Sin información» |
| Hora nula (T3) | — | 3.398 | Sí: filas que decían «Sin información» (34,8 %) |
| Condición de la víctima nula (T3) | — | 404 | Sí: filas que decían «Sin información» |
| Medio de transporte nulo (T3) | — | 414 | Sí: filas que decían «Sin información» |

### Decisiones

- No se pasan al staging las columnas con un solo valor (departamento, manera de muerte, localidad) ni las de orientación sexual, identidad de género y pueblo indígena: «No había sido implementada» en todas las filas 2015-2021 significa que no se preguntaba, no que se desconoce.
- «No aplica» se conserva: dice algo distinto a «no sé».

### Diccionario de columnas

| Columna en el staging | Viene de (bruto) | Regla |
|---|---|---|
| `id_fila` | `socrata_id` | Sin cambio |
| `id_caso` | `id` | T1: texto a entero |
| `anio` | `a_o_del_hecho` | T1: texto a entero |
| `mes_num` | `mes_del_hecho` | T1: nombre del mes a número |
| `dia_semana` | `dia_del_hecho` | T3, T4 |
| `rango_hora` | `rango_de_hora_del_hecho_x_3_horas` | T3, T4 |
| `cod_municipio` | `codigo_dane_municipio` | T1: completa a 5 dígitos |
| `municipio` | `municipio_del_hecho_dane` | T2: un nombre por código |
| `sexo` | `sexo_de_la_victima` | Sin cambio |
| `ciclo_vital` | `ciclo_vital` | Sin cambio |
| `grupo_edad` | `grupo_de_edad_quinquenal` | Sin cambio |
| `condicion_victima` | `condicion_de_la_victima_at` | T3 |
| `medio_transporte` | `medio_de_desplazamiento_o_transporte` | T3 |
| `clase_accidente` | `clase_o_tipo_de_accidente_de_transporte` | Sin cambio |
| `zona` | `zona_del_hecho` | T3 |
| `archivo_origen` | `archivo_origen` | Sin cambio (trazabilidad) |

## Mi consulta en 3 respuestas (S4)
Consulta: sql/stg_s65h_7665.sql
1. ¿Por qué en los controles de staging aparecen 9.756 filas tanto en bruto como en staging y 0 registros sin convertir en `anio`?
Respuesta: Porque la capa de staging estandariza y limpia sin filtrar ni eliminar registros, conservando las 9.756 filas originales. Que `anio` tenga 0 registros sin convertir indica que las 10 anualidades (2015-2024) en `a_o_del_hecho` son numéricas y pasaron a entero sin fallos, mientras que en `mes_num` queda 1 registro sin convertir porque venía como «Sin información».
2. ¿Por qué se aplicó la regla T3 para pasar «Sin información» a nulo en columnas como `medio_transporte` (414 nulos), `condicion_victima` (404 nulos) y `rango_hora` (3.398 nulos)?
Respuesta: Porque «Sin información» (en cualquier mayúscula) indica ausencia o desconocimiento del dato, no una categoría válida. Convertir esos casos a nulo evita inflar categorías falsas y permite identificar con precisión los faltantes reales en SQL (`medio_transporte` con 414 nulos, `condicion_victima` con 404 y `rango_hora` con 3.398, equivalentes al 34,8 % del total).
3. ¿Qué pasaría si quitamos la regla T1 o si en una próxima carga llegan valores no numéricos en `a_o_del_hecho` o `id`?
Respuesta: Si quitamos T1, campos como `anio`, `id_caso` y `mes_num` quedarían en formatos menos limpios o inconsistentes para ordenar, cruzar o filtrar, y los códigos municipales no quedarían estandarizados a 5 dígitos. Si en una futura carga llegan valores no numéricos en un campo entero, la conversión segura evita que todo el proceso falle y deja esos casos visibles para revisarlos en los controles.