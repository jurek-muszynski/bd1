-- PRACA DOMOWA LAB 4 JERZY MUSZY�SKI

-- 2. Ile jest region�w zaczynaj�cych si� na liter� �A�?
SELECT count(*) AS REGIONS_BEGINNIG_WITH_A
FROM regions 
WHERE name LIKE 'A%';

-- 3. Jaka jest maksymalna pensja w�r�d wszystkich pracownik�w?
SELECT max(salary) as MAX_SALARY 
from employees;

-- 4. Ilu jest pracownik�w bez przypisanego zak�adu?
SELECT count(*) AS EMPLOYEES_WITH_NO_DEPARTMENT 
FROM employees 
WHERE department_id is NULL;

-- 5. Wylistuj pracownik�w zatrudnionych po roku 2010.
SELECT *
FROM employees
WHERE EXTRACT(YEAR from date_employed) > 2010;

-- 6. Poka� adresy przypisane do kraj�w o id 119 lub 118 lub 106
SELECT *
FROM addresses
WHERE country_id in (119, 118, 106);

-- 7. Poka� kraje kt�rych nazwa skr�cona ma d�ugo�� 2
SELECT *
FROM countries
WHERE LENGTH(code) = 2;