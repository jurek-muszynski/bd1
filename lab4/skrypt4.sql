-- Wylistuj wszystkie dane z tabeli departments.

SELECT * FROM departments;

-- Wylistuj wybrane 3 kolumny z tabeli departments. W jakiej kolejno�ci si� pojawi�?

SELECT department_id, UPPER(name), established from departments;

--. Poka� id, imi� i nazwisko pracownik�w ich wynagrodzenie oraz przewidywana warto�� miesi�cznych podatk�w przez nich p�aconych (23%).

SELECT employee_id, name, surname, salary, salary*0.23 as tax from employees;

--Ilu jest wszystkich pracownik�w?

SELECT count(employee_id) as "Employees Count" from employees;

--Wylistuj wszystkie imiona pracownik�w. Ile ich jest?

SELECT COUNT(DISTINCT name) from employees;

-- Wylistuj wszystkich pracownik�w, kt�rzy maj� zarobki wy�sze ni� 3000.

SELECT * from employees WHERE salary BETWEEN 2000 AND 3000;
 
-- 3. Wylistuj wszystkich pracownik�w, kt�rzy maj� zarobki mi�dzy ni� 2000 a 3000 i kt�rzy s� zatrudnieni po 2010. Ilu ich jest?

SELECT * from employees WHERE (salary BETWEEN 2000 AND 3000) AND (EXTRACT(YEAR from date_employed) > 2010);

--. Wylistuj wszystkich pracownik�w, kt�rzy p�ac� podatki mniejsze ni� 500.

SELECT salary, salary*0.23 as tax from employees WHERE (salary * 0.23 < 500);

-- Poka� kraje, kt�re zaczynaj� si� na liter� �K�

SELECT * from countries WHERE name like 'K%';

--6. Poka� pracownik�w, kt�rzy nie pracuj� w �adnym zak�adzie

SELECT * from employees WHERE department_id is NULL;

--  Poka� pracownik�w, kt�rzy pracuj� w zak�adzie o kodzie 102, 103, lub 105

SELECT * from employees WHERE department_id in (102,103,105);

--. Poka� pracownik�w, kt�rzy nie pracuj� zak�adzie o kodzie 102, 103, lub 105.

SELECT * from employees WHERE department_id NOT IN (102,103,105);


-- Wypisz imi� i nazwisko, zarobki pracownik�w. Zmodyfikuj to zapytanie tak, aby zamiast NULL wypisywa�o warto�� 0.

 SELECT name, surname, NVL(salary, 0) FROM employees;
 
-- Poka� imi� i nazwisko 5ciu najlepiej zarabiaj�cych pracownik�w.

SELECT name, surname, salary 
from employees 
ORDER BY salary DESC NULLS LAST
FETCH NEXT 5 ROWS WITH TIES;

-- Poka� najwcze�niej zatrudnionego pracownika

SELECT *
from employees 
ORDER BY date_employed ASC NULLS LAST
FETCH NEXT 1 ROWS ONLY;

-- Poka� 2 stanowiska na kt�rych szeroko�� wide�ek (rozpi�to�� przedzia�u minp�aca - max p�aca jest najwi�ksza)

SELECT * 
from positions 
ORDER BY (max_salary - min_salary) DESC NULLS LAST
FETCH NEXT 2 ROWS WITH TIES;



