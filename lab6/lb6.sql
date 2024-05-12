-- CROSS JOIN

SELECT
    E.EMPLOYEE_ID, G.GRADE, G.DESCRIPTION
FROM EMPLOYEES E CROSS JOIN GRADES G
WHERE E.DEPARTMENT_ID IN (101, 102, 103) OR E.DEPARTMENT_ID IS NULL;

-- INNER JOIN

--  Znajdź pracowników, których zarobki nie są zgodne z “widełkami” na jego
-- stanowisku. Zwróć imię, nazwisko, wynagrodzenie oraz nazwę stanowiska

SELECT E.NAME, E.SURNAME, E.SALARY, P.NAME
FROM EMPLOYEES E
    JOIN POSITIONS P on E.POSITION_ID = P.POSITION_ID
WHERE E.SALARY NOT BETWEEN P.MIN_SALARY AND P.MAX_SALARY;

-- 2. Zmodyfikuj poprzednie zapytanie tak, aby dodatkowo wyświetlić informacje
-- o nazwie zakładu pracownika
SELECT E.NAME, E.SURNAME, E.SALARY, P.NAME AS POS_NAME, D.NAME AS DEP_NAME
FROM EMPLOYEES E
    INNER JOIN POSITIONS P on E.POSITION_ID = P.POSITION_ID
    INNER JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE E.SALARY NOT BETWEEN P.MIN_SALARY AND P.MAX_SALARY;

-- 3. Wyświetl nazwę zakładu wraz z imieniem i nazwiskiem jego kierowników.
-- Pokaż tylko zakłady, które mają budżet pomiędzy 5000000 i 10000000

SELECT D.NAME, E.NAME, E.SURNAME, D.YEAR_BUDGET
FROM DEPARTMENTS D
     JOIN EMPLOYEES E ON D.MANAGER_ID = E.EMPLOYEE_ID
WHERE D.YEAR_BUDGET BETWEEN 5000000 AND 10000000;

-- 4. Znajdź zakłady (podaj ich nazwę), które mają swoje siedziby w Polsce
-- USING łączy kolummy
SELECT D.NAME, A.ADDRESS_ID
FROM DEPARTMENTS D
    INNER JOIN ADDRESSES A ON A.ADDRESS_ID = D.ADDRESS_ID
    INNER JOIN COUNTRIES C ON A.COUNTRY_ID = C.COUNTRY_ID
WHERE C.NAME = 'Polska'

-- 5. Zmodyfikuj zapytanie 3 tak, aby uwzględniać w wynikach tylko zakłady,
-- które mają siedziby w Polsce

SELECT D.NAME, E.NAME, E.SURNAME, D.YEAR_BUDGET
FROM DEPARTMENTS D
    JOIN EMPLOYEES E ON D.MANAGER_ID = E.EMPLOYEE_ID
    JOIN ADDRESSES A on A.ADDRESS_ID = D.ADDRESS_ID
    JOIN COUNTRIES C ON A.COUNTRY_ID = C.COUNTRY_ID
WHERE D.YEAR_BUDGET BETWEEN 5000000 AND 10000000 AND C.NAME = 'Polska';

-- 6. Pokaż oceny (grades) pracowników którzy nie posiadają kierownika. W
-- wynikach pokaż imie , nazwisko pracownika, ocene liczbowa i jej opis.

SELECT E.NAME, E.SURNAME, G.GRADE, G.DESCRIPTION
FROM EMPLOYEES E
    JOIN EMP_GRADES EMPG ON E.EMPLOYEE_ID = EMPG.EMPLOYEE_ID
    JOIN GRADES G ON EMPG.GRADE_ID = G.GRADE_ID
WHERE E.MANAGER_ID IS NULL;

-- 7. Pokaż nazwę kraju i nazwę regionu do którego został przypisany.
SELECT C.NAME AS COUNTRY, R.NAME AS REGION
FROM COUNTRIES C
    JOIN REG_COUNTRIES RC ON C.COUNTRY_ID = RC.COUNTRY_ID
    JOIN REGIONS R ON RC.REGION_ID = R.REGION_ID;


-- OUTER JOINS

-- 1. Wyświetl listę zawierającą nazwisko pracownika, stanowisko, na którym
-- pracuje, aktualne zarobki oraz widełki płacowe dla tego stanowiska.
-- Sterując rodzajem złączenia, zagwarantuj, że w wynikach znajdą się
-- wszyscy pracownicy.

SELECT E.SURNAME, P.NAME, E.SALARY, P.MIN_SALARY, P.MAX_SALARY
FROM EMPLOYEES E
    LEFT JOIN POSITIONS P ON E.POSITION_ID = P.POSITION_ID;

