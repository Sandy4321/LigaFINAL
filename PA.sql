
DROP PROCEDURE IF EXISTS insertar_jugador;
DROP PROCEDURE IF EXISTS insertar_equipo;
DROP PROCEDURE IF EXISTS insertar_entrenador;
DROP PROCEDURE IF EXISTS insertar_tecnico;
DROP PROCEDURE IF EXISTS insertar_arbitro;
DROP PROCEDURE IF EXISTS insertar_partido;
DROP PROCEDURE IF EXISTS insertar_campeonato;
DROP PROCEDURE IF EXISTS asingar_partido_arbitro;
DROP PROCEDURE IF EXISTS insertar_equipo_en_campeonato;
DROP PROCEDURE IF EXISTS insertar_gol;
DROP PROCEDURE IF EXISTS cambio_jugador;
DROP PROCEDURE IF EXISTS cambio_tecnico;
DROP PROCEDURE IF EXISTS cambio_entrenador;
DROP PROCEDURE IF EXISTS cambio_posicion;
DROP PROCEDURE IF EXISTS ver_goles_jugador;
DROP FUNCTION IF EXISTS obtener_edad;
DROP PROCEDURE IF EXISTS obtener_partidos;
DROP PROCEDURE IF EXISTS obtener_historico_entrenador;
DROP PROCEDURE IF EXISTS obtener_equipos_rendimiento;
DROP PROCEDURE IF EXISTS obtener_equipos_rendimiento_extendido;
DROP PROCEDURE IF EXISTS aumentar_salario_jugadores;

DELIMITER $$

CREATE PROCEDURE insertar_jugador (nacionalidad VARCHAR(45),  
								nombres VARCHAR(45), apellidos VARCHAR(45),  nombre_equ VARCHAR(45), numero_camiseta INT, fecha DATETIME, salario DOUBLE)
	BEGIN	
	DECLARE edad INT DEFAULT year(curdate()) - year(fecha);
	START TRANSACTION;		
		SET @id_equ = (SELECT id_equipo FROM equipo WHERE nombre_equipo = nombre_equ);
		INSERT INTO jugador (nacionalidad_jugador, edad_jugador, nombres_jugador, apellidos_jugador, numero_jugador, fechaNacimiento_jugador, id_equipo, salario_jugador) 
					VALUES (nacionalidad,edad,nombres,apellidos, numero_camiseta, fecha, @id_equ, salario );
	COMMIT;
	END;
$$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE insertar_equipo (ciudad VARCHAR(45), nombre VARCHAR(45), nombre_tec VARCHAR(45), apellido_tec  VARCHAR(45))
	BEGIN
	START TRANSACTION;
		SET @id_tec = (SELECT id_tecnico FROM tecnico WHERE nombres_tecnico = nombre_tec  AND apellidos_tecnico = apellido_tec );
		INSERT INTO equipo (id_tecnico, ciudad_equipo, nombre_equipo, rendimiento_equipo) VALUES (@id_tec, ciudad, nombre, 'ESTANDAR');
	COMMIT;
	END;
$$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE insertar_entrenador(telefono VARCHAR(45), equipo VARCHAR(45), experiencia INT, 
									 nombres VARCHAR(45), apellidos VARCHAR(45), año INT, salario DOUBLE)
	BEGIN
	START TRANSACTION;
		SET @id_equipo = (SELECT id_equipo FROM equipo WHERE nombre_equipo = equipo);
		INSERT INTO entrenador (telefono_entrenador, experiencia_entrenador, apellidos_entrenador, nombres_entrenador, salario_entrenador, id_equipo)
						 VALUES( telefono, experiencia, apellidos, nombres, salario, @id_equipo );
	COMMIT;
	END;
$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE insertar_tecnico(telefono VARCHAR(45), experiencia INT, nombres VARCHAR(45),
									apellidos VARCHAR(45), salario DOUBLE)
	BEGIN
	START TRANSACTION;
	INSERT INTO tecnico (telefono_tecnico,experiencia_tecnico, apellidos_tecnico, nombres_tecnico, salario_tecnico)
				  VALUES( telefono, experiencia, apellidos, nombres, salario );
	COMMIT;	
	END;
$$
DELIMITER ;

##########################################################################################
##########################################################################################
#Otros PA de inserción


DELIMITER $$
CREATE PROCEDURE insertar_arbitro( nombre VARCHAR(45), apellido VARCHAR(45), tipo VARCHAR(45) )
	BEGIN
	START TRANSACTION;
	INSERT INTO arbitro ( nombre_arbitro, apellido_arbitro, tipo_arbitro )VALUES( nombre, apellido, tipo );
	COMMIT;
	END;
