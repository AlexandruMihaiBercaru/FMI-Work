--Exercitiul E1
DECLARE
    TYPE tablou_employees
        IS TABLE OF employees.employee_id%TYPE
        INDEX BY PLS_INTEGER;
    TYPE modif_salariu IS RECORD
        (salariu_vechi emp_abe.salary%TYPE,
        salariu_nou emp_abe.salary%TYPE);
    rec_salarii modif_salariu;
    v_tablou_ang tablou_employees;
    salariu_vechi NUMBER(6);
    salariu_nou NUMBER(6);
    v_err_count NUMBER;
BEGIN
    SELECT * 
    BULK COLLECT INTO v_tablou_ang
    FROM
    (SELECT employee_id FROM emp_abe
        WHERE commission_pct IS NULL
        ORDER BY salary)
    WHERE ROWNUM <= 5;
    
    FOR i IN v_tablou_ang.FIRST..v_tablou_ang.LAST LOOP
        SELECT salary INTO salariu_vechi FROM emp_abe WHERE employee_id = v_tablou_ang(i);
        --FORALL i IN v_tablou_ang.FIRST..v_tablou_ang.LAST SAVE EXCEPTIONS
        UPDATE emp_abe
            SET salary = salary + 0.05 * salary
        WHERE employee_id = v_tablou_ang(i)
        RETURNING salary INTO salariu_nou;
        DBMS_OUTPUT.PUT_LINE(v_tablou_ang(i) || ' - ' || salariu_vechi || ' -> ' || salariu_nou);
    END LOOP;
    --EXCEPTION
        --WHEN OTHERS THEN 
            --DBMS_OUTPUT.PUT_LINE('FFF');
END;
/
ROLLBACK;

UPDATE emp_abe
SET commission_pct = 0.1;
SELECT * FROM emp_abe;


SELECT * 
    --BULK COLLECT INTO v_tablou_ang
    FROM
    (SELECT employee_id FROM emp_abe
        WHERE commission_pct IS NULL
        ORDER BY salary)
    WHERE ROWNUM <= 5;
    
    
 
--Exercitiul E2
CREATE OR REPLACE TYPE tip_orase_abe IS VARRAY(100) OF VARCHAR2(30);
/

CREATE TABLE excursie_abe (
    cod_excursie        NUMBER(4)       PRIMARY KEY,
    denumire            VARCHAR2(20),
    orase               tip_orase_abe,
    status              VARCHAR2(20)    CHECK (status IN ('disponibila', 'anulata'))
);

--DESCRIBE excursie_abe

-- punctul a
    INSERT INTO excursie_abe (cod_excursie, denumire, orase, status)
    VALUES (101, 'Comorile Banatului', tip_orase_abe('Timisoara', 'Arad', 'Resita', 'Baile Herculane'), 'disponibila');
    INSERT INTO excursie_abe (cod_excursie, denumire, orase, status)
    VALUES (102, 'Vizitati Spania!', tip_orase_abe('Sevilla', 'Granada', 'Alhambra', 'Valencia', 'Bilbao'), 'disponibila');
    INSERT INTO excursie_abe (cod_excursie, denumire, orase, status)
    VALUES (103, 'Prin Scandinavia', tip_orase_abe ('Stockholm', 'Malmo', 'Oslo', 'Copenhaga', 'Goteburg'), 'anulata');
    INSERT INTO excursie_abe (cod_excursie, denumire, orase, status)
    VALUES (104, 'Italia', tip_orase_abe('Verona', 'Florenta', 'Milano', 'Venetia'), 'disponibila');
    INSERT INTO excursie_abe (cod_excursie, denumire, orase, status)
    VALUES (105, 'Japonia', tip_orase_abe('Tokyo', 'Osaka', 'Kyoto'), 'disponibila');
    COMMIT;
    

<<punctul_b>>
DECLARE
    v_cod_excursie  excursie_abe.cod_excursie%TYPE := &cod_exc_b;
    v_nume_oras1    VARCHAR2(20) := '&adauga_oras_1';
    v_nume_oras2    VARCHAR2(20) := '&adauga_oras_2';
    
    v_orase         tip_orase_abe := tip_orase_abe();
    oras_1          VARCHAR2(20) := 'Tokyo';
    oras_2          VARCHAR2(20) := 'Osaka';
    oras_sters      VARCHAR2(20) := 'Kyoto';
    oras_aux        VARCHAR2(20);
    pos_1           NUMBER := 0;
    pos_2           NUMBER := 0;
    contor           NUMBER;
