--FETCH nume_cursor INTO... genereaza exceptii (too many rows, no data found)?

--adaptare pe exemplul 5.3 din curs
DECLARE
    TYPE tab_categ IS TABLE OF categorii%ROWTYPE;
    v_categ tab_categ := tab_categ();
    categ_1     categorii%ROWTYPE;
    categ_2     categorii%ROWTYPE;
    CURSOR c1 IS
        SELECT * FROM categorii WHERE id_parinte IS NULL;
    CURSOR c2 IS
        SELECT * FROM categorii WHERE 1=2;
BEGIN
    <<subbloc_1>>
    BEGIN
        OPEN c1;
        LOOP
            FETCH c1 BULK COLLECT INTO categ_1;
            EXIT WHEN c1%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('Denumire categorie (c1): ' || categ_1.denumire || ' ' || c1%ROWCOUNT);
        END LOOP;
        IF c1%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('c1 nu a incarcat nicio linie');
        ELSE
            DBMS_OUTPUT.PUT_LINE('c1 a incarcat cel putin o linie');  
        END IF;
       
        DBMS_OUTPUT.PUT_LINE('Denumire categorie (c1): ' || categ_1.denumire || ' ' || c1%ROWCOUNT);
        CLOSE c1;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Eroare! c1 nu a incarcat nicio linie.');
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Eroare! c1 a incarcat prea multe linii.');
        --WHEN INVALID_CURSOR THEN
            --DBMS_OUTPUT.PUT_LINE('Eroare! Cursor inchis.');
        
    END subbloc_1;
    
    <<subbloc_2>>
    BEGIN
        OPEN c2;
        FETCH c2 INTO categ_2;
        DBMS_OUTPUT.PUT_LINE('Denumire categorie 2: ' || NVL(categ_2.denumire, 0));

        IF c2%NOTFOUND THEN
            DBMS_OUTPUT.PUT_LINE('c2 nu a incarcat nicio linie');
        ELSE
            DBMS_OUTPUT.PUT_LINE('c2 a incarcat cel putin o linie');
        END IF;
        CLOSE c2;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Eroare! c2 nu a incarcat nicio linie.');
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Eroare! c2 a incarcat prea multe linii.');
            
    END subbloc_2;
END;
/


CREATE TABLE categorii_amb AS SELECT * FROM categorii;
ALTER TABLE categorii_amb MODIFY id_categorie NUMBER(7);
SELECT count(*) FROM categorii_amb WHERE id_parinte is null;


DROP TABLE categorii_amb;
DESCRIBE categorii_amb;

DECLARE
    crt_id      categorii_amb.id_categorie%TYPE;
BEGIN
    SELECT MAX(id_categorie) + 1 INTO crt_id FROM categorii_amb;
    FOR i IN 1..1000000 LOOP
        INSERT INTO categorii_amb(id_categorie, denumire, nivel)
        VALUES(crt_id, 'Categoria ' || i, 1);
        crt_id := crt_id + 1;
    END LOOP;
END;
/

ROLLBACK;


--5.6.
--fetch bulk collect into
DECLARE
    TYPE tab_imb IS TABLE OF categorii_amb%ROWTYPE;
    v_categorii tab_imb;
    categorie           categorii_amb%ROWTYPE;
    CURSOR c IS SELECT * FROM categorii_amb WHERE id_parinte IS NULL;
    timp_inainte_fetch      PLS_INTEGER;
    timp_dupa_fetch         PLS_INTEGER;
BEGIN
    OPEN c;
    timp_inainte_fetch := DBMS_UTILITY.GET_TIME;
    LOOP
        FETCH c INTO categorie;
        EXIT WHEN c%NOTFOUND;
    END LOOP;
    timp_dupa_fetch := DBMS_UTILITY.GET_TIME;
    CLOSE c;
    DBMS_OUTPUT.PUT_LINE('------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Timp FETCH c INTO: ' ||
    to_char((timp_dupa_fetch - timp_inainte_fetch)/100) || ' secunde');
END;
/


--select bulk collect into
DECLARE
    TYPE tab_imb IS TABLE OF categorii_amb%ROWTYPE;
    v_categorii tab_imb;
    timp_inainte_select      PLS_INTEGER;
    timp_dupa_select         PLS_INTEGER;
BEGIN
    timp_inainte_select := DBMS_UTILITY.GET_TIME;
    SELECT * BULK COLLECT INTO v_categorii 
        FROM categorii_amb 
        WHERE id_parinte IS NULL;
    timp_dupa_select := DBMS_UTILITY.GET_TIME;
    DBMS_OUTPUT.PUT_LINE('------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Timp SELECT BULK COLLECT INTO: ' ||
    to_char((timp_dupa_select - timp_inainte_select)/100) || ' secunde');
END;
/