$$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE insertar_partido( fecha DATETIME , ciudad VARCHAR(45), estadio VARCHAR(45), goles_loc INT, 
								   goles_vis INT, eq_local VARCHAR(45), eq_visitante VARCHAR(45), añ INT, sem INT)
	BEGIN 
	START TRANSACTION;
		SET @camp = (SELECT id_campeonato FROM campeonato WHERE semestre = sem AND año = añ);
		SET @id_loc = (SELECT id_equipo FROM equipo WHERE nombre_equipo = eq_local);
		SET @id_vis = (SELECT id_equipo FROM equipo WHERE nombre_equipo = eq_visitante);

		INSERT INTO partido (fecha_partido, ciudad_partido, estadio, goles_local, goles_visitante, id_local, id_visitante, id_campeonato  ) 
					 VALUES (fecha, ciudad, estadio, goles_loc, goles_vis, @id_loc, @id_vis, @camp);
	COMMIT;
	END;
$$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE insertar_campeonato(añ INT, sem INT)
	BEGIN
	START TRANSACTION;
		INSERT INTO campeonato (año, semestre) VALUES (añ, sem);
	COMMIT;
	END;
$$
DELIMITER ;




DELIMITER $$

CREATE PROCEDURE asingar_partido_arbitro(nombre VARCHAR(45), apellido VARCHAR(45), nombre_loc VARCHAR(45), 
										 nombre_vis VARCHAR(45), añ VARCHAR(45), sem VARCHAR(45))
	BEGIN
	START TRANSACTION;
	SET @id_arbitro = (SELECT id_arbitro FROM arbitro WHERE nombre_arbitro = nombre AND apellido_arbitro = apellido);
	SET @id_camp = (SELECT id_campeonato FROM campeonato WHERE semestre = sem AND año = añ);
	SET @id_local = (SELECT id_equipo FROM equipo WHERE nombre_equipo = nombre_loc );
	SET @id_vis = (SELECT id_equipo FROM equipo WHERE nombre_equipo = nombre_vis );
	SET @id_partido = (SELECT id_partido FROM partido WHERE id_local = @id_local AND id_visitante = @id_vis 
					   AND id_campeonato = @id_camp);
	
	INSERT INTO arbitro_partido VALUES(@id_arbitro, @id_partido);
	
	COMMIT;
	END;
$$
DELIMITER ;



DELIMITER $$

CREATE PROCEDURE insertar_equipo_en_campeonato(nombre_eq VARCHAR(45), añ INT, sem INT)
	BEGIN
	START TRANSACTION;
	SET @id_camp = (SELECT id_campeonato FROM campeonato WHERE año = añ AND semestre = sem);
	SET @id_equ = (SELECT id_equipo FROM equipo WHERE nombre_equipo = nombre_eq);
	
	INSERT INTO posicion (id_campeonato, id_equipo)VALUES(@id_camp, @id_equ);
	COMMIT;
	END;
$$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE insertar_gol(minuto INT, tipo_gol VARCHAR(45), nom_jug VARCHAR(45), ape_jug VARCHAR(45),
							  nombre_loc VARCHAR(45), nombre_vis VARCHAR(45), añ INT, sem INT, fecha DATETIME )
	BEGIN
	START TRANSACTION;
	SET @id_camp = (SELECT id_campeonato FROM campeonato WHERE semestre = sem AND año = añ);
	SET @id_local = (SELECT id_equipo FROM equipo WHERE nombre_equipo = nombre_loc );
	SET @id_vis = (SELECT id_equipo FROM equipo WHERE nombre_equipo = nombre_vis );
	SET @id_partido = (SELECT id_partido FROM partido WHERE id_local = @id_local AND id_visitante = @id_vis 
					   AND id_campeonato = @id_camp AND fecha_partido = fecha);
	SET @id_jug = (SELECT id_jugador FROM jugador WHERE nombres_jugador = nom_jug AND apellidos_jugador = ape_jug);

	INSERT INTO gol (tipo_gol, minuto, id_partido, id_jugador )VALUES(tipo_gol, minuto, @id_partido, @id_jug);
	COMMIT;

	END;

$$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE cambio_jugador( nombres VARCHAR(45), apellidos VARCHAR(45), equipo_nuevo VARCHAR(45), numero_camiseta INT, salario DOUBLE)
	BEGIN
	START TRANSACTION;
	SET @id_equ = (SELECT id_equipo FROM equipo WHERE nombre_equipo = equipo_nuevo);
	SET @id_jug = (SELECT id_jugador FROM jugador WHERE nombres_jugador = nombres AND apellidos_jugador = apellidos);
	UPDATE jugador SET id_equipo = @id_equ, numero_jugador = numero_camiseta, salario_jugador = salario WHERE id_jugador = @id_jug;
	COMMIT;
	END;
