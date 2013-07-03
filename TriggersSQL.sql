drop trigger if exists equipo_insert_constraint;
drop trigger if exists arbitro_insert_constraint;
drop trigger if exists jugador_insert_constraint;
drop trigger if exists tecnico_insert_constraint;
drop trigger if exists entrenador_insert_constraint;
drop trigger if exists partido_insert_constraint;
drop trigger if exists gol_insert_constraint;
drop trigger if exists campeonato_insert_constraint;

drop trigger if exists equipo_update_constraint;
drop trigger if exists arbitro_update_constraint;
drop trigger if exists jugador_update_constraint;
drop trigger if exists tecnico_update_constraint;
drop trigger if exists entrenador_update_constraint;
drop trigger if exists partido_update_constraint;

drop trigger if exists jugador_update;
drop trigger if exists entrenador_update;
drop trigger if exists tecnico_update;

drop trigger if exists gol_insert;
drop trigger if exists partido_insert;
drop trigger if exists campeonato_insert;

-- ------------ INSERT CONSTRAINT TRIGGERS

DELIMITER $$
CREATE TRIGGER equipo_insert_constraint BEFORE INSERT ON equipo FOR EACH ROW
BEGIN
	DECLARE msg varchar(255);
	IF (!(NEW.nombre_equipo regexp binary '^[A-Z]'))
	THEN
		SET msg = concat('Constraint equipo_insert_constraint violated in attribute nombre_equipo with value ', NEW.nombre_equipo);
        SIGNAL sqlstate '45000' SET message_text = msg;
	END IF;
    
  IF (!(NEW.rendimiento_equipo like 'MALO' or NEW.rendimiento_equipo like'ESTANDAR' 
    or NEW.rendimiento_equipo like 'BUENO' or NEW.rendimiento_equipo like 'MUY BUENO'))
	THEN
		SET msg = concat('Constraint equipo_insert_constraint violated in attribute rendimiento_equipo with value ', NEW.rendimiento_equipo);
        SIGNAL sqlstate '45000' SET message_text = msg;
	END IF;  
    
  IF ((select count(*) from equipo where nombre_equipo like new.nombre_equipo)>0)
	THEN
		SET msg = concat('Constraint equipo_insert_constraint violated. Already exists : ', NEW.nombre_equipo);
        SIGNAL sqlstate '45000' SET message_text = msg;
	END IF;
    
END;
$$

DELIMITER $$
CREATE TRIGGER arbitro_insert_constraint BEFORE INSERT ON arbitro FOR EACH ROW
BEGIN
	DECLARE msg varchar(255);
	IF (!(NEW.nombre_arbitro regexp binary '^[A-Z]'))
	THEN
		SET msg = concat('Constraint arbitro_insert_constraint violated in attribute nombre_arbitro with value ', NEW.nombre_arbitro);
        SIGNAL sqlstate '45000' SET message_text = msg;
ELSEIF (!(NEW.apellido_arbitro regexp binary '^[A-Z]'))
	THEN
		SET msg = concat('Constraint arbitro_insert_constraint violated in attribute apellido_arbitro with value ', NEW.apellido_arbitro);
        SIGNAL sqlstate '45000' SET message_text = msg;
	
	END IF;
  
  IF ((select count(*) from arbitro where nombre_arbitro like new.nombre_arbitro and apellido_arbitro like new.apellido_arbitro)>0)
	THEN
		SET msg = concat('Constraint arbitro_insert_constraint. Already exists : ', NEW.nombre_arbitro,' ',new.apellido_arbitro);
        SIGNAL sqlstate '45000' SET message_text = msg;
	END IF;
    
END;
$$


DELIMITER $$
CREATE TRIGGER jugador_insert_constraint BEFORE INSERT ON jugador FOR EACH ROW
BEGIN
	DECLARE msg varchar(255);
	IF (!(NEW.nombres_jugador regexp binary '^[A-Z]'))
	THEN
		SET msg = concat('Constraint jugador_insert_constraint violated in attribute nombres_jugador with value ', NEW.nombres_jugador);
        SIGNAL sqlstate '45000' SET message_text = msg;