-- 2. Wyświetl średnią pensję oraz liczbę osób zatrudnionych dla stanowisk.
-- Sterując rodzajem złączenia zagwarantuj, że znajdą się tam również
-- stanowiska, na których nikt nie jest zatrudniony

SELECT P.NAME, ROUND(AVG(E.SALARY),2) AS AVG_SALARY, COUNT(E.EMPLOYEE_ID) AS NUM_OF_EMPLOYEES
FROM POSITIONS P
    LEFT JOIN EMPLOYEES E on P.POSITION_ID = E.POSITION_ID
GROUP BY P.NAME;


-- 3. Dla każdego projektu pokaż liczbę pracowników zatrudnionych kiedykolwiek
-- w tym projekcie. Zadbaj by w wynikach pojawił się każdy projekt (nawet bez
-- pracowników).

SELECT P.NAME, COUNT(E.EMPLOYEE_ID) AS NUM_OF_EMPLOYEES
FROM PROJECTS P
    LEFT JOIN EMP_PROJECTS EP ON P.PROJECT_ID = EP.PROJECT_ID
    LEFT JOIN EMPLOYEES E ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID
GROUP BY P.NAME;

-- 4. Pokaż średnią ocenę pracowników per departament (uwzględnij wszystkie
-- departamenty). W wynikach zamiesc nazwe departamentu i srednia ocene.

SELECT D.NAME, AVG(G.GRADE) AS AVG_GRADE
FROM DEPARTMENTS D
    LEFT JOIN EMPLOYEES E ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
    LEFT JOIN EMP_GRADES EG on E.EMPLOYEE_ID = EG.EMPLOYEE_ID
    LEFT JOIN GRADES G on EG.GRADE_ID = G.GRADE_ID
GROUP BY D.NAME;

-- 4 V2
SELECT D.NAME, AVG(G.GRADE) AS AVG_GRADE
FROM GRADES G
    JOIN EMP_GRADES USING (GRADE_ID)
    JOIN EMPLOYEES E USING (EMPLOYEE_ID)
    RIGHT JOIN DEPARTMENTS D USING (DEPARTMENT_ID)
GROUP BY D.NAME;


-- SELF JOIN
SELECT e1.name, e1.surname, e1.salary, e2.salary as threshold
FROM employees e1
JOIN employees e2 ON (e1.salary >= e2.salary AND e2.surname = 'King');

-- PRACOWNICY + MENADZERZY
SELECT emp.name, emp.surname, man.name || ' ' || man.surname manager
FROM employees emp
JOIN employees man ON (emp.manager_id = man.employee_id);

-- 1. Dla każdego imienia pracownika z zakładów Administracja lub Marketing zwróć
-- liczbę pracowników, którzy mają takie samo imię i podaj ich średnie zarobki.
SELECT E.NAME, COUNT(EMPLOYEE_ID) AS NUM_EMP, AVG(E.SALARY)
FROM EMPLOYEES E
    JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE D.NAME IN ('Administracja', 'Marketing')
GROUP BY E.NAME;


-- 2. Zwróć imiona i nazwiska pracowników, którzy przeszli więcej niż 2 zmiany
-- stanowiska. Wyniki posortuj malejąco wg liczby zmian.
SELECT E.NAME, E.SURNAME, COUNT(PHIS.POSITION_ID) AS NUM_CHANGES
FROM EMPLOYEES E
    JOIN POSITIONS_HISTORY PHIS ON E.EMPLOYEE_ID = PHIS.EMPLOYEE_ID
GROUP BY E.NAME, E.SURNAME
HAVING COUNT(PHIS.POSITION_ID) > 2
ORDER BY NUM_CHANGES DESC;

-- 3. Zwróć id, nazwisko kierowników oraz liczbę podległych pracowników. Wyniki
-- posortuj malejąco wg liczby podległych pracowników.
SELECT M.EMPLOYEE_ID AS MANAGER_ID, M.SURNAME, COUNT(E.EMPLOYEE_ID) AS NUM_OF_EMPS
FROM EMPLOYEES M
    LEFT JOIN EMPLOYEES E ON M.EMPLOYEE_ID = E.MANAGER_ID
GROUP BY M.EMPLOYEE_ID, M.SURNAME
ORDER BY NUM_OF_EMPS DESC;

-- 4. Napisz zapytanie zwracające liczbę zakładów w krajach. W wynikach podaj
-- nazwę kraju oraz jego ludność.

SELECT C.NAME, C.POPULATION, COUNT(D.DEPARTMENT_ID) AS NUM_OF_DEPS
FROM COUNTRIES C
    LEFT JOIN ADDRESSES A on C.COUNTRY_ID = A.COUNTRY_ID
    LEFT JOIN DEPARTMENTS D on A.ADDRESS_ID = D.ADDRESS_ID
GROUP BY C.NAME, C.POPULATION;


