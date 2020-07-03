#CONSULTAS

#CONSULTA 1:Desplegar para cada elección el país y el partido político que obtuvo mayor porcentaje de votos en su país. 
#Debe desplegar el nombre de la elección, el año de la elección, el país, el nombre del partido político y el porcentaje 
#que obtuvo de votos en su país.
SELECT DISTINCT datos.eleccion,datos.año,datos.pais,datos.nombre,MAX((datos.semisum/total.totalsum)*100) AS 'Porcentaje(%)'
FROM (
	SELECT eleccion.nombre as eleccion,eleccion.año as año,pais.nombre as pais,partido.nombre_partido as nombre, SUM(voto.alfabetos+voto.analfabetos) as semisum
	FROM eleccion_partido
	INNER JOIN eleccion ON eleccion.id_eleccion=eleccion_partido.fk_id_eleccion 
	INNER JOIN partido ON partido.id_partido=eleccion_partido.fk_id_partido
	INNER JOIN voto ON voto.fk_id_eleccion_partido=eleccion_partido.id_eleccion_partido
	INNER JOIN zona ON zona.id_zona=voto.fk_id_zona
	INNER JOIN pais ON pais.id_pais=zona.fk_pais
	GROUP BY eleccion.nombre,eleccion.año,pais.nombre,partido.nombre_partido
)AS datos,(
	SELECT pais.nombre as codepais, SUM(voto.analfabetos+voto.alfabetos) as totalsum
	FROM voto
	INNER JOIN zona ON zona.id_zona=voto.fk_id_zona
	INNER JOIN pais ON pais.id_pais=zona.fk_pais
	GROUP BY zona.fk_pais
)as total
WHERE total.codepais=datos.pais
GROUP BY datos.pais;

#CONSULTA 2: Desplegar total de votos y porcentaje de votos de mujeres por departamento y país. 
#El ciento por ciento es el total de votos de mujeres por país. (Tip: Todos los porcentajes por departamento de un 
#país deben sumar el 100%)
SELECT subtotal.pais,total.sumatot as 'Total Pais',subtotal.depto,subtotal.semisum as 'Total Depto',(subtotal.semisum/total.sumatot)*100 as 'Porcentaje(%)'
FROM (
	SELECT pais.nombre as pais,zona.fk_depto as depto,SUM(voto.alfabetos+voto.analfabetos) as semisum
	FROM voto
	INNER JOIN zona ON zona.id_zona=voto.fk_id_zona
	INNER JOIN pais ON pais.id_pais=zona.fk_pais
	WHERE voto.genero='mujeres'
	GROUP BY pais.nombre,zona.fk_depto
) as subtotal,(
	SELECT pais.nombre as paist,SUM(voto.alfabetos+voto.analfabetos) as sumatot
	FROM voto
	INNER JOIN zona ON zona.id_zona=voto.fk_id_zona
	INNER JOIN pais ON pais.id_pais=zona.fk_pais
	WHERE voto.genero='mujeres'
	GROUP BY pais.nombre
)as total
WHERE total.paist=subtotal.pais;

