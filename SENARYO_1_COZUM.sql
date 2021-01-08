-- SENARYO 1

-- Customers isimli bir veritabanı oluşturunuz ve bu veritabanı içerisine gösterilen tabloları SQL kodu yazarak oluşturunuz.
 
 CREATE TABLE CUSTOMERS

 CREATE TABLE CITIES(
 ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
 CITY VARCHAR(50)
 )

 CREATE TABLE DISTRICTS(
 ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
 CITYID INT,
 DISTRICT VARCHAR(50)
 )

 CREATE TABLE CUSTOMERS(
 ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
 CUSTOMERNAME VARCHAR(100),
 TCNUMBER VARCHAR(11),
 GENDER VARCHAR(1),
 EMAIL VARCHAR(100),
 BIRTHDATE DATE,
 CITYID INT,
 DISTRICTID INT,
 TELNR1 VARCHAR(15),
 TELNR2 VARCHAR(15),
 )


 -- Customers tablosundan adı ‘A’ harfi ile başlayan kişileri çeken sorguyu yazınız.
 
 SELECT * FROM CUSTOMERS
 WHERE CUSTOMERNAME LIKE 'A%'



 -- Customers tablosundan adı ‘A’ harfi ile baþlayan erkek müşterileri çeken sorguyu yazınız.
 
 SELECT * FROM CUSTOMERS
 WHERE CUSTOMERNAME LIKE 'A%' AND GENDER='E'



 -- 1990 ve 1995 yılları arasında doğan müşterileri çekiniz. 1990 ve 1995 yılları dahildir.
 
 SELECT * FROM CUSTOMERS
 WHERE BIRTHDATE BETWEEN '1990-01-01' AND '1995-12-31'




 -- İstanbul’da yaşayan kişileri Join kullanarak getiren sorguyu yazınız.

 SELECT C.*,CT.CITY FROM CUSTOMERS C
 INNER JOIN CITIES CT ON C.CITYID = CT.ID
 WHERE CT.CITY = 'ÝSTANBUL'




 -- İstanbul’da yaþayan kişileri subquery kullanarak getiren sorguyu yazınýı.
 
 --1.YÖNTEM
 SELECT
 (SELECT CITY FROM CITIES  WHERE ID=C.CITYID),
 * FROM CUSTOMERS C
 WHERE (SELECT CITY FROM CITIES  WHERE ID=C.CITYID) = 'ÝSTANBUL'

 --2.YÖNTEM
 SELECT * FROM CUSTOMERS C
 WHERE C.CITYID IN (SELECT ID FROM CITIES  WHERE CITY='ÝSTANBUL') 





-- Hangi şehirde kaç müşterimizin olduðu bilgisini getiren sorguyu yazınız.
 
 --1.YÖNTEM
 SELECT CT.CITY, COUNT(C.ID) AS CUSTOMERCOUNT FROM CUSTOMERS C
 INNER JOIN CITIES CT ON CT.ID = C.CITYID
 GROUP BY CT.CITY

 --2.YÖNTEM
 SELECT *,
 (SELECT COUNT(*) FROM CUSTOMERS WHERE CITYID = CT.ID) AS CUSTOMERSCOUNT
FROM CITIES CT




-- 10’dan fazla müşterimiz olan şehirleri müşteri sayısı ile birlikte müşteri sayısına göre fazladan aza doğru sıralı şekilde getiriniz.
 
 --1.YÖNTEM
 SELECT CT.CITY, COUNT(C.ID) AS CUSTOMERCOUNT FROM CUSTOMERS C
 INNER JOIN CITIES CT ON CT.ID = C.CITYID
 GROUP BY CT.CITY
 HAVING COUNT(C.ID) >10
 ORDER BY COUNT(C.ID) DESC
 
 --2.YÖNTEM
 SELECT*,
 (SELECT COUNT(*) FROM CUSTOMERS WHERE CITYID=C.ID)
 FROM CITIES C
 WHERE (SELECT COUNT(*) FROM CUSTOMERS WHERE CITYID=C.ID) >10





 -- Hangi şehirde kaç erkek, kaç kadın müşterimizin olduğu bilgisini şekildeki gibi getiren sorguyu yazınız.
 SELECT CT.CITY, C.GENDER, COUNT(C.ID) AS CUSTOMERCOUNT FROM CUSTOMERS C
 INNER JOIN CITIES CT ON CT.ID = C.CITYID
 GROUP BY CT.CITY, C.GENDER
 ORDER BY CT.CITY,C.GENDER




 -- Hangi şehirde kaç erkek, kaç kadın müşterimizin olduğu bilgisini şekildeki gibi getiren sorguyu yazınız.

 SELECT CITY AS SEHIRADI,
 (SELECT COUNT(*) FROM CUSTOMERS WHERE CITYID = C.ID) AS MUSTERISAYISI,
 (SELECT COUNT(*) FROM CUSTOMERS WHERE CITYID = C.ID AND GENDER='E') AS ERKEKSAYISI,
 (SELECT COUNT(*) FROM CUSTOMERS WHERE CITYID = C.ID AND GENDER='k') AS KADINSAYISI
 FROM CITIES C





 -- Customers tablosuna yaş grubu için yeni bir alan ekleyiniz. Bu işlemi hem management studio ile hem de sql kodu ile yapınız.Alanı adı AGEGROUP veritipi Varchar(50)

