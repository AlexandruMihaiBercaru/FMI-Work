--Sa se afle numarul traseului care a avut cel mai mare numar mediu
--de ture (se vor lua in calcul doar acele trasee care au avut cel putin trei curse) si numarul de statii
--de pe acest traseu
--Sa se afiseze rezultatul atat din bloc, cat si din afara lui.
SELECT  s.nume, s.cod_statie, pt.numar_traseu 
FROM parcurs_traseu pt 
JOIN statie s ON pt.cod_statie = s.cod_statie;
SELECT * FROM cursa;



VARIABLE nr_statii NUMBER
VARIABLE linie NUMBER
BEGIN
    SELECT tm.numar_traseu, COUNT(pt.cod_statie)
        INTO :linie, :nr_statii
        FROM  parcurs_traseu pt JOIN 
    (
    SELECT AVG(c.numar_ture), c.numar_traseu
    FROM cursa c
        JOIN parcurs_traseu pt ON pt.numar_traseu = c.numar_traseu
    GROUP BY c.numar_traseu
        HAVING COUNT(c.numar_traseu) > 2 
        AND
        AVG(c.numar_ture) = (SELECT MAX(AVG(c2.numar_ture))
                                        FROM cursa c2
                                        GROUP BY c2.numar_traseu
                                        HAVING COUNT(numar_traseu) > 2
                                        )
    ) tm ON tm.numar_traseu = pt.numar_traseu
    GROUP BY tm.numar_traseu;
    DBMS_OUTPUT.PUT_LINE('Traseul cu cel mai mare numar mediu de ture: ' || :linie);
    DBMS_OUTPUT.PUT_LINE('Numar opriri: ' || :nr_statii);
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Exista mai multe trasee cu acelasi numar mediu de ture.');
            :linie := NULL;
            :nr_statii := NULL;
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista niciun traseu cu cel putin 3 curse');
END;
/
PRINT linie
PRINT nr_statii


--testare exceptie too_many_rows
INSERT INTO cursa VALUES (102, 2002, 1, SYSDATE, TO_DATE('06:25', 'HH24:MI'), TO_DATE('06:33', 'HH24:MI'),
TO_DATE('14:06', 'HH24:MI'), TO_DATE('14:28', 'HH24:MI'), 26);
ROLLBACK;

DELETE FROM cursa WHERE numar_traseu IN 
        (SELECT numar_traseu 
        FROM cursa 
        GROUP BY numar_traseu 
        HAVING COUNT(numar_traseu) >= 3);
ROLLBACK;




--sub 10 zile, sub o luna, sub 6 luni, peste o luna
select * from reparatie;
--Pentru o reparatie al carei id este introdus de la tastatura, sa se clasifice in functie de durata reparatiei, astfel:
--sub 10 zile: reparatie de scurta durata
--intre 10 zile si o luna: reparatie de durata medie
--intre o luna si 6 luni: reparatie lunga
--mai mult de 6 luni: reparatie foarte lunga

SET VERIFY OFF
DECLARE
    var_cod_rep reparatie.cod_reparatie%TYPE := &codul_reparatiei;
    durata NUMBER(6);
    clasif_rep VARCHAR2(100);   
BEGIN
    SELECT NVL(data_finalizare, SYSDATE) - data_incepere
        INTO durata
        FROM reparatie
    WHERE cod_reparatie = var_cod_rep;
    IF durata <= 10 THEN 
        clasif_rep := ' de durata scurta';
    ELSIF durata <= 30 THEN
        clasif_rep := ' de durata medie';
    ELSIF durata <= 180 THEN
        clasif_rep := ' de durata lunga';
    ELSE
        clasif_rep := ' de durata foarte lunga';
    END IF;
    DBMS_OUTPUT.PUT_LINE('Reparatia cu codul ' || var_cod_rep || ' este' || clasif_rep);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista o reparatie cu codul ' || var_cod_rep);
END;
/



SELECT * FROM sofer WHERE cod_sofer = 100;
SELECT * FROM cursa;
SELECT * FROM angajat WHERE cod_angajat = 100;

--stocati prin variabile de subsitutie codul unui sofer si o data ce reprezinta data de expirare a permisului de conducere
--sa i se actualizeze soferului respectiv data de expirare si, pentru fiecare cursa efectuata in luna mai 2024
--sa i se adauge un spor de 200 de lei la salariu


DEFINE cod_sof = 111
DEFINE data_exp = TO_DATE('01/01/2032', 'DD/MM/YYYY')
DECLARE
    v_cod_sofer sofer.cod_sofer%TYPE := &cod_sof;
    v_data sofer.data_expirare%TYPE := &data_exp;
    curse_mai NUMBER(2);
BEGIN
    UPDATE sofer
    SET data_expirare = v_data
    WHERE cod_sofer = v_cod_sofer;
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Nu exista un sofer cu acest cod');
    ELSE
        SELECT COUNT(*) INTO curse_mai
            FROM cursa
            WHERE cod_sofer = v_cod_sofer 
            AND LAST_DAY(data_cursa) = TO_DATE('31-05-2024', 'DD-MM-YYYY');
        UPDATE angajat
        SET salariu = salariu + 200 * curse_mai 
        WHERE cod_angajat = v_cod_sofer;
        DBMS_OUTPUT.PUT_LINE('Actualizare realizata');      
    END IF;
END;
/
ROLLBACK;




SELECT COUNT(*) --INTO curse_mai
            FROM cursa
            WHERE cod_sofer = 100 
            AND LAST_DAY(data_cursa) = TO_DATE('31-05-2024', 'DD-MM-YYYY');