ELSEIF (!(NEW.apellidos_jugador regexp binary '^[A-Z]'))
	THEN
		SET msg = concat('Constraint jugador_insert_constraint violated in attribute apellidos_jugador with value ', NEW.apellidos_jugador);
        SIGNAL sqlstate '45000' SET message_text = msg;
	
	END IF;
    
  IF ((NEW.salario_jugador)<0)
  THEN
    SET msg = concat('Constraint jugador_insert_constraint violated in attribute salario_jugador with value ', NEW.salario_jugador);
        SIGNAL sqlstate '45000' SET message_text = msg;
   END IF;
   
  IF ((select count(*) from jugador where nombres_jugador like new.nombres_jugador and apellidos_jugador like new.apellidos_jugador)>0)
	THEN
		SET msg = concat('Constraint jugador_insert_constraint. Already exists : ', NEW.nombres_jugador,' ',new.apellidos_jugador);
        SIGNAL sqlstate '45000' SET message_text = msg;
	END IF;
  
   
END;
$$
	
DELIMITER $$
CREATE TRIGGER tecnico_insert_constraint BEFORE INSERT ON tecnico FOR EACH ROW
BEGIN
	DECLARE msg varchar(255);
	IF (!(NEW.nombres_tecnico regexp binary '^[A-Z]'))
	THEN
		SET msg = concat('Constraint tecnico_insert_constraint violated in attribute nombres_tecnico with value ', NEW.nombres_tecnico);
        SIGNAL sqlstate '45000' SET message_text = msg;
ELSEIF (!(NEW.apellidos_tecnico regexp binary '^[A-Z]'))
	THEN
		SET msg = concat('Constraint tecnico_insert_constraint violated in attribute apellidos_tecnico with value ', NEW.apellidos_tecnico);
        SIGNAL sqlstate '45000' SET message_text = msg;
	
	END IF;
    
  IF ((NEW.salario_tecnico)<0)
  THEN
    SET msg = concat('Constraint tecnico_insert_constraint violated in attribute salario_tecnico with value ', NEW.salario_tecnico);
        SIGNAL sqlstate '45000' SET message_text = msg;
   END IF;
   
  IF ((select count(*) from tecnico where nombres_tecnico like new.nombres_tecnico and apellidos_tecnico like new.apellidos_tecnico)>0)
	THEN
		SET msg = concat('Constraint tecnico_insert_constraint. Already exists : ', NEW.nombres_tecnico,' ',new.apellidos_tecnico);
        SIGNAL sqlstate '45000' SET message_text = msg;
	END IF; 
   
END;
$$

DELIMITER $$
CREATE TRIGGER entrenador_insert_constraint BEFORE INSERT ON entrenador FOR EACH ROW
BEGIN
	DECLARE msg varchar(255);
	IF (!(NEW.nombres_entrenador regexp binary '^[A-Z]'))
	THEN
		SET msg = concat('Constraint entrenador_insert_constraint violated in attribute nombres_entrenador with value ', NEW.nombres_entrenador);
        SIGNAL sqlstate '45000' SET message_text = msg;
ELSEIF (!(NEW.apellidos_entrenador regexp binary '^[A-Z]'))
	THEN
		SET msg = concat('Constraint entrenador_insert_constraint violated in attribute apellidos_entrenador with value ', NEW.apellidos_entrenador);
        SIGNAL sqlstate '45000' SET message_text = msg;
	
	END IF;
    
  IF ((NEW.salario_entrenador)<0)
  THEN
    SET msg = concat('Constraint entrenador_insert_constraint violated in attribute salario_entrenador with value ', NEW.salario_entrenador);
        SIGNAL sqlstate '45000' SET message_text = msg;
   END IF;
   
   IF ((select count(*) from entrenador where nombres_entrenador like new.nombres_entrenador and apellidos_entrenador 
   like new.apellidos_entrenador)>0)
	THEN
		SET msg = concat('Constraint entrenador_insert_constraint. Already exists : ', NEW.nombres_entrenador,' ',new.apellidos_entrenador);
        SIGNAL sqlstate '45000' SET message_text = msg;
	END IF; 
   
END;
$$


