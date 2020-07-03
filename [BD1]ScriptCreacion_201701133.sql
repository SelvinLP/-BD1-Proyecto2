#CREACION DE TABLAS

#TABLA PAIS
CREATE TABLE IF NOT EXISTS pais(
	id_pais INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
	nombre VARCHAR(100) NOT NULL
);

#TABLA REGION
CREATE TABLE IF NOT EXISTS region(
	id_region INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	nombre VARCHAR(100) NOT NULL
);

#TABLA DEPTO
CREATE TABLE IF NOT EXISTS depto(
	id_depto INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	nombre VARCHAR(100) NOT NULL,
    fk_id_region INTEGER,
    fk_id_pais INTEGER,
    FOREIGN KEY (fk_id_region) REFERENCES region(id_region),
    FOREIGN KEY (fk_id_pais) REFERENCES pais(id_pais)
);

#TABLA MUNICIPIO
CREATE TABLE IF NOT EXISTS municipio(
	id_municipio INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	nombre VARCHAR(100) NOT NULL,
    fk_id_depto INTEGER,
    FOREIGN KEY (fk_id_depto) REFERENCES depto(id_depto)
);

#TABLA PARTIDO
CREATE TABLE IF NOT EXISTS partido(
	id_partido INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	partido VARCHAR(100) NOT NULL UNIQUE,
	nombre_partido VARCHAR(100)
);

#TABLA RAZA
CREATE TABLE IF NOT EXISTS raza(
	id_raza INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	tipo VARCHAR(100) NOT NULL UNIQUE
);

#TABLA ELECCION
CREATE TABLE IF NOT EXISTS eleccion(
	id_eleccion INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	nombre VARCHAR(100) NOT NULL,
    año INTEGER NOT NULL CONSTRAINT vf_año CHECK (año>=1000)
);

#TABLA ELECCION_PARTIDO
CREATE TABLE IF NOT EXISTS eleccion_partido(
	id_eleccion_partido INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	fk_id_eleccion INTEGER,
    fk_id_partido INTEGER,
    FOREIGN KEY (fk_id_eleccion) REFERENCES eleccion(id_eleccion),
    FOREIGN KEY (fk_id_partido) REFERENCES partido(id_partido)
);

#TABLA ZONA
CREATE TABLE IF NOT EXISTS zona(
	id_zona INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	fk_pais INTEGER,
    fk_region VARCHAR(100),
    fk_depto VARCHAR(100),
    fk_municipio VARCHAR(100),
    FOREIGN KEY (fk_pais) REFERENCES pais(id_pais)
);

#TABLA VOTO
CREATE TABLE IF NOT EXISTS voto(
	id_voto INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	genero VARCHAR(100) CONSTRAINT vf_genero CHECK (genero IN('mujeres','hombres')),
    analfabetos INTEGER NOT NULL CONSTRAINT vf_analfa CHECK (analfabetos>=0),
    alfabetos INTEGER NOT NULL CONSTRAINT vf_alfa CHECK (alfabetos>=0),
    primaria INTEGER NOT NULL CONSTRAINT vf_primaria CHECK (primaria>=0),
    nivel_medio INTEGER NOT NULL CONSTRAINT vf_medio CHECK (nivel_medio>=0),
    universitarios INTEGER NOT NULL CONSTRAINT vf_uni CHECK (universitarios>=0),
    fk_id_raza INTEGER,
    fk_id_zona INTEGER,
    fk_id_eleccion_partido INTEGER,
    FOREIGN KEY (fk_id_raza) REFERENCES raza(id_raza),
    FOREIGN KEY (fk_id_zona) REFERENCES zona(id_zona),
    FOREIGN KEY (fk_id_eleccion_partido) REFERENCES eleccion_partido(id_eleccion_partido)
);

#Eliminando Tablas
DROP TABLE voto;
DROP TABLE zona;
DROP TABLE municipio;
DROP TABLE depto;
DROP TABLE pais;
DROP TABLE region;
DROP TABLE eleccion_partido;
DROP TABLE partido;
DROP TABLE eleccion;
DROP TABLE raza;



