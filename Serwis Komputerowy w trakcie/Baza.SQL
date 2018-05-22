/*
Created: 14.12.2017
Modified: 18.12.2017
Project: Model bazy serwisu komputerowego
Model: PostgreSQL 9.5
Company: PWSZ w Tarnowie
Author: Dominik Stasik, Michał Nowicki, Maciej Poręba
Version: 0.1
Database: PostgreSQL 9.5
*/


-- Create roles section -------------------------------------------------

CREATE ROLE "Serwisant"
;

CREATE ROLE "Klienci"
;

-- Create sequences section -------------------------------------------------

CREATE SEQUENCE "id_serwisanta_increment"
 INCREMENT BY 1
 START WITH 1
 NO MAXVALUE
 NO MINVALUE
 CACHE 1
;

CREATE SEQUENCE "id_zlecenia_increment"
 INCREMENT BY 1
 START WITH 1
 NO MAXVALUE
 NO MINVALUE
 CACHE 1
;

CREATE SEQUENCE "id_klienta_increment"
 INCREMENT BY 1
 START WITH 1
 NO MAXVALUE
 NO MINVALUE
 CACHE 1
;

CREATE SEQUENCE "id_produktu_increment"
 INCREMENT BY 1
 START WITH 1
 NO MAXVALUE
 NO MINVALUE
 CACHE 1
;

CREATE SEQUENCE "id_adresu_increment"
 INCREMENT BY 1
 START WITH 1
 NO MAXVALUE
 NO MINVALUE
 CACHE 1
;

-- Create tables section -------------------------------------------------

-- Table zlecenia

CREATE TABLE "zlecenia"(
 "id_zlecenia" Integer NOT NULL,
 "id_klienta" Integer NOT NULL,
 "id_serwisanta" Integer,
 "opis_usterki" Text,
 "typ_sprzetu" Character varying(30),
 "typ_zgloszenia" Character varying(25)
)
TABLESPACE "serwis_komputerowy_tablespace"
;

-- Create indexes for table zlecenia

CREATE INDEX "zlecenia_id_serwisanta" ON "zlecenia" ("id_serwisanta")
TABLESPACE "serwis_komputerowy_tablespace"
;

CREATE INDEX "zlecenia_id_klienta" ON "zlecenia" ("id_klienta")
TABLESPACE "serwis_komputerowy_tablespace"
;

-- Add keys for table zlecenia

ALTER TABLE "zlecenia" ADD CONSTRAINT "ID zlecenia" PRIMARY KEY ("id_zlecenia")
 USING INDEX TABLESPACE "serwis_komputerowy_tablespace"
;

-- Table klienci

CREATE TABLE "klienci"(
 "id_klienta" Integer NOT NULL,
 "imie" Character varying(30),
 "nazwisko" Character varying(40),
 "adres_email" Character varying(35),
 "nr_komorkowy" Character varying(12)
        CHECK (VALUE ~* '([(0)])([0-9]){9,}')
)
TABLESPACE "serwis_komputerowy_tablespace"
;

-- Add keys for table klienci

ALTER TABLE "klienci" ADD CONSTRAINT "ID klienta" PRIMARY KEY ("id_klienta")
 USING INDEX TABLESPACE "serwis_komputerowy_tablespace"
;

-- Table adresy

CREATE TABLE "adresy"(
 "id_adresu" Integer NOT NULL,
 "id_klienta" Integer NOT NULL,
 "ulica" Character varying(30),
 "nr_domu" Integer,
 "nr_lokalu" Integer
)
TABLESPACE "serwis_komputerowy_tablespace"
;

-- Create indexes for table adresy

CREATE INDEX "adresy_id_klienta" ON "adresy" ("id_klienta")
TABLESPACE "serwis_komputerowy_tablespace"
;

-- Add keys for table adresy

ALTER TABLE "adresy" ADD CONSTRAINT "ID adresu" PRIMARY KEY ("id_adresu")
 USING INDEX TABLESPACE "serwis_komputerowy_tablespace"
;

-- Table serwisanci

CREATE TABLE "serwisanci"(
 "id_serwisanta" Integer NOT NULL,
 "imie" Character varying(30),
 "nazwisko" Character varying(40),
 "nr_komorkowy" Character varying(12)
        CHECK (VALUE ~* '([(0)])([0-9]){9,}'),
 "specjalizacja" Text
)
TABLESPACE "serwis_komputerowy_tablespace"
;