#CONSULTA 3:Desplegar el nombre del país, nombre del partido político y número de alcaldías de los partidos políticos
#que ganaron más alcaldías por país.
SELECT casitotal.pais, casitotal.part,MAX(casitotal.cantidad)
FROM(
	SELECT paracontar.pais as pais,nombres.pat as part,COUNT(paracontar.muni) as cantidad
	FROM(
		SELECT sumas.nm as pais,sumas.muni as muni,MAX(sumas.semsum) as maximo
		FROM (
			SELECT pais.nombre as nm,zona.fk_municipio as muni,partido.partido as pat, SUM(voto.alfabetos+voto.analfabetos) as semsum
			FROM voto
			INNER JOIN eleccion_partido ON eleccion_partido.id_eleccion_partido=voto.fk_id_eleccion_partido
			INNER JOIN partido ON partido.id_partido=eleccion_partido.fk_id_partido
			INNER JOIN zona ON zona.id_zona=voto.fk_id_zona
			INNER JOIN pais ON pais.id_pais=zona.fk_pais
			GROUP BY pais.nombre,zona.fk_municipio,partido.partido
		) as sumas
		GROUP BY sumas.nm,sumas.muni
	) as paracontar,(
		SELECT pais.nombre as nm,zona.fk_municipio as muni,partido.partido as pat, SUM(voto.alfabetos+voto.analfabetos) as semsum
		FROM voto
		INNER JOIN eleccion_partido ON eleccion_partido.id_eleccion_partido=voto.fk_id_eleccion_partido
		INNER JOIN partido ON partido.id_partido=eleccion_partido.fk_id_partido
		INNER JOIN zona ON zona.id_zona=voto.fk_id_zona
		INNER JOIN pais ON pais.id_pais=zona.fk_pais
		GROUP BY pais.nombre,zona.fk_municipio,partido.partido
	) as nombres
	WHERE nombres.nm=paracontar.pais AND nombres.muni=paracontar.muni AND nombres.semsum=paracontar.maximo
	GROUP BY  paracontar.pais,nombres.pat
) as casitotal
GROUP BY casitotal.pais;

#CONSULTA 4:Desplegar todas las regiones por país en las que predomina la raza indígena. 
#Es decir, hay más votos que las otras razas.
SELECT tmax.pais,tmax.region,indi.semsum
FROM (
	SELECT smax.pais as pais, smax.region as region, MAX(smax.semsum) as mx
	FROM (
		SELECT pais.nombre AS pais,zona.FK_region AS region,raza.tipo as raza, SUM(voto.alfabetos+voto.analfabetos) as semsum
		FROM voto
		INNER JOIN raza ON (raza.id_raza=voto.fk_id_raza)
		INNER JOIN zona ON zona.id_zona=voto.fk_id_zona
		INNER JOIN pais ON pais.id_pais=zona.fk_pais
		GROUP BY pais.nombre,zona.FK_region,raza.tipo
	)as smax
	GROUP BY smax.pais, smax.region
) as tmax,(
	SELECT pais.nombre AS pais,zona.FK_region AS region,raza.tipo as raza, SUM(voto.alfabetos+voto.analfabetos) as semsum
	FROM voto
	INNER JOIN raza ON (raza.id_raza=voto.fk_id_raza AND raza.tipo='INDIGENAS')
	INNER JOIN zona ON zona.id_zona=voto.fk_id_zona
	INNER JOIN pais ON pais.id_pais=zona.fk_pais
	GROUP BY pais.nombre,zona.FK_region,raza.tipo
) as indi
WHERE indi.pais=tmax.pais AND indi.region=tmax.region AND indi.semsum=tmax.mx;

#CONSULTA 5:Desplegar el nombre del país, el departamento, el municipio, el partido político y la cantidad de votos 
#universitarios de todos aquellos partidos políticos que obtuvieron una cantidad de votos de universitarios mayor 
#que el 25% de votos de primaria y menor que el 30% de votos de nivel medio (correspondiente a ese municipio y al 
#partido político).  Ordene sus resultados de mayor a menor.
SELECT total.pais,total.depto,total.muni,total.partido,total.univers
FROM (
	SELECT pais.nombre as pais ,zona.fk_depto as depto,zona.fk_municipio as muni,partido.nombre_partido as partido
    ,SUM(voto.universitarios) as univers,SUM(voto.primaria) as primaria,SUM(voto.nivel_medio) as medio
	FROM voto
	INNER JOIN zona ON zona.id_zona=voto.fk_id_zona
	INNER JOIN pais ON pais.id_pais=zona.fk_pais
	INNER JOIN eleccion_partido ON eleccion_partido.id_eleccion_partido=voto.fk_id_eleccion_partido
	INNER JOIN partido ON partido.id_partido=eleccion_partido.fk_id_partido
	GROUP BY pais.nombre,zona.fk_depto,zona.fk_municipio,partido.nombre_partido
)as total
WHERE total.univers/total.primaria>0.25 AND total.univers/total.medio<0.30
ORDER BY total.univers DESC;

