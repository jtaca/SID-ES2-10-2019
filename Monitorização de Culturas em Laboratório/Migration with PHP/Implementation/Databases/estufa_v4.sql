-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 01, 2019 at 08:15 PM
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `addRole` (IN `role` ENUM('investigador  ','auditor','administrador','sensorLuminosidade','sensorTemperatura'), IN `var_nome` VARCHAR(200))  BEGIN
	SET @`sql` := CONCAT('GRANT '', role, '' TO '',var_nome,''@%');
    PREPARE `statement` FROM @`sql`;
    EXECUTE `statement`;
    
    SET @`sql` := CONCAT('SET DEFAULT ROLE ', role ,' FOR ', 		CONCAT(var_nome,'@%'));
    PREPARE `statement` FROM @`sql`;
    EXECUTE `statement`;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `addTodosPriv` ()  BEGIN
	CALL criarRoles;
 
    CALL criarPrivilegios;

  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_User` (IN `var_nome` VARCHAR(45), IN `var_password` VARCHAR(45))  BEGIN
    SET @`sql` := CONCAT('CREATE USER ', var_nome, ' IDENTIFIED BY ', QUOTE(var_password));
    PREPARE `statement` FROM @`sql`;
    EXECUTE `statement`;
    
    SET @`sql` := CONCAT('GRANT ALL PRIVILEGES ON *.* TO ', var_nome);
    PREPARE `statement` FROM @`sql`;
    EXECUTE `statement`;
    DEALLOCATE PREPARE `statement`;
    FLUSH PRIVILEGES;
    


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `criarPrivilegios` ()  BEGIN
GRANT SELECT ON estufa.cultura TO auditor;
GRANT SELECT ON estufa.sistema TO auditor;
GRANT SELECT ON estufa.investigador TO auditor;
GRANT SELECT ON estufa.medicoes TO auditor;
GRANT SELECT ON estufa.medicoesluminosidade TO auditor, investigador;
GRANT SELECT ON estufa.medicoestemperatura TO auditor,investigador;

GRANT INSERT ON estufa.medicoestemperatura TO sensorTemperatura;
GRANT INSERT ON estufa.medicoesluminosidade TO sensorLuminosidade;


GRANT SELECT,INSERT, UPDATE, DELETE ON estufa.sistema TO administrador,investigador;
GRANT SELECT,INSERT, UPDATE, DELETE ON estufa.variaveis TO administrador,investigador;
GRANT SELECT,INSERT, UPDATE, DELETE ON estufa.investigador TO administrador,investigador;
GRANT SELECT,INSERT, UPDATE, DELETE ON estufa.medicoes TO administrador,investigador;
GRANT SELECT,INSERT, UPDATE, DELETE ON estufa.sistema TO administrador,investigador;
GRANT SELECT,INSERT, UPDATE, DELETE ON estufa.cultura TO administrador,investigador;
GRANT SELECT,INSERT, UPDATE, DELETE ON estufa.sistema TO administrador,investigador;

GRANT SELECT,INSERT, UPDATE, DELETE ON estufa.medicoestemperatura TO administrador;
GRANT SELECT,INSERT, UPDATE, DELETE ON estufa.medicoesluminosidade TO administrador;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `criarRoles` ()  CREATE ROLE investigador, administrador, sensorLuminosidade,  sensorTemperatura, auditor$$

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

-- --------------------------------------------------------

--
-- Table structure for table `investigador`
--

CREATE TABLE `investigador` (
  `Email` varchar(50) NOT NULL,
  `NomeInvestigador` varchar(100) NOT NULL,
  `CategoriaProfissional` varchar(300) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
  `exportado` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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

-- --------------------------------------------------------

--
-- Table structure for table `medicoesluminosidade`
--

CREATE TABLE `medicoesluminosidade` (
  `DataHoraMedicao` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ValorMedicaoLuminosidade` decimal(8,2) NOT NULL,
  `IDMedicao` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `medicoestemperatura`
--

CREATE TABLE `medicoestemperatura` (
  `DataHoraMedicao` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ValorMedicaoTemperatura` decimal(8,2) NOT NULL,
  `IDMedicao` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
-- Table structure for table `variaveismedidas`
--

CREATE TABLE `variaveismedidas` (
  `IDVariavel` int(11) NOT NULL,
  `IDCultura` int(11) NOT NULL,
  `LimiteInferior` decimal(8,2) NOT NULL,
  `LimiteSuperior` decimal(8,2) NOT NULL,
  `NumeroMedicao` int(11) NOT NULL,
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
-- Indexes for table `medicoesluminosidade`
--
ALTER TABLE `medicoesluminosidade`
  ADD PRIMARY KEY (`IDMedicao`);

--
-- Indexes for table `medicoestemperatura`
--
ALTER TABLE `medicoestemperatura`
  ADD PRIMARY KEY (`IDMedicao`);

--
-- Indexes for table `variaveis`
--
ALTER TABLE `variaveis`
  ADD PRIMARY KEY (`IDVariavel`);

--
-- Indexes for table `variaveismedidas`
--
ALTER TABLE `variaveismedidas`
  ADD PRIMARY KEY (`IdVariaveisMedidas`),
  ADD KEY `IDCultura` (`IDCultura`),
  ADD KEY `NumeroMedicao` (`NumeroMedicao`),
  ADD KEY `IDVariavel` (`IDVariavel`,`IDCultura`) USING BTREE;

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cultura`
--
ALTER TABLE `cultura`
  MODIFY `IDCultura` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `logs`
--
ALTER TABLE `logs`
  MODIFY `logId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `medicoes`
--
ALTER TABLE `medicoes`
  MODIFY `NumeroMedicao` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `medicoesluminosidade`
--
ALTER TABLE `medicoesluminosidade`
  MODIFY `IDMedicao` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `medicoestemperatura`
--
ALTER TABLE `medicoestemperatura`
  MODIFY `IDMedicao` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `variaveis`
--
ALTER TABLE `variaveis`
  MODIFY `IDVariavel` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `variaveismedidas`
--
ALTER TABLE `variaveismedidas`
  MODIFY `IdVariaveisMedidas` int(11) NOT NULL AUTO_INCREMENT;

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
  ADD CONSTRAINT `medicoes_ibfk_1` FOREIGN KEY (`IdVariaveisMedidas`) REFERENCES `variaveismedidas` (`IdVariaveisMedidas`);

--
-- Constraints for table `variaveismedidas`
--
ALTER TABLE `variaveismedidas`
  ADD CONSTRAINT `variaveismedidas_ibfk_1` FOREIGN KEY (`IDCultura`) REFERENCES `cultura` (`IDCultura`),
  ADD CONSTRAINT `variaveismedidas_ibfk_2` FOREIGN KEY (`IDVariavel`) REFERENCES `variaveis` (`IDVariavel`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
