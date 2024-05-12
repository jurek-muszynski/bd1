-- ĆWICZENIA CROSS JOIN


-- 1. Pokaż wszystkie kombinacje pracowników (employees) oraz uzyskanych
-- ocen z oceny rocznej (grades). Pokaż identyfikator pracownika oraz ocenę
-- liczbową i jej opis

SELECT EMPLOYEES.EMPLOYEE_ID, GRADES.GRADE, GRADES.DESCRIPTION
FROM EMPLOYEES CROSS JOIN GRADES;

-- 2. Zmodyfikuj poprzednie zapytanie tak aby pokazać tylko pracowników z
-- departamentów 101, 102, 103 lub bez departamentu.

SELECT EMPLOYEES.EMPLOYEE_ID, GRADES.GRADE, GRADES.DESCRIPTION
FROM EMPLOYEES CROSS JOIN GRADES
WHERE EMPLOYEES.DEPARTMENT_ID IN (101, 102, 103) OR EMPLOYEES.DEPARTMENT_ID IS NULL;

-- ĆWICZENIA INNER JOIN


--  Zwróć id, imię i nazwisko pracowników wraz z informacją o id
-- i nazwie departamentu, w którym pracuje.

-- V1
SELECT E.EMPLOYEE_ID, E.NAME, E.SURNAME, D.DEPARTMENT_ID, D.NAME
FROM EMPLOYEES E JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID

-- V2
SELECT E.EMPLOYEE_ID, E.NAME, E.SURNAME, DEPARTMENT_ID, D.NAME
FROM EMPLOYEES E JOIN DEPARTMENTS D USING (DEPARTMENT_ID);

-- V3
SELECT E.EMPLOYEE_ID, E.NAME, E.SURNAME, D.DEPARTMENT_ID, D.NAME
FROM EMPLOYEES E, DEPARTMENTS D
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID;

-- Zwróć id, imię i nazwisko kobiet pracowników wraz z informacją
-- o id i nazwie departamentu, w którym pracuje,
-- jeśli ten departament został założony po 2005 roku.

SELECT E.EMPLOYEE_ID, E.NAME, E.SURNAME, D.DEPARTMENT_ID, D.NAME
FROM EMPLOYEES E JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE E.GENDER = 'K' AND EXTRACT(YEAR FROM D.ESTABLISHED) > 2005;

-- Napisz zapytanie zwracające wynik złączenia naturalnego tabel kraje i adresy.
-- Jakie kolumny będą w wyniku?

SELECT *
FROM COUNTRIES NATURAL JOIN ADDRESSES;


-- ĆWICZENIA INNER JOIN

-- 1. Znajdź pracowników, których zarobki nie są zgodne z “widełkami” na jego
-- stanowisku. Zwróć imię, nazwisko, wynagrodzenie oraz nazwę stanowiska

SELECT E.NAME, E.SURNAME, E.SALARY, P.NAME
FROM EMPLOYEES E INNER JOIN JMUSZYNS.POSITIONS P on E.POSITION_ID = P.POSITION_ID
WHERE E.SALARY NOT BETWEEN P.MIN_SALARY AND P.MAX_SALARY;


-- Zmodyfikuj poprzednie zapytanie tak, aby dodatkowo wyświetlić informacje
-- o nazwie zakładu pracownika

SELECT E.NAME AS NAME, E.SURNAME, E.SALARY, P.NAME AS POSITION_NAME, D.NAME AS DEPARTMENT_NAME
FROM EMPLOYEES E
    INNER JOIN JMUSZYNS.POSITIONS P on E.POSITION_ID = P.POSITION_ID
    INNER JOIN JMUSZYNS.DEPARTMENTS D on E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE E.SALARY NOT BETWEEN P.MIN_SALARY AND P.MAX_SALARY;


-- 3. Wyświetl nazwę zakładu wraz z imieniem i nazwiskiem jego kierowników.
-- Pokaż tylko zakłady, które mają budżet pomiędzy 5000000 i 10000000

SELECT D.NAME AS DEPARTMENT_NAME, E.NAME AS MANAGER_NAME, E.SURNAME AS MANAGER_SURNAME
FROM DEPARTMENTS D
    INNER JOIN EMPLOYEES E ON D.MANAGER_ID = E.EMPLOYEE_ID
WHERE D.YEAR_BUDGET BETWEEN 5000000 AND 10000000;

-- 4. Znajdź zakłady (podaj ich nazwę), które mają swoje siedziby w Polsce

SELECT D.NAME AS DEPARTMENT_NAME
FROM DEPARTMENTS D
    INNER JOIN ADDRESSES A ON D.ADDRESS_ID = A.ADDRESS_ID
    INNER JOIN COUNTRIES C on A.COUNTRY_ID = C.COUNTRY_ID
WHERE C.NAME = 'Polska';

