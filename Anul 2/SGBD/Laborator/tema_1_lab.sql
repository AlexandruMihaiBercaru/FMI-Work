CREATE TABLE VEHICUL_TRANSPORT_2 (
cod_vehicul         NUMBER(5)       CONSTRAINT pk_vehicul_tr_2 PRIMARY KEY,
producator          VARCHAR2(25)    NOT NULL,
an_achizitie        DATE            NOT NULL,
data_verificare     DATE            DEFAULT TO_DATE('15/09/2023', 'dd/mm/yyyy'),
kilometraj          NUMBER(10)      DEFAULT 0,
stare               VARCHAR2(20)    DEFAULT 'functional' 
                                    CONSTRAINT verifica_stare 
                                    CHECK(stare IN('functional', 'defect', 'in reparatie'))
);

INSERT INTO VEHICUL_TRANSPORT_2 VALUES
(902, 'Ikarus', TO_DATE('1987', 'yyyy'), DEFAULT, 3240000, DEFAULT);
INSERT INTO VEHICUL_TRANSPORT_2 VALUES
(906, 'Ikarus', TO_DATE('1999', 'yyyy'), TO_DATE('15/11/2018', 'dd/mm/yyyy'), 2250000, 'defect');
INSERT INTO VEHICUL_TRANSPORT_2 VALUES
(2001, 'Solaris', TO_DATE('2021', 'yyyy'), TO_DATE('15/10/2022', 'dd/mm/yyyy'), 20090, DEFAULT);
INSERT INTO VEHICUL_TRANSPORT_2 VALUES
(2002, 'Solaris', TO_DATE('2023', 'yyyy'), DEFAULT, 18500, DEFAULT);
INSERT INTO VEHICUL_TRANSPORT_2 VALUES
(2006, 'Solaris', TO_DATE('2022', 'yyyy'), TO_DATE('15/10/2022', 'dd/mm/yyyy'), 32540, DEFAULT);
INSERT INTO VEHICUL_TRANSPORT_2 VALUES
(1310, 'Astra Vagoane Calatori', TO_DATE('2020', 'yyyy'), DEFAULT, 58040, 'defect');
INSERT INTO VEHICUL_TRANSPORT_2 VALUES
(1312, 'Astra Vagoane Calatori', TO_DATE('2022', 'yyyy'), DEFAULT, 58390, DEFAULT);
INSERT INTO VEHICUL_TRANSPORT_2 VALUES
(911, 'Solaris', TO_DATE('2021', 'yyyy'), DEFAULT, 26780, DEFAULT);
COMMIT;


CREATE TABLE EVENIMENT_CIRCULATIE_2(
cod_eveniment       NUMBER(5)       CONSTRAINT pk_ev_circ_2 PRIMARY KEY,
data_producere      DATE            NOT NULL,
localizare          VARCHAR2(100)   NOT NULL,
descriere           VARCHAR2(100)   NOT NULL,
intarziere          NUMBER(3)       NOT NULL
);

INSERT INTO EVENIMENT_CIRCULATIE_2 VALUES
(10, TO_DATE('14-05-2024', 'DD-MM-YYYY'), 'Bd. Unirii, Buzau', 'Deraiere tramvai', 150);
INSERT INTO EVENIMENT_CIRCULATIE_2 VALUES
(11, TO_DATE('14-05-2024', 'DD-MM-YYYY'), 'Bd. Nicolae Balcescu, Buzau', 'Coliziune intre autobuz si biciclist', 100);
INSERT INTO EVENIMENT_CIRCULATIE_2 VALUES
(12, TO_DATE('31-01-2024', 'DD-MM-YYYY'), 'Spataru', 'Ciocniri intre autobuze cauzate de polei', 300);
INSERT INTO EVENIMENT_CIRCULATIE_2 VALUES
(13, TO_DATE('28-05-2024', 'DD-MM-YYYY'), 'Sarata Monteoru', 'Autobuz ramas in pana', 30);
INSERT INTO EVENIMENT_CIRCULATIE_2 VALUES
(14, TO_DATE('13-03-2024', 'DD-MM-YYYY'), 'Centura Buzau', 'Coliziune intre 2 autobuze', 250);
INSERT INTO EVENIMENT_CIRCULATIE_2 VALUES
(15, TO_DATE('01-10-2024', 'DD-MM-YYYY'), 'Bd. Unirii, Buzau', 'Lipsa tensiune retea electrica', 300);
COMMIT;



CREATE TABLE IMPLICA_2(
cod_eveniment       NUMBER(5)       CONSTRAINT fk_imp_ev_circ_2 REFERENCES EVENIMENT_CIRCULATIE_2(cod_eveniment) 
                                    ON DELETE CASCADE,
cod_vehicul_tr      NUMBER(5)       CONSTRAINT fk_imp_veh_tr_2 REFERENCES VEHICUL_TRANSPORT_2(cod_vehicul)
                                    ON DELETE CASCADE,
daune               VARCHAR2(100)   NOT NULL,
CONSTRAINT pk_implica_2 PRIMARY KEY (cod_eveniment, cod_vehicul_tr)
);

INSERT INTO IMPLICA_2 VALUES (14, 906, 'Caroserie distrusa total');
INSERT INTO IMPLICA_2 VALUES (14, 902, 'Caroserie indoita');
INSERT INTO IMPLICA_2 VALUES (11, 2001, 'Parbriz spart, faruri sparte');
INSERT INTO IMPLICA_2 VALUES (12, 902, 'Ambreiaj stricat');
INSERT INTO IMPLICA_2 VALUES (12, 2002, 'Ambreiaj stricat');
INSERT INTO IMPLICA_2 VALUES (12, 2001, 'Parbriz crapat, caroserie indoita');
INSERT INTO IMPLICA_2 VALUES (10, 911, 'Faruri sparte');
INSERT INTO IMPLICA_2 VALUES (13, 2001, 'Pneuri sparte');
COMMIT;


SELECT * FROM IMPLICA_2;

--S? se afi?eze, codul, denumirea produc?torului, anul achizi?iei
--starea re?inut? ?i starea corect? pentru acele vehicule care au fost
--implicate într-un eveniment de circula?ie în anul curent, ?tiind c?
--dac? au trecut mai pu?in de 6 luni de la cel mai recent accident, înc? se afl? în repara?ie, ?i altfel, sunt în func?iune
WITH ultimul_eveniment AS
    (SELECT MAX(ec.data_producere) "Data", imp.cod_vehicul_tr FROM eveniment_circulatie_2 ec
            JOIN implica_2 imp ON imp.cod_eveniment = ec.cod_eveniment
            GROUP BY imp.cod_vehicul_tr
        )
SELECT vt.cod_vehicul, vt.producator, EXTRACT(YEAR FROM vt.an_achizitie) "An achizitie", vt.stare,
    COALESCE((SELECT 
        CASE
            WHEN TO_CHAR(ev2."Data", 'YYYY') = '2024' 
                    AND SYSDATE - ev2."Data" <= 180 
                THEN 'in reparatie'
            WHEN  TO_CHAR(ev2."Data", 'YYYY') = '2024' 
                    AND SYSDATE - ev2."Data" > 180
                THEN 'functional'
        END 
        FROM ultimul_eveniment ev2
        WHERE ev2.cod_vehicul_tr = vt.cod_vehicul), vt.stare) "Starea actuala"
FROM vehicul_transport_2 vt;
