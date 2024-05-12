-- PRACA DOMOWA LAB5 JERZY MUSZYŃSKI

-- 1. Rozwiąż nierozwiązane ćwiczenia z zajęć
-- Plik lab5.sql

-- 2. Wyznacz średnie zarobki pracowników ze względu na zakłady, o ile są to pracownicy
-- zatrudnieni przed 01.01.2020. Następnie dodatkowo ogranicz powyższe zapytanie do
-- tych zakładów, które zatrudniają więcej niż 2 takie osoby.

SELECT DEPARTMENT_ID, AVG(SALARY) AS AVG_SALARY
FROM EMPLOYEES
WHERE DATE_EMPLOYED < TO_DATE('01-01-2020', 'DD-MM-YYYY')
GROUP BY DEPARTMENT_ID
HAVING COUNT(EMPLOYEE_ID) > 2;

-- 3.* Wyznacz średnie zarobki pracowników ze względu na zakłady, o ile są to pracownicy
-- zatrudnieni przed 01.01.2010. Dodatkowo ogranicz powyższe zapytanie do tych
-- zakładów, które zatrudniają więcej niż 2 osoby (w ogóle, a nie tylko takie, które zostały
-- zatrudnione przed 01.01.2010)

SELECT DEPARTMENT_ID, ROUND(AVG(SALARY),2) AS AVG_SALARY
FROM EMPLOYEES
WHERE DATE_EMPLOYED < TO_DATE('01-01-2020', 'DD-MM-YYYY')
GROUP BY DEPARTMENT_ID
INTERSECT
SELECT DEPARTMENT_ID, ROUND(AVG(SALARY),2) AS AVG_SALARY
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING COUNT(EMPLOYEE_ID) > 2;


-- 4. Napisz zapytanie które dla każdego departamentu wyświetli średnią pensję w
-- zależności od płci.
SELECT DEPARTMENT_ID, GENDER, AVG(SALARY) AS AVG_SALARY
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID, GENDER
ORDER BY DEPARTMENT_ID NULLS LAST;

-- 5. Napisz zapytanie które pogrupuje liczby krajów ze względu na pierwszą literę nazwy
-- języka używanego w danym kraju.
SELECT SUBSTR(LANGUAGE, 0, 1) AS LANG_FIRST_LETTER, COUNT(COUNTRY_ID) AS "NUM OF COUNTRIES"
FROM COUNTRIES
GROUP BY SUBSTR(LANGUAGE, 0, 1)
ORDER BY LANG_FIRST_LETTER;

-- 6. Polecenie SELECT name, surname, COUNT(*) FROM employees GROUP BY name
-- HAVING COUNT(*) >=2; jest niepoprawne. Dlaczego ?

-- Polecenie jest niepoprawne ponieważ odwołujemy się do kolumny która nie została zgrupowana

-- Poprawne polecenie
SELECT NAME, SURNAME, COUNT(*)
FROM EMPLOYEES
GROUP BY NAME, SURNAME
HAVING COUNT(*) >= 2;

-- 7. Dla każdego departamentu zwróć informację o maksymalnej pensji pracownika
-- z tego departamentu.
SELECT  DEPARTMENT_ID, MAX(SALARY) AS MAX_SALARY
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID;

-- 8. * Ile walut jest oficjalną walutą wykorzystywaną w wiecej niż 1 kraju?
SELECT COUNT(*) AS "NUM OF CURRENCIES USED IN MORE THAN 1 COUNTRY"
FROM (SELECT CURRENCY, COUNT(COUNTRY_ID)
      FROM COUNTRIES
      GROUP BY CURRENCY
      HAVING COUNT(COUNTRY_ID) > 1);


-- 9. * Ile jest średnio zmian na stanowiskach (skorzystaj z positions_history)?
SELECT AVG(CHANGES) AS "AVERAGE POSITION CHANGES" FROM (
SELECT EMPLOYEE_ID, COUNT(POSITION_ID) AS CHANGES
FROM POSITIONS_HISTORY
GROUP BY EMPLOYEE_ID);

-- 10. Przy grupowaniu danych wykorzystując jedną kolumnę, ile powstanie grup
-- danych?

-- Powstanie dokładnie tyle grup danych ile jest unikalnych wartości w tej kolumnie