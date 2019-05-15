-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: 15-Maio-2019 às 03:00
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
GRANT SELECT ON estufa.variaveis_medidas TO investigador;

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
GRANT SELECT ON mysql.User TO administrador;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `criarPrivilegiosExecute` ()  BEGIN

GRANT EXECUTE ON PROCEDURE estufa.apagarCultura TO administrador,investigador;
GRANT EXECUTE ON PROCEDURE estufa.selectUserCulturas TO investigador;
GRANT EXECUTE ON PROCEDURE estufa.apagarVariaveis TO administrador,investigador;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `selectUserCulturas` ()  NO SQL
BEGIN

	SET @sql1 := CONCAT('CREATE TEMPORARY TABLE test AS SELECT email FROM mysql.user WHERE CONCAT(mysql.user.USER, "@%")=CURRENT_USER');
    PREPARE statement FROM @sql1;
    EXECUTE statement;
        
    SET @sql2 := CONCAT('SELECT * FROM cultura WHERE cultura.EmailInvestigador IN (SELECT * FROM test)');
    PREPARE statement FROM @sql2;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateVariaveis` (IN `variableId` INT, IN `newName` VARCHAR(100))  NO SQL
UPDATE variaveis SET variaveis.NomeVariavel = newName WHERE variaveis.IDVariavel = variableId$$

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
(30, 'Chumbo', 'Cenouras', 'root@localhost', '2019-05-06 12:16:44', '2.85', '8.25', '13.52', 'O valor da medição ultrapassou o limite superior.'),
(31, 'Chumbo', 'Alfaces', 'root@localhost', '2019-05-12 22:55:48', '3.00', '4.00', '3.00', 'O valor da medição atingiu o limite inferior.'),
(32, 'Chumbo', 'Alfaces', 'root@localhost', '2019-05-12 22:56:01', '3.00', '4.00', '2.00', 'O valor da medição ultrapassou o limite inferior.'),
(33, 'Chumbo', 'Alfaces', 'root@localhost', '2019-05-12 22:56:01', '3.00', '4.00', '8.00', 'O valor da medição ultrapassou o limite superior.');

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
(6, 'battas', 'sd', 'joaofneto97@gmail.com'),
(7, 'Alfaces', 'Cultura HIdropónica', 'testeinvestigador@gmail.com');

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
('aaa', 'aaa', 'investigador'),
('abc', 'El Chap', 'abc'),
('aDFSDFV', 'sfdafd', 'sadsd'),
('afga', 'asddsa', 'wcafdv'),
('b', 'b', 'b'),
('c', 'c', 'c'),
('eumail', 'eu', 'sadad'),
('hmbs@gmail.com', 'hmbs', 'eng'),
('joaofneto97@gmail.com', 'joao', 'chefe'),
('jonas@gmail.com', 'jonas', 'programador'),
('jorge@gmail.com', 'Jorge', 'admin'),
('lala@gmail.com', 'wqser', 'qwer'),
('p@p.p', 'pipu', '0'),
('qwe', 'sens', 'asd'),
('qwerty', 'boneca', 'asdfg'),
('sdfvsdfvc', 'adscfsad', 'sfcvsfdcv'),
('testeAdministrador@gmail.com', 'testeAdministrador', 'admin'),
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
(249, 'root@localhost', 'investigador', 'DELETE', 'Email: testeinsertcultura@gmail.com  NomeInvestigador: TesteInsert  CategoriaProfissional: teste teste', 'Linha Eliminada', '2019-05-09 13:51:14', 0),
(250, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 42  NomeVariavel: nomeDaVariavel', '2019-05-09 16:35:58', 0),
(251, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 16:35:58', 0),
(252, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 16:35:58', 0),
(253, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 43  NomeVariavel: nomeDaVariavel', '2019-05-09 17:00:04', 0),
(254, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 17:00:04', 0),
(255, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 17:00:04', 0),
(256, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 44  NomeVariavel: nomeDaVariavel', '2019-05-09 17:01:42', 0),
(257, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 17:01:42', 0),
(258, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 17:01:42', 0),
(259, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 45  NomeVariavel: nomeDaVariavel', '2019-05-09 17:11:03', 0),
(260, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 17:11:03', 0),
(261, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 17:11:03', 0),
(262, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 46  NomeVariavel: nomeDaVariavel', '2019-05-09 17:13:54', 0),
(263, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 17:13:54', 0),
(264, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 17:13:54', 0),
(265, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 47  NomeVariavel: nomeDaVariavel', '2019-05-09 17:14:21', 0),
(266, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 17:14:21', 0),
(267, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 17:14:21', 0),
(268, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 48  NomeVariavel: nomeDaVariavel', '2019-05-09 17:14:38', 0),
(269, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 17:14:38', 0),
(270, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 17:14:38', 0),
(271, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 49  NomeVariavel: nomeDaVariavel', '2019-05-09 17:17:26', 0),
(272, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 17:17:26', 0),
(273, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 17:17:26', 0),
(274, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 50  NomeVariavel: nomeDaVariavel', '2019-05-09 17:17:58', 0),
(275, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 17:17:58', 0),
(276, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-09 17:17:58', 0),
(277, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 51  NomeVariavel: nomeDaVariavel', '2019-05-09 17:20:32', 0),
(278, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 52  NomeVariavel: nomeDaVariavel', '2019-05-09 17:21:45', 0),
(279, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 53  NomeVariavel: nomeDaVariavel', '2019-05-09 17:22:10', 0),
(280, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 54  NomeVariavel: nomeDaVariavel', '2019-05-09 17:22:41', 0),
(281, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 55  NomeVariavel: nomeDaVariavel', '2019-05-09 17:22:59', 0),
(282, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 56  NomeVariavel: nomeDaVariavel', '2019-05-09 17:23:26', 0),
(283, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 57  NomeVariavel: nomeDaVariavel', '2019-05-09 17:34:06', 0),
(284, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 58  NomeVariavel: nomeDaVariavel', '2019-05-09 17:40:08', 0),
(285, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 59  NomeVariavel: nomeDaVariavel', '2019-05-09 17:48:54', 0),
(286, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 60  NomeVariavel: nomeDaVariavel', '2019-05-09 17:49:56', 0),
(287, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 61  NomeVariavel: nomeDaVariavel', '2019-05-09 17:55:14', 0),
(288, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 62  NomeVariavel: nomeDaVariavel', '2019-05-09 22:51:44', 0),
(289, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 63  NomeVariavel: nomeDaVariavel', '2019-05-09 23:28:10', 0),
(290, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 64  NomeVariavel: nomeDaVariavel', '2019-05-09 23:59:28', 0),
(291, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 65  NomeVariavel: nomeDaVariavel', '2019-05-10 00:11:50', 0),
(292, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 66  NomeVariavel: nomeDaVariavel', '2019-05-10 00:13:39', 0),
(293, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 67  NomeVariavel: nomeDaVariavel', '2019-05-10 00:13:57', 0),
(294, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 68  NomeVariavel: nomeDaVariavel', '2019-05-10 00:15:24', 0),
(295, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 69  NomeVariavel: nomeDaVariavel', '2019-05-10 00:16:05', 0),
(296, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 70  NomeVariavel: nomeDaVariavel', '2019-05-11 17:37:20', 0),
(297, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 71  NomeVariavel: nomeDaVariavel', '2019-05-11 17:40:16', 0),
(298, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 72  NomeVariavel: nomeDaVariavel', '2019-05-11 17:42:24', 0),
(299, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 73  NomeVariavel: nomeDaVariavel', '2019-05-11 17:46:45', 0),
(300, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 74  NomeVariavel: nomeDaVariavel', '2019-05-11 17:47:37', 0),
(301, 'root@localhost', 'cultura', 'INSERT', 'Não Aplicável', 'IdCultura: 8  NomeCultura: Cerejas  DescricaoCultura: Cultura hidroponica  EmailInvestigador: hmbs@gmail.com', '2019-05-11 17:47:37', 0),
(302, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 10  DataHoraMedicao: 2019-05-03 23:26:07  ValorMedicao: 7.71  IdVariaveisMedidas: 1', 'NumeroMedicao: 10  DataHoraMedicao: 2019-05-11 17:49:56  ValorMedicao: 8.11  IdVariaveisMedidas: 1', '2019-05-11 17:49:56', 0),
(303, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 75  NomeVariavel: nomeDaVariavel', '2019-05-11 17:52:56', 0),
(304, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 76  NomeVariavel: nomeDaVariavel', '2019-05-11 17:56:20', 0),
(305, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-11 17:56:21', 0),
(306, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-11 17:56:21', 0),
(307, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 3  DataHoraMedicao: 2019-05-03 23:21:57  ValorMedicao: 2.85  IdVariaveisMedidas: 1', 'NumeroMedicao: 3  DataHoraMedicao: 2019-05-11 17:56:21  ValorMedicao: 3.25  IdVariaveisMedidas: 1', '2019-05-11 17:56:21', 0),
(308, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 77  NomeVariavel: nomeDaVariavel', '2019-05-11 17:59:30', 0),
(309, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-11 17:59:30', 0),
(310, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-11 17:59:30', 0),
(311, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 3  DataHoraMedicao: 2019-05-11 17:56:21  ValorMedicao: 3.25  IdVariaveisMedidas: 1', 'NumeroMedicao: 3  DataHoraMedicao: 2019-05-11 17:56:21  ValorMedicao: 3.25  IdVariaveisMedidas: 1', '2019-05-11 17:59:30', 0),
(312, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 78  NomeVariavel: nomeDaVariavel', '2019-05-11 18:03:31', 0),
(313, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-11 18:03:31', 0),
(314, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-11 18:03:31', 0),
(315, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 3  DataHoraMedicao: 2019-05-11 17:56:21  ValorMedicao: 3.25  IdVariaveisMedidas: 1', 'NumeroMedicao: 3  DataHoraMedicao: 2019-05-11 17:56:21  ValorMedicao: 3.25  IdVariaveisMedidas: 1', '2019-05-11 18:03:31', 0),
(316, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 79  NomeVariavel: nomeDaVariavel', '2019-05-11 18:05:37', 0),
(317, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 80  NomeVariavel: nomeDaVariavel', '2019-05-11 18:11:42', 0),
(318, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-11 18:11:42', 0),
(319, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-11 18:11:42', 0),
(320, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 3  DataHoraMedicao: 2019-05-11 17:56:21  ValorMedicao: 3.25  IdVariaveisMedidas: 1', 'NumeroMedicao: 3  DataHoraMedicao: 2019-05-11 17:56:21  ValorMedicao: 3.25  IdVariaveisMedidas: 1', '2019-05-11 18:11:42', 0),
(321, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 81  NomeVariavel: nomeDaVariavel', '2019-05-11 18:12:45', 0),
(322, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 82  NomeVariavel: nomeDaVariavel', '2019-05-11 18:16:49', 0),
(323, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: jorge@gmail.com  NomeInvestigador: Jorge  CategoriaProfissional: admin', '2019-05-12 13:41:49', 0),
(324, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 83  NomeVariavel: nomeDaVariavel', '2019-05-12 13:43:51', 0),
(325, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 84  NomeVariavel: nomeDaVariavel', '2019-05-12 14:02:43', 0),
(326, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 85  NomeVariavel: nomeDaVariavel', '2019-05-12 15:36:45', 0),
(327, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 86  NomeVariavel: nomeDaVariavel', '2019-05-12 15:37:34', 0),
(328, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-12 15:37:34', 0),
(329, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-12 15:37:34', 0),
(330, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 24  DataHoraMedicao: 2019-05-04 17:44:45  ValorMedicao: 3.85  IdVariaveisMedidas: 2', 'Linha Eliminada', '2019-05-12 15:37:34', 0),
(331, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 25  DataHoraMedicao: 2019-05-04 17:45:21  ValorMedicao: 5.42  IdVariaveisMedidas: 2', 'Linha Eliminada', '2019-05-12 15:37:34', 0),
(332, 'root@localhost', 'variaveis_medidas', 'DELETE', 'IDVariavel: 8  IDCultura: 2  LimiteInferior: 5.00  LimiteSuperior: 9.50  IdVariaveisMedidas: 2', 'Linha Eliminada', '2019-05-12 15:37:34', 0),
(333, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 8  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-12 15:37:34', 0),
(334, 'root@localhost', 'variaveis', 'UPDATE', 'IDVariavel: 13  NomeVariavel: nomeDaVariavel', 'IDVariavel: 13  NomeVariavel: Mercurio', '2019-05-12 16:33:14', 0),
(335, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: testeAdministrador@gmail.com  NomeInvestigador: testeAdministrador  CategoriaProfissional: admin', '2019-05-12 16:56:25', 0),
(336, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 87  NomeVariavel: nomeDaVariavel', '2019-05-12 19:20:57', 0),
(337, 'root@localhost', 'cultura', 'DELETE', 'IdCultura: 8  NomeCultura: Cerejas  DescricaoCultura: Cultura hidroponica  EmailInvestigador: hmbs@gmail.com', 'Linha Eliminada', '2019-05-12 19:23:34', 0),
(338, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 88  NomeVariavel: nomeDaVariavel', '2019-05-12 19:24:34', 0),
(339, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 89  NomeVariavel: nomeDaVariavel', '2019-05-12 19:26:03', 0),
(340, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 90  NomeVariavel: nomeDaVariavel', '2019-05-12 19:28:22', 0),
(341, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-12 19:28:22', 0),
(342, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-12 19:28:22', 0),
(343, 'root@localhost', 'cultura', 'DELETE', 'IdCultura: 5  NomeCultura: Pimentos  DescricaoCultura: Cultura Hidropónica  EmailInvestigador: afga', 'Linha Eliminada', '2019-05-12 19:28:22', 0),
(344, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 91  NomeVariavel: nomeDaVariavel', '2019-05-12 19:32:05', 0),
(345, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: aaa  NomeInvestigador: aaa  CategoriaProfissional: investigador', '2019-05-12 22:13:05', 0),
(346, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 92  NomeVariavel: nomeDaVariavel', '2019-05-12 22:13:05', 0),
(347, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-12 22:13:05', 0),
(348, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-12 22:13:05', 0),
(349, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 93  NomeVariavel: nomeDaVariavel', '2019-05-12 22:15:57', 0),
(350, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-12 22:15:57', 0),
(351, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-12 22:15:57', 0),
(352, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 94  NomeVariavel: nomeDaVariavel', '2019-05-12 22:21:08', 0),
(353, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-12 22:21:09', 0),
(354, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-12 22:21:09', 0),
(355, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 95  NomeVariavel: nomeDaVariavel', '2019-05-12 22:24:04', 0),
(356, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 96  NomeVariavel: nomeDaVariavel', '2019-05-12 22:25:13', 0),
(357, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 97  NomeVariavel: nomeDaVariavel', '2019-05-12 22:26:23', 0),
(358, 'root@localhost', 'cultura', 'INSERT', 'Não Aplicável', 'IdCultura: 7  NomeCultura: Alfaces  DescricaoCultura: Cultura HIdropónica  EmailInvestigador: testeinvestigador@gmail.com', '2019-05-12 22:31:28', 0),
(359, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 98  NomeVariavel: nomeDaVariavel', '2019-05-12 22:33:14', 0),
(360, 'root@localhost', 'variaveis_medidas', 'INSERT', 'Não Aplicável', 'IDVariavel: 3  IDCultura: 7  LimiteInferior: 3.00  LimiteSuperior: 4.00  IdVariaveisMedidas: 2', '2019-05-12 22:55:18', 0),
(361, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 24  DataHoraMedicao: 2019-05-12 22:55:48  ValorMedicao: 3.00  IdVariaveisMedidas: 2', '2019-05-12 22:55:48', 0),
(362, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 25  DataHoraMedicao: 2019-05-12 22:56:01  ValorMedicao: 2.00  IdVariaveisMedidas: 2', '2019-05-12 22:56:01', 0),
(363, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 26  DataHoraMedicao: 2019-05-12 22:56:01  ValorMedicao: 8.00  IdVariaveisMedidas: 2', '2019-05-12 22:56:01', 0),
(364, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 99  NomeVariavel: nomeDaVariavel', '2019-05-12 23:19:37', 0),
(365, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 100  NomeVariavel: nomeDaVariavel', '2019-05-13 11:32:15', 0),
(366, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 101  NomeVariavel: nomeDaVariavel', '2019-05-13 11:38:18', 0),
(367, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 102  NomeVariavel: nomeDaVariavel', '2019-05-13 11:40:12', 0),
(368, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 103  NomeVariavel: nomeDaVariavel', '2019-05-13 11:41:24', 0),
(369, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 104  NomeVariavel: nomeDaVariavel', '2019-05-13 11:43:27', 0),
(370, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 105  NomeVariavel: nomeDaVariavel', '2019-05-13 11:48:26', 0),
(371, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 106  NomeVariavel: nomeDaVariavel', '2019-05-13 11:55:57', 0),
(372, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 107  NomeVariavel: nomeDaVariavel', '2019-05-13 11:58:15', 0),
(373, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 108  NomeVariavel: nomeDaVariavel', '2019-05-13 11:59:36', 0),
(374, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 109  NomeVariavel: nomeDaVariavel', '2019-05-13 12:19:55', 0),
(375, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 110  NomeVariavel: nomeDaVariavel', '2019-05-13 12:20:56', 0),
(376, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 111  NomeVariavel: nomeDaVariavel', '2019-05-13 12:24:33', 0);
INSERT INTO `logs` (`logId`, `username`, `nomeTabela`, `comandoUsado`, `linhaAnterior`, `resultado`, `dataComando`, `exportado`) VALUES
(377, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 112  NomeVariavel: nomeDaVariavel', '2019-05-13 12:24:56', 0),
(378, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 113  NomeVariavel: nomeDaVariavel', '2019-05-13 12:25:38', 0),
(379, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 114  NomeVariavel: nomeDaVariavel', '2019-05-13 12:26:05', 0),
(380, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 115  NomeVariavel: nomeDaVariavel', '2019-05-13 12:26:49', 0),
(381, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 116  NomeVariavel: nomeDaVariavel', '2019-05-13 12:27:41', 0),
(382, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 117  NomeVariavel: nomeDaVariavel', '2019-05-13 12:29:50', 0),
(383, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 118  NomeVariavel: nomeDaVariavel', '2019-05-13 12:35:21', 0),
(384, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 119  NomeVariavel: nomeDaVariavel', '2019-05-13 12:36:03', 0),
(385, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 120  NomeVariavel: nomeDaVariavel', '2019-05-13 12:36:52', 0),
(386, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 121  NomeVariavel: nomeDaVariavel', '2019-05-13 12:41:29', 0),
(387, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 122  NomeVariavel: nomeDaVariavel', '2019-05-13 17:44:27', 0),
(388, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 123  NomeVariavel: nomeDaVariavel', '2019-05-13 17:47:12', 0),
(389, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 124  NomeVariavel: nomeDaVariavel', '2019-05-13 17:50:51', 0),
(390, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 125  NomeVariavel: nomeDaVariavel', '2019-05-14 00:03:19', 0),
(391, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 126  NomeVariavel: nomeDaVariavel', '2019-05-14 00:05:41', 0),
(392, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-14 00:05:41', 0),
(393, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-14 00:05:41', 0),
(394, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 127  NomeVariavel: nomeDaVariavel', '2019-05-14 00:44:38', 0),
(395, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 128  NomeVariavel: nomeDaVariavel', '2019-05-14 12:00:27', 0),
(396, 'root@localhost', 'cultura', 'INSERT', 'Não Aplicável', 'IdCultura: 8  NomeCultura: Bananas  DescricaoCultura: cultura hidro  EmailInvestigador: TesteInvestigador@gmail.com', '2019-05-14 12:00:27', 0),
(397, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 129  NomeVariavel: nomeDaVariavel', '2019-05-14 12:01:18', 0),
(398, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 130  NomeVariavel: nomeDaVariavel', '2019-05-14 12:01:47', 0),
(399, 'root@localhost', 'cultura', 'DELETE', 'IdCultura: 8  NomeCultura: Bananas  DescricaoCultura: cultura hidro  EmailInvestigador: TesteInvestigador@gmail.com', 'Linha Eliminada', '2019-05-14 12:01:47', 0),
(400, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 131  NomeVariavel: nomeDaVariavel', '2019-05-14 12:02:25', 0),
(401, 'root@localhost', 'cultura', 'INSERT', 'Não Aplicável', 'IdCultura: 14  NomeCultura: Bananas  DescricaoCultura: cultura hidro  EmailInvestigador: TesteInvestigador@gmail.com', '2019-05-14 12:02:25', 0),
(402, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 132  NomeVariavel: nomeDaVariavel', '2019-05-14 12:02:48', 0),
(403, 'root@localhost', 'cultura', 'DELETE', 'IdCultura: 14  NomeCultura: Bananas  DescricaoCultura: cultura hidro  EmailInvestigador: TesteInvestigador@gmail.com', 'Linha Eliminada', '2019-05-14 12:02:48', 0),
(404, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 27  DataHoraMedicao: 2019-05-14 19:19:42  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 19:19:42', 0),
(405, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 24  DataHoraMedicao: 2019-05-12 22:55:48  ValorMedicao: 3.00  IdVariaveisMedidas: 2', 'Linha Eliminada', '2019-05-14 19:24:39', 0),
(406, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 25  DataHoraMedicao: 2019-05-12 22:56:01  ValorMedicao: 2.00  IdVariaveisMedidas: 2', 'Linha Eliminada', '2019-05-14 19:24:39', 0),
(407, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 26  DataHoraMedicao: 2019-05-12 22:56:01  ValorMedicao: 8.00  IdVariaveisMedidas: 2', 'Linha Eliminada', '2019-05-14 19:24:39', 0),
(408, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 27  DataHoraMedicao: 2019-05-14 19:19:42  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-14 19:24:39', 0),
(409, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 28  DataHoraMedicao: 2019-05-14 19:26:30  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 19:26:30', 0),
(410, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 29  DataHoraMedicao: 2019-05-14 19:27:44  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 19:27:44', 0),
(411, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:31:15  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 19:31:15', 0),
(412, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:31:15  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:31:15  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-14 19:31:15', 0),
(413, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:31:15  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:31:15  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 19:31:15', 0),
(414, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 23  DataHoraMedicao: 2019-05-04 17:43:24  ValorMedicao: 1.58  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-14 19:32:24', 0),
(415, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 28  DataHoraMedicao: 2019-05-14 19:26:30  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-14 19:32:24', 0),
(416, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 29  DataHoraMedicao: 2019-05-14 19:27:44  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-14 19:32:24', 0),
(417, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:31:15  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-14 19:32:24', 0),
(418, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:32:41  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 19:32:41', 0),
(419, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:32:41  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:32:41  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-14 19:32:41', 0),
(420, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:32:41  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:32:41  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 19:32:41', 0),
(421, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:32:41  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-14 19:33:36', 0),
(422, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:34:00  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 19:34:00', 0),
(423, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:34:00  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:34:00  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-14 19:34:00', 0),
(424, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:34:00  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:34:00  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 19:34:00', 0),
(425, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:34:00  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:35:35  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-14 19:35:35', 0),
(426, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:35:35  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:35:35  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 19:35:35', 0),
(427, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:35:35  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-14 19:35:48', 0),
(428, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:36:58  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 19:36:58', 0),
(429, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:36:58  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:36:58  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-14 19:36:58', 0),
(430, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:36:58  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:36:58  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 19:36:58', 0),
(431, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:36:58  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-14 19:36:58', 0),
(432, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:44:28  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 19:44:28', 0),
(433, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:44:28  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:44:28  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-14 19:44:28', 0),
(434, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:44:28  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:44:28  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 19:44:28', 0),
(435, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:44:28  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-14 19:44:28', 0),
(436, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:45:37  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 19:45:37', 0),
(437, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:45:37  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:45:37  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-14 19:45:37', 0),
(438, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:45:37  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:45:37  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 19:45:37', 0),
(439, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 19:45:37  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-14 19:45:37', 0),
(440, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 20:50:20  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 20:50:20', 0),
(441, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 20:50:20  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 20:50:20  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-14 20:50:20', 0),
(442, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 20:50:20  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 20:50:20  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 20:50:20', 0),
(443, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 20:50:20  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-14 20:50:20', 0),
(444, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 20:51:10  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 20:51:10', 0),
(445, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 20:51:10  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 20:51:10  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-14 20:51:10', 0),
(446, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 20:51:10  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 20:51:10  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 20:51:10', 0),
(447, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 20:51:10  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-14 20:51:10', 0),
(448, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 21:02:56  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 21:02:56', 0),
(449, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 21:02:56  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-14 21:29:52', 0),
(450, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 21:30:12  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 21:30:12', 0),
(451, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 21:30:12  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-14 21:31:14', 0),
(452, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 21:32:07  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 21:32:07', 0),
(453, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 21:32:07  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-14 23:01:33', 0),
(454, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:14:46  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 23:14:46', 0),
(455, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:14:46  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-14 23:14:46', 0),
(456, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:15:16  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 23:15:16', 0),
(457, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:15:16  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-14 23:15:16', 0),
(458, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:18:09  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 23:18:09', 0),
(459, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:18:09  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-14 23:18:09', 0),
(460, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:28:01  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 23:28:01', 0),
(461, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:28:01  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-14 23:28:01', 0),
(462, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:28:39  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 23:28:39', 0),
(463, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:28:39  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-14 23:28:39', 0),
(464, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:33:28  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 23:33:28', 0),
(465, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:33:28  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:33:28  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 23:33:28', 0),
(466, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:33:28  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-14 23:33:28', 0),
(467, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:34:00  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 23:34:00', 0),
(468, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:34:00  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:34:00  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-14 23:34:00', 0),
(469, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:34:00  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-14 23:34:00', 0),
(470, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:34:38  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 23:34:38', 0),
(471, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:34:38  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:34:38  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-14 23:34:38', 0),
(472, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:34:38  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:34:38  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-14 23:38:40', 0),
(473, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:34:38  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-14 23:38:40', 0),
(474, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:40:20  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 23:40:20', 0),
(475, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:40:20  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:40:20  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-14 23:40:20', 0),
(476, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:40:20  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-14 23:40:20', 0),
(477, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:42:35  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 23:42:35', 0),
(478, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:42:35  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:42:35  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-14 23:42:35', 0),
(479, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:42:35  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-14 23:42:35', 0),
(480, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:44:05  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 23:44:05', 0),
(481, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:44:05  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:44:05  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-14 23:44:05', 0),
(482, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:44:05  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-14 23:44:05', 0),
(483, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:46:44  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 23:46:44', 0),
(484, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:46:44  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:46:44  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-14 23:46:44', 0),
(485, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:46:44  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-14 23:46:44', 0),
(486, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:48:18  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 23:48:18', 0),
(487, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:48:18  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:48:18  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-14 23:48:18', 0),
(488, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:48:18  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-14 23:48:18', 0),
(489, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:51:11  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-14 23:51:11', 0),
(490, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:51:11  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:51:11  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-14 23:51:11', 0),
(491, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-14 23:51:11  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-14 23:51:11', 0),
(492, 'root@localhost', 'cultura', 'INSERT', 'Não Aplicável', 'IdCultura: 8  NomeCultura: teste  DescricaoCultura: tdd  EmailInvestigador: lala@gmail.com', '2019-05-14 23:52:36', 0),
(493, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:01:42  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 00:01:42', 0),
(494, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:01:42  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:01:42  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 00:01:42', 0),
(495, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:01:42  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 00:01:42', 0),
(496, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:05:19  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 00:05:19', 0),
(497, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:05:19  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:05:19  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 00:05:19', 0),
(498, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:05:19  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 00:05:19', 0),
(499, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 133  NomeVariavel: nomeDaVariavel', '2019-05-15 00:09:52', 0),
(500, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-15 00:09:52', 0),
(501, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-15 00:09:52', 0),
(502, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 134  NomeVariavel: nomeDaVariavel', '2019-05-15 00:10:32', 0),
(503, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-15 00:10:32', 0),
(504, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', 'LimiteInferiorTemperatura: 19.00  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 1.00  LimiteSuperiorLuz: 3.00', '2019-05-15 00:10:32', 0),
(505, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:11:49  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 00:11:49', 0),
(506, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:11:49  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:11:49  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 00:11:49', 0),
(507, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:11:49  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 00:11:49', 0),
(508, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:17:14  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 00:17:14', 0),
(509, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:17:14  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:17:14  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 00:17:14', 0),
(510, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:17:14  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 00:17:14', 0),
(511, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:26:34  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 00:26:34', 0),
(512, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:26:34  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:26:34  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 00:26:34', 0),
(513, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:26:34  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 00:26:34', 0),
(514, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:28:08  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 00:28:08', 0),
(515, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:28:08  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:28:08  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 00:28:08', 0),
(516, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:28:08  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 00:28:08', 0),
(517, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:30:55  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 00:30:55', 0),
(518, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:30:55  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:30:55  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 00:30:55', 0),
(519, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:30:55  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 00:30:56', 0),
(520, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: testeapi@gmail.com  NomeInvestigador: TesteAPI  CategoriaProfissional: teste', '2019-05-15 00:34:23', 0),
(521, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:34:23  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 00:34:23', 0),
(522, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:34:23  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:34:23  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 00:34:23', 0),
(523, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:34:23  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 00:34:23', 0),
(524, 'root@localhost', 'investigador', 'DELETE', 'Email: testeapi@gmail.com  NomeInvestigador: TesteAPI  CategoriaProfissional: teste', 'Linha Eliminada', '2019-05-15 00:37:23', 0),
(525, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:37:23  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 00:37:23', 0),
(526, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:37:23  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:37:23  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 00:37:23', 0),
(527, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:37:23  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 00:37:23', 0),
(528, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: testeapi@gmail.com  NomeInvestigador: TesteAPI  CategoriaProfissional: teste', '2019-05-15 00:41:21', 0),
(529, 'root@localhost', 'investigador', 'DELETE', 'Email: testeapi@gmail.com  NomeInvestigador: TesteAPI  CategoriaProfissional: teste', 'Linha Eliminada', '2019-05-15 00:41:21', 0),
(530, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:41:21  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 00:41:21', 0),
(531, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:41:21  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:41:21  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 00:41:21', 0),
(532, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:41:21  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 00:41:21', 0),
(533, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: testeapi@gmail.com  NomeInvestigador: TesteAPI  CategoriaProfissional: teste', '2019-05-15 00:49:46', 0),
(534, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:49:46  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 00:49:46', 0),
(535, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:49:46  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:49:46  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 00:49:46', 0),
(536, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:49:46  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 00:49:46', 0),
(537, 'root@localhost', 'investigador', 'DELETE', 'Email: testeapi@gmail.com  NomeInvestigador: TesteAPI  CategoriaProfissional: teste', 'Linha Eliminada', '2019-05-15 00:51:11', 0),
(538, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:51:11  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 00:51:11', 0),
(539, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:51:11  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:51:11  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 00:51:11', 0),
(540, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:51:11  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 00:51:11', 0),
(541, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: testeapi@gmail.com  NomeInvestigador: TesteAPI  CategoriaProfissional: teste', '2019-05-15 00:52:51', 0),
(542, 'root@localhost', 'investigador', 'DELETE', 'Email: testeapi@gmail.com  NomeInvestigador: TesteAPI  CategoriaProfissional: teste', 'Linha Eliminada', '2019-05-15 00:52:51', 0),
(543, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:52:51  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 00:52:51', 0),
(544, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:52:51  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:52:51  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 00:52:51', 0),
(545, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:52:51  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 00:52:51', 0),
(546, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: testeapi@gmail.com  NomeInvestigador: TesteAPI  CategoriaProfissional: teste', '2019-05-15 00:58:50', 0),
(547, 'root@localhost', 'investigador', 'UPDATE', 'Email: testeapi@gmail.com  NomeInvestigador: TesteAPI  CategoriaProfissional: teste', 'Email: testeapi@gmail.com  NomeInvestigador: TesteAPIES  CategoriaProfissional: teste', '2019-05-15 00:58:50', 0),
(548, 'root@localhost', 'investigador', 'UPDATE', 'Email: testeapi@gmail.com  NomeInvestigador: TesteAPIES  CategoriaProfissional: teste', 'Email: testeapi@gmail.com  NomeInvestigador: TesteAPIES  CategoriaProfissional: testeteste', '2019-05-15 00:58:50', 0),
(549, 'root@localhost', 'investigador', 'UPDATE', 'Email: testeapi@gmail.com  NomeInvestigador: TesteAPIES  CategoriaProfissional: testeteste', 'Email: testeapies@gmail.com  NomeInvestigador: TesteAPIES  CategoriaProfissional: testeteste', '2019-05-15 00:58:50', 0),
(550, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:58:50  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 00:58:50', 0),
(551, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:58:50  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:58:50  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 00:58:50', 0),
(552, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 00:58:50  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 00:58:50', 0),
(553, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:02:18  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 01:02:18', 0),
(554, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:02:18  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:02:18  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 01:02:18', 0),
(555, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:02:18  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 01:02:18', 0),
(556, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:02:53  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 01:02:53', 0),
(557, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:02:53  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:02:53  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 01:02:53', 0),
(558, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:02:53  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 01:02:53', 0),
(559, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:03:01  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 01:03:01', 0),
(560, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:03:01  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:03:01  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 01:03:01', 0),
(561, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:03:01  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 01:03:01', 0),
(562, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:04:02  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 01:04:02', 0),
(563, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:04:02  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:04:02  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 01:04:02', 0),
(564, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:04:02  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 01:04:02', 0),
(565, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:04:41  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 01:04:41', 0),
(566, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:04:41  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:04:41  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 01:04:41', 0),
(567, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:04:41  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 01:04:41', 0),
(568, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:05:33  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 01:05:33', 0),
(569, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:05:33  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:05:33  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 01:05:33', 0),
(570, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:05:33  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 01:05:33', 0),
(571, 'root@localhost', 'investigador', 'DELETE', 'Email: testeapies@gmail.com  NomeInvestigador: TesteAPIES  CategoriaProfissional: testeteste', 'Linha Eliminada', '2019-05-15 01:06:16', 0),
(572, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:07:06  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 01:07:06', 0),
(573, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:07:06  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:07:06  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 01:07:06', 0),
(574, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:07:06  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 01:07:06', 0),
(575, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:08:13  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 01:08:13', 0),
(576, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:08:13  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:08:13  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 01:08:13', 0),
(577, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:08:13  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 01:08:13', 0),
(578, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:08:41  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 01:08:41', 0),
(579, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:08:41  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:08:41  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 01:08:41', 0),
(580, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:08:41  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 01:08:41', 0),
(581, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:10:24  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 01:10:24', 0),
(582, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:10:24  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:10:24  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 01:10:24', 0),
(583, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:10:24  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 01:10:24', 0),
(584, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:11:33  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 01:11:33', 0),
(585, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:11:33  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:11:34  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 01:11:34', 0),
(586, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:11:34  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 01:11:34', 0),
(587, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:20:33  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 01:20:33', 0),
(588, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:20:33  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:20:33  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 01:20:33', 0),
(589, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:20:33  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 01:20:33', 0),
(590, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:22:00  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 01:22:00', 0),
(591, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:22:00  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:22:00  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 01:22:00', 0),
(592, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:22:00  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 01:22:00', 0),
(593, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:24:45  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 01:24:45', 0),
(594, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:24:45  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:24:45  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 01:24:45', 0),
(595, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:24:45  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 01:24:45', 0),
(596, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:25:04  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 01:25:04', 0),
(597, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:25:04  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:25:04  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 01:25:04', 0),
(598, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:25:04  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 01:25:04', 0),
(599, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:34:05  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 01:34:05', 0),
(600, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:34:05  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:34:05  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 01:34:05', 0),
(601, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:34:05  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 01:34:05', 0),
(602, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:34:55  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 01:34:55', 0),
(603, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:34:55  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:34:55  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 01:34:55', 0),
(604, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:34:55  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 01:34:55', 0),
(605, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:38:16  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 01:38:16', 0),
(606, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:38:16  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:38:16  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 01:38:16', 0),
(607, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:38:16  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 01:38:16', 0),
(608, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:42:22  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 01:42:22', 0),
(609, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:42:22  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:42:22  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 01:42:22', 0),
(610, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:42:22  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 01:42:22', 0),
(611, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:43:36  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 01:43:36', 0);
INSERT INTO `logs` (`logId`, `username`, `nomeTabela`, `comandoUsado`, `linhaAnterior`, `resultado`, `dataComando`, `exportado`) VALUES
(612, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:43:36  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:43:36  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 01:43:36', 0),
(613, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:43:36  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 01:43:36', 0),
(614, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:43:52  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 01:43:52', 0),
(615, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:43:52  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:43:52  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 01:43:52', 0),
(616, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:43:52  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 01:43:52', 0),
(617, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:45:42  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 01:45:42', 0),
(618, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:45:42  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:45:42  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 01:45:42', 0),
(619, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:45:42  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 01:45:42', 0),
(620, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:46:16  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 01:46:16', 0),
(621, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:46:16  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:46:16  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 01:46:16', 0),
(622, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:46:16  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 01:46:16', 0),
(623, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:48:14  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 01:48:14', 0),
(624, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:48:14  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:48:14  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 01:48:14', 0),
(625, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:48:14  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 01:48:14', 0),
(626, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:49:09  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 01:49:09', 0),
(627, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:49:09  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:49:09  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 01:49:09', 0),
(628, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:49:09  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 01:49:09', 0),
(629, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:50:19  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 01:50:19', 0),
(630, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:50:19  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:50:20  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 01:50:20', 0),
(631, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:50:20  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 01:50:20', 0),
(632, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:51:06  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 01:51:06', 0),
(633, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:51:06  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:51:06  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 01:51:06', 0),
(634, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:51:06  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 01:51:06', 0),
(635, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:52:05  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 01:52:05', 0),
(636, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:52:05  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:52:05  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 01:52:05', 0),
(637, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:52:05  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 01:52:05', 0),
(638, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:54:03  ValorMedicao: 3.56  IdVariaveisMedidas: 1', '2019-05-15 01:54:03', 0),
(639, 'root@localhost', 'medicoes', 'UPDATE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:54:03  ValorMedicao: 3.56  IdVariaveisMedidas: 1', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:54:03  ValorMedicao: 4.56  IdVariaveisMedidas: 1', '2019-05-15 01:54:03', 0),
(640, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 40  DataHoraMedicao: 2019-05-15 01:54:03  ValorMedicao: 4.56  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-05-15 01:54:03', 0),
(641, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 15  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(642, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 16  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(643, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 17  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(644, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 18  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(645, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 19  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(646, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 20  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(647, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 21  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(648, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 22  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(649, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 23  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(650, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 24  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(651, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 25  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(652, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 26  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(653, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 27  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(654, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 28  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(655, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 29  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(656, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 30  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(657, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 31  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(658, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 32  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(659, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 33  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(660, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 34  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(661, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 35  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(662, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 36  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(663, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 37  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(664, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 38  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(665, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 39  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(666, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 40  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(667, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 41  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(668, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 42  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(669, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 43  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(670, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 44  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(671, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 45  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(672, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 46  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(673, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 47  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(674, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 48  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(675, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 49  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(676, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 50  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(677, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 51  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(678, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 52  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(679, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 53  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(680, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 54  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(681, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 55  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(682, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 56  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(683, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 57  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(684, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 58  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(685, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 59  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(686, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 60  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(687, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 61  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(688, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 62  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(689, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 63  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(690, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 64  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(691, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 65  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(692, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 66  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(693, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 67  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(694, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 68  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(695, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 69  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(696, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 70  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(697, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 71  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(698, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 72  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(699, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 73  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(700, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 74  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(701, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 75  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(702, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 76  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(703, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 77  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(704, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 78  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(705, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 79  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(706, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 80  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(707, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 81  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(708, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 82  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(709, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 83  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(710, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 84  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(711, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 85  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(712, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 86  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(713, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 87  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(714, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 88  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(715, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 89  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(716, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 90  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(717, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 91  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(718, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 92  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(719, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 93  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(720, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 94  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(721, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 95  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(722, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 96  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(723, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 97  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(724, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 98  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(725, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 99  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(726, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 100  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(727, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 101  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(728, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 102  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(729, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 103  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(730, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 104  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(731, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 105  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(732, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 106  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(733, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 107  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(734, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 108  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(735, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 109  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(736, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 110  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(737, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 111  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(738, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 112  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(739, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 113  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(740, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 114  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(741, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 115  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(742, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 116  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(743, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 117  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(744, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 118  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(745, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 119  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(746, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 120  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(747, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 121  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(748, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 122  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(749, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 123  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(750, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 124  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(751, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 125  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(752, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 126  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(753, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 127  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(754, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 128  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(755, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 129  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(756, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 130  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(757, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 131  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(758, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 132  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(759, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 133  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(760, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 134  NomeVariavel: nomeDaVariavel', 'Linha Eliminada', '2019-05-15 01:57:54', 0),
(761, 'root@localhost', 'cultura', 'DELETE', 'IdCultura: 8  NomeCultura: teste  DescricaoCultura: tdd  EmailInvestigador: lala@gmail.com', 'Linha Eliminada', '2019-05-15 01:58:18', 0);

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
(3, '2019-05-11 16:56:21', '3.25', 1),
(4, '2019-05-03 22:22:27', '2.50', 1),
(5, '2019-05-03 22:23:14', '2.86', 1),
(6, '2019-05-03 22:23:41', '3.01', 1),
(7, '2019-05-03 22:24:19', '3.39', 1),
(8, '2019-05-03 22:24:40', '3.40', 1),
(9, '2019-05-03 22:25:45', '7.70', 1),
(10, '2019-05-11 16:49:56', '8.11', 1),
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
(22, '2019-05-04 16:42:48', '10.25', 1);

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
  `TempoEntreAlertasConsecutivos` decimal(8,2) NOT NULL,
  `TempoExport` decimal(8,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `sistema`
--

INSERT INTO `sistema` (`LimiteInferiorTemperatura`, `LimiteSuperiorTemperatura`, `MargemSegurancaTemperatura`, `LimiteInferiorLuz`, `LimiteSuperiorLuz`, `MargemSegurancaLuz`, `PercentagemVariacaoTemperatura`, `PercentagemVariacaoLuz`, `TempoEntreAlertasConsecutivos`, `TempoExport`) VALUES
('19.00', '30.00', '0.00', '1.00', '3.00', '0.00', '0.00', '0.00', '0.00', '0.00');

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
(9, 'nomeDaVariavel'),
(10, 'nomeDaVariavel'),
(11, 'nomeDaVariavel'),
(12, 'nomeDaVariavel'),
(13, 'Mercurio'),
(14, 'nomeDaVariavel');

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
(3, 7, '3.00', '4.00', '0.80', 2);

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
  MODIFY `idAlerta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `cultura`
--
ALTER TABLE `cultura`
  MODIFY `IDCultura` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `logs`
--
ALTER TABLE `logs`
  MODIFY `logId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=762;

--
-- AUTO_INCREMENT for table `medicoes`
--
ALTER TABLE `medicoes`
  MODIFY `NumeroMedicao` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

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
  MODIFY `IDVariavel` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=135;

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
