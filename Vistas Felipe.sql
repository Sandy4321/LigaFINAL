##Vistas FELIPE

#Vista que muestra los atributos de los entrenadores actuales y su equipo
DROP VIEW IF EXISTS ver_entrenadores_actuales;
CREATE VIEW ver_entrenadores_actuales AS
	SELECT nombre_equipo AS 'Equipo' , nombres_entrenador AS 'Nombres', apellidos_entrenador AS 'Apellidos',
		   salario_entrenador AS 'Salario', telefono_entrenador AS 'Número telefónico', experiencia_entrenador AS 'Experiencia'
		    FROM entrenador NATURAL JOIN equipo;

#Vista para ver jugadores actuales y su equipo
DROP VIEW IF EXISTS ver_jugadores_actuales;
CREATE VIEW ver_jugadores_actuales AS
	SELECT nombre_equipo AS 'Equipo', nombres_jugador AS 'Nombres', apellidos_jugador 'Apellidos', nacionalidad_jugador AS 'Nacionaliad',
		   fechaNacimiento_jugador AS 'Fecha Nacimiento', edad_jugador AS 'Edad', numero_jugador AS 'Número Camiseta', salario_jugador AS 'Salario',
		   goles_jugador AS 'Goles' FROM jugador NATURAL JOIN equipo;

#Vista para ver los técnicos actuales
DROP VIEW IF EXISTS ver_tecnicos_actuales;

CREATE VIEW ver_tecnicos_actuales AS
	SELECT nombre_equipo AS 'Equipo', nombres_tecnico AS 'Nombres', apellidos_tecnico AS 'Apellidos', experiencia_tecnico AS 'Experiencia', salario_tecnico AS 'Salario'
		   FROM tecnico NATURAL JOIN equipo;

#Vista para ver datos generales de los equipos
DROP VIEW IF EXISTS ver_equipos;
CREATE VIEW ver_equipos AS
	SELECT nombre_equipo AS 'Nombre', ciudad_equipo AS 'Ciudad', rendimiento_equipo AS 'Rendimiento' FROM equipo;






