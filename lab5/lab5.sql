-- LAB5 JERZY MUSZYŃSKI

-- ĆWICZENIA GROUP BY

-- 1. Przygotuj zapytanie, które wyświetli informację ilu pracowników ma aktualnie dany status_id
-- (Status_ID odwołujący się do tabeli EMP_STATUS).

SELECT STATUS_ID, COUNT(*) AS "EMPLOYEES WITH A PART. STATUS ID"
FROM EMPLOYEES
GROUP BY STATUS_ID;

-- 2. Zmodyfikuj poprzednie zapytanie, żeby pokazać jedynie liczbę kobiet będących w danym statusie.

SELECT STATUS_ID, COUNT(*) AS "EMPLOYEES WITH A PART. STATUS ID"
FROM EMPLOYEES
WHERE GENDER = 'K'
GROUP BY STATUS_ID;

-- 3. Wyświetl minimalne, maksymalne zarobki, a także średnią, medianę i odchylenie standardowe
-- zarobków pracowników na każdym ze stanowisk (wykorzystaj tylko tabelę Employees).

SELECT POSITION_ID, MIN(SALARY) AS "MIN SALARY", MAX(SALARY) AS "MAX SALARY", AVG(SALARY) AS "AVERAGE SALARY", MEDIAN(SALARY) AS "MEDIAN SALARY", STDDEV(SALARY)
FROM EMPLOYEES
WHERE POSITION_ID IS NOT NULL
GROUP BY POSITION_ID

-- 4. Napisz zapytanie, które dla określonego języka zwróci: liczbę krajów które używają tego języka,
-- średnią populację.

SELECT LANGUAGE, COUNT(COUNTRY_ID) "OFFICIAL IN", AVG(POPULATION) AS "AVERAGE POPULATION"
FROM COUNTRIES
GROUP BY LANGUAGE;

-- 5. Dla każdej z płci oblicz średnią pensję, średni wiek oraz średnią długość zatrudnienia. Wyniki
-- posortuj względem średniej pensji malejąco.

SELECT GENDER, ROUND(AVG(SALARY),2) AS "AVERAGE SALARY", ROUND(AVG((CURRENT_DATE - BIRTH_DATE)/365),2) AS "AVERAGE AGE", ROUND(AVG((CURRENT_DATE - EMPLOYEES.DATE_EMPLOYED)/365),2) AS "AVERAGE EMPLOYEMENT TIME"
FROM EMPLOYEES
GROUP BY GENDER
ORDER BY "AVERAGE SALARY" DESC;

-- 6. Oblicz liczbę założonych departamentów w każdym roku.
SELECT EXTRACT(YEAR FROM ESTABLISHED) AS "YEAR OF ESTABLISHMENT", COUNT(DEPARTMENT_ID) AS "NUMBER OF ESTABLISHED DEPARTMENTS"
FROM DEPARTMENTS
GROUP BY EXTRACT(YEAR FROM ESTABLISHED);

-- 7. Oblicz liczbę pracowników zatrudnionych każdego miesiąca(sty, lu, ma..)
SELECT EXTRACT(MONTH FROM DATE_EMPLOYED) AS "MONTH", COUNT(EMPLOYEE_ID) AS "NUMBER OF EMPLOYED"
FROM EMPLOYEES
GROUP BY EXTRACT(MONTH FROM DATE_EMPLOYED)
ORDER BY EXTRACT(MONTH FROM DATE_EMPLOYED)

-- ĆWICZENIA HAVING

-- 1. Wyświetl informacje o liczbie krajów mających dany język jako urzędowy. Pokaż języki które
-- są wykorzystane przez przynajmniej 2 kraje.

SELECT LANGUAGE, COUNT(COUNTRY_ID) AS "NUM OF COUNTRIES"
FROM COUNTRIES
GROUP BY LANGUAGE
HAVING COUNT(COUNTRY_ID) > 1;

-- 2. Wyświetl średnie zarobki dla każdego ze stanowisk, o ile średnie te są większe od 2000.
SELECT POSITION_ID, AVG(SALARY) AS "AVERAGE SALARY"
FROM EMPLOYEES
GROUP BY POSITION_ID
HAVING AVG(SALARY) > 2000;

-- 3. Wyświetl średnie zarobki dla każdego ze stanowisk, o ile średnie te są większe od 2000 i liczba
-- pracowników na danym stanowisku jest większa niż 1.