DELIMITER $$
CREATE TRIGGER partido_insert_constraint BEFORE INSERT ON partido FOR EACH ROW
BEGIN
	DECLARE msg varchar(255);
  
  -- los equipo juegan en el campeonato
  
  IF((select count(*) from posicion where id_equipo like new.id_local and id_campeonato like new.id_campeonato)=0)
  THEN 
    SET msg = concat('Constraint partido_insert_constraint violated in attribute id_local with value ', NEW.id_local);
        SIGNAL sqlstate '45000' SET message_text = msg;
  
  ELSEIF((select count(*) from posicion where id_equipo like new.id_visitante and id_campeonato like new.id_campeonato)=0)
  THEN 
    SET msg = concat('Constraint partido_insert_constraint violated in attribute id_visitante with value ', NEW.id_visitante);
        SIGNAL sqlstate '45000' SET message_text = msg;
  END IF;
  
  
  -- Partido en misma fecha y misma ciudad
  
  IF ((select count(*) from partido where fecha_partido like new.fecha_partido)>0)
	THEN 
    
    IF((select count(*) from partido where ciudad_partido like new.ciudad_partido)>0)
    THEN
		SET msg = concat('Constraint insert_partido violated: El partido ya se jugo');
        SIGNAL sqlstate '45000' SET message_text = msg;
    END IF;
    
  END IF;
  
  -- Partido con mismos contrincantes en misma condicion
  
  IF((select count(*) from partido where id_local like new.id_local and id_visitante like new.id_visitante and id_campeonato like
    new.id_campeonato)>0)
    THEN 
    SET msg = concat('Constraint insert_partido violated: El partido ya se jugo');
        SIGNAL sqlstate '45000' SET message_text = msg;
   END IF;
    
  
  
END;
$$

DELIMITER $$
CREATE TRIGGER gol_insert_constraint BEFORE INSERT ON gol FOR EACH ROW
BEGIN
	DECLARE msg varchar(255);
    
  -- Minutos permitidos
  
	IF (NEW.minuto<0 or NEW.minuto>100)
	THEN
		SET msg = concat('Constraint gol_insert_constraint violated in attribute minuto with value ', NEW.minuto);
        SIGNAL sqlstate '45000' SET message_text = msg;
	END IF;
    
  -- Insercion repetida
  
  IF ((select count(*) from gol where id_partido like new.id_partido and id_jugador like new.id_jugador and 
    minuto like new.minuto and tipo_gol like new.tipo_gol)>0)
	THEN
		SET msg = concat('Constraint gol_insert_constraint violated. Insercion repetida con atributos :', NEW.id_jugador,', ',
        NEW.id_partido,', ',NEW.minuto,', ',NEW.tipo_gol,'.');
        SIGNAL sqlstate '45000' SET message_text = msg;
	END IF;  
    
END;
$$

DELIMITER $$
CREATE TRIGGER campeonato_insert_constraint BEFORE INSERT ON campeonato FOR EACH ROW
BEGIN

-- Insercion Repetida

	DECLARE msg varchar(255); 
	IF ((select count(*) from campeonato where año like new.año and semestre like new.semestre)>0)
	THEN
		SET msg = concat('Constraint campeonato_insert_constraint violated. Already exists : ', NEW.año, ' - ',NEW.semestre);
        SIGNAL sqlstate '45000' SET message_text = msg;
	END IF;
    
-- Campeonato viejo 

  IF ((select count(*) from campeonato where año > new.año )>0)
	THEN
		SET msg = concat('Constraint campeonato_insert_constraint violated. Values :', NEW.año, ' - ',NEW.semestre);
        SIGNAL sqlstate '45000' SET message_text = msg;
	END IF;
  
  
  set @maxaño = (select max(año) from campeonato);
  set @maxsemestre = (select max(semestre) from campeonato where año like @maxaño);
  IF((@maxaño like new.año) and (@maxsemestre>new.semestre))
    THEN
		SET msg = concat('Constraint campeonato_insert_constraint violated. Values :', NEW.año, ' - ',NEW.semestre);
        SIGNAL sqlstate '45000' SET message_text = msg;
  END IF;  
    
END;
$$

-- ------------ UPDATE CONSTRAINT TRIGGERS

