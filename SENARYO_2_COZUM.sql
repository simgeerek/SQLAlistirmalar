-- SENARYO 2

-- HR isimli bir veritabani olusturunuz ve bu veritabani içerisine gosterilen tablolari SQL kodu yazarak olusturunuz.

CREATE DATABASE HR

CREATE TABLE DEPARTMENT
(ID INT IDENTITY(1,1) PRIMARY KEY, DEPARTMENT VARCHAR(50))

CREATE TABLE POSITION
(ID INT IDENTITY(1,1) PRIMARY KEY, POSITION VARCHAR(100))

CREATE TABLE PERSON
( ID INT IDENTITY(1,1) PRIMARY KEY, 
CODE VARCHAR(10),
TCNUMBER VARCHAR(11),
NAME_ VARCHAR(50),
SURNAME VARCHAR(50),
GENDER VARCHAR(1),
BIRTHDATE DATE,
INDATE DATE,
OUTDATE DATE,
DEPARTMENTID INT,
POSITIONID INT,
PARENTPOSITIONID INT,
MANAGERID INT,
TELNR VARCHAR(15),
SALARY FLOAT)


-- Sirketimizde halen calismaya devam eden caliþsnlarin listesini getiren sorgu hangisidir?
-- Not:Isten cikis tarihi bos olanlar calýsmaya devam eden calisanlardir.

SELECT * FROM PERSON WHERE OUTDATE IS NULL



-- Sirketimizde departman bazli halen calismaya devam eden calýsan sayisini getiren sorguyu yaziniz?

SELECT D.DEPARTMENT,COUNT(P.ID) AS PERSONCOUNT
FROM PERSON P
INNER JOIN DEPARTMENT D ON D.ID = P.DEPARTMENTID

WHERE P.OUTDATE IS NULL

GROUP BY D.DEPARTMENT
ORDER BY PERSONCOUNT




-- Þirketimizde departman bazli halen calýsmaya devam KADIN ve ERKEK sayilarini sekildeki gibi getiren sorguyu yaziniz.

SELECT D.DEPARTMENT, GENDER,COUNT(P.ID) AS PERSONCOUNT
FROM PERSON P
INNER JOIN DEPARTMENT D ON D.ID = P.DEPARTMENTID

WHERE P.OUTDATE IS NULL

GROUP BY D.DEPARTMENT, GENDER
ORDER BY D.DEPARTMENT, GENDER




-- Þirketimizde departman bazli halen çalýþmaya devam KADIN ve ERKEK sayilarini þekildeki gibi getiren sorguyu yaziniz.

SELECT *,
(SELECT COUNT(*) FROM PERSON WHERE DEPARTMENTID = D.ID AND GENDER='E' AND  OUTDATE IS NULL) AS MALE_PERSONCOUNT,
(SELECT COUNT(*) FROM PERSON WHERE DEPARTMENTID = D.ID AND GENDER='K' AND  OUTDATE IS NULL) AS FEMALE_PERSONCOUNT
FROM DEPARTMENT D




-- Þirketimizin Planlama departmanýna yeni bir þef atamasý yapildi ve maasini belirlemek istiyoruz. 
-- Planlama departmani için minimum,maximum ve ortalama sef maasi getiren sorgu hangisidir? 
-- (Not:iþten cikmis olan personel maaþlari da dahildir.)

SELECT POS.POSITION, MIN(P.SALARY) AS MIN_SALARY,
MAX(P.SALARY) AS MAX_SALARY,
ROUND(AVG(P.SALARY),0) AS AVG_SALARY
FROM POSITION POS
INNER JOIN PERSON P ON P.POSITIONID = POS.ID
WHERE POSITION = 'PLANLAMA ÞEFÝ'
GROUP BY POS.POSITION




-- Her bir pozisyonda mevcut halde calisanlar olarak kaç kisi ve ortalama maaslarinin ne kadar oldugunu listelettirmek istiyoruz. 
-- Bu sonucu getiren sorguyu yaziniz.

