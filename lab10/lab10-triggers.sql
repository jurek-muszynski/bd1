-- 1. Stwórz wyzwalacz, który podczas uaktualniania zarobków pracownika wyświetli
-- podatek 20% procent od nowych zarobków. Przetestuj działanie.
--1
CREATE FUNCTION podatek (p_eid INTEGER)
RETURN NUMBER
AS
    v_threshold NUMBER(10,0);
    v_tax1 NUMBER(2,2) := 0.15;
    v_tax2 NUMBER(2,2) := 0.25;
    v_salary employees.salary%TYPE;
BEGIN

    SELECT salary INTO v_salary
    FROM employees WHERE employee_id = p_eid;

    IF v_salary*v_tax1 < v_threshold THEN
        RETURN v_salary*v_tax1;
    ELSE
        RETURN v_salary*v_tax2;
    END IF;
END;

CREATE OR REPLACE TRIGGER tax_trigger
AFTER
INSERT OR UPDATE OF SALARY ON EMPLOYEES
FOR EACH ROW
WHEN (OLD.SALARY != NEW.SALARY)
    DECLARE
        v_tax number(20, 2);
    BEGIN
--         v_tax := podatek(:new.EMPLOYEE_ID);
            v_tax := 0.2 * :new.SALARY;

        DBMS_OUTPUT.PUT_LINE('Podatek: ' || v_tax);
    end;

UPDATE EMPLOYEES SET SALARY = SALARY * 1.1
    WHERE MOD(EMPLOYEE_ID,2) = 0;

-- W tej samej transakcji co wyzwalacz wykonuje for each row na danej tabeli nie mozna używać na niej SELECT'a

SELECT * FROM USER_TRIGGERS WHERE TABLE_NAME = 'EMPLOYEES';


-- 2. Stwórz wyzwalacz, który po dodaniu nowego pracownika, usunięciu pracownika lub
-- modyfikacji zarobków pracowników wyświetli aktualne średnie zarobki wszystkich
-- pracowników. Przetestuj działanie.

CREATE OR REPLACE FUNCTION AVG_SALARY
RETURN NUMBER
AS
    v_avg_salary NUMBER(20,2);
BEGIN
    SELECT AVG(SALARY) INTO v_avg_salary
    FROM EMPLOYEES;
    RETURN v_avg_salary;
end;

CREATE OR REPLACE TRIGGER AVG_SALARY_AFTER_SALARY_UPDATE
AFTER
INSERT OR DELETE OR UPDATE OF SALARY ON EMPLOYEES
    DECLARE
        v_avg_salary number(20,2);
    BEGIN
        SELECT AVG(SALARY) INTO v_avg_salary
        FROM EMPLOYEES;
        DBMS_OUTPUT.PUT_LINE('Średnie zarobki: ' || v_avg_salary);
    end;


UPDATE EMPLOYEES SET SALARY = SALARY * 1.1 WHERE MOD(EMPLOYEE_ID,2) = 0;


-- 3. Stwórz wyzwalacz, który dla każdego nowego pracownika nieposiadającego managera,
-- ale zatrudnionego w departamencie, przypisze temu pracownikowi managera
-- będącego jednocześnie managerem departamentu, w którym ten pracownik pracuje.
-- Wykorzystaj klauzulę WHEN wyzwalacza. Przetestuj działanie.

CREATE OR REPLACE TRIGGER ASSIGN_MANAGER
BEFORE UPDATE OR INSERT ON EMPLOYEES
FOR EACH ROW
WHEN (NEW.MANAGER_ID IS NULL)
    DECLARE
        v_new_manager_id NUMBER;
    BEGIN
        SELECT MANAGER_ID INTO v_new_manager_id
        FROM DEPARTMENTS
            WHERE DEPARTMENT_ID = :NEW.MANAGER_ID;

        :NEW.MANAGER_ID := v_new_manager_id;
    end;

-- 4. IF => Wewnątrz wyzwalacza

-- KURSORY

-- 2. Przygotuj procedurę PL/SQL, która z wykorzystaniem jawnego kursora
-- wyświetli p_no_dept departamenty największych budżetach, gdzie p_no_dept
-- to parametr wejściowy procedury.

CREATE OR REPLACE PROCEDURE SHOW_DEPT_BUDGET(p_number INTEGER)
AS
    CURSOR cr IS
        SELECT DEPARTMENT_ID, YEAR_BUDGET
        FROM DEPARTMENTS
        ORDER BY YEAR_BUDGET DESC
        NULLS LAST;

    v_dept_id INTEGER;
    v_year_budget NUMBER (20,2);
    index_i integer := 1;

    BEGIN
        OPEN cr;
        LOOP
            FETCH cr INTO v_dept_id, v_year_budget;
            DBMS_OUTPUT.PUT_LINE(v_dept_id || ' ' || v_year_budget);

            EXIT WHEN index_i = p_number;
            index_i := index_i + 1;
        end loop;
        CLOSE cr;
    end;
/

EXECUTE SHOW_DEPT_BUDGET(5);

-- SPRAWDZIAN
-- 1 funkcja
-- 1 procedura
-- 1 wyzwalacz
-- 1 kursor