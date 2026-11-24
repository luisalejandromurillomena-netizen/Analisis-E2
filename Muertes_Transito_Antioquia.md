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
|---|---|---|
| | | |

## Reglas del repositorio

- Es público: nada de datos personales, contraseñas, tokens ni llaves.
- Las credenciales van en un archivo `.env`, que Git ignora (ver `.gitignore`). `.env.example` muestra qué variables hacen falta, sin valores.
- Cada commit explica en su mensaje qué se decidió y por qué.