DELIMITER $$
CREATE TRIGGER equipo_update_constraint BEFORE UPDATE ON equipo FOR EACH ROW
BEGIN
	DECLARE msg varchar(255);
	IF (!(NEW.nombre_equipo regexp binary '^[A-Z]'))
	THEN
		SET msg = concat('Constraint equipo_update_constraint violated in attribute nombre_equipo with value ', NEW.nombre_equipo);
        SIGNAL sqlstate '45000' SET message_text = msg;
	END IF;
    
  IF (!(NEW.rendimiento_equipo like 'MALO' or NEW.rendimiento_equipo like'ESTANDAR' 
    or NEW.rendimiento_equipo like 'BUENO' or NEW.rendimiento_equipo like 'MUY BUENO'))
	THEN
		SET msg = concat('Constraint equipo_update_constraint violated in attribute rendimiento_equipo with value ', NEW.rendimiento_equipo);
        SIGNAL sqlstate '45000' SET message_text = msg;
	END IF;    
    
  IF(new.id_tecnico != old.id_tecnico)
    THEN
    set @telefono =(select telefono_tecnico from tecnico where id_tecnico like old.id_tecnico);
    set @experiencia =(select experiencia_tecnico from tecnico where id_tecnico like old.id_tecnico);
    set @salario= (select salario_tecnico from tecnico where id_tecnico like old.id_tecnico);
    insert into historico_tecnico 
        values(old.id_equipo,old.id_tecnico,@telefono,@experiencia,@salario);
    END IF;
END;
$$

DELIMITER $$
CREATE TRIGGER arbitro_update_constraint BEFORE UPDATE ON arbitro FOR EACH ROW
BEGIN
	DECLARE msg varchar(255);
	IF (!(NEW.nombre_arbitro regexp binary '^[A-Z]'))
	THEN
		SET msg = concat('Constraint arbitro_update_constraint violated in attribute nombre_arbitro with value ', NEW.nombre_arbitro);
        SIGNAL sqlstate '45000' SET message_text = msg;
ELSEIF (!(NEW.apellido_arbitro regexp binary '^[A-Z]'))
	THEN
		SET msg = concat('Constraint arbitro_update_constraint violated in attribute apellido_arbitro with value ', NEW.apellido_arbitro);
        SIGNAL sqlstate '45000' SET message_text = msg;
	
	END IF;
END;
$$


DELIMITER $$
CREATE TRIGGER jugador_update_constraint BEFORE UPDATE ON jugador FOR EACH ROW
BEGIN
	DECLARE msg varchar(255);
	IF (!(NEW.nombres_jugador regexp binary '^[A-Z]'))
	THEN
		SET msg = concat('Constraint jugador_update_constraint violated in attribute nombres_jugador with value ', NEW.nombres_jugador);
        SIGNAL sqlstate '45000' SET message_text = msg;
ELSEIF (!(NEW.apellidos_jugador regexp binary '^[A-Z]'))
	THEN
		SET msg = concat('Constraint jugador_update_constraint violated in attribute apellidos_jugador with value ', NEW.apellidos_jugador);
        SIGNAL sqlstate '45000' SET message_text = msg;
	
	END IF;
    
  IF ((NEW.salario_jugador)<0)
  THEN
    SET msg = concat('Constraint jugador_update_constraint violated in attribute salario_jugador with value ', NEW.salario_jugador);
        SIGNAL sqlstate '45000' SET message_text = msg;
   END IF;
   
END;
$$
	
DELIMITER $$
CREATE TRIGGER tecnico_update_constraint BEFORE UPDATE ON tecnico FOR EACH ROW
BEGIN
	DECLARE msg varchar(255);
	IF (!(NEW.nombres_tecnico regexp binary '^[A-Z]'))
	THEN
		SET msg = concat('Constraint tecnico_update_constraint violated in attribute nombres_tecnico with value ', NEW.nombres_tecnico);
        SIGNAL sqlstate '45000' SET message_text = msg;
ELSEIF (!(NEW.apellidos_tecnico regexp binary '^[A-Z]'))
	THEN
		SET msg = concat('Constraint tecnico_update_constraint violated in attribute apellidos_tecnico with value ', NEW.apellidos_tecnico);
        SIGNAL sqlstate '45000' SET message_text = msg;
	
	END IF;
    
  IF ((NEW.salario_tecnico)<0)
  THEN
    SET msg = concat('Constraint tecnico_update_constraint violated in attribute salario_tecnico with value ', NEW.salario_tecnico);
        SIGNAL sqlstate '45000' SET message_text = msg;
   END IF;
   
