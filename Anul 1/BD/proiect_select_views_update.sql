
--EXERCITIUL 12 
--EXEMPLU 1.
--Sa se obtina informatii despre reparatiile demarate in primavara anului 2024 asupra vehiculelor produse de o firma al carei
--nume se termina cu litera s: data demararii, data incheierii (daca reparatia se afla inca in desfasurare, 
--se va afisa un mesaj corespunzator), numele si prenumele inginerului care a supravegheat lucrarile, 
--locatia atelierului, modelul vehiculului si producatorul acestuia, anul in care a fost cumparat, observatii referitoare la vechimea
--autovehiculului (cele cumparate inainte de 2000 sunt considerate vechi, cele achizitionate inainte de 1980 sunt considerate foarte vechi),
--Rezultatele se vor ordona crescator dupa data demararii.

--Clauza ORDER BY + NVL + DECODE, clauza WITH, functii pe siruri de caractere (CONCAT, SUBSTR), functie pentru date calendaristice (MONTHS_BETWEEN)
WITH loc_atelier AS (SELECT atl.cod_atelier, localitate AS loc, CONCAT(CONCAT(nume_strada, ', nr. '), numar) AS str 
                     FROM atelier atl 
                     JOIN adresa adr ON atl.cod_adresa = adr.cod_adresa),         
info_vehicul AS (SELECT v.cod_vehicul, v.producator || ' ' || vm.denumire_model AS nume_vehicul, TO_CHAR(v.an_achizitie, 'yyyy') AS an
                    FROM vehicul v 
                    JOIN vehicul_transport vtr ON v.cod_vehicul = vtr.cod_vehicul_tr
                    JOIN model vm ON vtr.cod_model = vm.cod_model
                    WHERE SUBSTR(v.producator, -1) = 's'),
inginer_rep AS (SELECT a.nume || ' ' || a.prenume AS nume_ing, cod_inginer
                          FROM angajat a 
                          JOIN inginer i ON i.cod_inginer = a.cod_angajat)                   
SELECT r.cod_reparatie "Cod_rep",
       TO_CHAR(r.data_incepere, 'dd.mm.yyyy') "Data demarare", 
       NVL(TO_CHAR(r.data_finalizare, 'dd.mm.yyyy'), 'Reparatie in desfasurare') "Data finalizare",
       nume_ing "Supervizor",
       loc || ', ' || str "Locatie",
       nume_vehicul || ', ' || an  "Autovehicul",
       DECODE(FLOOR(an/1980), 
                0, 'Autovehiculul este foarte vechi si ar trebui retras',
                1, DECODE(FLOOR(an/2000),
                            0, 'Autovehiculul este vechi, trebuie verificat mai des',
                            1, 'Autovehiculul este nou' ) ) "Observatii"
FROM reparatie r 
    JOIN loc_atelier l ON l.cod_atelier = r.cod_atelier
    JOIN info_vehicul vh ON vh.cod_vehicul = r.cod_vehicul_tr
    JOIN inginer_rep ing ON ing.cod_inginer = r.cod_inginer
WHERE MONTHS_BETWEEN('31-MAY-2024', data_incepere) <= 3
ORDER BY "Data demarare";



--EXEMPLU 2.
--S? se ob?in? informa?ii despre autovehiculele implicate în acele evenimente de circula?ie care s-au petrecut într-o zi în care vehiculul se afla într-o curs?. 
--S? se afi?eze ?i num?rul traseului pe care se afla vehiculul în acea zi, numele ?oferului care conducea vehiculul, daunele suferite. 

