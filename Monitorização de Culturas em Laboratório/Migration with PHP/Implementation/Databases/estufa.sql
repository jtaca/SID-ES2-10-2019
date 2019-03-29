-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 30, 2019 at 12:27 AM
-- Server version: 10.1.37-MariaDB
-- PHP Version: 7.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `estufa`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `addUser` (IN `var_role` ENUM('investigador  ','administrador','sensorLuminosidade','sensorTemperatura'), IN `var_nome` VARCHAR(50), IN `var_password` VARCHAR(50), IN `var_email` VARCHAR(100), IN `var_categoria_profissional` VARCHAR(100))  BEGIN

	IF (SELECT EXISTS( SELECT * FROM mysql.user WHERE `email` =  var_email))=0 THEN

        DROP USER IF EXISTS ''@localhost;

        SET @sql := CONCAT('CREATE USER ', QUOTE(var_nome), ' IDENTIFIED BY ', QUOTE(var_password));
        PREPARE statement FROM @sql;
        EXECUTE statement;

        SET @sql := CONCAT('GRANT ', var_role, ' TO ', QUOTE(var_nome));
        PREPARE statement FROM @sql;
        EXECUTE statement;

        SET @sql := CONCAT('SET DEFAULT ROLE ', var_role ,' FOR ', 		QUOTE(var_nome));
        PREPARE statement FROM @sql;
        EXECUTE statement;

        SET @sql := CONCAT('UPDATE mysql.user SET email = ', QUOTE(var_email),' WHERE User=',QUOTE(var_nome));
        PREPARE statement FROM @sql;
        EXECUTE statement;

        SET @sql := CONCAT('INSERT INTO investigador SET email=', QUOTE(var_email),', nomeinvestigador=', QUOTE(var_nome),', categoriaprofissional=', QUOTE(var_categoria_profissional));
        PREPARE statement FROM @sql;
        EXECUTE statement;

        DEALLOCATE PREPARE statement;
        FLUSH PRIVILEGES;
    
    END IF;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `alterarLimitesLuz` (IN `limiteInferior` DOUBLE(8,2), IN `limiteSuperior` DOUBLE(8,2))  NO SQL
IF EXISTS(select * from sistema) THEN
	UPDATE sistema SET LimiteInferiorLuz = limiteInferior, LimiteSuperiorLuz = limiteSuperior WHERE 1;
ELSE
	INSERT INTO sistema VALUES (0, 0, limiteInferior, limiteSuperior);
END IF$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `alterarLimitesTemperatura` (IN `limiteInferior` DOUBLE(8,2), IN `limiteSuperior` DOUBLE(8,2))  NO SQL
IF EXISTS(select * from sistema) THEN
	UPDATE sistema SET sistema.LimiteInferiorTemperatura = limiteInferior, sistema.LimiteSuperiorTemperatura = limiteSuperior;
ELSE
	INSERT INTO sistema VALUES (limiteInferior, limiteSuperior, 0, 0);
END IF$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `alterarValorMedido` (IN `IdVar` INT(11), IN `novoValor` DECIMAL(8,2))  UPDATE medicoes SET medicoes.ValorMedicao = novoValor WHERE medicoes.NumeroMedicao = IdVar$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `apagarCultura` (IN `id` INT(11))  DELETE FROM `cultura` WHERE cultura.IDCultura=id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `apagarMedicao` (IN `id` INT(11))  DELETE FROM `medicoes` WHERE medicoes.NumeroMedicao=id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `createPhpUser` ()  BEGIN
DROP USER IF EXISTS ''@localhost;
SET @sql := CONCAT('CREATE USER ', 'php', ' IDENTIFIED BY ', QUOTE('php'));
    PREPARE statement FROM @sql;
    EXECUTE statement;
    
    SET @sql := CONCAT('GRANT ', 'phpUser', ' TO ', QUOTE('php'));
    PREPARE statement FROM @sql;
    EXECUTE statement;
    
    SET @sql := CONCAT('SET DEFAULT ROLE ', 'phpUser' ,' FOR ', 		QUOTE('php'));
    PREPARE statement FROM @sql;
    EXECUTE statement;

    DEALLOCATE PREPARE statement;
    FLUSH PRIVILEGES;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `criarPrivilegios` ()  BEGIN

GRANT SELECT ON estufa.logs TO phpUser;
GRANT EXECUTE ON PROCEDURE estufa.selectDadosNaoMigrados TO phpUser;
GRANT EXECUTE ON PROCEDURE estufa.updateMigrados TO phpUser;



GRANT SELECT ON estufa.medicoes_luminosidade TO investigador;
GRANT SELECT ON estufa.medicoes_temperatura TO investigador;

