-- Staging de s65h_7665 (muertes por transporte, Antioquia)
-- Origen: bruto.s65h_7665, todo texto. Una fila = una víctima (no un accidente).
-- Una fila del staging = una fila del bruto: no se quita ninguna.
-- T1 Tipos: año y id a entero, mes a número 1-12, código DANE a 5 dígitos.
-- T2 Catálogo: un municipio con dos nombres (Itagui/Itagüí) queda con uno, según su código.
-- T3 «Sin información», en cualquier mayúscula, pasa a nulo.
-- T4 Día y hora en un solo formato (minúsculas, sin paréntesis).
CREATE OR REPLACE VIEW staging.stg_s65h_7665 AS
SELECT
  socrata_id AS id_fila,
  SAFE_CAST(id AS INT64) AS id_caso,                                          -- T1
  SAFE_CAST(TRIM(a_o_del_hecho) AS INT64) AS anio,                            -- T1
  CASE LOWER(TRIM(mes_del_hecho))                                             -- T1
    WHEN 'enero' THEN 1 WHEN 'febrero' THEN 2 WHEN 'marzo' THEN 3
    WHEN 'abril' THEN 4 WHEN 'mayo' THEN 5 WHEN 'junio' THEN 6
    WHEN 'julio' THEN 7 WHEN 'agosto' THEN 8 WHEN 'septiembre' THEN 9
    WHEN 'octubre' THEN 10 WHEN 'noviembre' THEN 11 WHEN 'diciembre' THEN 12
  END AS mes_num,
  IF(LOWER(TRIM(dia_del_hecho)) = 'sin información', NULL,
     LOWER(TRIM(dia_del_hecho))) AS dia_semana,                               -- T3, T4
  IF(LOWER(TRIM(rango_de_hora_del_hecho_x_3_horas)) = 'sin información', NULL,
     REPLACE(REPLACE(LOWER(TRIM(rango_de_hora_del_hecho_x_3_horas)), '(', ''), ')', '')
  ) AS rango_hora,                                                            -- T3, T4
  LPAD(TRIM(codigo_dane_municipio), 5, '0') AS cod_municipio,                 -- T1
  MAX(TRIM(municipio_del_hecho_dane))
    OVER (PARTITION BY codigo_dane_municipio) AS municipio,                   -- T2
  sexo_de_la_victima AS sexo,
  ciclo_vital,
  grupo_de_edad_quinquenal AS grupo_edad,
  IF(LOWER(TRIM(condicion_de_la_victima_at)) = 'sin información', NULL,
     TRIM(condicion_de_la_victima_at)) AS condicion_victima,                  -- T3
  IF(LOWER(TRIM(medio_de_desplazamiento_o_transporte)) = 'sin información', NULL,
     TRIM(medio_de_desplazamiento_o_transporte)) AS medio_transporte,         -- T3
  IF(LOWER(TRIM(clase_o_tipo_de_accidente_de_transporte)) = 'sin información', NULL,
     TRIM(clase_o_tipo_de_accidente_de_transporte)) AS clase_accidente,       -- T3
  IF(LOWER(TRIM(zona_del_hecho)) = 'sin información', NULL,
     REPLACE(TRIM(zona_del_hecho), 'poblado(', 'poblado (')) AS zona,         -- T3
  archivo_origen
FROM bruto.s65h_7665;