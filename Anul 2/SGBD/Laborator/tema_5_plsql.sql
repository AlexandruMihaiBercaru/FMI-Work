--tema laborator 5
select * from traseu;
select * from statie;
select * from parcurs_traseu;


-- cerinta 1: dandu-se numele unei localitati de la tastatura, sa se 
-- afiseze toate traseele care trec prin localitatea respectiva: indicativul traseului, 
-- lista de statii (numele + amplasamentul), intervalul la care ce succed vehiculele
select * from statie s JOIN parcurs_traseu pt ON s.cod_statie = pt.cod_statie;

select s.nume, s.localitate, pt.numar_traseu
FROM statie s JOIN parcurs_traseu pt ON pt.cod_statie = s.cod_statie
GROUP BY pt.numar_traseu, s.nume, s.localitate
    HAVING lower(s.localitate) LIKE 'buzau'
    ORDER BY numar_traseu;
--WHERE LOWER(s.nume) LIKE 'buzau';



-- sa se afiseze lista statiilor (numele, localitatea + amplasamentul) pentru traseele care tranziteaza
-- cel putin 3 localitat. de asemenea, sa se afiseze intervalul la care se succed vehiculele pe traseu

DECLARE
    CURSOR c_trasee IS
        SELECT numar_traseu 
        FROM parcurs_traseu pt 
            JOIN statie s ON s.cod_statie = pt.cod_statie
        WHERE 1 = 2
        GROUP BY numar_traseu
        HAVING COUNT(DISTINCT localitate) >= 3;
        
    CURSOR c_statii(nr_traseu NUMBER) IS
        SELECT s.nume, CONCAT(s.localitate, ', ' || s.amplasament), 
                EXTRACT(HOUR FROM t.frecventa), EXTRACT(MINUTE FROM t.frecventa)
        FROM statie s 
            JOIN parcurs_traseu pt ON s.cod_statie = pt.cod_statie
            JOIN traseu t ON t.numar_traseu = pt.numar_traseu
        WHERE t.numar_traseu = nr_traseu;
            
    v_traseu        NUMBER;
    v_nume          statie.nume%TYPE;
    v_ora           NUMBER(2);
    v_minute        NUMBER(2);
    interv          VARCHAR2(32);
    adresa          VARCHAR2(256);
BEGIN
    OPEN c_trasee;
    LOOP 
        FETCH c_trasee INTO v_traseu;
        EXIT WHEN c_trasee%NOTFOUND;
        
        OPEN c_statii(v_traseu);
        FETCH c_statii INTO v_nume, adresa, v_ora, v_minute;
        
        IF v_ora = 0 THEN 
            interv := v_minute || ' minute';
        ELSIF v_ora = 1 THEN 
            interv := v_ora || ' ora si ' || v_minute || ' minute';
        ELSE 
            interv := v_ora || ' ore si ' || v_minute || ' minute';
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('------------------LINIA ' || v_traseu || '-----------------');
        DBMS_OUTPUT.PUT_LINE('      INTERVAL DE CIRCULATIE: ' || interv);
        DBMS_OUTPUT.NEW_LINE();
        DBMS_OUTPUT.PUT_LINE('------STATIE------------------------AMPLASAMENT------');
        
        WHILE c_statii%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE(RPAD(v_nume, 30) || adresa);
            FETCH c_statii INTO v_nume, adresa, v_ora, v_minute;
        END LOOP;
        DBMS_OUTPUT.NEW_LINE();
        
        CLOSE c_statii;
    END LOOP;
    
    IF c_trasee%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Nu exista niciun traseu care sa treaca prin cel putin 3 localitati.');
    END IF;
    CLOSE c_trasee;
END;
/
INSERT INTO furnizor VALUES (1, 'Greenbrier Europe', '+40257202115', 'Greenbrier.Europe@gbrx.com');
INSERT INTO componenta VALUES(1110, 1, 770);
INSERT INTO componenta VALUES(1110, 2, 770);
INSERT INTO componenta VALUES(1110, 3, 780);
INSERT INTO componenta VALUES(1060, 2, 810);

UPDATE lot_componenta SET cod_furnizor = 1 WHERE cod_lot = 1080;
SELECT * FROM reparatie;
SELECT * FROM componenta ORDER BY cod_reparatie, cod_lot;
SELECT * FROM lot_componenta;
SELECT * FROM furnizor;
--

DECLARE
    CURSOR c_rep IS
        SELECT  r.cod_reparatie, r.cod_vehicul_tr, 
        lc.cod_lot || '/' ||TO_CHAR(lc.data_livrare, 'DD.MM.YYYY') "Lot/Data",
        COUNT(cmp.numar_componenta) nr_comp_folosite, lc.nume_componenta, f.nume furnizor
        FROM reparatie r 
            JOIN componenta cmp ON cmp.cod_reparatie = r.cod_reparatie
            JOIN lot_componenta lc ON lc.cod_lot = cmp.cod_lot
            JOIN furnizor f ON f.cod_furnizor = lc.cod_furnizor
        GROUP BY r.cod_reparatie, r.cod_vehicul_tr, 
                lc.cod_lot || '/' ||TO_CHAR(lc.data_livrare, 'DD.MM.YYYY'), lc.nume_componenta, f.nume
        ORDER BY cod_reparatie;
        
    v_codrep  reparatie.cod_reparatie%TYPE := -1;