GRANT INSERT ON estufa.medicoes_temperatura TO sensorTemperatura;
GRANT INSERT ON estufa.medicoes_luminosidade TO sensorLuminosidade;


GRANT SELECT,INSERT, UPDATE, DELETE ON estufa.sistema TO administrador,investigador;
GRANT SELECT,INSERT, UPDATE, DELETE ON estufa.variaveis TO administrador,investigador;
GRANT SELECT,INSERT, UPDATE, DELETE ON estufa.investigador TO administrador,investigador;
GRANT SELECT,INSERT, UPDATE, DELETE ON estufa.medicoes TO administrador,investigador;
GRANT SELECT,INSERT, UPDATE, DELETE ON estufa.sistema TO administrador,investigador;
GRANT SELECT,INSERT, UPDATE, DELETE ON estufa.cultura TO administrador,investigador;
GRANT SELECT,INSERT, UPDATE, DELETE ON estufa.sistema TO administrador,investigador;

GRANT SELECT,INSERT, UPDATE, DELETE ON estufa.medicoes_temperatura TO administrador;
GRANT SELECT,INSERT, UPDATE, DELETE ON estufa.medicoes_luminosidade TO administrador;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `criarPrivilegiosExecute` ()  BEGIN

GRANT EXECUTE ON PROCEDURE estufa.apagarCultura TO administrador,investigador;
GRANT EXECUTE ON PROCEDURE estufa.apagarMedicao TO administrador,investigador;
GRANT EXECUTE ON PROCEDURE estufa.addUser TO administrador;
GRANT EXECUTE ON PROCEDURE estufa.alterarLimitesLuz TO administrador;
GRANT EXECUTE ON PROCEDURE estufa.alterarLimitesTemperatura TO administrador;
GRANT EXECUTE ON PROCEDURE estufa.alterarValorMedido TO administrador,investigador;
GRANT EXECUTE ON PROCEDURE estufa.createPhpUser TO administrador;
GRANT EXECUTE ON PROCEDURE estufa.criarPrivilegios TO administrador;
GRANT EXECUTE ON PROCEDURE estufa.criarRoles TO administrador;
GRANT EXECUTE ON PROCEDURE estufa.deleteUser TO administrador;
GRANT EXECUTE ON PROCEDURE estufa.init TO administrador;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `criarRoles` ()  CREATE ROLE IF NOT EXISTS investigador, administrador, sensorLuminosidade, sensorTemperatura,  phpUser$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteUser` (IN `var_email` VARCHAR(100))  NO SQL
BEGIN

SET @sql := CONCAT('SELECT User INTO @user FROM mysql.user WHERE email = ', QUOTE(var_email));
PREPARE statement FROM @sql;
EXECUTE statement;

SET @sql := CONCAT('DROP USER IF EXISTS ', @user);
PREPARE statement FROM @sql;
EXECUTE statement;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `init` ()  BEGIN

	CALL criarRoles;
 
    CALL criarPrivilegios;
    
   CALL criarPrivilegiosExecute;
    

	ALTER TABLE mysql.user ADD COLUMN IF NOT EXISTS email varchar(100) UNIQUE;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `selectDadosNaoMigrados` ()  SELECT * FROM logs WHERE logs.exportado=0$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `selectMedicoes` (IN `var_condicao` VARCHAR(200))  NO SQL
BEGIN  

	IF var_condicao = "" THEN 
    	SET var_condicao = "1=1";
        SELECT "Dentro IF";
    END IF;

	SET @sql := CONCAT('INSERT INTO estufa.logs VALUES (null, CURRENT_USER, "medicoes", "SELECT", "Não Aplicável", "', var_condicao,'", NOW(), 0)');
    PREPARE statement FROM @sql;
    EXECUTE statement;

	SET @sql := CONCAT('SELECT * FROM estufa.medicoes WHERE ', var_condicao);
    PREPARE statement FROM @sql;
    EXECUTE statement; 

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateMigrados` (IN `endID` INT(50))  UPDATE logs SET logs.exportado=1 WHERE logs.logId<=endID$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `cultura`
--

