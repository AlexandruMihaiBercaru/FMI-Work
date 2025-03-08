
--ex. 10: crearea de secvente

CREATE SEQUENCE seq_model
INCREMENT BY 1 START WITH 1000
MAXVALUE 99999
NOCYCLE NOCACHE;

CREATE SEQUENCE seq_angajat
INCREMENT BY 1 START WITH 100
MAXVALUE 99999
NOCYCLE NOCACHE;

CREATE SEQUENCE seq_general
INCREMENT BY 10 START WITH 10
MAXVALUE 99999
NOCYCLE NOCACHE;

CREATE SEQUENCE seq_furn
MAXVALUE 999
NOCYCLE NOCACHE;



--ex. 11: crearea tabelelor si inserarea datelor

CREATE TABLE ADRESA(
cod_adresa      NUMBER(5)       CONSTRAINT pk_adresa PRIMARY KEY,
nume_strada     VARCHAR2(50)    NOT NULL,
numar           VARCHAR2(10)    NOT NULL,
bloc            VARCHAR2(10),
apartament      NUMBER(5),
localitate      VARCHAR2(20)    NOT NULL,
judet           VARCHAR2(20)    NOT NULL,
CONSTRAINT unicitate_adr UNIQUE(nume_strada, numar, bloc, apartament, localitate, judet)
);


INSERT INTO ADRESA VALUES(seq_general.NEXTVAL, 'Str. Emil Racovita', '15C', 'P20', 13, 'Ploiesti', 'Prahova');
INSERT INTO ADRESA VALUES(seq_general.NEXTVAL, 'Bd. Alexandru Marghiloman', '78A', 'T7A', 28, 'Buzau', 'Buzau');
INSERT INTO ADRESA VALUES(seq_general.NEXTVAL, 'Str. Dorobanti', '21', NULL, 3, 'Mizil', 'Prahova');
INSERT INTO ADRESA VALUES(seq_general.NEXTVAL, 'Str. Parcului', '11', '18', 27, 'Berca', 'Buzau');
INSERT INTO ADRESA VALUES(seq_general.NEXTVAL, 'Bd. Unirii', '22', 'Flacara', 61, 'Buzau', 'Buzau');
INSERT INTO ADRESA(cod_adresa, nume_strada, numar, localitate, judet) VALUES(seq_general.NEXTVAL, 'Str. Stadionului', '42', 'Berca', 'Buzau');
INSERT INTO ADRESA(cod_adresa, nume_strada, numar, localitate, judet) VALUES(seq_general.NEXTVAL, 'Str. Aurorei', '25', 'Buzau', 'Buzau');
INSERT INTO ADRESA(cod_adresa, nume_strada, numar, localitate, judet) VALUES(seq_general.NEXTVAL, 'Str. Scolii', '24', 'Breaza', 'Buzau');
INSERT INTO ADRESA(cod_adresa, nume_strada, numar, localitate, judet) VALUES(seq_general.NEXTVAL, 'Str. Scolii', '4 Bis', 'Breaza', 'Prahova');
INSERT INTO ADRESA(cod_adresa, nume_strada, numar, localitate, judet) VALUES(seq_general.NEXTVAL, 'Str. Dorobanti', '13', 'Mizil', 'Prahova');
INSERT INTO ADRESA(cod_adresa, nume_strada, numar, localitate, judet) VALUES(seq_general.NEXTVAL, 'Str. Primaverii', '35', 'Buzau', 'Buzau');
INSERT INTO ADRESA(cod_adresa, nume_strada, numar, localitate, judet) VALUES(seq_general.NEXTVAL, 'Str. Canalului', '20', 'Candesti', 'Buzau');
INSERT INTO ADRESA(cod_adresa, nume_strada, numar, localitate, judet) VALUES(seq_general.NEXTVAL, 'Str. Viilor', '1', 'Candesti', 'Vrancea');
INSERT INTO ADRESA(cod_adresa, nume_strada, numar, localitate, judet) VALUES(seq_general.NEXTVAL, 'Str. Transilvaniei', '62', 'Buzau', 'Buzau');
INSERT INTO ADRESA(cod_adresa, nume_strada, numar, localitate, judet) VALUES(seq_general.NEXTVAL, 'Str. Stadionului', '63', 'Vadul Pasii', 'Buzau');
INSERT INTO ADRESA(cod_adresa, nume_strada, numar, localitate, judet) VALUES(seq_general.NEXTVAL, 'Str. Islazului', '105B', 'Maracineni', 'Buzau');
INSERT INTO ADRESA(cod_adresa, nume_strada, numar, localitate, judet) VALUES(seq_general.NEXTVAL, 'Bd. 1 Decembrie 1918', '25', 'Buzau', 'Buzau');
INSERT INTO ADRESA(cod_adresa, nume_strada, numar, localitate, judet) VALUES(seq_general.NEXTVAL, 'Soseaua Pogonele', '28', 'Buzau', 'Buzau');
INSERT INTO ADRESA(cod_adresa, nume_strada, numar, localitate, judet) VALUES(seq_general.NEXTVAL, 'Bd. Eroilor', '44', 'Ramnicu Sarat', 'Buzau');
INSERT INTO ADRESA(cod_adresa, nume_strada, numar, localitate, judet) VALUES(seq_general.NEXTVAL, 'Sos. Bucuresti', '88-92', 'Buzau', 'Buzau');
INSERT INTO ADRESA(cod_adresa, nume_strada, numar, localitate, judet) VALUES(seq_general.NEXTVAL, 'Str. Eroilor', '22-26', 'Mizil', 'Prahova');

COMMIT;
--SELECT * FROM ADRESA;



CREATE TABLE FURNIZOR(
cod_furnizor    NUMBER(3)      CONSTRAINT pk_furnizor PRIMARY KEY,
nume            VARCHAR2(50)   NOT NULL,
numar_telefon   CHAR(12)       NOT NULL,
adresa_email    VARCHAR2(50)   NOT NULL
);

--elimin constrangerea "adresa_email not null"
ALTER TABLE FURNIZOR DROP CONSTRAINT SYS_C007444;

INSERT INTO FURNIZOR VALUES(seq_furn.NEXTVAL, 'Alstom', '+40212721700', 'contact@transport.alstom.com');
INSERT INTO FURNIZOR VALUES(seq_furn.NEXTVAL, 'Siemens', '+40216296400', 'siemens.ro@siemens.com');
INSERT INTO FURNIZOR VALUES(seq_furn.NEXTVAL, 'TisTram', '+48516178828', 'kontakt@tistram.com');
INSERT INTO FURNIZOR VALUES(seq_furn.NEXTVAL, 'MEXIMPEX SRL', '+40213166847', null);
INSERT INTO FURNIZOR VALUES(seq_furn.NEXTVAL, 'Schaeffler Romania', '+40268505000', 'info.ro@schaeffler.com');
INSERT INTO FURNIZOR VALUES(seq_furn.NEXTVAL, 'Unix Automotive', '+40264501899', null);
INSERT INTO FURNIZOR VALUES(seq_furn.NEXTVAL, 'Räder-Vogel', '+494075499-0', 'rv@raedervogel.de');
INSERT INTO FURNIZOR VALUES(seq_furn.NEXTVAL, 'FAUR SA', '+40212556559', 'faur_marketing@bega.ro');
COMMIT;

--SELECT * FROM FURNIZOR;





