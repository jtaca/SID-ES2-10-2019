-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 07, 2019 at 09:33 PM
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
-- Database: `auditor`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `addUser` (IN `var_nome` VARCHAR(45), IN `var_password` VARCHAR(45))  BEGIN

	DROP USER IF EXISTS ''@localhost;

    SET @sql := CONCAT('CREATE USER ', var_nome, ' IDENTIFIED BY ', QUOTE(var_password));
    PREPARE statement FROM @sql;
    EXECUTE statement;
    
    SET @sql := CONCAT('GRANT ', 'auditor' , ' TO ', QUOTE(var_nome));
    PREPARE statement FROM @sql;
    EXECUTE statement;
    
    SET @sql := CONCAT('SET DEFAULT ROLE ', 'auditor' ,' FOR ', 		QUOTE(var_nome));
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
    
    SET @sql := CONCAT('GRANT ', 'phpmigr', ' TO ', QUOTE('php'));
    PREPARE statement FROM @sql;
    EXECUTE statement;
    
    SET @sql := CONCAT('SET DEFAULT ROLE ', 'phpmigr' ,' FOR ', 		QUOTE('php'));
    PREPARE statement FROM @sql;
    EXECUTE statement;

    DEALLOCATE PREPARE statement;
    FLUSH PRIVILEGES;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `init` ()  BEGIN

CREATE ROLE phpmigr, auditor;

GRANT SELECT ON auditor.logs TO auditor;
GRANT INSERT ON auditor.logs TO phpmigr;
GRANT EXECUTE ON PROCEDURE auditor.addUser TO auditor;

CALL createPhpUser;

END$$

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
  `dataComando` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `logs`
--

INSERT INTO `logs` (`logId`, `username`, `nomeTabela`, `comandoUsado`, `linhaAnterior`, `resultado`, `dataComando`) VALUES
(2, 'root@localhost', 'medicoes_luminosidade', 'DELETE', 'DataHoraMedicao: 2019-03-05 00:22:37  ValorMedicaoLuminosidade: 20.67  IDMedicao: 1', 'Linha Eliminada', '2019-03-05 00:22:56'),
(3, 'root@localhost', 'medicoes', 'SELECT', 'Nao Aplicavel', 'Nao Aplicavel', '2019-03-06 00:26:58'),
(4, 'root@localhost', 'medicoes', 'SELECT', 'Nao Aplicavel', 'Nao Aplicavel', '2019-03-06 00:28:09'),
(5, 'root@localhost', 'sistema', 'DELETE', 'LimiteInferiorTemperatura: 19.50  LimiteSuperiorTemperatura: 25.00  LimiteInferiorLuz: 2.00  LimiteSuperiorLuz: 5.00', 'Linha Eliminada', '2019-03-06 01:14:33'),
(6, 'root@localhost', 'sistema', 'DELETE', 'LimiteInferiorTemperatura: 19.50  LimiteSuperiorTemperatura: 30.00  LimiteInferiorLuz: 5.00  LimiteSuperiorLuz: 9.00', 'Linha Eliminada', '2019-03-06 01:14:33'),
(7, 'root@localhost', 'sistema', 'INSERT', 'Nao Aplicável', 'LimiteInferiorTemperatura: 0.00  LimiteSuperiorTemperatura: 10.00  LimiteInferiorLuz: 50.00  LimiteSuperiorLuz: 100.00', '2019-03-06 01:14:47'),
(8, 'root@localhost', 'sistema', 'DELETE', 'LimiteInferiorTemperatura: 0.00  LimiteSuperiorTemperatura: 10.00  LimiteInferiorLuz: 50.00  LimiteSuperiorLuz: 100.00', 'Linha Eliminada', '2019-03-06 02:58:40');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`logId`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `logs`
--
ALTER TABLE `logs`
  MODIFY `logId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