-- Add keys for table serwisanci

ALTER TABLE "serwisanci" ADD CONSTRAINT "ID serwisanta" PRIMARY KEY ("id_serwisanta")
 USING INDEX TABLESPACE "serwis_komputerowy_tablespace"
;

-- Table statusy

CREATE TABLE "statusy"(
 "id_zlecenia" Integer NOT NULL,
 "status" Text,
 "typ_zwrotu" Text,
 "cena_naprawy" Double precision,
 "cena_podzespolow" Double precision
)
TABLESPACE "serwis_komputerowy_tablespace"
;

-- Add keys for table statusy

ALTER TABLE "statusy" ADD CONSTRAINT "ID statusu" PRIMARY KEY ("id_zlecenia")
 USING INDEX TABLESPACE "serwis_komputerowy_tablespace"
;

-- Table produkty

CREATE TABLE "produkty"(
 "id_produktu" Integer NOT NULL,
 "id_serwisanta" Integer,
 "nazwa_produktu" Character varying(30),
 "cena" Double precision,
 "dlugosc_gwarancji" Text
)
TABLESPACE "serwis_komputerowy_tablespace"
;

-- Create indexes for table produkty

CREATE INDEX "produkty_id_serwisanta" ON "produkty" ("id_serwisanta")
TABLESPACE "serwis_komputerowy_tablespace"
;

-- Add keys for table produkty

ALTER TABLE "produkty" ADD CONSTRAINT "ID produktu_produkty" PRIMARY KEY ("id_produktu")
 USING INDEX TABLESPACE "serwis_komputerowy_tablespace"
;

-- Table magazyn

CREATE TABLE "magazyn"(
 "id_produktu" Integer NOT NULL,
 "status" Text,
 "termin_dostawy" Date,
 "na_stanie" Bigint,
 "kategoria_sprzetu" Character varying(40)
)
TABLESPACE "serwis_komputerowy_tablespace"
;

-- Add keys for table magazyn

ALTER TABLE "magazyn" ADD CONSTRAINT "ID produktu_magazyn" PRIMARY KEY ("id_produktu")
 USING INDEX TABLESPACE "serwis_komputerowy_tablespace"
;

-- Create views section -------------------------------------------------

CREATE VIEW "archiwum" AS
SELECT "zlecenia"."id_zlecenia", "id_klienta", "id_serwisanta", "opis_usterki", "typ_sprzetu", "status", "typ_zwrotu"
FROM "zlecenia", "statusy"
WHERE "statusy"."status" = 'Zwrócony'
;

CREATE VIEW "produkty_niedostepne" AS
SELECT "produkty"."id_produktu", "nazwa_produktu", "cena", "status", "termin_dostawy"
FROM "produkty", "magazyn"
WHERE "produkty"."id_produktu" = "magazyn"."id_produktu"
;

CREATE VIEW "zasilacze" AS
SELECT "id_produktu", "status", "termin_dostawy", "na_stanie", "kategoria_sprzetu"
FROM "magazyn"
WHERE "kategoria_sprzetu" = 'Zasilacz'
;
-- Create foreign keys (relationships) section ------------------------------------------------- 

ALTER TABLE "zlecenia" ADD CONSTRAINT "należy do" FOREIGN KEY ("id_serwisanta") REFERENCES "serwisanci" ("id_serwisanta") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "adresy" ADD CONSTRAINT "mieszka" FOREIGN KEY ("id_klienta") REFERENCES "klienci" ("id_klienta") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "produkty" ADD CONSTRAINT "definiuje" FOREIGN KEY ("id_serwisanta") REFERENCES "serwisanci" ("id_serwisanta") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "zlecenia" ADD CONSTRAINT "przynależy do" FOREIGN KEY ("id_klienta") REFERENCES "klienci" ("id_klienta") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "statusy" ADD CONSTRAINT "sprawdza" FOREIGN KEY ("id_zlecenia") REFERENCES "zlecenia" ("id_zlecenia") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "magazyn" ADD CONSTRAINT "znajdują się w" FOREIGN KEY ("id_produktu") REFERENCES "produkty" ("id_produktu") ON DELETE NO ACTION ON UPDATE NO ACTION
;