--Subcerere nesincronizat? in clauza FROM.
SELECT istoric.cod_eveniment "Cod_ev", istoric.descriere "Evenimentul",
istoric.data_producere "Data eveniment", istoric.cod_vehicul "Autovehicul implicat", istoric.marca "Model", 
a.nume || ' ' || a.prenume "Nume sofer", c.numar_traseu "Traseu", istoric.daune "Daune"
FROM angajat a, sofer s, cursa c,
    (SELECT ec.cod_eveniment, ec.descriere, v.cod_vehicul, ec.data_producere, i.daune, v.producator || ' ' || m.denumire_model marca
            FROM eveniment_circulatie ec
                JOIN implica i ON ec.cod_eveniment = i.cod_eveniment
                JOIN vehicul_transport vt ON i.cod_vehicul_tr = vt.cod_vehicul_tr
                JOIN vehicul v ON v.cod_vehicul = vt.cod_vehicul_tr
                JOIN model m ON m.cod_model = vt.cod_model
    )istoric
WHERE a.cod_angajat = s.cod_sofer
        AND s.cod_sofer = c.cod_sofer
        AND istoric.data_producere = c.data_cursa
        AND c.cod_vehicul_tr = istoric.cod_vehicul
ORDER BY istoric.cod_eveniment, istoric.cod_vehicul;



--EXEMPLUL 3
--S? se afi?eze specifica?iile modelului de vehicul de transport cel mai des folosit pe trasee.
--(Explica?ie: c?ut?m modelul care apare de cele mai multe ori in tabelul "curs?").

--grup?ri de date, func?ii grup, filtrare la nivel de grupuri cu subcereri nesincronizate (în clauza de HAVING) în care intervin cel pu?in 3 tabele
SELECT v.producator || ' ' || m1.denumire_model "Modelul", m1.tip_mijloc_transport "Categorie vehicul", 
m1.lungime || 'm, ' || m1.numar_scaune || ' scaune, capacitate totala ' || m1.capacitate_calatori || ' persoane, viteza maxima ' || m1.viteza_maxima || ' km/h' "Specificatii" 
            FROM model m1
            JOIN vehicul_transport vt ON vt.cod_model = m1.cod_model
            JOIN cursa c ON c.cod_vehicul_tr = vt.cod_vehicul_tr
            JOIN vehicul v ON v.cod_vehicul = vt.cod_vehicul_tr
GROUP by v.producator, m1.denumire_model, m1.tip_mijloc_transport, m1.lungime, m1.numar_scaune, m1.capacitate_calatori, m1.viteza_maxima 
HAVING COUNT(m1.cod_model) = (SELECT MAX(COUNT(m2.cod_model)) 
                                FROM model m2
                                    JOIN vehicul_transport vt ON vt.cod_model = m2.cod_model
                                    JOIN cursa c ON c.cod_vehicul_tr = vt.cod_vehicul_tr
                                GROUP BY m2.cod_model);
            



                                  select * from cursa;  
                                    
                                    
--EXEMPLUL 4
--S? se g?seasc? to?i ?oferii care au tranzitat cel pu?in o dat? în ultimele dou? s?pt?mâni, în timpul unei curse care a început dup? mizeul zilei,
--localitatea în care se afl? ?i domiciliul lor.
--S? se afi?eze toate sta?iile prin care a trecut ?oferul, care se g?sesc în localitatea sa de re?edin??, afi?ându-se ?i linia pe care se g?se?te sta?ia respectiv?.

--subcerere sincronizat? în care intervin cel pu?in 3 tabele, func?ie pe ?iruri de caractere, func?ie pe date calendaristice (ROUND, SYSDATE)
SELECT DISTINCT a.nume || ' ' || a.prenume "Nume sofer", 
CONCAT(CONCAT(adr.nume_strada, ', nr. '), adr.numar) || ' ' || adr.localitate "Domiciliu sofer", 
st.nume "Nume statie tranzitata", st.amplasament || ', ' || st.localitate "Localizarea statiei", 
t.numar_traseu "Linia"
FROM angajat a 
    JOIN adresa adr ON a.cod_adresa = adr.cod_adresa
    JOIN sofer s ON a.cod_angajat = s.cod_sofer
    JOIN cursa c ON s.cod_sofer = c.cod_sofer
    JOIN traseu t ON t.numar_traseu = c.numar_traseu
    JOIN parcurs_traseu pt ON pt.numar_traseu = t.numar_traseu
    JOIN statie st ON st.cod_statie = pt.cod_statie
