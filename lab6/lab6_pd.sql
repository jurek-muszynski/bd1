-- 1. Napisz zapytanie znajdujące liczbę zmian stanowisk pracownika Jan Kowalski.

SELECT CONCAT(CONCAT(E.NAME, ' '), E.SURNAME) AS NAME, COUNT(*)
FROM EMPLOYEES E
    JOIN POSITIONS_HISTORY PHIS ON E.EMPLOYEE_ID = PHIS.EMPLOYEE_ID
WHERE E.NAME = 'Jan' AND E.SURNAME = 'Kowalski'
GROUP BY E.NAME, E.SURNAME;

-- 2. Napisz zapytanie znajdujące średnią pensję dla każdego ze stanowisk. Wynik
-- powinien zawierać nazwę stanowiska i zaokrągloną średnią pensję

SELECT P.NAME, ROUND(AVG(E.SALARY), 2) AS AVG_SALARY
FROM POSITIONS P
    LEFT OUTER JOIN EMPLOYEES E ON P.POSITION_ID = E.POSITION_ID
GROUP BY P.NAME
ORDER BY AVG_SALARY DESC;


-- 3. Pobierz wszystkich pracowników zakładu Kadry lub Finanse wraz z informacją w
-- jakim zakładzie pracują.

SELECT *
FROM EMPLOYEES E
    INNER JOIN JMUSZYNS.DEPARTMENTS D on E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE D.NAME IN ('Kadry', 'Finanse');


-- 4. Znajdź pracowników, których zarobki nie są zgodne z “widełkami” na jego
-- stanowisku. Zwróć imię, nazwisko, wynagrodzenie oraz nazwę stanowiska.
-- Zrealizuj za pomocą złączenia nierównościowego

SELECT E.NAME, E.SURNAME, E.SALARY, P.NAME AS POSITION
FROM EMPLOYEES E
    INNER JOIN POSITIONS P ON
        (E.POSITION_ID = P.POSITION_ID AND (E.SALARY < P.MIN_SALARY OR E.SALARY > P.MAX_SALARY));

-- 5. Pokaż nazwy regionów w których nie ma żadnego kraju.

SELECT R.NAME REGIONS_WITH_NO_COUNTRIES
FROM REGIONS R
    LEFT OUTER JOIN REG_COUNTRIES RGC ON R.REGION_ID = RGC.REGION_ID
GROUP BY R.NAME
HAVING COUNT(COUNTRY_ID) = 0;

-- 6. Wykonaj złączenie naturalne między tabelami countries a regions. Jaki wynik
-- otrzymujemy i dlaczego?

SELECT *
FROM COUNTRIES
NATURAL JOIN REGIONS;

-- Wynik jest pusty, ponieważ NATURAL JOIN dokonuje złączenia między tabelami na
-- podstawie kolumny o tej samej nazwie, czyli 'name'

-- 7. Jaki otrzymamy wynik jeśli zrobimy NATURAL JOIN na tabelach bez wspólnej
-- kolumny? Sprawdź i zastanów się nad przyczyną

SELECT *
FROM EMPLOYEES
    NATURAL JOIN ADDRESSES;

SELECT *
FROM EMPLOYEES
    CROSS JOIN ADDRESSES;

-- Wyniki obu powyższych zapytań są identyczne, zatem w przypadku braku wspólnej kolumny
-- dojdzie do złączenia kartezjańskiego
