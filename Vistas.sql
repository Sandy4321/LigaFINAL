DROP FUNCTION IF EXISTS ganador;
DROP FUNCTION IF EXISTS nombre_equipo;
DROP VIEW IF EXISTS vista_partidos;
DROP VIEW IF EXISTS goles_por_partido;
DROP PROCEDURE IF EXISTS ver_goles_por_partido;

DELIMITER $
CREATE FUNCTION ganador( equipo_local VARCHAR(45), equipo_visitante VARCHAR(45),
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
CREATE FUNCTION nombre_equipo( id_equipo_requerido INT )
						 RETURNS VARCHAR(45)
BEGIN
	RETURN (SELECT equipo_nombre FROM equipo WHERE id_equipo = id_equipo_requerido );
END
$
DELIMITER ;


CREATE VIEW vista_partidos( fecha_partido, equipo_local, equipo_visitante, 
							goles_local, goles_visitante, equipo_ganador ) 
AS 
	SELECT fecha_partido, 
		   nombre_equipo(id_local), nombre_equipo(id_visitante),
		   goles_local, goles_visitante,
		   ganador( nombre_equipo(id_local), nombre_equipo(id_visitante), 
					goles_local, goles_visitante )	
	FROM partido;



CREATE VIEW goles_por_partido( nombre_jugador, apellido_jugador, goles, 
							   equipo_local, equipo_visitante, 
							   año_camp, semestre_camp )
AS
	SELECT nombres_jugador, apellidos_jugador, SUM(id_jugador), nombre_equipo(id_local),
		   nombre_equipo(id_visitante), año, semestre	
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