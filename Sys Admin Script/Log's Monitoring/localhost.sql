-- phpMyAdmin SQL Dump
-- version 4.0.10.8
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Feb 20, 2015 at 11:44 AM
-- Server version: 5.1.73
-- PHP Version: 5.3.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `link_ip`
--

-- --------------------------------------------------------

--
-- Table structure for table `lnklist_ip`
--

CREATE TABLE IF NOT EXISTS `lnklist_ip` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `list_ip` varchar(40) NOT NULL,
  `status` int(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `list_ip` (`list_ip`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=16 ;

--
-- Dumping data for table `lnklist_ip`
--

INSERT INTO `lnklist_ip` (`id`, `list_ip`, `status`) VALUES
(1, '192.3.171.177', 1),
(2, '192.3.173.23', 1),
(3, '192.3.171.230', 1),
(4, '198.23.190.141', 1),
(5, '198.23.190.209', 1),
(6, '162.218.89.31', 1),
(7, '23.88.236.236', 1),
(8, '192.157.221.4', 1),
(9, '23.88.105.8', 1),
(10, '107.172.22.7', 1),
(11, '5.196.128.77', 1),
(12, '104.223.1.152', 1),
(13, '198.98.124.20', 1),
(14, '198.96.90.3', 1),
(15, '192.157.245.183', 1);
--
-- Database: `smtp_log`
--

-- --------------------------------------------------------

--
-- Table structure for table `list_ip`
--

CREATE TABLE IF NOT EXISTS `list_ip` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ip_name` varchar(40) DEFAULT NULL,
  `status` int(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `ip_name` (`ip_name`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=27 ;

--
-- Dumping data for table `list_ip`
--

INSERT INTO `list_ip` (`id`, `ip_name`, `status`) VALUES
(1, '103.255.101.18', 1),
(20, '155.94.173.183', 1),
(3, '162.253.154.51', 1),
(4, '107.161.84.21', 1),
(5, '198.23.190.157', 1),
(6, '5.135.29.150', 1),
(21, '98.143.148.237', 1),
(8, '96.8.114.98', 1),
(9, '192.210.133.5', 1),
(11, '75.127.3.246', 1),
(14, '206.221.182.9', 1),
(25, '8.8.0.8', 1),
(18, '192.3.207.114', 1),
(19, '192.3.159.188', 1),
(22, '206.221.182.180', 1),
(26, '192.168.2.3', 1);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
