#CONTADORES
SELECT COUNT(*) FROM voto;
SELECT COUNT(*) FROM partido;
SELECT COUNT(*) FROM (
	SELECT DISTINCT nombre
	FROM municipio
) as n;
SELECT COUNT(*) FROM (
	SELECT DISTINCT nombre
	FROM depto
) as n;
SELECT COUNT(*) FROM (
	SELECT DISTINCT (CAST(nombre AS CHAR CHARACTER SET utf8) COLLATE utf8_bin)
	FROM region
) as n;
SELECT COUNT(*) FROM pais;
SELECT COUNT(*) FROM eleccion;
SELECT COUNT(*) FROM raza;