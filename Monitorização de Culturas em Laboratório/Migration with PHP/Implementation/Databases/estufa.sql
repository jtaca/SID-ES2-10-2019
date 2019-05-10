-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: 09-Maio-2019 às 15:02
-- Versão do servidor: 10.1.38-MariaDB
-- versão do PHP: 7.3.2

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
CREATE DEFINER=`root`@`localhost` PROCEDURE `addUser` (IN `var_role` ENUM('investigador','administrador','sensorLuminosidade','sensorTemperatura'), IN `var_nome` VARCHAR(50), IN `var_password` VARCHAR(50), IN `var_email` VARCHAR(100), IN `var_categoria_profissional` VARCHAR(100))  BEGIN

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `apagarCultura` (IN `id` INT(11))  BEGIN

	SET @sql1 := CONCAT('CREATE TEMPORARY TABLE test AS SELECT IdVariaveisMedidas From variaveis_medidas WHERE variaveis_medidas.IDCultura=', QUOTE(id));
    PREPARE statement FROM @sql1;
    EXECUTE statement;
        
    SET @sql2 := CONCAT('DELETE FROM medicoes WHERE medicoes.IdVariaveisMedidas IN (SELECT * FROM test)');
    PREPARE statement FROM @sql2;
    EXECUTE statement;
    
    SET @sql2 := CONCAT('DELETE FROM variaveis_medidas WHERE variaveis_medidas.IDCultura =', QUOTE(id));
    PREPARE statement FROM @sql2;
    EXECUTE statement;
    
    SET @sql2 := CONCAT('DELETE FROM cultura WHERE cultura.IDCultura =', QUOTE(id));
    PREPARE statement FROM @sql2;
    EXECUTE statement;    
         
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `apagarMedicao` (IN `id` INT(11))  DELETE FROM `medicoes` WHERE medicoes.NumeroMedicao=id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `apagarVariaveis` (IN `id` INT)  NO SQL
BEGIN

	SET @sql1 := CONCAT('CREATE TEMPORARY TABLE test AS SELECT IdVariaveisMedidas From variaveis_medidas WHERE variaveis_medidas.IDVariavel=', QUOTE(id));
    PREPARE statement FROM @sql1;
    EXECUTE statement;
        
    SET @sql2 := CONCAT('DELETE FROM medicoes WHERE medicoes.IdVariaveisMedidas IN (SELECT * FROM test)');
    PREPARE statement FROM @sql2;
    EXECUTE statement;
    
    SET @sql2 := CONCAT('DELETE FROM variaveis_medidas WHERE variaveis_medidas.IDVariavel =', QUOTE(id));
    PREPARE statement FROM @sql2;
    EXECUTE statement;
    
    SET @sql2 := CONCAT('DELETE FROM variaveis WHERE variaveis.IDVariavel =', QUOTE(id));
    PREPARE statement FROM @sql2;
    EXECUTE statement;    
         
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `createJavaUser` ()  BEGIN
DROP USER IF EXISTS ''@localhost;
SET @sql := CONCAT('CREATE USER ', 'java', ' IDENTIFIED BY ', QUOTE('java'));
    PREPARE statement FROM @sql;
    EXECUTE statement;
    
    SET @sql := CONCAT('GRANT ', 'javaUser', ' TO ', QUOTE('java'));
    PREPARE statement FROM @sql;
    EXECUTE statement;
    
    SET @sql := CONCAT('SET DEFAULT ROLE ', 'javaUser' ,' FOR ', 		QUOTE('java'));
    PREPARE statement FROM @sql;
    EXECUTE statement;

    DEALLOCATE PREPARE statement;
    FLUSH PRIVILEGES;
END$$

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

GRANT INSERT ON estufa.medicoes TO javaUser;
GRANT INSERT ON estufa.medicoes_luminosidade TO javaUser;
GRANT INSERT ON estufa.medicoes_temperatura TO javaUser;
GRANT INSERT ON estufa.alertas TO javaUser;
GRANT INSERT ON estufa.medicoes_temperatura_incorretas TO javaUser;
GRANT INSERT ON estufa.medicoes_luminosidade_incorretas TO javaUser;
GRANT SELECT ON estufa.sistema TO javaUser;
GRANT SELECT ON estufa.variaveis_medidas TO javaUser;

GRANT SELECT ON estufa.medicoes_luminosidade TO investigador;
GRANT SELECT ON estufa.medicoes_temperatura TO investigador;
GRANT SELECT ON estufa.alertas TO investigador;
GRANT SELECT ON mysql.User TO investigador;

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `criarRoles` ()  CREATE ROLE IF NOT EXISTS investigador, administrador, sensorLuminosidade, sensorTemperatura,  phpUser, javaUser$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteUser` (IN `var_email` VARCHAR(100))  NO SQL
BEGIN

	SET @sql := CONCAT('SELECT User INTO @user FROM mysql.user WHERE email = ', QUOTE(var_email));
	PREPARE statement FROM @sql;
	EXECUTE statement;

	SET @sql := CONCAT('DROP USER IF EXISTS ', @user);
	PREPARE statement FROM @sql;
	EXECUTE statement;

	SET @sql := CONCAT('DELETE FROM estufa.investigador WHERE Email = ', QUOTE(var_email));
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCultura` (IN `culturaID` INT(11), IN `Nome` VARCHAR(100), IN `Descricao` TEXT)  NO SQL
BEGIN

	IF (Nome != "" AND Descricao = "")
	THEN UPDATE `cultura` SET `NomeCultura` = Nome WHERE `cultura`.`IDCultura` = culturaID;
	
    ELSEIF(Nome = "" AND Descricao != "")
	THEN UPDATE `cultura` SET `DescricaoCultura` = Descricao WHERE `cultura`.`IDCultura` = culturaID;
	
    ELSEIF (Nome != "" AND Descricao != "")
	THEN UPDATE `cultura` SET `NomeCultura` = Nome, `DescricaoCultura` = Descricao WHERE `cultura`.`IDCultura` = culturaID;
	
    END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateInvestigador` (IN `emailInv` VARCHAR(200), IN `nomeInv` VARCHAR(100), IN `catProf` VARCHAR(300), IN `pass` VARCHAR(100), IN `newEmailInv` VARCHAR(200))  NO SQL
BEGIN

	IF (nomeInv != "" OR nomeInv != NULL)
	THEN 
    UPDATE `investigador` SET `NomeInvestigador` = nomeInv WHERE `investigador`.`Email` = emailInv;
    UPDATE `mysql`.`user` SET `User` = nomeInv WHERE `mysql`.`user`.`email` = emailInv;
    END IF;
	
    IF(catProf != "" OR catProf != NULL)
	THEN 
    UPDATE `investigador` SET `CategoriaProfissional` = catProf WHERE `investigador`.`Email` = emailInv;
    END IF;
    
    IF(pass != "" OR pass != NULL)
	THEN 
   	UPDATE `mysql`.`user` SET `Password` = PASSWORD(pass) WHERE `mysql`.`user`.`email` = emailInv;
	END IF;
    
    IF(newEmailInv != "" OR newEmailInv != NULL)
	THEN 
    UPDATE `investigador` SET `Email` = newEmailInv WHERE `investigador`.`Email` = emailInv;
    UPDATE `mysql`.`user` SET `email` = newEmailInv WHERE `mysql`.`user`.`email` = emailInv;
    END IF;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateMigrados` (IN `endID` INT(50))  UPDATE logs SET logs.exportado=1 WHERE logs.logId<=endID$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `alertas`