ALTER TABLE CUSTOMERS ADD AGEGROUP VARCHAR(50)




-- Customers tablosuna eklediðiniz AGEGROUP alanını 20-35 yaş arası,36-45 yaş arası,46-55 yaş arası,55-65 yaş arası ve 65 yaş üstü olarak güncelleyiniz.

UPDATE CUSTOMERS SET AGEGROUP='20-35 YAS'
WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 20 AND 35

UPDATE CUSTOMERS SET AGEGROUP='36-45 YAS'
WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 36 AND 45

UPDATE CUSTOMERS SET AGEGROUP='46-55 YAS'
WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 46 AND 55

UPDATE CUSTOMERS SET AGEGROUP='55-65 YAS'
WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 56 AND 65

UPDATE CUSTOMERS SET AGEGROUP='65 YAS ÜSTÜ'
WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) > 65





-- Customers tablosunda müşterinin yaşına göre hesaplayarak şekildeki gibi bir sonuç getiriniz. Not: AGEGROUP alanı kullanılmadan sorgu getirilecektir.

-- GROUP BY İLE YAPMAK
SELECT AGEGROUP, COUNT(*) FROM CUSTOMERS
GROUP BY AGEGROUP
ORDER BY AGEGROUP

-- ASIL İSTENİLEN

SELECT 
CASE 
    WHEN DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 20 AND 35 THEN '20-35 YAS ARASI'
	WHEN DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 36 AND 45 THEN '36-45 YAS ARASI'
	WHEN DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 46 AND 55 THEN '46-55 YAS ARASI'
	WHEN DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 56 AND 65 THEN '20-35 YAS ARASI'
	WHEN DATEDIFF(YEAR,BIRTHDATE,GETDATE()) >65 THEN '65 YAÞ ÜSTÜ'
END AGEGROUP,
COUNT(*) CUSTOMERCOUNT
FROM CUSTOMERS
GROUP BY 
CASE 
    WHEN DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 20 AND 35 THEN '20-35 YAS ARASI'
	WHEN DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 36 AND 45 THEN '36-45 YAS ARASI'
	WHEN DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 46 AND 55 THEN '46-55 YAS ARASI'
	WHEN DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 56 AND 65 THEN '20-35 YAS ARASI'
	WHEN DATEDIFF(YEAR,BIRTHDATE,GETDATE()) >65 THEN '65 YAÞ ÜSTÜ'
END






-- İstanbul’da yaşayıp ilçesi ‘Kadıköy’ dışında olanları listeleyiniz.
 
 SELECT * FROM CUSTOMERS C
 INNER JOIN CITIES CT ON CT.ID = C.CITYID
 INNER JOIN DISTRICTS D ON D.ID = C.DISTRICTID
 WHERE CITY = 'ÝSTANBUL' AND D.DISTRICT <> 'KADIKÖY'

 --SUBQUERY YÖNTEMÝ ÝLE

 SELECT * FROM CUSTOMERS
 WHERE CITYID IN (SELECT ID FROM CITIES WHERE CITY='ÝSTANBUL')
 AND DISTRICTID NOT IN (SELECT ID FROM DISTRICTS WHERE DISTRICT='KADIKÖY')



-- Cities tablosundan “Ankara” kaydını sildiğimizi varsayalım. 
-- Bu durumda şehri “Ankara” olan müşterilerin şehir alanı boş gelecektir. 
-- şehir alanı boş olan müşterileri listeleyen sorguyu yazınız.