CREATE TABLE MODEL(
cod_model               NUMBER(5)       CONSTRAINT pk_model PRIMARY KEY,
denumire_model          VARCHAR2(20)    UNIQUE NOT NULL,
tip_mijloc_transport    VARCHAR2(20)    NOT NULL CHECK (tip_mijloc_transport IN ('tramvai', 'autobuz', 'troleibuz')),
lungime                 NUMBER(2)       NOT NULL,
numar_scaune            NUMBER(3)       NOT NULL,
capacitate_calatori     NUMBER(3)       NOT NULL,
viteza_maxima           NUMBER(5,2)     NOT NULL,
CONSTRAINT verif_calatori CHECK(numar_scaune <= capacitate_calatori)
);

ALTER TABLE MODEL MODIFY viteza_maxima NUMBER(6, 2);
INSERT INTO MODEL VALUES(seq_model.NEXTVAL, 'Urbino 12 III', 'autobuz', 9, 28, 65, 80.6);
INSERT INTO MODEL VALUES(seq_model.NEXTVAL, 'Urbino IV Electric', 'autobuz', 9, 26, 69, 80.6);
INSERT INTO MODEL VALUES(seq_model.NEXTVAL, 'Trollino', 'troleibuz', 11, 32, 74, 75);
INSERT INTO MODEL VALUES(seq_model.NEXTVAL, '415T', 'troleibuz', 8, 28, 88, 55);
INSERT INTO MODEL VALUES(seq_model.NEXTVAL, '103', 'autobuz', 10, 40, 81, 65.5);
INSERT INTO MODEL VALUES(seq_model.NEXTVAL, 'Imperio', 'tramvai', 32, 56, 320, 66.6);
INSERT INTO MODEL VALUES(seq_model.NEXTVAL, 'Pesa Swing', 'tramvai', 26, 48, 256, 73.6);
INSERT INTO MODEL VALUES(seq_model.NEXTVAL, '263', 'autobuz', 8, 32, 88, 52);
INSERT INTO MODEL VALUES(seq_model.NEXTVAL, 'Trambus', 'troleibuz', 16, 50, 160, 77.8);
INSERT INTO MODEL VALUES(seq_model.NEXTVAL, 'Tramvay', 'tramvai', 32, 60, 330, 80.6);
COMMIT;
--SELECT * FROM MODEL;



CREATE TABLE TRASEU(
numar_traseu            NUMBER(3)                 CONSTRAINT pk_traseu PRIMARY KEY,
lungime                 NUMBER(4,2)               NOT NULL,
categorie               VARCHAR2(15)              NOT NULL CHECK(categorie IN ('urban', 'regional', 'temporar')),
frecventa               INTERVAL DAY TO SECOND    NOT NULL,
calatori_zilnic         NUMBER(6)                 NOT NULL
);
ALTER TABLE TRASEU MODIFY lungime NUMBER(6,2);
INSERT INTO TRASEU VALUES(1, 11.5, 'urban', INTERVAL '15' MINUTE, 3000);
INSERT INTO TRASEU VALUES(2, 23, 'regional', INTERVAL '100' MINUTE, 2000);
INSERT INTO TRASEU VALUES(5, 8.9, 'urban', INTERVAL '10' MINUTE, 15500);
INSERT INTO TRASEU VALUES(7, 33.2, 'regional', INTERVAL '30' MINUTE, 8400);
INSERT INTO TRASEU VALUES(8, 14, 'regional', INTERVAL '50' MINUTE, 3300);
INSERT INTO TRASEU VALUES(20, 8.2, 'urban', INTERVAL '8' MINUTE, 45000);
INSERT INTO TRASEU VALUES(22, 32.5, 'regional', INTERVAL '80' MINUTE, 4200);
INSERT INTO TRASEU VALUES(61, 5.2, 'urban', INTERVAL '20' MINUTE, 5100);
INSERT INTO TRASEU VALUES(66, 14.8, 'urban', INTERVAL '8' MINUTE, 35000);
INSERT INTO TRASEU VALUES(100, 6, 'temporar', INTERVAL '40' MINUTE, 15500);
COMMIT;
--SELECT * FROM TRASEU;


CREATE TABLE STATIE(
cod_statie          NUMBER(5)       CONSTRAINT pk_statie PRIMARY KEY,
nume                VARCHAR2(25)    NOT NULL UNIQUE,
localitate          VARCHAR2(25),
amplasament         VARCHAR2(100)   UNIQUE
);
    
INSERT INTO STATIE VALUES(seq_general.NEXTVAL, 'Piata de Flori', 'Buzau', 'Bd. Alexandru Marghiloman nr. 34');
INSERT INTO STATIE VALUES(seq_general.NEXTVAL, 'Teilor', 'Buzau', 'Bd. 1 Decembrie 1918 nr. 16');
INSERT INTO STATIE VALUES(seq_general.NEXTVAL, 'Crang', 'Buzau', 'Sos. Stadionului nr. 100');
INSERT INTO STATIE VALUES(seq_general.NEXTVAL, 'Muzeul Judetean', 'Buzau', 'Bd. Nicolae Balcescu nr. 360');
INSERT INTO STATIE VALUES(seq_general.NEXTVAL, 'Colegiul Hasdeu', 'Buzau', 'Bd. Garii nr. 50');
INSERT INTO STATIE VALUES(seq_general.NEXTVAL, 'Parul Marghiloman', 'Buzau', 'Bd. Alexandru Marghiloman nr. 202');
INSERT INTO STATIE VALUES(seq_general.NEXTVAL, 'Piata Centrala', 'Buzau', 'Bd. Unirii nr. 5');
INSERT INTO STATIE VALUES(seq_general.NEXTVAL, 'Rond Oltului', 'Buzau', 'Str. Oltului nr. 20');
INSERT INTO STATIE VALUES(seq_general.NEXTVAL, 'Filatura', 'Buzau', 'Sos. Stadionului nr. 40');
INSERT INTO STATIE VALUES(seq_general.NEXTVAL, 'Primarie', 'Buzau', 'Bd. Unirii nr. 68');
INSERT INTO STATIE VALUES(seq_general.NEXTVAL, 'Garlei', 'Buzau', 'Centura Est');
INSERT INTO STATIE VALUES(seq_general.NEXTVAL, 'Gara', 'Buzau', 'Bd. Garii nr. 2');
INSERT INTO STATIE VALUES(seq_general.NEXTVAL, 'Sarata Monteoru Bai', null, 'DN1B Popas Merei');
INSERT INTO STATIE VALUES(seq_general.NEXTVAL, 'Sarata Monteoru', 'Sarata Monteoru', 'Str. Brazilor nr. 1');
INSERT INTO STATIE VALUES(seq_general.NEXTVAL, 'Maracineni - Primarie', 'Maracineni', 'Sos. Buzaului nr. 100A');
INSERT INTO STATIE VALUES(seq_general.NEXTVAL, 'Pod Rau', 'Berca', 'Str. Debarcaderului nr. 30');
INSERT INTO STATIE VALUES(seq_general.NEXTVAL, 'Spitalul de Psihiatrie', 'Sapoca', 'DJ103K');
INSERT INTO STATIE VALUES(seq_general.NEXTVAL, 'Maracineni - Viilor', 'Maracineni', 'DJ203K');
INSERT INTO STATIE VALUES(seq_general.NEXTVAL, 'Pod Feroviar', 'Vadu Pasii', 'Str. Principala nr. 5');
COMMIT;
--SELECT p.*, s.nume  FROM STATIE s join parcurs_traseu p on p.cod_statie = s.cod_statie;



CREATE TABLE INTERVENTIE(
numar_interventie       NUMBER(5)                   CONSTRAINT pk_interventie PRIMARY KEY,
cauza                   VARCHAR2(100),              
durata                  INTERVAL DAY TO SECOND      NOT NULL
);

