-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: 01-Maio-2019 às 22:02
-- Versão do servidor: 10.1.37-MariaDB
-- versão do PHP: 7.2.12

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
SET @sql := CONCAT('CREATE USER ', 'java', ' IDENTIFIED BY ', QUOTE('php'));
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
GRANT INSERT ON estufa.medicao_luminosidade TO javaUser;
GRANT INSERT ON estufa.medicao_temperatura TO javaUser;
GRANT INSERT ON estufa.alertas TO javaUser;
GRANT INSERT ON estufa.medicoes_temperatura_incorretas TO javaUser;
GRANT INSERT ON estufa.medicoes_luminosidade_incorretas TO javaUser;
GRANT SELECT ON estufa.sistema TO javaUser;
GRANT SELECT ON estufa.variaveis_medidas TO javaUser;

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `criarRoles` ()  CREATE ROLE IF NOT EXISTS investigador, administrador, sensorLuminosidade, sensorTemperatura,  phpUser, javaUser$$

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
    
    CALL createJavaUser;

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
-- Estrutura da tabela `alertas`
--

CREATE TABLE `alertas` (
  `idAlerta` int(11) NOT NULL,
  `nomeVariavel` varchar(100) DEFAULT NULL,
  `nomeCultura` varchar(100) DEFAULT NULL,
  `emailInvestigador` varchar(100) NOT NULL,
  `data` datetime NOT NULL,
  `valor` decimal(8,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `alertas`
--

INSERT INTO `alertas` (`idAlerta`, `nomeVariavel`, `nomeCultura`, `emailInvestigador`, `data`, `valor`) VALUES
(5, 'PH', 'Batatas', 'pedro@gmail.com', '2019-04-01 00:00:00', '7.80'),
(6, 'CHUMBO', 'Cebola', 'carlos@gmail.com', '2019-04-13 00:00:00', '3.57');

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
(2, 'Tomate', 'fsdkjfvjksdjkfsd', 'lala@gmail.com'),
(4, 'Beterraba', 'Cultura Hidroponica ++', 'hmbs@gmail.com');

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
('jonas@gmail.com', 'jonas', 'programador'),
('lala@gmail.com', 'wqser', 'qwer'),
('p@p.p', 'pipu', '0'),
('qwe', 'sens', 'asd'),
('qwerty', 'boneca', 'asdfg'),
('sdfvsdfvc', 'adscfsad', 'sfcvsfdcv'),
('teste@gmail.com', 'testeeee', 'chefe'),
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
(42, 'root@localhost', 'cultura', 'DELETE', 'IdCultura: 2  NomeCultura: Pepinos  DescricaoCultura: cultura hidroponica  EmailInvestigador: eumail', 'Linha Eliminada', '2019-03-30 21:13:16', 0),
(43, 'root@localhost', 'cultura', 'INSERT', 'Não Aplicável', 'IdCultura: 3  NomeCultura: pimentos  DescricaoCultura: dsjfkjsdhfkjdkv  EmailInvestigador: lala@gmail.com', '2019-03-30 21:13:54', 0),
(44, 'root@localhost', 'cultura', 'DELETE', 'IdCultura: 3  NomeCultura: pimentos  DescricaoCultura: dsjfkjsdhfkjdkv  EmailInvestigador: lala@gmail.com', 'Linha Eliminada', '2019-03-30 21:14:15', 0),
(45, 'root@localhost', 'medicoes', 'SELECT', 'Não Aplicável', 'medicoes.NumeroMedicao = 1', '2019-03-30 21:22:54', 0),
(46, 'root@localhost', 'cultura', 'UPDATE', 'IdCultura: 1  NomeCultura: cenouras  DescricaoCultura: Daucus carota subsp. sativus   EmailInvestigador: lala@gmail.com', 'IdCultura: 1  NomeCultura: cenouras  DescricaoCultura: Daucus carota subs  EmailInvestigador: lala@gmail.com', '2019-03-30 23:48:31', 0),
(47, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 1  DataHoraMedicao: 2019-03-14 14:05:52  ValorMedicao: 5.00  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-03-30 23:58:08', 0),
(48, 'root@localhost', 'variaveis_medidas', 'DELETE', 'IDVariavel: 1  IDCultura: 1  LimiteInferior: 3.00  LimiteSuperior: 7.00  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-03-30 23:58:47', 0),
(49, 'root@localhost', 'cultura', 'DELETE', 'IdCultura: 1  NomeCultura: cenouras  DescricaoCultura: Daucus carota subs  EmailInvestigador: lala@gmail.com', 'Linha Eliminada', '2019-03-30 23:59:24', 0),
(50, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: hmbs@gmail.com  NomeInvestigador: hmbs  CategoriaProfissional: eng', '2019-04-03 19:29:51', 0),
(51, 'root@localhost', 'sistema', 'DELETE', 'LimiteInferiorTemperatura: 19.50  LimiteSuperiorTemperatura: 25.00  LimiteInferiorLuz: 2.00  LimiteSuperiorLuz: 5.00', 'Linha Eliminada', '2019-04-03 19:58:23', 0),
(52, 'root@localhost', 'sistema', 'DELETE', 'LimiteInferiorTemperatura: 19.50  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 5.00  LimiteSuperiorLuz: 9.00', 'Linha Eliminada', '2019-04-03 19:58:23', 0),
(53, 'root@localhost', 'sistema', 'INSERT', 'Não Aplicável', 'LimiteInferiorTemperatura: 2.00  LimiteSuperiorTemperatura: 5.00  LimiteInferiorLuz: 8.00  LimiteSuperiorLuz: 10.00', '2019-04-03 19:58:46', 0),
(54, 'root@localhost', 'sistema', 'UPDATE', 'LimiteInferiorTemperatura: 2.00  LimiteSuperiorTemperatura: 5.00  LimiteInferiorLuz: 8.00  LimiteSuperiorLuz: 10.00', 'LimiteInferiorTemperatura: 1.00  LimiteSuperiorTemperatura: 5.00  LimiteInferiorLuz: 8.00  LimiteSuperiorLuz: 10.00', '2019-04-03 20:00:13', 0),
(55, 'root@localhost', 'cultura', 'INSERT', 'Não Aplicável', 'IdCultura: 1  NomeCultura: couves  DescricaoCultura: hgvhgv  EmailInvestigador: afga', '2019-04-03 22:01:43', 0),
(56, 'root@localhost', 'medicoes', 'SELECT', 'Não Aplicável', '1=1', '2019-04-03 23:51:41', 0),
(57, 'root@localhost', 'variaveis_medidas', 'INSERT', 'Não Aplicável', 'IDVariavel: 1  IDCultura: 1  LimiteInferior: 5.00  LimiteSuperior: 10.00  IdVariaveisMedidas: 1', '2019-04-03 23:52:27', 0),
(58, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 1  DataHoraMedicao: 2019-04-03 23:52:44  ValorMedicao: 8.00  IdVariaveisMedidas: 1', '2019-04-03 23:52:44', 0),
(59, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 2  DataHoraMedicao: 2019-04-03 23:52:57  ValorMedicao: 7.00  IdVariaveisMedidas: 1', '2019-04-03 23:52:57', 0),
(60, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 3  DataHoraMedicao: 2019-04-03 23:52:57  ValorMedicao: 6.00  IdVariaveisMedidas: 1', '2019-04-03 23:52:57', 0),
(61, 'root@localhost', 'medicoes', 'SELECT', 'Não Aplicável', '1=1', '2019-04-03 23:53:15', 0),
(62, 'root@localhost', 'cultura', 'INSERT', 'Não Aplicável', 'IdCultura: 2  NomeCultura: Tomate  DescricaoCultura: fsdkjfvjksdjkfsd  EmailInvestigador: lala@gmail.com', '2019-04-07 19:09:18', 0),
(63, 'root@localhost', 'cultura', 'INSERT', 'Não Aplicável', 'IdCultura: 3  NomeCultura: Alface  DescricaoCultura: dfsfregegehbhre  EmailInvestigador: p@p.p', '2019-04-07 19:09:18', 0),
(64, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 2  NomeVariavel: Mercurio', '2019-04-07 19:10:00', 0),
(65, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 3  NomeVariavel: Chumbo', '2019-04-07 19:10:00', 0),
(66, 'root@localhost', 'variaveis_medidas', 'INSERT', 'Não Aplicável', 'IDVariavel: 2  IDCultura: 2  LimiteInferior: 7.00  LimiteSuperior: 8.00  IdVariaveisMedidas: 2', '2019-04-07 19:11:16', 0),
(67, 'root@localhost', 'variaveis_medidas', 'INSERT', 'Não Aplicável', 'IDVariavel: 3  IDCultura: 3  LimiteInferior: 2.00  LimiteSuperior: 8.00  IdVariaveisMedidas: 3', '2019-04-07 19:11:16', 0),
(68, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 4  DataHoraMedicao: 2019-04-07 19:12:43  ValorMedicao: 4.00  IdVariaveisMedidas: 2', '2019-04-07 19:12:43', 0),
(69, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 5  DataHoraMedicao: 2019-04-07 19:12:43  ValorMedicao: 6.00  IdVariaveisMedidas: 2', '2019-04-07 19:12:43', 0),
(70, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 6  DataHoraMedicao: 2019-04-07 19:12:43  ValorMedicao: 2.00  IdVariaveisMedidas: 2', '2019-04-07 19:12:43', 0),
(71, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 7  DataHoraMedicao: 2019-04-07 19:12:43  ValorMedicao: 9.00  IdVariaveisMedidas: 2', '2019-04-07 19:12:43', 0),
(72, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 8  DataHoraMedicao: 2019-04-07 19:12:43  ValorMedicao: 4.00  IdVariaveisMedidas: 2', '2019-04-07 19:12:43', 0),
(73, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 9  DataHoraMedicao: 2019-04-07 19:13:18  ValorMedicao: 1.00  IdVariaveisMedidas: 3', '2019-04-07 19:13:18', 0),
(74, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 10  DataHoraMedicao: 2019-04-07 19:13:18  ValorMedicao: 8.00  IdVariaveisMedidas: 3', '2019-04-07 19:13:18', 0),
(75, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 11  DataHoraMedicao: 2019-04-07 19:13:18  ValorMedicao: 6.00  IdVariaveisMedidas: 3', '2019-04-07 19:13:18', 0),
(76, 'root@localhost', 'variaveis_medidas', 'INSERT', 'Não Aplicável', 'IDVariavel: 3  IDCultura: 1  LimiteInferior: 3.00  LimiteSuperior: 8.00  IdVariaveisMedidas: 4', '2019-04-07 23:45:20', 0),
(77, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 12  DataHoraMedicao: 2019-04-08 01:19:35  ValorMedicao: 5.00  IdVariaveisMedidas: 4', '2019-04-08 01:19:35', 0),
(78, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 13  DataHoraMedicao: 2019-04-08 01:19:35  ValorMedicao: 1.00  IdVariaveisMedidas: 4', '2019-04-08 01:19:35', 0),
(79, 'root@localhost', 'investigador', 'INSERT', 'Não Aplicável', 'Email: teste@gmail.com  NomeInvestigador: testeeee  CategoriaProfissional: chefe', '2019-04-08 17:43:33', 0),
(80, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 4  NomeVariavel: nomeDaVariavel', '2019-04-08 17:43:33', 0),
(81, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 5  NomeVariavel: nomeDaVariavel', '2019-04-09 00:52:52', 0),
(82, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 6  NomeVariavel: nomeDaVariavel', '2019-04-09 12:37:24', 0),
(83, 'root@localhost', 'cultura', 'INSERT', 'Não Aplicável', 'IdCultura: 4  NomeCultura: Beterraba  DescricaoCultura: Cultura Hidroponica  EmailInvestigador: hmbs@gmail.com', '2019-04-09 12:37:24', 0),
(84, 'root@localhost', 'cultura', 'UPDATE', 'IdCultura: 4  NomeCultura: Beterraba  DescricaoCultura: Cultura Hidroponica  EmailInvestigador: hmbs@gmail.com', 'IdCultura: 4  NomeCultura: Beterraba  DescricaoCultura: Cultura Hidroponica ++  EmailInvestigador: hmbs@gmail.com', '2019-04-09 12:43:45', 0),
(85, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 1  DataHoraMedicao: 2019-04-03 23:52:44  ValorMedicao: 8.00  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-04-09 13:42:35', 0),
(86, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 2  DataHoraMedicao: 2019-04-03 23:52:57  ValorMedicao: 7.00  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-04-09 13:42:35', 0),
(87, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 3  DataHoraMedicao: 2019-04-03 23:52:57  ValorMedicao: 6.00  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-04-09 13:42:35', 0),
(88, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 12  DataHoraMedicao: 2019-04-08 01:19:35  ValorMedicao: 5.00  IdVariaveisMedidas: 4', 'Linha Eliminada', '2019-04-09 13:42:35', 0),
(89, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 13  DataHoraMedicao: 2019-04-08 01:19:35  ValorMedicao: 1.00  IdVariaveisMedidas: 4', 'Linha Eliminada', '2019-04-09 13:42:35', 0),
(90, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 14  DataHoraMedicao: 2019-04-09 13:44:33  ValorMedicao: 1.00  IdVariaveisMedidas: 1', '2019-04-09 13:44:33', 0),
(91, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 15  DataHoraMedicao: 2019-04-09 13:44:33  ValorMedicao: 2.00  IdVariaveisMedidas: 1', '2019-04-09 13:44:33', 0),
(92, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 16  DataHoraMedicao: 2019-04-09 13:44:33  ValorMedicao: 3.00  IdVariaveisMedidas: 1', '2019-04-09 13:44:33', 0),
(93, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 17  DataHoraMedicao: 2019-04-09 13:44:33  ValorMedicao: 4.00  IdVariaveisMedidas: 4', '2019-04-09 13:44:33', 0),
(94, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 18  DataHoraMedicao: 2019-04-09 13:44:33  ValorMedicao: 5.00  IdVariaveisMedidas: 4', '2019-04-09 13:44:33', 0),
(95, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 14  DataHoraMedicao: 2019-04-09 13:44:33  ValorMedicao: 1.00  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-04-09 13:53:30', 0),
(96, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 15  DataHoraMedicao: 2019-04-09 13:44:33  ValorMedicao: 2.00  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-04-09 13:53:30', 0),
(97, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 16  DataHoraMedicao: 2019-04-09 13:44:33  ValorMedicao: 3.00  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-04-09 13:53:30', 0),
(98, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 17  DataHoraMedicao: 2019-04-09 13:44:33  ValorMedicao: 4.00  IdVariaveisMedidas: 4', 'Linha Eliminada', '2019-04-09 13:53:30', 0),
(99, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 18  DataHoraMedicao: 2019-04-09 13:44:33  ValorMedicao: 5.00  IdVariaveisMedidas: 4', 'Linha Eliminada', '2019-04-09 13:53:30', 0),
(100, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 19  DataHoraMedicao: 2019-04-09 13:54:28  ValorMedicao: 1.00  IdVariaveisMedidas: 1', '2019-04-09 13:54:28', 0),
(101, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 20  DataHoraMedicao: 2019-04-09 13:54:28  ValorMedicao: 2.00  IdVariaveisMedidas: 1', '2019-04-09 13:54:28', 0),
(102, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 21  DataHoraMedicao: 2019-04-09 13:54:28  ValorMedicao: 3.00  IdVariaveisMedidas: 1', '2019-04-09 13:54:28', 0),
(103, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 22  DataHoraMedicao: 2019-04-09 13:54:28  ValorMedicao: 4.00  IdVariaveisMedidas: 4', '2019-04-09 13:54:28', 0),
(104, 'root@localhost', 'medicoes', 'INSERT', 'Não Aplicável', 'NumeroMedicao: 23  DataHoraMedicao: 2019-04-09 13:54:28  ValorMedicao: 5.00  IdVariaveisMedidas: 4', '2019-04-09 13:54:28', 0),
(105, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 19  DataHoraMedicao: 2019-04-09 13:54:28  ValorMedicao: 1.00  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-04-09 13:55:19', 0),
(106, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 20  DataHoraMedicao: 2019-04-09 13:54:28  ValorMedicao: 2.00  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-04-09 13:55:19', 0),
(107, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 21  DataHoraMedicao: 2019-04-09 13:54:28  ValorMedicao: 3.00  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-04-09 13:55:19', 0),
(108, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 22  DataHoraMedicao: 2019-04-09 13:54:28  ValorMedicao: 4.00  IdVariaveisMedidas: 4', 'Linha Eliminada', '2019-04-09 13:55:19', 0),
(109, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 23  DataHoraMedicao: 2019-04-09 13:54:28  ValorMedicao: 5.00  IdVariaveisMedidas: 4', 'Linha Eliminada', '2019-04-09 13:55:19', 0),
(110, 'root@localhost', 'variaveis_medidas', 'DELETE', 'IDVariavel: 1  IDCultura: 1  LimiteInferior: 5.00  LimiteSuperior: 10.00  IdVariaveisMedidas: 1', 'Linha Eliminada', '2019-04-09 13:55:19', 0),
(111, 'root@localhost', 'variaveis_medidas', 'DELETE', 'IDVariavel: 3  IDCultura: 1  LimiteInferior: 3.00  LimiteSuperior: 8.00  IdVariaveisMedidas: 4', 'Linha Eliminada', '2019-04-09 13:55:19', 0),
(112, 'root@localhost', 'cultura', 'DELETE', 'IdCultura: 1  NomeCultura: couves  DescricaoCultura: hgvhgv  EmailInvestigador: afga', 'Linha Eliminada', '2019-04-09 13:55:19', 0),
(113, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 1  NomeVariavel: pH', 'Linha Eliminada', '2019-04-09 14:06:09', 0),
(114, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 4  DataHoraMedicao: 2019-04-07 19:12:43  ValorMedicao: 4.00  IdVariaveisMedidas: 2', 'Linha Eliminada', '2019-04-09 14:07:20', 0),
(115, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 5  DataHoraMedicao: 2019-04-07 19:12:43  ValorMedicao: 6.00  IdVariaveisMedidas: 2', 'Linha Eliminada', '2019-04-09 14:07:20', 0),
(116, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 6  DataHoraMedicao: 2019-04-07 19:12:43  ValorMedicao: 2.00  IdVariaveisMedidas: 2', 'Linha Eliminada', '2019-04-09 14:07:20', 0),
(117, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 7  DataHoraMedicao: 2019-04-07 19:12:43  ValorMedicao: 9.00  IdVariaveisMedidas: 2', 'Linha Eliminada', '2019-04-09 14:07:20', 0),
(118, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 8  DataHoraMedicao: 2019-04-07 19:12:43  ValorMedicao: 4.00  IdVariaveisMedidas: 2', 'Linha Eliminada', '2019-04-09 14:07:20', 0),
(119, 'root@localhost', 'variaveis_medidas', 'DELETE', 'IDVariavel: 2  IDCultura: 2  LimiteInferior: 7.00  LimiteSuperior: 8.00  IdVariaveisMedidas: 2', 'Linha Eliminada', '2019-04-09 14:07:20', 0),
(120, 'root@localhost', 'variaveis', 'DELETE', 'IDVariavel: 2  NomeVariavel: Mercurio', 'Linha Eliminada', '2019-04-09 14:07:20', 0),
(121, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 7  NomeVariavel: nomeDaVariavel', '2019-04-11 15:21:11', 0),
(122, 'root@localhost', 'cultura', 'INSERT', 'Não Aplicável', 'IdCultura: 5  NomeCultura: Pepinos  DescricaoCultura: Cultura Hidroponica  EmailInvestigador: hmbs@gmail.com', '2019-04-11 15:21:11', 0),
(123, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 8  NomeVariavel: nomeDaVariavel', '2019-04-11 15:22:27', 0),
(124, 'root@localhost', 'cultura', 'DELETE', 'IdCultura: 5  NomeCultura: Pepinos  DescricaoCultura: Cultura Hidroponica  EmailInvestigador: hmbs@gmail.com', 'Linha Eliminada', '2019-04-11 15:22:27', 0),
(125, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 9  NomeVariavel: nomeDaVariavel', '2019-04-11 15:22:49', 0),
(126, 'root@localhost', 'variaveis', 'INSERT', 'Não Aplicável', 'IDVariavel: 10  NomeVariavel: nomeDaVariavel', '2019-04-11 15:23:25', 0),
(127, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 9  DataHoraMedicao: 2019-04-07 19:13:18  ValorMedicao: 1.00  IdVariaveisMedidas: 3', 'Linha Eliminada', '2019-04-11 15:23:25', 0),
(128, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 10  DataHoraMedicao: 2019-04-07 19:13:18  ValorMedicao: 8.00  IdVariaveisMedidas: 3', 'Linha Eliminada', '2019-04-11 15:23:25', 0),
(129, 'root@localhost', 'medicoes', 'DELETE', 'NumeroMedicao: 11  DataHoraMedicao: 2019-04-07 19:13:18  ValorMedicao: 6.00  IdVariaveisMedidas: 3', 'Linha Eliminada', '2019-04-11 15:23:25', 0),
(130, 'root@localhost', 'variaveis_medidas', 'DELETE', 'IDVariavel: 3  IDCultura: 3  LimiteInferior: 2.00  LimiteSuperior: 8.00  IdVariaveisMedidas: 3', 'Linha Eliminada', '2019-04-11 15:23:25', 0),
(131, 'root@localhost', 'cultura', 'DELETE', 'IdCultura: 3  NomeCultura: Alface  DescricaoCultura: dfsfregegehbhre  EmailInvestigador: p@p.p', 'Linha Eliminada', '2019-04-11 15:23:25', 0);

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
-- Acionadores `medicoes`
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
  `PercentagemVariacaoLuz` decimal(8,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `sistema`
--

INSERT INTO `sistema` (`LimiteInferiorTemperatura`, `LimiteSuperiorTemperatura`, `MargemSegurancaTemperatura`, `LimiteInferiorLuz`, `LimiteSuperiorLuz`, `MargemSegurancaLuz`, `PercentagemVariacaoTemperatura`, `PercentagemVariacaoLuz`) VALUES
('1.00', '5.00', '0.00', '8.00', '10.00', '0.00', '0.00', '0.00');

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
(10, 'nomeDaVariavel');

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
  MODIFY `idAlerta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `cultura`
--
ALTER TABLE `cultura`
  MODIFY `IDCultura` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `logs`
--
ALTER TABLE `logs`
  MODIFY `logId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=132;

--
-- AUTO_INCREMENT for table `medicoes`
--
ALTER TABLE `medicoes`
  MODIFY `NumeroMedicao` int(11) NOT NULL AUTO_INCREMENT;

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
  MODIFY `IDVariavel` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `variaveis_medidas`
--
ALTER TABLE `variaveis_medidas`
  MODIFY `IdVariaveisMedidas` int(11) NOT NULL AUTO_INCREMENT;

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