BEGIN
    FOR i IN c_rep LOOP
        IF i.cod_reparatie <> v_codrep THEN
            v_codrep := i.cod_reparatie;
            DBMS_OUTPUT.NEW_LINE();
            DBMS_OUTPUT.NEW_LINE();
            DBMS_OUTPUT.PUT_LINE('Pentru reparatia ' || v_codrep || 
            ' a vehiculului ' || i.cod_vehicul_tr || ' s-au folosit:');
            DBMS_OUTPUT.PUT_LINE('--BUC-----COMPONENTA----------FURNIZOR------------LOT-----------');
        END IF;
        DBMS_OUTPUT.PUT_LINE(RPAD(i.nr_comp_folosite, 10) || RPAD(i.nume_componenta, 20) || 
            RPAD(i.furnizor, 20) || i."Lot/Data");
    END LOOP;
END;
/


SELECT * FROM cursa;
--3
--pentru fiecare sofer, sa se afiseze urmatoarele informatii despre cursele efectuate in 
--mai 2024: codul vehiculului folosit, numarul traseului pe care a circulat, data, ora plecarii
--din depou, ora gararii, durata medie a unei ture
DECLARE
    nr_curse        NUMBER;
BEGIN
    FOR vsof IN (SELECT s.cod_sofer, a.nume, a.prenume 
                 FROM angajat a JOIN sofer s ON a.cod_angajat = s.cod_sofer)
    LOOP
        DBMS_OUTPUT.PUT_LINE('Soferul ' || vsof.nume || ' ' || vsof.prenume ||
        ' a efectuat urmatoarele curse in luna mai 2024: ');
        nr_curse := 0;
        FOR vcrs IN (SELECT numar_traseu, cod_vehicul_tr, TO_CHAR(data_cursa, 'DD.MM.YYYY') datacrs,
                            TO_CHAR(ora_preluare, 'hh24:mi') oraplec,  
                            TO_CHAR(ora_predare, 'hh24:mi') oragaraj,
                            ROUND(((ora_finalizare_ture - ora_incepere_ture) * 24 * 60) / numar_ture, 2) medtime
                     FROM cursa
                     WHERE vsof.cod_sofer = cursa.cod_sofer
                        AND LAST_DAY(data_cursa) = TO_DATE('31-05-2024', 'DD-MM-YYYY')) 
        LOOP
            nr_curse := nr_curse + 1;
            DBMS_OUTPUT.PUT_LINE('Linia ' || vcrs.numar_traseu || '/ vehiculul: ' || vcrs.cod_vehicul_tr
            || '/ ziua: ' || vcrs.datacrs || '/ ora plecare depou: ' || vcrs.oraplec || 
            '/ ora sosire depou: ' || vcrs.oragaraj || '/ durata tura: ' || vcrs.medtime || ' min.');
        END LOOP;
        --alt mod de a testa ca nu au fost curse?
        IF nr_curse = 0 THEN
            DBMS_OUTPUT.PUT_LINE('...nicio cursa!');
        END IF;   
        DBMS_OUTPUT.NEW_LINE();
    END LOOP;
END;
/

SELECT * FROM angajat;

--4
--pentru fiecare depou, o lista cu angajatii si o lista cu vehiculele garate (daca sunt vehicule de transport
--sa se afiseze si denumirea modelului si tipul de vehicul)
DECLARE
    TYPE refcursor IS REF CURSOR;
    CURSOR c_depou IS 
        SELECT denumire_depou,
        CURSOR(SELECT nume, prenume, tip_job
                    FROM angajat a
                    WHERE a.cod_depou = d.cod_depou),
        CURSOR(SELECT cod_vehicul, producator, intrebuintare, m.denumire_model,
                m.tip_mijloc_transport
                    FROM vehicul v
                        LEFT JOIN vehicul_transport vt ON v.cod_vehicul = vt.cod_vehicul_tr
                        LEFT JOIN model m ON m.cod_model = vt.cod_model
                    WHERE v.cod_depou = d.cod_depou)
        FROM depou d;   
    v_cursor_ang            refcursor;
    v_cursor_veh            refcursor;
    v_den_dep               depou.denumire_depou%TYPE;
    v_nume                  angajat.nume%TYPE;
    v_prenume               angajat.prenume%TYPE;
    v_tip_job               angajat.tip_job%TYPE;
    v_cod_veh               NUMBER;
    v_prod                  vehicul.producator%TYPE;
    v_rol                   vehicul.intrebuintare%TYPE;
    v_den_mod               model.denumire_model%TYPE;
    v_tip_mijl              model.tip_mijloc_transport%TYPE;
BEGIN
    OPEN c_depou;
    LOOP
        FETCH c_depou INTO v_den_dep, v_cursor_ang, v_cursor_veh;
        EXIT WHEN c_depou%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('-------------------------------------'); 
        DBMS_OUTPUT.PUT_LINE (v_den_dep); 
        DBMS_OUTPUT.PUT_LINE('--------------ANGAJATI---------------');
        LOOP
            FETCH v_cursor_ang INTO v_nume, v_prenume, v_tip_job;
            EXIT WHEN v_cursor_ang%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(v_nume || ' ' || v_prenume || ' - job: ' || v_tip_job);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('--------------VEHICULE---------------');
        LOOP
            FETCH v_cursor_veh INTO v_cod_veh, v_prod, v_rol, v_den_mod, v_tip_mijl;
            EXIT WHEN v_cursor_veh%NOTFOUND;
            IF v_tip_mijl IS NOT NULL THEN
                DBMS_OUTPUT.PUT_LINE(v_cod_veh || '/ folosit la: ' || v_rol || '/ tip: ' || v_tip_mijl 
                ||'/ produs de: ' || v_prod || '/ model: ' || v_den_mod);
            ELSE
                DBMS_OUTPUT.PUT_LINE(v_cod_veh || '/ folosit la: ' || v_rol || 
                '/ produs de: ' || v_prod);
            END IF;
        END LOOP;
        DBMS_OUTPUT.NEW_LINE();
        DBMS_OUTPUT.NEW_LINE();
    END LOOP;
    CLOSE c_depou;
END;
/
COMMIT;