INSERT INTO INTERVENTIE VALUES(seq_general.NEXTVAL, 'Lipsa Tensiune', INTERVAL '2:30' HOUR TO MINUTE);
INSERT INTO INTERVENTIE VALUES(seq_general.NEXTVAL, 'Eveniment Circulatie', INTERVAL '3' HOUR);
INSERT INTO INTERVENTIE VALUES(seq_general.NEXTVAL, 'Eveniment Circulatie', INTERVAL '30' MINUTE);
INSERT INTO INTERVENTIE VALUES(seq_general.NEXTVAL, 'Copac Cazut', INTERVAL '2:30' HOUR TO MINUTE);
INSERT INTO INTERVENTIE VALUES(seq_general.NEXTVAL, 'Eveniment Circulatie', INTERVAL '4:30' HOUR TO MINUTE);
INSERT INTO INTERVENTIE VALUES(seq_general.NEXTVAL, 'Eveniment Circulatie', INTERVAL '50' MINUTE);
INSERT INTO INTERVENTIE VALUES(seq_general.NEXTVAL, 'Eveniment Circulatie', INTERVAL '100' MINUTE);
INSERT INTO INTERVENTIE VALUES(seq_general.NEXTVAL, 'Lipsa Tensiune', INTERVAL '45' MINUTE);
COMMIT;
--SELECT * FROM INTERVENTIE;


CREATE TABLE DEPOU(
cod_depou       NUMBER(5)       CONSTRAINT pk_depou PRIMARY KEY,
denumire_depou  VARCHAR2(50)    UNIQUE NOT NULL,
an_infiintare   DATE            NOT NULL,
capacitate      NUMBER(3)       NOT NULL,
categorie       VARCHAR2(50)    NOT NULL CHECK(categorie IN('autobaza', 'depou tramvaie', 'depou troleibuze', 'depou mixt')),
cod_adresa      NUMBER(5)       CONSTRAINT fk_depou REFERENCES ADRESA(cod_adresa) ON DELETE SET NULL
);

ALTER TABLE DEPOU ADD CONSTRAINT addr_unic_dep UNIQUE(cod_adresa);
INSERT INTO DEPOU VALUES(seq_general.NEXTVAL, 'Depou Industriilor', TO_DATE('01/06/1998', 'dd/mm/yyyy'), 25, 'autobaza', 210);
INSERT INTO DEPOU VALUES(seq_general.NEXTVAL, 'Depou Florilor', TO_DATE('01/06/1987', 'dd/mm/yyyy'), 15, 'depou tramvaie', 200);
INSERT INTO DEPOU VALUES(seq_general.NEXTVAL, 'Depou Sud', TO_DATE('01/06/2004', 'dd/mm/yyyy'), 32, 'depou troleibuze', 180);
INSERT INTO DEPOU VALUES(seq_general.NEXTVAL, 'Depou Moldovei', TO_DATE('01/06/1976', 'dd/mm/yyyy'), 60, 'depou mixt', 170);
INSERT INTO DEPOU VALUES(seq_general.NEXTVAL, 'Depou Transilvaniei', TO_DATE('01/06/1962', 'dd/mm/yyyy'), 15, 'autobaza', 140);
COMMIT;
--SELECT * FROM DEPOU;



CREATE TABLE VEHICUL(
cod_vehicul         NUMBER(5)       CONSTRAINT pk_vehicul PRIMARY KEY,
producator          VARCHAR2(25)    NOT NULL,
an_achizitie        DATE            NOT NULL,
data_verificare     DATE            NOT NULL,
kilometraj          NUMBER(10)      DEFAULT 0,
intrebuintare       VARCHAR2(20)    CHECK(intrebuintare IN('transport', 'interventie')),
cod_depou           NUMBER(5)       NOT NULL,

CONSTRAINT fk_vehicul FOREIGN KEY (cod_depou) REFERENCES DEPOU(cod_depou) ON DELETE SET NULL
);

ALTER TABLE VEHICUL MODIFY data_verificare DEFAULT TO_DATE('15/09/2023', 'dd/mm/yyyy');

INSERT INTO VEHICUL VALUES(902, 'Ikarus', TO_DATE('1987', 'yyyy'), DEFAULT, 3240000, 'transport', 660);
INSERT INTO VEHICUL VALUES(903, 'Ikarus', TO_DATE('1987', 'yyyy'), TO_DATE('13/10/2014', 'dd/mm/yyyy'), 2800000, 'transport', 660);
INSERT INTO VEHICUL VALUES(906, 'Ikarus', TO_DATE('1999', 'yyyy'), TO_DATE('15/11/2018', 'dd/mm/yyyy'), 2250000, 'transport', 650);
INSERT INTO VEHICUL VALUES(907, 'Ikarus', TO_DATE('1999', 'yyyy'), TO_DATE('15/10/2022', 'dd/mm/yyyy'), 1840000, 'transport', 650);
INSERT INTO VEHICUL VALUES(910, 'Solaris', TO_DATE('2022', 'yyyy'), DEFAULT, 144500, 'transport', 640);
INSERT INTO VEHICUL VALUES(911, 'Solaris', TO_DATE('2021', 'yyyy'), DEFAULT, 267800, 'transport', 640);
INSERT INTO VEHICUL VALUES(913, 'Bozankaya', TO_DATE('2021', 'yyyy'), TO_DATE('15/10/2022', 'dd/mm/yyyy'), 21000, 'transport', 640);
INSERT INTO VEHICUL VALUES(1300, 'Bozankaya', TO_DATE('2022', 'yyyy'), DEFAULT, 65650, 'transport', 630);
INSERT INTO VEHICUL VALUES(1301, 'Bozankaya', TO_DATE('2022', 'yyyy'), DEFAULT, 88500, 'transport', 630);
INSERT INTO VEHICUL VALUES(1302, 'PESA', TO_DATE('2018', 'yyyy'), TO_DATE('15/10/2022', 'dd/mm/yyyy'), 289430, 'transport', 630);
INSERT INTO VEHICUL VALUES(1303, 'PESA', TO_DATE('2018', 'yyyy'), TO_DATE('15/10/2022', 'dd/mm/yyyy'), 432090, 'transport', 650);
INSERT INTO VEHICUL VALUES(1310, 'Astra Vagoane Calatori', TO_DATE('2020', 'yyyy'), DEFAULT, 58040, 'transport', 630);
INSERT INTO VEHICUL VALUES(1312, 'Astra Vagoane Calatori', TO_DATE('2022', 'yyyy'), DEFAULT, 58390, 'transport', 650);
INSERT INTO VEHICUL VALUES(2001, 'Solaris', TO_DATE('2021', 'yyyy'), TO_DATE('15/10/2022', 'dd/mm/yyyy'), 20090, 'transport', 620);
INSERT INTO VEHICUL VALUES(2002, 'Solaris', TO_DATE('2023', 'yyyy'), DEFAULT, 18500, 'transport', 620);
INSERT INTO VEHICUL VALUES(2003, 'Solaris', TO_DATE('2021', 'yyyy'), TO_DATE('15/10/2022', 'dd/mm/yyyy'), 16090, 'transport', 650);
INSERT INTO VEHICUL VALUES(2004, 'MAZ', TO_DATE('1980', 'yyyy'), DEFAULT, 387950, 'transport', 660);
INSERT INTO VEHICUL VALUES(2005, 'MAZ', TO_DATE('1980', 'yyyy'), TO_DATE('13/10/2014', 'dd/mm/yyyy'), 388930, 'transport', 650);
INSERT INTO VEHICUL VALUES(2006, 'Solaris', TO_DATE('2022', 'yyyy'), TO_DATE('15/10/2022', 'dd/mm/yyyy'), 32540, 'transport', 650);
INSERT INTO VEHICUL VALUES(3300, 'Ikarus', TO_DATE('2009', 'yyyy'), TO_DATE('15/11/2018', 'dd/mm/yyyy'), 34000, 'interventie', 650);
INSERT INTO VEHICUL VALUES(3301, 'MAN', TO_DATE('2006', 'yyyy'), TO_DATE('13/10/2014', 'dd/mm/yyyy'), 14090, 'interventie', 640);
INSERT INTO VEHICUL VALUES(3302, 'Mercedes', TO_DATE('1999', 'yyyy'), TO_DATE('15/11/2018', 'dd/mm/yyyy'), 108900, 'interventie', 620);
INSERT INTO VEHICUL VALUES(3303, 'ROMAN', TO_DATE('1973', 'yyyy'), TO_DATE('13/10/2014', 'dd/mm/yyyy'), 549720, 'interventie', 630);
INSERT INTO VEHICUL VALUES(3304, 'ROMAN', TO_DATE('1975', 'yyyy'), TO_DATE('13/10/2014', 'dd/mm/yyyy'), 519730, 'interventie', 660);