BEGIN   
    --adaugati oras nou (ultimul in lista)
    SELECT orase INTO v_orase FROM excursie_abe WHERE cod_excursie = v_cod_excursie;
    v_orase.extend;
    v_orase(v_orase.last) := v_nume_oras1;
    --afisare lista orase (ca sa vedem modificarea)
    DBMS_OUTPUT.PUT_LINE('Adaugare la final:');
    FOR i IN 1..v_orase.last LOOP
        DBMS_OUTPUT.PUT(v_orase(i) || ' ');       
    END LOOP;
    DBMS_OUTPUT.NEW_LINE();
    
    
    --adaugati un oras in lista (sa fie al doilea vizitat)
    v_orase.extend;
    FOR i IN REVERSE 3..v_orase.last LOOP
        v_orase(i) := v_orase(i-1);
    END LOOP;
    v_orase(2) := v_nume_oras2;
    --afisare lista orase
    DBMS_OUTPUT.PUT_LINE('Adaugare pozitia 2:');
    FOR i IN 1..v_orase.last LOOP
        DBMS_OUTPUT.PUT(v_orase(i) || ' ');       
    END LOOP;    
    DBMS_OUTPUT.NEW_LINE();
    
    
    --inversati ordine vizitare orase
    --caut pozitiile pe care se afla 
    FOR i IN 1..v_orase.last LOOP
        IF v_orase(i) = oras_1 THEN
            pos_1 := i;
        END IF;
        IF v_orase(i) = oras_2 THEN
            pos_2 := i;
        END IF;
    END LOOP;
    --swap
    IF pos_1 <> 0 AND pos_2 <> 0 THEN
        oras_aux := v_orase(pos_1);
        v_orase(pos_1) := v_orase(pos_2);
        v_orase(pos_2) := oras_aux;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Nu exista ambele orase in colectie.');
    END IF;
    --afisare
    DBMS_OUTPUT.PUT_LINE('Swap orase:');
    FOR i IN 1..v_orase.last LOOP
        DBMS_OUTPUT.PUT(v_orase(i) || ' ');       
    END LOOP;    
    DBMS_OUTPUT.NEW_LINE(); 
    
    
    --eliminati din lista un oras cu numele specificat
    FOR i IN 1..v_orase.last LOOP
        IF v_orase(i) = oras_sters THEN
            v_orase(i) := NULL;
        END IF;
    END LOOP;
    --actualizez tabela
    UPDATE excursie_abe
        SET orase = v_orase
        WHERE cod_excursie = v_cod_excursie;
    --afisare
    DBMS_OUTPUT.PUT_LINE('Stergere oras:');
    contor := v_orase.first;
    WHILE contor <= v_orase.last LOOP
        DBMS_OUTPUT.PUT(v_orase(contor) || ' ');
        contor := v_orase.next(contor);
    END LOOP;
    DBMS_OUTPUT.NEW_LINE(); 
    DBMS_OUTPUT.PUT_LINE(v_orase.count);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista nicio excursie cu codul dat.');         
END punctul_b;
/
ROLLBACK;


<<punctul_c>>
DECLARE
    v_cod_excursie  excursie_abe.cod_excursie%TYPE := &cod_exc_c;
    lista_orase     tip_orase_abe := tip_orase_abe();
    nr_orase        NUMBER := 0;
    contor          NUMBER;
BEGIN
    SELECT orase INTO lista_orase FROM excursie_abe WHERE cod_excursie = v_cod_excursie;
    contor := lista_orase.first;
    DBMS_OUTPUT.PUT_LINE('Orasele vizitate:');
    WHILE contor <= lista_orase.last LOOP
        IF lista_orase(contor) IS NOT NULL THEN
            DBMS_OUTPUT.PUT(lista_orase(contor) || ' ');
            nr_orase := nr_orase + 1;
        END IF;
        contor := lista_orase.next(contor);
    END LOOP;
    DBMS_OUTPUT.NEW_LINE(); 
    DBMS_OUTPUT.PUT_LINE('Numarul de orase vizitate: ' || nr_orase);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista nicio excursie cu codul dat.');         