END;
$$

DELIMITER $$
CREATE TRIGGER entrenador_update_constraint BEFORE UPDATE ON entrenador FOR EACH ROW
BEGIN
	DECLARE msg varchar(255);
	IF (!(NEW.nombres_entrenador regexp binary '^[A-Z]'))
	THEN
		SET msg = concat('Constraint entrenador_update_constraint violated in attribute nombres_entrenador with value ', NEW.nombres_entrenador);
        SIGNAL sqlstate '45000' SET message_text = msg;
ELSEIF (!(NEW.apellidos_entrenador regexp binary '^[A-Z]'))
	THEN
		SET msg = concat('Constraint entrenador_update_constraint violated in attribute apellidos_entrenador with value ', NEW.apellidos_entrenador);
        SIGNAL sqlstate '45000' SET message_text = msg;
	
	END IF;
    
  IF ((NEW.salario_entrenador)<0)
  THEN
    SET msg = concat('Constraint entrenador_update_constraint violated in attribute salario_entrenador with value ', NEW.salario_entrenador);
        SIGNAL sqlstate '45000' SET message_text = msg;
   END IF;
   
END;
$$


DELIMITER $$
CREATE TRIGGER partido_update_constraint BEFORE UPDATE ON partido FOR EACH ROW
BEGIN
	DECLARE msg varchar(255);
    
  -- Goles Positivos  
    
	IF (!(NEW.goles_local >= 0))
	THEN 
		SET msg = concat('Constraint goles_positivos violated in attribute goles_local with value ', NEW.goles_local);
        SIGNAL sqlstate '45000' SET message_text = msg;
	ELSEIF (!(NEW.goles_visitante >= 0))
	THEN
		SET msg = concat('Constraint goles_positivos violated in attribute goles_visitante with value ', NEW.goles_visitante);
        SIGNAL sqlstate '45000' SET message_text = msg;
    
  END IF;
   
END;
$$

-- Inserciones en historicos -- 

DELIMITER $$
CREATE TRIGGER jugador_update AFTER UPDATE ON jugador FOR EACH ROW
BEGIN

IF(new.id_equipo != old.id_equipo)
THEN
    set @Añojug = (select Year(CURDATE()));
    insert into historico_jugadores 
        values(old.id_equipo,old.id_jugador,@Añojug,old.numero_jugador,old.goles_jugador,old.salario_jugador);
 END IF;
END;
$$

DELIMITER $$
CREATE TRIGGER entrenador_update AFTER UPDATE ON entrenador FOR EACH ROW
BEGIN
IF(new.id_equipo != old.id_equipo)
THEN
    set @Añoentre = (select Year(CURDATE()));
    insert into historico_entrenadores 
        values(old.id_equipo,old.id_entrenador,old.salario_entrenador,@Añoentre);
END IF;
END;
$$

/*
DELIMITER $$
CREATE TRIGGER tecnico_update AFTER UPDATE ON tecnico FOR EACH ROW
BEGIN
    
    set @oldequipo = (select id_equipo from equipo where id_tecnico like old.id_tecnico);
    insert into historico_entrenadores 
        values(@oldequipo,old.id_tecnico,old.telefono_tecnico,old.experiencia_tecnico,old.salario_tecnico);
    
END;
$$
*/

-- TRIGGERS NORMALES 


DELIMITER $$
CREATE TRIGGER gol_insert AFTER INSERT ON gol FOR EACH ROW
BEGIN
    
    update jugador set goles_jugador=goles_jugador+1 where id_jugador like new.id_jugador; 
    
END;
$$

