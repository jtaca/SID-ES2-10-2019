-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 26, 2019 at 11:39 PM
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

--
-- Dumping data for table `cultura`
--

INSERT INTO `cultura` (`IDCultura`, `NomeCultura`, `DescricaoCultura`, `EmailInvestigador`) VALUES
(4, 'batatas', 'sao batatas moh', 'jose@email.com'),
(6, 'ntf', 'tgrfe', 'jose@email.com');

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
('email', 'joao', 'qwer'),
('jose@email.com', 'jose bello', 'eng');

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
-- Table structure for table `privilegios`
--

CREATE TABLE `privilegios` (
  `tipoUtilizador` varchar(200) NOT NULL,
  `tipoComando` varchar(200) NOT NULL,
  `tabela` varchar(200) NOT NULL,
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `privilegios`
--

INSERT INTO `privilegios` (`tipoUtilizador`, `tipoComando`, `tabela`, `id`) VALUES
('Investigador', 'select', 'sistema', 1),
('investigador', 'select', 'variaveis', 2),
('investigador', 'update', 'variaveis', 3),
('investigador', 'insert', 'variaveis', 4),
('investigador', 'delete', 'variaveis', 5),
('investigador', 'select', 'investigador', 6),
('investigador', 'update', 'investigador', 7),
('investigador', 'select', 'medicoes', 8),
('investigador', 'update', 'medicoes', 9),
('investigador', 'delete', 'medicoes', 10),
('investigador', 'insert', 'medicoes', 11),
('investigador', 'select', 'variaveismedidas', 12),
('investigador', 'delete', 'variaveismedidas', 13),
('investigador', 'update', 'variaveismedidas', 14),
('investigador', 'insert', 'variaveismedidas', 15),
('investigador', 'select', 'medicoesluminosidade', 16),
('investigador', 'select', 'medicoestemperatura', 17),
('investigador', 'update', 'cultura', 18),
('investigador', 'select', 'cultura', 19),
('investigador', 'delete', 'cultura', 20),
('investigador', 'insert', 'cultura', 21),
('administradoraplicacao', 'select', 'sistema', 22),
('administradoraplicacao', 'update', 'sistema', 23),
('administradoraplicacao', 'insert', 'sistema', 24),
('administradoraplicacao', 'delete', 'sistema', 25),
('administradoraplicacao', 'select', 'variaveis', 26),
('administradoraplicacao', 'update', 'variaveis', 27),
('administradoraplicacao', 'delete', 'variaveis', 28),
('administradoraplicacao', 'insert', 'variaveis', 29),
('administradoraplicacao', 'select', 'investigador', 30),
('administradoraplicacao', 'update', 'investigador', 31),
('administradoraplicacao', 'delete', 'investigador', 32),
('administradoraplicacao', 'insert', 'investigador', 33),
('administradoraplicacao', 'select', 'medicoes', 34),
('administradoraplicacao', 'update', 'medicoes', 35),
('administradoraplicacao', 'delete', 'medicoes', 36),
('administradoraplicacao', 'insert', 'medicoes', 37),
('administradoraplicacao', 'update', 'variaveismedidas', 38),
('administradoraplicacao', 'select', 'variaveismedidas', 39),
('administradoraplicacao', 'delete', 'variaveismedidas', 40),
('administradoraplicacao', 'insert', 'variaveismedidas', 41),
('administradoraplicacao', 'select', 'medicoesluminosidade', 42),
('administradoraplicacao', 'update', 'medicoesluminosidade', 43),
('administradoraplicacao', 'delete', 'medicoesluminosidade', 44),
('administradoraplicacao', 'insert', 'medicoesluminosidade', 45),
('administradoraplicacao', 'select', 'medicoestemperatura', 46),
('administradoraplicacao', 'update', 'medicoestemperatura', 47),
('administradoraplicacao', 'delete', 'medicoestemperatura', 48),
('administradoraplicacao', 'insert', 'medicoestemperatura', 49),
('administradoraplicacao', 'select', 'cultura', 50),
('administradoraplicacao', 'update', 'cultura', 51),
('administradoraplicacao', 'insert', 'cultura', 52),
('administradoraplicacao', 'delete', 'cultura', 53),
('administradoraplicacao', 'select', 'privilegios', 54),
('administradoraplicacao', 'update', 'privilegios', 55),
('administradoraplicacao', 'delete', 'privilegios', 56),
('administradoraplicacao', 'insert', 'privilegios', 57),
('auditor', 'select', 'sistema', 58),
('auditor', 'select', 'variaveis', 59),
('auditor', 'select', 'investigador', 60),
('auditor', 'select', 'medicoes', 61),
('auditor', 'select', 'variaveismedidas', 62),
('auditor', 'select', 'medicoesluminosidade', 63),
('auditor', 'select', 'medicoestemperatura', 64),
('auditor', 'select', 'cultura', 65),
('auditor', 'select', 'logs', 66),
('auditor', 'select', 'privilegios', 67),
('sensortemperatura', 'insert', 'medicoestemperatura', 68),
('sensorluminosidade', 'insert', 'medicoesluminosidade', 69);

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
-- Indexes for table `privilegios`
--
ALTER TABLE `privilegios`
  ADD PRIMARY KEY (`id`);

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
-- AUTO_INCREMENT for table `privilegios`
--
ALTER TABLE `privilegios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;

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