WHERE INITCAP(adr.localitate) IN ( SELECT INITCAP(s1.localitate)
                                    FROM statie s1
                                        JOIN parcurs_traseu pt1 ON s1.cod_statie = pt1.cod_statie
                                        JOIN traseu t1 ON t1.numar_traseu = pt1.numar_traseu
                                        JOIN cursa c1 ON c1.numar_traseu = t1.numar_traseu
                                    WHERE c1.cod_sofer = s.cod_sofer
                                    AND st.localitate = s1.localitate)
AND MONTHS_BETWEEN(SYSDATE, c.data_cursa) < 0.5
AND TO_CHAR(ROUND(c.ora_incepere_ture), 'DD/MM/YYYY') = TO_CHAR(c.ora_incepere_ture + 1, 'DD/MM/YYYY');

-- TO_DATE('31/05/2024', 'DD/MM/YYYY') IN LOC DE SYSDATE CA SA DEA REZULTATUL

--EXEMPLUL 5
--S? se clasifice interven?iile, în func?ie de num?rul de mecanici ?i de vehicule ce au luat parte, astfel:
-- - pentru maxim 2 mecanici ?i maxim un vehicul, se va considera o interven?ie minor?
-- - pentru cel mult 3 mecanici ?i dou? vehicule, interven?ie medie
-- - pentru mai mult de 3 mecanici ?i cel pu?in dou? vehicule, interven?ie major?
--Pentru fiecare interven?ie, s? se specifice cauza ?i num?rul de vehicule implicate (daca este cazul).


--expresie CASE
SELECT pt.numar_interventie "Cod_intervin", count(pt.cod_mecanic) "Nr_mecanici", 
count(distinct pt.cod_vehicul_int) "Nr_vehicule_interventie", itr.cauza "Cauza", 
COALESCE(numar_vehicule, 0) "Nr_vehicule_accidentate",
CASE
    WHEN (count(cod_mecanic) <= 2 AND count(distinct cod_vehicul_int) = 1) 
        THEN 'Interventie minora'
    WHEN (count(cod_mecanic)  <= 3 AND count(distinct cod_vehicul_int) <= 2) 
        THEN 'Interventie medie'
   ELSE 'Interventie majora'
END "Tip interventie"
FROM participare_interventie pt
    JOIN interventie itr ON itr.numar_interventie = pt.numar_interventie
    LEFT JOIN (SELECT ec.numar_interventie, ec.cod_eveniment, COUNT(imp.cod_vehicul_tr) numar_vehicule
                    FROM eveniment_circulatie ec 
                    JOIN implica imp ON imp.cod_eveniment = ec.cod_eveniment
                    GROUP BY ec.cod_eveniment, ec.numar_interventie) events
    ON itr.numar_interventie = events.numar_interventie
GROUP BY pt.numar_interventie, numar_vehicule, itr.cauza
ORDER BY "Nr_vehicule_accidentate", "Nr_mecanici", "Nr_vehicule_interventie";



--EXERCITIUL 13

--Sa se reduca cu 10% salariul soferilor care nu au intreprins cel putin trei curse.

--SELECT a.cod_angajat "Cod sofer", a.nume|| ' ' || a.prenume "Nume sofer", a.salariu "Salariu"
--FROM angajat a
--JOIN sofer s ON s.cod_sofer = a.cod_angajat;

UPDATE angajat a
SET a.salariu = a.salariu - (10 * a.salariu) / 100
WHERE 
(SELECT COUNT(c.data_cursa) 
    FROM cursa c JOIN sofer s ON c.cod_sofer = s.cod_sofer
    WHERE a.cod_angajat = s.cod_sofer
    GROUP BY c.cod_sofer) < 3;
commit;
rollback;