CREATE TABLE `cultura` (
  `IDCultura` int(11) NOT NULL,
  `NomeCultura` varchar(100) NOT NULL,
  `DescricaoCultura` text,
  `EmailInvestigador` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `cultura`
--

INSERT INTO `cultura` (`IDCultura`, `NomeCultura`, `DescricaoCultura`, `EmailInvestigador`) VALUES
(1, 'cenouras', 'Daucus carota subsp. sativus ', 'lala@gmail.com');

--
-- Triggers `cultura`
--
DELIMITER $$
CREATE TRIGGER `deleteCultura` AFTER DELETE ON `cultura` FOR EACH ROW INSERT into logs VALUES (null, CURRENT_USER, "cultura", "DELETE", CONCAT("IdCultura", ": ", old.IdCultura, "  NomeCultura", ": ", old.NomeCultura, "  DescricaoCultura", ": ", old.DescricaoCultura, "  EmailInvestigador", ": ", old.EmailInvestigador), "Linha Eliminada", NOW(), 0)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertCultura` AFTER INSERT ON `cultura` FOR EACH ROW INSERT into logs VALUES (null, CURRENT_USER, "cultura", "INSERT", "Não Aplicável", CONCAT("IdCultura", ": ", new.IdCultura, "  NomeCultura", ": ", new.NomeCultura, "  DescricaoCultura", ": ", new.DescricaoCultura, "  EmailInvestigador", ": ", new.EmailInvestigador), NOW(),0)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `updateCultura` AFTER UPDATE ON `cultura` FOR EACH ROW INSERT into logs VALUES (null, CURRENT_USER, "cultura", "UPDATE", CONCAT("IdCultura", ": ", old.IdCultura, "  NomeCultura", ": ", old.NomeCultura, "  DescricaoCultura", ": ", old.DescricaoCultura, "  EmailInvestigador", ": ", old.EmailInvestigador), CONCAT("IdCultura", ": ", new.IdCultura, "  NomeCultura", ": ", new.NomeCultura, "  DescricaoCultura", ": ", new.DescricaoCultura, "  EmailInvestigador", ": ", new.EmailInvestigador), NOW(), 0)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `investigador`
--

CREATE TABLE `investigador` (
  `Email` varchar(50) NOT NULL,
  `NomeInvestigador` varchar(100) NOT NULL,
  `CategoriaProfissional` varchar(300) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `investigador`
--

INSERT INTO `investigador` (`Email`, `NomeInvestigador`, `CategoriaProfissional`) VALUES
('a', 'a', 'a'),
('a.@b.c', 'Alberto', 'wer'),
('a@b.c', 'qwer', 'nao sei'),
('abc', 'El Chap', 'abc'),
('aDFSDFV', 'sfdafd', 'sadsd'),
('afga', 'asddsa', 'wcafdv'),
('b', 'b', 'b'),
('c', 'c', 'c'),
('eumail', 'eu', 'sadad'),
('jonas@gmail.com', 'jonas', 'programador'),
('lala@gmail.com', 'wqser', 'qwer'),
('p@p.p', 'pipu', '0'),
('qwe', 'sens', 'asd'),
('qwerty', 'boneca', 'asdfg'),
('sdfvsdfvc', 'adscfsad', 'sfcvsfdcv'),
('v', 'v', 'v'),
('y', 'y', 'y');

--
-- Triggers `investigador`
--
DELIMITER $$
CREATE TRIGGER `deleteInvestigador` AFTER DELETE ON `investigador` FOR EACH ROW INSERT into logs VALUES (null, CURRENT_USER, "investigador", "DELETE", CONCAT("Email", ": ", old.Email, "  NomeInvestigador", ": ", old.NomeInvestigador, "  CategoriaProfissional", ": ", old.CategoriaProfissional), "Linha Eliminada", NOW(), 0)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertInsvestigador` AFTER INSERT ON `investigador` FOR EACH ROW INSERT into logs VALUES (null, CURRENT_USER, "investigador", "INSERT", "Não Aplicável", CONCAT("Email", ": ", new.Email, "  NomeInvestigador", ": ", new.NomeInvestigador, "  CategoriaProfissional", ": ", new.CategoriaProfissional), NOW(),0)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `updateInvestigador` AFTER UPDATE ON `investigador` FOR EACH ROW INSERT into logs VALUES (null, CURRENT_USER, "investigador", "UPDATE", CONCAT("Email", ": ", old.Email, "  NomeInvestigador", ": ", old.NomeInvestigador, "  CategoriaProfissional", ": ", old.CategoriaProfissional), CONCAT("Email", ": ", new.Email, "  NomeInvestigador", ": ", new.NomeInvestigador, "  CategoriaProfissional", ": ", new.CategoriaProfissional), NOW(), 0)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

CREATE TABLE `logs` (
  `logId` int(11) NOT NULL,
  `username` varchar(80) NOT NULL,
  `nomeTabela` varchar(200) NOT NULL,
  `comandoUsado` varchar(200) NOT NULL,
  `linhaAnterior` varchar(200) NOT NULL,
  `resultado` varchar(200) NOT NULL,
  `dataComando` varchar(200) NOT NULL,
  `exportado` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `logs`
--

INSERT INTO `logs` (`logId`, `username`, `nomeTabela`, `comandoUsado`, `linhaAnterior`, `resultado`, `dataComando`, `exportado`) VALUES
(2, 'root@localhost', 'medicoes_luminosidade', 'DELETE', 'DataHoraMedicao: 2019-03-05 00:22:37  ValorMedicaoLuminosidade: 20.67  IDMedicao: 1', 'Linha Eliminada', '2019-03-05 00:22:56', 1),
(3, 'root@localhost', 'medicoes', 'SELECT', 'Não Aplicável', 'Não Aplicável', '2019-03-06 00:26:58', 1),
(4, 'root@localhost', 'medicoes', 'SELECT', 'Não Aplicável', 'Não Aplicável', '2019-03-06 00:28:09', 1),
(5, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: lala@gmail.com  NomeInvestigador: wqser  CategoriaProfissional: qwer', '2019-03-14 14:01:00', 0),
(6, 'root@localhost', 'cultura', 'INSERT', 'Não Aplicável', 'IdCultura: 1  NomeCultura: cenouras  DescricaoCultura: Daucus carota subsp. sativus   EmailInvestigador: lala@gmail.com', '2019-03-14 14:01:58', 0),
(7, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 1  NomeVariavel: pH', '2019-03-14 14:02:13', 0),
(8, 'root@localhost', 'variaveis_medidas', 'INSERT', 'Não Aplicável', 'IDVariavel: 1  IDCultura: 1  LimiteInferior: 3.00  LimiteSuperior: 7.00  IdVariaveisMedidas: 1', '2019-03-14 14:03:56', 0),
(9, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 1  DataHoraMedicao: 2019-03-14 14:04:11  ValorMedicao: 4.00  IdVariaveisMedidas: 1', '2019-03-14 14:04:11', 0),
(10, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 1  DataHoraMedicao: 2019-03-14 14:04:11  ValorMedicao: 4.00  IdVariaveisMedidas: 1', 'NumeroMedicao: 1  DataHoraMedicao: 2019-03-14 14:05:52  ValorMedicao: 5.00  IdVariaveisMedidas: 1', '2019-03-14 14:05:52', 0),
(11, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 2  DataHoraMedicao: 2019-03-14 14:07:34  ValorMedicao: 6.00  IdVariaveisMedidas: 1', '2019-03-14 14:07:34', 0),
(12, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 2  DataHoraMedicao: 2019-03-14 14:07:34  ValorMedicao: 6.00  IdVariaveisMedidas: 1', 'NumeroMedicao: 2  DataHoraMedicao: 2019-03-14 14:09:00  ValorMedicao: 23233.00  IdVariaveisMedidas: 1', '2019-03-14 14:09:00', 0),
(13, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: a@b.c  NomeInvestigador: qwer  CategoriaProfissional: nao sei', '2019-03-15 19:23:05', 0),
(14, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: p@p.p  NomeInvestigador: pipu  CategoriaProfissional: 0', '2019-03-15 19:27:25', 0),
(15, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: jonas@gmail.com  NomeInvestigador: jonas  CategoriaProfissional: programador', '2019-03-15 19:28:52', 0),
(16, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: a.@b.c  NomeInvestigador: Alberto  CategoriaProfissional: wer', '2019-03-18 20:07:38', 0),
(17, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: abc  NomeInvestigador: El Chap  CategoriaProfissional: abc', '2019-03-18 20:09:27', 0),
(18, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: qwe  NomeInvestigador: sens  CategoriaProfissional: asd', '2019-03-18 23:09:58', 0),
(19, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: eumail  NomeInvestigador: eu  CategoriaProfissional: sadad', '2019-03-18 23:24:58', 0),
(20, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: afga  NomeInvestigador: asddsa  CategoriaProfissional: wcafdv', '2019-03-18 23:25:24', 0),
(21, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: aDFSDFV  NomeInvestigador: sfdafd  CategoriaProfissional: sadsd', '2019-03-18 23:26:34', 0),
(22, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: sdfvsdfvc  NomeInvestigador: adscfsad  CategoriaProfissional: sfcvsfdcv', '2019-03-18 23:28:04', 0),
(23, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: qwerty  NomeInvestigador: boneca  CategoriaProfissional: asdfg', '2019-03-18 23:49:37', 0),
(24, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: a  NomeInvestigador: a  CategoriaProfissional: a', '2019-03-19 00:17:37', 0),
(25, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: b  NomeInvestigador: b  CategoriaProfissional: b', '2019-03-19 00:49:06', 0),
(26, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: c  NomeInvestigador: c  CategoriaProfissional: c', '2019-03-19 00:49:50', 0),
(27, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: v  NomeInvestigador: v  CategoriaProfissional: v', '2019-03-19 01:02:05', 0),
(28, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: y  NomeInvestigador: y  CategoriaProfissional: y', '2019-03-19 01:04:33', 0),
(29, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 2  DataHoraMedicao: 2019-03-14 14:09:00  ValorMedicao: 23233.00  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-03-19 10:16:43', 0),
(30, 'root@localhost', 'medicoes', 'SELECT', '1', 'Não Aplicável', '2019-03-29 18:25:26', 0),
(31, 'root@localhost', 'medicoes', 'SELECT', '1', 'Não Aplicável', '2019-03-29 18:25:39', 0),
(32, 'root@localhost', 'medicoes', 'SELECT', '1', 'Não Aplicável', '2019-03-29 18:25:56', 0),
(33, 'root@localhost', 'medicoes', 'SELECT', '1', 'Não Aplicável', '2019-03-29 18:26:09', 0),
(34, 'root@localhost', 'medicoes', 'SELECT', '1', 'Não Aplicável', '2019-03-29 18:28:01', 0),
(35, 'root@localhost', 'medicoes', 'SELECT', '1', 'Não Aplicável', '2019-03-29 18:28:14', 0),
(36, 'root@localhost', 'medicoes', 'SELECT', '1', 'Não Aplicável', '2019-03-29 18:31:32', 0),
(37, 'root@localhost', 'medicoes', 'SELECT', '1', 'Não Aplicável', '2019-03-29 18:32:59', 0),
(38, 'root@localhost', 'medicoes', 'SELECT', '1=1', 'Não Aplicável', '2019-03-29 18:34:14', 0),
(39, 'root@localhost', 'medicoes', 'SELECT', '1=0', 'Não Aplicável', '2019-03-29 18:34:33', 0),
(40, 'root@localhost', 'medicoes', 'SELECT', '1=123', 'Não Aplicável', '2019-03-29 18:50:52', 0);

-- --------------------------------------------------------

--
-- Table structure for table `medicoes`
--

CREATE TABLE `medicoes` (
  `NumeroMedicao` int(11) NOT NULL,
  `DataHoraMedicao` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ValorMedicao` decimal(8,2) NOT NULL,
  `IdVariaveisMedidas` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `medicoes`
--

INSERT INTO `medicoes` (`NumeroMedicao`, `DataHoraMedicao`, `ValorMedicao`, `IdVariaveisMedidas`) VALUES
(1, '2019-03-14 14:05:52', '5.00', 1);

--
-- Triggers `medicoes`
--
DELIMITER $$
CREATE TRIGGER `deleteMedicoes` AFTER DELETE ON `medicoes` FOR EACH ROW INSERT into logs VALUES (null, CURRENT_USER, "medicoes", "DELETE", CONCAT("NumeroMedicao", ": ", old.NumeroMedicao, "  DataHoraMedicao", ": ", old.DataHoraMedicao, "  ValorMedicao", ": ", old.ValorMedicao, "  IdVariaveisMedidas", ": ", old.IdVariaveisMedidas), "Linha Eliminada", NOW(), 0)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertMedicoes` AFTER INSERT ON `medicoes` FOR EACH ROW INSERT into logs VALUES (null, CURRENT_USER, "medicoes", "INSERT", "Não Aplicável", CONCAT("NumeroMedicao", ": ", new.NumeroMedicao, "  DataHoraMedicao", ": ", new.DataHoraMedicao, "  ValorMedicao", ": ", new.ValorMedicao, "  IdVariaveisMedidas", ": ", new.IdVariaveisMedidas), NOW(),0)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `updateMedicoes` AFTER UPDATE ON `medicoes` FOR EACH ROW INSERT into logs VALUES (null, CURRENT_USER, "medicoes", "UPDATE", CONCAT("NumeroMedicao", ": ", old.NumeroMedicao, "  DataHoraMedicao", ": ", old.DataHoraMedicao, "  ValorMedicao", ": ", old.ValorMedicao, "  IdVariaveisMedidas", ": ", old.IdVariaveisMedidas), CONCAT("NumeroMedicao", ": ", new.NumeroMedicao, "  DataHoraMedicao", ": ", new.DataHoraMedicao, "  ValorMedicao", ": ", new.ValorMedicao, "  IdVariaveisMedidas", ": ", new.IdVariaveisMedidas), NOW(), 0)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `medicoes_luminosidade`
--

CREATE TABLE `medicoes_luminosidade` (
  `DataHoraMedicao` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ValorMedicaoLuminosidade` decimal(8,2) NOT NULL,
  `IDMedicao` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `medicoes_luminosidade`
--
DELIMITER $$
CREATE TRIGGER `deleteMedicoesLuminosidade` AFTER DELETE ON `medicoes_luminosidade` FOR EACH ROW INSERT into logs VALUES (null, CURRENT_USER, "medicoes_luminosidade", "DELETE", CONCAT("DataHoraMedicao", ": ", old.DataHoraMedicao, "  ValorMedicaoLuminosidade", ": ", old.ValorMedicaoLuminosidade, "  IDMedicao", ": ", old.IDMedicao), "Linha Eliminada", NOW(), 0)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertMedicoesLuminosidade` AFTER INSERT ON `medicoes_luminosidade` FOR EACH ROW INSERT into logs VALUES (null, CURRENT_USER, "medicoes_luminosidade", "INSERT", "Não Aplicável", CONCAT("DataHoraMedicao", ": ", new.DataHoraMedicao, "  ValorMedicaoLuminosidade", ": ", new.ValorMedicaoLuminosidade, "  IDMedicao", ": ", new.IDMedicao), NOW(),0)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `updateMedicoesLuminosidade` AFTER UPDATE ON `medicoes_luminosidade` FOR EACH ROW INSERT into logs VALUES (null, CURRENT_USER, "medicoes_luminosidade", "UPDATE", CONCAT("DataHoraMedicao", ": ", old.DataHoraMedicao, "  ValorMedicaoLuminosidade", ": ", old.ValorMedicaoLuminosidade, "  IDMedicao", ": ", old.IDMedicao), CONCAT("DataHoraMedicao", ": ", new.DataHoraMedicao, "  ValorMedicaoLuminosidade", ": ", new.ValorMedicaoLuminosidade, "  IDMedicao", ": ", new.IDMedicao), NOW(), 0)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `medicoes_temperatura`
--

CREATE TABLE `medicoes_temperatura` (
  `DataHoraMedicao` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ValorMedicaoTemperatura` decimal(8,2) NOT NULL,
  `IDMedicao` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `medicoes_temperatura`
--
DELIMITER $$
CREATE TRIGGER `deleteMedicoesTemperatura` AFTER DELETE ON `medicoes_temperatura` FOR EACH ROW INSERT into logs VALUES (null, CURRENT_USER, "medicoes_temperatura", "DELETE", CONCAT("DataHoraMedicao", ": ", old.DataHoraMedicao, "  ValorMedicaoTemperatura", ": ", old.ValorMedicaoTemperatura, "  IDMedicao", ": ", old.IDMedicao), "Linha Eliminada", NOW(), 0)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertMedicoesTemperatura` AFTER INSERT ON `medicoes_temperatura` FOR EACH ROW INSERT into logs VALUES (null, CURRENT_USER, "medicoes_temperatura", "INSERT", "Não Aplicável", CONCAT("DataHoraMedicao", ": ", new.DataHoraMedicao, "  ValorMedicaoTemperatura", ": ", new.ValorMedicaoTemperatura	, "  IDMedicao", ": ", new.IDMedicao), NOW(),0)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `updateMedicoesTemperatura` AFTER UPDATE ON `medicoes_temperatura` FOR EACH ROW INSERT into logs VALUES (null, CURRENT_USER, "medicoes_temperatura", "UPDATE", CONCAT("DataHoraMedicao", ": ", old.DataHoraMedicao, "  ValorMedicaoTemperatura", ": ", old.ValorMedicaoTemperatura, "  IDMedicao", ": ", old.IDMedicao), CONCAT("DataHoraMedicao", ": ", new.DataHoraMedicao, "  ValorMedicaoTemperatura", ": ", new.ValorMedicaoTemperatura, "  IDMedicao", ": ", new.IDMedicao), NOW(), 0)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `sistema`
--

CREATE TABLE `sistema` (
  `LimiteInferiorTemperatura` decimal(8,2) NOT NULL,
  `LimiteSuperiorTemperatura` decimal(8,2) NOT NULL,
  `LimiteInferiorLuz` decimal(8,2) NOT NULL,
  `LimiteSuperiorLuz` decimal(8,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `sistema`
--

INSERT INTO `sistema` (`LimiteInferiorTemperatura`, `LimiteSuperiorTemperatura`, `LimiteInferiorLuz`, `LimiteSuperiorLuz`) VALUES
('19.50', '25.00', '2.00', '5.00'),
('19.50', '30.00', '5.00', '9.00');

--
-- Triggers `sistema`
--
DELIMITER $$
CREATE TRIGGER `deleteSistema` AFTER DELETE ON `sistema` FOR EACH ROW INSERT into logs VALUES (null, CURRENT_USER, "sistema", "DELETE", CONCAT("LimiteInferiorTemperatura", ": ", old.LimiteInferiorTemperatura, "  LimiteSuperiorTemperatura", ": ", old.LimiteSuperiorTemperatura, "  LimiteInferiorLuz", ": ", old.LimiteInferiorLuz, "  LimiteSuperiorLuz", ": ", old.LimiteSuperiorLuz), "Linha Eliminada", NOW(), 0)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertSistema` AFTER INSERT ON `sistema` FOR EACH ROW INSERT into logs VALUES (null, CURRENT_USER, "sistema", "INSERT", "Não Aplicável", CONCAT("LimiteInferiorTemperatura", ": ", new.LimiteInferiorTemperatura, "  LimiteSuperiorTemperatura", ": ", new.LimiteSuperiorTemperatura	, "  LimiteInferiorLuz", ": ", new.LimiteInferiorLuz, "  LimiteSuperiorLuz", ": ", new.LimiteSuperiorLuz), NOW(),0)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `updateSistema` AFTER UPDATE ON `sistema` FOR EACH ROW INSERT into logs VALUES (null, CURRENT_USER, "sistema", "UPDATE", CONCAT("LimiteInferiorTemperatura", ": ", old.LimiteInferiorTemperatura, "  LimiteSuperiorTemperatura", ": ", old.LimiteSuperiorTemperatura, "  LimiteInferiorLuz", ": ", old.LimiteInferiorLuz, "  LimiteSuperiorLuz", ": ", old.LimiteSuperiorLuz), CONCAT("LimiteInferiorTemperatura", ": ", new.LimiteInferiorTemperatura, "  LimiteSuperiorTemperatura", ": ", new.LimiteSuperiorTemperatura, "  LimiteInferiorLuz", ": ", new.LimiteInferiorLuz, "  LimiteSuperiorLuz", ": ", new.LimiteSuperiorLuz), NOW(), 0)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `variaveis`
--

CREATE TABLE `variaveis` (
  `IDVariavel` int(11) NOT NULL,
  `NomeVariavel` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `variaveis`
--

INSERT INTO `variaveis` (`IDVariavel`, `NomeVariavel`) VALUES
(1, 'pH');

--
-- Triggers `variaveis`
--
DELIMITER $$
CREATE TRIGGER `deleteVariaveis` AFTER DELETE ON `variaveis` FOR EACH ROW INSERT into logs VALUES (null, CURRENT_USER, "variaveis", "DELETE", CONCAT("IDVariavel", ": ", old.IDVariavel, "  NomeVariavel", ": ", old.NomeVariavel), "Linha Eliminada", NOW(), 0)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertVariaveis` AFTER INSERT ON `variaveis` FOR EACH ROW INSERT into logs VALUES (null, CURRENT_USER, "variaveis", "INSERT", "Não Aplicável", CONCAT("IDVariavel", ": ", new.IDVariavel, "  NomeVariavel", ": ", new.NomeVariavel), NOW(),0)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `updateVariaveis` AFTER UPDATE ON `variaveis` FOR EACH ROW INSERT into logs VALUES (null, CURRENT_USER, "variaveis", "UPDATE", CONCAT("IDVariavel", ": ", old.IDVariavel, "  NomeVariavel", ": ", old.NomeVariavel), CONCAT("IDVariavel", ": ", new.IDVariavel, "  NomeVariavel", ": ", new.NomeVariavel), NOW(), 0)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `variaveis_medidas`
--

CREATE TABLE `variaveis_medidas` (
  `IDVariavel` int(11) NOT NULL,
  `IDCultura` int(11) NOT NULL,
  `LimiteInferior` decimal(8,2) NOT NULL,
  `LimiteSuperior` decimal(8,2) NOT NULL,
  `IdVariaveisMedidas` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `variaveis_medidas`
--

INSERT INTO `variaveis_medidas` (`IDVariavel`, `IDCultura`, `LimiteInferior`, `LimiteSuperior`, `IdVariaveisMedidas`) VALUES
(1, 1, '3.00', '7.00', 1);

--
-- Triggers `variaveis_medidas`
--
DELIMITER $$
CREATE TRIGGER `deleteVariaveisMedidas` AFTER DELETE ON `variaveis_medidas` FOR EACH ROW INSERT into logs VALUES (null, CURRENT_USER, "variaveis_medidas", "DELETE", CONCAT("IDVariavel", ": ", old.IDVariavel, "  IDCultura", ": ", old.IDCultura, "  LimiteInferior", ": ", old.LimiteInferior, "  LimiteSuperior", ": ", old.LimiteSuperior, "  IdVariaveisMedidas", ": ", old.IdVariaveisMedidas), "Linha Eliminada", NOW(), 0)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertVariaveisMedidas` AFTER INSERT ON `variaveis_medidas` FOR EACH ROW INSERT into logs VALUES (null, CURRENT_USER, "variaveis_medidas", "INSERT", "Não Aplicável", CONCAT("IDVariavel", ": ", new.IDVariavel, "  IDCultura", ": ", new.IDCultura, "  LimiteInferior", ": ", new.LimiteInferior,"  LimiteSuperior", ": ", new.LimiteSuperior,"  IdVariaveisMedidas", ": ", new.IdVariaveisMedidas), NOW(),0)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `updateVariaveisMedidas` AFTER UPDATE ON `variaveis_medidas` FOR EACH ROW INSERT into logs VALUES (null, CURRENT_USER, "variaveis_medidas", "UPDATE", CONCAT("IDVariavel", ": ", old.IDVariavel, "  IDCultura", ": ", old.IDCultura, "  LimiteInferior", ": ", old.LimiteInferior, "  LimiteSuperior", ": ", old.LimiteSuperior, "  IdVariaveisMedidas", ": ", old.IdVariaveisMedidas), CONCAT("IDVariavel", ": ", new.IDVariavel, "  IDCultura", ": ", new.IDCultura, "  LimiteInferior", ": ", new.LimiteInferior, "  LimiteSuperior", ": ", new.LimiteSuperior, "  IdVariaveisMedidas", ": ", new.IdVariaveisMedidas), NOW(), 0)
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cultura`
--
ALTER TABLE `cultura`
  ADD PRIMARY KEY (`IDCultura`) USING BTREE,
  ADD KEY `EmailInvestigador` (`EmailInvestigador`) USING BTREE;

--
-- Indexes for table `investigador`
--
ALTER TABLE `investigador`
  ADD PRIMARY KEY (`Email`);

--
-- Indexes for table `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`logId`);

--
-- Indexes for table `medicoes`
--
ALTER TABLE `medicoes`
  ADD PRIMARY KEY (`NumeroMedicao`),
  ADD KEY `IdVariaveisMedidas` (`IdVariaveisMedidas`);

--
-- Indexes for table `medicoes_luminosidade`
--
ALTER TABLE `medicoes_luminosidade`
  ADD PRIMARY KEY (`IDMedicao`);

--
-- Indexes for table `medicoes_temperatura`
--
ALTER TABLE `medicoes_temperatura`
  ADD PRIMARY KEY (`IDMedicao`);

--
-- Indexes for table `variaveis`
--
ALTER TABLE `variaveis`
  ADD PRIMARY KEY (`IDVariavel`);

--
-- Indexes for table `variaveis_medidas`
--
ALTER TABLE `variaveis_medidas`
  ADD PRIMARY KEY (`IdVariaveisMedidas`),
  ADD KEY `IDCultura` (`IDCultura`),
  ADD KEY `IDVariavel` (`IDVariavel`,`IDCultura`) USING BTREE;

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cultura`
--
ALTER TABLE `cultura`
  MODIFY `IDCultura` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `logs`
--
ALTER TABLE `logs`
  MODIFY `logId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `medicoes`
--
ALTER TABLE `medicoes`
  MODIFY `NumeroMedicao` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `medicoes_luminosidade`
--
ALTER TABLE `medicoes_luminosidade`
  MODIFY `IDMedicao` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `medicoes_temperatura`
--
ALTER TABLE `medicoes_temperatura`
  MODIFY `IDMedicao` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `variaveis`
--
ALTER TABLE `variaveis`
  MODIFY `IDVariavel` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `variaveis_medidas`
--
ALTER TABLE `variaveis_medidas`
  MODIFY `IdVariaveisMedidas` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cultura`
--
ALTER TABLE `cultura`
  ADD CONSTRAINT `cultura_ibfk_1` FOREIGN KEY (`EmailInvestigador`) REFERENCES `investigador` (`Email`);

--
-- Constraints for table `medicoes`
--
ALTER TABLE `medicoes`
  ADD CONSTRAINT `medicoes_ibfk_1` FOREIGN KEY (`IdVariaveisMedidas`) REFERENCES `variaveis_medidas` (`IdVariaveisMedidas`);

--
-- Constraints for table `variaveis_medidas`
--
ALTER TABLE `variaveis_medidas`
  ADD CONSTRAINT `variaveis_medidas_ibfk_1` FOREIGN KEY (`IDCultura`) REFERENCES `cultura` (`IDCultura`),
  ADD CONSTRAINT `variaveis_medidas_ibfk_2` FOREIGN KEY (`IDVariavel`) REFERENCES `variaveis` (`IDVariavel`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