$$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE cambio_tecnico( nombres VARCHAR(45), apellidos VARCHAR(45), equipo_nuevo VARCHAR(45), salario DOUBLE) 
	BEGIN
	START TRANSACTION;
	SET @id_tec = (SELECT id_tecnico FROM tecnico WHERE nombres_tecnico = nombres AND apellidos_tecnico = apellidos);
	SET @id_equ = (SELECT id_equipo FROM equipo WHERE nombre_equipo = equipo_nuevo);
	
	UPDATE tecnico SET salario_tecnico = salario WHERE id_tecnico = @id_tec;
	UPDATE equipo SET id_tecnico = @id_tec WHERE id_equipo = @id_equ;
	
	COMMIT;
	END;
$$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE cambio_entrenador( nombres VARCHAR(45), apellidos VARCHAR(45), equipo VARCHAR(45), salario DOUBLE )
	BEGIN 
	START TRANSACTION;
	SET @id_ent = (SELECT id_entrenador FROM entrenador WHERE nombres_entrenador = nombres AND apellidos_entrenador = apellidos);
	SET @id_equ = (SELECT id_equipo FROM equipo WHERE nombre_equipo = equipo);

	UPDATE entrenador SET salario_entrenador = salario, id_equipo = @id_equ WHERE id_entrenador = @id_ent;
	COMMIT;
	END;
$$
DELIMITER ;

#Procedimiento para actualizar la posición

/*DELIMITER $$
CREATE PROCEDURE cambio_posicion(id_camp INT)
	BEGIN 
	DECLARE done BOOLEAN DEFAULT 0;
	DECLARE aux INT DEFAULT 0;
	DECLARE id_equipo_ap INT;

	DECLARE equipo CURSOR FOR SELECT id_equipo FROM posicion WHERE id_campeonato = id_camp ORDER BY puntaje DESC;
	DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done=1;

	OPEN equipo;

	REPEAT
	  SET aux = aux + 1;
      FETCH equipo INTO id_equipo_ap;
	  UPDATE posicion SET pos = aux WHERE id_equipo = id_equipo_ap AND id_campeonato = id_camp;
	  UNTIL done END REPEAT;
	  CLOSE equipo;
	END;
$$
DELIMITER ;*/

#########################################################################################
#########################################################################################
#########################################################################################
#########################################################################################
#PA DEL DOC:

#PA que retorne la edad:
DELIMITER $$
CREATE FUNCTION obtener_edad(nombres VARCHAR(45), apellidos VARCHAR(45))
RETURNS INT
	BEGIN
		SET @ret = (SELECT edad_jugador FROM jugador WHERE nombres_jugador = nombres AND apellidos_jugador = apellidos);
		RETURN @ret;
	END;
$$
DELIMITER ;



#MUESTRA todos los goles del jugador
DELIMITER $$
CREATE PROCEDURE ver_goles_jugador(nombres VARCHAR(45), apellidos VARCHAR(45))
	BEGIN
	(SELECT nombres_jugador AS 'Nombres', apellidos_jugador AS 'Apellidos', nombre_equipo AS 'Equipo Actual', goles_jugador AS 'Goles' 
		   FROM jugador NATURAL JOIN equipo WHERE nombres_jugador = nombres AND apellidos_jugador = apellidos)
	UNION
	(SELECT nombres_jugador AS 'Nombres', apellidos_jugador AS 'Apellidos', nombre_equipo AS 'Equipo', goles_jugador AS 'Goles' 
		   FROM jugador NATURAL JOIN equipo JOIN historico_jugadores USING(id_jugador) WHERE nombres_jugador = nombres AND apellidos_jugador = apellidos);

	END;
$$
DELIMITER ;


#Devolver el goleador de un campeonato
/*DELIMITER $$
CREATE PROCEDURE obtener_goleador( id_camp INT )
	BEGIN
	SET @id_goleador = ( SELECT id_jugador FROM campeonato NATURAL JOIN partido NATURAL JOIN gol ORDER BY LIMIT(1) ASC);
	SELECT nombres_jugador AS 'Nombres', apellidos_jugador AS 'Apellidos' WHERE id_jugador = @id_goleador;
	END;
$$
DELIMITER ;*/

#INsertar gol y actualizar (más arriba y en trigger)

#Devolver el numero de partidos ganados, perdidos, empatados, posicion en el campeoanto y puntaje

