-- Generated by Oracle SQL Developer Data Modeler 23.1.0.087.0806
--   at:        2024-03-19 23:15:43 CET
--   site:      Oracle Database 11g
--   type:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE adresy (
    id_adresu      VARCHAR2(50) NOT NULL,
    kod_pocztowy   VARCHAR2(50) NOT NULL,
    ulica          VARCHAR2(50) NOT NULL,
    miasto         VARCHAR2(50) NOT NULL,
    kraje_id_kraju VARCHAR2(50)
);

ALTER TABLE adresy ADD CONSTRAINT adresy_pk PRIMARY KEY ( id_adresu );

CREATE TABLE historia_stanowisk (
    stanowiska_id_stanowiska VARCHAR2(50) NOT NULL,
    pracownicy_id_pracownika VARCHAR2(50) NOT NULL
);

ALTER TABLE historia_stanowisk ADD CONSTRAINT relation_11_pk PRIMARY KEY ( stanowiska_id_stanowiska,
                                                                           pracownicy_id_pracownika );

CREATE TABLE kraje (
    id_kraju           VARCHAR2(50) NOT NULL,
    nazwa              VARCHAR2(50) NOT NULL,
    regiony_id_regionu VARCHAR2(50)
);

ALTER TABLE kraje ADD CONSTRAINT kraje_pk PRIMARY KEY ( id_kraju );

CREATE TABLE pracownicy (
    id_pracownika            VARCHAR2(50) NOT NULL,
    imie                     VARCHAR2(20) NOT NULL,
    nazwisko                 VARCHAR2(20) NOT NULL,
    data_urodzenia           DATE NOT NULL,
    data_zatrudnienia        DATE NOT NULL,
    pracownicy_id_pracownika VARCHAR2(50) NOT NULL,
    zak�ady_id_zak�adu       VARCHAR2(50) NOT NULL,
    stanowiska_id_stanowiska VARCHAR2(50)
);

ALTER TABLE pracownicy ADD CONSTRAINT pracownicy_pk PRIMARY KEY ( id_pracownika );

CREATE TABLE regiony (
    id_regionu VARCHAR2(50) NOT NULL,
    nazwa      VARCHAR2(50) NOT NULL
);

ALTER TABLE regiony ADD CONSTRAINT regiony_pk PRIMARY KEY ( id_regionu );

CREATE TABLE stanowiska (
    id_stanowiska     VARCHAR2(50) NOT NULL,
    nazwa             VARCHAR2(50) NOT NULL,
    min_wynagrodzenie NUMBER(10, 2) NOT NULL,
    max_wynagrodzenie NUMBER(10, 2) NOT NULL
);

ALTER TABLE stanowiska ADD CONSTRAINT stanowiska_pk PRIMARY KEY ( id_stanowiska );

CREATE TABLE zak�ady (
    id_zak�adu               VARCHAR2(50) NOT NULL,
    nazwa                    VARCHAR2(50) NOT NULL,
    pracownicy_id_pracownika VARCHAR2(50) NOT NULL,
    adresy_id_adresu         VARCHAR2(50)
);

COMMENT ON COLUMN zak�ady.nazwa IS
    '		';

ALTER TABLE zak�ady ADD CONSTRAINT zak�ady_pk PRIMARY KEY ( id_zak�adu );

ALTER TABLE adresy
    ADD CONSTRAINT adresy_kraje_fk FOREIGN KEY ( kraje_id_kraju )
        REFERENCES kraje ( id_kraju );

ALTER TABLE kraje
    ADD CONSTRAINT kraje_regiony_fk FOREIGN KEY ( regiony_id_regionu )
        REFERENCES regiony ( id_regionu );

ALTER TABLE pracownicy
    ADD CONSTRAINT pracownicy_pracownicy_fk FOREIGN KEY ( pracownicy_id_pracownika )
        REFERENCES pracownicy ( id_pracownika );

ALTER TABLE pracownicy
    ADD CONSTRAINT pracownicy_stanowiska_fk FOREIGN KEY ( stanowiska_id_stanowiska )
        REFERENCES stanowiska ( id_stanowiska );

ALTER TABLE pracownicy
    ADD CONSTRAINT pracownicy_zak�ady_fk FOREIGN KEY ( zak�ady_id_zak�adu )
        REFERENCES zak�ady ( id_zak�adu );

ALTER TABLE historia_stanowisk
    ADD CONSTRAINT relation_11_pracownicy_fk FOREIGN KEY ( pracownicy_id_pracownika )
        REFERENCES pracownicy ( id_pracownika );

ALTER TABLE historia_stanowisk
    ADD CONSTRAINT relation_11_stanowiska_fk FOREIGN KEY ( stanowiska_id_stanowiska )
        REFERENCES stanowiska ( id_stanowiska );

ALTER TABLE zak�ady
    ADD CONSTRAINT zak�ady_adresy_fk FOREIGN KEY ( adresy_id_adresu )
        REFERENCES adresy ( id_adresu );

ALTER TABLE zak�ady
    ADD CONSTRAINT zak�ady_pracownicy_fk FOREIGN KEY ( pracownicy_id_pracownika )
        REFERENCES pracownicy ( id_pracownika );



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                             7
-- CREATE INDEX                             0
-- ALTER TABLE                             16
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0