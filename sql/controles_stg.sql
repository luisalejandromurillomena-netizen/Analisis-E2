SELECT '1 filas en el bruto' AS control, COUNT(*) AS valor FROM bruto.s65h_7665
UNION ALL SELECT '2 filas en el staging', COUNT(*) FROM staging.stg_s65h_7665
UNION ALL SELECT '3 municipios en el bruto', COUNT(DISTINCT municipio_del_hecho_dane) FROM bruto.s65h_7665
UNION ALL SELECT '4 municipios en el staging', COUNT(DISTINCT municipio) FROM staging.stg_s65h_7665
UNION ALL SELECT '5 anio sin convertir', COUNTIF(anio IS NULL) FROM staging.stg_s65h_7665
UNION ALL SELECT '6 mes sin convertir', COUNTIF(mes_num IS NULL) FROM staging.stg_s65h_7665
UNION ALL SELECT '7 hora nula', COUNTIF(rango_hora IS NULL) FROM staging.stg_s65h_7665
UNION ALL SELECT '8 condicion nula', COUNTIF(condicion_victima IS NULL) FROM staging.stg_s65h_7665
UNION ALL SELECT '9 medio de transporte nulo', COUNTIF(medio_transporte IS NULL) FROM staging.stg_s65h_7665
ORDER BY control;