COMMIT;
SELECT * FROM VEHICUL;


CREATE TABLE VEHICUL_TRANSPORT(
cod_vehicul_tr      NUMBER(5)       CONSTRAINT pk_veh_tr PRIMARY KEY,
stare               VARCHAR2(20)    DEFAULT 'functional' 
                                    CONSTRAINT verif_stare CHECK(stare IN('functional', 'defect', 'in reparatie')),           
cod_model           NUMBER(5)       NOT NULL, 
CONSTRAINT fk_veh_tr_1 FOREIGN KEY (cod_model) REFERENCES MODEL(cod_model) ON DELETE SET NULL,
CONSTRAINT fk_veh_tr_2 FOREIGN KEY (cod_vehicul_tr) REFERENCES VEHICUL(cod_vehicul) ON DELETE CASCADE
);
--am eliminat constrangerea "cod_model is not null"
ALTER TABLE vehicul_transport DROP CONSTRAINT SYS_C007506;

INSERT INTO VEHICUL_TRANSPORT VALUES(902, DEFAULT, 1004);
INSERT INTO VEHICUL_TRANSPORT VALUES(903, DEFAULT, 1004);
INSERT INTO VEHICUL_TRANSPORT VALUES(906, 'in reparatie', 1003);
INSERT INTO VEHICUL_TRANSPORT VALUES(907, DEFAULT, 1003);
INSERT INTO VEHICUL_TRANSPORT VALUES(910, DEFAULT, 1002);
INSERT INTO VEHICUL_TRANSPORT VALUES(911, 'defect', 1002);
INSERT INTO VEHICUL_TRANSPORT VALUES(913,  DEFAULT, 1008);
INSERT INTO VEHICUL_TRANSPORT VALUES(1300, DEFAULT, 1009);
INSERT INTO VEHICUL_TRANSPORT VALUES(1301, DEFAULT, 1009);
INSERT INTO VEHICUL_TRANSPORT VALUES(1302, DEFAULT, 1006);
INSERT INTO VEHICUL_TRANSPORT VALUES(1303, 'in reparatie', 1006);
INSERT INTO VEHICUL_TRANSPORT VALUES(1310, DEFAULT, 1005);
INSERT INTO VEHICUL_TRANSPORT VALUES(1312, 'defect', 1005);
INSERT INTO VEHICUL_TRANSPORT VALUES(2001, DEFAULT, 1000);
INSERT INTO VEHICUL_TRANSPORT VALUES(2002, DEFAULT, 1000);
INSERT INTO VEHICUL_TRANSPORT VALUES(2003, DEFAULT, 1000);
INSERT INTO VEHICUL_TRANSPORT VALUES(2004, 'defect', 1007);
INSERT INTO VEHICUL_TRANSPORT VALUES(2005, DEFAULT, 1007);
INSERT INTO VEHICUL_TRANSPORT VALUES(2006, 'in reparatie', 1001);
COMMIT;


CREATE TABLE VEHICUL_INTERVENTIE(
cod_vehicul_int         NUMBER(5)       CONSTRAINT pk_veh_int PRIMARY KEY,
categorie_utilitate     VARCHAR2(50)    NOT NULL,
CONSTRAINT fk_veh_int FOREIGN KEY(cod_vehicul_int) REFERENCES VEHICUL(cod_vehicul) ON DELETE CASCADE
);

INSERT INTO VEHICUL_INTERVENTIE VALUES(3300, 'tractor');
INSERT INTO VEHICUL_INTERVENTIE VALUES(3301, 'autospeciala interventie retea');
INSERT INTO VEHICUL_INTERVENTIE VALUES(3302, 'automacara');
INSERT INTO VEHICUL_INTERVENTIE VALUES(3303, 'plug');
INSERT INTO VEHICUL_INTERVENTIE VALUES(3304, 'autospeciala interventie retea');
COMMIT;
--SELECT* FROM vehicul_interventie;


CREATE TABLE PARCURS_TRASEU(
numar_traseu        NUMBER(3)       CONSTRAINT fk_parcurs_1 REFERENCES TRASEU(numar_traseu) ON DELETE CASCADE,
cod_statie          NUMBER(5)       CONSTRAINT fk_parcurs_2 REFERENCES STATIE(cod_statie) ON DELETE CASCADE,
CONSTRAINT pk_parcurs PRIMARY KEY(numar_traseu, cod_statie)
);

INSERT INTO PARCURS_TRASEU VALUES(1, 270);
INSERT INTO PARCURS_TRASEU VALUES(1, 220);
INSERT INTO PARCURS_TRASEU VALUES(1, 240);
INSERT INTO PARCURS_TRASEU VALUES(2, 330);
INSERT INTO PARCURS_TRASEU VALUES(2, 340);
INSERT INTO PARCURS_TRASEU VALUES(2, 350);
INSERT INTO PARCURS_TRASEU VALUES(5, 250);
INSERT INTO PARCURS_TRASEU VALUES(5, 260);
INSERT INTO PARCURS_TRASEU VALUES(7, 280);
INSERT INTO PARCURS_TRASEU VALUES(7, 360);
INSERT INTO PARCURS_TRASEU VALUES(7, 390);
INSERT INTO PARCURS_TRASEU VALUES(7, 370);
INSERT INTO PARCURS_TRASEU VALUES(8, 330);
INSERT INTO PARCURS_TRASEU VALUES(8, 360);
INSERT INTO PARCURS_TRASEU VALUES(8, 400);
INSERT INTO PARCURS_TRASEU VALUES(20, 330);
INSERT INTO PARCURS_TRASEU VALUES(20, 310);
INSERT INTO PARCURS_TRASEU VALUES(22, 310);
INSERT INTO PARCURS_TRASEU VALUES(22, 380);
INSERT INTO PARCURS_TRASEU VALUES(61, 270);
INSERT INTO PARCURS_TRASEU VALUES(61, 220);
INSERT INTO PARCURS_TRASEU VALUES(61, 320);
INSERT INTO PARCURS_TRASEU VALUES(61, 290);
INSERT INTO PARCURS_TRASEU VALUES(61, 240);
INSERT INTO PARCURS_TRASEU VALUES(66, 300);
INSERT INTO PARCURS_TRASEU VALUES(66, 290);
INSERT INTO PARCURS_TRASEU VALUES(66, 260);
INSERT INTO PARCURS_TRASEU VALUES(100, 280);
INSERT INTO PARCURS_TRASEU VALUES(100, 310);
INSERT INTO PARCURS_TRASEU VALUES(100, 330);
COMMIT;
SELECT * FROM PARCURS_TRASEU;




