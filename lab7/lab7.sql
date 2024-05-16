-- PODZAPYTANIA NIESKORELOWANE JEDNOWIERSZOWE

-- skonstruuj zapytanie, które zwróci dane pracownika (pracowników) o
-- największych zarobkach.

SELECT name, surname
FROM Employees
WHERE salary =
(
 SELECT MAX(salary)
 FROM Employees
);

-- skonstruuj zapytanie, które zwróci dane pracowniczki (pracowniczek) o najmniejszych
-- zarobkach.

SELECT name, surname, gender
FROM employees
WHERE (salary, gender) =
(
 SELECT MIN(salary), 'K'
 FROM Employees
 WHERE Gender = 'K'
);

-- 1. Napisz zapytanie, które wyświetli imię, nazwisko oraz nazwy zakładów, w których
-- pracownicy mają większe zarobki niż minimalne zarobki na stanowisku o nazwie
-- ‘Konsultant’.

SELECT E.NAME, E.SURNAME, D.NAME, E.SALARY
FROM EMPLOYEES E
         JOIN JMUSZYNS.DEPARTMENTS D on D.DEPARTMENT_ID = E.DEPARTMENT_ID
WHERE E.SALARY > (
    SELECT MIN_SALARY FROM POSITIONS P
    WHERE P.NAME LIKE 'Konsultant'
);

-- V2

SELECT E.NAME, E.SURNAME, D.NAME, E.SALARY, SQ.MIN_SALARY CONSULTANT
FROM EMPLOYEES E
    JOIN JMUSZYNS.DEPARTMENTS D on D.DEPARTMENT_ID = E.DEPARTMENT_ID
    JOIN (
    SELECT MIN_SALARY FROM POSITIONS P
    WHERE P.NAME LIKE 'Konsultant') SQ ON E.SALARY > SQ.MIN_SALARY;

-- 2. Napisz zapytanie, które zwróci dane najmłodszego wśród dzieci pracowników. (Skorzystaj
-- z podzapytań. Jaki jest inny sposób na osiągnięcie tego wyniku?)

SELECT *
FROM DEPENDENTS D
WHERE BIRTH_DATE = (SELECT MAX(BIRTH_DATE) FROM DEPENDENTS);

-- 3. Napisz zapytanie, które zwróci dane dzieci najstarszego pracownika z zakładu 102.
SELECT *
FROM DEPENDENTS D
JOIN EMPLOYEES E ON D.EMPLOYEE_ID = E.EMPLOYEE_ID
WHERE (E.BIRTH_DATE, E.DEPARTMENT_ID) = (
SELECT MIN(BIRTH_DATE), 102 FROM EMPLOYEES WHERE DEPARTMENT_ID = 102);

-- 4. Napisz zapytanie, które wyświetli wszystkich pracowników, którzy zostali zatrudnieni nie
-- wcześniej niż najwcześniej zatrudniony pracownik w zakładzie o id 101 i nie później niż
-- najpóźniej zatrudniony pracownik w zakładzie o id 107.

-- BEZ ALIASÓW

SELECT E.*
FROM EMPLOYEES E
WHERE E.DATE_EMPLOYED BETWEEN
(SELECT MIN(DATE_EMPLOYED) FROM EMPLOYEES WHERE DEPARTMENT_ID = 101)
AND
(SELECT MAX(DATE_EMPLOYED) FROM EMPLOYEES WHERE DEPARTMENT_ID = 107);

-- 5. Wyświetl średnie zarobki dla każdego ze stanowisk, o ile średnie te są większe od
-- średnich zarobków w departamencie “Administracja”.

SELECT P.NAME, AVG(E.SALARY) AS AVG_SALARY
FROM EMPLOYEES E
JOIN POSITIONS P USING (POSITION_ID)
GROUP BY P.NAME
HAVING AVG(E.SALARY) > (
    SELECT AVG(SALARY) FROM EMPLOYEES JOIN DEPARTMENTS USING (DEPARTMENT_ID)
    WHERE DEPARTMENTS.NAME LIKE 'Administracja'
);

-- PODZAPYTANIA NIESKORELOWANE WIELOWIERSZOWE

-- Skonstruuj zapytanie, które zwróci wszystkich pracowników zatrudnionych w
-- zakładach o id managera = 101 lub 112.

SELECT name, surname
FROM employees
WHERE department_id IN
(
SELECT department_id
FROM departments
WHERE manager_id IN (101, 112)
);

SELECT name, surname
FROM employees
WHERE department_id = ANY
(
SELECT department_id
FROM departments
WHERE manager_id IN (101, 112)
);

-- Skonstruuj zapytanie, które zwróci wszystkich mężczyzn zatrudnionych
-- wcześniej niż pracownicy na stanowiskach = 102 lub 103.

SELECT name, surname, gender
FROM employees
WHERE (date_employed) < ALL
(
 SELECT date_employed
 FROM employees
 WHERE position_id IN (102, 103)
);

-- 1. Napisz zapytanie, które zwróci informacje o pracownikach zatrudnionych po
-- zakończeniu wszystkich projektów (tabela projects). Zapytanie zrealizuj na 2 sposoby i
-- porównaj wyniki

SELECT E.*
FROM EMPLOYEES E
WHERE E.DATE_EMPLOYED > ALL (
    SELECT DATE_END FROM PROJECTS
    WHERE  DATE_END IS NOT NULL );