END punctul_c;
/


<<punctul_d>>
DECLARE
    TYPE vect_cod_exc IS VARRAY(100) OF excursie_abe.cod_excursie%TYPE;
    v_excursii  vect_cod_exc := vect_cod_exc();
    lista_orase tip_orase_abe := tip_orase_abe();
    contor      NUMBER;
BEGIN
    SELECT cod_excursie BULK COLLECT INTO v_excursii FROM excursie_abe;
    FOR i IN 1..v_excursii.last LOOP
        SELECT orase INTO lista_orase FROM excursie_abe WHERE cod_excursie = v_excursii(i);
        DBMS_OUTPUT.PUT('Excursia ' || v_excursii(i) || ': ');
        contor := lista_orase.first;
        WHILE contor <= lista_orase.last LOOP
            IF lista_orase(contor) IS NOT NULL THEN
                DBMS_OUTPUT.PUT(lista_orase(contor) || ' ');
            END IF;
            contor := lista_orase.next(contor);
        END LOOP;
        DBMS_OUTPUT.NEW_LINE(); 
    END LOOP;
END punctul_d;
/


<<punctul_e>>
DECLARE
    TYPE vect_cod_exc IS VARRAY(100) OF excursie_abe.cod_excursie%TYPE;
    TYPE t_exc_min IS TABLE OF excursie_abe.cod_excursie%TYPE;
    v_excursii  vect_cod_exc := vect_cod_exc();
    lista_orase tip_orase_abe := tip_orase_abe();
    coduri_exc_min  t_exc_min := t_exc_min();
    min_count_orase NUMBER := 100;
    nr_orase        NUMBER;
    l_error_count   NUMBER;
BEGIN
    SELECT cod_excursie BULK COLLECT INTO v_excursii FROM excursie_abe;
    FOR i IN 1..v_excursii.last LOOP
        SELECT orase INTO lista_orase FROM excursie_abe WHERE cod_excursie = v_excursii(i);
        nr_orase := lista_orase.count;
        IF nr_orase < min_count_orase THEN
            min_count_orase := nr_orase;
            coduri_exc_min.delete;
            coduri_exc_min.extend;
            coduri_exc_min(1) := v_excursii(i);
        ELSIF nr_orase = min_count_orase THEN
            coduri_exc_min.extend;
            coduri_exc_min(coduri_exc_min.last) := v_excursii(i);
        END IF;
    END LOOP;
    FORALL i IN 1..coduri_exc_min.last SAVE EXCEPTIONS
        UPDATE excursie_abe
        SET status = 'anulata'
        WHERE cod_excursie = coduri_exc_min(i);
    DBMS_OUTPUT.put_line ('Numar inregistrari actualizate: ' || SQL%ROWCOUNT);
EXCEPTION
   WHEN OTHERS THEN
      l_error_count := SQL%BULK_EXCEPTIONS.count;
      DBMS_OUTPUT.put_line('Number of failures: ' || l_error_count);             
END punctul_e;
/
ROLLBACK;
SELECT * FROM excursie_abe;
SELECT exc.cod_excursie, exc.denumire, ors.*, exc.status
    FROM excursie_abe exc, TABLE(exc.orase) ors;
    
DROP TABLE excursie_abe;
DROP TYPE tip_orase_abe;



CREATE OR REPLACE TYPE tip_orase_abe IS TABLE OF VARCHAR2(30);
/
 
CREATE TABLE excursie_abe (
    cod_excursie        NUMBER(4)       PRIMARY KEY,
    denumire            VARCHAR2(20),
    orase               tip_orase_abe,
    status              VARCHAR2(20)    CHECK (status IN ('disponibila', 'anulata'))
)
NESTED TABLE orase STORE AS tabl_imb_orase;

