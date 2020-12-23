

CREATE TABLE IF NOT EXISTS `mydb`.`Nagrody` (
  `IdNagrody` INT NOT NULL,
  `Rodzaj` VARCHAR(45) NULL,
  `Ilosc` VARCHAR(45) NULL,
  `KosztProdukcji` VARCHAR(45) NULL,
  PRIMARY KEY (`IdNagrody`))





CREATE TABLE IF NOT EXISTS `mydb`.`Maratony` (
  `idMaratony` INT NOT NULL,
  `NazwaMaratonu` VARCHAR(45) NULL,
  `Data` DATE NULL,
  `Miejsce` VARCHAR(45) NULL,
  `IloscZawodnikow` INT NULL,
  `Nagrody_IdNagrody` INT NOT NULL,
  PRIMARY KEY (`idMaratony`),
  INDEX `fk_Maratony_Nagrody1_idx` (`Nagrody_IdNagrody` ASC) VISIBLE,
  CONSTRAINT `fk_Maratony_Nagrody1`
    FOREIGN KEY (`Nagrody_IdNagrody`)
    REFERENCES `mydb`.`Nagrody` (`IdNagrody`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)


CREATE TABLE IF NOT EXISTS `mydb`.`Kluby` (
  `idKluby` INT NOT NULL,
  `Nazwa` VARCHAR(45) NULL,
  `Miejscowosc` VARCHAR(45) NULL,
  `IloscCzlonkow` INT NULL,
  PRIMARY KEY (`idKluby`))




CREATE TABLE IF NOT EXISTS `mydb`.`Zawodnicy` (
  `idZawodnicy` INT NOT NULL,
  `Imie` VARCHAR(45) NULL,
  `Nazwisko` VARCHAR(45) NULL,
  `Pesel` INT NULL,
  `UlicaZamieszkania` VARCHAR(45) NULL,
  `KodPocztowy` VARCHAR(45) NULL,
  `Miejscowosc` VARCHAR(45) NULL,
  `StatusPlatnosci` TINYINT NULL,
  `Kluby_idKluby` INT NOT NULL,
  PRIMARY KEY (`idZawodnicy`),
  INDEX `fk_Zawodnicy_Kluby1_idx` (`Kluby_idKluby` ASC) VISIBLE,
  CONSTRAINT `fk_Zawodnicy_Kluby1`
    FOREIGN KEY (`Kluby_idKluby`)
    REFERENCES `mydb`.`Kluby` (`idKluby`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)



-- -----------------------------------------------------
-- Table `mydb`.`Cennik`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Cennik` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Cennik` (
  `Cena` VARCHAR(45) NULL,
  `IloscSprzedanychBiletow` VARCHAR(45) NULL,
  `IloscOplaconychBiletow` VARCHAR(45) NULL,
  `Maratony_idMaratony` INT NOT NULL,
  INDEX `fk_Cennik_Maratony1_idx` (`Maratony_idMaratony` ASC) VISIBLE,
  CONSTRAINT `fk_Cennik_Maratony1`
    FOREIGN KEY (`Maratony_idMaratony`)
    REFERENCES `mydb`.`Maratony` (`idMaratony`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)





CREATE TABLE IF NOT EXISTS `mydb`.`Szczegóły_udziału` (
  `Maratony_idMaratony` INT NOT NULL,
  `Zawodnicy_idZawodnicy` INT NOT NULL,
  INDEX `fk_Szczegóły_udziału_Maratony1_idx` (`Maratony_idMaratony` ASC) VISIBLE,
  INDEX `fk_Szczegóły_udziału_Zawodnicy1_idx` (`Zawodnicy_idZawodnicy` ASC) VISIBLE,
  CONSTRAINT `fk_Szczegóły_udziału_Maratony1`
    FOREIGN KEY (`Maratony_idMaratony`)
    REFERENCES `mydb`.`Maratony` (`idMaratony`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Szczegóły_udziału_Zawodnicy1`
    FOREIGN KEY (`Zawodnicy_idZawodnicy`)
    REFERENCES `mydb`.`Zawodnicy` (`idZawodnicy`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)





CREATE TABLE IF NOT EXISTS `mydb`.`Wyniki` (
  `idWyniki` INT NOT NULL,
  `Zajęte_miejsce` VARCHAR(45) NULL,
  `Data` DATE NULL,
  `Maratony_idMaratony` INT NOT NULL,
  `Zawodnicy_idZawodnicy` INT NOT NULL,
  PRIMARY KEY (`idWyniki`),
  INDEX `fk_Wyniki_Maratony1_idx` (`Maratony_idMaratony` ASC) VISIBLE,
  INDEX `fk_Wyniki_Zawodnicy1_idx` (`Zawodnicy_idZawodnicy` ASC) VISIBLE,
  CONSTRAINT `fk_Wyniki_Maratony1`
    FOREIGN KEY (`Maratony_idMaratony`)
    REFERENCES `mydb`.`Maratony` (`idMaratony`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Wyniki_Zawodnicy1`
    FOREIGN KEY (`Zawodnicy_idZawodnicy`)
    REFERENCES `mydb`.`Zawodnicy` (`idZawodnicy`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)





CREATE TABLE IF NOT EXISTS `mydb`.`Wyniki` (
  `idWyniki` INT NOT NULL,
  `Zajęte_miejsce` VARCHAR(45) NULL,
  `Data` DATE NULL,
  `Maratony_idMaratony` INT NOT NULL,
  `Zawodnicy_idZawodnicy` INT NOT NULL,
  PRIMARY KEY (`idWyniki`),
  INDEX `fk_Wyniki_Maratony1_idx` (`Maratony_idMaratony` ASC) VISIBLE,
  INDEX `fk_Wyniki_Zawodnicy1_idx` (`Zawodnicy_idZawodnicy` ASC) VISIBLE,
  CONSTRAINT `fk_Wyniki_Maratony1`
    FOREIGN KEY (`Maratony_idMaratony`)
    REFERENCES `mydb`.`Maratony` (`idMaratony`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Wyniki_Zawodnicy1`
    FOREIGN KEY (`Zawodnicy_idZawodnicy`)
    REFERENCES `mydb`.`Zawodnicy` (`idZawodnicy`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
//FUNKCJA 
CREATE DEFINER=`rutkowskin`@`localhost` FUNCTION `przychod_maratonu`() RETURNS int
BEGIN
DECLARE zarobek INT;
SELECT SUM(Cena*IloscOplaconychBiletow) INTO @zarobek FROM Cennik;
RETURN @zarobek;
END
//FUNKCJA
CREATE DEFINER=`rutkowskin`@`localhost` FUNCTION `wygrani`() RETURNS int
BEGIN
 DECLARE wygrani INT;
 SELECT Zawodnicy_idZawodnicy INTO @wygrani FROM Wyniki WHERE Zajęte_miejsce='1' limit 1;
 RETURN @wygrani;
 END
 //TRIGGER
 DELIMITER //
 CREATE TRIGGER bieganie BEFORE INSERT ON Zawodnicy
 FOR EACH ROW
 BEGIN
 IF NEW.StatusPlatnosci=0 THEN SET NEW.kluby_idKluby=0;
 END IF;
 END//
 DELIMIITER ;
 //PROCEDURA 
 CREATE DEFINER=`rutkowskin`@`localhost` PROCEDURE `rezygnacja`(IN id INT)
BEGIN
DELETE FROM Zawodnicy WHERE idZawodnicy =id;
END
//PROCEDURA
CREATE DEFINER=`rutkowskin`@`localhost` PROCEDURE `opłata`(in id int)
begin
update Zawodnicy set StatusPlatnosci =1 where idZawodnicy=id ;
end


