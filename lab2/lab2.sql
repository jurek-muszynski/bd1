
-- Stwórz tabelê Szkolenia zawieraj¹c¹ kolumnê identyfikator i nazwa. 
CREATE TABLE szkolenia (
    ID_szkolenia    INTEGER CONSTRAINT szkolenia_pk PRIMARY KEY,
    Nazwa           VARCHAR2 (20) CONSTRAINT nn_nazwa NOT NULL   
);


-- Zmodyfikuj tabelê Pracownicy dodaj¹c kolumnê szkolenie_id bêd¹ce kluczem obcym do tabeli Szkolenia
ALTER TABLE pracownicy
    ADD szkolenie_id INTEGER REFERENCES szkolenia ( ID_szkolenia );
    
    
-- Zmodyfikuj tabelê Pracownicy usuwaj¹c kolumnê date_zatrudnienia.   
ALTER TABLE pracownicy
    DROP COLUMN data_zatrudnienia;
    
    
-- Usuñ tabelê Szkolenia. Co obserwujesz? Jak wymusiæ usuniêcie tabeli?
DROP TABLE szkolenia;
-- RDBMS blokuje usuniêcie tabeli ze wzglêdnu na odwo³anie do jej klucza 
-- pierwotnego w innej tabeli. Aby wymusiæ usuniêcie musimy najpierw zdj¹æ 
-- ograniczenia z innych tabel poprzez pozbycie siê kolumn z kluczem obcym szkoleñ
DROP TABLE szkolenia CASCADE CONSTRAINTS;


-- Przywróæ tabelê Szkolenia poleceniem FLASHBACK tablename TO BEFORE DROP.
FLASHBACK TABLE szkolenia TO BEFORE DROP;


-- Co zmienia klauzula PURGE przy DROP table? Wypróbuj na tabeli Adresy. 

-- Tworzenie tabeli adresy
CREATE TABLE adresy (
    ID_adresu       INTEGER CONSTRAINT adresy_pk PRIMARY KEY,
    Kod_pocztowy    VARCHAR2 (20) NOT NULL,
    Ulica           VARCHAR2 (20) NOT NULL,
    Miasto          VARCHAR2 (20) NOT NULL,
    ID_kraju        INTEGER CONSTRAINT adresy_kraje_fk REFERENCES kraje ( ID_kraju )
);

-- usuwanie tabeli adresy z pomoc¹ klauzuli purge
DROP TABLE adresy PURGE;

-- w zwi¹zku z u¿yciem klauzuli purge przy usuwaniu tabeli, kosz zosta³ 
-- ominiêty, a przez to nie mo¿emy odzyskaæ stanu tabeli przed jej usuniêciem
FLASHBACK TABLE adresy TO BEFORE DROP;

