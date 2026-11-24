-- Cifras de control del staging: filas antes y despues, y efecto de T1 y T2.
SELECT '1 filas en el bruto' AS control, COUNT(*) AS valor
FROM `estudia-datos-515120.bruto.s65h_7665`
UNION ALL
SELECT '2 filas en el staging', COUNT(*)
FROM `estudia-datos-515120.staging.stg_s65h_7665`
UNION ALL
SELECT '3 T1: no convirtio anio_hecho', COUNTIF(anio_hecho IS NULL)
FROM `estudia-datos-515120.staging.stg_s65h_7665`
UNION ALL
SELECT '4 T2: valores distintos antes (bruto)', COUNT(DISTINCT medio_de_desplazamiento_o_transporte)
FROM `estudia-datos-515120.bruto.s65h_7665`
UNION ALL
SELECT '5 T2: valores distintos despues (staging)', COUNT(DISTINCT medio_transporte_limpio)
FROM `estudia-datos-515120.staging.stg_s65h_7665`
ORDER BY control;