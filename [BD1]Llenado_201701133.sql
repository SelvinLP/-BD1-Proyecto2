#LLENADO DE TABLAS 

#TABLA PAIS
INSERT INTO pais (nombre)
SELECT DISTINCT pais
FROM temporal;

#TABLA REGION
INSERT INTO region (nombre)
SELECT DISTINCT region
FROM temporal;

#TABLA DEPARTAMENTO
INSERT INTO depto (nombre,fk_id_pais,fk_id_region)
SELECT DISTINCT depto,pais.id_pais,region.id_region
FROM temporal
INNER JOIN pais ON pais.nombre=temporal.pais
INNER JOIN region ON region.nombre=temporal.region;

#TABLA MUNICIPIO
INSERT INTO municipio (nombre, fk_id_depto)
SELECT DISTINCT municipio,id_depto
FROM temporal
INNER JOIN depto ON depto.nombre=temporal.depto;

#TABLA PARTIDO
INSERT INTO partido (partido,nombre_partido)
SELECT DISTINCT partido, nombre_partido 
FROM temporal;

#TABLA RAZA
INSERT INTO raza (tipo)
SELECT DISTINCT raza
FROM temporal;

#TABLA ELECCION
INSERT INTO eleccion (nombre,año)
SELECT DISTINCT nombre_eleccion,anio_eleccion
FROM temporal;

#TABLA ELECCION_PARTIDO
INSERT INTO eleccion_partido (fk_id_eleccion,fk_id_partido)
SELECT DISTINCT eleccion.id_eleccion, partido.id_partido
FROM temporal
INNER JOIN eleccion ON temporal.nombre_eleccion=eleccion.nombre
INNER JOIN partido ON temporal.partido=partido.partido;

#TABLA ZONA
INSERT INTO zona(fk_pais,fk_region,fk_depto,fk_municipio)
SELECT DISTINCT pais.id_pais,region,depto,municipio
FROM temporal
INNER JOIN pais ON temporal.pais=pais.nombre;

#TABLA VOTO
INSERT INTO voto (genero,analfabetos,alfabetos,primaria,nivel_medio,universitarios,fk_id_raza,fk_id_zona,fk_id_eleccion_partido)
SELECT DISTINCT sexo,analfabetos,alfabetos,primaria,nivel_medio,universitarios,raza.id_raza,zona.id_zona,eleccion_partido.id_eleccion_partido
FROM temporal
INNER JOIN raza ON raza.tipo=temporal.raza

INNER JOIN eleccion ON (temporal.nombre_eleccion=eleccion.nombre AND eleccion.año=temporal.anio_eleccion)
INNER JOIN partido ON temporal.partido=partido.partido
INNER JOIN eleccion_partido ON (eleccion.id_eleccion=eleccion_partido.fk_id_eleccion AND partido.id_partido=eleccion_partido.fk_id_partido)

INNER JOIN pais ON temporal.pais=pais.nombre
INNER JOIN zona ON zona.fk_pais=pais.id_pais AND zona.fk_region=temporal.region 
AND zona.fk_depto=temporal.depto AND zona.fk_municipio=temporal.municipio;