--

CREATE TABLE `alertas` (
  `idAlerta` int(11) NOT NULL,
  `nomeVariavel` varchar(100) DEFAULT NULL,
  `nomeCultura` varchar(100) DEFAULT NULL,
  `emailInvestigador` varchar(100) NOT NULL,
  `data` datetime NOT NULL,
  `limiteInferiorVar` decimal(8,2) NOT NULL,
  `limiteSuperiorVar` decimal(8,2) NOT NULL,
  `valor` decimal(8,2) NOT NULL,
  `descricaoAlertas` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `alertas`
--

INSERT INTO `alertas` (`idAlerta`, `nomeVariavel`, `nomeCultura`, `emailInvestigador`, `data`, `limiteInferiorVar`, `limiteSuperiorVar`, `valor`, `descricaoAlertas`) VALUES
(9, 'Chumbo', 'Beterraba', 'root@localhost', '2019-05-03 23:21:57', '0.00', '0.00', '2.85', 'O valor da medição ultrapassou o limite inferior.'),
(10, 'Chumbo', 'Beterraba', 'root@localhost', '2019-05-03 23:22:27', '0.00', '0.00', '2.50', 'O valor da medição ultrapassou o limite inferior.'),
(11, 'Chumbo', 'Beterraba', 'root@localhost', '2019-05-03 23:23:14', '0.00', '0.00', '2.86', 'O valor da medição está próximo do limite inferior.'),
(12, 'Chumbo', 'Beterraba', 'root@localhost', '2019-05-03 23:23:41', '0.00', '0.00', '3.01', 'O valor da medição está próximo do limite inferior.'),
(13, 'Chumbo', 'Beterraba', 'root@localhost', '2019-05-03 23:24:19', '0.00', '0.00', '3.39', 'O valor da medição está próximo do limite inferior.'),
(14, 'Chumbo', 'Beterraba', 'root@localhost', '2019-05-03 23:26:07', '0.00', '0.00', '7.71', 'O valor da medição está próximo do limite superior.'),
(15, 'Chumbo', 'Beterraba', 'root@localhost', '2019-05-03 23:26:41', '0.00', '0.00', '7.95', 'O valor da medição está próximo do limite superior.'),
(16, 'Chumbo', 'Beterraba', 'root@localhost', '2019-05-03 23:27:10', '0.00', '0.00', '8.24', 'O valor da medição está próximo do limite superior.'),
(17, 'Chumbo', 'Beterraba', 'root@localhost', '2019-05-03 23:27:29', '0.00', '0.00', '8.25', 'O valor da medição ultrapassou o limite superior.'),
(18, 'Chumbo', 'Beterraba', 'root@localhost', '2019-05-03 23:27:52', '0.00', '0.00', '9.56', 'O valor da medição ultrapassou o limite superior.'),
(19, 'Chumbo', 'Beterraba', 'root@localhost', '2019-05-03 23:42:46', '0.00', '0.00', '2.85', 'O valor da medição atingiu o limite inferior.'),
(20, 'Chumbo', 'Beterraba', 'root@localhost', '2019-05-03 23:43:13', '0.00', '0.00', '8.25', 'O valor da medição atingiu o limite superior.'),
(21, 'Chumbo', 'Beterraba', 'root@localhost', '2019-05-03 23:43:48', '0.00', '0.00', '2.84', 'O valor da medição ultrapassou o limite inferior.'),
(22, 'Chumbo', 'Beterraba', 'root@localhost', '2019-05-03 23:43:48', '0.00', '0.00', '2.86', 'O valor da medição está próximo do limite inferior.'),
(23, 'Chumbo', 'Beterraba', 'root@localhost', '2019-05-03 23:44:29', '0.00', '0.00', '8.26', 'O valor da medição ultrapassou o limite superior.'),
(24, 'Chumbo', 'Beterraba', 'root@localhost', '2019-05-03 23:44:29', '0.00', '0.00', '8.24', 'O valor da medição está próximo do limite superior.'),
(25, 'Chumbo', 'Beterraba', 'root@localhost', '2019-05-04 17:42:48', '2.85', '8.25', '10.25', 'O valor da medição ultrapassou o limite superior.'),
(26, 'Chumbo', 'Beterraba', 'root@localhost', '2019-05-04 17:43:24', '2.85', '8.25', '1.58', 'O valor da medição ultrapassou o limite inferior.'),
(27, 'nomeDaVariavel', 'Tomate', 'root@localhost', '2019-05-04 17:44:45', '5.00', '9.50', '3.85', 'O valor da medição ultrapassou o limite inferior.'),
(28, 'nomeDaVariavel', 'Tomate', 'root@localhost', '2019-05-04 17:45:21', '5.00', '9.50', '5.42', 'O valor da medição está próximo do limite inferior.'),
(29, 'Chumbo', 'Cenouras', 'root@localhost', '2019-05-06 12:14:46', '2.85', '8.25', '1.52', 'O valor da medição ultrapassou o limite inferior.'),
(30, 'Chumbo', 'Cenouras', 'root@localhost', '2019-05-06 12:16:44', '2.85', '8.25', '13.52', 'O valor da medição ultrapassou o limite superior.');

-- --------------------------------------------------------

--
-- Estrutura da tabela `cultura`
--

CREATE TABLE `cultura` (
  `IDCultura` int(11) NOT NULL,
  `NomeCultura` varchar(100) NOT NULL,
  `DescricaoCultura` text,
  `EmailInvestigador` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `cultura`
--

INSERT INTO `cultura` (`IDCultura`, `NomeCultura`, `DescricaoCultura`, `EmailInvestigador`) VALUES
(2, 'Batatas', 'Cultura Hidropónica', 'lala@gmail.com'),
(4, 'Cenouras', 'Cultura Hidropónica', 'hmbs@gmail.com'),
(5, 'Pimentos', 'Cultura Hidropónica', 'afga'),
(6, 'battas', 'sd', 'joaofneto97@gmail.com');

--
-- Acionadores `cultura`
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
-- Estrutura da tabela `investigador`
--

CREATE TABLE `investigador` (
  `Email` varchar(50) NOT NULL,
  `NomeInvestigador` varchar(100) NOT NULL,
  `CategoriaProfissional` varchar(300) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `investigador`
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
('hmbs@gmail.com', 'hmbs', 'eng'),
('joaofneto97@gmail.com', 'joao', 'chefe'),
('jonas@gmail.com', 'jonas', 'programador'),
('lala@gmail.com', 'wqser', 'qwer'),
('p@p.p', 'pipu', '0'),
('qwe', 'sens', 'asd'),
('qwerty', 'boneca', 'asdfg'),
('sdfvsdfvc', 'adscfsad', 'sfcvsfdcv'),
('testeinvestigador@gmail.com', 'TesteInvestigador', 'teste teste'),
('v', 'v', 'v'),
('y', 'y', 'y');

--
-- Acionadores `investigador`
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
-- Estrutura da tabela `logs`
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
-- Extraindo dados da tabela `logs`
--

INSERT INTO `logs` (`logId`, `username`, `nomeTabela`, `comandoUsado`, `linhaAnterior`, `resultado`, `dataComando`, `exportado`) VALUES
(133, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 1  DataHoraMedicao: 2019-05-02 19:23:45  ValorMedicao: 10.00  IdVariaveisMedidas: 1', '2019-05-02 19:23:45', 0),
(134, 'root@localhost', 'variaveis_medidas', 'UPDATE', 'IDVariavel: 3  IDCultura: 4  LimiteInferior: 2.85  LimiteSuperior: 8.23  IdVariaveisMedidas: 1', 'IDVariavel: 3  IDCultura: 4  LimiteInferior: 2.85  LimiteSuperior: 8.25  IdVariaveisMedidas: 1', '2019-05-03 23:19:04', 0),
(135, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 2  DataHoraMedicao: 2019-05-03 23:21:13  ValorMedicao: 5.23  IdVariaveisMedidas: 1', '2019-05-03 23:21:13', 0),
(136, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 3  DataHoraMedicao: 2019-05-03 23:21:57  ValorMedicao: 2.85  IdVariaveisMedidas: 1', '2019-05-03 23:21:57', 0),
(137, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 4  DataHoraMedicao: 2019-05-03 23:22:27  ValorMedicao: 2.50  IdVariaveisMedidas: 1', '2019-05-03 23:22:27', 0),
(138, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 5  DataHoraMedicao: 2019-05-03 23:23:14  ValorMedicao: 2.86  IdVariaveisMedidas: 1', '2019-05-03 23:23:14', 0),
(139, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 6  DataHoraMedicao: 2019-05-03 23:23:41  ValorMedicao: 3.01  IdVariaveisMedidas: 1', '2019-05-03 23:23:41', 0),
(140, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 7  DataHoraMedicao: 2019-05-03 23:24:19  ValorMedicao: 3.39  IdVariaveisMedidas: 1', '2019-05-03 23:24:19', 0),
(141, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 8  DataHoraMedicao: 2019-05-03 23:24:40  ValorMedicao: 3.40  IdVariaveisMedidas: 1', '2019-05-03 23:24:40', 0),
(142, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 9  DataHoraMedicao: 2019-05-03 23:25:45  ValorMedicao: 7.70  IdVariaveisMedidas: 1', '2019-05-03 23:25:45', 0),
(143, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 10  DataHoraMedicao: 2019-05-03 23:26:07  ValorMedicao: 7.71  IdVariaveisMedidas: 1', '2019-05-03 23:26:07', 0),
(144, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 11  DataHoraMedicao: 2019-05-03 23:26:41  ValorMedicao: 7.95  IdVariaveisMedidas: 1', '2019-05-03 23:26:41', 0),
(145, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 12  DataHoraMedicao: 2019-05-03 23:27:10  ValorMedicao: 8.24  IdVariaveisMedidas: 1', '2019-05-03 23:27:10', 0),
(146, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 13  DataHoraMedicao: 2019-05-03 23:27:29  ValorMedicao: 8.25  IdVariaveisMedidas: 1', '2019-05-03 23:27:29', 0),
(147, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 14  DataHoraMedicao: 2019-05-03 23:27:52  ValorMedicao: 9.56  IdVariaveisMedidas: 1', '2019-05-03 23:27:52', 0),
(148, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 1  DataHoraMedicao: 2019-05-02 19:23:45  ValorMedicao: 10.00  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-03 23:28:14', 0),
(149, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 15  DataHoraMedicao: 2019-05-03 23:28:30  ValorMedicao: 6.45  IdVariaveisMedidas: 1', '2019-05-03 23:28:30', 0),
(150, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 16  DataHoraMedicao: 2019-05-03 23:42:46  ValorMedicao: 2.85  IdVariaveisMedidas: 1', '2019-05-03 23:42:46', 0),
(151, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 17  DataHoraMedicao: 2019-05-03 23:43:13  ValorMedicao: 8.25  IdVariaveisMedidas: 1', '2019-05-03 23:43:13', 0),
(152, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 18  DataHoraMedicao: 2019-05-03 23:43:48  ValorMedicao: 2.84  IdVariaveisMedidas: 1', '2019-05-03 23:43:48', 0),
(153, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 19  DataHoraMedicao: 2019-05-03 23:43:48  ValorMedicao: 2.86  IdVariaveisMedidas: 1', '2019-05-03 23:43:48', 0),
(154, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 20  DataHoraMedicao: 2019-05-03 23:44:29  ValorMedicao: 8.26  IdVariaveisMedidas: 1', '2019-05-03 23:44:29', 0),
(155, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 21  DataHoraMedicao: 2019-05-03 23:44:29  ValorMedicao: 8.24  IdVariaveisMedidas: 1', '2019-05-03 23:44:29', 0),
(156, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 22  DataHoraMedicao: 2019-05-04 17:42:48  ValorMedicao: 10.25  IdVariaveisMedidas: 1', '2019-05-04 17:42:48', 0),
(157, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 23  DataHoraMedicao: 2019-05-04 17:43:24  ValorMedicao: 1.58  IdVariaveisMedidas: 1', '2019-05-04 17:43:24', 0),
(158, 'root@localhost', 'variaveis_medidas', 'INSERT', 'Não Aplicável', 'IDVariavel: 8  IDCultura: 2  LimiteInferior: 5.00  LimiteSuperior: 9.50  IdVariaveisMedidas: 2', '2019-05-04 17:44:22', 0),
(159, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 24  DataHoraMedicao: 2019-05-04 17:44:45  ValorMedicao: 3.85  IdVariaveisMedidas: 2', '2019-05-04 17:44:45', 0),
(160, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 25  DataHoraMedicao: 2019-05-04 17:45:21  ValorMedicao: 5.42  IdVariaveisMedidas: 2', '2019-05-04 17:45:21', 0),
(161, 'root@localhost', 'cultura', 'UPDATE', 'IdCultura: 2  NomeCultura: Tomate  DescricaoCultura: fsdkjfvjksdjkfsd  EmailInvestigador: lala@gmail.com', 'IdCultura: 2  NomeCultura: Tomate  DescricaoCultura: dfsdfksdbkjdskjnf  EmailInvestigador: lala@gmail.com', '2019-05-05 16:40:12', 0),
(162, 'root@localhost', 'cultura', 'UPDATE', 'IdCultura: 4  NomeCultura: Beterraba  DescricaoCultura: Cultura Hidroponica ++  EmailInvestigador: hmbs@gmail.com', 'IdCultura: 4  NomeCultura: Beterraba +  DescricaoCultura: Cultura Hidroponica +++  EmailInvestigador: hmbs@gmail.com', '2019-05-05 17:10:53', 0),
(163, 'root@localhost', 'cultura', 'INSERT', 'Não Aplicável', 'IdCultura: 5  NomeCultura: jbhjjh  DescricaoCultura: jhbjhbhjbjhvj  EmailInvestigador: afga', '2019-05-05 17:11:35', 0),
(164, 'root@localhost', 'cultura', 'UPDATE', 'IdCultura: 5  NomeCultura: jbhjjh  DescricaoCultura: jhbjhbhjbjhvj  EmailInvestigador: afga', 'IdCultura: 5  NomeCultura: jbhjjhku  DescricaoCultura: jhbjhbhjbjhvjuyf  EmailInvestigador: afga', '2019-05-05 17:22:42', 0),
(165, 'root@localhost', 'cultura', 'UPDATE', 'IdCultura: 4  NomeCultura: Beterraba +  DescricaoCultura: Cultura Hidroponica +++  EmailInvestigador: hmbs@gmail.com', 'IdCultura: 4  NomeCultura: Beterraba  DescricaoCultura: Cultura Hidropónica  EmailInvestigador: hmbs@gmail.com', '2019-05-05 17:41:50', 0),
(166, 'root@localhost', 'cultura', 'UPDATE', 'IdCultura: 5  NomeCultura: jbhjjhku  DescricaoCultura: jhbjhbhjbjhvjuyf  EmailInvestigador: afga', 'IdCultura: 5  NomeCultura: Pimentos  DescricaoCultura: jhbjhbhjbjhvjuyf  EmailInvestigador: afga', '2019-05-05 17:42:50', 0),
(167, 'root@localhost', 'cultura', 'UPDATE', 'IdCultura: 5  NomeCultura: Pimentos  DescricaoCultura: jhbjhbhjbjhvjuyf  EmailInvestigador: afga', 'IdCultura: 5  NomeCultura: Pimentos  DescricaoCultura: Cultura HIdro  EmailInvestigador: afga', '2019-05-05 17:44:55', 0),
(168, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 11  NomeVariavel: nomeDaVariavel', '2019-05-05 18:00:32', 0),
(169, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 12  NomeVariavel: nomeDaVariavel', '2019-05-05 18:04:11', 0),
(170, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 13  NomeVariavel: nomeDaVariavel', '2019-05-05 18:05:45', 0),
(171, 'root@localhost', 'cultura', 'UPDATE', 'IdCultura: 2  NomeCultura: Tomate  DescricaoCultura: dfsdfksdbkjdskjnf  EmailInvestigador: lala@gmail.com', 'IdCultura: 2  NomeCultura: Batatas  DescricaoCultura: Cultura Hidropónica  EmailInvestigador: lala@gmail.com', '2019-05-05 18:05:45', 0),
(172, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 14  NomeVariavel: nomeDaVariavel', '2019-05-05 18:06:37', 0),
(173, 'root@localhost', 'cultura', 'UPDATE', 'IdCultura: 5  NomeCultura: Pimentos  DescricaoCultura: Cultura HIdro  EmailInvestigador: afga', 'IdCultura: 5  NomeCultura: Pimentos  DescricaoCultura: Cultura Hidropónica  EmailInvestigador: afga', '2019-05-05 18:06:37', 0),
(174, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 15  NomeVariavel: nomeDaVariavel', '2019-05-05 18:07:22', 0),
(175, 'root@localhost', 'cultura', 'UPDATE', 'IdCultura: 4  NomeCultura: Beterraba  DescricaoCultura: Cultura Hidropónica  EmailInvestigador: hmbs@gmail.com', 'IdCultura: 4  NomeCultura: Cenouras  DescricaoCultura: Cultura Hidropónica  EmailInvestigador: hmbs@gmail.com', '2019-05-05 18:07:22', 0),
(176, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 2  DataHoraMedicao: 2019-05-03 23:21:13  ValorMedicao: 5.23  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-05 18:16:33', 0),
(177, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 16  NomeVariavel: nomeDaVariavel', '2019-05-06 12:14:46', 0),
(178, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 26  DataHoraMedicao: 2019-05-06 12:14:46  ValorMedicao: 1.52  IdVariaveisMedidas: 1', '2019-05-06 12:14:46', 0),
(179, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 17  NomeVariavel: nomeDaVariavel', '2019-05-06 12:16:44', 0),
(180, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 27  DataHoraMedicao: 2019-05-06 12:16:44  ValorMedicao: 13.52  IdVariaveisMedidas: 1', '2019-05-06 12:16:44', 0),
(181, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 18  NomeVariavel: nomeDaVariavel', '2019-05-06 12:17:57', 0),
(182, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 26  DataHoraMedicao: 2019-05-06 12:14:46  ValorMedicao: 1.52  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-06 12:17:57', 0),
(183, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 19  NomeVariavel: nomeDaVariavel', '2019-05-06 12:18:24', 0),
(184, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 27  DataHoraMedicao: 2019-05-06 12:16:44  ValorMedicao: 13.52  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-06 12:18:24', 0),
(185, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: iscte@gmail.com  NomeInvestigador: iscte  CategoriaProfissional: uni', '2019-05-07 10:52:00', 0),
(186, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 20  NomeVariavel: nomeDaVariavel', '2019-05-07 19:44:48', 0),
(187, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 21  NomeVariavel: nomeDaVariavel', '2019-05-07 19:46:09', 0),
(188, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 22  NomeVariavel: nomeDaVariavel', '2019-05-07 20:34:17', 0),
(189, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 23  NomeVariavel: nomeDaVariavel', '2019-05-07 20:36:28', 0),
(190, 'root@localhost', 'investigador', 'DELETE', 'Email: iscte@gmail.com  NomeInvestigador: iscte  CategoriaProfissional: uni', 'Linha Eliminada', '2019-05-07 20:40:37', 0),
(191, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 24  NomeVariavel: nomeDaVariavel', '2019-05-07 20:41:17', 0),
(192, 'root@localhost', 'investigador', 'DELETE', 'Email: teste@gmail.com  NomeInvestigador: testeeee  CategoriaProfissional: chefe', 'Linha Eliminada', '2019-05-07 20:45:24', 0),
(193, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 25  NomeVariavel: nomeDaVariavel', '2019-05-07 20:46:06', 0),
(194, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: testeUser@gmail.com  NomeInvestigador: testeUser  CategoriaProfissional: chefeTeste', '2019-05-07 20:52:51', 0),
(195, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 26  NomeVariavel: nomeDaVariavel', '2019-05-07 20:52:51', 0),
(196, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 27  NomeVariavel: nomeDaVariavel', '2019-05-07 20:54:03', 0),
(197, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 28  NomeVariavel: nomeDaVariavel', '2019-05-07 20:57:08', 0),
(198, 'root@localhost', 'investigador', 'DELETE', 'Email: testeUser@gmail.com  NomeInvestigador: testeUser  CategoriaProfissional: chefeTeste', 'Linha Eliminada', '2019-05-07 21:23:42', 0),
(199, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: testeUser@gmail.com  NomeInvestigador: testeUser  CategoriaProfissional: chefeTeste', '2019-05-07 21:24:07', 0),
(200, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 29  NomeVariavel: nomeDaVariavel', '2019-05-07 21:24:07', 0),
(201, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 30  NomeVariavel: nomeDaVariavel', '2019-05-07 21:24:48', 0),
(202, 'root@localhost', 'investigador', 'DELETE', 'Email: testeUser@gmail.com  NomeInvestigador: testeUser  CategoriaProfissional: chefeTeste', 'Linha Eliminada', '2019-05-07 21:26:56', 0),
(203, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: testeUser@gmail.com  NomeInvestigador: testeUser  CategoriaProfissional: chefeTeste', '2019-05-07 21:27:47', 0),
(204, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 31  NomeVariavel: nomeDaVariavel', '2019-05-07 21:27:47', 0),
(205, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 32  NomeVariavel: nomeDaVariavel', '2019-05-07 21:28:32', 0),
(206, 'root@localhost', 'investigador', 'DELETE', 'Email: testeUser@gmail.com  NomeInvestigador: testeUser  CategoriaProfissional: chefeTeste', 'Linha Eliminada', '2019-05-07 21:28:32', 0),
(207, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: joaofneto97@gmail.com  NomeInvestigador: joao  CategoriaProfissional: chefe', '2019-05-07 22:27:38', 0),
(208, 'root@localhost', 'cultura', 'INSERT', 'Não Aplicável', 'IdCultura: 6  NomeCultura: battas  DescricaoCultura: sd  EmailInvestigador: joaofneto97@gmail.com', '2019-05-08 17:24:40', 0),
(209, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: TesteInvestigador@gmail.com  NomeInvestigador: TesteInvestigador  CategoriaProfissional: teste teste', '2019-05-08 23:46:05', 0),
(210, 'root@localhost', 'investigador', 'UPDATE', 'Email: TesteInvestigador@gmail.com  NomeInvestigador: TesteInvestigador  CategoriaProfissional: teste teste', 'Email: TesteInvestigador@gmail.com  NomeInvestigador: TesteInvestigador  CategoriaProfissional: teste teste', '2019-05-08 23:49:17', 0),
(211, 'root@localhost', 'investigador', 'UPDATE', 'Email: TesteInvestigador@gmail.com  NomeInvestigador: TesteInvestigador  CategoriaProfissional: teste teste', 'Email: TesteInvestigador@gmail.com  NomeInvestigador: TesteInvestigador  CategoriaProfissional: teste teste teste', '2019-05-08 23:49:17', 0),
(212, 'root@localhost', 'investigador', 'UPDATE', 'Email: TesteInvestigador@gmail.com  NomeInvestigador: TesteInvestigador  CategoriaProfissional: teste teste teste', 'Email: TesteInvestigadorIscte@gmail.com  NomeInvestigador: TesteInvestigador  CategoriaProfissional: teste teste teste', '2019-05-08 23:49:17', 0),
(213, 'root@localhost', 'investigador', 'UPDATE', 'Email: TesteInvestigadorIscte@gmail.com  NomeInvestigador: TesteInvestigador  CategoriaProfissional: teste teste teste', 'Email: TesteInvestigadorIscte@gmail.com  NomeInvestigador: TesteInvestigadorIscte  CategoriaProfissional: teste teste teste', '2019-05-08 23:51:14', 0),
(214, 'root@localhost', 'investigador', 'UPDATE', 'Email: TesteInvestigadorIscte@gmail.com  NomeInvestigador: TesteInvestigadorIscte  CategoriaProfissional: teste teste teste', 'Email: TesteInvestigadorIscte@gmail.com  NomeInvestigador: TesteInvestigadorIscte  CategoriaProfissional: teste teste teste', '2019-05-08 23:51:14', 0),
(215, 'root@localhost', 'investigador', 'UPDATE', 'Email: TesteInvestigadorIscte@gmail.com  NomeInvestigador: TesteInvestigadorIscte  CategoriaProfissional: teste teste teste', 'Email: TesteInvestigadorIscteiul@gmail.com  NomeInvestigador: TesteInvestigadorIscte  CategoriaProfissional: teste teste teste', '2019-05-08 23:51:14', 0),
(216, 'root@localhost', 'investigador', 'DELETE', 'Email: TesteInvestigadorIscteiul@gmail.com  NomeInvestigador: TesteInvestigadorIscte  CategoriaProfissional: teste teste teste', 'Linha Eliminada', '2019-05-08 23:51:55', 0),
(217, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 33  NomeVariavel: nomeDaVariavel', '2019-05-09 00:03:47', 0),
(218, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 1.00  LimiteSuperiorTemperatura: 5.00  LimiteInferiorLuz: 8.00  LimiteSuperiorLuz: 10.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 8.00  LimiteSuperiorLuz: 10.00', '2019-05-09 00:03:47', 0),
(219, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 8.00  LimiteSuperiorLuz: 10.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 00:03:47', 0),
(220, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 34  NomeVariavel: nomeDaVariavel', '2019-05-09 00:04:08', 0),
(221, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 00:04:08', 0),
(222, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 00:04:08', 0),
(223, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 35  NomeVariavel: nomeDaVariavel', '2019-05-09 00:09:42', 0),
(224, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 00:09:42', 0),
(225, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 00:09:42', 0),
(226, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 36  NomeVariavel: nomeDaVariavel', '2019-05-09 00:18:52', 0),
(227, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 00:18:52', 0),
(228, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 00:18:52', 0),
(229, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 37  NomeVariavel: nomeDaVariavel', '2019-05-09 00:20:07', 0),
(230, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 00:20:07', 0),
(231, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 00:20:07', 0),
(232, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 38  NomeVariavel: nomeDaVariavel', '2019-05-09 00:20:53', 0),
(233, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 00:20:53', 0),
(234, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 00:20:53', 0),
(235, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: testeinvestigador@gmail.com  NomeInvestigador: TesteInvestigador  CategoriaProfissional: teste teste', '2019-05-09 13:38:09', 0),
(236, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 39  NomeVariavel: nomeDaVariavel', '2019-05-09 13:40:53', 0),
(237, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 13:40:53', 0),
(238, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 13:40:53', 0),
(239, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: testeinsert@gmail.com  NomeInvestigador: TesteInsert  CategoriaProfissional: teste teste teste', '2019-05-09 13:40:53', 0),
(240, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 40  NomeVariavel: nomeDaVariavel', '2019-05-09 13:49:00', 0),
(241, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 13:49:00', 0),
(242, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 13:49:00', 0),
(243, 'root@localhost', 'investigador', 'UPDATE', 'Email: testeinsert@gmail.com  NomeInvestigador: TesteInsert  CategoriaProfissional: teste teste teste', 'Email: testeinsert@gmail.com  NomeInvestigador: TesteInsert  CategoriaProfissional: teste teste teste', '2019-05-09 13:49:00', 0),
(244, 'root@localhost', 'investigador', 'UPDATE', 'Email: testeinsert@gmail.com  NomeInvestigador: TesteInsert  CategoriaProfissional: teste teste teste', 'Email: testeinsert@gmail.com  NomeInvestigador: TesteInsert  CategoriaProfissional: teste teste', '2019-05-09 13:49:00', 0),
(245, 'root@localhost', 'investigador', 'UPDATE', 'Email: testeinsert@gmail.com  NomeInvestigador: TesteInsert  CategoriaProfissional: teste teste', 'Email: testeinsertcultura@gmail.com  NomeInvestigador: TesteInsert  CategoriaProfissional: teste teste', '2019-05-09 13:49:00', 0),
(246, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 41  NomeVariavel: nomeDaVariavel', '2019-05-09 13:51:14', 0),
(247, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 13:51:14', 0),
(248, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 13:51:14', 0),
(249, 'root@localhost', 'investigador', 'DELETE', 'Email: testeinsertcultura@gmail.com  NomeInvestigador: TesteInsert  CategoriaProfissional: teste teste', 'Linha Eliminada', '2019-05-09 13:51:14', 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `medicoes`
--

CREATE TABLE `medicoes` (
  `NumeroMedicao` int(11) NOT NULL,
  `DataHoraMedicao` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ValorMedicao` decimal(8,2) NOT NULL,
  `IdVariaveisMedidas` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `medicoes`
--

INSERT INTO `medicoes` (`NumeroMedicao`, `DataHoraMedicao`, `ValorMedicao`, `IdVariaveisMedidas`) VALUES
(3, '2019-05-03 22:21:57', '2.85', 1),
(4, '2019-05-03 22:22:27', '2.50', 1),
(5, '2019-05-03 22:23:14', '2.86', 1),
(6, '2019-05-03 22:23:41', '3.01', 1),
(7, '2019-05-03 22:24:19', '3.39', 1),
(8, '2019-05-03 22:24:40', '3.40', 1),
(9, '2019-05-03 22:25:45', '7.70', 1),
(10, '2019-05-03 22:26:07', '7.71', 1),
(11, '2019-05-03 22:26:41', '7.95', 1),
(12, '2019-05-03 22:27:10', '8.24', 1),
(13, '2019-05-03 22:27:29', '8.25', 1),
(14, '2019-05-03 22:27:52', '9.56', 1),
(15, '2019-05-03 22:28:30', '6.45', 1),
(16, '2019-05-03 22:42:46', '2.85', 1),
(17, '2019-05-03 22:43:13', '8.25', 1),
(18, '2019-05-03 22:43:48', '2.84', 1),
(19, '2019-05-03 22:43:48', '2.86', 1),
(20, '2019-05-03 22:44:29', '8.26', 1),
(21, '2019-05-03 22:44:29', '8.24', 1),
(22, '2019-05-04 16:42:48', '10.25', 1),
(23, '2019-05-04 16:43:24', '1.58', 1),
(24, '2019-05-04 16:44:45', '3.85', 2),
(25, '2019-05-04 16:45:21', '5.42', 2);

--
-- Acionadores `medicoes`
--
DELIMITER $$
CREATE TRIGGER `deleteMedicoes` AFTER DELETE ON `medicoes` FOR EACH ROW INSERT into logs VALUES (null, CURRENT_USER, "medicoes", "DELETE", CONCAT("NumeroMedicao", ": ", old.NumeroMedicao, "  DataHoraMedicao", ": ", old.DataHoraMedicao, "  ValorMedicao", ": ", old.ValorMedicao, "  IdVariaveisMedidas", ": ", old.IdVariaveisMedidas), "Linha Eliminada", NOW(), 0)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertMedicoes` AFTER INSERT ON `medicoes` FOR EACH ROW BEGIN

	DECLARE limiteS DECIMAL(8,2);
    DECLARE limiteI DECIMAL(8,2);
    DECLARE percentagem DECIMAL(8,2);
    
    DECLARE nomeVariavel Varchar(100);
    DECLARE nomeCultura Varchar(100);
    
    DECLARE intervaloMed DECIMAL(8,2);
    DECLARE margem DECIMAL(8,2);
    
    SELECT variaveis_medidas.LimiteSuperior FROM variaveis_medidas WHERE variaveis_medidas.IdVariaveisMedidas = new.IdVariaveisMedidas INTO limiteS;
    SELECT variaveis_medidas.LimiteInferior FROM variaveis_medidas WHERE variaveis_medidas.IdVariaveisMedidas = new.IdVariaveisMedidas INTO limiteI;
    SELECT variaveis_medidas.MargemSegurancaVariavel FROM variaveis_medidas WHERE variaveis_medidas.IdVariaveisMedidas= new.IdVariaveisMedidas INTO percentagem;
    
    SELECT cultura.NomeCultura FROM cultura, variaveis_medidas WHERE variaveis_medidas.IdVariaveisMedidas = new.IdVariaveisMedidas AND variaveis_medidas.IDCultura = cultura.IDCultura INTO nomeCultura;
    SELECT variaveis.NomeVariavel FROM variaveis, variaveis_medidas WHERE variaveis_medidas.IdVariaveisMedidas = new.IdVariaveisMedidas AND variaveis_medidas.IDVariavel = variaveis.IDVariavel INTO nomeVariavel;
    
	SET intervaloMed = limiteS-LimiteI;
    SET margem = intervaloMed*percentagem;
    
	INSERT into logs VALUES (null, CURRENT_USER, "medicoes", "INSERT", "Não Aplicável", CONCAT("NumeroMedicao", ": ", new.NumeroMedicao, "  DataHoraMedicao", ": ", new.DataHoraMedicao, "  ValorMedicao", ": ", new.ValorMedicao, "  IdVariaveisMedidas", ": ", new.IdVariaveisMedidas), NOW(),0);

	IF(new.ValorMedicao < limiteI)
    THEN INSERT into alertas VALUES(null, nomeVariavel, nomeCultura, CURRENT_USER, NOW(), limiteI, limiteS, new.ValorMedicao, "O valor da medição ultrapassou o limite inferior.");
    
    ELSEIF(new.ValorMedicao = limiteI)
    THEN INSERT into alertas VALUES(null, nomeVariavel, nomeCultura, CURRENT_USER, NOW(), limiteI, limiteS, new.ValorMedicao, "O valor da medição atingiu o limite inferior.");
    
    ELSEIF(new.ValorMedicao > limiteI AND new.ValorMedicao <= limiteI+margem)
    THEN INSERT into alertas VALUES(null, nomeVariavel, nomeCultura, CURRENT_USER, NOW(), limiteI, limiteS, new.ValorMedicao, "O valor da medição está próximo do limite inferior.");
    
    ELSEIF(new.ValorMedicao >= limiteS-margem AND new.ValorMedicao < limiteS)
    THEN INSERT into alertas VALUES(null, nomeVariavel, nomeCultura, CURRENT_USER, NOW(), limiteI, limiteS, new.ValorMedicao, "O valor da medição está próximo do limite superior.");
    
    ELSEIF(new.ValorMedicao = limiteS)
    THEN INSERT into alertas VALUES(null, nomeVariavel, nomeCultura, CURRENT_USER, NOW(), limiteI, limiteS, new.ValorMedicao, "O valor da medição atingiu o limite superior.");
    
    ELSEIF(new.ValorMedicao > limiteS)
    THEN INSERT into alertas VALUES(null, nomeVariavel, nomeCultura, CURRENT_USER, NOW(), limiteI, limiteS, new.ValorMedicao, "O valor da medição ultrapassou o limite superior.");
    END IF;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `updateMedicoes` AFTER UPDATE ON `medicoes` FOR EACH ROW INSERT into logs VALUES (null, CURRENT_USER, "medicoes", "UPDATE", CONCAT("NumeroMedicao", ": ", old.NumeroMedicao, "  DataHoraMedicao", ": ", old.DataHoraMedicao, "  ValorMedicao", ": ", old.ValorMedicao, "  IdVariaveisMedidas", ": ", old.IdVariaveisMedidas), CONCAT("NumeroMedicao", ": ", new.NumeroMedicao, "  DataHoraMedicao", ": ", new.DataHoraMedicao, "  ValorMedicao", ": ", new.ValorMedicao, "  IdVariaveisMedidas", ": ", new.IdVariaveisMedidas), NOW(), 0)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `medicoes_luminosidade`
--

CREATE TABLE `medicoes_luminosidade` (
  `DataHoraMedicao` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ValorMedicaoLuminosidade` decimal(8,2) NOT NULL,
  `IDMedicao` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Acionadores `medicoes_luminosidade`
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
-- Estrutura da tabela `medicoes_luminosidade_incorretas`
--

CREATE TABLE `medicoes_luminosidade_incorretas` (
  `DataHoraMedicao` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ValorMedicaoLuminosidade` decimal(8,2) NOT NULL,
  `IDMedicao` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `medicoes_temperatura`
--

CREATE TABLE `medicoes_temperatura` (
  `DataHoraMedicao` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ValorMedicaoTemperatura` decimal(8,2) NOT NULL,
  `IDMedicao` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Acionadores `medicoes_temperatura`
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
-- Estrutura da tabela `medicoes_temperatura_incorretas`
--

CREATE TABLE `medicoes_temperatura_incorretas` (
  `DataHoraMedicao` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ValorMedicaoTemperatura` decimal(8,2) NOT NULL,
  `IDMedicao` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `sistema`
--

CREATE TABLE `sistema` (
  `LimiteInferiorTemperatura` decimal(8,2) NOT NULL,
  `LimiteSuperiorTemperatura` decimal(8,2) NOT NULL,
  `MargemSegurancaTemperatura` decimal(8,2) NOT NULL,
  `LimiteInferiorLuz` decimal(8,2) NOT NULL,
  `LimiteSuperiorLuz` decimal(8,2) NOT NULL,
  `MargemSegurancaLuz` decimal(8,2) NOT NULL,
  `PercentagemVariacaoTemperatura` decimal(8,2) NOT NULL,
  `PercentagemVariacaoLuz` decimal(8,2) NOT NULL,
  `TempoEntreAlertasConsecutivos` decimal(8,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `sistema`
--

INSERT INTO `sistema` (`LimiteInferiorTemperatura`, `LimiteSuperiorTemperatura`, `MargemSegurancaTemperatura`, `LimiteInferiorLuz`, `LimiteSuperiorLuz`, `MargemSegurancaLuz`, `PercentagemVariacaoTemperatura`, `PercentagemVariacaoLuz`, `TempoEntreAlertasConsecutivos`) VALUES
('19.00', '30.00', '0.00', '1.00', '3.00', '0.00', '0.00', '0.00', '0.00');

--
-- Acionadores `sistema`
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
-- Estrutura da tabela `variaveis`
--

CREATE TABLE `variaveis` (
  `IDVariavel` int(11) NOT NULL,
  `NomeVariavel` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `variaveis`
--

INSERT INTO `variaveis` (`IDVariavel`, `NomeVariavel`) VALUES
(3, 'Chumbo'),
(4, 'nomeDaVariavel'),
(5, 'nomeDaVariavel'),
(6, 'nomeDaVariavel'),
(7, 'nomeDaVariavel'),
(8, 'nomeDaVariavel'),
(9, 'nomeDaVariavel'),
(10, 'nomeDaVariavel'),
(11, 'nomeDaVariavel'),
(12, 'nomeDaVariavel'),
(13, 'nomeDaVariavel'),
(14, 'nomeDaVariavel'),
(15, 'nomeDaVariavel'),
(16, 'nomeDaVariavel'),
(17, 'nomeDaVariavel'),
(18, 'nomeDaVariavel'),
(19, 'nomeDaVariavel'),
(20, 'nomeDaVariavel'),
(21, 'nomeDaVariavel'),
(22, 'nomeDaVariavel'),
(23, 'nomeDaVariavel'),
(24, 'nomeDaVariavel'),
(25, 'nomeDaVariavel'),
(26, 'nomeDaVariavel'),
(27, 'nomeDaVariavel'),
(28, 'nomeDaVariavel'),
(29, 'nomeDaVariavel'),
(30, 'nomeDaVariavel'),
(31, 'nomeDaVariavel'),
(32, 'nomeDaVariavel'),
(33, 'nomeDaVariavel'),
(34, 'nomeDaVariavel'),
(35, 'nomeDaVariavel'),
(36, 'nomeDaVariavel'),
(37, 'nomeDaVariavel'),
(38, 'nomeDaVariavel'),
(39, 'nomeDaVariavel'),
(40, 'nomeDaVariavel'),
(41, 'nomeDaVariavel');

--
-- Acionadores `variaveis`
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
-- Estrutura da tabela `variaveis_medidas`
--

CREATE TABLE `variaveis_medidas` (
  `IDVariavel` int(11) NOT NULL,
  `IDCultura` int(11) NOT NULL,
  `LimiteInferior` decimal(8,2) NOT NULL,
  `LimiteSuperior` decimal(8,2) NOT NULL,
  `MargemSegurancaVariavel` decimal(8,2) DEFAULT NULL,
  `IdVariaveisMedidas` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `variaveis_medidas`
--

INSERT INTO `variaveis_medidas` (`IDVariavel`, `IDCultura`, `LimiteInferior`, `LimiteSuperior`, `MargemSegurancaVariavel`, `IdVariaveisMedidas`) VALUES
(3, 4, '2.85', '8.25', '0.10', 1),
(8, 2, '5.00', '9.50', '0.20', 2);

--
-- Acionadores `variaveis_medidas`
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
-- Indexes for table `alertas`
--
ALTER TABLE `alertas`
  ADD PRIMARY KEY (`idAlerta`);

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
-- Indexes for table `medicoes_luminosidade_incorretas`
--
ALTER TABLE `medicoes_luminosidade_incorretas`
  ADD PRIMARY KEY (`IDMedicao`);

--
-- Indexes for table `medicoes_temperatura`
--
ALTER TABLE `medicoes_temperatura`
  ADD PRIMARY KEY (`IDMedicao`);

--
-- Indexes for table `medicoes_temperatura_incorretas`
--
ALTER TABLE `medicoes_temperatura_incorretas`
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
-- AUTO_INCREMENT for table `alertas`
--
ALTER TABLE `alertas`
  MODIFY `idAlerta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `cultura`
--
ALTER TABLE `cultura`
  MODIFY `IDCultura` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `logs`
--
ALTER TABLE `logs`
  MODIFY `logId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=250;

--
-- AUTO_INCREMENT for table `medicoes`
--
ALTER TABLE `medicoes`
  MODIFY `NumeroMedicao` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `medicoes_luminosidade`
--
ALTER TABLE `medicoes_luminosidade`
  MODIFY `IDMedicao` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `medicoes_luminosidade_incorretas`
--
ALTER TABLE `medicoes_luminosidade_incorretas`
  MODIFY `IDMedicao` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `medicoes_temperatura`
--
ALTER TABLE `medicoes_temperatura`
  MODIFY `IDMedicao` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `medicoes_temperatura_incorretas`
--
ALTER TABLE `medicoes_temperatura_incorretas`
  MODIFY `IDMedicao` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `variaveis`
--
ALTER TABLE `variaveis`
  MODIFY `IDVariavel` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `variaveis_medidas`
--
ALTER TABLE `variaveis_medidas`
  MODIFY `IdVariaveisMedidas` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Limitadores para a tabela `cultura`
--
ALTER TABLE `cultura`
  ADD CONSTRAINT `cultura_ibfk_1` FOREIGN KEY (`EmailInvestigador`) REFERENCES `investigador` (`Email`);

--
-- Limitadores para a tabela `medicoes`
--
ALTER TABLE `medicoes`
  ADD CONSTRAINT `medicoes_ibfk_1` FOREIGN KEY (`IdVariaveisMedidas`) REFERENCES `variaveis_medidas` (`IdVariaveisMedidas`);

--
-- Limitadores para a tabela `variaveis_medidas`
--
ALTER TABLE `variaveis_medidas`
  ADD CONSTRAINT `variaveis_medidas_ibfk_1` FOREIGN KEY (`IDCultura`) REFERENCES `cultura` (`IDCultura`),
  ADD CONSTRAINT `variaveis_medidas_ibfk_2` FOREIGN KEY (`IDVariavel`) REFERENCES `variaveis` (`IDVariavel`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
