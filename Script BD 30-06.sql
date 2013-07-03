SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';


-- -----------------------------------------------------
-- Table `tecnico`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tecnico` ;

CREATE  TABLE IF NOT EXISTS `tecnico` (
  `id_tecnico` INT NOT NULL AUTO_INCREMENT ,
  `telefono_tecnico` VARCHAR(45) NULL ,
  `experiencia_tecnico` INT NULL ,
  `apellidos_tecnico` VARCHAR(45) NOT NULL ,
  `nombres_tecnico` VARCHAR(45) NOT NULL ,
  `salario_tecnico` DOUBLE NULL,
  PRIMARY KEY (`id_tecnico`) )
ENGINE = InnoDB;

CREATE INDEX `tecnico_idx` ON `tecnico` (`nombres_tecnico` ASC, `apellidos_tecnico` ASC) ;

CREATE INDEX `experiencia_idx` ON `tecnico` (`id_tecnico` ASC, `experiencia_tecnico` ASC) ;


-- -----------------------------------------------------
-- Table `equipo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `equipo` ;

CREATE  TABLE IF NOT EXISTS `equipo` (
  `id_equipo` INT NOT NULL AUTO_INCREMENT ,
  `id_tecnico` INT NOT NULL ,
  `ciudad_equipo` VARCHAR(45) NULL ,
  `nombre_equipo` VARCHAR(45) NOT NULL ,
  `rendimiento_equipo` VARCHAR(45) NULL DEFAULT 'ESTANDAR',
  PRIMARY KEY (`id_equipo`) ,
  CONSTRAINT `fk_equipo_tecnico1`
    FOREIGN KEY (`id_tecnico` )
    REFERENCES `tecnico` (`id_tecnico` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `nombre_ciudad_equipo_UNIQUE` ON `equipo` (`nombre_equipo` ASC, `ciudad_equipo` ASC) ;

CREATE INDEX `fk_equipo_tecnico1_idx` ON `equipo` (`id_tecnico` ASC) ;

CREATE UNIQUE INDEX `tecnico_id_tecnico_UNIQUE` ON `equipo` (`nombre_equipo` ASC, `id_tecnico` ASC) ;


-- -----------------------------------------------------
-- Table `entrenador`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `entrenador` ;

CREATE  TABLE IF NOT EXISTS `entrenador` (
  `id_entrenador` INT NOT NULL AUTO_INCREMENT ,
  `id_equipo` INT NOT NULL ,
  `telefono_entrenador` VARCHAR(45) NULL ,
  `experiencia_entrenador` INT NULL DEFAULT 0 ,
  `apellidos_entrenador` VARCHAR(45) NOT NULL ,
  `nombres_entrenador` VARCHAR(45) NOT NULL ,
  `salario_entrenador` DOUBLE NOT NULL ,
  PRIMARY KEY (`id_entrenador`) ,
  CONSTRAINT `fk_entrenador_equipo1`
    FOREIGN KEY (`id_equipo` )
    REFERENCES `equipo` (`id_equipo` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `entrenador_idx` ON `entrenador` (`nombres_entrenador` ASC, `apellidos_entrenador` ASC) ;

CREATE INDEX `fk_entrenador_equipo1_idx` ON `entrenador` (`id_equipo` ASC) ;

CREATE INDEX `entrenador_equipo_idx` ON `entrenador` (`id_entrenador` ASC, `id_equipo` ASC) ;


-- -----------------------------------------------------
-- Table `historico_entrenadores`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `historico_entrenadores` ;

CREATE  TABLE IF NOT EXISTS `historico_entrenadores` (
  `id_equipo` INT NOT NULL ,
  `id_entrenador` INT NOT NULL ,
  `salario_historico_entrenadores` DOUBLE NOT NULL ,
  `año_historico_entrenadores` INT NOT NULL ,
  PRIMARY KEY (`id_equipo`, `id_entrenador`) ,
  CONSTRAINT `fk_historico_entrenadores_equipo1`
    FOREIGN KEY (`id_equipo` )
    REFERENCES `equipo` (`id_equipo` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_historico_entrenadores_entrenador1`
    FOREIGN KEY (`id_entrenador` )
    REFERENCES `entrenador` (`id_entrenador` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `salario_idx` ON `historico_entrenadores` (`id_entrenador` ASC, `id_equipo` ASC, `salario_historico_entrenadores` ASC) ;

CREATE INDEX `fk_historico_entrenadores_equipo1_idx` ON `historico_entrenadores` (`id_equipo` ASC) ;

CREATE INDEX `fk_historico_entrenadores_entrenador1_idx` ON `historico_entrenadores` (`id_entrenador` ASC) ;

CREATE INDEX `historico_entrenadores_idx` ON `historico_entrenadores` (`id_entrenador` ASC, `id_equipo` ASC) ;


-- -----------------------------------------------------
-- Table `jugador`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `jugador` ;

CREATE  TABLE IF NOT EXISTS `jugador` (
  `id_jugador` INT NOT NULL AUTO_INCREMENT ,
  `id_equipo` INT NOT NULL ,
  `nombres_jugador` VARCHAR(45) NOT NULL ,
  `apellidos_jugador` VARCHAR(45) NOT NULL ,
  `nacionalidad_jugador` VARCHAR(45) NOT NULL ,
  `fechaNacimiento_jugador` DATETIME NOT NULL ,
  `edad_jugador` INT NULL ,
  `numero_jugador` INT NOT NULL ,
  `salario_jugador` DOUBLE NULL ,
  `goles_jugador` INT NULL DEFAULT 0,
  PRIMARY KEY (`id_jugador`) ,
  CONSTRAINT `fk_jugador_equipo1`
    FOREIGN KEY (`id_equipo` )
    REFERENCES `equipo` (`id_equipo` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `jugador_idx` ON `jugador` (`nombres_jugador` ASC, `apellidos_jugador` ASC) ;

CREATE INDEX `nacionalidad_jugador_idx` ON `jugador` (`nombres_jugador` ASC, `apellidos_jugador` ASC, `nacionalidad_jugador` ASC) ;

CREATE INDEX `numero_jugador_idx` ON `jugador` (`nombres_jugador` ASC, `apellidos_jugador` ASC, `numero_jugador` ASC) ;

CREATE INDEX `fk_jugador_equipo1_idx` ON `jugador` (`id_equipo` ASC) ;


-- -----------------------------------------------------
-- Table `historico_jugadores`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `historico_jugadores` ;

CREATE  TABLE IF NOT EXISTS `historico_jugadores` (
  `id_equipo` INT NOT NULL ,
  `id_jugador` INT NOT NULL ,
  `año_historico_jugadores` INT NOT NULL ,
  `numero_historico_jugadores` INT NOT NULL ,
  `goles_historico` INT NOT NULL ,
  `salario_jugador` DOUBLE NULL ,
  PRIMARY KEY (`id_equipo`, `id_jugador`) ,
  CONSTRAINT `fk_historico_jugadores_equipo1`
    FOREIGN KEY (`id_equipo` )
    REFERENCES `equipo` (`id_equipo` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_historico_jugadores_jugador1`
    FOREIGN KEY (`id_jugador` )
    REFERENCES `jugador` (`id_jugador` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `numero_historio_idx` ON `historico_jugadores` (`id_jugador` ASC, `id_equipo` ASC, `numero_historico_jugadores` ASC) ;

CREATE INDEX `fk_historico_jugadores_equipo1_idx` ON `historico_jugadores` (`id_equipo` ASC) ;

CREATE INDEX `fk_historico_jugadores_jugador1_idx` ON `historico_jugadores` (`id_jugador` ASC) ;

CREATE INDEX `historico_jugadores_dx` ON `historico_jugadores` (`id_equipo` ASC, `id_jugador` ASC) ;


-- -----------------------------------------------------
-- Table `campeonato`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `campeonato` ;

CREATE  TABLE IF NOT EXISTS `campeonato` (
  `id_campeonato` INT NOT NULL AUTO_INCREMENT,
  `año` INT NOT NULL ,
  `semestre` INT NOT NULL ,
  PRIMARY KEY (`id_campeonato`) )
ENGINE = InnoDB;

CREATE INDEX `campeonato_idx` ON `campeonato` (`año` ASC, `semestre` ASC) ;


-- -----------------------------------------------------
-- Table `partido`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `partido` ;

CREATE  TABLE IF NOT EXISTS `partido` (
  `id_partido` INT NOT NULL AUTO_INCREMENT,
  `fecha_partido` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  `ciudad_partido` VARCHAR(45) NOT NULL ,
  `estadio` VARCHAR(45) NOT NULL ,
  `goles_local` INT NOT NULL ,
  `goles_visitante` INT NOT NULL ,
  `id_local` INT NOT NULL ,
  `id_visitante` INT NOT NULL ,
  `id_campeonato` INT NOT NULL ,
  PRIMARY KEY (`id_partido`) ,
  CONSTRAINT `id_local`
    FOREIGN KEY (`id_local` )
    REFERENCES `equipo` (`id_equipo` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_visitante`
    FOREIGN KEY (`id_visitante` )
    REFERENCES `equipo` (`id_equipo` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_campeonato`
    FOREIGN KEY (`id_campeonato` )
    REFERENCES `campeonato` (`id_campeonato` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `id_local_idx` ON `partido` (`id_local` ASC) ;

CREATE INDEX `id_visitante_idx` ON `partido` (`id_visitante` ASC) ;

CREATE INDEX `fecha_estadio_partido_idx` ON `partido` (`fecha_partido` ASC, `estadio` ASC) ;

CREATE INDEX `ciudad_idx` ON `partido` (`id_partido` ASC, `ciudad_partido` ASC) ;

CREATE INDEX `id_campeonato_idx` ON `partido` (`id_campeonato` ASC) ;

CREATE INDEX `contrincantes_idx` ON `partido` (`id_local` ASC, `id_visitante` ASC) ;


-- -----------------------------------------------------
-- Table `gol`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `gol` ;

CREATE  TABLE IF NOT EXISTS `gol` (
  `id_gol` INT NOT NULL AUTO_INCREMENT,
  `id_partido` INT NOT NULL ,
  `id_jugador` INT NOT NULL ,
  `minuto` INT NOT NULL ,
  `tipo_gol` VARCHAR(45) NULL ,
  PRIMARY KEY (`id_gol`) ,
  CONSTRAINT `id_partido`
    FOREIGN KEY (`id_partido` )
    REFERENCES `partido` (`id_partido` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_jugador`
    FOREIGN KEY (`id_jugador` )
    REFERENCES `jugador` (`id_jugador` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE INDEX `id_jugador_idx` ON `gol` (`id_jugador` ASC) ;

CREATE INDEX `gol_idx` ON `gol` (`id_partido` ASC, `id_jugador` ASC) ;

CREATE INDEX `gol_jugador_idx` ON `gol` (`id_jugador` ASC, `tipo_gol` ASC) ;


-- -----------------------------------------------------
-- Table `arbitro`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `arbitro` ;

CREATE  TABLE IF NOT EXISTS `arbitro` (
  `id_arbitro` INT NOT NULL AUTO_INCREMENT ,
  `nombre_arbitro` VARCHAR(45) NOT NULL ,
  `apellido_arbitro` VARCHAR(45) NOT NULL ,
  `tipo_arbitro` VARCHAR(45) NULL ,
  PRIMARY KEY (`id_arbitro`) )
ENGINE = InnoDB;

CREATE INDEX `arbitro_idx` ON `arbitro` (`nombre_arbitro` ASC, `apellido_arbitro` ASC) ;

CREATE INDEX `tipo_arbitro_idx` ON `arbitro` (`nombre_arbitro` ASC, `apellido_arbitro` ASC, `tipo_arbitro` ASC) ;


-- -----------------------------------------------------
-- Table `posicion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `posicion` ;

CREATE  TABLE IF NOT EXISTS `posicion` (
  `id_campeonato` INT NOT NULL ,
  `id_equipo` INT NOT NULL ,
  `pos` INT NOT NULL DEFAULT 1 ,
  `puntaje` INT NOT NULL DEFAULT 0 ,
  `goles_favor` INT NOT NULL DEFAULT 0,
  `goles_contra` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`id_campeonato`, `id_equipo`) ,
  CONSTRAINT `id_campeonato_posicion`
    FOREIGN KEY (`id_campeonato` )
    REFERENCES `campeonato` (`id_campeonato` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_equipo_posicion`
    FOREIGN KEY (`id_equipo` )
    REFERENCES `equipo` (`id_equipo` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `id_campeonato_idx` ON `posicion` (`id_campeonato` ASC) ;

CREATE INDEX `id_equipo_idx` ON `posicion` (`id_equipo` ASC) ;

CREATE INDEX `posicion_idx` ON `posicion` (`id_equipo` ASC, `pos` ASC) ;

CREATE INDEX `equipo_campeonato_idx` ON `posicion` (`id_equipo` ASC, `id_campeonato` ASC) ;


-- -----------------------------------------------------
-- Table `historico_tecnico`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `historico_tecnico` ;

CREATE  TABLE IF NOT EXISTS `historico_tecnico` (
  `id_equipo` INT NOT NULL ,
  `id_tecnico` INT NOT NULL ,
  `telefono_tecnico` VARCHAR(45) NOT NULL ,
  `experiencia_tecnico` INT NULL ,
  `salario_tecnico` DOUBLE NULL,
  PRIMARY KEY (`id_equipo`, `id_tecnico`) ,
  CONSTRAINT `fk_historico_tecnico_equipo1`
    FOREIGN KEY (`id_equipo` )
    REFERENCES `equipo` (`id_equipo` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_historico_tecnico_tecnico1`
    FOREIGN KEY (`id_tecnico` )
    REFERENCES `tecnico` (`id_tecnico` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_historico_tecnico_equipo1_idx` ON `historico_tecnico` (`id_equipo` ASC) ;

CREATE INDEX `fk_historico_tecnico_tecnico1_idx` ON `historico_tecnico` (`id_tecnico` ASC) ;

CREATE INDEX `historico_entrenadores_idx` ON `historico_tecnico` (`id_tecnico` ASC, `id_equipo` ASC) ;


-- -----------------------------------------------------
-- Table `arbitro_partido`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `arbitro_partido` ;

CREATE  TABLE IF NOT EXISTS `arbitro_partido` (
  `id_arbitro` INT NOT NULL ,
  `id_partido` INT NOT NULL ,
  PRIMARY KEY (`id_arbitro`, `id_partido`) ,
  CONSTRAINT `id_arbitro_partido`
    FOREIGN KEY (`id_arbitro` )
    REFERENCES `arbitro` (`id_arbitro` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_partido_partido`
    FOREIGN KEY (`id_partido` )
    REFERENCES `partido` (`id_partido` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `id_arbitro_idx` ON `arbitro_partido` (`id_arbitro` ASC) ;

CREATE INDEX `id_partido_idx` ON `arbitro_partido` (`id_partido` ASC) ;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