CREATE TABLE ANGAJAT(
cod_angajat         NUMBER(5)          CONSTRAINT pk_angajat PRIMARY KEY,
nume                VARCHAR2(25)       NOT NULL,
prenume             VARCHAR2(25)       NOT NULL,
numar_telefon       CHAR(12)           UNIQUE,
data_angajare       DATE               DEFAULT TO_DATE('01-01-2000','DD-MM-YYYY'),
salariu             NUMBER(5)          NOT NULL CHECK(salariu > 0),
tip_job             VARCHAR2(25)       NOT NULL,
cod_adresa          NUMBER(5)          CONSTRAINT fk_ang_adr REFERENCES ADRESA(cod_adresa) ON DELETE SET NULL,
cod_depou           NUMBER(5)          CONSTRAINT fk_ang_dep REFERENCES DEPOU(cod_depou) ON DELETE SET NULL
);

INSERT INTO ANGAJAT VALUES(seq_angajat.NEXTVAL, 'Moise', 'Laurentiu', '+40700000001', TO_DATE('15-06-1986','DD-MM-YYYY'), 5400, 'sofer', 130, 620);
INSERT INTO ANGAJAT VALUES(seq_angajat.NEXTVAL, 'Popescu', 'Marius', '+40700000002', TO_DATE('20-09-1998','DD-MM-YYYY'), 4300, 'sofer', 40, 650);
INSERT INTO ANGAJAT VALUES(seq_angajat.NEXTVAL, 'Marinescu', 'Matei', '+40700000003', TO_DATE('01-03-2019','DD-MM-YYYY'), 3200, 'sofer', 70, 650);
INSERT INTO ANGAJAT VALUES(seq_angajat.NEXTVAL, 'Pisica', 'Catalin', '+40700000004', TO_DATE('20-09-2012','DD-MM-YYYY'), 4400, 'sofer', 30, 650);
INSERT INTO ANGAJAT VALUES(seq_angajat.NEXTVAL, 'Georgescu', 'George', '+40700000005', TO_DATE('15-06-1986','DD-MM-YYYY'), 4600, 'sofer', 10, 640);
INSERT INTO ANGAJAT VALUES(seq_angajat.NEXTVAL, 'Badescu', 'Stefan', '+40700000006', TO_DATE('01-03-2019','DD-MM-YYYY'), 2800, 'sofer', 80, 660);
INSERT INTO ANGAJAT VALUES(seq_angajat.NEXTVAL, 'Stoica', 'Maria', '+40700000007', TO_DATE('20-09-2009','DD-MM-YYYY'), 5000, 'sofer', 30, 630);
INSERT INTO ANGAJAT VALUES(seq_angajat.NEXTVAL, 'Moldoveanu', 'Sorin', '+40700000010', TO_DATE('20-09-2012','DD-MM-YYYY'), 4200, 'sofer', 10, 630);

INSERT INTO ANGAJAT VALUES(seq_angajat.NEXTVAL, 'Tunaru', 'Gheorghe', '+40700000011', TO_DATE('15-06-1986','DD-MM-YYYY'), 3100, 'mecanic', 90, 630);
INSERT INTO ANGAJAT VALUES(seq_angajat.NEXTVAL, 'Popescu', 'Flavius', '+40700000012', TO_DATE('20-09-1998','DD-MM-YYYY'), 1900, 'mecanic', 40, 630);
INSERT INTO ANGAJAT VALUES(seq_angajat.NEXTVAL, 'Zugravu', 'Doru', '+40700000013', TO_DATE('01-03-2019','DD-MM-YYYY'), 2200, 'mecanic', 80, 640);
INSERT INTO ANGAJAT VALUES(seq_angajat.NEXTVAL, 'Stanciu', 'Mihai', '+40700000014', TO_DATE('12-07-2001','DD-MM-YYYY'), 2500, 'mecanic', 60, 640);
INSERT INTO ANGAJAT VALUES(seq_angajat.NEXTVAL, 'Vulpescu', 'Safta', '+40700000015', TO_DATE('15-06-1986','DD-MM-YYYY'), 3000, 'mecanic', 50, 620);

INSERT INTO ANGAJAT VALUES(seq_angajat.NEXTVAL, 'Dumitrescu', 'Cosmin', '+40700000016', TO_DATE('20-09-1998','DD-MM-YYYY'), 7200, 'inginer', 120, 640);
INSERT INTO ANGAJAT VALUES(seq_angajat.NEXTVAL, 'Negulescu', 'Traian', '+40700000017', DEFAULT, 8100, 'inginer', 130, 630);
INSERT INTO ANGAJAT VALUES(seq_angajat.NEXTVAL, 'Moise', 'Maria', '+40700000018', TO_DATE('15-06-1986','DD-MM-YYYY'), 7450, 'inginer', 100, 650);
INSERT INTO ANGAJAT VALUES(seq_angajat.NEXTVAL, 'Constantinescu', 'Mihai', '+40700000019', DEFAULT, 8000, 'inginer', 190, 650);
INSERT INTO ANGAJAT VALUES(seq_angajat.NEXTVAL, 'Gradinaru', 'Cristian', '+40700000020', TO_DATE('20-09-2012','DD-MM-YYYY'), 8050, 'inginer', 40, 650);
COMMIT;
--SELECT* FROM ANGAJAT;



CREATE TABLE SOFER(
cod_sofer           NUMBER(5)           CONSTRAINT pk_sofer PRIMARY KEY,
experienta          NUMBER(2)           NOT NULL,
categorie_permis    VARCHAR2(5)         NOT NULL CHECK(categorie_permis IN('BUS', 'TRAM', 'TRL')),
data_expirare       DATE                NOT NULL,
CONSTRAINT fk_sofer FOREIGN KEY(cod_sofer) REFERENCES ANGAJAT(cod_angajat) ON DELETE CASCADE
);

ALTER TABLE SOFER MODIFY data_expirare DEFAULT TO_DATE('31/05/2025', 'dd-mm-yyyy');
INSERT INTO SOFER VALUES(100, 45, 'BUS', DEFAULT);
INSERT INTO SOFER VALUES(101, 24, 'TRL', DEFAULT);
INSERT INTO SOFER VALUES(102, 15, 'BUS', TO_DATE('12-07-2027','DD-MM-YYYY'));
INSERT INTO SOFER VALUES(103, 42, 'TRL', TO_DATE('12-07-2027','DD-MM-YYYY'));
INSERT INTO SOFER VALUES(104, 7, 'BUS', TO_DATE('17-08-2029','DD-MM-YYYY'));
INSERT INTO SOFER VALUES(105, 20, 'TRAM', DEFAULT);
INSERT INTO SOFER VALUES(106, 22, 'TRAM', TO_DATE('12-07-2027','DD-MM-YYYY'));
INSERT INTO SOFER VALUES(117, 33, 'TRAM', TO_DATE('17-08-2029','DD-MM-YYYY'));
COMMIT;
--SELECT s.*, a.cod_depou FROM SOFER s join angajat a on a.cod_angajat = s.cod_sofer;