--SELECT * FROM furnizor;

--cerinta 2.
--Sa se stearga furnizorii care nu au livrat niciun lot de componente in ultimul an
DELETE FROM furnizor
WHERE cod_furnizor NOT IN (SELECT cod_furnizor
                            FROM lot_componenta
                            WHERE MONTHS_BETWEEN(SYSDATE, data_livrare) < 12);
commit;
--rollback;


--select * from parcurs_traseu;

--cerinta 3.
--S? se ?tearg? din traseul liniilor regionale acele sta?ii care sunt amplasate în ora?ul Buz?u.
DELETE FROM PARCURS_TRASEU
WHERE numar_traseu IN (SELECT numar_traseu
                        FROM traseu
                        WHERE UPPER(categorie) LIKE 'REGIONAL')
    AND cod_statie IN (SELECT cod_statie
                        FROM statie
                        WHERE UPPER(localitate) LIKE 'BUZAU');
commit;


select * from furnizor;

select * from parcurs_traseu;


--ex. 14

CREATE VIEW ATELIERE_BUZAU AS
SELECT at.cod_atelier, at.denumire, at.an_infiintare, at.cod_adresa, 
ad.nume_strada, ad.numar, ad.localitate, ad.judet
FROM atelier at JOIN adresa ad ON at.cod_adresa = ad.cod_adresa
WHERE ad.localitate like 'Buzau';
SELECT * FROM ATELIERE_BUZAU;

--operatie permisa:
UPDATE ATELIERE_BUZAU
SET an_infiintare = (SELECT MAX(an_infiintare) FROM ateliere_buzau);

--operatie nepermisa:
--INSERT INTO ATELIERE_BUZAU(cod_adresa, nume_strada) VALUES (1000, 'Bulevardul Eroilor');


--SELECT * FROM USER_UPDATABLE_COLUMNS WHERE TABLE_NAME LIKE 'ATELIERE_BUZAU';




--ex. 15

--Cerinta 1 (outer-join):

--Sa se ofere informatii si statistici despre vehiculele societatii de transport: anul achizitiei, starea actuala, modelul si numarul de identificare,
--numarul de evenimente de circulatie in care au fost implicate (daca este cazul), 
--informatii despre cel mai recent eveniment de circulatie (data acestuia, ce daune au suferit),
--istoricul tuturor reparatiilor prin care au trecut vehiculele (daca exista)


SELECT v.cod_vehicul, TO_CHAR(v.an_achizitie, 'YYYY') "An achizitie", v.intrebuintare, vt.stare, 
v.producator, m.denumire_model, COALESCE(nr_ev."Accidente", 0) "Nr accidente",
acc.data_producere "Data accident recent", acc.daune,
rep.data_incepere "Data incepere reparatie",
rep.data_finalizare "Data finalizare reparatie"
FROM vehicul v 
LEFT OUTER JOIN vehicul_transport vt ON v.cod_vehicul = vt.cod_vehicul_tr
LEFT OUTER JOIN model m ON vt.cod_model = m.cod_model
LEFT OUTER JOIN (SELECT COUNT(cod_eveniment) "Accidente", cod_vehicul_tr 
                    FROM implica 
                    GROUP BY cod_vehicul_tr) nr_ev 
            ON nr_ev.cod_vehicul_tr = vt.cod_vehicul_tr
LEFT OUTER JOIN     (SELECT event2.data_producere, imp2.cod_vehicul_tr, imp2.daune 
                            FROM implica imp2 
                            JOIN eveniment_circulatie event2 ON event2.cod_eveniment = imp2.cod_eveniment
                            WHERE event2.data_producere =
                                    (SELECT MAX(event.data_producere) "Accident recent"
                                    FROM eveniment_circulatie event
                                    JOIN implica imp ON imp.cod_eveniment = event.cod_eveniment
                                    WHERE imp.cod_vehicul_tr = imp2.cod_vehicul_tr
                                    GROUP BY imp.cod_vehicul_tr)
                    ) acc
                    ON acc.cod_vehicul_tr = vt.cod_vehicul_tr