DELIMITER $$
CREATE TRIGGER partido_insert AFTER INSERT ON partido FOR EACH ROW
BEGIN

  DECLARE ganador INT;
	DECLARE done INT;
	DECLARE puntaje1 INT;
	DECLARE puntaje2 INT;
	DECLARE dif1 INT;
	DECLARE dif2 INT;
	DECLARE id1 INT;
	DECLARE id2 INT;
	DECLARE cont INT;

	DECLARE actualizar_posiciones CURSOR
	FOR SELECT id_equipo, puntaje, goles_favor-goles_contra
	FROM posicion WHERE id_campeonato = NEW.id_campeonato ORDER BY puntaje DESC FOR UPDATE;
	DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;

    -- actualizacion goles en contra y a favor de los contrincantes
    
    update posicion set goles_favor=goles_favor+new.goles_local where id_equipo like new.id_local and id_campeonato like new.id_campeonato;
    update posicion set goles_contra=goles_contra+new.goles_visitante where id_equipo like new.id_local and id_campeonato like new.id_campeonato;
    
    update posicion set goles_favor=goles_favor+new.goles_visitante where id_equipo like new.id_visitante and id_campeonato like new.id_campeonato;
    update posicion set goles_contra=goles_contra+new.goles_local where id_equipo like new.id_visitante and id_campeonato like new.id_campeonato;

    -- Sumar puntos a posicion 
    
    IF(new.goles_local>new.goles_visitante)
    THEN
        update posicion set puntaje=puntaje+3 where id_equipo like new.id_local and id_campeonato like new.id_campeonato;
    END IF;
    
    IF (new.goles_visitante>new.goles_local)
    THEN 
        update posicion set puntaje=puntaje+3 where id_equipo like new.id_visitante and id_campeonato like new.id_campeonato;
    END IF; 
    
    IF (new.goles_visitante=new.goles_local)
    THEN
        update posicion set puntaje=puntaje+1 where id_equipo like new.id_local and id_campeonato like new.id_campeonato;
        update posicion set puntaje=puntaje+1 where id_equipo like new.id_visitante and id_campeonato like new.id_campeonato;
    END IF;
    
    -- actualizar posiciones
    
    SET cont = 1;
	SET puntaje1 = -1;
	OPEN actualizar_posiciones;
	REPEAT
		FETCH actualizar_posiciones INTO id2, puntaje2, dif2;
		IF puntaje2 = puntaje1 THEN
			UPDATE posicion 
				SET pos = cont-1 WHERE id_equipo = id2 and id_campeonato = new.id_campeonato;
		ELSE 
			UPDATE posicion 
				SET pos = cont WHERE id_equipo = id2 and id_campeonato = new.id_campeonato;
			SET cont = cont + 1;
		END IF;
		SET id1 = id2;
		SET puntaje1 = puntaje2;
		SET dif1 = dif2;
	UNTIL done
	END REPEAT;

	CLOSE actualizar_posiciones;
    
END;
$$

DELIMITER $$
CREATE TRIGGER campeonato_insert AFTER INSERT ON campeonato FOR EACH ROW
BEGIN
    
  DECLARE done INT DEFAULT 0;
  DECLARE a INT;
  DECLARE b INT;
  DECLARE max INT DEFAULT 0;
  DECLARE prom INT;
  DECLARE cur1 CURSOR FOR SELECT DISTINCT id_campeonato FROM posicion;
  DECLARE cur2 CURSOR FOR SELECT DISTINCT id_equipo from posicion where id_campeonato not like new.id_campeonato;
  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
  
  
  OPEN cur1;
  
  REPEAT
    FETCH cur1 INTO a;
    IF NOT done THEN
    
       set max = (max+(select max(puntaje) from posicion where id_campeonato like a));
        
    END IF;
  UNTIL done END REPEAT;
  
  CLOSE cur1;
  
  set max = (max/(SELECT count(DISTINCT id_campeonato) FROM posicion));
  set done = 0;
 
  OPEN cur2;
  
  REPEAT
    FETCH cur2 INTO b;
    IF NOT done THEN
        set prom = (SELECT avg(puntaje) from posicion where id_equipo like b);
        
       IF(((prom*100)/max)>=85)
       THEN
       update equipo set rendimiento_equipo ='MUY BUENO' where id_equipo like b;
       END IF;
       
       IF(((prom*100)/max)>=75 and ((prom*100)/max)<85)
       THEN
       update equipo set rendimiento_equipo ='BUENO' where id_equipo like b;
       END IF;
       
       IF(((prom*100)/max)>=25 and ((prom*100)/max)<75)
       THEN
       update equipo set rendimiento_equipo ='ESTANDAR' where id_equipo like b;
       END IF;
       
       IF(((prom*100)/max)<25)
       THEN
       update equipo set rendimiento_equipo ='MALO' where id_equipo like b;
       END IF;
       
    END IF;
  UNTIL done END REPEAT;
  
  CLOSE cur2;
  
END;
$$