-- punctul a
    INSERT INTO excursie_abe (cod_excursie, denumire, orase, status)
    VALUES (101, 'Comorile Banatului', tip_orase_abe('Timisoara', 'Arad', 'Resita', 'Baile Herculane'), 'disponibila');
    INSERT INTO excursie_abe (cod_excursie, denumire, orase, status)
    VALUES (102, 'Vizitati Spania!', tip_orase_abe('Sevilla', 'Granada', 'Valencia', 'Bilbao'), 'disponibila');
    INSERT INTO excursie_abe (cod_excursie, denumire, orase, status)
    VALUES (103, 'Prin Scandinavia', tip_orase_abe ('Stockholm', 'Malmo', 'Oslo', 'Copenhaga', 'Goteburg'), 'disponibila');
    INSERT INTO excursie_abe (cod_excursie, denumire, orase, status)
    VALUES (104, 'Italia', tip_orase_abe('Verona', 'Florenta', 'Milano', 'Venetia'), 'disponibila');
    INSERT INTO excursie_abe (cod_excursie, denumire, orase, status)
    VALUES (105, 'Japonia', tip_orase_abe('Tokyo', 'Osaka', 'Kyoto'), 'disponibila');
    COMMIT;

SELECT * FROM excursie_abe;
DROP TABLE excursie_abe;
DROP TYPE tip_orase_abe;
ROLLBACK;

--punctul b1
UPDATE excursie_abe
    SET orase = orase MULTISET UNION
                CAST(MULTISET(SELECT 'Barcelona' FROM DUAL) AS tip_orase_abe)
    WHERE cod_excursie = 102;

--punctul b2 
UPDATE excursie_abe
    SET orase = (
                    CAST(MULTISET
                            (SELECT COLUMN_VALUE FROM TABLE(SELECT orase 
                                                        FROM excursie_abe 
                                                        WHERE cod_excursie = 102) 
                            FETCH FIRST ROW ONLY) AS tip_orase_abe) 
                        MULTISET UNION 
                    CAST(MULTISET(SELECT 'Madrid' FROM DUAL) AS tip_orase_abe)
                )
                MULTISET UNION
                (  
                    orase MULTISET EXCEPT DISTINCT
                    CAST(MULTISET
                            (SELECT COLUMN_VALUE FROM TABLE(SELECT orase 
                                                        FROM excursie_abe 
                                                        WHERE cod_excursie = 102) 
                            FETCH FIRST ROW ONLY) AS tip_orase_abe)
                )
WHERE cod_excursie = 102;

--punctul b3
/*
Nu se poate inversa ordinea de vizitare a oraselor folosind doar SQL 
(fara a ne folosi de variabile), pentru ca mai intai ar trebui sa gasim 
pozitiile pe care se afla valorile date in colectie. Altfel, nu am putea
sa facem operatia de ”swap” direct.
*/


--punctul b4
UPDATE excursie_abe
    SET orase = orase MULTISET EXCEPT DISTINCT
                CAST(MULTISET(SELECT 'Granada' FROM DUAL) AS tip_orase_abe)
WHERE cod_excursie = 102;
 
                
SELECT * FROM excursie_abe;
SELECT exc.cod_excursie, exc.denumire, ors.*, exc.status
    FROM excursie_abe exc, TABLE(exc.orase) ors
    WHERE cod_excursie = 102;

--punctul c    
SELECT CARDINALITY(exc.orase) "Nr orase", ors.*
    FROM excursie_abe exc, TABLE(exc.orase) ors
    WHERE exc.cod_excursie = 101; 
    
--punctul d
SELECT exc.cod_excursie, exc.denumire, (SELECT LISTAGG(COLUMN_VALUE, ', ') WITHIN GROUP 
                                        (ORDER BY ROWNUM) 
                                        FROM excursie_abe exc2, TABLE(exc2.orase)
                                        WHERE exc2.cod_excursie = exc.cod_excursie)
        FROM excursie_abe exc
        GROUP BY exc.cod_excursie, exc.denumire
        ORDER BY exc.cod_excursie;
     
--e
UPDATE excursie_abe
SET status = 'anulata'
WHERE CARDINALITY(orase) = 
    (SELECT MIN("Numar")
        FROM
        (SELECT CARDINALITY(orase) "Numar" FROM excursie_abe));


ROLLBACK;