CREATE TABLE MECANIC(
cod_mecanic         NUMBER(5)           CONSTRAINT pk_mecanic PRIMARY KEY,
specializare        VARCHAR2(20),
CONSTRAINT fk_mecanic FOREIGN KEY(cod_mecanic) REFERENCES ANGAJAT(cod_angajat) ON DELETE CASCADE
);

INSERT INTO MECANIC VALUES(107, 'Maistru Mecanic Auto');
INSERT INTO MECANIC VALUES(108, 'Tehnician Utiaje');
INSERT INTO MECANIC VALUES(109, 'Maistru Sudura');
INSERT INTO MECANIC VALUES(110, 'Maistru Mecanic Auto');
INSERT INTO MECANIC VALUES(111, 'Maistru Mecanic Auto');
COMMIT;
--SELECT * FROM mecanic;


CREATE TABLE INGINER(
cod_inginer             NUMBER(5)       CONSTRAINT pk_inginer PRIMARY KEY,
institutie_absolvita    VARCHAR2(100)   NOT NULL,
CONSTRAINT fk_inginer FOREIGN KEY(cod_inginer) REFERENCES ANGAJAT(cod_angajat) ON DELETE CASCADE
);

INSERT INTO INGINER VALUES(112, 'Facultatea de Transporturi, UPB');
INSERT INTO INGINER VALUES(113, 'Facultatea de Autovehicule Rutiere si Mecanica, UTCN');
INSERT INTO INGINER VALUES(114, 'Facultatea de Ingineria Traficului, ULBS');
INSERT INTO INGINER VALUES(115, 'Facultatea de Inginerie Mecanica, UPB');
INSERT INTO INGINER VALUES(116, 'Facultatea de Ingineria Traficului, ULBS');
COMMIT;
--SELECT * FROM INGINER;


CREATE TABLE CURSA(
cod_sofer               NUMBER(5)       CONSTRAINT fk_cursa_sof REFERENCES SOFER(cod_sofer) ON DELETE CASCADE,
cod_vehicul_tr          NUMBER(5)       CONSTRAINT fk_cursa_veh REFERENCES VEHICUL_TRANSPORT(cod_vehicul_tr) ON DELETE CASCADE,
numar_traseu            NUMBER(3)       CONSTRAINT fk_cursa_trs REFERENCES TRASEU(numar_traseu) ON DELETE CASCADE,
data_cursa              DATE            NOT NULL,
ora_preluare            DATE            NOT NULL,
ora_incepere_ture       DATE            NOT NULL,
ora_finalizare_ture     DATE            NOT NULL,
ora_predare             DATE            NOT NULL,
numar_ture              NUMBER(3)       NOT NULL,
CONSTRAINT pk_cursa PRIMARY KEY(cod_sofer, cod_vehicul_tr, numar_traseu, data_cursa),
CONSTRAINT sof_zi_unic UNIQUE(cod_sofer, data_cursa),
CONSTRAINT verif_ore CHECK(ora_incepere_ture - ora_preluare > 0 
                           AND ora_finalizare_ture - ora_incepere_ture > 0 
                           AND ora_predare - ora_finalizare_ture > 0)
);

INSERT INTO CURSA VALUES(100, 2001, 1, TO_DATE('30/05/2024', 'DD/MM/YYYY'), TO_DATE('06:14', 'HH24:MI'), TO_DATE('06:30', 'HH24:MI'),
TO_DATE('14:25', 'HH24:MI'), TO_DATE('14:40', 'HH24:MI'), 12);
INSERT INTO CURSA VALUES(100, 2001, 2, TO_DATE('28/04/2024', 'DD/MM/YYYY'), TO_DATE('05:59', 'HH24:MI'), TO_DATE('06:18', 'HH24:MI'),
TO_DATE('13:57', 'HH24:MI'), TO_DATE('14:05', 'HH24:MI'), 7);
INSERT INTO CURSA VALUES(100, 2002, 1, TO_DATE('14/05/2024', 'DD/MM/YYYY'), TO_DATE('15:23', 'HH24:MI'), TO_DATE('15:40', 'HH24:MI'),
TO_DATE('22:25', 'HH24:MI'), TO_DATE('22:47', 'HH24:MI'), 13);
INSERT INTO CURSA VALUES(101, 907, 61, TO_DATE('30/05/2024', 'DD/MM/YYYY'), TO_DATE('06:23', 'HH24:MI'), TO_DATE('06:35', 'HH24:MI'),
TO_DATE('14:02', 'HH24:MI'), TO_DATE('14:23', 'HH24:MI'), 21);
INSERT INTO CURSA VALUES(101, 907, 61, TO_DATE('14/05/2024', 'DD/MM/YYYY'), TO_DATE('06:25', 'HH24:MI'), TO_DATE('06:33', 'HH24:MI'),
TO_DATE('14:06', 'HH24:MI'), TO_DATE('14:28', 'HH24:MI'), 20);
INSERT INTO CURSA VALUES(102, 2003, 8, TO_DATE('28/05/2024', 'DD/MM/YYYY'), TO_DATE('13:30', 'HH24:MI'), TO_DATE('13:35', 'HH24:MI'),
TO_DATE('21:10', 'HH24:MI'), TO_DATE('21:19', 'HH24:MI'), 11);
INSERT INTO CURSA VALUES(102, 2005, 2, TO_DATE('30/05/2024', 'DD/MM/YYYY'), TO_DATE('06:23', 'HH24:MI'), TO_DATE('06:40', 'HH24:MI'),
TO_DATE('15:01', 'HH24:MI'), TO_DATE('15:23', 'HH24:MI'), 8);
INSERT INTO CURSA VALUES(102, 2006, 100, TO_DATE('28/04/2024', 'DD/MM/YYYY'), TO_DATE('06:50', 'HH24:MI'), TO_DATE('07:00', 'HH24:MI'),
TO_DATE('13:30', 'HH24:MI'), TO_DATE('13:50', 'HH24:MI'), 22);
INSERT INTO CURSA VALUES(103, 911, 61, TO_DATE('14/05/2024', 'DD/MM/YYYY'), TO_DATE('05:55', 'HH24:MI'), TO_DATE('06:03', 'HH24:MI'),
TO_DATE('13:01', 'HH24:MI'), TO_DATE('13:09', 'HH24:MI'), 10);
INSERT INTO CURSA VALUES(103, 911, 61, TO_DATE('13/05/2024', 'DD/MM/YYYY'), TO_DATE('05:54', 'HH24:MI'), TO_DATE('06:04', 'HH24:MI'),
TO_DATE('13:09', 'HH24:MI'), TO_DATE('13:15', 'HH24:MI'), 7);
INSERT INTO CURSA VALUES(104, 902, 1, TO_DATE('14/05/2024', 'DD/MM/YYYY'), TO_DATE('05:25', 'HH24:MI'), TO_DATE('06:00', 'HH24:MI'),
TO_DATE('13:00', 'HH24:MI'), TO_DATE('13:05', 'HH24:MI'), 12);
INSERT INTO CURSA VALUES(104, 903, 5, TO_DATE('24/04/2024', 'DD/MM/YYYY'), TO_DATE('05:46', 'HH24:MI'), TO_DATE('06:02', 'HH24:MI'),
TO_DATE('14:43', 'HH24:MI'), TO_DATE('15:00', 'HH24:MI'), 23);
INSERT INTO CURSA VALUES(105, 1301, 20, TO_DATE('14/05/2024', 'DD/MM/YYYY'), TO_DATE('05:12', 'HH24:MI'), TO_DATE('05:30', 'HH24:MI'),
TO_DATE('21:15', 'HH24:MI'), TO_DATE('21:30', 'HH24:MI'), 15);
INSERT INTO CURSA VALUES(105, 1302, 20, TO_DATE('28/05/2024', 'DD/MM/YYYY'), TO_DATE('05:15', 'HH24:MI'), TO_DATE('05:31', 'HH24:MI'),
TO_DATE('21:21', 'HH24:MI'), TO_DATE('21:30', 'HH24:MI'), 16);
INSERT INTO CURSA VALUES(105, 1301, 20, TO_DATE('30/05/2024', 'DD/MM/YYYY'), TO_DATE('05:10', 'HH24:MI'), TO_DATE('05:30', 'HH24:MI'),
TO_DATE('21:43', 'HH24:MI'), TO_DATE('22:00', 'HH24:MI'), 15);
INSERT INTO CURSA VALUES(117, 1303, 20, TO_DATE('14/04/2024', 'DD/MM/YYYY'), TO_DATE('05:45', 'HH24:MI'), TO_DATE('06:13', 'HH24:MI'),
TO_DATE('22:22', 'HH24:MI'), TO_DATE('22:45', 'HH24:MI'), 17);
INSERT INTO CURSA VALUES(117, 1303, 22, TO_DATE('28/04/2024', 'DD/MM/YYYY'), TO_DATE('05:43', 'HH24:MI'), TO_DATE('06:15', 'HH24:MI'),
TO_DATE('21:59', 'HH24:MI'), TO_DATE('22:08', 'HH24:MI'), 17);
COMMIT;
SELECT cod_sofer, cod_vehicul_tr, numar_traseu, data_cursa,
TO_CHAR(ora_preluare, 'hh24:mi') t1, TO_CHAR(ora_incepere_ture, 'hh24:mi') t2,
TO_CHAR(ora_finalizare_ture, 'hh24:mi') t3, TO_CHAR(ora_predare, 'hh24:mi') t4, numar_ture FROM CURSA;