SELECT  POSITION_ID, AVG(SALARY) AS "AVERAGE SALARY"
FROM EMPLOYEES
GROUP BY POSITION_ID
HAVING AVG(SALARY) > 2000 AND COUNT(EMPLOYEE_ID) > 1;


-- 4. Wyświetl średnie zarobki dla wszystkich pracowników pogrupowane ze względu na kolumny
-- Department_ID, Status_ID, o ile ich Status_ID = 301 lub 304. Porównaj rezultaty zapytania jeśli
-- warunek ograniczający Status_ID jest umieszczony:

-- a. w klauzuli WHERE,
SELECT DEPARTMENT_ID, STATUS_ID, AVG(SALARY) AS "AVERAGE SALARY"
FROM EMPLOYEES
WHERE STATUS_ID IN (301, 304)
GROUP BY DEPARTMENT_ID, STATUS_ID;

-- b. w klauzuli HAVING.
SELECT DEPARTMENT_ID, STATUS_ID, AVG(SALARY) AS "AVERAGE SALARY"
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID, STATUS_ID
HAVING STATUS_ID IN (301, 304);

-- WYNIKI IDENTYCZNE

-- ĆWICZENIA - UNION (ALL), INTERSECT, MINUS

-- 1. Napisz polecenie które zwróci nazwę regionu i jego nazwę skróconą oraz nazwę kraju oraz jego
-- nazwę skróconą. Rozróżnij regiony od krajów dodając kolumnę rodzaj przyjmującą wartości “R” dla
-- regionów i “K” dla krajów

SELECT NAME, SHORTNAME, 'R' AS TYPE
FROM REGIONS
UNION
SELECT NAME, CODE, 'K' AS TYPE
FROM COUNTRIES;

-- 2. Napisz polecenie które zwróci imię nazwisko i wiek pracowników oraz imię, nazwisko i wiek dzieci
-- pracowników. Rozróżnij pracowników od dzieci dodając kolumnę rodzaj przyjmującą wartości “P” dla
-- pracowników i “D” dla dzieci.

SELECT NAME, SURNAME, ROUND((CURRENT_DATE - EMPLOYEES.BIRTH_DATE)/365) AS AGE, 'P' AS "TYPE"
FROM EMPLOYEES
UNION
SELECT NAME, SURNAME, ROUND((CURRENT_DATE - DEPENDENTS.BIRTH_DATE)/365) AS AGE, 'D' AS "TYPE"
FROM DEPENDENTS


-- 3. Korzystając z operatora UNION napisz zapytanie, które zwróci id, imię i nazwisko wszystkich
-- pracowników pracujących w zakładzie o ID = 101 lub na stanowisku o ID = 103. (Jak mozna to
-- inaczej zapisac? Jak myslisz która wersja jest wydajniejsza?)

-- Z UNION
SELECT EMPLOYEE_ID, NAME, SURNAME
FROM EMPLOYEES
WHERE DEPARTMENT_ID = 101
UNION
SELECT EMPLOYEE_ID, NAME, SURNAME
FROM EMPLOYEES
WHERE DEPARTMENT_ID = 103;

-- BEZ UNION
SELECT EMPLOYEE_ID, NAME, SURNAME
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN (101, 103);

-- 4. Korzystając z operatora INTERSECT pokaż nazwy wszystkich stanowisk, które rozpoczynają się od
-- liter P, K lub A, a minimalne zarobki (według tabeli POSITIONS) są dla nich większe lub równe 1500.

SELECT NAME
FROM POSITIONS
WHERE MIN_SALARY >= 1500
INTERSECT
SELECT NAME
FROM POSITIONS
WHERE SUBSTR(NAME, 0, 1) IN ('A', 'K', 'P');

-- 5. Z zastosowaniem operatora MINUS wyświetl średnie zarobki (dla tabeli Employees) dla wszystkich
-- stanowisk z wyłączeniem stanowiska o ID = 102. Posortuj rezultat malejąco według średnich
-- zarobków.

SELECT POSITION_ID, AVG(SALARY) AS AVG_SALARY
FROM EMPLOYEES
GROUP BY POSITION_ID
MINUS
SELECT POSITION_ID, AVG(SALARY) AS AVG_SALARY
FROM EMPLOYEES
WHERE POSITION_ID = 102
GROUP BY POSITION_ID
ORDER BY AVG_SALARY DESC NULLS LAST;

