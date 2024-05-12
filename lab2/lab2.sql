
-- Stw�rz tabel� Szkolenia zawieraj�c� kolumn� identyfikator i nazwa. 
CREATE TABLE szkolenia (
    ID_szkolenia    INTEGER CONSTRAINT szkolenia_pk PRIMARY KEY,
    Nazwa           VARCHAR2 (20) CONSTRAINT nn_nazwa NOT NULL   
);


-- Zmodyfikuj tabel� Pracownicy dodaj�c kolumn� szkolenie_id b�d�ce kluczem obcym do tabeli Szkolenia
ALTER TABLE pracownicy
    ADD szkolenie_id INTEGER REFERENCES szkolenia ( ID_szkolenia );
    
    
-- Zmodyfikuj tabel� Pracownicy usuwaj�c kolumn� date_zatrudnienia.   
ALTER TABLE pracownicy
    DROP COLUMN data_zatrudnienia;
    
    
-- Usu� tabel� Szkolenia. Co obserwujesz? Jak wymusi� usuni�cie tabeli?
DROP TABLE szkolenia;
-- RDBMS blokuje usuni�cie tabeli ze wzgl�dnu na odwo�anie do jej klucza 
-- pierwotnego w innej tabeli. Aby wymusi� usuni�cie musimy najpierw zdj�� 
-- ograniczenia z innych tabel poprzez pozbycie si� kolumn z kluczem obcym szkole�
DROP TABLE szkolenia CASCADE CONSTRAINTS;


-- Przywr�� tabel� Szkolenia poleceniem FLASHBACK tablename TO BEFORE DROP.
FLASHBACK TABLE szkolenia TO BEFORE DROP;


-- Co zmienia klauzula PURGE przy DROP table? Wypr�buj na tabeli Adresy. 

-- Tworzenie tabeli adresy
CREATE TABLE adresy (
    ID_adresu       INTEGER CONSTRAINT adresy_pk PRIMARY KEY,
    Kod_pocztowy    VARCHAR2 (20) NOT NULL,
    Ulica           VARCHAR2 (20) NOT NULL,
    Miasto          VARCHAR2 (20) NOT NULL,
    ID_kraju        INTEGER CONSTRAINT adresy_kraje_fk REFERENCES kraje ( ID_kraju )
);

-- usuwanie tabeli adresy z pomoc� klauzuli purge
DROP TABLE adresy PURGE;

-- w zwi�zku z u�yciem klauzuli purge przy usuwaniu tabeli, kosz zosta� 
-- omini�ty, a przez to nie mo�emy odzyska� stanu tabeli przed jej usuni�ciem
FLASHBACK TABLE adresy TO BEFORE DROP;