LEFT OUTER JOIN reparatie rep ON vt.cod_vehicul_tr = rep.cod_vehicul_tr;



SELECT t.*, s.cod_statie, s.nume, s.localitate FROM traseu t 
JOIN parcurs_traseu pt ON t.numar_traseu = pt.numar_traseu
JOIN statie s ON pt.cod_statie = s.cod_statie 
ORDER BY t.numar_traseu;


--Cerinta 2 (Division):
--Sa se listeze informatii despre traseele care tranzitateaza toate statiile amplasate in localitatea Maracineni


SELECT t.numar_traseu, t.lungime, t.categorie
FROM traseu t
WHERE NOT EXISTS 
    (SELECT *
        FROM statie s
        WHERE s.localitate LIKE 'Maracineni' 
        AND NOT EXISTS
            (SELECT 1
            FROM parcurs_traseu pt
            WHERE pt.cod_statie = s.cod_statie 
            AND pt.numar_traseu = t.numar_traseu)
    );
        
        
        
--Cerinta 3 (Analiza "top-n"):
--Sa se ofere informatii despre primele 3 trasee pe care au fost efectuate cele mai multe curse.

SELECT * FROM
    (SELECT c.numar_traseu, t.lungime, t.categorie, t.calatori_zilnic, COUNT(c.numar_traseu) "Numar curse"
    FROM cursa c JOIN traseu t ON t.numar_traseu = c.numar_traseu
    GROUP BY c.numar_traseu, t.lungime, t.categorie, t.calatori_zilnic
    ORDER BY "Numar curse" DESC)
WHERE ROWNUM <= 3;




--EXERCITIUL 16
select * from model;

--codurile vehiculelor, producatorul, denumirea modelului si anul achizitiei pentru vehiculele de transport functionale care au fost cumparate incepand cu anul 2020 
--si care au o viteza maxima de deplasare de peste 80 km/h

SELECT v.cod_vehicul, v.producator,  m.denumire_model, TO_CHAR(v.an_achizitie, 'YYYY')
FROM vehicul v JOIN vehicul_transport vt ON v.cod_vehicul = vt.cod_vehicul_tr
JOIN model m ON vt.cod_model = m.cod_model
WHERE vt.stare = 'functional' AND m.viteza_maxima >= 80 AND v.an_achizitie >= TO_DATE('2020', 'YYYY');



--inainte de optimizare 
SELECT cod_vehicul, producator, denumire_model, TO_CHAR(an_achizitie, 'YYYY') FROM 
( SELECT * FROM (SELECT cod_vehicul, an_achizitie, producator FROM vehicul) WHERE an_achizitie  >= TO_DATE('2020', 'YYYY') ) veh1 ,

(SELECT * FROM 
        (SELECT * FROM vehicul_transport WHERE stare = 'functional') veh2,
        (SELECT * FROM (SELECT cod_model, denumire_model, viteza_maxima FROM model) WHERE viteza_maxima >= 80) model2 
        WHERE veh2.cod_model = model2.cod_model
) veh3
WHERE veh1.cod_vehicul = veh3.cod_vehicul_tr;


--dupa
SELECT cod_vehicul, producator, denumire_model, TO_CHAR(an_achizitie, 'YYYY') FROM 
(SELECT cod_vehicul, producator, an_achizitie FROM vehicul WHERE an_achizitie >= TO_DATE('2020', 'YYYY')) veh1,
(SELECT cod_vehicul_tr, denumire_model FROM
        (SELECT * FROM vehicul_transport WHERE stare = 'functional') vt2,
        (SELECT cod_model, denumire_model FROM model WHERE viteza_maxima >= 80) model2
        WHERE vt2.cod_model = model2.cod_model
) veh2
WHERE veh1.cod_vehicul = veh2.cod_vehicul_tr;