CREATE TABLE PARTICIPARE_INTERVENTIE(
cod_mecanic             NUMBER(5)       CONSTRAINT fk_part_mec REFERENCES MECANIC(cod_mecanic) ON DELETE CASCADE,
cod_vehicul_int         NUMBER(5)       CONSTRAINT fk_part_veh REFERENCES VEHICUL_INTERVENTIE(cod_vehicul_int) ON DELETE CASCADE,
numar_interventie       NUMBER(5)       CONSTRAINT fk_part_int REFERENCES INTERVENTIE(numar_interventie) ON DELETE CASCADE,
CONSTRAINT pk_part PRIMARY KEY(cod_mecanic, cod_vehicul_int, numar_interventie)
);
INSERT INTO PARTICIPARE_INTERVENTIE VALUES(107, 3304, 500);
INSERT INTO PARTICIPARE_INTERVENTIE VALUES(108, 3304, 500);
INSERT INTO PARTICIPARE_INTERVENTIE VALUES(109, 3301, 500);
INSERT INTO PARTICIPARE_INTERVENTIE VALUES(107, 3304, 510);
INSERT INTO PARTICIPARE_INTERVENTIE VALUES(108, 3300, 510);
INSERT INTO PARTICIPARE_INTERVENTIE VALUES(109, 3301, 520);
INSERT INTO PARTICIPARE_INTERVENTIE VALUES(110, 3301, 520);
INSERT INTO PARTICIPARE_INTERVENTIE VALUES(111, 3300, 520);
INSERT INTO PARTICIPARE_INTERVENTIE VALUES(108, 3302, 530);
INSERT INTO PARTICIPARE_INTERVENTIE VALUES(110, 3302, 540);
INSERT INTO PARTICIPARE_INTERVENTIE VALUES(111, 3304, 540);
INSERT INTO PARTICIPARE_INTERVENTIE VALUES(109, 3302, 550);
INSERT INTO PARTICIPARE_INTERVENTIE VALUES(107, 3304, 550);
INSERT INTO PARTICIPARE_INTERVENTIE VALUES(110, 3304, 550);
INSERT INTO PARTICIPARE_INTERVENTIE VALUES(108, 3304, 560);
INSERT INTO PARTICIPARE_INTERVENTIE VALUES(110, 3304, 560);
INSERT INTO PARTICIPARE_INTERVENTIE VALUES(107, 3304, 560);
INSERT INTO PARTICIPARE_INTERVENTIE VALUES(109, 3301, 570);
COMMIT;
--SELECT * FROM PARTICIPARE_INTERVENTIE;



CREATE TABLE ATELIER(
cod_atelier         NUMBER(5)       CONSTRAINT pk_atelier PRIMARY KEY,
denumire            VARCHAR2(50)    UNIQUE NOT NULL,
an_infiintare       DATE            NOT NULL,
capacitate          NUMBER(3)       CHECK(capacitate >= 1),
cod_adresa          NUMBER(5)       
CONSTRAINT fk_atelier REFERENCES ADRESA(cod_adresa) ON DELETE SET NULL,
CONSTRAINT addr_unic_atel UNIQUE(cod_adresa)
);


INSERT INTO ATELIER VALUES(seq_general.NEXTVAL, 'Atelier Central', TO_DATE('01/06/1998', 'dd/mm/yyyy'), 8, 200);
INSERT INTO ATELIER VALUES(seq_general.NEXTVAL, 'Atelier Sud', TO_DATE('01/06/2004', 'dd/mm/yyyy'), 4, 180);
INSERT INTO ATELIER VALUES(seq_general.NEXTVAL, 'Atelier Mizil', TO_DATE('01/06/1960', 'dd/mm/yyyy'), 12, 210);
INSERT INTO ATELIER VALUES(seq_general.NEXTVAL, 'Atelier Ramnicu Sarat', TO_DATE('01/06/1977', 'dd/mm/yyyy'), 6, 190);
INSERT INTO ATELIER VALUES(seq_general.NEXTVAL, 'Atelier Vest', TO_DATE('01/06/1988', 'dd/mm/yyyy'), 4, 170);
COMMIT;
SELECT cod_atelier, denumire, to_char(an_infiintare, 'yyyy'), capacitate, cod_adresa FROM ATELIER;


CREATE TABLE EVENIMENT_CIRCULATIE(
cod_eveniment       NUMBER(5)       CONSTRAINT pk_event PRIMARY KEY,
data_producere      DATE            NOT NULL,
localizare          VARCHAR2(100),
descriere           VARCHAR2(100),
numar_interventie   NUMBER(5)       
CONSTRAINT fk_event REFERENCES INTERVENTIE(numar_interventie) ON DELETE SET NULL,
CONSTRAINT nr_int_unic UNIQUE(numar_interventie)
);

ALTER TABLE EVENIMENT_CIRCULATIE ADD CONSTRAINT nr_int_unic UNIQUE(numar_interventie);
INSERT INTO EVENIMENT_CIRCULATIE VALUES
(seq_general.nextval, TO_DATE('14-05-2024', 'DD-MM-YYYY'), 'Bd. Unirii, Buzau', 'Deraiere', 510);
INSERT INTO EVENIMENT_CIRCULATIE VALUES
(seq_general.nextval, TO_DATE('14-05-2024', 'DD-MM-YYYY'), 'Bd. Nicolae Balcescu, Buzau', 'Coliziune', 520);
INSERT INTO EVENIMENT_CIRCULATIE VALUES
(seq_general.nextval, TO_DATE('31-01-2024', 'DD-MM-YYYY'), 'Sapoca', 'Ciocniri cauzate de polei', 540);
INSERT INTO EVENIMENT_CIRCULATIE VALUES
(seq_general.nextval, TO_DATE('28-05-2024', 'DD-MM-YYYY'), 'Sarata Monteoru', 'Pana Auto', 550);
INSERT INTO EVENIMENT_CIRCULATIE VALUES
(seq_general.nextval, TO_DATE('13-03-2024', 'DD-MM-YYYY'), 'Centura Buzau', 'Coliziune', 560);
COMMIT;
--SELECT * FROM EVENIMENT_CIRCULATIE;