-- 5. Zmodyfikuj zapytanie 3 tak, aby uwzględniać w wynikach tylko zakłady,
-- które mają siedziby w Polsce.

SELECT D.NAME AS DEPARTMENT_NAME, E.NAME AS MANAGER_NAME, E.SURNAME AS MANAGER_SURNAME
FROM DEPARTMENTS D
    INNER JOIN EMPLOYEES E ON D.MANAGER_ID = E.EMPLOYEE_ID
    INNER JOIN ADDRESSES A on D.ADDRESS_ID = A.ADDRESS_ID
    INNER JOIN JMUSZYNS.COUNTRIES C2 on A.COUNTRY_ID = C2.COUNTRY_ID
WHERE D.YEAR_BUDGET BETWEEN 5000000 AND 10000000 AND C2.NAME = 'Polska';

-- 6. Pokaż oceny (grades) pracowników którzy nie posiadają kierownika. W
-- wynikach pokaż imie , nazwisko pracownika, ocene liczbowa i jej opis.

SELECT E.NAME AS EMPLOYEE_NAME, E.SURNAME AS EMPLOYEE_SURNAME, G.GRADE AS GRADE, G.DESCRIPTION AS GRADE_DESC
FROM EMPLOYEES E
    INNER JOIN EMP_GRADES EG on E.EMPLOYEE_ID = EG.EMPLOYEE_ID
    INNER JOIN GRADES G ON EG.GRADE_ID = G.GRADE_ID
WHERE E.MANAGER_ID IS NULL;

-- 7. Pokaż nazwę kraju i nazwę regionu do którego został przypisany.

SELECT C.NAME AS COUNTRY_NAME, RG.NAME AS REGION_NAME
FROM COUNTRIES C
    INNER JOIN REG_COUNTRIES RGC ON C.COUNTRY_ID = RGC.COUNTRY_ID
    INNER JOIN JMUSZYNS.REGIONS RG on RGC.REGION_ID = RG.REGION_ID;

-- ĆWICZENIA OUTER JOIN

-- Zwróć id, imię i nazwisko pracownika wraz z informacją o id i nazwie
-- departamentu, w którym pracuje. Uwzględnij pracowników, którzy nie pracują w
-- żadnym departamencie.

SELECT E.EMPLOYEE_ID, E.NAME, E.SURNAME, D.DEPARTMENT_ID, D.NAME
FROM EMPLOYEES E
    LEFT OUTER JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;

-- Zwróć id, imię i nazwisko pracownika wraz z informacją o id i nazwie
-- departamentu, w którym pracuje. Uwzględnij departamenty, w których
-- nie ma żadnego pracownika.

SELECT E.EMPLOYEE_ID, E.NAME, E.SURNAME, D.DEPARTMENT_ID, D.NAME
FROM EMPLOYEES E
    RIGHT OUTER JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;

-- ĆWICZENIA OUTER JOIN

-- 1. Wyświetl listę zawierającą nazwisko pracownika, stanowisko, na którym
-- pracuje, aktualne zarobki oraz widełki płacowe dla tego stanowiska.
-- Sterując rodzajem złączenia, zagwarantuj, że w wynikach znajdą się
-- wszyscy pracownicy.

SELECT E.SURNAME, P.NAME, E.SALARY, P.MIN_SALARY, P.MAX_SALARY
FROM EMPLOYEES E
    LEFT OUTER JOIN JMUSZYNS.POSITIONS P on E.POSITION_ID = P.POSITION_ID;

-- 2. Wyświetl średnią pensję oraz liczbę osób zatrudnionych dla stanowisk.
-- Sterując rodzajem złączenia zagwarantuj, że znajdą się tam również
-- stanowiska, na których nikt nie jest zatrudniony.

SELECT P.NAME, ROUND(AVG(E.SALARY)) AS AVG_SALARY, COUNT(E.EMPLOYEE_ID) AS NUM_OF_EMPLOYEES
FROM EMPLOYEES E
    FULL OUTER JOIN POSITIONS P on E.POSITION_ID = P.POSITION_ID
GROUP BY P.NAME;

-- 3. Dla każdego projektu pokaż liczbę pracowników zatrudnionych kiedykolwiek
-- w tym projekcie. Zadbaj by w wynikach pojawił się każdy projekt (nawet bez
-- pracowników).

SELECT P.NAME AS PROJECT_NAME, COUNT(PEMP.EMPLOYEE_ID) AS NUM_OF_EMP
FROM PROJECTS P
    LEFT OUTER JOIN EMP_PROJECTS PEMP ON P.PROJECT_ID = PEMP.PROJECT_ID
GROUP BY P.NAME;

-- 4. Pokaż średnią ocenę pracowników per departament (uwzględnij wszystkie
-- departamenty). W wynikach zamiesc nazwe departamentu i srednia ocene.

