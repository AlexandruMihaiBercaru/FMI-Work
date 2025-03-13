DESCRIBE produse_caracteristici;
SELECT * FROM clasific_clienti;
SELECT * FROM UNITATI_MASURA;
SELECT * FROM produse_caracteristici;
SELECT * FROM produse WHERE LOWER(denumire) LIKE '%creion mecanic%';
SELECT p.id_produs, p.denumire, stoc_curent, pret_unitar, greutate, volum, pc.valoare
    FROM produse p
    JOIN produse_caracteristici pc ON p.id_produs = pc.id_produs
    WHERE LOWER(denumire) LIKE '%creion mecanic%' AND stoc_curent > 0
    ORDER BY denumire;

--rigla plastic

SELECT * FROM categorii;

SET VERIFY OFF
DECLARE
    v_denumire_gama     VARCHAR2(30) :='&denumire_sortiment';
    v_denumire_produs   produse.denumire%TYPE;
    v_id_produs         produse.id_produs%TYPE;
    v_densitate         NUMBER(6, 8);
    v_grosime           NUMBER;
    tip_grosime         VARCHAR2(15); 
BEGIN
    --select...into... -> too many rows, no data found
    SELECT id_produs INTO v_id_produs
    FROM produse WHERE LOWER(denumire) LIKE '%creion mecanic%' 
    AND LOWER(denumire) LIKE '%' || LOWER(v_denumire_gama) || '%' AND stoc_curent > 0;
    
    --eroare zero-divide
    SELECT COALESCE(greutate, 0) / COALESCE(volum, 0), 
    denumire INTO v_densitate, v_denumire_produs
    FROM produse WHERE id_produs = v_id_produs;
    
    --value error (nu poate converti intotdeauna varchar2 la number)
    SELECT pc.valoare INTO v_grosime
    FROM produse p JOIN produse_caracteristici pc ON p.id_produs = pc.id_produs
    WHERE p.id_produs = v_id_produs
    FETCH FIRST 1 ROW ONLY;
    
    --case not found (lipsesc valorile 0.15 si 0.7)
    CASE v_grosime
        WHEN 0.35 THEN tip_grosime := 'fin';
        WHEN 0.5  THEN tip_grosime := 'mediu';
        WHEN 1  THEN tip_grosime := 'gros';
    END CASE;
    
    DBMS_OUTPUT.PUT_LINE('Denumire: '  || v_denumire_produs);
    DBMS_OUTPUT.PUT_LINE('Densitate: ' || v_densitate);
    DBMS_OUTPUT.PUT_LINE('Grosimea minei: '  || tip_grosime);
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nu exista niciun produs din sortimentul cautat!');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Exista mai multe produse din acelasi sortiment!');
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('EROARE: Impartire la zero!');
        DBMS_OUTPUT.PUT_LINE('Nu exista informatii referitoare la greutate si volum!');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('EROARE: VALUE_ERROR - exista o incompatibilitate la atribuire');
        DBMS_OUTPUT.PUT_LINE('Nu exista informatii despre grosimea minei creionului.');
    WHEN CASE_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('EROARE CASE_NOT_FOUND');
        DBMS_OUTPUT.PUT_LINE('Nu exista o categorie asociata grosimii minei');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
SET VERIFY ON




--3.8
CREATE TABLE clasific_clienti_abe AS SELECT * FROM clasific_clienti;

SELECT * FROM clasific_clienti_abe WHERE id_client = 12;
 
    
DECLARE
    v_categorie NUMBER;
    v_produse NUMBER;
    v_id_client clasific_clienti.id_client%TYPE := 12;
    v_clasificare CHAR(1);
BEGIN
    DELETE FROM clasific_clienti_abe WHERE id_client = v_id_client
        RETURNING id_categorie, nr_produse, clasificare
        INTO v_categorie, v_produse, v_clasificare;
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('ROWCOUNT = 0 - Nu exista client cu ID-ul ' || v_id_client);
    ELSIF SQL%ROWCOUNT = 1 THEN
        DBMS_OUTPUT.PUT_LINE('S-a sters clasificarea.');
    END IF;
    COMMIT;
    
    EXCEPTION 
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('EXCEPTION TOO MANY ROWS- Clientul cu ID-ul ' || v_id_client || ' are mai multe clasificari');
        WHEN NO_DATA_FOUND THEN 
            DBMS_OUTPUT.PUT_LINE('EXCEPTION NO DATA FOUND - Nu exista client cu ID-ul ' || v_id_client);
END;
/

SELECT * FROM clasific_clienti_abe WHERE id_client = 12;
DECLARE
    v_categorie NUMBER;
    v_produse NUMBER;
    v_clasificare CHAR(1);
    v_id_client clasific_clienti.id_client%TYPE := 12;
BEGIN
    UPDATE clasific_clienti_abe
    SET clasificare = 'D' WHERE id_client = v_id_client
    RETURNING id_categorie, nr_produse, clasificare
        INTO v_categorie, v_produse, v_clasificare;
        
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('ROWCOUNT = 0 - Nu exista client cu ID-ul ' || v_id_client);
    ELSE
        DBMS_OUTPUT.PUT_LINE('ROWCOUNT = 1 - S-a actualizat clasificarea.');
    END IF;
    COMMIT;

    EXCEPTION 
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('EXCEPTION TOO MANY ROWS UPDATE- Clientul cu ID-ul ' || v_id_client || ' are mai multe clasificari');
        WHEN NO_DATA_FOUND THEN 
            DBMS_OUTPUT.PUT_LINE('EXCEPTION NO DATA FOUND UPDATE- Nu exista client cu ID-ul ' || v_id_client);
END;
/
ROLLBACK;

SELECT * FROM clasific_clienti;



