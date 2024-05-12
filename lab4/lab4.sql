-- PRACA DOMOWA LAB 4 JERZY MUSZYÑSKI

-- 2. Ile jest regionów zaczynaj¹cych siê na literê ‘A’?
SELECT count(*) AS REGIONS_BEGINNIG_WITH_A
FROM regions 
WHERE name LIKE 'A%';

-- 3. Jaka jest maksymalna pensja wœród wszystkich pracowników?
SELECT max(salary) as MAX_SALARY 
from employees;

-- 4. Ilu jest pracowników bez przypisanego zak³adu?
SELECT count(*) AS EMPLOYEES_WITH_NO_DEPARTMENT 
FROM employees 
WHERE department_id is NULL;

-- 5. Wylistuj pracowników zatrudnionych po roku 2010.
SELECT *
FROM employees
WHERE EXTRACT(YEAR from date_employed) > 2010;

-- 6. Poka¿ adresy przypisane do krajów o id 119 lub 118 lub 106
SELECT *
FROM addresses
WHERE country_id in (119, 118, 106);

-- 7. Poka¿ kraje których nazwa skrócona ma d³ugoœæ 2
SELECT *
FROM countries
WHERE LENGTH(code) = 2;