
-- SENARYO 4

-- Arac markalarina gore her markadan ne kadar arac oldugu bilgisini sekildeki gibi getiren sorguyu yaziniz.

SELECT BRAND, count(*) as COUNT FROM WEBOFFERS
GROUP BY BRAND


-- Arac markalarýna göre her markadan ne kadar arac oldugu ve yuzdesel olarak toplamin ne kadarina tekabul ettigi bilgisini sekildeki gibi getiren sorguyu yaziniz.

SELECT BRAND, count(*) AS COUNT_ ,
ROUND(
CONVERT(FLOAT,COUNT(*))/(SELECT COUNT(*) FROM WEBOFFERS)*100,2) AS PERCENT_
FROM WEBOFFERS
GROUP BY BRAND


-- Hangi sehirde ne kadar arac ilaný oldugu bilgisini sekildeki gibi getiren sorguyu yaziniz.

SELECT C.CITY, COUNT(O.ID) AS COUNT_ FROM WEBOFFERS O 
INNER JOIN USER_ U ON U.ID = O.USERID
INNER JOIN CITY C ON C.ID = O.CITYID
INNER JOIN TOWN T ON T.ID = O.TOWNID
INNER JOIN DISTRICT D ON D.ID = O.DISTRICTID
GROUP BY C.CITY
ORDER BY 2 DESC

--2.yontem

SELECT CITY,
(SELECT COUNT(*) FROM WEBOFFERS WHERE CITYID = CITY.ID) AS COUNT_
FROM CITY
ORDER BY 2 DESC



-- Ýstanbul’da Volkswagen Passat marka bir araç arýyoruz. Kriterlerimiz þu þekilde.
-- Kimden:Sahibinden
-- Model:2014-2018 arasý
-- Vites:Otomatik
-- Yakýt:Dizel
-- Sýralama:Kilometre ve fiyata göre

SELECT U.NAMESURNAME, C.CITY, T.TOWN, D.DISTRICT, O.TITLE,
O.BRAND, O.MODEL, O.PRICE,O.YEAR_,O.KM,O.FUEL, O.SHIFTTYPE,O.COLOR
FROM WEBOFFERS O
INNER JOIN USER_ U ON U.ID = O.USERID
INNER JOIN CITY C ON C.ID = O.CITYID
INNER JOIN TOWN T ON T.ID = O.TOWNID
INNER JOIN DISTRICT D ON D.ID = O.DISTRICTID
WHERE C.CITY = 'ÝSTANBUL'
AND O.SHIFTTYPE IN ('Yarý Otomatik Vites','Otomatik Vites')
AND O.BRAND = 'Volkswagen' AND O.MODEL = 'Passat'
AND o.FUEL = 'Dizel' AND O.FROMWHO = 'Sahibinden'
AND O.YEAR_ BETWEEN 2014 AND 2018
ORDER BY KM,PRICE




-- BMW marka araçlari Ankara, istanbul ve izmir'de listelettiren sorguyu yaziniz.
-- Burada sorguya gonderilen þehir isimleri teker teker degil virgul ile birlestirilerek gonderilecek. ‘Ankara,Ýstanbul,Ýzmir’ seklinde.

SELECT U.NAMESURNAME, C.CITY, T.TOWN, D.DISTRICT, O.TITLE,
O.BRAND, O.MODEL, O.PRICE,O.YEAR_,O.KM,O.FUEL, O.SHIFTTYPE,O.COLOR, O.VARYANT
FROM WEBOFFERS O
INNER JOIN USER_ U ON U.ID = O.USERID
INNER JOIN CITY C ON C.ID = O.CITYID
INNER JOIN TOWN T ON T.ID = O.TOWNID
INNER JOIN DISTRICT D ON D.ID = O.DISTRICTID
WHERE O.BRAND = 'BMW'
AND C.CITY IN
(SELECT value FROM string_split('ANKARA, ÝSTANBUL,ÝZMÝR',','))