SELECT * FROM CITIES WHERE CITY='ANKARA'

SELECT * FROM CUSTOMERS C 
LEFT JOIN CITIES CT ON CT.ID=C.CITYID
WHERE C.CITYID IS NULL





-- Önceki soruda CITIES tablosundan silmiş olduğumuz Ankara ve İstanbul kayıtlarını aynı ID leri alacak şekilde yeniden tabloya insert ediniz.

SELECT * FROM CITIES

SET IDENTITY_INSERT CITIES ON

INSERT INTO CITIES(ID,CITY)
VALUES (6,'ANKARA')

INSERT INTO CITIES(ID,CITY)
VALUES (34,'ISTANBUL')


-- Müşterilerimizin telefon numalarının operatör bilgisini getirmek istiyoruz. 
-- TELNR1 ve TELNR2 alanlarının yanýna operatör numarasını (532),(505) gibi getirmek istiyoruz.
-- Bu sorgu için gereken SQL cümlesini yazınız.

SELECT * FROM CUSTOMERS 

SELECT *,
SUBSTRING(TELNR1,2,3) AS OPERATOR1,
SUBSTRING(TELNR2,2,3) AS OPERATOR2
FROM CUSTOMERS


-- Müşterilerimizin telefon numalarının operatör bilgisini getirmek istiyoruz. 
-- TELNR1 ve TELNR2 alanlarının yanına operatör numarasını (532),(505) gibi getirmek istiyoruz.
-- Bu sorgu için gereken SQL cümlesini yazınız.

SELECT 
SUM(TELNR1_XOPERATORCOUNT + TELNR2_XOPERATORCOUNT) AS XOPERATORTCOUNT,
SUM(TELNR1_YOPERATORCOUNT + TELNR2_YOPERATORCOUNT) AS YOPERATORTCOUNT,
SUM(TELNR1_ZOPERATORCOUNT + TELNR2_ZOPERATORCOUNT) AS ZOPERATORTCOUNT
FROM
(

SELECT 
CASE 
    WHEN TELNR1 LIKE '(50%' OR TELNR1 LIKE '(55%' THEN 1
	ELSE 0
END AS TELNR1_XOPERATORCOUNT,
CASE 
    WHEN TELNR1 LIKE '(54%' THEN 1
	ELSE 0
END AS TELNR1_YOPERATORCOUNT,
CASE 
    WHEN TELNR1 LIKE '(53%' THEN 1
	ELSE 0
END AS TELNR1_ZOPERATORCOUNT,
CASE 
    WHEN TELNR2 LIKE '(50%' OR TELNR2 LIKE '(55%' THEN 1
	ELSE 0
END AS TELNR2_XOPERATORCOUNT,
CASE 
    WHEN TELNR2 LIKE '(54%' THEN 1
	ELSE 0
END AS TELNR2_YOPERATORCOUNT,
CASE 
    WHEN TELNR2 LIKE '(53%' THEN 1
	ELSE 0
END AS TELNR2_ZOPERATORCOUNT,

 *FROM CUSTOMERS
 ) T



 -- Her ilde en çok müşteriye sahip olduðumuz ilçeleri müşteri sayısına 
 -- göre çoktan aza doðru sıralı şekilde şekildeki gibi getirmek için gereken sorguyu yazınız.

 SELECT CT.CITY, D.DISTRICT, COUNT(C.ID) AS CUSTOMERCOUNT FROM CUSTOMERS C 
 INNER JOIN CITIES CT ON CT.ID = C.CITYID
 INNER JOIN DISTRICTS D ON D.ID = C.DISTRICTID
 GROUP BY CT.CITY,D.DISTRICT
 ORDER BY CT.CITY, COUNT(C.ID) DESC



 -- Müşterilerin doğum günlerini resimdeki gibi haftanın günü olarak getiren sorguyu yazınız.

 SET LANGUAGE Turkish

 SELECT 
 DATENAME(DW,BIRTHDATE), BIRTHDATE,
 * FROM CUSTOMERS




 -- Doğum günü bugün olan müşterilerin listesini getiriniz.

 SELECT * FROM CUSTOMERS

 WHERE DATEPART (MONTH,BIRTHDATE) = DATEPART(MONTH,GETDATE())
 AND  
 DATEPART (DAY, BIRTHDATE) = DATEPART (DAY, GETDATE())
