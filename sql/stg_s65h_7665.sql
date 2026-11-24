-- Staging de s65h_7665
-- Origen: bruto.s65h_7665, cargado tal como llegó (todo texto).
-- T1: Año del hecho de texto a número entero (SAFE_CAST). Ejemplo: "2015" -> 2015.
-- T2: Convertir 'Sin información' en medio_de_desplazamiento_o_transporte a NULL.
CREATE OR REPLACE VIEW staging.stg_s65h_7665 AS
SELECT
  socrata_id,
  id,
  a_o_del_hecho,
  SAFE_CAST(TRIM(a_o_del_hecho) AS INT64) AS anio_hecho, -- T1
  codigo_dane_municipio,
  TRIM(municipio_del_hecho_dane) AS municipio_del_hecho_dane,
  departamento_del_hecho_dane,
  sexo_de_la_victima,
  condicion_de_la_victima_at,
  NULLIF(TRIM(medio_de_desplazamiento_o_transporte), 'Sin información') AS medio_transporte_limpio, -- T2
  clase_o_tipo_de_accidente_de_transporte,
  archivo_origen
FROM bruto.s65h_7665;