-- V2
SELECT E.*
FROM EMPLOYEES E
WHERE E.DATE_EMPLOYED > (
    SELECT MAX(DATE_END) FROM PROJECTS);


-- 2. Napisz zapytanie, które wyświetli wszystkich pracowników, których zarobki są co
-- najmniej czterokrotnie większe od zarobków jakiegokolwiek innego pracownika.

SELECT *
FROM EMPLOYEES E
WHERE E.SALARY > ANY (SELECT 4 * SALARY FROM EMPLOYEES);

-- 3. Korzystając z podzapytań napisz zapytanie które zwróci pracowników departamentów
-- mających siedziby w Polsce.
SELECT *
FROM EMPLOYEES E
WHERE E.DEPARTMENT_ID IN (
    SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE ADDRESS_ID IN (
        SELECT ADDRESS_ID FROM ADDRESSES JOIN COUNTRIES USING (COUNTRY_ID)
                          WHERE NAME LIKE 'Polska')
    )

-- 4. Zmodyfikuj poprzednie zapytania tak, żeby dodatkowo pokazać maksymalną pensję
-- per departament.
SELECT E.DEPARTMENT_ID, MAX(E.SALARY) AS MAX_SALARY
FROM EMPLOYEES E
WHERE E.DEPARTMENT_ID IN (
    SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE ADDRESS_ID IN (
        SELECT ADDRESS_ID FROM ADDRESSES JOIN COUNTRIES USING (COUNTRY_ID)
                          WHERE NAME LIKE 'Polska')
    )
GROUP BY E.DEPARTMENT_ID;

-- PODZAPYTANIA SKORELOWANE

-- 1. Napisz zapytanie, które zwróci pracowników zarabiających więcej niż średnia w ich
-- departamencie.

SELECT *
FROM EMPLOYEES E1
WHERE E1.SALARY > ALL (
    SELECT AVG(E2.SALARY) FROM EMPLOYEES E2 WHERE E1.DEPARTMENT_ID = E2.DEPARTMENT_ID
    )

-- 2. Napisz zapytanie które zwróci regiony nieprzypisane do krajów
SELECT *
FROM REGIONS R
WHERE R.REGION_ID NOT IN (
    SELECT R2.REGION_ID FROM REG_COUNTRIES R2 WHERE R2.REGION_ID = R.REGION_ID
)

-- 3. Napisz zapytanie które zwróci kraje nieprzypisane do regionów
SELECT *
FROM COUNTRIES C
WHERE C.COUNTRY_ID NOT IN (
    SELECT C.COUNTRY_ID FROM REG_COUNTRIES R WHERE C.COUNTRY_ID = R.COUNTRY_ID
);

-- 4. Napisz zapytanie, które zwróci wszystkich pracowników niebędących managerami
SELECT *
FROM EMPLOYEES
WHERE EMPLOYEE_ID NOT IN (SELECT MANAGER_ID FROM EMPLOYEES WHERE MANAGER_ID IS NOT NULL);

SELECT *
FROM EMPLOYEES E1
WHERE NOT EXISTS (SELECT 1 FROM EMPLOYEES E2 WHERE E1.EMPLOYEE_ID = E2.MANAGER_ID);

-- 5. Napisz zapytanie, które zwróci dane pracowników, którzy zarabiają więcej niż średnie
-- zarobki na stanowisku, na którym pracują


-- 6. Za pomocą podzapytania skorelowanego sprawdź, czy wszystkie stanowiska
-- zdefiniowane w tabeli Positions są aktualnie zajęte przez pracowników.

SELECT NAME
FROM POSITIONS P
WHERE NOT EXISTS (
    SELECT 1 FROM EMPLOYEES E WHERE E.POSITION_ID = P.POSITION_ID
)

SELECT POSITION_ID
FROM POSITIONS
MINUS
SELECT POSITION_ID
FROM EMPLOYEES;

-- PODZAPYTANIA W KLAUZULI SELECT/FROM

-- 1. Napisz zapytanie, które dla wszystkich pracowników posiadających pensję
-- zwróci informację o różnicy między ich pensją, a średnią pensją pracowników.
-- Różnicę podaj jako zaokrągloną wartość bezwzględną.



-- 5. Napisz zapytanie które zwróci pracowników którzy uzyskali w 2019 oceny wyższe niż
-- średnia w swoim departamencie. Pokaż średnią departamentu jako kolumnę.
SELECT E.NAME, E.SURNAME, EG.GRADE, SQG.GRADE
FROM EMPLOYEES E
    JOIN EMP_GRADES EG USING (EMPLOYEE_ID)
    JOIN GRADES USING (GRADE_ID)
    JOIN (
        SELECT DS.DEPARTMENT_ID AS DEPT_ID, AVG(GRADE) AS GRADE
        FROM EMPLOYEES ES JOIN DEPARTMENTS DS USING (DEPARTMENT_ID)
        JOIN EMP_GRADES EGS USING (EMPLOYEE_ID) JOIN GRADES GS USING (GRADE_ID)
        GROUP BY DS.DEPARTMENT_ID) SQG ON (E.DEPARTMENT_ID = SQG.DEPT_ID)
WHERE EG.PERIOD = 2019;