SELECT POSITION,COUNT(*) AS PERSON_COUNT, ROUND(AVG(P.SALARY) ,0) AS AVG_SALARY FROM POSITION POS
INNER JOIN PERSON P ON P.POSITIONID = POS.ID
GROUP BY POSITION




-- Yillara göre ise alinan personel sayisini kadin ve erkek bazinda listelettiren sorguyu yaziniz.

SELECT DISTINCT YEAR(P.INDATE) YEAR_,
(SELECT COUNT(*) FROM PERSON WHERE GENDER = 'E' AND YEAR(INDATE) = YEAR(P.INDATE)) AS MALE_PERSON,
(SELECT COUNT(*) FROM PERSON WHERE GENDER = 'K' AND YEAR(INDATE) = YEAR(P.INDATE)) AS FEMALE_PERSON
FROM PERSON P
ORDER BY 1




-- Her bir personelimizin ne kadar zamandir calistiði bilgisini sekildeki gibi ay olarak getiren sorguyu yaziniz.

SELECT P.NAME_ + ' ' + P.SURNAME  AS PERSON,
INDATE,OUTDATE,
CASE 
    WHEN OUTDATE IS NOT NULL THEN DATEDIFF(MONTH,INDATE,OUTDATE)
	ELSE DATEDIFF(MONTH,INDATE,GETDATE())
END AS WORKINGTIME
FROM PERSON P





-- Þirketimiz 5. Yilinda ustunde herkesin isminin ve soyisminin baþ harflerinin bulunduðu bir ajanda bastirip calisanlarýna hediye edecektir.
-- Bunun için hangi harf kombinasyonundan en az ne kadar sayida ajanda bastirilacaði sorusunun cevabini getiren sorguyu yaziniz.
-- Not:Ýki isimli olanlarin birinci isminin baþ harfi kullanilacaktir.

SELECT 
SUBSTRING (NAME_,1,1) + '.' + SUBSTRING (SURNAME,1,1)+'.' SHORTNAME,
COUNT(*) PERSONCOUNT
FROM PERSON

GROUP BY SUBSTRING(NAME_,1,1) + '.' + SUBSTRING (SURNAME,1,1)+'.'
ORDER BY COUNT(*) DESC





--  Maas ortalamasi 5.500 TL’den fazla olan departmanlari listeleyecek sorguyu yaziniz.

SELECT
D.DEPARTMENT, AVG(P.SALARY) AS AVGSALARY
FROM DEPARTMENT D
INNER JOIN PERSON P ON P.DEPARTMENTID = D.ID
GROUP BY D.DEPARTMENT
HAVING AVG(P.SALARY) > 5500




-- Departmanlarin ortalama kidemini ay olarak hesaplayacak ve sekildeki gibi cekecek sorguyu yaziniz.

SELECT  DEPARTMENT D, AVG(WORKINGTIME)
FROM
(
SELECT D.DEPARTMENT,
CASE WHEN OUTDATE IS NOT NULL THEN DATEDIFF(MONTH,INDATE,OUTDATE)
ELSE DATEDIFF (MONTH,INDATE,GETDATE()) END AS WORKINGTIME
FROM PERSON P
INNER JOIN DEPARTMENT D ON P.DEPARTMENTID = D.ID
) T GROUP BY DEPARTMENT
ORDER BY 1



-- Her personelin adini, pozisyonunu baðli oldugu birim yoneticisinin adini ve pozisyonunu sekildeki gibi getiren sorguyu yaziniz.

SELECT 

P.NAME_ + ' ' + P.SURNAME AS PERSON,POS.POSITION,
P2.NAME_ + ' ' + P2.SURNAME AS MANAGERNAME ,POS2.POSITION AS MANAGERPOSITION
FROM PERSON P
INNER JOIN POSITION POS ON POS.ID = P.POSITIONID
INNER JOIN PERSON P2 ON P.MANAGERID = P2.ID
INNER JOIN POSITION POS2 ON POS2.ID = P2.POSITIONID


--