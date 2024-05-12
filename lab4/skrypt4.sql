-- Wylistuj wszystkie dane z tabeli departments.

SELECT * FROM departments;

-- Wylistuj wybrane 3 kolumny z tabeli departments. W jakiej kolejnoœci siê pojawi¹?

SELECT department_id, UPPER(name), established from departments;

--. Poka¿ id, imiê i nazwisko pracowników ich wynagrodzenie oraz przewidywana wartoœæ miesiêcznych podatków przez nich p³aconych (23%).

SELECT employee_id, name, surname, salary, salary*0.23 as tax from employees;

--Ilu jest wszystkich pracowników?

SELECT count(employee_id) as "Employees Count" from employees;

--Wylistuj wszystkie imiona pracowników. Ile ich jest?

SELECT COUNT(DISTINCT name) from employees;

-- Wylistuj wszystkich pracowników, którzy maj¹ zarobki wy¿sze ni¿ 3000.

SELECT * from employees WHERE salary BETWEEN 2000 AND 3000;
 
-- 3. Wylistuj wszystkich pracowników, którzy maj¹ zarobki miêdzy ni¿ 2000 a 3000 i którzy s¹ zatrudnieni po 2010. Ilu ich jest?

SELECT * from employees WHERE (salary BETWEEN 2000 AND 3000) AND (EXTRACT(YEAR from date_employed) > 2010);

--. Wylistuj wszystkich pracowników, którzy p³ac¹ podatki mniejsze ni¿ 500.

SELECT salary, salary*0.23 as tax from employees WHERE (salary * 0.23 < 500);

-- Poka¿ kraje, które zaczynaj¹ siê na literê “K”

SELECT * from countries WHERE name like 'K%';

--6. Poka¿ pracowników, którzy nie pracuj¹ w ¿adnym zak³adzie

SELECT * from employees WHERE department_id is NULL;

--  Poka¿ pracowników, którzy pracuj¹ w zak³adzie o kodzie 102, 103, lub 105

SELECT * from employees WHERE department_id in (102,103,105);

--. Poka¿ pracowników, którzy nie pracuj¹ zak³adzie o kodzie 102, 103, lub 105.

SELECT * from employees WHERE department_id NOT IN (102,103,105);


-- Wypisz imiê i nazwisko, zarobki pracowników. Zmodyfikuj to zapytanie tak, aby zamiast NULL wypisywa³o wartoœæ 0.

 SELECT name, surname, NVL(salary, 0) FROM employees;
 
-- Poka¿ imiê i nazwisko 5ciu najlepiej zarabiaj¹cych pracowników.

SELECT name, surname, salary 
from employees 
ORDER BY salary DESC NULLS LAST
FETCH NEXT 5 ROWS WITH TIES;

-- Poka¿ najwczeœniej zatrudnionego pracownika

SELECT *
from employees 
ORDER BY date_employed ASC NULLS LAST
FETCH NEXT 1 ROWS ONLY;

-- Poka¿ 2 stanowiska na których szerokoœæ wide³ek (rozpiêtoœæ przedzia³u minp³aca - max p³aca jest najwiêksza)

SELECT * 
from positions 
ORDER BY (max_salary - min_salary) DESC NULLS LAST
FETCH NEXT 2 ROWS WITH TIES;