CREATE TABLE IMPLICA(
cod_eveniment       NUMBER(5)       CONSTRAINT fk_imp_ev REFERENCES EVENIMENT_CIRCULATIE(cod_eveniment) ON DELETE CASCADE,
cod_vehicul_tr      NUMBER(5)       CONSTRAINT fk_imp_veh REFERENCES VEHICUL_TRANSPORT(cod_vehicul_tr) ON DELETE CASCADE,
daune               VARCHAR2(100)   NOT NULL,
CONSTRAINT pk_imp PRIMARY KEY (cod_eveniment, cod_vehicul_tr)
);
INSERT INTO IMPLICA VALUES(720, 1301, 'Parbriz Spart');
INSERT INTO IMPLICA VALUES(730, 2002, 'Caroserie Indoita');
INSERT INTO IMPLICA VALUES(730, 911, 'Parbriz Spart');
INSERT INTO IMPLICA VALUES(740, 2006, 'Ambreiaj Stricat');
INSERT INTO IMPLICA VALUES(740, 2004, 'Ambreiaj Stricat');
INSERT INTO IMPLICA VALUES(740, 2002, 'Caroserie Indoita');
INSERT INTO IMPLICA VALUES(750, 2003, 'Pneuri Sparte');
INSERT INTO IMPLICA VALUES(760, 911, 'Caroserie Distrusa');
INSERT INTO IMPLICA VALUES(760, 2001, 'Caroserie Indoita');
INSERT INTO IMPLICA VALUES(760, 906, 'Caroserie Distrusa');
COMMIT;
--SELECT * FROM IMPLICA;



CREATE TABLE REPARATIE(
cod_reparatie       NUMBER(5)       CONSTRAINT pk_rep PRIMARY KEY,
data_incepere       DATE            NOT NULL,            
data_finalizare     DATE,
cod_vehicul_tr      NUMBER(5)       CONSTRAINT fk_rep_veh REFERENCES VEHICUL_TRANSPORT(cod_vehicul_tr) ON DELETE SET NULL,
cod_inginer         NUMBER(5)       CONSTRAINT fk_rep_ing REFERENCES INGINER(cod_inginer) ON DELETE SET NULL,
cod_atelier         NUMBER(5)       CONSTRAINT fk_rep_atl REFERENCES ATELIER(cod_atelier) ON DELETE SET NULL
);

INSERT INTO REPARATIE VALUES(seq_general.nextval, TO_DATE('15-05-2024', 'DD-MM-YYYY'), TO_DATE('18-05-2024', 'DD-MM-YYYY'), 1301, 113, 680);
INSERT INTO REPARATIE VALUES(seq_general.nextval, TO_DATE('20-05-2024', 'DD-MM-YYYY'), TO_DATE('27-05-2024', 'DD-MM-YYYY'), 2002, 115, 680);
INSERT INTO REPARATIE VALUES(seq_general.nextval, TO_DATE('02-02-2024', 'DD-MM-YYYY'), TO_DATE('08-03-2024', 'DD-MM-YYYY'), 2002, 115, 690);
INSERT INTO REPARATIE VALUES(seq_general.nextval, TO_DATE('15-05-2024', 'DD-MM-YYYY'), null, 906, 113, 680);
INSERT INTO REPARATIE VALUES(seq_general.nextval, TO_DATE('29-04-2024', 'DD-MM-YYYY'), null, 1303, 114, 670);
INSERT INTO REPARATIE VALUES(seq_general.nextval, TO_DATE('01-05-2024', 'DD-MM-YYYY'), null, 2006, 114, 710);
INSERT INTO REPARATIE VALUES(seq_general.nextval, TO_DATE('18-11-2023', 'DD-MM-YYYY'), TO_DATE('01-02-2024', 'DD-MM-YYYY'), 1312, 112, 690);
COMMIT;
--SELECT * FROM REPARATIE;



CREATE TABLE LOT_COMPONENTA(
cod_lot             NUMBER(5)       CONSTRAINT pk_lotcomp PRIMARY KEY,
nume_componenta     VARCHAR2(50)    NOT NULL,
cantitate           NUMBER(5)       NOT NULL CHECK(cantitate >= 1),
pret                NUMBER(6,2)     NOT NULL CHECK(pret > 0),
data_livrare        DATE            NOT NULL,
cod_furnizor        NUMBER(3)       CONSTRAINT fk_lot REFERENCES FURNIZOR(cod_furnizor) ON DELETE SET NULL
);

INSERT INTO LOT_COMPONENTA VALUES(seq_general.nextval, 'Ambreiaj Autobuz', 15, 4500, TO_DATE('18-11-2023', 'DD-MM-YYYY'), 5);
INSERT INTO LOT_COMPONENTA VALUES(seq_general.nextval, 'Parbriz Tramvai', 10, 2100, TO_DATE('10-09-2023', 'DD-MM-YYYY'), 7);
INSERT INTO LOT_COMPONENTA VALUES(seq_general.nextval, 'Boghiu', 3, 8500, TO_DATE('18-11-2022', 'DD-MM-YYYY'), 8);
INSERT INTO LOT_COMPONENTA VALUES(seq_general.nextval, 'Pneuri Autobuz', 40, 800, TO_DATE('16-10-2023', 'DD-MM-YYYY'), 6);
INSERT INTO LOT_COMPONENTA VALUES(seq_general.nextval, 'Caroserie Autobuz', 30, 9900, TO_DATE('18-11-2023', 'DD-MM-YYYY'), 4);
INSERT INTO LOT_COMPONENTA VALUES(seq_general.nextval, 'Parbriz Autobuz', 15, 1800, TO_DATE('10-09-2023', 'DD-MM-YYYY'), 7);
COMMIT;
SELECT * FROM LOT_COMPONENTA;



CREATE TABLE COMPONENTA(
cod_lot             NUMBER(5)      CONSTRAINT fk_comp_lot REFERENCES LOT_COMPONENTA(cod_lot),
numar_componenta    NUMBER(5)      NOT NULL,
cod_reparatie       NUMBER(5)      CONSTRAINT fk_comp_rep REFERENCES REPARATIE(cod_reparatie),
CONSTRAINT pk_comp PRIMARY KEY(cod_lot, numar_componenta)
);
INSERT INTO COMPONENTA VALUES(1070, 1, 830);
INSERT INTO COMPONENTA VALUES(1070, 2, 830);
INSERT INTO COMPONENTA VALUES(1100, 1, 770);
INSERT INTO COMPONENTA VALUES(1100, 2, 780);
INSERT INTO COMPONENTA VALUES(1100, 3, 790);
INSERT INTO COMPONENTA VALUES(1080, 1, 800);
INSERT INTO COMPONENTA VALUES(1080, 2, 800);
INSERT INTO COMPONENTA VALUES(1060, 1, 810);
INSERT INTO COMPONENTA VALUES(1070, 3, 820);
INSERT INTO COMPONENTA VALUES(1080, 3, 820);
COMMIT;
SELECT * FROM COMPONENTA;



--SELECT * FROM user_constraints WHERE LOWER(table_name) LIKE 'sofer';
