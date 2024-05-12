CREATE TABLE Kraje (
    ID_kraju    INTEGER CONSTRAINT kraje_pk PRIMARY KEY,
    Nazwa       VARCHAR2 (20) NOT NULL,
    ID_regionu  INTEGER REFERENCES regiony ( ID_regionu )
);

-- dodanie klucza obcego do pracownicy

ALTER TABLE pracownicy
    ADD ID_stanowiska INTEGER;

ALTER TABLE pracownicy 
    ADD CONSTRAINT pracownicy_stanowiska_fk FOREIGN KEY ( ID_stanowiska ) REFERENCES stanowiska ( ID_stanowiska );

-- tabela zak³ady z odwo³aniem do menadzera + minimalne wynagrodzenie

CREATE TABLE ZAKLADY (
    ID_zakladu  INTEGER CONSTRAINT zaklady_pk PRIMARY KEY,
    Nazwa       VARCHAR2 (20) CONSTRAINT nn_nazwa NOT NULL,
    ID_menadzera INTEGER CONSTRAINT nn_menadzer NOT NULL
);

ALTER TABLE ZAKLADY
    ADD CONSTRAINT zaklady_menadzer_fk FOREIGN KEY ( ID_menadzera ) REFERENCES pracownicy ( ID_pracownika );

ALTER TABLE STANOWISKA
    ADD CONSTRAINT stanowiska_min_wynagrodzenie CHECK ( min_wynagrodzenie > 1000);
    
    
    