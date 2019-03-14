-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 06, 2019 at 11:24 PM
-- Server version: 10.1.38-MariaDB
-- PHP Version: 7.3.2

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
CREATE DATABASE IF NOT EXISTS `auditor` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `auditor`;

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
