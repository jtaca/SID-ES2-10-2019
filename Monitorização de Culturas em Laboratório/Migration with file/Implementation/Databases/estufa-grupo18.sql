-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: 18-Mar-2019 às 21:50
-- Versão do servidor: 10.1.37-MariaDB
-- versão do PHP: 7.3.1

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
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_administrador` (IN `var_nome` VARCHAR(50), IN `var_password` VARCHAR(50))  NO SQL
BEGIN

	DROP USER IF EXISTS ''@localhost;

    SET @sql := CONCAT('CREATE USER ', QUOTE(var_nome), ' IDENTIFIED BY ', QUOTE(var_password));
    PREPARE statement FROM @sql;
    EXECUTE statement;

    SET @sql := CONCAT('GRANT administrador TO ', QUOTE(var_nome));
    PREPARE statement FROM @sql;
    EXECUTE statement;

    SET @sql := CONCAT('SET DEFAULT ROLE administrador FOR ', 		QUOTE(var_nome));
    PREPARE statement FROM @sql;
    EXECUTE statement;

    DEALLOCATE PREPARE statement;
    FLUSH PRIVILEGES;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_investigador` (IN `var_nome` VARCHAR(50), IN `var_password` VARCHAR(50), IN `var_email` VARCHAR(100), IN `var_categoria_profissional` VARCHAR(100))  NO SQL
BEGIN

	DROP USER IF EXISTS ''@localhost;

    ALTER TABLE mysql.user ADD COLUMN IF NOT EXISTS email varchar(100);

    SET @sql := CONCAT('CREATE USER ', QUOTE(var_nome), ' IDENTIFIED BY ', QUOTE(var_password));
    PREPARE statement FROM @sql;
    EXECUTE statement;

    SET @sql := CONCAT('GRANT investigador TO ', QUOTE(var_nome));
    PREPARE statement FROM @sql;
    EXECUTE statement;

    SET @sql := CONCAT('SET DEFAULT ROLE investigador FOR ', 		QUOTE(var_nome));
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

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `export_cultura` ()  BEGIN

SELECT * INTO OUTFILE 'C:logs_cultura.csv '
  FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM log_cultura
  WHERE log_cultura.IDLog > (SELECT IDLogCultura FROM `dadosexportados`) ;
  
  
UPDATE `dadosexportados` SET `IDLogCultura`= (SELECT IDLog FROM log_cultura ORDER BY IDLog DESC LIMIT 1);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `export_investigador` ()  BEGIN

SELECT * INTO OUTFILE 'C:logs_investigador.csv '
  FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM log_investigador  WHERE log_investigador.IDLog > (SELECT IDLogInvestigador FROM `dadosexportados`) ;
  
  
UPDATE `dadosexportados` SET `IDLogInvestigador`= (SELECT IDLog FROM log_investigador ORDER BY IDLog DESC LIMIT 1);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `export_manual` ()  BEGIN

CALL export_cultura;
CALL export_investigador;
CALL export_medicoes;
CALL export_medicoesluminosidade;
CALL export_medicoestemperatura;
CALL export_sistema;
CALL export_variaveis;
CALL export_variaveismedidas;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `export_medicoes` ()  BEGIN

SELECT * INTO OUTFILE 'C:logs_medicoes.csv '
  FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM log_medicoes WHERE log_medicoes.IDLog > (SELECT 	IDLogMedicoes FROM `dadosexportados`) ;
  
UPDATE `dadosexportados` SET `IDLogMedicoes`= (SELECT IDLog FROM log_medicoes ORDER BY IDLog DESC LIMIT 1);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `export_medicoesluminosidade` ()  NO SQL
BEGIN

SELECT * INTO OUTFILE 'C:logs_medicoesluminosidade.csv '
  FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM log_medicoesluminosidade  WHERE log_medicoesluminosidade.IDLog > (SELECT IDLogMedicoesLuminosidade FROM `dadosexportados`) ;

UPDATE `dadosexportados` SET `IDLogMedicoesLuminosidade`= (SELECT IDLog FROM log_medicoesluminosidade ORDER BY IDLog DESC LIMIT 1);
  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `export_medicoestemperatura` ()  BEGIN

SELECT * INTO OUTFILE 'C:logs_medicoestemperatura.csv '
  FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM log_medicoestemperatura  WHERE log_medicoestemperatura.IDLog > (SELECT IDLogMedicoesTemperatura FROM `dadosexportados`) ;
 
UPDATE `dadosexportados` SET `IDLogMedicoesTemperatura`= (SELECT IDLog FROM log_medicoestemperatura ORDER BY IDLog DESC LIMIT 1);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `export_sistema` ()  BEGIN

SELECT * INTO OUTFILE 'C:logs_sistema.csv '
  FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM log_sistema WHERE log_sistema.IDLog > (SELECT IDLogSistema FROM `dadosexportados`) ;
  
UPDATE `dadosexportados` SET `IDLogSistema`= (SELECT IDLog FROM log_sistema ORDER BY IDLog DESC LIMIT 1);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `export_variaveis` ()  NO SQL
BEGIN

SELECT * INTO OUTFILE 'C:logs_variaveis.csv '
  FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM log_variaveis  WHERE log_variaveis.IDLog > (SELECT IDLogVariaveis FROM `dadosexportados`) ;
  
UPDATE `dadosexportados` SET `IDLogVariaveis`= (SELECT IDLog FROM log_variaveis ORDER BY IDLog DESC LIMIT 1);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `export_variaveismedidas` ()  BEGIN

SELECT * INTO OUTFILE 'C:logs_variaveismedidas.csv '
  FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM log_variaveismedidas WHERE log_variaveismedidas.IDLog > (SELECT IDLogVariaveisMedidas FROM `dadosexportados`) ;
  
UPDATE `dadosexportados` SET `IDLogVariaveisMedidas`= (SELECT IDLog FROM log_variaveismedidas ORDER BY IDLog DESC LIMIT 1);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `init` ()  BEGIN
CREATE ROLE investigador, administrador;

GRANT SELECT,UPDATE,DELETE,INSERT ON estufa.cultura TO investigador;
GRANT SELECT,UPDATE,DELETE,INSERT ON estufa.medicoes TO investigador;

GRANT SELECT,UPDATE,DELETE,INSERT ON estufa.variaveis TO administrador;
GRANT SELECT ON estufa.variaveis TO investigador;

GRANT SELECT,UPDATE,DELETE,INSERT ON estufa.variaveismedidas TO administrador;
GRANT SELECT ON estufa.variaveismedidas TO investigador;

GRANT SELECT,UPDATE,DELETE,INSERT ON estufa.investigador TO administrador;
GRANT SELECT ON estufa.investigador TO investigador;

GRANT SELECT,UPDATE,DELETE,INSERT ON estufa.sistema TO administrador;
GRANT SELECT ON estufa.sistema TO investigador;

GRANT SELECT ON estufa.dadosexportados TO administrador;
GRANT SELECT ON estufa.log_cultura TO administrador;
GRANT SELECT ON estufa.log_medicoes TO administrador;
GRANT SELECT ON estufa.log_medicoestemperatura TO administrador;
GRANT SELECT ON estufa.log_medicoesluminosidade TO administrador;
GRANT SELECT ON estufa.log_variaveis TO administrador;
GRANT SELECT ON estufa.log_variaveismedidas TO administrador;
GRANT SELECT ON estufa.log_investigador TO administrador;
GRANT SELECT ON estufa.log_sistema TO administrador;

INSERT INTO `dadosexportados`(`IDExportação`, `IDLogInvestigador`, `IDLogMedicoesLuminosidade`, `IDLogMedicoesVariaveis`, `IDLogMedicoesTemperatura`, `IDLogMedicoes`, `IDLogCultura`, `IDLogVariaveisMedidas`,`IDLogSistema`,`IDLogVariaveis`) VALUES (Null,'0','0','0','0','0','0','0','0','0');

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `cultura`
--

CREATE TABLE `cultura` (
  `IDCultura` int(11) NOT NULL,
  `NomeCultura` varchar(100) NOT NULL,
  `DescricaoCultura` text,
  `IDInvestigador` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `cultura`
--

INSERT INTO `cultura` (`IDCultura`, `NomeCultura`, `DescricaoCultura`, `IDInvestigador`) VALUES
(4, 'sdaf', 'sd', 12);

--
-- Triggers `cultura`
--
DELIMITER $$
CREATE TRIGGER `insert_cultura` AFTER INSERT ON `cultura` FOR EACH ROW INSERT into log_cultura VALUES ( null ,new.IDCultura, new.NomeCultura, new.DescricaoCultura, new.IDInvestigador,CURRENT_USER, CURRENT_TIME, 'Insert')
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `dadosexportados`
--

CREATE TABLE `dadosexportados` (
  `IDExportação` int(11) NOT NULL,
  `IDLogInvestigador` int(11) NOT NULL,
  `IDLogMedicoesLuminosidade` int(11) NOT NULL,
  `IDLogMedicoesVariaveis` int(11) NOT NULL,
  `IDLogMedicoesTemperatura` int(11) NOT NULL,
  `IDLogMedicoes` int(11) NOT NULL,
  `IDLogCultura` int(11) NOT NULL,
  `IDLogVariaveisMedidas` int(11) NOT NULL,
  `IDLogSistema` int(11) NOT NULL,
  `IDLogVariaveis` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `dadosexportados`
--

INSERT INTO `dadosexportados` (`IDExportação`, `IDLogInvestigador`, `IDLogMedicoesLuminosidade`, `IDLogMedicoesVariaveis`, `IDLogMedicoesTemperatura`, `IDLogMedicoes`, `IDLogCultura`, `IDLogVariaveisMedidas`, `IDLogSistema`, `IDLogVariaveis`) VALUES
(1, 3, 0, 0, 0, 0, 1, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `investigador`
--

CREATE TABLE `investigador` (
  `IDInvestigador` int(11) NOT NULL,
  `Email` varchar(45) NOT NULL,
  `NomeInvestigador` varchar(45) NOT NULL,
  `CategoriaProfissional` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `investigador`
--

INSERT INTO `investigador` (`IDInvestigador`, `Email`, `NomeInvestigador`, `CategoriaProfissional`) VALUES
(8, 'lala@gmail.com', 'sdf', 'sdf'),
(11, 'lala@gmail.com', 'sf', 'sdf'),
(12, 'asdsfs', 'sdfsdd', 'sdds'),
(13, 'lala@gmail.com', 'sfd', 'sdgfh');

--
-- Triggers `investigador`
--
DELIMITER $$
CREATE TRIGGER `investigador_insert` AFTER INSERT ON `investigador` FOR EACH ROW INSERT into log_investigador VALUES ( null ,CURRENT_USER, new.NomeInvestigador, new.Email, new.NomeInvestigador, new.CategoriaProfissional, CURRENT_TIME, 'Insert')
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `log_cultura`
--

CREATE TABLE `log_cultura` (
  `IDLog` int(11) NOT NULL,
  `IDCultura` int(11) NOT NULL,
  `NomeCultura` varchar(45) DEFAULT NULL,
  `DescricaoCultura` varchar(45) DEFAULT NULL,
  `IDInvestigador` int(11) DEFAULT NULL,
  `Utilizador` varchar(45) NOT NULL,
  `Data` datetime NOT NULL,
  `Operacao` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `log_investigador`
--

CREATE TABLE `log_investigador` (
  `IDLog` int(11) NOT NULL,
  `IDInvestigador` int(11) NOT NULL,
  `Email` varchar(45) DEFAULT NULL,
  `NomeInvestigador` varchar(45) DEFAULT NULL,
  `CategoriaProfissional` varchar(45) DEFAULT NULL,
  `Utilizador` varchar(45) NOT NULL,
  `Data` datetime NOT NULL,
  `Operacao` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `log_investigador`
--

INSERT INTO `log_investigador` (`IDLog`, `IDInvestigador`, `Email`, `NomeInvestigador`, `CategoriaProfissional`, `Utilizador`, `Data`, `Operacao`) VALUES
(1, 0, 'sdx', 'lala@gmail.com', 'sf', 'sdf', '2019-03-13 22:37:47', 'Insert'),
(2, 0, 'sdfsdd', 'asdsfs', 'sdfsdd', 'sdds', '2019-03-13 22:40:31', 'Insert'),
(3, 0, 'sfd', 'lala@gmail.com', 'sfd', 'sdgfh', '2019-03-15 22:14:50', 'Insert'),
(4, 0, 'Toino', 'a@b.c', 'Toino', 'xixi', '2019-03-18 20:30:55', 'Insert');

-- --------------------------------------------------------

--
-- Table structure for table `log_medicoes`
--

CREATE TABLE `log_medicoes` (
  `IDLog` int(11) NOT NULL,
  `IDVariavel` int(11) DEFAULT NULL,
  `IDCultura` int(11) DEFAULT NULL,
  `NumMedicao` int(11) NOT NULL,
  `DataHoraMedicao` datetime DEFAULT NULL,
  `ValorMedicao` int(11) DEFAULT NULL,
  `Utilizador` varchar(45) NOT NULL,
  `Data` datetime NOT NULL,
  `Operacao` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `log_medicoesluminosidade`
--

CREATE TABLE `log_medicoesluminosidade` (
  `IDLog` int(11) NOT NULL,
  `IDMedicao` int(11) NOT NULL,
  `DataHoraMedicao` datetime DEFAULT NULL,
  `ValorMedicaoLuminosidade` int(11) DEFAULT NULL,
  `Utilizador` varchar(45) NOT NULL,
  `Data` datetime NOT NULL,
  `Operacao` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `log_medicoestemperatura`
--

CREATE TABLE `log_medicoestemperatura` (
  `IDLog` int(11) NOT NULL,
  `IDMedicao` int(11) NOT NULL,
  `DataHoraMedicao` datetime DEFAULT NULL,
  `ValorMedicaoTemperatura` int(11) DEFAULT NULL,
  `Utilizador` varchar(45) NOT NULL,
  `Data` datetime NOT NULL,
  `Operacao` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `log_sistema`
--

CREATE TABLE `log_sistema` (
  `IDLog` int(11) NOT NULL,
  `IDSistema` int(11) NOT NULL,
  `LimiteInfTemperatura` int(11) DEFAULT NULL,
  `LimiteSupTemperatura` int(11) DEFAULT NULL,
  `LimiteInfLuminosidade` int(11) DEFAULT NULL,
  `LimiteSupLuminosidade` int(11) DEFAULT NULL,
  `Utilizador` varchar(45) NOT NULL,
  `Data` datetime NOT NULL,
  `Operacao` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `log_variaveis`
--

CREATE TABLE `log_variaveis` (
  `IDLog` int(11) NOT NULL,
  `IDVariavel` int(11) NOT NULL,
  `NomeVariavel` varchar(45) DEFAULT NULL,
  `Utilizador` varchar(45) NOT NULL,
  `Data` datetime NOT NULL,
  `Operacao` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `log_variaveismedidas`
--

CREATE TABLE `log_variaveismedidas` (
  `IDLog` int(11) NOT NULL,
  `IDVariavel` int(11) NOT NULL,
  `IDCultura` int(11) NOT NULL,
  `LimiteInferior` int(11) DEFAULT NULL,
  `LimiteSuperior` int(11) DEFAULT NULL,
  `Utilizador` varchar(45) NOT NULL,
  `Data` datetime NOT NULL,
  `Operacao` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `medicoes`
--

CREATE TABLE `medicoes` (
  `DataHoraMedicao` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ValorMedicao` decimal(8,2) NOT NULL,
  `IDCultura` int(11) NOT NULL,
  `IDVariavel` int(11) NOT NULL,
  `NumMedicao` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `medicoes`
--
DELIMITER $$
CREATE TRIGGER `medicoes_insert` AFTER INSERT ON `medicoes` FOR EACH ROW INSERT into log_medicoes VALUES ( null ,new.IDVariavel, new.IDCultura, new.NumMedicao,  new.DataHoraMedicao, new.ValorMedicao,CURRENT_USER,  CURRENT_TIME, 'Insert')
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
CREATE TRIGGER `medicoesluminosidade_insert` AFTER INSERT ON `medicoes_luminosidade` FOR EACH ROW INSERT into log_medicoesluminosidade VALUES ( null ,new.IDMedicao, new.DataHoraMedicao, new.ValorMedicaoLuminosidade,  CURRENT_USER,  CURRENT_TIME, 'Insert')
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
CREATE TRIGGER `medicoestemperatura_insert` AFTER INSERT ON `medicoes_temperatura` FOR EACH ROW INSERT into log_medicoestemperatura VALUES ( null ,new.IDMedicao, new.DataHoraMedicao, new.ValorMedicaoTemperatura,  CURRENT_USER,  CURRENT_TIME, 'Insert')
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `sistema`
--

CREATE TABLE `sistema` (
  `IDSistema` int(11) NOT NULL,
  `LimiteInfTemperatura` decimal(8,2) NOT NULL,
  `LimiteSupTemperatura` decimal(8,2) NOT NULL,
  `LimiteInfLuminosidade` decimal(8,2) NOT NULL,
  `LimiteSupLuminosidade` decimal(8,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `sistema`
--
DELIMITER $$
CREATE TRIGGER `sistema_insert` AFTER INSERT ON `sistema` FOR EACH ROW INSERT into log_sistema VALUES ( null ,new.IDSistema, new.LimiteInfTemperatura, new.LimiteSupTemperatura,  new.LimiteInfLuminosidade, new.LimiteSupLuminosidade,CURRENT_USER,  CURRENT_TIME, 'Insert')
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
-- Triggers `variaveis`
--
DELIMITER $$
CREATE TRIGGER `variaveis_insert` AFTER INSERT ON `variaveis` FOR EACH ROW INSERT into log_variaveis VALUES ( null ,new.IDVariavel, new.NomeVariavel,CURRENT_USER,  CURRENT_TIME, 'Insert')
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
  `LimiteSuperior` decimal(8,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `variaveis_medidas`
--
DELIMITER $$
CREATE TRIGGER `variaveismedidas_insert` AFTER INSERT ON `variaveis_medidas` FOR EACH ROW INSERT into log_variaveismedidas VALUES ( null ,new.IDVariavel, new.IDCultura, new.LimiteInferior,  new.LimiteSuperior,CURRENT_USER,  CURRENT_TIME, 'Insert')
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
  ADD KEY `EmailInvestigador` (`IDInvestigador`) USING BTREE;

--
-- Indexes for table `dadosexportados`
--
ALTER TABLE `dadosexportados`
  ADD PRIMARY KEY (`IDExportação`);

--
-- Indexes for table `investigador`
--
ALTER TABLE `investigador`
  ADD PRIMARY KEY (`IDInvestigador`);

--
-- Indexes for table `log_cultura`
--
ALTER TABLE `log_cultura`
  ADD PRIMARY KEY (`IDLog`);

--
-- Indexes for table `log_investigador`
--
ALTER TABLE `log_investigador`
  ADD PRIMARY KEY (`IDLog`);

--
-- Indexes for table `log_medicoes`
--
ALTER TABLE `log_medicoes`
  ADD PRIMARY KEY (`IDLog`);

--
-- Indexes for table `log_medicoesluminosidade`
--
ALTER TABLE `log_medicoesluminosidade`
  ADD PRIMARY KEY (`IDLog`);

--
-- Indexes for table `log_medicoestemperatura`
--
ALTER TABLE `log_medicoestemperatura`
  ADD PRIMARY KEY (`IDLog`);

--
-- Indexes for table `log_sistema`
--
ALTER TABLE `log_sistema`
  ADD PRIMARY KEY (`IDLog`);

--
-- Indexes for table `log_variaveis`
--
ALTER TABLE `log_variaveis`
  ADD PRIMARY KEY (`IDLog`);

--
-- Indexes for table `log_variaveismedidas`
--
ALTER TABLE `log_variaveismedidas`
  ADD PRIMARY KEY (`IDLog`);

--
-- Indexes for table `medicoes`
--
ALTER TABLE `medicoes`
  ADD PRIMARY KEY (`NumMedicao`),
  ADD KEY `IDVariavel` (`IDVariavel`),
  ADD KEY `IDCultura` (`IDCultura`,`IDVariavel`) USING BTREE;

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
-- Indexes for table `sistema`
--
ALTER TABLE `sistema`
  ADD PRIMARY KEY (`IDSistema`);

--
-- Indexes for table `variaveis`
--
ALTER TABLE `variaveis`
  ADD PRIMARY KEY (`IDVariavel`);

--
-- Indexes for table `variaveis_medidas`
--
ALTER TABLE `variaveis_medidas`
  ADD PRIMARY KEY (`IDVariavel`,`IDCultura`),
  ADD KEY `IDVariavel` (`IDVariavel`,`IDCultura`) USING BTREE,
  ADD KEY `IDCultura` (`IDCultura`) USING BTREE;

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cultura`
--
ALTER TABLE `cultura`
  MODIFY `IDCultura` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `dadosexportados`
--
ALTER TABLE `dadosexportados`
  MODIFY `IDExportação` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `investigador`
--
ALTER TABLE `investigador`
  MODIFY `IDInvestigador` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `log_cultura`
--
ALTER TABLE `log_cultura`
  MODIFY `IDLog` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `log_investigador`
--
ALTER TABLE `log_investigador`
  MODIFY `IDLog` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `log_medicoes`
--
ALTER TABLE `log_medicoes`
  MODIFY `IDLog` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `log_medicoesluminosidade`
--
ALTER TABLE `log_medicoesluminosidade`
  MODIFY `IDLog` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `log_medicoestemperatura`
--
ALTER TABLE `log_medicoestemperatura`
  MODIFY `IDLog` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `log_sistema`
--
ALTER TABLE `log_sistema`
  MODIFY `IDLog` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `log_variaveis`
--
ALTER TABLE `log_variaveis`
  MODIFY `IDLog` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `log_variaveismedidas`
--
ALTER TABLE `log_variaveismedidas`
  MODIFY `IDLog` int(11) NOT NULL AUTO_INCREMENT;

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
  MODIFY `IDVariavel` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cultura`
--
ALTER TABLE `cultura`
  ADD CONSTRAINT `cultura_ibfk_1` FOREIGN KEY (`IDInvestigador`) REFERENCES `investigador` (`IDInvestigador`);

--
-- Constraints for table `medicoes`
--
ALTER TABLE `medicoes`
  ADD CONSTRAINT `medicoes_ibfk_1` FOREIGN KEY (`IDCultura`) REFERENCES `variaveis_medidas` (`IDCultura`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `medicoes_ibfk_2` FOREIGN KEY (`IDVariavel`) REFERENCES `variaveis_medidas` (`IDVariavel`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `variaveis_medidas`
--
ALTER TABLE `variaveis_medidas`
  ADD CONSTRAINT `variaveis_medidas_ibfk_1` FOREIGN KEY (`IDCultura`) REFERENCES `cultura` (`IDCultura`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `variaveis_medidas_ibfk_2` FOREIGN KEY (`IDVariavel`) REFERENCES `variaveis` (`IDVariavel`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
