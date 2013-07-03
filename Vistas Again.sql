DROP FUNCTION IF EXISTS equipo_nombre;
DROP FUNCTION IF EXISTS ganador_nombre;
DROP PROCEDURE IF EXISTS ver_goles_por_partido;
DROP VIEW IF EXISTS vista_partidos;
DROP VIEW IF EXISTS tabla_de_posiciones;
DROP VIEW IF EXISTS goles_por_partido;



DELIMITER $
CREATE FUNCTION ganador_nombre( equipo_local VARCHAR(45), equipo_visitante VARCHAR(45),
						 goles_local INT, goles_visitante INT )
						 RETURNS VARCHAR(45)
BEGIN
	IF goles_local > goles_visitante THEN
		RETURN equipo_local;
	ELSEIF goles_visitante > goles_local THEN
		RETURN equipo_visitante;
	ELSE
		RETURN 'Empate';
	END IF;
END
$
DELIMITER ;

DELIMITER $
CREATE FUNCTION equipo_nombre( id_equipo_requerido INT )
						 RETURNS VARCHAR(45)
BEGIN
	RETURN (SELECT nombre_equipo FROM equipo WHERE id_equipo = id_equipo_requerido);
END
$
DELIMITER ;

-- ----------------------------
-- Muestra todos los partidos
-- ----------------------------

DROP VIEW IF EXISTS vista_partidos;
CREATE VIEW vista_partidos( fecha_partido, equipo_local, equipo_visitante, 
							goles_local, goles_visitante, ganador, año, semestre ) 
AS 
	SELECT fecha_partido, 
		   equipo_nombre(id_local), 
		   equipo_nombre(id_visitante),
		   goles_local, 
		   goles_visitante,
		   ganador_nombre( equipo_nombre(id_local),equipo_nombre(id_visitante),
					goles_local, goles_visitante),
		   año, 
		   semestre	
	FROM partido NATURAL JOIN campeonato;

-- ------------------------------------------
-- Muestra la tabla de posiciones
-- ------------------------------------------

CREATE VIEW tabla_de_posiciones( posicion, nombre_equipo, puntaje, 
								 goles_favor, goles_contra, año, semestre )
AS
	SELECT pos, nombre_equipo, puntaje, goles_favor, goles_contra, año, semestre 
	FROM posicion NATURAL JOIN equipo NATURAL JOIN campeonato ORDER BY pos ASC; 


DROP VIEW IF EXISTS goles_por_partido;
CREATE VIEW goles_por_partido( nombre_jugador, apellido_jugador, goles, 
							   equipo_local, equipo_visitante, 
							   año_camp, semestre_camp )
AS
	SELECT nombres_jugador, apellidos_jugador, SUM(id_jugador), equipo_nombre(id_local),
		   equipo_nombre(id_visitante), año, semestre	
	FROM partido NATURAL JOIN campeonato NATURAL JOIN gol NATURAL JOIN jugador
	GROUP BY nombres_jugador;



DELIMITER $
CREATE PROCEDURE ver_goles_por_partido( equipo_local_requerido VARCHAR(45), 
										equipo_visitante_requerido VARCHAR(45),
										año_requerido INT, semestre_requerido INT )
BEGIN
	SELECT nombre_jugador, apellido_jugador, goles FROM goles_por_partido
	WHERE equipo_local = equipo_local_requerido 
		  AND equipo_visitante = equipo_visitante_requerido
		  AND año_camp = año_requerido AND semestre_camp = semestre_requerido;
END
$
DELIMITER ;


SELECT * FROM vista_partidos;
SELECT * FROM tabla_de_posiciones;
SELECT * FROM goles_por_partido;