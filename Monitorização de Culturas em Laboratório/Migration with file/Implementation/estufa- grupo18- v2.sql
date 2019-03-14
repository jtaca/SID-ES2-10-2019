-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 13, 2019 at 09:56 PM
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `addTodosPriv` ()  BEGIN
	CALL criarRoles;
 
    CALL criarPrivilegios;

  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `addUser` (IN `var_nome` VARCHAR(45), IN `var_password` VARCHAR(45), IN `var_role` ENUM('investigador  ','administrador','sensorLuminosidade','sensorTemperatura'))  BEGIN

	DROP USER IF EXISTS ''@localhost;

    SET @sql := CONCAT('CREATE USER ', var_nome, ' IDENTIFIED BY ', QUOTE(var_password));
    PREPARE statement FROM @sql;
    EXECUTE statement;
    
    SET @sql := CONCAT('GRANT ', var_role, ' TO ', QUOTE(var_nome));
    PREPARE statement FROM @sql;
    EXECUTE statement;
    
    SET @sql := CONCAT('SET DEFAULT ROLE ', var_role ,' FOR ', 		QUOTE(var_nome));
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `criarRoles` ()  CREATE ROLE investigador, administrador, sensorLuminosidade, sensorTemperatura,  phpUser$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `selectDadosNaoMigrados` ()  SELECT * FROM logs WHERE logs.exportado=0$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `selectMedicoes` ()  NO SQL
BEGIN  
   	SELECT * FROM estufa.medicoes;  
   	INSERT INTO estufa.logs VALUES (null, CURRENT_USER, "medicoes", "SELECT", "Não Aplicável", "Não Aplicável", NOW(), 0);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateMigrados` (IN `startID` INT(50))  UPDATE logs SET logs.exportado=1 WHERE logs.logId>= startID$$

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
  `IDLogVariaveisMedidas` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
  `NumeroMedicao` int(11) NOT NULL,
  `DataHoraMedicao` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ValorMedicao` decimal(8,2) NOT NULL,
  `IdVariaveisMedidas` int(11) NOT NULL,
  `IDCultura` int(11) NOT NULL,
  `IDVariavel` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `medicoes_luminosidade`
--

CREATE TABLE `medicoes_luminosidade` (
  `DataHoraMedicao` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ValorMedicaoLuminosidade` decimal(8,2) NOT NULL,
  `IDMedicao` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `medicoes_temperatura`
--

CREATE TABLE `medicoes_temperatura` (
  `DataHoraMedicao` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ValorMedicaoTemperatura` decimal(8,2) NOT NULL,
  `IDMedicao` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `sistema`
--

CREATE TABLE `sistema` (
  `IDSistema` int(11) NOT NULL,
  `LimiteInferiorTemperatura` decimal(8,2) NOT NULL,
  `LimiteSuperiorTemperatura` decimal(8,2) NOT NULL,
  `LimiteInferiorLuz` decimal(8,2) NOT NULL,
  `LimiteSuperiorLuz` decimal(8,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `sistema`
--

INSERT INTO `sistema` (`IDSistema`, `LimiteInferiorTemperatura`, `LimiteSuperiorTemperatura`, `LimiteInferiorLuz`, `LimiteSuperiorLuz`) VALUES
(0, '19.50', '25.00', '2.00', '5.00'),
(0, '19.50', '30.00', '5.00', '9.00');

-- --------------------------------------------------------

--
-- Table structure for table `variaveis`
--

CREATE TABLE `variaveis` (
  `IDVariavel` int(11) NOT NULL,
  `NomeVariavel` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
  ADD PRIMARY KEY (`IDCultura`,`IDVariavel`),
  ADD KEY `IdVariaveisMedidas` (`IdVariaveisMedidas`),
  ADD KEY `NumeroMedicao` (`NumeroMedicao`) USING BTREE,
  ADD KEY `IDVariavel` (`IDVariavel`);

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
  ADD PRIMARY KEY (`IDVariavel`,`IDCultura`),
  ADD KEY `IDVariavel` (`IDVariavel`,`IDCultura`) USING BTREE,
  ADD KEY `IdVariaveisMedidas` (`IdVariaveisMedidas`) USING BTREE,
  ADD KEY `IDCultura` (`IDCultura`) USING BTREE;

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cultura`
--
ALTER TABLE `cultura`
  MODIFY `IDCultura` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `dadosexportados`
--
ALTER TABLE `dadosexportados`
  MODIFY `IDExportação` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `investigador`
--
ALTER TABLE `investigador`
  MODIFY `IDInvestigador` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `log_cultura`
--
ALTER TABLE `log_cultura`
  MODIFY `IDLog` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `log_investigador`
--
ALTER TABLE `log_investigador`
  MODIFY `IDLog` int(11) NOT NULL AUTO_INCREMENT;

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
-- AUTO_INCREMENT for table `variaveis_medidas`
--
ALTER TABLE `variaveis_medidas`
  MODIFY `IdVariaveisMedidas` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cultura`
--
ALTER TABLE `cultura`
  ADD CONSTRAINT `Responsavel` FOREIGN KEY (`IDInvestigador`) REFERENCES `investigador` (`IDInvestigador`) ON DELETE CASCADE ON UPDATE CASCADE;

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