#CONSULTA 6: Desplegar el porcentaje de mujeres universitarias y hombres universitarios que votaron por departamento,
#donde las mujeres universitarias que votaron fueron más que los hombres universitarios que votaron.
SELECT datos.pais,datos.depto,(datos.tuni/total.tsum)*100 AS 'Porcentaje Mujeres (%)'
FROM (
	SELECT pais.nombre as pais,zona.fk_depto as depto,voto.genero as genero, SUM(voto.universitarios) as tuni
	FROM voto
	INNER JOIN zona ON zona.id_zona=voto.fk_id_zona
	INNER JOIN pais ON pais.id_pais=zona.fk_pais
    GROUP BY pais.nombre,zona.fk_depto,voto.genero
)as datos,(
	SELECT pais.nombre as pais,zona.fk_depto as depto, SUM(voto.universitarios) as tsum
	FROM voto
	INNER JOIN zona ON zona.id_zona=voto.fk_id_zona
	INNER JOIN pais ON pais.id_pais=zona.fk_pais
    GROUP BY pais.nombre,zona.fk_depto
) as total
WHERE datos.genero='mujeres' AND datos.pais=total.pais AND datos.depto=total.depto AND datos.tuni/total.tsum>0.5;

#CONSULTA 7:Desplegar el nombre del país, la región y el promedio de votos por departamento. Por ejemplo: 
#si la región tiene tres departamentos, se debe sumar todos los votos de la región y dividirlo dentro de tres 
#(número de departamentos de la región).
SELECT total.pais,total.region, AVG(total.sm)
FROM (
	SELECT pais.nombre as pais ,zona.fk_region as region ,fk_depto as depto,SUM(voto.alfabetos+voto.analfabetos) AS sm
	FROM voto
	INNER JOIN zona ON zona.id_zona=voto.fk_id_zona
	INNER JOIN pais ON pais.id_pais=zona.fk_pais
	GROUP BY  pais.nombre,zona.fk_region,fk_depto
) as total
GROUP BY total.pais,total.region;

#CONSULTA 8:Desplegar el nombre del municipio y el nombre de los dos partidos políticos con más votos en el 
#municipio, ordenados por país.

#CONSULTA 9:Desplegar el total de votos de cada nivel de escolaridad (primario, medio, universitario) por país, 
#sin importar raza o sexo.
SELECT pais.nombre, SUM(voto.primaria),SUM(voto.nivel_medio),SUM(voto.universitarios)
FROM voto
INNER JOIN zona ON zona.id_zona=voto.fk_id_zona
INNER JOIN pais ON pais.id_pais=zona.fk_pais
GROUP BY pais.nombre;

#CONSULTA 10:Desplegar el nombre del país y el porcentaje de votos por raza.
SELECT datos.pais, datos.raza, (datos.sm/total.sm)*100 as 'Porcentaje (%)'
FROM (
	SELECT pais.nombre as pais ,raza.tipo as raza ,SUM(voto.alfabetos+voto.analfabetos) AS sm
	FROM voto
	INNER JOIN zona ON zona.id_zona=voto.fk_id_zona
	INNER JOIN pais ON pais.id_pais=zona.fk_pais
    INNER JOIN raza ON raza.id_raza=voto.fk_id_raza
    GROUP BY pais.nombre, raza.tipo
) as datos,(
	SELECT pais.nombre as pais ,SUM(voto.alfabetos+voto.analfabetos) AS sm
	FROM voto
	INNER JOIN zona ON zona.id_zona=voto.fk_id_zona
	INNER JOIN pais ON pais.id_pais=zona.fk_pais
    GROUP BY pais.nombre
) as total
WHERE datos.pais=total.pais
GROUP BY  datos.pais, datos.raza;

#CONSULTA 11:

