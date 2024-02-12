-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1:3306
-- Üretim Zamanı: 12 Şub 2024, 12:41:02
-- Sunucu sürümü: 8.0.31
-- PHP Sürümü: 8.0.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `charge_location`
--

DELIMITER $$
--
-- Yordamlar
--
DROP PROCEDURE IF EXISTS `getCities`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCities` ()   SELECT iller.plaka,iller.iller_ad,iller.nufus_23,iller.havalimani_sayisi,
iller.otoyikama_sayisi,iller.avm_sayisi,iller.otopark_sayisi,
iller.yillik_yagis,iller.fay_hattina_yakinlik,
COUNT(istasyonlar.istasyon_kodu) as istasyon_sayisi
FROM iller LEFT JOIN istasyonlar ON iller.plaka = istasyonlar.plaka
GROUP BY iller.plaka$$

DROP PROCEDURE IF EXISTS `getCitiesById`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCitiesById` (IN `id` INT(2))   SELECT iller.plaka,iller.iller_ad,iller.nufus_23,iller.havalimani_sayisi,
iller.otoyikama_sayisi,iller.avm_sayisi,iller.otopark_sayisi,
iller.yillik_yagis,iller.fay_hattina_yakinlik,
COUNT(istasyonlar.istasyon_kodu) as istasyon_sayisi
FROM iller LEFT JOIN istasyonlar ON iller.plaka = istasyonlar.plaka
WHERE iller.plaka = id
GROUP BY iller.plaka$$

DROP PROCEDURE IF EXISTS `getCitiesByName`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCitiesByName` (IN `name` VARCHAR(20))   SELECT iller.plaka,iller.iller_ad,iller.nufus_23,iller.havalimani_sayisi,
iller.otoyikama_sayisi,iller.avm_sayisi,iller.otopark_sayisi,
iller.yillik_yagis,iller.fay_hattina_yakinlik,
COUNT(istasyonlar.istasyon_kodu) as istasyon_sayisi
FROM iller LEFT JOIN istasyonlar ON iller.plaka = istasyonlar.plaka
WHERE iller.iller_ad LIKE concat(name,'%')
GROUP BY iller.plaka$$

DROP PROCEDURE IF EXISTS `getModels`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getModels` ()   SELECT model.model_kodu,model.model_adi,model.model_aciklama,soket.soket_tipi,
soket.soket_sayisi
FROM model LEFT JOIN
soket ON soket.soket_id = model.soket_id$$

DROP PROCEDURE IF EXISTS `getStations`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getStations` ()   SELECT istasyonlar.istasyon_kodu,istasyonlar.lat,istasyonlar.lng,istasyonlar.lokasyon_tipi,istasyonlar.aktiflik,istasyonlar.adres,istasyonlar.otopark,istasyonlar.park_suresi,istasyonlar.hizmet_saati,model.model_kodu,model.model_adi,model.model_aciklama,soket.soket_tipi, soket.soket_sayisi,iller.iller_ad
FROM istasyonlar,iller,model,soket
WHERE istasyonlar.model_kodu = model.model_kodu AND istasyonlar.plaka= iller.plaka AND soket.soket_id = model.soket_id$$

DROP PROCEDURE IF EXISTS `getstationsByName`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getstationsByName` (IN `name` VARCHAR(20))   SELECT istasyonlar.istasyon_kodu,model.model_kodu,model.model_adi,iller.iller_ad,
istasyonlar.adres,istasyonlar.aktiflik
FROM iller,model,istasyonlar
WHERE iller.plaka = istasyonlar.plaka AND model.model_kodu = istasyonlar.model_kodu
AND iller.iller_ad LIKE concat(name,'%')
ORDER BY istasyonlar.otopark$$

DROP PROCEDURE IF EXISTS `getTotalPop`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getTotalPop` ()   SELECT SUM(iller.nufus_23) as toplam
FROM iller$$

DROP PROCEDURE IF EXISTS `getTotalStations`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getTotalStations` ()   SELECT COUNT(istasyonlar.istasyon_kodu) as toplam
FROM istasyonlar$$

DROP PROCEDURE IF EXISTS `getWeatherById`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getWeatherById` (IN `id` INT(2))   SELECT iller.plaka,iklim_kosullari.hava_kosullari
FROM iller,iklim_kosullari,iklim_il
WHERE iller.plaka=iklim_il.plaka AND iklim_kosullari.iklim_id= iklim_il.iklim_id
AND iller.plaka = id$$

DROP PROCEDURE IF EXISTS `HighPopCities`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `HighPopCities` ()   SELECT iller.iller_ad,iller.nufus_23
FROM iller
ORDER BY iller.nufus_23 DESC
LIMIT 5$$

DROP PROCEDURE IF EXISTS `HighStationCities`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `HighStationCities` ()   SELECT iller.iller_ad,COUNT(istasyonlar.istasyon_kodu) as istasyon_sayisi
FROM iller,istasyonlar
WHERE iller.plaka = istasyonlar.plaka
GROUP BY iller.plaka
ORDER BY istasyon_sayisi DESC
LIMIT 7$$

DROP PROCEDURE IF EXISTS `LowModelStations`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `LowModelStations` ()   SELECT model.model_kodu, COUNT(istasyonlar.istasyon_kodu) as sayi
FROM istasyonlar,model
WHERE istasyonlar.model_kodu=model.model_kodu
GROUP BY model.model_kodu
ORDER BY sayi 
LIMIT 8$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `eklenen_model_tarih`
--

DROP TABLE IF EXISTS `eklenen_model_tarih`;
CREATE TABLE IF NOT EXISTS `eklenen_model_tarih` (
  `id` int NOT NULL AUTO_INCREMENT,
  `islem` varchar(16) COLLATE utf8mb3_turkish_ci NOT NULL,
  `model_kodu` varchar(16) COLLATE utf8mb3_turkish_ci NOT NULL,
  `model_adi` varchar(40) COLLATE utf8mb3_turkish_ci NOT NULL,
  `model_aciklama` text COLLATE utf8mb3_turkish_ci NOT NULL,
  `soket_id` int NOT NULL,
  `islem_zamani` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_turkish_ci;

--
-- Tablo döküm verisi `eklenen_model_tarih`
--

INSERT INTO `eklenen_model_tarih` (`id`, `islem`, `model_kodu`, `model_adi`, `model_aciklama`, `soket_id`, `islem_zamani`) VALUES
(2, 'eklendi', 'deneme', 'deneme', 'deneme', 5, '2023-12-19 13:32:47');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `iklim_il`
--

DROP TABLE IF EXISTS `iklim_il`;
CREATE TABLE IF NOT EXISTS `iklim_il` (
  `iklim_id` int NOT NULL,
  `plaka` int NOT NULL,
  KEY `iklim_id` (`iklim_id`),
  KEY `plaka` (`plaka`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_turkish_ci;

--
-- Tablo döküm verisi `iklim_il`
--

INSERT INTO `iklim_il` (`iklim_id`, `plaka`) VALUES
(17, 19),
(4, 55),
(11, 42),
(2, 80),
(17, 17),
(5, 78),
(8, 18),
(8, 37),
(12, 77),
(1, 6),
(9, 29),
(10, 67),
(7, 19),
(3, 36),
(13, 13),
(15, 6),
(17, 6),
(4, 72),
(2, 80),
(17, 12),
(15, 4),
(11, 13),
(6, 51),
(8, 50),
(3, 75),
(10, 53),
(17, 6),
(1, 13),
(10, 20),
(1, 49),
(13, 48),
(1, 70),
(13, 41),
(7, 79),
(10, 72),
(17, 8),
(9, 57),
(10, 41),
(8, 31),
(6, 74),
(4, 14),
(2, 27),
(17, 38),
(11, 62),
(15, 61),
(1, 34),
(2, 47),
(5, 36),
(2, 59),
(4, 22),
(15, 51),
(16, 7),
(17, 64),
(7, 65),
(2, 80),
(17, 20),
(5, 54),
(1, 51),
(8, 65),
(16, 18),
(16, 12),
(6, 46),
(16, 69),
(7, 65),
(16, 14),
(11, 7),
(3, 38),
(5, 29),
(4, 13),
(12, 65),
(7, 71),
(3, 63),
(15, 41),
(5, 42),
(7, 28),
(16, 32),
(3, 58),
(16, 71),
(7, 13),
(7, 8),
(3, 22),
(15, 15),
(13, 72),
(17, 71),
(6, 59),
(16, 4),
(5, 16),
(1, 60),
(11, 63),
(2, 29),
(10, 53),
(1, 29),
(16, 57),
(9, 30),
(17, 16),
(16, 26),
(8, 65),
(11, 16),
(10, 6),
(11, 8),
(9, 54),
(17, 71),
(11, 70),
(8, 75),
(9, 16),
(4, 14),
(13, 27),
(2, 45),
(6, 42),
(5, 23),
(4, 58),
(12, 26),
(1, 48),
(8, 3),
(1, 45),
(17, 64),
(12, 13),
(8, 62),
(6, 65),
(2, 31),
(8, 71),
(15, 3),
(2, 80),
(11, 35);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `iklim_kosullari`
--

DROP TABLE IF EXISTS `iklim_kosullari`;
CREATE TABLE IF NOT EXISTS `iklim_kosullari` (
  `iklim_id` int NOT NULL AUTO_INCREMENT,
  `hava_kosullari` varchar(30) COLLATE utf8mb3_turkish_ci NOT NULL,
  PRIMARY KEY (`iklim_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_turkish_ci;

--
-- Tablo döküm verisi `iklim_kosullari`
--

INSERT INTO `iklim_kosullari` (`iklim_id`, `hava_kosullari`) VALUES
(1, 'yağmurlu'),
(2, 'karlı'),
(3, 'bulutlu'),
(4, 'açık'),
(5, 'kapalı'),
(6, 'sisli'),
(7, 'fırtınalı'),
(8, 'rüzgarlı'),
(9, 'güneşli'),
(10, 'parçalı bulutlu'),
(11, 'sağanak yağışlı'),
(12, 'karla karışık yağmurlu'),
(13, 'kar yağışlı'),
(15, 'puslu'),
(16, 'tozlu'),
(17, 'dumanlı');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `iller`
--

DROP TABLE IF EXISTS `iller`;
CREATE TABLE IF NOT EXISTS `iller` (
  `plaka` int NOT NULL,
  `iller_ad` varchar(16) COLLATE utf8mb3_turkish_ci NOT NULL,
  `nufus_23` int NOT NULL,
  `havalimani_sayisi` int NOT NULL,
  `otoyikama_sayisi` int NOT NULL,
  `avm_sayisi` int NOT NULL,
  `otopark_sayisi` int NOT NULL,
  `yillik_yagis` int NOT NULL,
  `fay_hattina_yakinlik` int NOT NULL,
  PRIMARY KEY (`plaka`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_turkish_ci;

--
-- Tablo döküm verisi `iller`
--

INSERT INTO `iller` (`plaka`, `iller_ad`, `nufus_23`, `havalimani_sayisi`, `otoyikama_sayisi`, `avm_sayisi`, `otopark_sayisi`, `yillik_yagis`, `fay_hattina_yakinlik`) VALUES
(1, 'Adana', 2274106, 1, 54, 4, 6, 379, 80),
(2, 'Adıyaman', 635169, 1, 58, 6, 12, 1108, 120),
(3, 'Afyonkarahisar', 747555, 0, 20, 1, 13, 1403, 200),
(4, 'Ağrı', 510626, 1, 3, 1, 30, 624, 100),
(5, 'Amasya', 338267, 1, 38, 5, 29, 764, 180),
(6, 'Ankara', 5782285, 1, 14, 6, 16, 299, 90),
(7, 'Antalya', 2688004, 2, 42, 8, 26, 777, 150),
(8, 'Artvin', 169403, 0, 31, 2, 23, 1386, 120),
(9, 'Aydın', 1148241, 1, 58, 4, 29, 977, 160),
(10, 'Balıkesir', 1257590, 2, 1, 6, 26, 162, 110),
(11, 'Bilecik', 228673, 0, 15, 6, 24, 453, 140),
(12, 'Bingöl', 282556, 1, 3, 4, 26, 1367, 200),
(13, 'Bitlis', 353988, 0, 23, 9, 14, 1073, 130),
(14, 'Bolu', 320824, 0, 58, 4, 28, 316, 170),
(15, 'Burdur', 273799, 0, 39, 2, 32, 1087, 100),
(16, 'Bursa', 3194720, 2, 31, 3, 23, 1291, 110),
(17, 'Çanakkale', 559383, 2, 53, 4, 16, 1439, 150),
(18, 'Çankırı', 195766, 0, 15, 1, 17, 1447, 180),
(19, 'Çorum', 524130, 0, 37, 2, 34, 183, 90),
(20, 'Denizli', 1056332, 1, 57, 1, 22, 449, 120),
(21, 'Diyarbakır', 1804880, 1, 31, 2, 17, 642, 160),
(22, 'Edirne', 414714, 0, 41, 4, 27, 988, 110),
(23, 'Elazığ', 591497, 1, 49, 6, 21, 687, 116),
(24, 'Erzincan', 239223, 1, 25, 5, 39, 1477, 49),
(25, 'Erzurum', 749754, 1, 46, 5, 29, 775, 400),
(26, 'Eskişehir', 906617, 2, 33, 5, 24, 406, 353),
(27, 'Gaziantep', 2154051, 1, 1, 4, 27, 1362, 62),
(28, 'Giresun', 450862, 0, 29, 7, 19, 473, 253),
(29, 'Gümüşhane', 144544, 0, 60, 7, 28, 1395, 81),
(30, 'Hakkari', 275333, 1, 35, 4, 23, 1057, 143),
(31, 'Hatay', 1686043, 1, 22, 6, 9, 1027, 473),
(32, 'Isparta', 445325, 1, 56, 2, 38, 299, 437),
(33, 'Mersin', 1916432, 0, 60, 3, 19, 690, 476),
(34, 'İstanbul', 15907951, 2, 357, 147, 120, 661, 332),
(35, 'İzmir', 4462056, 1, 156, 24, 78, 700, 232),
(36, 'Kars', 274829, 1, 26, 0, 8, 1428, 162),
(37, 'Kastamonu', 378115, 1, 47, 7, 27, 671, 117),
(38, 'Kayseri', 1441523, 1, 26, 5, 5, 313, 99),
(39, 'Kırklareli', 369347, 0, 4, 7, 14, 923, 141),
(40, 'Kırşehir', 244519, 0, 19, 3, 32, 1351, 410),
(41, 'Kocaeli', 2079072, 1, 37, 3, 27, 269, 129),
(42, 'Konya', 2296347, 1, 51, 6, 37, 299, 412),
(43, 'Kütahya', 580701, 1, 48, 7, 14, 954, 285),
(44, 'Malatya', 812580, 1, 35, 6, 28, 320, 145),
(45, 'Manisa', 1468279, 0, 2, 3, 35, 360, 369),
(46, 'Kahramanmaraş', 1177436, 1, 0, 0, 31, 1025, 412),
(47, 'Mardin', 870374, 1, 44, 1, 7, 1411, 451),
(48, 'Muğla', 1048185, 2, 38, 5, 22, 1303, 19),
(49, 'Muş', 399202, 1, 54, 8, 35, 859, 242),
(50, 'Nevşehir', 310011, 1, 32, 7, 32, 176, 153),
(51, 'Niğde', 365419, 0, 15, 0, 26, 1050, 40),
(52, 'Ordu', 763190, 1, 33, 7, 25, 773, 242),
(53, 'Rize', 344016, 1, 18, 1, 27, 503, 24),
(54, 'Sakarya', 1080080, 0, 37, 10, 26, 1161, 34),
(55, 'Samsun', 1368488, 1, 13, 0, 20, 1397, 99),
(56, 'Siirt', 331311, 1, 44, 3, 19, 957, 394),
(57, 'Sinop', 220799, 1, 36, 8, 22, 965, 171),
(58, 'Sivas', 634924, 1, 21, 9, 40, 569, 173),
(59, 'Tekirdağ', 1142451, 1, 23, 6, 29, 627, 350),
(60, 'Tokat', 596454, 1, 25, 7, 38, 1329, 235),
(61, 'Trabzon', 818023, 1, 23, 9, 13, 447, 123),
(62, 'Tunceli', 84366, 0, 25, 0, 11, 435, 408),
(63, 'Şanlıurfa', 2170110, 1, 56, 2, 27, 1010, 174),
(64, 'Uşak', 375454, 1, 31, 3, 16, 660, 147),
(65, 'Van', 1128749, 1, 5, 6, 10, 630, 210),
(66, 'Yozgat', 418442, 0, 38, 2, 32, 1014, 111),
(67, 'Zonguldak', 588510, 1, 42, 1, 20, 1450, 426),
(68, 'Aksaray', 433055, 0, 51, 10, 18, 268, 296),
(69, 'Bayburt', 84241, 0, 40, 4, 17, 857, 200),
(70, 'Karaman', 260838, 0, 38, 4, 20, 175, 113),
(71, 'Kırıkkale', 277046, 0, 59, 10, 27, 309, 464),
(72, 'Batman', 634491, 1, 35, 5, 20, 1432, 482),
(73, 'Şırnak', 557605, 1, 7, 5, 15, 1422, 314),
(74, 'Bartın', 203351, 0, 25, 0, 11, 449, 270),
(75, 'Ardahan', 92481, 0, 18, 8, 22, 1057, 406),
(76, 'Iğdır', 203594, 1, 32, 10, 17, 1145, 218),
(77, 'Yalova', 296333, 0, 22, 2, 6, 445, 375),
(78, 'Karabük', 252058, 0, 29, 10, 23, 563, 219),
(79, 'Kilis', 147919, 0, 20, 10, 36, 623, 472),
(80, 'Osmaniye', 559405, 0, 18, 0, 10, 840, 202),
(81, 'Düzce', 405131, 0, 42, 5, 39, 1023, 92);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `istasyonlar`
--

DROP TABLE IF EXISTS `istasyonlar`;
CREATE TABLE IF NOT EXISTS `istasyonlar` (
  `istasyon_kodu` varchar(30) COLLATE utf8mb3_turkish_ci NOT NULL,
  `plaka` int NOT NULL,
  `model_kodu` varchar(40) COLLATE utf8mb3_turkish_ci NOT NULL,
  `lat` float NOT NULL,
  `lng` float NOT NULL,
  `lokasyon_tipi` tinyint(1) NOT NULL,
  `aktiflik` tinyint(1) NOT NULL,
  `adres` text COLLATE utf8mb3_turkish_ci NOT NULL,
  `otopark` int NOT NULL,
  `park_suresi` int NOT NULL,
  `hizmet_saati` varchar(40) COLLATE utf8mb3_turkish_ci NOT NULL,
  PRIMARY KEY (`istasyon_kodu`),
  KEY `plaka` (`plaka`),
  KEY `model_kodu` (`model_kodu`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_turkish_ci;

--
-- Tablo döküm verisi `istasyonlar`
--

INSERT INTO `istasyonlar` (`istasyon_kodu`, `plaka`, `model_kodu`, `lat`, `lng`, `lokasyon_tipi`, `aktiflik`, `adres`, `otopark`, `park_suresi`, `hizmet_saati`) VALUES
('TR-ADA-002', 1, 'EFANC222', 37.0191, 35.2403, 0, 1, 'Yeni Mah. Öğretmenler Bulvarı 87071. Sok. No:5, Seyhan', 300, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ADA-005', 1, 'EFAQC50CSA', 36.9951, 35.28, 0, 1, 'Fevzipaşa, Turhan Cemal Beriker Blv. No: 292/A, Seyhan', 2, 1440, '00:00,00:00;1,7'),
('TR-ADA-010', 1, 'STCTIT120SS', 36.9881, 35.3368, 0, 1, 'Sinanpaşa Mah. Hacı Sabancı Bulv. No:1, Yüreğir', 1, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ADA-011', 1, 'STCTIT120SS', 37.0276, 35.4014, 1, 1, 'Yıldırım Beyazıt Mah. Kozan Cad. No:755/A, Sarıçam', 30, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ADA-012', 1, 'STCTIT120SS', 37.0535, 35.2548, 1, 1, 'Belediye Evleri Mah. T. Özal Bulvarı No: 234, Çukurova', 200, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ADA-013', 1, 'STCTIT90SS', 36.9831, 35.1091, 1, 1, 'Gökçeler Mah. Adana - Mersin Karayolu üzeri 17. Km. Çukobirlik Gen. Müd. Karşısı Okar Otomotiv plaza, Seyhan', 15, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ADA-014', 1, 'STCTIT120SS', 36.9863, 35.3625, 1, 1, 'Özgür Mah. Girne Blv. No:167/Z01, Yüreğir', 4, 1440, '08:30,18:00;1,5|08:30,16:00;6,6'),
('TR-ADA-015', 1, 'STCTIT120SS', 36.9865, 35.3624, 1, 1, 'Özgür Mah. Girne Blv. No:167/Z01, Yüreğir', 4, 1440, '08:30,18:00;1,5|08:30,16:00;6,6'),
('TR-ADA-016', 1, 'STCTIT120SS', 36.9917, 35.3242, 1, 1, 'Çınarlı Mah. Turhan Cemal Beriker Blv. No:33, Seyhan', 80, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ADA-017', 1, 'STCTIT120SS', 36.9838, 35.3829, 1, 1, 'Yenidoğan mah girne blv. no 245/Z3, Yüreğir ', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ADA-018', 1, 'STCTIT120SS', 36.9838, 35.3749, 1, 1, 'Levent Mah. Girne Blv. No:240/A, Yüreğir', 25, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ADA-019', 1, 'STCTIT120SS', 37.0424, 35.3612, 1, 1, 'Balcalı Mah. Güney Kampüs Bulv. Teknokent Sitesi Yönetim ve Kuluçka Merkezi,  Sarıçam', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ADA-020', 1, 'STCTIT120SS', 37.0577, 35.303, 1, 1, 'Karslı Mah. YSE Cad. 82046. Sok. No:2, Çukurova ', 50, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ADA-021', 1, 'STCTIT120SS', 37.0477, 35.2498, 1, 1, '100. Yıl Mah, Yüzüncüyıl Mh Carrefoursa AVM Yanı, 85019. Sk. No:8,  Çukurova', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ADA-022', 1, 'STCTIT120SS', 37.0111, 35.3389, 0, 1, 'Köprülü, Dr. Mithat Özsan Blv.,  Yüreğir', 30, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ADF-001', 2, 'ABBTER22', 37.7344, 38.2172, 1, 1, 'Altınşehir Mah. Gölbaşı Yolu Kucuk Sanayi Sitesi Karsisi Ford Plaza, Merkez', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AFY-002', 3, 'STCTIT120SS', 38.7933, 30.4579, 1, 1, 'Dörtyol Mahallesi Kütahya Yolu Bulvarı No:2 / 3, Merkez', 100, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AFY-003', 3, 'STCTIT120SS', 38.7743, 30.5887, 1, 1, 'Veysel Karani, Mareşal Fevzi Çakmak Blv. No:75, Merkez', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AFY-004', 3, 'STCTIT180SS', 38.7973, 30.452, 1, 1, 'Dörtyol Mah. Afyon Kütahya Yolu Üzeri, No:9/2, Merkez', 500, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AFY-005', 3, 'STCTIT180SS', 38.7972, 30.4519, 1, 1, 'Dörtyol Mah. Afyon Kütahya Yolu Üzeri, No:9/2, Merkez', 500, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AFY-006', 3, 'STCTIT180SS', 38.7972, 30.4518, 1, 1, 'Dörtyol Mah. Afyon Kütahya Yolu Üzeri, No:9/2, Merkez', 500, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AFY-007', 3, 'STCTIT120SS', 39.0592, 31.1646, 1, 1, 'Yeni Mah. Emidağ Blv. No:442, Emirdağ', 0, 0, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AFY-008', 3, 'STCTIT120SS', 38.7963, 30.6199, 1, 1, 'Sakarya, Ankara kara yolu 7. km,  Susuz/Merkez', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AFY-009', 3, 'STCTIT120SS', 38.7963, 30.62, 1, 1, 'Sakarya, Ankara kara yolu 7. km,  Susuz/Merkez', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AFY-010', 3, 'STCTIT120SS', 38.0568, 30.1448, 0, 1, 'Otogar, Yeni Denizli Cd. No:1,  Dinar', 200, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AFY-011', 3, 'ABBTER22', 38.0568, 30.1449, 0, 0, 'Otogar, Yeni Denizli Cd. No:1,  Dinar', 200, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AFY-012', 3, 'ABBTER22', 38.0568, 30.145, 0, 1, 'Otogar, Yeni Denizli Cd. No:1,  Dinar', 200, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AFY-013', 3, 'STCTIT150SS', 38.7984, 30.4515, 0, 1, 'Dörtyol Mah. Afyon Kütahya Yolu Üzeri, No:9/2, Merkez', 500, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AFY-014', 3, 'STCTIT150SS', 38.7985, 30.4515, 0, 1, 'Dörtyol Mah. Afyon Kütahya Yolu Üzeri, No:9/2, Merkez', 500, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AFY-015', 3, 'ABBTER22', 38.7984, 30.4515, 0, 1, 'Dörtyol Mah. Afyon Kütahya Yolu Üzeri, No:9/2, Merkez', 500, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AGR-001', 4, 'STCATE60SS', 39.6006, 44.0531, 1, 1, 'Karaca Köyü, Doğubeyazıt - Iğdır Karayolu, No:76, Doğubeyazıt', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AKS-002', 68, 'STCTIT90SS', 38.365, 34.0081, 0, 1, 'Taşpazar Mah. E-90 Karayolu Cd. No:1, Merkez', 50, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AKS-003', 68, 'STCTIT120SS', 38.3684, 34.0307, 0, 1, 'Atatürk Bulvarı, 1301 sokak', 1000, 0, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AKS-004', 68, 'STCTIT120SS', 38.3387, 33.974, 1, 1, 'Aratol İstiklal Mah. 135. Necmettin Erbakan Blv. No:65, Merkez', 30, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AKS-005', 68, 'STCTIT120SS', 38.4018, 34.0294, 1, 1, 'Zafer Mah. Muhsin Yazıcıoğlu Blv. No:150, Merkez', 500, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AKS-006', 68, 'STCTIT180SS', 38.2662, 33.9983, 0, 1, ' Sağlık/Aksaray Merkez', 500, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AKS-007', 68, 'STCSAT222', 38.2661, 33.9983, 0, 1, ' Sağlık/Aksaray Merkez', 500, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AMA-001', 5, 'EFAQC20CSA', 40.6432, 35.8078, 0, 1, 'Hacılar Meydanı Maj. Yavuz Acar Cd. No: 90-A, Amasya Merkez', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-001', 6, 'EFANC222', 39.8833, 32.7575, 1, 1, 'Üniversiteler Mah., Bilkent Bulvarı, Bilkent, Çankaya', 1900, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-ANK-002', 6, 'EFANC222', 39.8479, 32.8321, 1, 1, 'Turan Güneş Bulvarı, No:182, Oran, Çankaya', 2500, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-ANK-003', 6, 'EFANC222', 39.9099, 32.7759, 1, 0, 'Mustafa Kemal Mah., Eskişehir Yolu 7.km, No:164, Çankaya', 3000, 1440, '10:00,22:00;1,5|10:00,23:00;6,7|10:00,22'),
('TR-ANK-007', 6, 'EFANC222', 39.8884, 32.8121, 1, 1, 'Konya Yolu, Mevlana Bulvarı, No:190 B, Balgat, Çankaya', 1000, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-ANK-010', 6, 'EFANC222', 39.9523, 32.8303, 1, 1, 'Gazi Mah., Mevlana Bulv., No: 2, Akköprü Mevkii, Yenimahalle', 3000, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-ANK-013B', 6, 'EFANC222', 39.9415, 32.7125, 0, 1, 'Bahçekapı Mahallesi, 6. Cad. No: 9/A, Etimesgut', 15, 1440, '00:00,00:00;1,6'),
('TR-ANK-015', 6, 'EFAQC50CSA', 39.9711, 32.7712, 0, 1, 'Mehmet Akif Ersoy Mah. Anadolu Bulvarı No:110/B, Yenimahalle', 15, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-020', 6, 'EFAPM22', 39.9002, 32.6836, 1, 1, 'Eskişehir Yolu, Erler Mah. 2717 Sok. No:6/A, Etimesgut', 30, 1440, '08:30,18:00;1,5|10:00,16:00;6,7'),
('TR-ANK-022', 6, 'EFANC222', 39.9105, 32.7787, 1, 1, 'Mustafa Kemal Mah. 2123. Sok. No: 2 K: 4 No: 401, Çankaya', 500, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-ANK-023', 6, 'EFAPM22', 39.9127, 32.778, 0, 1, 'Mustafa Kemal Mah. 2123. Sok. No: 2 K: 4 No: 401, Çankaya', 200, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-ANK-024', 6, 'EFAPM22', 39.9646, 32.7648, 0, 1, 'Mehmet Akif Ersoy Mah. 296. Cad. No: 16, Yenimahalle', 100, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-025', 6, 'EFAPM22', 39.9644, 32.7648, 0, 1, 'Mehmet Akif Ersoy Mah. 296. Cad. No: 16, Yenimahalle', 100, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-026', 6, 'EFAPM22', 39.913, 32.8088, 1, 0, 'Eskişehir Yolu No:6, Söğütözü', 1000, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-ANK-027', 6, 'EFAPM22', 39.9124, 32.809, 1, 1, 'Eskişehir Yolu No:6, Söğütözü', 1000, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-ANK-028', 6, 'EFAQC50CSA', 39.9121, 32.8103, 0, 1, 'Eskişehir Yolu No:6, Söğütözü', 1000, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-029', 6, 'EFANC222', 39.7198, 32.8159, 0, 1, 'Ankara Yolu Cad. Karaoğlan, Gölbaşı', 100, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-034', 6, 'EFAQC50CSA', 39.894, 32.677, 0, 1, 'Fatih Sultan Mah. Koru Kavşağı 2719 Cad. No:10A/1-2, 10B, Ümitköy', 2, 1440, '08:30,18:30;1,5'),
('TR-ANK-035', 6, 'EFAQC50CSA', 39.8896, 32.8135, 0, 1, 'Ehlibeyt Mahallesi Mevlana Bulvarı No:199-A 06520 Çankaya', 2, 1440, '08:00,18:30;1,5|09:15,18:30;6,6'),
('TR-ANK-036', 6, 'EFAQC50CSA', 39.9381, 32.7131, 0, 1, 'Hasmer Şaşmaz Plaza Bahçekapı Mah. Sanayi Bulvarı No: 22 Şaşmaz', 2, 1440, '08:30,18:00;1,6'),
('TR-ANK-037', 6, 'EFAQC50SA', 39.9456, 32.7425, 0, 1, 'Uğur Mumcu Mah. Fatih Sultan Mehmet Bul. No: 314, Yenimahalle', 10, 1440, '08:00,18:30;1,5'),
('TR-ANK-046', 6, 'STCTIT120SS', 39.8985, 32.6839, 0, 1, 'Erler Mah. Dumlupınar Blv. No:408/A, Etimesgut', 36, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-048', 6, 'STCTIT120SS', 39.8774, 32.7065, 0, 1, 'Angora Cad., No:209/10, Beysupark, Çayyolu', 350, 1440, '06:00,23:00;1,7|06:00,23:00;8,8'),
('TR-ANK-049', 6, 'STCTIT120SS', 39.9099, 32.7761, 0, 0, 'Mustafa Kemal Mah., Eskişehir Yolu 7.km, No:164, Çankaya', 3000, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-ANK-050', 6, 'STCTIT120SS', 39.8947, 32.8096, 0, 1, 'İşçi Blokları Mah. 1495. Cad. No:11, Çankaya', 50, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-051', 6, 'STCTIT120SS', 39.8948, 32.8099, 1, 1, 'İşçi Blokları Mah. 1495. Cad. No:11, Çankaya', 50, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-052', 6, 'STCTIT120SS', 39.8896, 32.8133, 0, 1, 'Ehlibeyt Mahallesi Mevlana Bulvarı No:199-A 06520 Çankaya', 2, 1440, '08:00,18:30;1,7|09:15,18:30;6,6'),
('TR-ANK-053', 6, 'STCTIT120SS', 39.7431, 32.8052, 0, 1, 'Karaoğlan Mah. Ankara Cad. No:207-209, Gölbaşı', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-054', 6, 'STCTIT120SS', 39.902, 32.8643, 0, 1, 'Tahran Cad. No:12, Kavaklıdere', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-055', 6, 'STCTIT120SS', 39.9528, 32.8621, 1, 1, 'Ziraat, Altındağ Cd. No:31', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-056', 6, 'STCTIT120SS', 39.9529, 32.8621, 1, 1, 'Ziraat, Altındağ Cd. No:31', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-057', 6, 'STCTIT120SS', 40.0946, 32.6228, 1, 1, 'Saray Mah. Ankara-İstanbul Yolu 33. km No:60, Kahramankazan', 5, 1440, '07:00,19:00;1,6'),
('TR-ANK-058', 6, 'STCTIT120SS', 39.946, 32.7186, 1, 1, 'İnönü Mah. Fatih Sultan Mehmet Blv. No:414, Yenimahalle', 50, 1440, '08:30,18:00;1,6|11:00,18:00;7,7|08:30,18'),
('TR-ANK-059', 6, 'STCTIT120SS', 39.9461, 32.7186, 1, 1, 'İnönü Mah. Fatih Sultan Mehmet Blv. No:414, Yenimahalle', 50, 1440, '08:30,18:00;1,6|11:00,18:00;7,7|08:30,18'),
('TR-ANK-060', 6, 'STCTIT120SS', 39.9463, 32.7185, 1, 1, 'İnönü Mah. Fatih Sultan Mehmet Blv. No:414, Yenimahalle', 50, 1440, '08:30,18:00;1,6|11:00,18:00;7,7|08:30,18'),
('TR-ANK-061', 6, 'STCTIT120SS', 39.9108, 32.8126, 1, 1, 'Kızılırmak Mah. Dumlupınar Blv. Next Level İş Kulesi No: 3A/132, Çukurambar', 3000, 180, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-ANK-062', 6, 'STCTIT120SS', 39.8977, 32.6825, 1, 1, 'Erler Mah. 2715 Cad. No:12, Etimesgut', 7, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-063', 6, 'STCTIT120SS', 39.8939, 32.6765, 1, 1, 'Fatih Sultan Mah, 2719. Cad. No:12, Etimesgut', 0, 0, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-064', 6, 'STCTIT120SS', 39.9033, 32.8119, 1, 1, 'Kızılırmak Mah. 1443. Cad. No:39, Çukurambar, Çankaya', 100, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-065', 6, 'STCTIT120SS', 39.9031, 32.8123, 1, 1, 'Kızılırmak Mah. 1443. Cad. No:39, Çukurambar, Çankaya', 100, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-066', 6, 'STCTIT120SS', 39.9031, 32.8123, 1, 1, 'Kızılırmak Mah. 1443. Cad. No:39, Çukurambar, Çankaya', 100, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-067', 6, 'STCTIT120SS', 39.9548, 32.8312, 1, 1, 'Varlık Mahallesi, Fatih Sultan Mehmet Blv. No:4, Yenimahalle', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-068', 6, 'STCTIT120SS', 39.9456, 32.7425, 1, 1, 'Uğur Mumcu Mah. Fatih Sultan Mehmet Bul. No: 314, Yenimahalle', 10, 1440, '08:30,18:30;1,5|00:00,00:00;1,8'),
('TR-ANK-069', 6, 'STCATE60SS', 39.9405, 32.7095, 1, 1, 'Bahçekapı MAH 2472.Cad. Şaşmaz Blv. NO:13/14,  Etimesgut', 2, 1440, '08:30,18:00;1,6'),
('TR-ANK-070', 6, 'STCTIT120SS', 39.9094, 32.7546, 1, 1, 'Mustafa Kemal Mah. Dumlupınar Bulvarı No: 266', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-071', 6, 'STCTIT180SS', 39.8551, 32.6064, 0, 1, 'Yapracık Mah. Dumlupınar Blv. No:30, Etimesgut', 2, 0, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-072', 6, 'STCNOV360S', 39.8551, 32.6064, 0, 1, 'Yapracık Mah. Dumlupınar Blv. No:30, Etimesgut', 2, 0, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-073', 6, 'STCTIT120SS', 40.1626, 31.9106, 1, 1, ' Gazipaşa Mahallesi Hıdırlık Yolu Sokak No:7, Beypazarı', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-074', 6, 'STCTIT120SS', 39.5734, 32.1221, 1, 1, 'Fatih, Ali Rıza Bey Cd. no:1,  Polatlı', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-076', 6, 'STCTIT120SS', 39.8958, 32.813, 1, 1, 'İşçi Blokları, Mevlana Blv. No:162,  Çankaya', 3, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-077', 6, 'STCSAT222', 39.8551, 32.6062, 1, 1, 'Yapracık Mah. Dumlupınar Blv. No:30, Etimesgut', 2, 0, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-079', 6, 'STCJUP60SCA', 39.9399, 32.7125, 1, 0, 'Bahçekapı Mah. 2474 Cad. No:13 A-B-C, Şaşmaz Blv.,  Etimesgut', 10, 1440, '07:30,19:00;1,6|08:00,17:00;7,7'),
('TR-ANK-080', 6, 'STCTIT120SS', 39.9092, 32.8124, 1, 1, 'Kızılırmak Mah., Ufuk Üniversitesi Cad., No:1, Başkent Kule, Çukurambar, Çankaya', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-081', 6, 'STCTIT120SS', 39.9092, 32.8123, 1, 1, 'Kızılırmak Mah., Ufuk Üniversitesi Cad., No:1, Başkent Kule, Çukurambar, Çankaya', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-082', 6, 'STCTIT180SS', 39.8551, 32.6064, 0, 1, 'Yapracık Mah. Dumlupınar Blv. No:30, Etimesgut', 2, 0, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-083', 6, 'EFAQC50SA', 40.1082, 32.6283, 0, 1, 'Selpa Ata sanayi sitesi 4/6-2, Kahramankazan', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-085', 6, 'STCTIT120SS', 39.9124, 32.8086, 0, 0, 'Eskişehir Yolu No:6, Söğütözü', 1000, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-086', 6, 'STCTIT120SS', 39.9125, 32.8086, 0, 1, 'Eskişehir Yolu No:6, Söğütözü', 1000, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-087', 6, 'STCTIT120SS', 39.9125, 32.8086, 0, 1, 'Eskişehir Yolu No:6, Söğütözü', 1000, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-088', 6, 'STCTIT120SS', 39.9123, 32.8085, 0, 1, 'Eskişehir Yolu No:6, Söğütözü', 1000, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-089', 6, 'STCTIT120SS', 39.9124, 32.8085, 0, 1, 'Eskişehir Yolu No:6, Söğütözü', 1000, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-090', 6, 'STCTIT120SS', 39.9124, 32.8084, 0, 1, 'Eskişehir Yolu No:6, Söğütözü', 1000, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-091', 6, 'STCATE60SS', 39.9129, 32.8092, 1, 1, 'Eskişehir Yolu No:6, Söğütözü', 1000, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-ANK-092', 6, 'STCATE60SS', 39.9132, 32.8095, 1, 1, 'Eskişehir Yolu No:6, Söğütözü', 1000, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-ANK-093', 6, 'STCTIT120SS', 39.8947, 32.824, 0, 1, 'Öveçler, Yukarı Öveçler Mah, Çetin Emeç Blv No:75, Çankaya', 3, 1440, '09:00,19:00;1,5|09:00,18:00;6,6|11:00,17'),
('TR-ANK-094', 6, 'STCJUP60SCA', 39.9923, 32.7688, 0, 1, 'İvedikköy Mah. 1493 Sk. No:5/E, Yenimahalle', 10, 1440, '00:00,00:00;1,7'),
('TR-ANK-095', 6, 'STCTIT180SS', 39.9022, 32.8147, 0, 1, 'Oğuzlar Mah. 1377.Sk. No:28, Konya Yolu Üzeri Balgat,  Çankaya', 150, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-096', 6, 'STCTIT180SS', 39.9023, 32.8146, 0, 1, 'Oğuzlar Mah. 1377.Sk. No:28, Konya Yolu Üzeri Balgat,  Çankaya', 150, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-098', 6, 'STCTIT120SS', 39.9108, 32.8126, 1, 1, 'Kızılırmak Mah. Dumlupınar Blv. Next Level İş Kulesi No: 3A/132, Çukurambar', 3000, 180, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-ANK-099', 6, 'STCATE60SS', 39.8994, 32.8144, 0, 1, 'Oğuzlar, Mevlana Blv. No:157,  Çankaya', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-100', 6, 'ABBTER22', 39.8994, 32.8145, 0, 1, 'Oğuzlar, Mevlana Blv. No:157,  Çankaya', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-101', 6, 'STCTIT90SS', 39.9695, 32.6146, 0, 1, 'Eryaman, 2609. Sk.,  Etimesgut', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-102', 6, 'STCTIT90SS', 39.9696, 32.6146, 0, 1, 'Eryaman, 2609. Sk.,  Etimesgut', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-103', 6, 'STCTIT120SS', 39.5875, 32.1463, 0, 1, 'Cumhuriyet, İnönü Cd. No:4,  Polatlı', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-104', 6, 'STCTIT180SS', 39.7004, 32.269, 0, 1, 'Yenidoğan,  Polatlı', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-105', 6, 'ABBTER22', 39.7004, 32.269, 0, 1, 'Yenidoğan,  Polatlı', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANK-106', 6, 'STCTIT120SS', 39.9076, 32.7455, 0, 1, 'Mustafa Kemal, Dumlupınar Blv. No:186,  Çankaya', 50, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANT-003', 7, 'EFANC222', 36.8833, 30.6599, 0, 1, 'Arapsuyu Mah., Atatürk Bulvarı No: 3, Konyaaltı', 3000, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANT-004', 7, 'EFANC222', 36.9145, 30.7767, 0, 1, 'Altınova Sinan Mah. Serik Cd. No: 239 Havaalanı Yolu, Muratpaşa', 50, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANT-007', 7, 'EFANC222', 36.8809, 31.0037, 0, 1, 'Kadriye Mah. Atatürk Cad. no:114/1-2, Serik', 1000, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-ANT-009', 7, 'EFAPM22', 36.5671, 31.917, 0, 1, 'Gerpelit Mevkii Konaklı, Alanya', 100, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANT-010', 7, 'EFAPM22', 36.6077, 31.7827, 0, 1, 'Türkler, Fuğla Mevkii, Alanya', 100, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANT-011', 7, 'EFAQC50CSA', 36.9055, 30.7536, 0, 1, 'Göksu Mah. Gazi Bulvarı 92. Sokak No: 465/2 Çevreyolu Üzeri Kepez', 2, 1440, '08:45,18:00;1,6|10:00,16:00;7,7'),
('TR-ANT-012', 7, 'EFAQC50CSA', 36.9045, 30.7546, 0, 1, 'Göksu Mah. Gazi Bulvarı, İzzet Doğan İş Merkezi No:469/6 Kepez', 2, 1440, '08:00,18:00;1,6'),
('TR-ANT-013', 7, 'EFAQC20CSA', 36.8572, 30.7462, 1, 1, 'Fener Mah. Tekelioğlu Cd. No:3 Muratpaşa', 2, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-ANT-015', 7, 'ABBTER22', 36.6604, 30.557, 0, 1, 'Göynük Mah. Ahu Ünal Aysal Cad. No:29, Kemer', 40, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANT-016', 7, 'ABBTER22', 36.6604, 30.557, 0, 1, 'Göynük Mah. Ahu Ünal Aysal Cad. No:29, Kemer', 40, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANT-019', 7, 'STCTIT120SS', 36.5985, 30.5712, 0, 1, 'Merkez Mah. Yalı Cad. No:7, Kemer', 20, 0, '00:00,00:00;1,6|00:00,00:00;8,8'),
('TR-ANT-020', 7, 'STCTIT120SS', 36.5981, 30.5732, 0, 1, 'Merkez Mah. Yalı Cad. 177. sk No:7, Kemer', 200, 0, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANT-021', 7, 'STCTIT120SS', 36.887, 30.6756, 1, 1, 'Bahçelievler Mah. Tarık Akıltopu Cad. No:1, Muratpaşa', 100, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANT-022', 7, 'STCTIT120SS', 36.8871, 30.6766, 1, 1, 'Bahçelievler Mah. Tarık Akıltopu Cad. No:1, Muratpaşa', 100, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANT-023', 7, 'STCTIT120SS', 36.6259, 31.7621, 1, 1, 'Avsarlar Merkez Mahallesi Caddesi No:20, Alanya', 40, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANT-024', 7, 'STCTIT120SS', 36.6246, 31.7639, 1, 1, 'Avsarlar Merkez Mahallesi Caddesi No:20, Alanya', 50, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANT-025', 7, 'STCTIT120SS', 36.9073, 30.6647, 1, 1, ' Fabrikalar, Dumlupınar Blv. No:49, Kepez', 500, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-ANT-026', 7, 'STCTIT120SS', 36.9969, 30.629, 1, 1, 'Altınkale Mah. Akdeniz Blv. No:187, Döşemealtı', 8, 240, '08:30,18:30;1,6'),
('TR-ANT-027', 7, 'STCTIT120SS', 36.857, 30.7474, 1, 1, 'Fener Mah. Tekelioğlu Cd. No:3 Muratpaşa', 2, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-ANT-028', 7, 'STCTIT120SS', 36.8573, 30.747, 1, 1, 'Fener Mah. Tekelioğlu Cd. No:3 Muratpaşa', 2, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-ANT-029', 7, 'STCTIT120SS', 36.8568, 30.7389, 1, 1, 'Şirinyalı Mah., Eski Lara Yolu, No:102, Lara', 100, 0, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANT-030', 7, 'STCTIT120SS', 36.3438, 29.3345, 1, 1, 'Kınık Mah İnönü bulvarı no:14a, Kaş', 20, 140, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANT-031', 7, 'STCATE60SS', 36.3438, 29.3345, 1, 1, 'Kınık Mah İnönü bulvarı no:14a, Kaş', 20, 140, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANT-032', 7, 'STCTIT120SS', 36.8204, 31.2913, 1, 1, 'Gündoğdu Mah. 3. Sk. No:3, Manavgat', 15, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANT-033', 7, 'STCTIT120SS', 36.8356, 31.1444, 1, 1, 'Boğazkent Mah, Mimar Sinan Cd. 5,  Serik', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANT-034', 7, 'STCTIT90SS', 36.843, 30.5977, 1, 1, 'Sarısu Mah. 121. Sk. No:20. Konyaaltı', 10, 1440, '09:00,18:00;1,7'),
('TR-ANT-035', 7, 'STCTIT120SS', 36.5741, 30.5799, 1, 1, 'Kiriş Mah. Sahil Cad. No:5, Kemer', 60, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANT-036', 7, 'STCVEN30S', 36.1939, 29.5965, 1, 0, 'Andifli, Sait Esen Sokak, Kaş', 1, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANT-037', 7, 'STCTIT150SS', 36.608, 31.7828, 0, 0, 'Türkler, Fuğla Mevkii, Alanya', 100, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ANT-040', 7, 'STCATE60SS', 36.5457, 32.0244, 0, 1, 'Cikcilli, Merkez MH, 111. Sk. NO:7/D,  Alanya', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ART-001', 8, 'STCVEN30S', 41.387, 41.4429, 0, 1, 'Sundura, Artvin Cd. No:170,  Hopa', 25, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AYD-003', 9, 'STCJUP60SCA', 37.7343, 27.4013, 0, 1, 'Cumhuriyet Mh. Akeller Cd. No: 6, Söke', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AYD-004', 9, 'STCTIT120SS', 37.8461, 27.8182, 0, 1, 'Zeybek Mah. İzmir Blv. No:121, Efeler', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AYD-005', 9, 'STCTIT120SS', 37.846, 27.8658, 1, 1, 'Ata Mah. Toptan Gıda Çarşısı 1. Cad. No:2, Efeler', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AYD-006', 9, 'ABBTER22', 37.7155, 27.2182, 1, 1, 'Güzelçamlı Mah. Oteller Cad. No:13, Kuşadası', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AYD-007', 9, 'STCTIT120SS', 37.7155, 27.2182, 1, 1, 'Güzelçamlı Mah. Oteller Cad. No:13, Kuşadası', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AYD-008', 9, 'STCTIT120SS', 37.6456, 28.0296, 1, 1, 'Çaltı, Muğla Aydın Karayolu, No:732,  Çine', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AYD-009', 9, 'STCTIT90SS', 37.6381, 28.0342, 1, 1, 'Yolboyu, Merkez Sk No:242, 09500 Çine/Aydın', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AYD-010', 9, 'STCTIT120SS', 37.7692, 27.4257, 1, 1, 'Fevzipaşa, Aydın Cd. No: 181,  Söke', 4, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AYD-011', 9, 'STCTIT120SS', 37.7692, 27.4257, 1, 1, 'Fevzipaşa, Aydın Cd. No: 181,  Söke', 4, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-AYD-012', 9, 'STCVEN30S', 37.9466, 28.8291, 1, 1, 'Kızıldere Mh, Denizli Aydın Yolu,  Buharkent', 15, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BAR-001', 74, 'STCTIT120SS', 41.6221, 32.3414, 1, 1, 'Kemerköprü Mah. Kadıoğlu Sokak No:30, Merkez', 83, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BAR-002', 74, 'STCTIT120SS', 41.7444, 32.3885, 1, 1, 'Kum Mah. Turgut Işık Cad. No:66/A, Amasra', 15, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BAR-003', 74, 'STCTIT90SS', 41.623, 32.3259, 1, 1, 'Kemer Köprü, Elmalık Sk. 60-76,  Bartın Merkez', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BAR-004', 74, 'STCTIT90SS', 41.623, 32.3259, 1, 1, 'Kemer Köprü, Elmalık Sk. 60-76,  Bartın Merkez', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BAR-005', 74, 'STCTIT120SS', 41.6246, 32.3204, 0, 0, 'Cumhuriyet, Cumhuriyet Cd. No:10, Bartın Merkez', 3, 1440, '08:00,17:00;1,6'),
('TR-BIL-001', 11, 'STCTIT120SS', 39.8882, 29.9386, 1, 1, 'Bursa Eskişehir Yolu 94-51/2 Kizilcapinar Koyu Sokagi, D200, D:E90, Bozüyük', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BLK-002', 10, 'ABBTER22', 39.4832, 26.9272, 0, 1, 'İskele Mah. Ayhan Özerdem Cad. No:14 Burhaniye', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BLK-003', 10, 'STCTIT120SS', 39.5699, 27.9002, 0, 1, 'Kesirven Mah. İsmail Akçay Sk. No:311, Altıeylül', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BLK-004', 10, 'STCTIT120SS', 39.6153, 27.894, 1, 1, 'Plevne Mah. 226 Sk. No:1/7, Altıeylül', 180, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BLK-005', 10, 'STCTIT120SS', 39.5974, 26.9785, 1, 1, 'Yolören Mah. Akçay Yolu 3. Km Mobayn Mobilya No:3, Edremit', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BLK-006', 10, 'STCTIT120SS', 39.5701, 27.8998, 1, 1, 'Kesirven Mah. İsmail Akçay Sk. No:346, Altıeylül', 9, 1440, '08:45,18:20;1,6'),
('TR-BLK-007', 10, 'STCTIT120SS', 39.2876, 26.7068, 1, 1, 'Küçükköy, İzmir Çanakkale Yolu E87, D550, Ayvalık', 16, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BLK-008', 10, 'STCTIT90SS', 39.2876, 26.7068, 1, 1, 'Küçükköy, İzmir Çanakkale Yolu E87, D550, Ayvalık', 16, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BLK-009', 10, 'STCVEN30S', 39.3371, 26.66, 1, 1, 'Namık Kemal, 15 Eylül Cd. No:76,  Ayvalık', 15, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BLK-010', 10, 'ABBTER22', 39.3332, 26.6565, 1, 1, 'Namık Kemal, 15 Eylül Cd. 24. Sokak No:6,  Cunda Adası, Ayvalık', 12, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BLK-011', 10, 'STCTIT180SS', 40.2991, 28.0299, 1, 1, 'Doğruca, Balıkesir Asfaltı 5. Km,  Bandırma', 50, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BLK-012', 10, 'STCTIT180SS', 39.6055, 27.9058, 1, 1, 'Çayırhisar, İzmir Yolu 5. Km,  Merkez', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BLK-013', 10, 'STCTIT120SS', 40.3443, 27.9524, 1, 1, 'Paşakent, Şht. Cem Güçlü Cd., No:2,  Bandırma', 50, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BLK-014', 10, 'STCTIT120SS', 39.5792, 27.9035, 0, 1, 'Kesirven Mah, Kesirven Mah. Akçakaya Sok, Akçakaya Yolu 348/1,  Merkez', 10, 1440, '09:00,18:00;1,5|09:00,17:00;6,6|10:00,16'),
('TR-BOL-001', 14, 'EFAPM22', 40.7229, 31.4669, 0, 1, 'Ankara-İstanbul Otoyolu, 227. Km, Elmalık Mevkii', 3750, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BOL-006', 14, 'STCTIT180SS', 40.7242, 31.4637, 0, 1, 'Ankara-İstanbul Otoyolu, 227. Km, Elmalık Mevkii', 3750, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BOL-007', 14, 'STCTIT150SS', 40.7241, 31.4638, 0, 1, 'Ankara-İstanbul Otoyolu, 227. Km, Elmalık Mevkii', 3750, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BOL-008', 14, 'STCTIT120SS', 40.739, 31.6602, 0, 1, 'Karaağaç Mah. Karalar Sk. No:3/A,Merkez', 10, 0, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BOL-009', 14, 'STCTIT180SS', 40.7358, 31.5855, 0, 1, 'Beşkavaklar Mah. D-100 Karayolu Cad. No: 35/B,  Merkez', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BOL-010', 14, 'STCATE60SS', 40.3999, 31.5607, 0, 1, 'Seben Nallıhan Yolu,  Gerenözü/Seben', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BOL-011', 14, 'STCATE60SS', 40.7032, 31.6186, 0, 1, 'Merkez, Kaplıca Yolu Sk. Berk Köyü No:41,  Berk/Bolu Merkez', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BUR-002', 16, 'EFANC222', 40.3069, 29.0619, 0, 1, 'Ovaakça Çeşmebaşı Mahallesi, Yeni Yalova Yolu Cd. No:65, Osmangazi', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BUR-003', 16, 'EFANC222', 40.2124, 28.9273, 0, 1, 'Altınşehir Mahallesi, İzmir Cd. No:281,  Nilüfer', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BUR-004', 16, 'EFAQC50CSA', 40.2332, 28.7815, 0, 1, 'İzmir Otoyolu OHT-4 Aytemiz Akaryakıt İstasyonu İstanbul Yönü, Nilüfer', 30, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BUR-006', 16, 'EFAPM22', 40.2118, 28.9339, 0, 0, 'Üçevler Mah. 65. Sok. 1/A, Nilüfer', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BUR-008', 16, 'EFAQC50SA', 40.215, 28.8928, 0, 1, 'Ürünlü, İzmir Yolu Cd 10.km D:No:403 Nilüfer', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BUR-010', 16, 'ABBTER22', 40.2133, 28.9545, 0, 0, 'İzmir Yolu No: 226 Nilüfer', 15, 1440, '09:00,18:30;1,7'),
('TR-BUR-012', 16, 'ABBTER22', 40.2074, 28.9987, 0, 0, 'Odunluk Mah. Akpınar Cad. Nilüfer', 100, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BUR-013', 16, 'ABBTER22', 40.207, 28.9987, 0, 1, 'Odunluk Mah. Akpınar Cad. Nilüfer', 100, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BUR-015', 16, 'STCJUP60SCA', 40.2892, 28.9365, 0, 1, 'Çağrışan Mh. 2000. Sk. No: 1A, Mudanya', 300, 1440, '08:30,18:30;1,5|09:00,18:00;6,6|11:00,16'),
('TR-BUR-016', 16, 'STCTIT120SS', 40.2556, 29.0964, 0, 1, 'İsmetiye Mah. 2. İhtiyar Sk. No:138/A, Osmangazi', 2, 1440, '08:00,18:00;1,5|08:00,13:00;6,6'),
('TR-BUR-017', 16, 'STCTIT120SS', 40.2139, 28.9171, 0, 1, 'Ertuğrul Mah. İzmir Yolu Cad. No:366/D, Nilüfer', 250, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BUR-018', 16, 'STCTIT120SS', 40.2816, 29.0525, 0, 1, 'Alaşar Mah. Yalova Yolu Cad. No:525-A/B, Osmangazi', 150, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BUR-019', 16, 'STCTIT120SS', 40.2449, 29.0631, 0, 1, 'Panayır Mah. İstanbul Cd No:433 Osmangazi', 42, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BUR-020', 16, 'STCTIT120SS', 40.2856, 29.0542, 0, 1, 'Alaşarköy Mah. İstanbul Cd. 13. Km No:543, Osmangazi', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BUR-021', 16, 'STCTIT120SS', 40.2159, 28.8918, 1, 1, '100. Yıl Mah. İzmir Yolu Cad. No:432/B, Nilüfer', 2, 1440, '08:00,18:00;1,5|08:00,16:00;6,6'),
('TR-BUR-022', 16, 'STCTIT120SS', 40.284, 28.9341, 1, 1, 'Nilüfer Mah. Mudanya Yolu Cad. No: 21-23, Osmangazi', 18, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BUR-023', 16, 'STCTIT120SS', 40.09, 29.5031, 1, 1, 'Süleymaniye, Ankara-Bursa Karayolu 2.Km D:16400, Süleymaniye Osb, İnegöl', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BUR-024', 16, 'STCTIT120SS', 40.3099, 29.0637, 1, 1, 'Ovaakça Eğitim, Mah İstanbul Caddesi No:752, Demirtaş Dumlupınar Osb, Osmangazi', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BUR-025', 16, 'STCTIT90SS', 40.0867, 29.5101, 1, 1, 'Osmaniye Mah. Altay Cad. No:2 İnegöl', 1000, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BUR-026', 16, 'STCTIT90SS', 40.0866, 29.5101, 1, 1, 'Osmaniye Mah. Altay Cad. No:2 İnegöl', 1000, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BUR-027', 16, 'STCTIT120SS', 40.2047, 29.3554, 1, 1, 'Turanköy Mah. Turan Cad. No:23, Kestel', 8, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BUR-028', 16, 'STCTIT120SS', 40.2419, 29.0641, 1, 1, 'Panayır Mah. İstanbul Cd. No:438 Osmangazi', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BUR-029', 16, 'STCTIT120SS', 40.215, 28.8927, 1, 1, 'Ürünlü, İzmir Yolu Cd 10.km D:No:403 Nilüfer', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BUR-030', 16, 'STCTIT90SS', 40.2271, 28.7975, 1, 1, 'İrfaniye Mah. İzmir Yolu Cad. No:624, Nilüfer ', 10, 1440, '08:30,17:00;1,6'),
('TR-BUR-031', 16, 'STCTIT120SS', 40.2273, 29.0629, 1, 1, 'Altınova, İstanbul Cd No:410 A,  Osmangazi', 40, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BUR-032', 16, 'STCTIT120SS', 40.2271, 29.0628, 1, 1, 'Altınova, İstanbul Cd No:410 A,  Osmangazi', 40, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BUR-033', 16, 'STCSAT222', 40.2271, 29.0632, 1, 1, 'Altınova, İstanbul Cd No:410 A,  Osmangazi', 40, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BUR-034', 16, 'STCTIT120SS', 40.2358, 28.9779, 1, 1, 'Bağlarbaşı, Sanayi Cd. No:368 A-B,  Osmangazi', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BUR-035', 16, 'EFAPM22', 40.2394, 28.9301, 0, 1, 'Nilüfer OSB, N.113 Sk. No:3, Minareliçavuş OSB, Nilüfer', 1, 1440, '08:00,18:00;1,5|08:00,16:00;6,6'),
('TR-BUR-036', 16, 'STCTIT120SS', 40.0727, 29.5422, 0, 1, 'Mesudiye, 33.Mobilya Sk No:39,  İnegöl', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BUR-037', 16, 'STCTIT150SS', 40.1019, 29.4719, 0, 1, 'Çeltikçi, Eski İpek Cad No:37, İnegöl', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BUR-038', 16, 'ABBTER22', 40.102, 29.4719, 0, 1, 'Çeltikçi, Eski İpek Cad No:37, İnegöl', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BUR-039', 16, 'ABBTER22', 40.2126, 28.9568, 0, 1, 'Beşevler, İzmir Road Cad 5.KM,  Nilüfer', 10, 1440, '08:30,18:00;1,5|08:30,17:00;6,6'),
('TR-BUR-040', 16, 'ABBTER22', 40.2127, 28.9567, 0, 1, 'Beşevler, İzmir Road Cad 5.KM,  Nilüfer', 10, 1440, '08:30,18:00;1,5|08:30,17:00;6,6'),
('TR-BYB-001', 69, 'STCTIT120SS', 40.2672, 40.2007, 1, 1, 'Şingah Mah. Turgut Özal Blv. No:44, Merkez', 30, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BYB-002', 69, 'STCTIT120SS', 40.2593, 40.2137, 1, 1, 'Şingah Mah., Turgut Özal Blv. No:17,  Bayburt Merkez', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BYB-003', 69, 'STCTIT90SS', 40.2688, 40.1973, 0, 1, 'Şingah Mah, Kayışkıran Mevkii, Turgut Özal Blv. No:22,  MERKEZ', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-BYB-004', 69, 'STCTIT120SS', 40.2612, 40.2138, 0, 1, 'Bayburt Kuleleri Altı,  Merkez', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-CAN-001', 17, 'EFANC222', 40.4135, 26.6788, 0, 1, 'Hoca Hamza Mah. Kemal Reis Cad. No:25 Gelibolu', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-CAN-002', 17, 'ABBTER22', 39.5596, 26.3417, 0, 0, 'İlyasfakı Mah. Köy Sok. No:152-8, Ayvacık', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-CAN-003', 17, 'ABBTER22', 40.1544, 26.4576, 0, 1, 'Karacaören Köyü Testicikırı Mah. 2. Sk. No:2/1, Merkez', 25, 1440, '00:00,00:00;1,7'),
('TR-CAN-005', 17, 'STCTIT180SS', 40.6033, 26.9029, 0, 1, 'Kavakköy Otoyol Servis Alanı, Hürriyet Mah. 258 ada 49 Parsel Kavakköy Çanakkale ', 150, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-CAN-006', 17, 'STCTIT180SS', 40.6023, 26.9047, 0, 1, 'Kavakköy Otoyol Servis Alanı, Hürriyet Mah. 258 ada 49 Parsel Kavakköy Çanakkale', 150, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-CAN-007', 17, 'STCTIT180SS', 40.2759, 26.6254, 0, 1, 'Lapseki Otoyol Servis Alanı, Batı Kısım 101 Ada / 92 Parsel Suluca Mevkii Lapseki, Çanakkale', 150, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-CAN-008', 17, 'STCTIT180SS', 40.3996, 26.6171, 0, 1, 'Gelibolu Otoyol Servis Alanı, Cevizli Köyü Gelibolu Çanakkale ', 150, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-CAN-009', 17, 'STCTIT180SS', 40.3979, 26.615, 0, 1, 'Gelibolu Otoyol Servis Alanı, Cevizli Köyü Gelibolu Çanakkale ', 150, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-CAN-010', 17, 'STCTIT180SS', 40.2757, 26.6278, 0, 1, 'Lapseki Otoyol Servis Alanı, Doğu Kısım 148 Ada / 309 Parsel Suluca Mevkii Lapseki, Çanakkale', 150, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-CAN-011', 17, 'EFAQC50SA', 40.1616, 26.4682, 1, 1, 'İsmetpaşa Mah, Çanakkale Organize Sanayi Bölgesi İç Yolu No:48,  Özbek, Merkez', 75, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-CAN-012', 17, 'STCTIT120SS', 40.0804, 26.3846, 1, 1, 'Çınarlı Köyü, Armutlu Mevkii 12. Sk. No:16/1, Merkez', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-CAN-013', 17, 'STCVEN30S', 39.8304, 26.0458, 1, 1, 'Cumhuriyet Mah. Çaykır Mevkii, No:80, Bozcaada', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-CAN-014', 17, 'STCTIT120SS', 39.5087, 26.3853, 1, 1, 'Büyükhusun Köyü Sazak Mevkii No:27 ( Ada:123 , Pafta:İ16C23C , Parsel:62 ), Ayvacık ', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-CAN-015', 17, 'ABBTER22', 40.1445, 26.4267, 0, 1, 'Metin Oktay Cad, Onurcan Sk. No: 12,  Merkez', 1, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-CAN-016', 17, 'STCTIT180SS', 39.9354, 27.2629, 0, 1, 'Kurtuluş Balikesir asfalti uzeri, no2,  Yenice', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-CAN-017', 17, 'ABBTER22', 39.9353, 27.2629, 0, 1, 'Kurtuluş Balikesir asfalti uzeri, no2,  Yenice', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-CKR-001', 18, 'STCTIT90SS', 40.8397, 32.7081, 1, 1, 'İstanbul Samsun Yolu, Çördük, Çerkeş', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-COR-001', 19, 'EFAPM22', 40.5448, 34.9477, 1, 1, 'Çepni Mah. 1. Cad No:7,  Kerebigazi', 1500, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-COR-002', 19, 'EFAQC50CSA', 40.5222, 34.916, 0, 1, 'Merkez Mah. Çevreyolu Bulvarı 3. km Merkez', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-COR-003', 19, 'STCTIT90SS', 40.5165, 34.9137, 1, 1, 'Mimar Sinan Mah, Çevre Yolu Blv. 5. Km No: 27, Merkez', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-COR-004', 19, 'STCTIT90SS', 40.5748, 34.9642, 1, 1, 'Üçtutlar, Binevler 9. Sk. 1,  Çorum Merkez', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-COR-005', 19, 'STCTIT120SS', 40.511, 34.912, 0, 1, 'Mimar Sinan, Çevre Yolu Blv. 3. Km No:43,  Çorum Merkez', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-DIY-005', 21, 'STCTIT120SS', 37.9421, 40.2023, 1, 1, 'Elazığ Yolu 2. San. Sitesi Cami Karşısı, Yenişehir', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-DIY-006', 21, 'STCTIT120SS', 37.9118, 40.0924, 1, 1, 'Çölgüzeli, Diyarbakır-Şanlıurfa Yolu 12. Km No:302,  Bağlar', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-DIY-007', 21, 'ABBTER184SS', 37.9647, 40.177, 0, 1, 'Fabrika Mahallesi Mahabad Bulvarı Birtane Gold Office Altı,  Yenişehir', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-DIY-008', 21, 'STCTIT120SS', 37.8639, 40.8992, 0, 1, 'Batman – Bismil Karayolu 22.KM Çeltikli Mahallesi (Kümeevler)\nNo.:227, D:370,  Bismil', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-DIY-009', 21, 'EFAQC50CSA', 37.9259, 40.167, 0, 1, 'Bağcılar mah, Şanlıurfa Blv. No:175,  Kayapınar', 30, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-DNZ-002', 20, 'EFAPM22', 37.8037, 29.0732, 0, 1, 'Menderes Bulvarı No: 41, Gümüşçay', 20, 1440, '08:00,18:00;1,5|08:30,16:00;6,7'),
('TR-DNZ-004', 20, 'STCTIT120SS', 37.8307, 29.0509, 1, 1, 'Bozburun Mahallesi Menderes Blv. No:290, Merkezefendi', 24, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-DNZ-005', 20, 'STCTIT120SS', 37.8074, 29.071, 1, 1, 'Akçeşme Mah. Menderes Blv. No:146,  Merkezefendi', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-DNZ-006', 20, 'STCTIT120SS', 37.8026, 29.0739, 1, 1, 'Gümüşçay Mah. Menderes Bulvarı, No:33, Merkezefendi', 2, 1440, '09:00,19:00;1,6'),
('TR-DNZ-007', 20, 'STCTIT120SS', 37.8037, 29.0897, 1, 0, 'Zafer Mah. 8020. Sk. No:32/A, Merkezefendi', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-DNZ-008', 20, 'STCTIT120SS', 37.7857, 29.0898, 1, 1, 'Topraklık, Gazi Mustafa Kemal Blv. No:11,  Denizli Merkez', 30, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-DNZ-010', 20, 'STCTIT120SS', 37.7889, 29.0928, 0, 1, 'Sümer, Ankara Bulv. 29/C,  Merkez, Merkezefendi', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-DNZ-011', 20, 'STCTIT120SS', 37.8016, 29.1017, 0, 1, 'Sevindik, 26, 2331. Sk., Merkez', 3, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-DNZ-012', 20, 'STCTIT120SS', 37.8414, 29.0359, 0, 1, 'Hacıeyüplü, 3154. Sk. No:3,  Denizli Merkez/Denizli', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-DZC-001', 81, 'STCTIT90SS', 40.8361, 31.1674, 1, 1, 'Cedidiye Mah. Tayfun Sk. No:3, Merkez', 35, 1440, '09:00,22:00;1,7|09:00,22:00;8,8'),
('TR-DZC-002', 81, 'STCTIT120SS', 40.7982, 31.2454, 1, 1, 'Yeni Doğan Mah. 114. Sk. No:38/A, Kaynaşlı', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-DZC-003', 81, 'STCTIT180SS', 40.7811, 31.2784, 0, 1, 'Şimşir,  Kaynaşlı', 30, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-DZC-004', 81, 'STCTIT180SS', 40.7811, 31.2786, 0, 1, 'Şimşir,  Kaynaşlı', 30, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-DZC-005', 81, 'STCVEN30S', 40.849, 31.0914, 0, 1, 'Şimşir, Düzce Cd. NO: 129/8,  Kaynaşlı', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-DZC-006', 81, 'STCVEN30S', 40.7791, 31.2843, 0, 1, 'Şimşir, Düzce Cd. NO:,  Kaynaşlı/Düzce', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-EDR-001', 22, 'EFAQC50CSA', 40.875, 26.6422, 0, 1, 'Keşan İspat Cami Mah. Kondra Cad. No: 80, Keşan', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-EDR-003', 22, 'STCTIT120SS', 41.6669, 26.5713, 1, 1, 'Talatpaşa Cad. No: 59, Merkez', 500, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-EDR-004', 22, 'STCTIT120SS', 41.8646, 26.7037, 1, 1, 'Hanlıyenice Köyü, Hanlıyenice Küme Evleri, No:162, Lalapaşa', 100, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-EDR-005', 22, 'STCTIT180SS', 40.8749, 26.6415, 1, 1, 'Keşan İspat Cami Mah. Kondra Cad. No: 80, Keşan', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-EDR-006', 22, 'STCTIT180SS', 40.8749, 26.6415, 1, 1, 'Keşan İspat Cami Mah. Kondra Cad. No: 80, Keşan', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ELA-001', 23, 'STCVEN30S', 38.6671, 39.2479, 1, 1, 'Sanayi Mah. Sanayi Cad. No:86, Merkez', 5, 1440, '08:00,19:00;1,7|08:00,19:00;8,8'),
('TR-ERC-001', 24, 'ABBTER22', 39.7447, 39.5007, 1, 1, 'Karaağaç Mah. Ergenekon Cad. No:3, Merkez', 2, 1440, '08:00,18:00;1,6|08:00,18:00;8,8'),
('TR-ERZ-001', 25, 'EFAPM7', 39.9575, 41.3019, 0, 1, 'Ömer Nasuhi Bilmen Mah. Tortum Yolu Cad. No: 212, Yakutiye', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ERZ-002', 25, 'STCVEN30S', 39.9102, 41.2584, 1, 1, 'Lalapaşa, Fuar Yolu Cd No:3,  Yakutiye', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ERZ-003', 25, 'STCVEN30S', 39.9575, 41.2943, 1, 1, 'Şükrüpaşa, Çevre Yolu Bulv No: 1, Yakutiye', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ESK-001', 26, 'EFAQC50CSA', 39.8055, 30.4171, 0, 1, 'Yukarı Söğütönü Mah. Çevreyolu Sok. No:750 Tepebaşı', 3, 1440, '00:00,00:00;1,7'),
('TR-ESK-003', 26, 'STCJUP60SCA', 39.7829, 30.5109, 1, 0, 'Eskibağlar Mah. Prof. Dr. Yılmaz Büyükerşen Blv. No:21, Tepebaşı ', 1100, 120, '10:00,22:00;1,7'),
('TR-ESK-004', 26, 'STCTIT120SS', 39.7831, 30.5109, 1, 1, 'Eskibağlar Mah. Prof. Dr. Yılmaz Büyükerşen Blv. No:21, Tepebaşı ', 1100, 120, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-ESK-005', 26, 'STCTIT120SS', 39.7412, 30.6221, 1, 1, 'Yetmişbeşinci yıl Mahallesi, Emko Sanayi Sitesi, 1. Cd. no:31,  Odunpazarı', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-GMS-001', 29, 'STCTIT120SS', 40.4502, 39.4956, 0, 1, 'Yeni Mah. Kazım Karabekir Cad. No:4, Merkez', 10, 0, '00:00,00:00;1,7'),
('TR-GSN-001', 28, 'ABBTER22', 40.2881, 38.4021, 1, 0, 'Bülbül Mahallesi D865, Bayhasan Köyü Yolu, Np:32/A, Şebinkarahisar', 8, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-GSN-002', 28, 'STCTIT90SS', 40.2881, 38.4026, 1, 1, 'Bülbül Mahallesi D865, Bayhasan Köyü Yolu, Np:32/A, Şebinkarahisar', 8, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-GSN-003', 28, 'STCTIT120SS', 40.9376, 38.1973, 0, 1, 'Aktepe Sokak no:2/3', 4, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-GSN-004', 28, 'ABBTER22', 40.9377, 38.1971, 0, 1, 'Aktepe Sokak no:2/3', 4, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-GZP-006', 27, 'STCTIT120SS', 37.0945, 37.4011, 1, 1, 'Aydınlar Mahallesi Şehit Ömer Halis Demir Bulvarı No:16, Şehitkamil', 3, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-GZP-007', 27, 'STCTIT120SS', 37.0518, 37.3201, 1, 1, '15 Temmuz Mah. Prof. Dr. Necmettin Erbakan Cad. 33 Sok. No:71, Şehitkamil', 200, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-GZP-008', 27, 'STCTIT120SS', 37.0761, 37.3872, 1, 1, 'Mithatpaşa, Alibey Sk. No:1,  Şehitkamil', 50, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-GZP-009', 27, 'STCTIT90SS', 37.084, 37.4194, 1, 1, 'Aydınlar Mah. 03041 Nolu Cad. No:13,  Şehitkamil', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-GZP-010', 27, 'STCATE60SS', 37.0882, 37.3534, 1, 1, 'Zeytinli Mah. 79006 Sk. No:3, Şehitkamil', 10, 1440, '08:00,18:00;1,5|08:00,13:15;6,6'),
('TR-GZP-011', 27, 'STCTIT120SS', 37.1322, 37.3041, 1, 1, 'Büyükpınar Mah. Adana Yolu Bulv. No:94, Şehitkamil', 100, 60, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-GZP-012', 27, 'STCTIT120SS', 37.1322, 37.3042, 1, 1, 'Büyükpınar Mah. Adana Yolu Bulv. No:94, Şehitkamil', 100, 60, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-GZP-013', 27, 'STCTIT120SS', 37.1323, 37.3042, 1, 1, 'Büyükpınar Mah. Adana Yolu Bulv. No:94, Şehitkamil', 100, 60, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-GZT-001', 27, 'EFANC222', 37.0522, 37.3204, 1, 1, '15 Temmuz Mah. Prof. Dr. Necmettin Erbakan Cad. 33 Sok. No:71, Şehitkamil', 200, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-GZT-002', 27, 'EFAPM22', 37.0921, 37.3999, 0, 1, 'Merveşehir Mah. Şehit Ömer Halis Demir Bulvarı No: 107, Şehitkamil', 20, 1440, '08:30,18:00;1,5|08:30,15:00;6,7'),
('TR-GZT-004', 27, 'STCTIT120SS', 37.1862, 37.2735, 1, 1, 'Aktoprak Mah. Kahramanmaraş Cad. No:70, Şehitkamil', 6, 1440, '08:00,18:00;1,5|08:00,13:15;6,6'),
('TR-GZT-005', 27, 'STCTIT120SS', 37.1862, 37.2737, 1, 1, 'Aktoprak Mah. Kahramanmaraş Cad. No:70, Şehitkamil', 6, 1440, '08:00,18:00;1,5|08:00,13:15;6,6'),
('TR-HKR-001', 30, 'ABBTER22', 37.258, 43.5848, 0, 1, 'Emirşaban, Çukurca Yolu,  Narlı/Çukurca', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-HTY-003', 31, 'EFAPM22', 36.5933, 36.1597, 1, 0, 'Atatürk Bulvarı No: 97/1 İskenderun', 1000, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-HTY-004', 31, 'STCTIT120SS', 36.5703, 36.157, 1, 1, 'Mustafa Kemal Mah. 575. Sk. No:18, İskenderun', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IGD-001', 76, 'ABBTER22', 39.9286, 44.0734, 1, 1, 'Sanayi Sitesi 13 B Blok No:1, Merkez', 2, 1440, '08:00,18:00;1,6|08:00,18:00;8,8'),
('TR-ISP-001', 32, 'STCTIT90SS', 37.798, 30.5778, 1, 1, 'Sanayi Mah. 104. Cad. No:97, Merkez', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ISP-002', 32, 'STCTIT120SS', 37.7742, 30.5491, 1, 1, 'Bahçelievler, 3035 Sok No:25-1,  Merkez', 45, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ISP-003', 32, 'STCTIT120SS', 37.7626, 30.6126, 1, 1, 'Savköy Beldesi Fatih Mah Isparta Antalya Asfaltı Blv. NO:85, Merkez', 0, 0, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ISP-004', 32, 'STCTIT120SS', 37.7818, 30.5456, 0, 1, 'Fatih, Ertokuş Cd. no:2/8,  Isparta Merkez', 400, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ISP-005', 32, 'STCTIT120SS', 37.7817, 30.5456, 0, 1, 'Fatih, Ertokuş Cd. no:2/8,  Isparta Merkez', 400, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ISP-006', 32, 'ABBTER22', 37.7817, 30.5456, 0, 1, 'Fatih, Ertokuş Cd. no:2/8,  Isparta Merkez', 400, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ISP-007', 32, 'ABBTER22', 37.7817, 30.5456, 0, 1, 'Fatih, Ertokuş Cd. no:2/8,  Isparta Merkez', 400, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ISP-008', 32, 'STCTIT120SS', 37.7983, 30.5385, 0, 1, 'Çünür Mh., D:167, Merkez, Süleyman Demirel Cd.,  Isparta Merkez', 200, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ISP-009', 32, 'STCTIT120SS', 37.7983, 30.5385, 0, 1, 'Çünür Mh., D:167, Merkez, Süleyman Demirel Cd.,  Isparta Merkez', 200, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ISP-010', 32, 'ABBTER22', 37.7983, 30.5385, 0, 1, 'Çünür Mh., D:167, Merkez, Süleyman Demirel Cd.,  Isparta Merkez', 200, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ISP-011', 32, 'ABBTER22', 37.7983, 30.5384, 0, 1, 'Çünür Mh., D:167, Merkez, Süleyman Demirel Cd.,  Isparta Merkez', 200, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-014', 34, 'EFANC222', 40.8895, 29.3799, 0, 1, 'Sabancı Üniversitesi, Orta Mahalle, Üniversite Caddesi, No:27, Tuzla', 20, 1440, '09:00,16:00;1,5'),
('TR-IST-015', 34, 'EFANC222', 41.0557, 28.667, 1, 1, 'Akbatı Alışveriş ve Yaşam Merkezi, Sanayi Mah. 1655 Sok. No:6, Esenyurt', 3000, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-IST-016', 34, 'EFAPM22', 40.9602, 28.8391, 0, 1, 'Yeşilyurt Mah. Sahil Yolu Cad. No:2, Bakırköy', 200, 0, '00:00,00:00;1,7'),
('TR-IST-020', 34, 'EFAQC50CSA', 41.0782, 29.0113, 1, 1, 'Kanyon Alışveriş Merkezi, Esentepe Mah. Büyükdere Caddesi, No:185, Esentepe, Şişli', 2300, 180, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-IST-025', 34, 'EFANC222', 40.9998, 29.0307, 1, 1, 'Acıbadem Mah. Fatih Cad. No:1, Kadıköy', 2700, 180, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-IST-026', 34, 'EFANC222', 40.9911, 28.7142, 1, 1, 'Üniversite Mah. Selvi Sok. No:25, E5 üzeri, Avcılar', 1300, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-IST-028', 34, 'EFANC222', 41.0542, 29.0002, 1, 0, 'Dikilitaş Mah., Hakkı Yeten Cad. Fulya, Beşiktaş', 300, 0, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-IST-031', 34, 'EFANC222', 41.0011, 29.0544, 1, 1, 'Ankara Devlet Yolu, Haydar Paşa Yönü, 4. km, Acıbadem Mah., Çeçen Sokak, Üsküdar', 3300, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-IST-037', 34, 'EFANC222', 41.064, 29.0025, 1, 0, 'Gayrettepe Mah., Girne Sok., No:1, Beşiktaş', 1500, 0, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-041', 34, 'EFANC222', 40.8658, 29.2753, 1, 1, 'Çamçeşme Mah., Fabrika Sok., No:5, Pendik', 1500, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-IST-042', 34, 'EFANC222', 41.0409, 29.0051, 1, 1, 'Sinanpaşa Mah, Hayrettin İskelesi Sok, No:1, Beşiktaş', 150, 180, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-043', 34, 'EFANC222', 41.0112, 28.8154, 1, 1, 'Köyaltı Mevkii Merkez Mah., Değirmenbahçe Cad., Kavak Sok., No:2, Yenibosna', 1700, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-IST-048', 34, 'EFANC222', 40.9173, 29.1788, 0, 1, 'E-5 Yanyol Pamukkale Sok. No: 2, Soğanlık, Kartal', 50, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-049', 34, 'EFANC222', 40.9553, 29.1181, 1, 0, 'Aydınevler Mah. İnönü cad. No:20 Küçükyalı, Maltepe', 1000, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-057B', 34, 'EFANC222', 41.0094, 29.1634, 0, 1, 'Yukarıdudullu Mah. Necip Fazıl Bulvarı No:22, Ümraniye', 10, 1440, '08:30,18:00;1,5|10:00,16:00;6,7'),
('TR-IST-062', 34, 'EFAQC50CSA', 41.0554, 28.6667, 0, 1, 'Akbatı Alışveriş ve Yaşam Merkezi, Sanayi Mah. 1655 Sok. No:6, Esenyurt', 3000, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-063', 34, 'EFAQC50CSA', 41.0586, 28.9657, 0, 1, 'Kaptanpaşa Mah. Darülcaze yanı No:274, Şişli', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-065', 34, 'EFANC222', 41.1083, 29.0077, 1, 1, 'Huzur Mah. Maslak-Ayazağa Cad. No:4, Ayazağa, Sarıyer', 1000, 30, '07:00,00:00;1,5|08:00,01:00;6,7'),
('TR-IST-066', 34, 'EFAQC50CSA', 41.0011, 29.0547, 1, 1, 'Ankara Devlet Yolu, Haydar Paşa Yönü, 4. km, Acıbadem Mah., Çeçen Sokak, Üsküdar', 3300, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-IST-067', 34, 'EFAQC50CSA', 41.0024, 28.8906, 0, 1, 'Osmaniye mah. E-5 Çırpıcı yanyol cad. No:1/3, Bakırköy', 100, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-074', 34, 'EFAPM7', 40.9611, 29.1121, 0, 1, 'İçerenköy Mah. Askent Sok. 3B D:3-6,  Ataşehir', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8');
INSERT INTO `istasyonlar` (`istasyon_kodu`, `plaka`, `model_kodu`, `lat`, `lng`, `lokasyon_tipi`, `aktiflik`, `adres`, `otopark`, `park_suresi`, `hizmet_saati`) VALUES
('TR-IST-076', 34, 'EFAPM22', 41.0819, 29.0091, 1, 0, 'Esentepe Mah. Büyükdere Caddesi No:209 4.Levent, Şişli', 30, 0, '07:30,17:30;1,5'),
('TR-IST-077', 34, 'EFAPM22', 41.0819, 29.009, 1, 1, 'Esentepe Mah. Büyükdere Caddesi No:209 4.Levent, Şişli', 30, 0, '07:30,17:30;1,5'),
('TR-IST-078', 34, 'EFAPM22', 41.0819, 29.009, 1, 1, 'Esentepe Mah. Büyükdere Caddesi No:209 4.Levent, Şişli', 30, 0, '07:30,17:30;1,5'),
('TR-IST-081', 34, 'EFAPM22', 41.0312, 28.9742, 0, 1, 'Asmalı Mescit Mah., Meşrutiyet Cad No:93, Tepebaşı', 100, 0, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-082', 34, 'EFANC222', 41.1087, 28.9876, 1, 1, 'Ayazağa Cad. Cendere Cad. 109/C, Sarıyer', 5500, 180, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-IST-085', 34, 'EFAQC24S', 40.9616, 29.1122, 0, 1, 'İçerenköy Mah. Askent Sok. 3B D:3-6,  Ataşehir', 20, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-IST-092', 34, 'EFAPM22', 41.0265, 29.1277, 1, 1, 'Fatih Sultan Mehmet Mah. Balkan Cad. No:56, Ümraniye', 2000, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-IST-094', 34, 'EFAPM22', 41.0782, 29.0113, 1, 1, 'Kanyon Alışveriş Merkezi, Esentepe Mah. Büyükdere Caddesi, No:185, Esentepe, Şişli', 2300, 180, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-IST-097', 34, 'EFAPM22', 41.0802, 29.0789, 0, 1, 'Anadolu hisarı mah. Göksu cad. No:1 Çavuşpaşa, Beykoz', 100, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-098', 34, 'EFAPM22', 41.2173, 29.0324, 0, 1, 'Uskumruköy 1. Cadde No:9/A, Sarıyer', 100, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-099', 34, 'EFAPM22', 41.1177, 29.0494, 0, 1, 'İstinye Mah, Çayır Cd. No: 1, İstinye, Sarıyer', 100, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-100', 34, 'EFAPM22', 41.0058, 29.1576, 0, 0, 'Anadolu Yakası, Yukarı Dudullu 1.Cad, Dudullu, Ümraniye', 100, 1440, '07:00,20:00;1,7|07:00,20:00;8,8'),
('TR-IST-101', 34, 'EFANC222', 40.9775, 29.097, 0, 1, '19 Mayıs Mah. İnönü cad. No: 101/1, Kadıköy ', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-102', 34, 'EFAQC50CSA', 40.9675, 29.1028, 0, 1, 'Kozyatağı Mah. Ankara Asfaltı E5 Yan Yol Üzeri Hüseyin Çelik Sok. No:2 Bostancı, Kadıköy', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-103', 34, 'EFAQC24S', 41.0393, 28.9669, 0, 1, 'Kaptanpaşa, Piyalepaşa Blv. No:3/1, Beyoğlu', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-104', 34, 'EFAQC50CSA', 40.9812, 29.214, 0, 1, 'Eyüp Sultan Mah. Yadigar Sokak No:38, Sancaktepe', 40, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-107', 34, 'EFAQC50CSA', 41.0048, 29.0355, 0, 1, 'Koşuyolu Mah. Ali Dede Sok. No:2, Kadıköy', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-109', 34, 'EFANC222', 40.9786, 29.022, 0, 1, 'Moda Cad. Ferit Tek Sok. No:1, Moda, Kadıköy', 2, 1440, '10:00,20:00;1,5|09:00,02:00;6,7'),
('TR-IST-110', 34, 'EFAQC50CSA', 41.0023, 28.6889, 0, 1, 'Turgut Özal Mah. 70. Sok. No:46, Esenyurt', 2, 1440, '08:30,18:00;1,6'),
('TR-IST-112', 34, 'EFAQC50CSA', 40.9866, 28.791, 0, 1, 'İstanbul-Edirne Asfaltı Şenlikköy Mah. Akasya Sokak No:22, Florya', 2, 1440, '08:30,18:00;1,6'),
('TR-IST-114', 34, 'EFAQC50CSA', 40.9712, 29.0613, 0, 1, 'Bağdat cad. No:243/A, Göztepe', 1, 1440, '09:30,20:00;1,5'),
('TR-IST-118', 34, 'EFAQC50SA', 41.021, 28.9023, 0, 1, 'Topkapı Mahallesi, Davutpaşa Caddesi No:40, Zeytinburnu', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-119', 34, 'EFAQC50SA', 41.021, 28.9023, 0, 1, 'Topkapı Mahallesi, Davutpaşa Caddesi No:40, Zeytinburnu', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-120', 34, 'EFAQC50SA', 40.9612, 29.1099, 0, 1, 'İçerenköy Mah. Değirmen Yolu Cd. No:28, Ataşehir', 10, 1440, '08:00,18:30;1,6'),
('TR-IST-121', 34, 'EFAQC50SA', 41.0814, 29.0346, 0, 0, 'Etiler Mah. Ahular Sok. No:10, Beşiktaş', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-126', 34, 'EFAQC20CSA', 41.0822, 28.6281, 0, 1, 'Akçaburgaz Mah. Halil Fahri Orman Caddesi No:3 D:1, Esenyurt', 5, 1440, '08:00,19:00;1,5|08:00,17:00;6,7|08:00,17'),
('TR-IST-133', 34, 'ABBTER22', 41.1207, 29.049, 0, 1, 'İstinye Mah. Sarıyer Caddesi No.68, Sarıyer', 60, 1440, '08:30,18:00;1,6'),
('TR-IST-135', 34, 'ABBTER22', 41.0222, 29.0401, 0, 1, 'Altunizade Mah. Mahir İz Cad. No: 19/1 4, Üsküdar', 10, 1440, '08:30,18:00;1,6|10:00,17:00;7,7'),
('TR-IST-138', 34, 'ABBTER22', 41.0808, 28.9294, 0, 1, 'Akşemsettin Mah. Cengiz Topel Cad. No:1/A, Eyüpsultan', 15, 30, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-139', 34, 'ABBTER22', 41.081, 28.9297, 0, 1, 'Akşemsettin Mah. Cengiz Topel Cad. No:1/A, Eyüpsultan', 15, 30, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-140', 34, 'STCJUP60SCA', 41.0096, 28.6599, 1, 1, 'Mevlana Mah. Çelebi Mehmet Cad. No:33/A, Esenyurt', 2237, 1440, '10:00,22:00;1,7'),
('TR-IST-142', 34, 'STCTIT180SS', 41.0022, 29.055, 1, 1, 'Ankara Devlet Yolu, Haydar Paşa Yönü, 4. km, Acıbadem Mh., Çeçen Sk., Üsküdar', 3300, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-IST-147', 34, 'STCVEN30S', 41.0838, 29.3295, 0, 1, 'Ömerli, Kadirova Cd. No:1/1,  Çekmeköy', 60, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-148', 34, 'STCVEN30S', 41.0886, 28.9829, 0, 1, 'Hamidiye Mah. Cendere Cad. No:15, Kağıthane', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-149', 34, 'STCTIT150SS', 41.0397, 28.9922, 0, 1, 'Askerocağı caddesi No:6. Elmadağ, Süzer Plaza, Şişli', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-150', 34, 'STCTIT150SS', 41.0265, 29.1274, 1, 1, 'Fatih Sultan Mehmet Mah. Balkan Cad. No:56, Ümraniye', 2000, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-IST-152', 34, 'STCTIT120SS', 40.9865, 29.1008, 1, 1, 'Palladium Alışveriş Merkezi, Barbaros Mah. Halk Cad. No:8-B, Ataşehir', 2500, 1440, '09:00,22:00;1,7|09:00,22:00;8,8'),
('TR-IST-153', 34, 'ABBTER22', 41.0814, 28.93, 0, 1, 'Akşemsettin Mah. Cengiz Topel Cad. No:1/A, Eyüpsultan', 15, 30, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-154', 34, 'ABBTER22', 41.0817, 28.9303, 0, 1, 'Akşemsettin Mah. Cengiz Topel Cad. No:1/A, Eyüpsultan', 15, 30, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-155', 34, 'STCTIT120SS', 41.0151, 28.5523, 0, 1, 'Mimarsinan Merkez Mh. E5 Londra Asfaltı Cd. No:55/A, Büyükçekmece', 26, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-156', 34, 'STCTIT120SS', 41.1096, 28.9891, 0, 1, 'Ayazağa Mah. Kemerburgaz Cad. No: 2/1, Sarıyer', 20, 1440, '08:00,18:00;1,5|09:00,17:00;6,6'),
('TR-IST-158', 34, 'STCTIT120SS', 41.1394, 29.0569, 1, 1, 'Haydar Aliyev Cad., No:154, Tarabya, Sarıyer', 500, 180, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-159', 34, 'STCTIT120SS', 40.9027, 29.216, 0, 1, 'Topselvi Mah. D-100 Karayolu Güney Yan Yol No:10, Kartal', 8, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-160', 34, 'STCTIT120SS', 41.0113, 28.8154, 1, 1, 'Köyaltı Mevkii Merkez Mah., Değirmenbahçe Cad., Kavak Sok., No:2, Yenibosna', 1700, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-IST-161', 34, 'STCTIT120SS', 41.0207, 28.8127, 0, 1, 'Yenibosna Merkez Mah. Çınar Cd. No: 16C, Bahçelievler', 2, 1440, '08:30,18:30;1,6'),
('TR-IST-162', 34, 'STCTIT120SS', 41.0141, 29.1874, 0, 1, 'Madenler Mah. Serencebey Cad. No:40/2, Ümraniye ', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-163', 34, 'STCTIT120SS', 40.9872, 29.2013, 0, 1, 'Eyüp Sultan Mah. Gülibrişim Sk. No:6, Sancaktepe', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-164', 34, 'STCTIT120SS', 41.0136, 29.1978, 0, 1, 'Meclis Mah. Semih Sancar Cad. No:89, Sancaktepe', 10, 1440, '08:00,19:00;1,7|08:00,19:00;8,8'),
('TR-IST-165', 34, 'STCTIT120SS', 41.0137, 29.1979, 0, 1, 'Meclis Mah. Semih Sancar Cad. No:89, Sancaktepe', 10, 1440, '08:00,19:00;1,7|08:00,19:00;8,8'),
('TR-IST-166', 34, 'STCTIT120SS', 40.9005, 29.2192, 0, 0, 'Yalı Mah. Topselvi D-100 Güney Yanyol Cad. No:18/B, Kartal', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-167', 34, 'STCTIT120SS', 41.0099, 28.6602, 1, 1, 'Mevlana Mah. Çelebi Mehmet Cad. No:33/A, Esenyurt', 2237, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-IST-168', 34, 'STCTIT120SS', 41.0594, 29.0102, 1, 1, 'Gayrettepe mahallesi Barboros bulvarı no:145 ', 80, 120, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-169', 34, 'STCTIT90SS', 41.1612, 28.4544, 0, 1, 'Kaleiçi Mah. Gökçeali Cad. No:1, Çatalca', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-171', 34, 'STCTIT150SS', 41.0266, 29.1278, 1, 1, 'Fatih Sultan Mehmet Mah. Balkan Cad. No:56, Ümraniye', 2000, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-IST-172', 34, 'STCTIT150SS', 41.0266, 29.1277, 1, 1, 'Fatih Sultan Mehmet Mah. Balkan Cad. No:56, Ümraniye', 2000, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-IST-173', 34, 'STCVEN30S', 41.0556, 28.8735, 1, 1, 'Havaalanı Mah. Mehmet Akif İnan Cad. No:67, Esenler', 1, 1440, '08:30,18:00;1,6'),
('TR-IST-175', 34, 'STCTIT120SS', 41.1363, 29.0435, 0, 1, 'Tarabya Mah. Tarabya Bayırı Cad. No: 42, Sarıyer ', 16, 0, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-176', 34, 'STCTIT120SS', 41.1363, 29.0434, 0, 0, 'Tarabya Mah. Tarabya Bayırı Cad. No: 42, Sarıyer ', 16, 0, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-178', 34, 'STCTIT120SS', 40.9659, 29.0708, 1, 1, 'Caddebostan Mah. Bağdat Cad. No:319-321A, Kadıköy', 320, 30, '10:00,23:59;1,7|10:00,23:59;8,8'),
('TR-IST-179', 34, 'STCTIT120SS', 40.9885, 28.909, 1, 1, 'Kazlıçeşme Mah. Abay Cad. No:62, Zeytinburnu', 5, 1440, '09:00,18:00;1,5|09:00,17:00;6,8'),
('TR-IST-180', 34, 'STCTIT120SS', 40.9658, 29.2159, 1, 1, 'Fatih Mah. Yakacık Cad. No:33, Sancaktepe', 0, 0, '09:30,19:00;1,5|10:00,18:00;6,6|11:00,17'),
('TR-IST-181', 34, 'STCTIT120SS', 40.9714, 29.0616, 1, 0, 'Bağdat cad. No:243/A Göztepe', 1, 1440, '09:30,20:00;1,5'),
('TR-IST-182', 34, 'ABBTER22', 41.0439, 28.9358, 1, 1, 'Nişancı Mah. Zalpaşa Cad. No:52/1, Eyüpsultan', 15, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-183', 34, 'ABBTER22', 41.0438, 28.9358, 1, 1, 'Nişancı Mah. Zalpaşa Cad. No:52/1, Eyüpsultan', 15, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-184', 34, 'STCTIT120SS', 40.8722, 29.2515, 1, 1, 'Kaynarca, Erol Kaya Cd No:204, Pendik', 1000, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-185', 34, 'STCTIT150SS', 41.0554, 28.668, 1, 1, 'Akbatı Alışveriş ve Yaşam Merkezi, Sanayi Mah. 1655 Sok. No:6, Esenyurt', 3000, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-186', 34, 'STCTIT150SS', 41.0554, 28.6679, 1, 1, 'Akbatı Alışveriş ve Yaşam Merkezi, Sanayi Mah. 1655 Sok. No:6, Esenyurt', 3000, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-187', 34, 'STCTIT150SS', 41.0559, 28.6677, 1, 1, 'Akbatı Alışveriş ve Yaşam Merkezi, Sanayi Mah. 1655 Sok. No:6, Esenyurt', 3000, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-IST-188', 34, 'STCTIT120SS', 40.9173, 29.158, 1, 1, 'Cevizli Mah. Tugay Yolu Cad. No:59, Maltepe', 2, 1440, '08:00,18:00;1,5|08:00,16:00;6,6'),
('TR-IST-189', 34, 'STCTIT120SS', 41.0747, 28.2608, 1, 1, 'Yeni Mah. General Ali İhsan Türkkan Cd. No:31, Silivri', 10, 1440, '09:00,17:00;1,5|09:00,15:00;6,6'),
('TR-IST-190', 34, 'STCTIT120SS', 41.0024, 28.8915, 1, 1, 'Osmaniye mah. E-5 Çırpıcı yanyol cad. No:1/3', 100, 1440, '08:30,18:00;1,5|10:00,16:00;6,7'),
('TR-IST-191', 34, 'STCTIT120SS', 40.9884, 29.0831, 1, 1, 'Sahrayıcedit Mah. Batman Sokak 30/20, Kadıköy', 2, 1440, '08:30,18:00;1,6|11:00,17:00;7,8'),
('TR-IST-192', 34, 'STCTIT150SS', 41.0018, 29.0552, 1, 1, 'Ankara Devlet Yolu, Haydar Paşa Yönü, 4. km, Acıbadem Mah., Çeçen Sokak, Üsküdar', 3300, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-IST-193', 34, 'STCTIT150SS', 41.0019, 29.0551, 1, 1, 'Ankara Devlet Yolu, Haydar Paşa Yönü, 4. km, Acıbadem Mah., Çeçen Sokak, Üsküdar', 3300, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-IST-194', 34, 'STCTIT120SS', 41.0681, 28.3145, 1, 0, 'Kavaklı Mah, Selanik Cad. No:25, Silivri', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-195', 34, 'STCTIT90SS', 41.0274, 29.2364, 1, 1, 'Ekşioğlu mah. Ulusal Cad. No:1, Çekmeköy', 4, 1440, '09:00,18:00;1,7|09:00,18:00;8,8'),
('TR-IST-196', 34, 'STCTIT120SS', 40.9868, 28.7909, 1, 1, 'İstanbul-Edirne Asfaltı Şenlikköy Mah. Akasya Sokak No:22, Florya', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-197', 34, 'STCTIT120SS', 40.9918, 29.1521, 1, 1, 'Yeni Çamlıca, Bostancı Yolu Cad No:13,Ataşehir', 100, 1440, '08:30,23:59;1,7|08:30,23:59;8,8'),
('TR-IST-198', 34, 'STCTIT120SS', 40.966, 29.1106, 1, 1, 'İçerenköy Mah, Ertaç Sk No:16,  Ataşehir', 90, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-200', 34, 'STCTIT120SS', 41.0229, 28.9022, 1, 1, 'Topkapı Mahallesi, Davutpaşa Caddesi No:40, Zeytinburnu', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-201', 34, 'STCTIT120SS', 41.0229, 28.9023, 1, 1, 'Topkapı Mahallesi, Davutpaşa Caddesi No:40, Zeytinburnu', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-202', 34, 'ABBTER22', 41.0694, 29.0045, 1, 0, 'Esentepe Mah. Salih Tozan Sk. No:14/1, Şişli', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-203', 34, 'STCTIT120SS', 40.8894, 29.3776, 1, 1, 'Sabancı Üniversitesi, Orta Mahalle, Üniversite Caddesi, No:27, Tuzla', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-204', 34, 'STCTIT120SS', 40.8894, 29.3775, 1, 1, 'Sabancı Üniversitesi, Orta Mahalle, Üniversite Caddesi, No:27, Tuzla', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-205', 34, 'STCTIT120SS', 41.1398, 29.0563, 1, 1, 'Haydar Aliyev Cad., No:154, Tarabya, Sarıyer', 500, 180, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-206', 34, 'STCTIT120SS', 40.9608, 29.1103, 1, 1, 'İçerenköy Mah. Değirmen Yolu Cd. No:28, Ataşehir', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-207', 34, 'ABBTER22', 41.0014, 29.054, 1, 1, 'Ankara Devlet Yolu, Haydar Paşa Yönü, 4. km, Acıbadem Mah., Çeçen Sokak, Üsküdar', 3300, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-208', 34, 'STCTIT120SS', 40.9857, 29.1006, 1, 1, 'Palladium Alışveriş Merkezi, Barbaros Mah. Halk Cad. No:8-B, Ataşehir', 2500, 1440, '09:00,22:00;1,7|09:00,22:00;8,8'),
('TR-IST-209', 34, 'STCTIT120SS', 41.0362, 28.9863, 1, 1, 'The Marmara Taksim, Taksim Meydanı, Beyoğlu', 120, 0, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-210', 34, 'STCTIT120SS', 40.9268, 29.3118, 1, 1, 'Yenişehir, Osmanlı Blv. No:4,  Pendik', 900, 90, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-211', 34, 'STCTIT120SS', 40.9268, 29.3148, 1, 1, 'Yenişehir, Osmanlı Blv. No:4,  Pendik', 900, 90, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-212', 34, 'STCTIT120SS', 40.9934, 28.9189, 1, 1, 'Kazlıçeşme, Prof. Muammer Aksoy Cad. No:3,  Zeytinburnu', 50, 1440, '10:00,18:00;1,6|10:00,13:00;7,8'),
('TR-IST-217', 34, 'STCTIT120SS', 40.9283, 29.3088, 1, 1, 'Kurtköy, Yenişehir Mah. Osmanlı Blv. NO:5/A, Pendik', 63, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-220', 34, 'STCSAT222', 41.1398, 29.0563, 1, 1, 'Haydar Aliyev Cad., No:154, Tarabya, Sarıyer', 500, 180, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-221', 34, 'STCTIT120SS', 40.9181, 29.348, 1, 1, 'Fatih, Katip Çelebi Caddesi No:47,  Tuzla', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-222', 34, 'STCTIT120SS', 40.9184, 29.3481, 1, 1, 'Fatih, Katip Çelebi Caddesi No:47,  Tuzla', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-223', 34, 'STCTIT90SS', 41.0576, 29.0657, 1, 1, 'Küçüksu Mah. No:17/1-2 Üsküdar İstanbul, Kaldırım Cd.,  Üsküdar', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-224', 34, 'STCTIT120SS', 41.0139, 29.0261, 1, 1, 'Barbaros, Nuhkuyusu Cd No:6,  Üsküdar', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-225', 34, 'STCTIT120SS', 41.0121, 28.8101, 1, 1, 'Yenibosna Merkez mah. 1 Emlak Asena Sokak No:9, Bahçelievler', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-226', 34, 'STCTIT120SS', 40.8775, 29.3944, 1, 1, 'Aydınlı Birlik OSB Mah. 1 Nolu Cadde No:26, Tuzla', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-227', 34, 'STCTIT120SS', 40.8774, 29.3944, 1, 1, 'Aydınlı Birlik OSB Mah. 1 Nolu Cadde No:26, Tuzla', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-228', 34, 'STCTIT120SS', 41.0988, 29.0061, 1, 1, 'Huzur Mah. Çamlıklar Cad. No:2/2 Sarıyer', 2, 1440, '08:30,18:30;1,5|08:30,14:00;6,6'),
('TR-IST-229', 34, 'STCTIT120SS', 40.9728, 28.8043, 1, 0, 'Şenlikköy Mah. Harman Sok. No:48, Florya', 700, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-IST-230', 34, 'STCTIT120SS', 40.9728, 28.8042, 1, 0, 'Şenlikköy Mah. Harman Sok. No:48, Florya', 700, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-IST-231', 34, 'STCTIT120SS', 41.0585, 28.9794, 1, 1, 'Silahşör Cad. No:42, Bomonti, Şişli', 680, 0, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-233', 34, 'STCTIT120SS', 40.9158, 29.1539, 1, 1, 'Cevizli, Zuhal Cd. No:2, Maltepe', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-234', 34, 'STCVEN30S', 40.983, 29.076, 1, 1, 'Sahrayı Cedit, İmam Ramiz Sokağı No: 35-37,  Kadıköy', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-235', 34, 'STCTIT120SS', 41.2176, 29.0327, 0, 1, 'Uskumruköy 1. Cadde No:9/A, Sarıyer', 100, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-237', 34, 'STCTIT90SS', 41.1612, 28.4545, 0, 1, 'Kaleiçi Mah. Gökçeali Cad. No:1, Çatalca', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-238', 34, 'STCTIT150SS', 41.1026, 28.9728, 0, 1, 'Hamidiye Mah. Selçuklu Caddesi No:10 D:H, Kağıthane', 1, 1440, '08:30,18:00;1,6|11:00,17:00;7,7'),
('TR-IST-239', 34, 'STCTIT90SS', 40.9092, 29.3581, 0, 1, 'Orhanlı, Katip Çelebi Cd No:33,  Tuzla', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-240', 34, 'STCTIT120SS', 40.9662, 28.7975, 1, 1, 'Şenliköy Mahallesi Yeşilköy Halkalı Caddesi NO:93-93/1 Florya /Bakırköy / istanbul', 1500, 1440, '07:00,00:00;1,7|07:00,00:00;8,8'),
('TR-IST-241', 34, 'ABBTER22', 40.9664, 28.7975, 1, 1, 'Şenliköy Mahallesi Yeşilköy Halkalı Caddesi NO:93-93/1 Florya /Bakırköy / istanbul', 1500, 1440, '07:00,00:00;1,7|07:00,00:00;8,8'),
('TR-IST-242', 34, 'STCTIT120SS', 40.9653, 28.799, 0, 1, 'Şenliköy Mahallesi Yeşilköy Halkalı Caddesi NO:93-93/1 Florya /Bakırköy / istanbul', 1500, 1440, '07:00,00:00;1,7|07:00,00:00;8,8'),
('TR-IST-243', 34, 'ABBTER22', 40.9655, 28.799, 0, 1, 'Şenliköy Mahallesi Yeşilköy Halkalı Caddesi NO:93-93/1 Florya /Bakırköy / istanbul', 1500, 1440, '07:00,00:00;1,7|07:00,00:00;8,8'),
('TR-IST-244', 34, 'STCTIT120SS', 40.991, 28.7147, 1, 1, 'Üniversite Mah. Selvi Sok. No:25, E5 üzeri, Avcılar', 1300, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-IST-245', 34, 'STCTIT120SS', 41.007, 29.0722, 0, 1, 'Bulgurlu, Libadiye Cd. No:5,  Üsküdar', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-246', 34, 'STCTIT180SS', 41.167, 29.5648, 0, 1, 'Meşrutiyet Mahallesi. Baloğlu Sokak No:28/D, Şile', 15, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-247', 34, 'STCTIT120SS', 41.0813, 29.0347, 0, 1, 'Etiler Mah. Ahular Sok. No:10, Beşiktaş', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-248', 34, 'STCTIT120SS', 41.1942, 28.7603, 0, 1, 'Atatürk, Atatürk Mahallesi Yıldırım Beyazıt Caddesi, Mahir Sk. No: 18,  Arnavutköy', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-249', 34, 'STCTIT180SS', 40.8692, 29.2706, 0, 1, 'Çamçeşme, Tevfik İleri Cd No:209,  Pendik', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-250', 34, 'ABBTER22', 40.8693, 29.271, 1, 1, 'Çamçeşme, Tevfik İleri Cd No:209,  Pendik', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-251', 34, 'ABBTER22', 40.8694, 29.271, 1, 1, 'Çamçeşme, Tevfik İleri Cd No:209,  Pendik', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-252', 34, 'ABBTER22', 40.8694, 29.271, 1, 1, 'Çamçeşme, Tevfik İleri Cd No:209,  Pendik', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-253', 34, 'STCTIT120SS', 40.8845, 29.3897, 0, 1, 'Aydınlı İstanbul AYOSB Mahallesi 5. Sokak No:2  Tuzla ', 1000, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-255', 34, 'STCTIT120SS', 41.0266, 29.2325, 0, 1, 'Soğukpınar, Adnan Menderes Caddesi 40/A,  Çekmeköy/İstanbul', 50, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-256', 34, 'ABBTER22', 41.0585, 28.9794, 1, 1, 'Silahşör Cad. No:42, Bomonti, Şişli', 680, 0, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-257', 34, 'STCTIT120SS', 40.9643, 28.8007, 1, 1, 'Şenliköy Mahallesi Yeşilköy Halkalı Caddesi NO:93-93/1 Florya /Bakırköy / istanbul', 1500, 1440, '07:00,00:00;1,7|07:00,00:00;8,8'),
('TR-IST-258', 34, 'ABBTER22', 40.9643, 28.8007, 1, 1, 'Şenliköy Mahallesi Yeşilköy Halkalı Caddesi NO:93-93/1 Florya /Bakırköy / istanbul', 1500, 1440, '07:00,00:00;1,7|07:00,00:00;8,8'),
('TR-IST-259', 34, 'STCTIT120SS', 40.9639, 28.8009, 0, 1, 'Şenliköy Mahallesi Yeşilköy Halkalı Caddesi NO:93-93/1 Florya /Bakırköy / istanbul', 1500, 1440, '07:00,00:00;1,7|07:00,00:00;8,8'),
('TR-IST-260', 34, 'ABBTER22', 40.964, 28.8009, 0, 1, 'Şenliköy Mahallesi Yeşilköy Halkalı Caddesi NO:93-93/1 Florya /Bakırköy / istanbul', 1500, 1440, '07:00,00:00;1,7|07:00,00:00;8,8'),
('TR-IST-261', 34, 'STCTIT120SS', 41.0801, 29.0793, 0, 1, 'Anadolu hisarı mah. Göksu cad. No:1 Çavuşpaşa, Beykoz', 100, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IST-262', 34, 'STCTIT120SS', 41.0801, 29.0794, 0, 1, 'Anadolu hisarı mah. Göksu cad. No:1 Çavuşpaşa, Beykoz', 100, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IZM-002', 35, 'EFANC222', 38.4747, 27.075, 1, 1, 'Mavişehir Mah. Cahey Dudayev Blv., Karşıyaka', 700, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IZM-005', 35, 'EFAPM22', 38.4383, 27.1613, 0, 1, 'Umurbey mh. Şehitler cd. No:149 Alsancak, Konak', 30, 1440, '08:30,18:00;1,5|10:00,16:00;6,7'),
('TR-IZM-007', 35, 'EFAQC50SA', 38.4538, 27.1972, 0, 1, 'Kazımdirik Mah. Üniversite Caddesi No:66, Bornova', 10, 1440, '08:30,18:00;1,5|09:00,16:00;6,6'),
('TR-IZM-010', 35, 'EFAQC50CSA', 38.4683, 27.1134, 0, 1, 'Anadolu Caddesi No:325, Karşıyaka', 15, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IZM-011', 35, 'EFANC222', 38.4468, 27.1756, 1, 1, 'Çınarlı Mah. Ozan Abay Cad. No: 8, Konak', 150, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-IZM-019', 35, 'EFAPM22', 38.6843, 26.7404, 0, 1, 'İsmetpaşa, Mersinaki Cad., 362. Sok. No:4', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IZM-024', 35, 'EFAQC50CSA', 38.4562, 27.1698, 0, 1, 'Adalet Mah. Ozan Abay Cad. No:66, Bayraklı', 4, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IZM-027', 35, 'STCJUP60SCA', 38.4991, 27.0472, 0, 1, 'Küçük Çiğli Mah. 8780/1 Sok. 13 Ata San. Sit, Çiğli', 3, 1440, '00:00,00:00;1,6|10:00,17:00;7,7|00:00,00'),
('TR-IZM-028', 35, 'STCJUP60SCA', 38.3213, 27.1378, 0, 1, 'Dokuz Eylül Mah. Akçay Cd. NO:219, Gaziemir', 3, 1440, '08:00,20:00;1,5|08:00,19:00;6,6|10:00,17'),
('TR-IZM-029', 35, 'STCJUP60SCA', 38.4781, 27.0966, 0, 0, 'Cumhuriyet Mah Anadolu Cd. No: 546/A,  Karşıyaka', 3, 1440, '08:00,20:00;1,5|08:00,19:00;6,6|10:00,17'),
('TR-IZM-030', 35, 'STCTIT120SS', 38.4398, 27.2684, 0, 1, 'Kemalpaşa Mah., Çanakkale Cd. No:61, Bornova', 15, 1440, '00:00,00:00;1,7'),
('TR-IZM-031', 35, 'STCTIT120SS', 38.4566, 27.2535, 0, 1, 'Doğanlar Mahallesi, Ankara Cd. No:210/B, Bornova', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IZM-032', 35, 'STCTIT90SS', 38.3204, 26.7544, 1, 1, 'Altıntaş Mah. A.Besim Uyal Cad. No:75/77,Urla', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IZM-033', 35, 'STCTIT90SS', 38.3598, 27.1361, 1, 1, 'Emrez Mh. Akçay Cad. No:16/A, Gaziemir', 2, 1440, '09:00,18:00;1,5|09:00,17:00;6,6|11:00,17'),
('TR-IZM-034', 35, 'STCTIT180SS', 38.2966, 27.1399, 1, 1, 'Sevgi Mah. Menderes Cad. No:16, Gaziemir', 5, 1440, '08:30,18:30;1,5|09:00,17:00;6,6'),
('TR-IZM-035', 35, 'STCTIT150SS', 38.1773, 26.8314, 1, 1, 'Tepecik Mah Kuşadası Cd. No:79,  Seferihisar', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IZM-036', 35, 'STCTIT120SS', 38.4375, 27.1603, 1, 1, 'Umurbey Mh. Şehitler Cd. No:149 Alsancak, Konak', 30, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IZM-037', 35, 'STCTIT120SS', 38.4514, 27.1702, 1, 1, 'Adalet Mah. Anadolu Cad. No:29, Bayraklı ', 50, 1440, '07:00,21:00;1,7|07:00,21:00;8,8'),
('TR-IZM-038', 35, 'STCTIT120SS', 38.6168, 27.0657, 1, 1, 'Ulus Mah. Çanakkale Asfaltı Cad. No:9, Menemen', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IZM-040', 35, 'STCTIT120SS', 38.4598, 27.3934, 1, 1, 'Kemalpaşa OSB Mah. Ankara Yolu Cad. No362/2, Kemalpaşa', 4, 1440, '08:45,18:20;1,6'),
('TR-IZM-041', 35, 'STCTIT90SS', 38.3118, 27.142, 1, 1, 'Gazikent Mah Akçay Cd. No:330/A,  Gaziemir', 25, 1440, '08:00,22:00;1,7|08:00,22:00;8,8'),
('TR-IZM-042', 35, 'STCTIT120SS', 38.3284, 26.3127, 1, 1, 'Sakarya Mah. 2001 Sok. No: 119/S, Çeşme', 50, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IZM-043', 35, 'STCTIT120SS', 38.3077, 27.143, 1, 1, '9 Eylül Mah, Akçay Cd. 698 Sokak D:No:2,  Gaziemir', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IZM-044', 35, 'STCTIT120SS', 38.3202, 27.1383, 1, 1, 'Dokuz Eylül, Akçay Cd. NO:233 Gaziemir', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IZM-045', 35, 'STCTIT120SS', 37.9204, 27.282, 1, 1, 'Pamucak Mah. Oteller Bölgesi,  Selçuk', 100, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IZM-046', 35, 'STCTIT120SS', 38.4729, 27.3601, 1, 1, 'Cumhuriyet Mah. 9081 Sk. No:55, Ulucak, Kemalpaşa', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IZM-047', 35, 'STCTIT180SS', 39.0778, 27.1183, 1, 1, 'Fatih mahallesi İzmir Çanakkale yolu üzeri no:1100/2,  Bergama', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IZM-048', 35, 'STCSAT222', 39.0778, 27.1185, 1, 1, 'Fatih mahallesi İzmir Çanakkale yolu üzeri no:1100/2,  Bergama', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IZM-051', 35, 'STCTIT120SS', 38.3059, 26.3684, 1, 1, 'Celal Bayar, 5152. Sk. No: 43,  Çeşme', 200, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IZM-052', 35, 'ABBTER22', 38.3059, 26.3684, 1, 1, 'Celal Bayar, 5152. Sk. No: 43,  Çeşme', 200, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-IZM-053', 35, 'ABBTER22', 38.3059, 26.3687, 1, 1, 'Celal Bayar, 5152. Sk. No: 43,  Çeşme', 200, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KIR-001', 40, 'STCTIT120SS', 39.1202, 34.1961, 1, 1, 'Kındam Mah. Ankara Kayseri Cad. No:8, Merkez', 15, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KIR-002', 40, 'STCTIT90SS', 39.0663, 34.371, 0, 1, 'Solaklı, Fevzi Çakmak Cd. No:3,  Mucur', 50, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KMR-001', 46, 'STCTIT90SS', 37.5617, 36.9542, 1, 0, 'Mehmet Akif Ersoy Mah. Recep Tayyip Erdoğan Blv. No:118/A, Dulkadiroğlu', 10, 1440, '08:30,18:10;1,5|08:30,13:00;6,6'),
('TR-KMR-002', 46, 'STCTIT90SS', 37.5409, 36.9758, 1, 1, 'Erkenez Recep Tayyip Erdoğan Bulvarı No:135 D:a,  Dulkadiroğlu', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KMR-005', 46, 'STCTIT120SS', 37.5649, 36.9, 0, 1, 'Barbaros Mah. Kayseri Kara Yolu 2. Km.,  Onikişubat', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KMR-006', 46, 'STCTIT120SS', 37.5648, 36.9, 0, 1, 'Barbaros Mah. Kayseri Kara Yolu 2. Km.,  Onikişubat', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KMR-007', 46, 'ABBTER22', 37.5648, 36.9001, 0, 1, 'Barbaros Mah. Kayseri Kara Yolu 2. Km.,  Onikişubat', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KMR-008', 46, 'ABBTER22', 37.5647, 36.9001, 0, 1, 'Barbaros Mah. Kayseri Kara Yolu 2. Km.,  Onikişubat', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KOC-006', 41, 'EFAPM22', 40.7869, 29.4171, 0, 1, 'İstasyon, 1460. Sok. No: 1, Gebze', 50, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KOC-009', 41, 'EFANC222', 40.773, 29.9686, 0, 1, 'Yenişehir mah. Araç sok. no:55, Bekirpaşa', 15, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KOC-010', 41, 'EFAPM22', 40.8681, 29.3795, 0, 1, 'Cumhuriyet Mah.Özgürlük Cad. No:11/A, Çayırova', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KOC-011', 41, 'EFAQC50CSA', 40.7281, 30.072, 0, 1, 'Kınalı Sakarya Otoyolu, Tepetarla Mevkii, Kuzey Kısım, Kartepe', 200, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KOC-012', 41, 'EFAQC50CSA', 40.7276, 30.0683, 0, 1, 'Kınalı Sakarya Otoyolu, Tepetarla Mevkii, Güney Kısım, Kartepe', 200, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KOC-015', 41, 'EFAQC50SA', 40.7474, 30.0623, 0, 1, 'Emek Mahallesi, D100 Karayolu Cad, No:108, Kartepe', 15, 1440, '08:30,17:30;1,6'),
('TR-KOC-018', 41, 'STCJUP60SCA', 40.7584, 29.9784, 0, 1, 'Ovacık Mah. D-100 Karayolu Cd. No:28/B, Başiskele', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KOC-020', 41, 'STCTIT120SS', 40.7914, 29.4062, 0, 1, 'Köşklüçeşme Mah., 573 Sok. No:5, Gebze', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KOC-021', 41, 'STCTIT120SS', 40.7445, 29.9497, 0, 1, 'İzmit Sanayi Sit. 308. Blok No:161/63, İzmit', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KOC-022', 41, 'STCTIT90SS', 40.7481, 29.9578, 0, 1, 'Sanayi Mah. D-130 Karayolu Cad. No:159, İzmit', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KOC-023', 41, 'STCTIT120SS', 40.7368, 30.111, 1, 1, 'Uzuntarla, İbrikdere Mahallesi, Adapazarı İzmit Yolu, No:361 14.Km, Kartepe', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KOC-024', 41, 'STCTIT120SS', 41.124, 30.2017, 1, 1, 'Kıncılı Köyü, Yayla Mevkii, Kerpe Cad. No:13/A, Kandıra', 25, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KOC-025', 41, 'STCTIT120SS', 40.8013, 29.5264, 1, 1, 'Dilovası OSB Mah. D-400 Sk. No:7/1A, Gebze', 30, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KOC-026', 41, 'STCTIT90SS', 40.7949, 29.4353, 1, 1, 'Tatlıkuyu Mah. 1313/6. Sk. No:2/1, Gebze', 25, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KOC-027', 41, 'STCTIT120SS', 40.6539, 30.0966, 1, 1, 'Çepni Mah. Kartepe Cad. No:222/A, Kartepe', 1000, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KOC-028', 41, 'STCTIT120SS', 40.7964, 29.4429, 1, 1, 'Tatlıkuyu Mahallesi, Gebze Center AVM, Gebze', 1, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-KOC-029', 41, 'STCTIT120SS', 40.7964, 29.4428, 1, 1, 'Tatlıkuyu Mahallesi, Gebze Center AVM, Gebze', 1, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-KOC-030', 41, 'STCTIT120SS', 40.7955, 29.4426, 1, 1, 'Tatlıkuyu Mahallesi, Gebze Center AVM, Gebze', 1, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-KOC-031', 41, 'STCTIT120SS', 40.7927, 29.3892, 1, 1, 'Sırasöğütler Mah. Çelikoğlu Cad. No:117, Darıca', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KOC-032', 41, 'STCTIT120SS', 40.7638, 30.0005, 1, 1, 'Alikahya Fatih Mah. Sanayi Cad. No:90, İzmit', 23, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KOC-033', 41, 'STCTIT120SS', 40.7638, 30.0005, 1, 1, 'Alikahya Fatih Mah. Sanayi Cad. No:90, İzmit', 23, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KOC-034', 41, 'STCTIT120SS', 40.7475, 30.0623, 1, 1, 'Emek Mahallesi, D100 Karayolu Cad, No:108, Kartepe', 15, 1440, '08:30,17:30;1,6'),
('TR-KOC-035', 41, 'ABBTER22', 40.7953, 29.4425, 1, 1, 'Tatlıkuyu Mahallesi, Gebze Center AVM, Gebze', 1, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-KOC-036', 41, 'STCTIT180SS', 40.7601, 29.9747, 1, 1, 'Ovacık Mah. D-100 Karayolu Cad. No:20, İzmit', 150, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KOC-037', 41, 'STCTIT180SS', 40.7601, 29.9747, 1, 1, 'Ovacık Mah. D-100 Karayolu Cad. No:20, İzmit', 150, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KOC-038', 41, 'STCVEN30S', 40.9047, 29.8483, 1, 1, 'Çavuşlu Mahallesi İshakçılar Mevkii Küme Evler No:53 ( Ada:-- , Pafta:G23B07C3C , Parsel:6887 ), Derince', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KOC-039', 41, 'STCTIT120SS', 40.7059, 29.8722, 0, 1, 'Sanayi Mahallesi D-130 Karayolu Üzeri Yazlik, Gölcük', 15, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KOC-040', 41, 'STCTIT120SS', 40.8058, 29.4848, 0, 1, 'Tavşanlı, Komürcüoğlu Cd.,  Gebze', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KRB-001', 78, 'STCTIT120SS', 41.217, 32.6615, 1, 1, 'Merkez Mahallesi 100. Yıl Sokak No:17, Merkez', 3, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KRB-002', 78, 'STCTIT120SS', 41.2159, 32.6475, 1, 1, 'Üniversite Şehit Ateşe Reşat Moralı Bulv, D:7,  Karabük Merkez', 72, 240, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KRK-001', 39, 'STCTIT90SS', 41.4067, 27.3395, 1, 1, 'Kocasinan Mah, Sanayi 20. Sk No 6/1,  Lüleburgaz', 15, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KRK-002', 39, 'STCTIT120SS', 41.4009, 27.3841, 1, 1, 'Güneş Mah. Cebelli Cad. No:13', 4, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KRK-003', 39, 'STCTIT120SS', 41.401, 27.384, 1, 1, 'Güneş Mah. Cebelli Cad. No:13', 4, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KRM-001', 70, 'STCTIT120SS', 37.2024, 33.0998, 1, 0, 'Karaman Konya Yolu 8. km, Bölükyazı Köyü,  Merkez', 15, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KRM-002', 70, 'STCTIT120SS', 37.1878, 33.179, 1, 1, 'Ataturk Mah. 15 Temmuz, Şehitler Blv No:34,  Merkez', 30, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KRM-003', 70, 'STCTIT120SS', 37.1878, 33.179, 1, 1, 'Ataturk Mah. 15 Temmuz, Şehitler Blv No:34,  Merkez', 30, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KST-001', 37, 'STCTIT120SS', 41.4723, 33.7759, 1, 1, 'Acısu Mh, Kastamonu İnebolu Yolu,  Arız, Merkez', 150, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KST-002', 37, 'STCTIT120SS', 41.5135, 34.2181, 0, 1, 'Musalla, Süleyman Demirel Cd.,  Taşköprü', 200, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KST-003', 37, 'STCTIT180SS', 41.4087, 33.7946, 0, 1, 'İnönü Mh. Halil Rıfat Paşa Cd. No:9 Kastamonu/Merkez', 15, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KTH-001', 43, 'STCTIT120SS', 39.4072, 30.0271, 1, 1, 'Dumlupınar Mah. Afyon Çevre Yolu 3. Km, No: 61, Merekz', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KTH-002', 43, 'STCTIT120SS', 39.4482, 30.0093, 1, 1, 'İnköy Mh. Eskişehir Karayolu Üzeri 3.Km No:54,  Merkez', 4, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KYA-003', 42, 'EFAQC50CSA', 37.909, 32.5154, 0, 1, 'Ankara Cad. No:172 Karatay', 1, 1440, '00:00,00:00;1,7'),
('TR-KYA-004', 42, 'ABBTER22', 37.8737, 32.4848, 0, 1, 'İhsaniye Mah.  Alsan Sitesi Vatan Cd. 19/A,  Selçuklu', 4, 1440, '10:00,19:00;1,7'),
('TR-KYA-005', 42, 'STCTIT120SS', 37.8883, 32.4956, 0, 1, 'Musalla Bağları Mah. Ahmet Hilmi Nalçacı Cad. No:92, Selçuklu', 25, 0, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KYA-006', 42, 'STCTIT120SS', 37.9217, 32.527, 1, 0, 'Fevziçakmak Mah.  Çelik Caddesi, Bukas iş Merkezi, 2/E, Karatay', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KYA-007', 42, 'ABBTER22', 37.5284, 34.0705, 1, 1, 'Ziya Gökalp Mah. Konya Ereğli Cad. No:2067,  Ereğli', 30, 1440, '08:00,18:00;1,7|08:00,18:00;8,8'),
('TR-KYA-008', 42, 'STCTIT120SS', 37.921, 32.5221, 1, 1, 'Horozluhan Mah., Çevreli Sk. No:2A,  Horozluhan Osb, Selçuklu', 16, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KYA-009', 42, 'STCTIT120SS', 37.9256, 32.5089, 1, 1, 'Horozluhan Osb Mah. İstanbul Yolu Üzeri 1.Organize San Böl. No:38/A, Selçuklu', 30, 1440, '09:00,00:00;1,6|12:00,17:00;7,7'),
('TR-KYA-010', 42, 'STCTIT120SS', 37.9517, 32.4937, 1, 1, 'Yazır Mah. Doç. Dr. Halil Ürün Cad. No: 22 Selçuk', 1000, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KYA-011', 42, 'STCTIT120SS', 37.8675, 32.567, 1, 1, 'Tatlıcak Mah. Vatan Sanayi Sitesi Kavaf Sk. No:47, Karatay', 3, 1440, '08:00,18:00;1,5'),
('TR-KYA-012', 42, 'STCTIT120SS', 37.8675, 32.5669, 1, 1, 'Tatlıcak Mah. Vatan Sanayi Sitesi Kavaf Sk. No:47, Karatay', 3, 1440, '08:00,18:00;1,5'),
('TR-KYA-013', 42, 'STCTIT120SS', 37.8589, 32.6244, 1, 1, 'Tatlıcak Mah Ereğli Caddesi No: 83, Karatay', 4, 1440, '08:00,17:30;1,6'),
('TR-KYA-014', 42, 'STCTIT120SS', 37.8589, 32.6245, 1, 1, 'Tatlıcak Mah Ereğli Caddesi No: 83, Karatay', 4, 1440, '08:00,17:30;1,6'),
('TR-KYA-015', 42, 'STCTIT120SS', 37.8266, 32.4096, 1, 1, 'Durunday Mah. Dutlu Cad. No:32, Meram', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KYA-016', 42, 'STCTIT90SS', 38.2032, 32.401, 1, 1, 'Ladik Mah. Yeni İstanbul Cad. No:713, Sarayönü', 65, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KYA-017', 42, 'STCTIT90SS', 38.2031, 32.401, 1, 1, 'Ladik Mah. Yeni İstanbul Cad. No:713, Sarayönü', 65, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KYA-018', 42, 'STCTIT120SS', 37.9145, 32.5503, 0, 1, 'Fevziçakmak, 10650. Sk. No:3,  Karatay', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KYS-002', 38, 'STCTIT180SS', 38.7556, 35.3756, 0, 1, 'Anbar Mah. Osman Kavuncu Blv. No:593-595, Melikgazi', 30, 1440, '00:00,00:00;1,7'),
('TR-KYS-003', 38, 'STCTIT120SS', 38.4695, 35.1594, 1, 1, 'Karacabey Mah. Kıbrıs Cad. No:5, Yeşilhisar', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KYS-004', 38, 'STCTIT120SS', 38.7389, 35.4274, 1, 1, 'Şeker Mah. Osman Kavuncu Blv. No:274, Kocasinan', 9, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KYS-005', 38, 'STCTIT120SS', 38.7514, 35.3951, 1, 1, 'Şeker Mah., Osman Kavuncu Bulvarı, 6161. Sk, D:No:3,  Kocasinan', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KYS-006', 38, 'STCTIT120SS', 38.7541, 35.3839, 1, 1, 'Anbar Mah. Osman Kavuncu Blv. No:412, Melikgazi', 4, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KYS-007', 38, 'STCTIT120SS', 38.7541, 35.3839, 1, 1, 'Anbar Mah. Osman Kavuncu Blv. No:412, Melikgazi', 4, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KYS-008', 38, 'STCTIT120SS', 38.7524, 35.3241, 1, 1, 'Anbar Mah, Osman Kavuncu Blv. No: 626,  Kayseri Osb, Melikgazi', 30, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KYS-009', 38, 'STCTIT120SS', 38.7527, 35.3287, 1, 1, 'Anbar Mah, Osman Kavuncu Blv. No: 608,  Kayseri Osb, Melikgazi', 6, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KYS-010', 38, 'STCATE60SS', 38.9316, 35.0681, 1, 1, 'Himmetdede, Ankara Bulvarı No:182,  Kocasinan', 4, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KYS-011', 38, 'STCATE60SS', 38.749, 35.3683, 1, 1, 'Anbar Mahallesi Delikan Sokak No:15, Melikgazi', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-KYS-012', 38, 'STCTIT120SS', 38.6481, 35.4515, 0, 1, 'Aşağı, Kayseri Cd. NO:9,  Hacılar', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MER-001', 33, 'EFANC222', 36.7719, 34.571, 0, 1, 'Eğriçam, Eğriçam Mah., Adnan Menderes Bulvarı, 33AG, Yenişehir', 200, 1440, '08:00,00:00;1,7|08:00,00:00;8,8'),
('TR-MER-004', 33, 'ABBTER22', 36.8081, 34.6221, 0, 1, 'Nusratiye Mah. Kuvaliyi Milliye Cad. No:130 Akdeniz', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MER-005', 33, 'ABBTER22', 36.8081, 34.6221, 0, 1, 'Nusratiye Mah. Kuvaliyi Milliye Cad. No:130 Akdeniz', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MER-006', 33, 'ABBTER22', 36.8589, 34.7593, 0, 1, 'Anadolu Mah. Atatürk Blv. No:96A Yakaköy, Akdeniz', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MER-008', 33, 'EFAQC50CSA', 36.7494, 34.5165, 0, 1, 'Merkez Mah. 52087 sk. No:24, Mezitli', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MER-009', 33, 'ABBTER22', 36.7832, 34.6139, 0, 1, 'Palmiye Mah. 1225 Sk. No:1, Yenişehir', 45, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MER-010', 33, 'STCTIT120SS', 36.742, 34.5194, 0, 1, 'Merkez Mah. GMK Blv. No:860/A, Mezitli', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MER-011', 33, 'STCTIT120SS', 36.7834, 34.6139, 0, 1, 'Palmiye Mah. 1225 Sk. No:1, Yenişehir', 45, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MER-012', 33, 'ABBTER22', 36.7394, 34.5176, 0, 1, 'Merkez Mah. Gazi Mustafa Kemal Blv. No:872, Mezitli', 7, 0, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MER-013', 33, 'ABBTER22', 36.7395, 34.5175, 0, 1, 'Merkez Mah. Gazi Mustafa Kemal Blv. No:872, Mezitli', 7, 0, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MER-014', 33, 'STCTIT120SS', 36.7916, 34.5947, 1, 1, 'Bahçelievler, 1835. Sk. No:4, Yenişehir', 100, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MER-015', 33, 'STCTIT120SS', 36.8753, 34.8045, 1, 1, 'Mersin Tarsus Karayolu üzeri Bağcılar Mevkii,  Akdeniz/Mersin', 20, 1440, '08:30,18:00;1,5|09:00,17:00;6,6|11:00,16'),
('TR-MER-016', 33, 'STCTIT120SS', 36.9521, 34.9968, 1, 1, 'Şahin Mahallesi Sait Polat Bulvarı No: 386A Blok,  Tarsus', 15, 1440, '08:30,18:30;1,5|08:30,13:30;6,6'),
('TR-MER-017', 33, 'STCTIT120SS', 36.7708, 34.5668, 1, 1, 'Eğriçam, Eğriçam Mah., Adnan Menderes Bulvarı, 33AG, Yenişehir', 200, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MER-018', 33, 'STCTIT120SS', 36.785, 34.5734, 1, 1, 'Menteş Mah. Hüseyin Okan Merzeci Bulvarı No : 85,Yenişehir ', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MER-020', 33, 'STCTIT120SS', 36.8793, 34.8153, 1, 1, 'Adnan Menderes Mah. İnönü Blv. No:1/16, Huzurkent, Akdeniz', 8, 1440, '08:00,22:00;1,7|08:00,22:00;8,8'),
('TR-MER-021', 33, 'STCTIT90SS', 36.9038, 34.8736, 1, 1, 'Yunusemre Mah. Nato Yolu Kavşağı, No:74, Yeni Hal Karşısı, Tarsus', 2, 0, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MER-022', 33, 'STCTIT120SS', 36.7582, 34.5449, 1, 1, 'Fatih, Gazi Mustafa Kemal Blv. Oktay Öner Sitesi D:A1 Blok No:1,  Mezitli', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MER-023', 33, 'ABBTER22', 36.683, 34.4172, 0, 0, 'Atatürk Mah. Mersin Cad. No:45/A Çeşmeli', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MER-024', 33, 'STCTIT120SS', 36.9703, 34.9487, 0, 1, 'Özbek,  Tarsus', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MER-025', 33, 'ABBTER22', 36.9703, 34.9488, 0, 1, 'Özbek,  Tarsus', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MER-026', 33, 'STCTIT120SS', 36.8325, 34.6643, 0, 1, 'Çilek, 63188. Sk. 8a,  Akdeniz', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MER-027', 33, 'ABBTER22', 36.8326, 34.6642, 0, 1, 'Çilek, 63188. Sk. 8a,  Akdeniz', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MLT-001', 44, 'ABBTER22', 38.3383, 38.248, 1, 1, 'Karavak Mah. Turgut Özal Blv. No:155/A, Yeşilyurt', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MLT-002', 44, 'STCTIT120SS', 38.3603, 38.1857, 0, 1, '1. Osb Mahallesi Havaalanı Yolu 2. Cadde No:12/2 İç Kapı No 1 Yeşilyurt', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MNS-001', 45, 'STCTIT120SS', 38.6204, 27.3814, 1, 0, '75. Yıl Mah. Kenan Evren Sanayi Sit. 5337. Sk No:2, Yunusemre', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MNS-002', 45, 'STCTIT120SS', 38.617, 27.3786, 1, 0, '75. Yıl Mah. , 5317. Sk. No:32,  Yunusemre', 35, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MNS-003', 45, 'STCTIT120SS', 38.6747, 27.4706, 0, 1, 'Veziroğlu Mah, Manisa Akhisar Yolu No:1,  Veziroğlu- Şehzadeler', 50, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MNS-004', 45, 'STCTIT120SS', 38.6747, 27.4706, 0, 1, 'Veziroğlu Mah, Manisa Akhisar Yolu No:1,  Veziroğlu- Şehzadeler', 50, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MNS-005', 45, 'STCTIT180SS', 38.6185, 27.3782, 0, 1, '75. Yıl, 5327. Sk. No:1/A,  Yunusemre', 15, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MNS-006', 45, 'STCTIT180SS', 38.6167, 27.3662, 0, 1, 'Keçiliköy Osb Mah. Atatürk Blv. No:7/1 Yunusemre ', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MRD-001', 47, 'STCATE60SS', 37.231, 40.6316, 1, 1, 'Mardin Yolu Üzeri Havaalanı Yanı,  Kızıltepe', 3, 1440, '08:00,18:00;1,5'),
('TR-MUG-001', 48, 'EFAPM22', 37.0315, 27.4163, 0, 1, 'Eskiçeşme Mah. Osman Nuri Bilgin Cad. No: 48, Bodrum', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MUG-006', 48, 'EFAQC50CSA', 37.0569, 27.3589, 1, 1, 'Ortakent Kemer Mevkii Cumhuriyet Cad. No: 6, Bodrum', 1000, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-MUG-008', 48, 'EFAQC50CSA', 37.2156, 27.658, 0, 1, 'Kemikler Mah. Muğla Bodrum Yolu, No: 5/5, Milas', 2, 1440, '08:30,18:30;1,6'),
('TR-MUG-009', 48, 'EFAQC24S', 37.0558, 28.3371, 0, 1, 'Akyaka Mah, İnişdibi Cd. No:48 Ula', 1, 1440, '08:30,00:00;1,7|08:30,00:00;8,8'),
('TR-MUG-012', 48, 'EFAQC50SA', 37.3402, 27.7389, 0, 1, 'Aydınlıkevler Mah. 19 Mayıs Blv. No:115/A', 20, 1440, '09:00,20:00;1,6'),
('TR-MUG-014', 48, 'STCTIT120SS', 37.3277, 28.1641, 0, 1, 'Madenler Mah. Gazi Mustafa Kemal Atatürk Blv. No: 18, Yatağan', 100, 1440, '07:00,23:00;1,7|07:00,23:00;8,8'),
('TR-MUG-016', 48, 'STCTIT120SS', 37.1117, 27.3223, 0, 1, 'Turgutreis Mah. Gökçebel Kalabak Mevki, Bodrum', 50, 0, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MUG-017', 48, 'STCTIT120SS', 37.2543, 28.2345, 1, 1, 'Salih Paşalar Mah. Köyiçi Sk. No:241-1, Menteşe', 10, 60, '09:00,18:30;1,7|09:00,18:30;8,8'),
('TR-MUG-018', 48, 'STCTIT120SS', 37.2049, 27.6438, 1, 1, 'Kemikler Mah.2 Blv. No:31/1, Milas', 20, 60, '09:00,18:30;1,7|09:00,18:30;8,8'),
('TR-MUG-019', 48, 'STCTIT120SS', 36.6223, 29.1317, 1, 1, 'Taşyaka Mah. Ölüdeniz Cad. No: 14, Fethiye', 1000, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-MUG-020', 48, 'STCTIT120SS', 37.0418, 27.4368, 1, 1, 'Yokuşbaşı Mah. Kocadere Sk. No:34, Bodrum', 20, 1440, '08:00,22:00;1,7|08:00,22:00;8,8'),
('TR-MUG-021', 48, 'STCTIT120SS', 37.0543, 27.3544, 1, 1, 'Ortakent Mah. Cumhuriyet Cad. No:49, Bodrum', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MUG-022', 48, 'STCTIT120SS', 37.2157, 27.6582, 1, 1, 'Kemikler Mah. Muğla Bodrum Yolu, No: 5/5, Milas', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MUG-023', 48, 'STCTIT120SS', 36.7748, 28.2474, 1, 1, 'Turunuç Mah. Cumhuriyet Cad. No:5, Marmaris', 25, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MUG-024', 48, 'STCTIT120SS', 37.0489, 27.4423, 1, 1, 'Yokuşbaşı Mah., 1836 Sokak No:8, 1836 Sokak No:8,  Bodrum', 25, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MUG-025', 48, 'STCTIT120SS', 37.0871, 27.4766, 1, 1, 'Torba, Kaynar Cd No:15,  Bodrum', 50, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MUG-026', 48, 'STCTIT120SS', 37.035, 27.4211, 1, 1, 'Eskiçeşme, Neyzen Tevfik Cd. No:168,  Bodrum', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MUG-027', 48, 'STCATE60SS', 36.7597, 27.6356, 1, 1, 'Karaköy Mah. Küme Evler, No:359, Datça', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MUG-028', 48, 'STCTIT120SS', 37.0846, 27.4778, 1, 1, 'Torba Mah. Kaynar Caddesi, No:11,  Bodrum', 150, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MUG-029', 48, 'STCTIT120SS', 36.5521, 29.1248, 1, 1, 'Belceğiz Mahallesi, 225. Sk.,  Ölüdeniz, Fethiye', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MUG-030', 48, 'STCTIT120SS', 37.0861, 27.4788, 1, 1, 'Torba Mah. 3129 Sk. No:1-3, Bodrum', 60, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MUG-031', 48, 'STCVEN30S', 37.0454, 27.442, 1, 1, 'Yokuşbaşı, Emin Anter Blv No:91,  Bodrum', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MUG-032', 48, 'STCTIT120SS', 37.2553, 28.23, 1, 1, 'Bayır, Aydın Karayolu 11.Km,  Muğla Merkez', 15, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MUG-033', 48, 'STCATE60SS', 37.1149, 27.3065, 1, 1, 'Yalıkavak, Tilkicik Cd. No:85,  Bodrum', 75, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MUG-034', 48, 'STCSAT222', 36.9881, 27.5533, 1, 1, 'Çiftlik Mahallesi, Yalıdağ Cd No 40,  Bodrum', 100, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MUG-035', 48, 'STCATE60SS', 37.0554, 28.3313, 0, 1, 'Akyaka, Koyuncu Sk. No:34,  Ula', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MUG-036', 48, 'STCTIT120SS', 36.6742, 29.1019, 0, 1, 'Karagedik, 1104. Sk. No:16,  Fethiye', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MUG-037', 48, 'ABBTER22', 37.2553, 28.2299, 0, 1, 'Bayır, Aydın Karayolu 11.Km,  Muğla Merkez', 15, 1440, '09:00,18:00;1,6'),
('TR-MUG-038', 48, 'STCTIT120SS', 36.4776, 29.1079, 0, 1, 'Uzunyurt, Kızılcakaya Sokak NO: 110,  Fethiye', 200, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MUG-039', 48, 'ABBTER22', 36.4776, 29.1079, 0, 1, 'Uzunyurt, Kızılcakaya Sokak NO: 110,  Fethiye', 200, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MUG-040', 48, 'ABBTER22', 36.4776, 29.1078, 0, 1, 'Uzunyurt, Kızılcakaya Sokak NO: 110,  Fethiye', 200, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-MUG-041', 48, 'STCTIT120SS', 37.0363, 27.2833, 0, 1, 'Dereköy Mah. Hayalözü Küme Evler No:35, Rinosgarden, Bodrum', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-NEV-001', 50, 'EFAPM22', 38.594, 34.7182, 0, 0, 'Afetevleri mah. Niğde Yolu 4. km, Merkez', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-NEV-002', 50, 'EFANC222', 38.629, 34.8064, 0, 1, 'Uçhisar Beldesi, Aşağı Mah. Gedik Sok. No:53 Merkez', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-NEV-003', 50, 'ABBTER22', 38.6352, 34.9039, 0, 1, 'Temenni Mahallesi Esbelli Sokak No: 5, Ürgüp', 4, 1440, '00:00,00:00;1,7'),
('TR-NEV-004', 50, 'STCTIT120SS', 38.5521, 34.5651, 1, 1, 'Bahçelievler Mah. Muhsin Yazıcıoğlu Blv. No:5/A Karapınar KSB., Acıgöl', 4, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-NEV-005', 50, 'STCTIT120SS', 38.5679, 34.7017, 1, 1, 'Kasapoğlu Mah. Sami Yüksel Blv. No:34, Göre, Merkez', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-ORD-001', 52, 'STCTIT120SS', 40.9785, 37.9058, 1, 1, 'Akyazı, Şht. Ali Gaffar Okkan Cd. No:9,  Altınordu', 50, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-OSM-001', 80, 'STCTIT120SS', 37.0449, 36.227, 1, 1, 'Fakıuşağı Mah. 45006 Sok, No:8 Fatih Sitesi A Blok , Osmaniye Merkez', 6, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-OSM-002', 80, 'STCTIT90SS', 37.242, 36.4312, 1, 1, 'Uzunbanı Mh, Çevreyolu Cd. No:128, Düziçi', 6, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-OSM-003', 80, 'STCTIT90SS', 37.242, 36.4312, 1, 1, 'Uzunbanı Mh, Çevreyolu Cd. No:128, Düziçi', 6, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-OSM-005', 80, 'STCTIT180SS', 37.0564, 36.1763, 0, 1, 'Kumarlı, Devlet Hastanesi Caddesi No:5/A,  Akyar/Toprakkale', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-RZE-002', 53, 'EFAQC50CSA', 41.0447, 40.5922, 0, 1, 'Taşlıdere Mah. Eski Rize Hopa Yolu, Rize Merkez', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-RZE-003', 53, 'STCTIT150SS', 40.7839, 40.6078, 0, 1, ' RİDOS Termal Otel,  Ilıcaköy/İkizdere', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-RZE-004', 53, 'STCTIT150SS', 40.784, 40.6078, 0, 1, ' RİDOS Termal Otel,  Ilıcaköy/İkizdere', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-RZE-005', 53, 'ABBTER22', 40.784, 40.6082, 0, 1, ' RİDOS Termal Otel,  Ilıcaköy/İkizdere', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-SAK-002', 54, 'EFAPM22', 40.7283, 30.3839, 0, 1, 'Hanlıköy mah. Kartopu Sok. No: 19/A, Arifiye', 20, 1440, '00:00,00:00;1,5|08:30,13:00;6,6'),
('TR-SAK-003', 54, 'STCTIT120SS', 40.7342, 30.3803, 0, 1, 'Hanlı Merkez Mah. D-100 Karayolu Cad. No:312/1, Arifiye', 2, 1440, '08:30,18:00;1,7'),
('TR-SAK-004', 54, 'STCTIT120SS', 40.7787, 30.3649, 0, 1, 'Arabacı Alanı Mah. Mehmet Akif Ersoy Cad. No:25, Adapazarı', 1000, 1440, '10:00,22:00;1,7|10:00,22:00;8,8'),
('TR-SAK-005', 54, 'STCTIT90SS', 40.6896, 30.2352, 1, 1, 'Hasanpaşa, Şht. Cevdet Koç Cd. No:10, Sapanca', 15, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-SAK-006', 54, 'ABBTER22', 41.1078, 30.681, 1, 1, 'Yalı Mah. İstanbul Cad. No:62, Karasu', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-SAK-007', 54, 'STCTIT120SS', 40.7606, 30.3927, 1, 1, 'Güllük Mah. Zübeyde Hanım Cd. No:87,  Adapazarı', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-SAK-008', 54, 'STCTIT120SS', 40.7213, 30.3819, 1, 1, 'Hanlıköy Mah, Eskişehir Cd. No: 70/1,  Arifiye', 150, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-SAK-009', 54, 'STCTIT120SS', 40.6777, 30.3051, 1, 1, 'Hacı Mercan Köyü, Orta Sk. No:29, Sapanca', 10, 1440, '07:00,23:30;1,7|07:00,23:30;8,8');
INSERT INTO `istasyonlar` (`istasyon_kodu`, `plaka`, `model_kodu`, `lat`, `lng`, `lokasyon_tipi`, `aktiflik`, `adres`, `otopark`, `park_suresi`, `hizmet_saati`) VALUES
('TR-SAK-010', 54, 'STCTIT120SS', 40.5528, 30.3142, 0, 1, 'Bağlarbaşı Mahallesi Merkez Sokağı No:5', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-SAK-011', 54, 'STCTIT120SS', 40.5529, 30.3142, 0, 1, 'Bağlarbaşı Mahallesi Merkez Sokağı No:5', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-SAM-002', 55, 'EFAQC50SA', 41.2246, 36.4487, 0, 0, 'Cumhuriyet Mah. Samsun Ordu Cad. No: 142, Tekkeköy', 50, 1440, '09:00,18:00;1,5'),
('TR-SAM-003', 55, 'ABBTER22', 41.2254, 36.4308, 0, 1, 'Kerimbey Mah. Işık Sk. No:2, Tekkeköy', 35, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-SAM-004', 55, 'STCTIT120SS', 41.2253, 36.4307, 0, 1, 'Kerimbey Mah. Işık Sk. No:2, Tekkeköy', 35, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-SAM-005', 55, 'STCTIT120SS', 41.4872, 36.0902, 1, 1, 'Engiz Mah. Atatürk Blv. No:88, 19 Mayıs', 4, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-SAM-007', 55, 'STCTIT180SS', 41.3009, 36.3303, 1, 1, 'Hançeri Mah. 608 Sk. No:2/1, İlkadım', 56, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-SAM-008', 55, 'STCTIT90SS', 41.2929, 36.244, 1, 1, 'Toybelen Mah. Anadolu Bulvarı (Samsun-Ankara Karayolu 14.km)  No:216,  İlkadım', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-SAM-009', 55, 'STCTIT120SS', 41.2313, 36.4195, 1, 1, 'Şabanoğlu Mah. Atatürk Blv. No:282, Tekkeköy', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-SAM-010', 55, 'STCTIT180SS', 41.3333, 36.2722, 1, 1, 'Mimar Sinan Mah. Alparslan Blv. No:17, Atakum', 256, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-SAM-011', 55, 'STCTIT180SS', 41.2976, 36.23, 0, 1, 'Toybelen, 1809. Caddesi No:2, İlkadım', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-SAM-012', 55, 'STCTIT120SS', 41.2932, 36.2892, 0, 1, 'Derecik, Atatürk Blv. No:6,  İlkadım', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-SAM-013', 55, 'ABBTER22', 41.293, 36.2893, 0, 1, 'Derecik, Atatürk Blv. No:6,  İlkadım', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-SAM-014', 55, 'ABBTER22', 41.293, 36.2893, 0, 1, 'Derecik, Atatürk Blv. No:6,  İlkadım', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-SRN-001', 73, 'ABBTER22', 37.3306, 42.2075, 0, 1, 'Konak Mah. Silopi Blv. No:83/A, Cizre', 6, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-SRT-001', 56, 'ABBTER22', 37.9419, 41.9121, 1, 1, 'Afetevleri mah. Kurtalan Yolu Cad. No:30/A, Merkez', 30, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-SUR-002', 63, 'ABBTER22', 37.1081, 38.8253, 0, 1, 'Asya Mah. Akcakale Cad. No:544 Gapel Plaza, Eyyübiye', 2, 60, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-SUR-003', 63, 'STCTIT120SS', 37.1084, 38.8256, 1, 1, 'Asya Mah. Akcakale Cad. No:544 Gapel Plaza, Eyyübiye', 2, 60, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-SUR-004', 63, 'STCATE60SS', 37.1614, 38.857, 1, 1, 'Akpınar, Recep Tayyip Erdoğan Bulvarı No:338,  Haliliye', 15, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-SVS-001', 58, 'EFAQC50SA', 39.7272, 37.0007, 0, 1, 'Gültepe Mah. Küçük San. Cad. No:11', 5, 1440, '08:00,18:30;1,5'),
('TR-SVS-002', 58, 'STCTIT90SS', 39.751, 37.0488, 1, 1, 'Yeşilyurt Mah. Sultan Şehir Blv No:86,  Merkez', 5, 1440, '08:00,23:59;1,6'),
('TR-SVS-003', 58, 'STCTIT120SS', 39.7377, 37.032, 1, 1, 'Kardeşler, Sultan Şehir Blv No:32/1,  Merkez', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-TEK-005', 59, 'EFAQC50CSA', 41.148, 27.8383, 0, 1, 'Zafer Mah. Bakım Onarım 3. Sk. No:14/16 Çorlu', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-TEK-006', 59, 'EFAQC50SA', 41.1392, 27.8726, 0, 1, 'İstanbul Yolu üzeri, Önerler Kavşağı Çorlu', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-TEK-007', 59, 'STCTIT120SS', 41.1407, 27.8678, 0, 0, 'Önerler Mah. İstanbul Cad. No:55, Çorlu', 10, 1440, '08:30,18:00;1,6|11:00,16:00;7,7'),
('TR-TEK-008', 59, 'STCTIT120SS', 41.1542, 27.8242, 1, 1, 'Kazimiye Mah. Salih Omurtak Cad. No:54/B,  Çorlu', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-TEK-009', 59, 'STCTIT120SS', 41.198, 27.8296, 1, 1, 'Velimeşe OSB Mah. 2. Yanyol Cad. No:8, Ergene', 20, 30, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-TEK-010', 59, 'STCTIT120SS', 40.9456, 27.4665, 1, 1, 'Altınova Mah. Adnan Menderes Blv. No:79, Süleymanpaşa', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-TEK-011', 59, 'STCTIT120SS', 40.9456, 27.4665, 1, 1, 'Altınova Mah. Adnan Menderes Blv. No:79, Süleymanpaşa', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-TEK-012', 59, 'STCTIT120SS', 41.2619, 27.9478, 1, 1, 'Kızılpınar, 221. Sk no 11,  Çerkezköy', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-TEK-013', 59, 'STCTIT120SS', 40.9349, 27.2976, 1, 0, 'İnecik mahallesi 279,  Süleymanpaşa', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-TEK-014', 59, 'STCVEN30S', 40.8729, 26.9938, 1, 1, 'E-84 Karayolu Üzeri Alaybey Köyü,  Malkara', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-TEK-015', 59, 'STCTIT120SS', 41.1437, 27.8392, 1, 1, 'Zafer, Sanayi Alt Yol Sok No: 27,  Çorlu', 6, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-TEK-016', 59, 'STCVEN30S', 41.191, 27.821, 1, 0, 'Silahtarağa Mah. Hacışeremet Cad. 2. SOK. No:1/A,  Çorlu', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-TEK-017', 59, 'STCATE60SS', 40.9652, 27.3736, 0, 0, 'Seymenli Mahallesi İsmet İnönü Bulvarı No:207, Süleymanpaşa', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-TEK-018', 59, 'STCTIT90SS', 40.966, 27.4867, 0, 1, '100. Yıl, Kita Sk. Tan İş Merkezi No:2 B Bölüm No:1,  Süleymanpaşa', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-TKT-001', 60, 'STCVEN30S', 40.3107, 36.2865, 0, 1, 'Dökmetepe Köyü Dökmetepe Küme Evleri İdari Bina Blk. No:201, Çerçi', 15, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-TZX-004', 61, 'STCTIT90SS', 40.9894, 39.8022, 1, 1, 'Pelitli Mah. Rize Cad. No:50, Ortahisar ', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-TZX-005', 61, 'STCTIT120SS', 41.0008, 39.7564, 1, 1, 'Sanayi Mah. Büyük Sanayi Sit. 302. Sk. No:20, Ortahisar', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-TZX-006', 61, 'EFAQC20CSA', 40.9925, 39.7854, 0, 1, 'Konaklar Mah. Barış Cad. No:34 Ortahisar', 1, 1440, '09:00,19:00;1,6'),
('TR-TZX-008', 61, 'STCTIT90SS', 40.9754, 39.7483, 0, 1, 'Kaymaklı, Anadolu Blv. Erzurum Yolu Üzeri No:163 Kat:1 D:1,  Ortahisar', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-TZX-009', 61, 'STCVEN30S', 40.8795, 39.6966, 0, 1, 'Esiroğlu, Trabzon Gümüşhane Yolu No:227,  Maçka', 10, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-TZX-010', 61, 'STCTIT120SS', 40.9498, 39.7436, 0, 1, 'İncesu, Trabzon Yolu no:2, Ortahisar', 5, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-USK-001', 64, 'STCTIT90SS', 38.6698, 29.4163, 1, 1, 'Fevzi Çakmak Mah. Gazi Blv. No:44, Merkez', 50, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-USK-002', 64, 'STCTIT90SS', 38.6698, 29.4162, 1, 1, 'Fevzi Çakmak Mah. Gazi Blv. No:44, Merkez', 50, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-USK-003', 64, 'STCTIT120SS', 38.6735, 29.4284, 1, 1, 'Fevzi Çakmak Mah. Gazi Blv. 1. Sok. No:84/A, Merkez', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-VAN-001', 65, 'STCVEN30S', 38.481, 43.3597, 0, 1, 'Hatuniye Mah. İpekyolu Bulv No:202/1, İpekyolu', 20, 0, '08:30,19:00;1,4|09:30,17:00;5,7|09:30,17'),
('TR-VAN-002', 65, 'ABBTER22', 38.4803, 43.3589, 1, 1, 'Hatuniye Mah. Sevimli Sk. No:1, İpekyolu', 40, 1440, '08:00,18:00;1,6|10:00,16:00;7,7|08:00,17'),
('TR-YLV-001', 77, 'STCTIT120SS', 40.6773, 29.3862, 1, 1, 'Taşköprü Merkez Mah. Yalova İzmit Yolu Cad. No:67, Çiftlikköy', 2, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-YLV-002', 77, 'STCTIT120SS', 40.649, 29.2846, 1, 1, 'Bayraktepe Mah. Yalova Bursa Yolu No:61, Merkez', 20, 1440, '00:00,00:00;1,7|00:00,00:00;8,8'),
('TR-YZG-001', 66, 'ABBTER22', 39.818, 34.7892, 1, 1, 'Köseoğlu Mah. Adnan Menderes Blv. No:35/1, Merkez', 3, 1440, '08:30,18:30;1,6|08:30,18:30;8,8');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `model`
--

DROP TABLE IF EXISTS `model`;
CREATE TABLE IF NOT EXISTS `model` (
  `model_kodu` varchar(16) COLLATE utf8mb3_turkish_ci NOT NULL,
  `model_adi` varchar(40) COLLATE utf8mb3_turkish_ci NOT NULL,
  `model_aciklama` text COLLATE utf8mb3_turkish_ci NOT NULL,
  `soket_id` int NOT NULL,
  PRIMARY KEY (`model_kodu`),
  KEY `soket_id` (`soket_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_turkish_ci;

--
-- Tablo döküm verisi `model`
--

INSERT INTO `model` (`model_kodu`, `model_adi`, `model_aciklama`, `soket_id`) VALUES
('ABBTER184SS', 'Terra 184, CCS+CCS', 'Terra 180kW, 2xCCS', 1),
('ABBTER22', 'Terra 22kVA', 'Terra AC 22kVA', 3),
('deneme', 'deneme', 'deneme', 5),
('EFANC222', 'Normal (Gen.2) 22kVA', 'Normal Charger Gen.2, AC 2x22kVA', 7),
('EFAPM22', 'PM 22kVA', 'Pole Mount Charger, AC 22kVA', 3),
('EFAPM7', 'PM 7.4kVA', 'Pole Mount Charger, AC 7.4kVA', 3),
('EFAQC20CSA', 'QC 20kW Full', 'Quick Charger, CHAdeMO 20kW + CCS 20kW + AC22kVA', 2),
('EFAQC24S', 'QC 24kW', 'Quick Charger, CCS 24kW', 4),
('EFAQC50CSA', 'QC 50kW Full', 'Quick Charger, CHAdeMO 50kW + CCS 50kW + AC22kVA', 2),
('EFAQC50SA', 'QC 50kW CCS + AC', 'Quick Charger, CCS 50kW + AC 22kVA', 6),
('STCATE60SS', 'Athena 60kW 2xCCS', 'Athena 60kW, 2xCCS', 1),
('STCJUP60SCA', 'Jupiter 60kW', 'Jupiter, CCS 60kW + CHAdeMO 60kw + AC22kVA', 5),
('STCNOV360S', 'Nova 360kW', 'Nova 360kW, CCS', 4),
('STCSAT222', 'Saturn 22kVA', 'Saturn, 2x AC 22kVA', 7),
('STCTIT120SS', 'Titan 120kW', 'Titan 120kW, 2xCCS', 1),
('STCTIT150SS', 'Titan 150kW', 'Titan 150kW, 2xCCS', 1),
('STCTIT180SS', 'Titan 180kW', 'Titan 180kW, 2xCCS', 1),
('STCTIT90SS', 'Titan 90kW', 'Titan 90kW, 2xCCS', 1),
('STCVEN30S', 'Venus 30kW', 'Venus, CCS 30kW', 4);

--
-- Tetikleyiciler `model`
--
DROP TRIGGER IF EXISTS `eklenen_model`;
DELIMITER $$
CREATE TRIGGER `eklenen_model` AFTER INSERT ON `model` FOR EACH ROW INSERT INTO eklenen_model_tarih (islem,model_kodu,model_adi,model_aciklama,soket_id,islem_zamani)
VALUES('eklendi',new.model_kodu,new.model_adi,new.model_aciklama,new.soket_id,now())
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `soket`
--

DROP TABLE IF EXISTS `soket`;
CREATE TABLE IF NOT EXISTS `soket` (
  `soket_id` int NOT NULL AUTO_INCREMENT,
  `soket_tipi` varchar(40) COLLATE utf8mb3_turkish_ci NOT NULL,
  `soket_sayisi` int NOT NULL,
  PRIMARY KEY (`soket_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_turkish_ci;

--
-- Tablo döküm verisi `soket`
--

INSERT INTO `soket` (`soket_id`, `soket_tipi`, `soket_sayisi`) VALUES
(1, 'DCCOMBOTYP2', 2),
(2, 'CHADEMO,DCCOMBOTYP2,IEC62196_2TYPE2OUTLE', 3),
(3, 'IEC62196_2TYPE2OUTLET', 1),
(4, 'DCCOMBOTYP2', 1),
(5, 'DCCOMBOTYP2,CHADEMO,IEC62196_2TYPE2OUTLE', 3),
(6, 'DCCOMBOTYP2,IEC62196_2TYPE2OUTLET', 2),
(7, 'IEC62196_2TYPE2OUTLET', 2);

--
-- Dökümü yapılmış tablolar için kısıtlamalar
--

--
-- Tablo kısıtlamaları `iklim_il`
--
ALTER TABLE `iklim_il`
  ADD CONSTRAINT `iklim_il_ibfk_1` FOREIGN KEY (`iklim_id`) REFERENCES `iklim_kosullari` (`iklim_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `iklim_il_ibfk_2` FOREIGN KEY (`plaka`) REFERENCES `iller` (`plaka`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Tablo kısıtlamaları `istasyonlar`
--
ALTER TABLE `istasyonlar`
  ADD CONSTRAINT `istasyonlar_ibfk_1` FOREIGN KEY (`plaka`) REFERENCES `iller` (`plaka`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `istasyonlar_ibfk_2` FOREIGN KEY (`model_kodu`) REFERENCES `model` (`model_kodu`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Tablo kısıtlamaları `model`
--
ALTER TABLE `model`
  ADD CONSTRAINT `model_ibfk_1` FOREIGN KEY (`soket_id`) REFERENCES `soket` (`soket_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
