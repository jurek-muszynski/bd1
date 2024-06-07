-- Dodaj do pakietu prywatną funkcję create_base_login, która będzie
-- generowała bazowy login pracownika (ćwiczenie z pracy domowej BD1_8).
-- Sprawdź możliwość wywołania tej funkcji.

CREATE OR REPLACE PACKAGE emp_management
AS
    FUNCTION create_base_login(p_id integer) RETURN VARCHAR2;
END;

CREATE OR REPLACE PACKAGE BODY emp_management
AS
    FUNCTION create_base_login(p_id integer) RETURN VARCHAR2
    AS
        v_login VARCHAR2(40);
        v_name employees.name%type;
        v_surname employees.surname%type;
    BEGIN
        select name, surname
        into v_name, v_surname
        from employees
        where EMPLOYEE_ID = p_id;

        v_login := SUBSTR(v_name,1,1) || v_surname || p_id;
    return v_login;
    END;
END emp_management;


SELECT emp_management.create_base_login(EMPLOYEE_ID)
FROM EMPLOYEES WHERE EMPLOYEE_ID = 110;