SELECT D.NAME AS DEP_NAME, ROUND(AVG(G.GRADE),2) AS AVG_GRADE
FROM DEPARTMENTS D
    LEFT OUTER JOIN EMPLOYEES E ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
    LEFT OUTER JOIN EMP_GRADES EG ON E.EMPLOYEE_ID = EG.EMPLOYEE_ID
    LEFT OUTER JOIN JMUSZYNS.GRADES G on EG.GRADE_ID = G.GRADE_ID
GROUP BY D.NAME;


-- Wyświetl imiona, nazwiska i pensje wszystkich pracowników, którzy zarabiają więcej lub
-- tyle samo od pracownika o nazwisku King. W wyniku pokaż również pensję
-- pracownika ‘King’.

SELECT E1.NAME, E1.SURNAME, E1.SALARY, E2.SALARY AS THRESHOLD
FROM EMPLOYEES E1
    JOIN EMPLOYEES E2 ON E1.SALARY >= E2.SALARY AND E2.SURNAME = 'King'


-- Dla każdego pracownika zwróć konkatenację imienia i nazwiska jego szefa.

SELECT E1.NAME AS EMP_NAME, CONCAT(CONCAT(E2.NAME, ' '), E2.SURNAME) AS EMP_MANAGER
FROM EMPLOYEES E1 JOIN EMPLOYEES E2 ON E1.MANAGER_ID = E2.EMPLOYEE_ID;

-- ĆWICZENIA JOIN & GROUP

-- 1. Dla każdego imienia pracownika z zakładów Administracja lub Marketing zwróć
-- liczbę pracowników, którzy mają takie samo imię i podaj ich średnie zarobki.

SELECT E1.NAME, ROUND(AVG(E1.SALARY),2) AS AVG_SALARY
FROM EMPLOYEES E1
    JOIN EMPLOYEES E2 ON E1.NAME = E2.NAME
    INNER JOIN DEPARTMENTS D ON E1.DEPARTMENT_ID = D.DEPARTMENT_ID
    WHERE D.NAME IN ('Administracja', 'Marketing')
GROUP BY E1.NAME;

-- 2. Zwróć imiona i nazwiska pracowników, którzy przeszli więcej niż 2 zmiany
-- stanowiska. Wyniki posortuj malejąco wg liczby zmian.

SELECT E.NAME, E.SURNAME, COUNT(*) AS CHANGED_POSITIONS
FROM EMPLOYEES E
    JOIN POSITIONS_HISTORY PHIS ON E.EMPLOYEE_ID = PHIS.EMPLOYEE_ID
GROUP BY E.NAME, E.SURNAME
HAVING COUNT(*) > 2;

-- 3. Zwróć id, nazwisko kierowników oraz liczbę podległych pracowników. Wyniki
-- posortuj malejąco wg liczby podległych pracowników (wraz z tymi, którzy nie mają żadnych podległych pracowników).

SELECT E1.EMPLOYEE_ID AS MANAGER_ID, E1.SURNAME, COUNT(E2.EMPLOYEE_ID) AS NUM_OF_MANAGED_EMPLOYEES
FROM EMPLOYEES E1
    LEFT OUTER JOIN EMPLOYEES E2 ON E1.EMPLOYEE_ID = E2.MANAGER_ID
GROUP BY E1.EMPLOYEE_ID, E1.SURNAME
ORDER BY NUM_OF_MANAGED_EMPLOYEES DESC;

-- 4. Napisz zapytanie zwracające liczbę zakładów w krajach. W wynikach podaj
-- nazwę kraju oraz jego ludność.

SELECT C.NAME, C.POPULATION, COUNT(DEPARTMENT_ID) AS NUM_OF_DEPARTMENTS
FROM COUNTRIES C
    LEFT OUTER JOIN JMUSZYNS.ADDRESSES A2 on C.COUNTRY_ID = A2.COUNTRY_ID
    LEFT OUTER JOIN JMUSZYNS.DEPARTMENTS D on A2.ADDRESS_ID = D.ADDRESS_ID
GROUP BY C.NAME, C.POPULATION
ORDER BY NUM_OF_DEPARTMENTS DESC;

-- 5. Napisz zapytanie zwracające liczbę zakładów w regionach. W wynikach podaj
-- nazwę regionu. Wynik posortuj malejąco względem liczby zakładów

SELECT R.NAME, COUNT(DEPARTMENT_ID) AS NUM_OF_DEPARTMENTS
FROM REGIONS R
    LEFT OUTER JOIN REG_COUNTRIES RGC ON R.REGION_ID = RGC.REGION_ID
    LEFT OUTER JOIN ADDRESSES A ON RGC.COUNTRY_ID = A.COUNTRY_ID
    LEFT OUTER JOIN DEPARTMENTS D ON A.ADDRESS_ID = D.ADDRESS_ID
GROUP BY R.NAME
ORDER BY NUM_OF_DEPARTMENTS DESC;

