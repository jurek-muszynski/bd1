-- BLOKI ANONIMOWE - ĆWICZENIA

-- 1. Napisz prosty blok anonimowy zawierający blok wykonawczy z instrukcją
-- NULL. Uruchom ten program.

BEGIN
    NULL;
end;

/
-- 2. Zmodyfikuj program powyżej i wykorzystaj procedurę dbms_output.put_line
-- przyjmującą jako parametr łańcuch znakowy do wyświetlenia na konsoli.
-- Uruchom program i odnajdź napis.

BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO DB!');
end;

/
-- 3. Napisz blok anonimowy który doda do tabeli region nowy rekord (np.
-- ‘Oceania’). Uruchom program i zweryfikuj działanie.

DECLARE
    V_NEW_REGION_ID NUMBER;
    V_OLD_REGION_ID NUMBER;
BEGIN
    BEGIN
        SELECT REGION_ID INTO V_OLD_REGION_ID FROM REGIONS WHERE NAME = 'Oceania';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_OLD_REGION_ID := NULL;
    end;
    IF V_OLD_REGION_ID IS NOT NULL THEN
        DELETE FROM REGIONS WHERE REGION_ID = V_OLD_REGION_ID;
        COMMIT;
    ELSE
        SELECT COUNT(*) INTO V_NEW_REGION_ID FROM REGIONS;
        V_NEW_REGION_ID := V_NEW_REGION_ID + 101;
        INSERT INTO REGIONS VALUES (V_NEW_REGION_ID,'Oceania', 'OC');
        COMMIT;
    END IF;
END;

/
-- 4. Napisz blok anonimowy, który wygeneruje błąd
-- (RAISE_APPLICATION_ERROR przyjmującą 2 parametry: kod błędu oraz
-- wiadomość)

BEGIN
    RAISE_APPLICATION_ERROR(-20001, 'INTERNAL DATABSE ERROR');
end;

/
-- 5. Napisz blok anonimowy który będzie korzystał z co najmniej dwóch
-- zmiennych (v_min_sal oraz v_emp_id) i który będzie wypisywał na ekran imię
-- i nazwisko pracownika o wskazanym id tylko jeśli jego zarobki są wyższe niż
-- v_min_sal.

DECLARE
    V_MIN_SAL CONSTANT EMPLOYEES.SALARY%TYPE := 3600;
    V_EMP_ID  CONSTANT EMPLOYEES.EMPLOYEE_ID%TYPE := 102;
    V_EMP_DATA EMPLOYEES%rowtype; -- KROTKA, TYLE SAMO PÓL CO W TABLE <TABLE>%ROWTYPE
BEGIN
    SELECT * INTO V_EMP_DATA FROM EMPLOYEES WHERE EMPLOYEE_ID = V_EMP_ID;

    IF V_EMP_DATA.SALARY > V_MIN_SAL THEN DBMS_OUTPUT.PUT_LINE('NAME:' || V_EMP_DATA.NAME || ' ' || V_EMP_DATA.SURNAME || ' ' || V_EMP_DATA.SALARY || ' ZL');
    END IF;
END;

/
-- NAZWANE BLOKI - ĆWICZENIA

-- Zaimplementuj funkcję, która wylicza dodatek
-- stażowy. Pracownik kwalifikujący się do
-- dodatku musi mieć 30+ lat oraz 3+ stażu pracy
-- w firmie. Dodatek to dwukrotność pensji.

CREATE OR REPLACE FUNCTION CALCULATE_SENIORITY_BONUS (EMP_ID NUMBER)
RETURN NUMBER
AS
    V_BONUS EMPLOYEES.SALARY%TYPE;
    V_AGE NUMBER;
    V_EMPLOYMENT NUMBER;
    V_EMP_DATA EMPLOYEES%rowtype;
    C_EMPLOYMENT_THRESHOLD NUMBER := 3;
    C_AGE_THRESHOLD NUMBER := 30;
    C_SALARY_MULTIPLIER NUMBER := 2;
BEGIN
    SELECT * INTO V_EMP_DATA FROM EMPLOYEES WHERE EMPLOYEE_ID = EMP_ID;

    V_AGE := EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM V_EMP_DATA.BIRTH_DATE);
    V_EMPLOYMENT := EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM V_EMP_DATA.DATE_EMPLOYED);

    IF V_AGE > C_AGE_THRESHOLD AND V_EMPLOYMENT > C_EMPLOYMENT_THRESHOLD THEN
        V_BONUS := V_EMP_DATA.SALARY * C_SALARY_MULTIPLIER;
    end if;

    RETURN V_BONUS;

END;
/

SELECT EMPLOYEE_ID, SALARY, CALCULATE_SENIORITY_BONUS(EMPLOYEE_ID) FROM EMPLOYEES;


-- 1. Napisz funkcję, która wyliczy roczną wartość podatku pracownika. Zakładamy
-- podatek progresywny. Początkowo stawka to 15%, po przekroczeniu progu
-- 100000 stawka wynosi 25%.

CREATE OR REPLACE FUNCTION CALCULATE_ANNUAL_TAX(EMP_ID NUMBER)
RETURN NUMBER
AS
    C_INITIAL_RATE CONSTANT NUMBER := 0.15;
    C_SECOND_RATE CONSTANT NUMBER := 0.25;
    C_SALARY_THRESHOLD CONSTANT NUMBER := 100000;
    V_ANNUAL_SALARY NUMBER;
    V_TAX NUMBER;
    V_TOTAL_TAX NUMBER;
BEGIN
    SELECT SALARY*12 INTO V_ANNUAL_SALARY FROM EMPLOYEES WHERE EMPLOYEE_ID = EMP_ID;

    IF V_ANNUAL_SALARY < C_SALARY_THRESHOLD THEN
        V_TOTAL_TAX := V_ANNUAL_SALARY * C_INITIAL_RATE;
    ELSE
        V_TAX := C_SALARY_THRESHOLD * C_INITIAL_RATE;
        V_ANNUAL_SALARY := V_ANNUAL_SALARY - C_SALARY_THRESHOLD;
        V_TOTAL_TAX := V_ANNUAL_SALARY * C_SECOND_RATE + V_TAX;
    end if;

    RETURN V_TOTAL_TAX;
END;


SELECT EMPLOYEE_ID,
       SALARY * 12 AS ANNUAL_SALARY,
       CALCULATE_ANNUAL_TAX(EMPLOYEE_ID) AS ANNUAL_TAX
FROM EMPLOYEES
WHERE SALARY * 12 > 100000;


-- 2. Stwórz widok łączący departamenty, adresy i kraje. Napisz zapytanie, które
-- pokaże sumę zapłaconych podatków w krajach. 