DELIMITER $$
CREATE PROCEDURE obtener_partidos( id_camp INT, nombre VARCHAR(45) )
	BEGIN
	SET @id_equ = (SELECT id_equipo FROM equipo WHERE nombre_equipo = nombre);

	SET @ganados = (SELECT COUNT(*) FROM campeonato NATURAL JOIN partido WHERE (id_campeonato = id_camp)
				   AND( (id_local = @id_equ AND goles_local > goles_visitante) OR (id_visitante = @id_equ
				   AND goles_visitante > goles_local) ));

	
	SET @perdidos = (SELECT COUNT(*) FROM campeonato NATURAL JOIN partido WHERE (id_campeonato = id_camp)
				   AND( (id_local = @id_equ AND goles_local < goles_visitante) OR (id_visitante = @id_equ
				   AND goles_visitante < goles_local) ));


	SET @empatados =  (SELECT COUNT(*) FROM campeonato NATURAL JOIN partido WHERE (id_campeonato = id_camp)
				   AND( (id_local = @id_equ AND goles_local = goles_visitante) OR (id_visitante = @id_equ
				   AND goles_visitante = goles_local) ));

	SET @posicion = (SELECT pos FROM posicion WHERE id_campeonato = id_camp AND id_equipo = @id_equ);

	SET @puntaje = (SELECT puntaje FROM posicion WHERE id_campeonato = id_camp AND id_equipo = @id_equ);
	
	(SELECT @ganados);
	(SELECT @perdidos) ;
	(SELECT @empatados);
	(SELECT @posicion);
	(SELECT @puntaje);
	
	END;
$$
DELIMITER ;

#Obtener equipos y tiempo historico de un entrenador
DELIMITER $$
CREATE PROCEDURE obtener_historico_entrenador(id_entre INT)
	BEGIN
	SELECT nombre_equipo AS 'Equipo', ciudad_equipo AS 'Ciudad', rendimiento_equipo AS 'Rendimiento', año_historico_entrenadores AS 'Año' 
	FROM entrenador NATURAL JOIN historico_entrenadores NATURAL JOIN equipo WHERE id_entrenador = id_entre;
	END;
$$
DELIMITER  ;

#Devolver equipos con un perfil
DELIMITER $$
CREATE PROCEDURE obtener_equipos_rendimiento(rendimiento VARCHAR(45))
	BEGIN
	SELECT * FROM equipo WHERE rendimiento_equipo LIKE rendimiento;
	END;
$$
DELIMITER ;

CALL obtener_equipos_rendimiento('ESTANDAR');

#PA dado el perfil del equipo devuelva cuantos equipos
#pertenecen a ese perfil y los 3 jugadores que más goles han anotado de
#c/u de estos equipos FALTA SACAR GOLEADORES

DELIMITER $$
CREATE PROCEDURE obtener_equipos_rendimiento_extendido(rendimiento VARCHAR(45))	
	BEGIN
	SELECT COUNT(*) FROM equipo WHERE rendimiento_equipo LIKE rendimiento; 
	END;
$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE aumentar_salario_jugadores()
	BEGIN
	
	DECLARE done BOOLEAN DEFAULT FALSE;
	DECLARE salario_ap DOUBLE;
	DECLARE id_jug INT;
	DECLARE jugador_cur CURSOR FOR SELECT DISTINCT id_jugador, salario_jugador FROM historico_jugadores WHERE año_historico_jugadores < 1999;
	DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = TRUE;

	OPEN jugador_cur;

	REPEAT
      FETCH jugador_cur INTO salario_ap, id_jug ;
	  IF salario_ap*1.15 > 5000000 THEN
			UPDATE jugador SET salario_jugador = salario_jugador *1.10 WHERE id_jugador = id_jugador;
	  
	  ELSE 
			UPDATE jugador SET salario_jugador = salario_jugador *1.15 WHERE id_jugador = id_jugador;
	  END IF;
	  UNTIL done END REPEAT;
	COMMIT;
	END;
$$
DELIMITER ;

/*CALL insertar_arbitro('asdasd', 'asdasd', 'pecora');
CALL insertar_tecnico('564654465', 7, 'Cruz', 'Andres', 1213213);
CALL insertar_equipo ('PecoraCity', 'PecoraTeam', 'MALO', 'Cruz', 'Andres');
CALL insertar_jugador('Cholo', 80, 'Zambrano', 'Pedro', 'PecoraTeam', 0, 10,'1985/03/03', 300000);
CALL insertar_campeonato(2013, 2);
CALL insertar_partido( curdate(), 'asdsadasd','asdasd', 8, 7, 'PecoraTeam', 'PecoraTeam', 2013, 2 );
CALL asingar_partido_arbitro('asdasd', 'asdasd', 'PecoraTeam', 'PecoraTeam', 2013, 2);
CALL insertar_gol (14, 'penal', 'Zambrano', 'Pedro', 'PecoraTeam', 'PecoraTeam', 2013, 2 );
CALL insertar_equipo_en_campeonato('PecoraTeam',2013,2);*/