ALTER SEQUENCE "id_serwisanta_increment" OWNED BY "serwisanci"."id_serwisanta"
;
ALTER SEQUENCE "id_zlecenia_increment" OWNED BY "zlecenia"."id_zlecenia"
;
ALTER SEQUENCE "id_klienta_increment" OWNED BY "klienci"."id_klienta"
;
ALTER SEQUENCE "id_produktu_increment" OWNED BY "produkty"."id_produktu"
;
ALTER SEQUENCE "id_adresu_increment" OWNED BY "adresy"."id_adresu"
;

-- Grant permissions section -------------------------------------------------


GRANT SELECT ON "serwisanci" TO "Serwisant"
;
GRANT INSERT ON "serwisanci" TO "Serwisant"
;
GRANT UPDATE ON "serwisanci" TO "Serwisant"
;
GRANT DELETE ON "serwisanci" TO "Serwisant"
;
GRANT REFERENCES ON "serwisanci" TO "Serwisant"
;
GRANT TRIGGER ON "serwisanci" TO "Serwisant"
;
GRANT TRUNCATE ON "serwisanci" TO "Serwisant"
;
GRANT SELECT ON "serwisanci" TO "Klienci"
;
GRANT SELECT ON "zlecenia" TO "Serwisant"
;
GRANT INSERT ON "zlecenia" TO "Serwisant"
;
GRANT UPDATE ON "zlecenia" TO "Serwisant"
;
GRANT DELETE ON "zlecenia" TO "Serwisant"
;
GRANT REFERENCES ON "zlecenia" TO "Serwisant"
;
GRANT TRIGGER ON "zlecenia" TO "Serwisant"
;
GRANT TRUNCATE ON "zlecenia" TO "Serwisant"
;
GRANT SELECT ON "zlecenia" TO "Klienci"
;
GRANT SELECT ON "klienci" TO "Serwisant"
;
GRANT INSERT ON "klienci" TO "Serwisant"
;
GRANT UPDATE ON "klienci" TO "Serwisant"
;
GRANT DELETE ON "klienci" TO "Serwisant"
;
GRANT REFERENCES ON "klienci" TO "Serwisant"
;
GRANT TRIGGER ON "klienci" TO "Serwisant"
;
GRANT TRUNCATE ON "klienci" TO "Serwisant"
;
GRANT SELECT ON "klienci" TO "Klienci"
;
GRANT UPDATE ON "klienci" TO "Klienci"
;
GRANT SELECT ON "produkty" TO "Serwisant"
;
GRANT INSERT ON "produkty" TO "Serwisant"
;
GRANT UPDATE ON "produkty" TO "Serwisant"
;
GRANT REFERENCES ON "produkty" TO "Serwisant"
;
GRANT TRIGGER ON "produkty" TO "Serwisant"
;
GRANT TRUNCATE ON "produkty" TO "Serwisant"
;
GRANT SELECT ON "produkty" TO "Klienci"
;
GRANT SELECT ON "statusy" TO "Serwisant"
;
GRANT INSERT ON "statusy" TO "Serwisant"
;
GRANT UPDATE ON "statusy" TO "Serwisant"
;
GRANT DELETE ON "statusy" TO "Serwisant"
;
GRANT REFERENCES ON "statusy" TO "Serwisant"
;
GRANT TRIGGER ON "statusy" TO "Serwisant"
;
GRANT TRUNCATE ON "statusy" TO "Serwisant"
;
GRANT SELECT ON "statusy" TO "Klienci"
;
GRANT SELECT ON "adresy" TO "Serwisant"
;
GRANT INSERT ON "adresy" TO "Serwisant"
;
GRANT UPDATE ON "adresy" TO "Serwisant"
;
GRANT DELETE ON "adresy" TO "Serwisant"
;
GRANT REFERENCES ON "adresy" TO "Serwisant"
;
GRANT TRIGGER ON "adresy" TO "Serwisant"
;
GRANT TRUNCATE ON "adresy" TO "Serwisant"
;
GRANT SELECT ON "adresy" TO "Klienci"
;
GRANT UPDATE ON "adresy" TO "Klienci"
;
GRANT SELECT ON "magazyn" TO "Serwisant"
;
GRANT INSERT ON "magazyn" TO "Serwisant"
;
GRANT UPDATE ON "magazyn" TO "Serwisant"
;
GRANT DELETE ON "magazyn" TO "Serwisant"
;
GRANT REFERENCES ON "magazyn" TO "Serwisant"
;
GRANT TRIGGER ON "magazyn" TO "Serwisant"
;
GRANT TRUNCATE ON "magazyn" TO "Serwisant"
;
GRANT SELECT ON "magazyn" TO "Klienci"
;
