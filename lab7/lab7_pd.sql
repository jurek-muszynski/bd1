-- 1. Skonstruuj po jednym zapytaniu, które będzie zawierać w klauzuli WHERE:
-- a. podzapytanie zwracające tylko jedną wartość;

SELECT NAME, SURNAME, SALARY
FROM EMPLOYEES
WHERE SALARY =
(SELECT MAX(SALARY) FROM EMPLOYEES);

-- b. podzapytanie zwracające jeden wiersz danych, ale wiele kolumn;

SELECT NAME, SURNAME, GENDER
FROM EMPLOYEES
WHERE (SALARY, GENDER) IN (
    SELECT MIN(SALARY), 'K'
    FROM EMPLOYEES
    WHERE GENDER = 'K'
);

-- c. podzapytanie zwracające jedną kolumnę danych;
SELECT SURNAME
FROM EMPLOYEES
WHERE (SALARY) IN (
    SELECT MAX(SALARY)
    FROM EMPLOYEES
);

-- d. podzapytanie zwracające tabelę danych.
SELECT NAME, SURNAME
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN
(
    SELECT DEPARTMENT_ID
    FROM DEPARTMENTS
    WHERE MANAGER_ID IN (101, 112)
);

-- 2. Napisz zapytanie, które zwróci pracowników będących kierownikami zakładów, o ile ich
-- zarobki są większe niż średnia zarobków dla wszystkich pracowników.
SELECT DISTINCT E.NAME, E.SURNAME, E.SALARY
FROM EMPLOYEES E
JOIN DEPARTMENTS D ON E.EMPLOYEE_ID = D.MANAGER_ID
WHERE SALARY > (
    SELECT AVG(SALARY)
    FROM EMPLOYEES
);

-- 3. Zmodyfikuj powyższe zapytanie tak, aby wyświetlało wszystkich pracowników
-- będących kierownikami zakładów, o ile ich zarobki są większe niż średnia zarobków na
-- stanowisku które zajmują.
SELECT DISTINCT E.NAME, E.SURNAME, E.SALARY, P.NAME
FROM EMPLOYEES E
JOIN POSITIONS P ON E.POSITION_ID = P.POSITION_ID
JOIN DEPARTMENTS D ON E.EMPLOYEE_ID = D.MANAGER_ID
WHERE E.SALARY > (
    SELECT AVG(E1.SALARY)
    FROM EMPLOYEES E1
    WHERE E.POSITION_ID = E1.POSITION_ID
);

-- 5. W których klauzulach polecenia SELECT możemy wykorzystać podzapytania
-- nieskorelowane?

-- SELECT, FROM, WHERE, HAVING ?

-- 6. W których klauzulach polecenia SELECT możemy wykorzystać podzapytania
-- skorelowane?

-- SELECT, WHERE, HAVING ?