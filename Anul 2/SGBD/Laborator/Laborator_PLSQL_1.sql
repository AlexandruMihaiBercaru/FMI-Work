<<principal>> 
DECLARE 
    v_client_id NUMBER(4):= 1600; 
    v_client_nume VARCHAR2(50):= 'N1'; 
    v_nou_client_id NUMBER(3):= 500; 
BEGIN 
    <<secundar>> 
    DECLARE 
        v_client_id NUMBER(4) := 0; 
        v_client_nume VARCHAR2(50) := 'N2'; 
        v_nou_client_id NUMBER(3) := 300; 
        v_nou_client_nume VARCHAR2(50) := 'N3'; 
    BEGIN 
        v_client_id:= v_nou_client_id; 
        principal.v_client_nume:= v_client_nume ||' '|| v_nou_client_nume; 
        --pozi?ia 1 
    END; 
    v_client_id:= (v_client_id *12)/10; 
    --pozi?ia 2
    dbms_output.put_line(v_client_nume);
END; 
/

--Exemplul 3
--Varianta 1: afisarea folosind variabile de legatura

VARIABLE g_mesaj VARCHAR2(50) 
BEGIN 
:g_mesaj := 'Invat PL/SQL'; 
END; 
/ 
PRINT g_mesaj

--Varianta 2 : Afisare folosind procedurile din pachetul standard DBMS.OUTPUT
BEGIN 
    DBMS_OUTPUT.PUT_LINE('Invat PL/SQL'); 
END;
/



--Exemplul 4
DECLARE v_dep departments.department_name%TYPE; 
BEGIN 
SELECT department_name 
INTO v_dep 
FROM employees e, departments d 
WHERE e.department_id=d.department_id 
GROUP BY department_name 
HAVING COUNT(*) = 
    (SELECT MAX(COUNT(*)) 
        FROM employees 
        GROUP BY department_id); 
DBMS_OUTPUT.PUT_LINE('Departamentul '|| v_dep); 
END; 
/



--Exemplul 5
VARIABLE rezultat VARCHAR2(35) 
BEGIN 
    SELECT department_name 
    INTO :rezultat
    FROM employees e, departments d 
    WHERE e.department_id=d.department_id 
    GROUP BY department_name 
    HAVING COUNT(*) = (SELECT MAX(COUNT(*)) 
                        FROM employees 
                        GROUP BY department_id); 
    DBMS_OUTPUT.PUT_LINE('Departamentul '|| :rezultat); 
END; 
/ 
PRINT rezultat



--Exemplul 6
VARIABLE rezultat VARCHAR2(35)
BEGIN 
SELECT department_name || ' - ' || COUNT(employee_id) || ' Angajati'
    INTO :rezultat
    FROM employees e, departments d 
    WHERE e.department_id=d.department_id 
    GROUP BY department_name 
    HAVING COUNT(*) = (SELECT MAX(COUNT(*)) 
                        FROM employees 
                        GROUP BY department_id); 
    DBMS_OUTPUT.PUT_LINE('Departamentul '|| :rezultat); 
END; 
/ 
PRINT rezultat 



--Exemplul 7
SET VERIFY OFF 
DECLARE 
	v_cod employees.employee_id%TYPE:=&p_cod; 
	v_bonus NUMBER(8); 
	v_salariu_anual NUMBER(8); 
BEGIN 
	SELECT salary*12 
	INTO v_salariu_anual 
	FROM employees 
	WHERE employee_id = v_cod; 
	IF v_salariu_anual>=200001 
		THEN v_bonus:=20000; 
	ELSIF v_salariu_anual BETWEEN 100001 AND 200000 
		THEN v_bonus:=10000; 
	ELSE v_bonus:=5000; 
END IF; 
DBMS_OUTPUT.PUT_LINE('Bonusul este ' || v_bonus); 
END; 
/ 
SET VERIFY ON



--Exemplul 8 
SET VERIFY OFF;
SET ECHO OFF;
DECLARE 
    v_cod employees.employee_id%TYPE:=&p_cod; 
    v_bonus NUMBER(8); 
    v_salariu_anual NUMBER(8); 
BEGIN 
    SELECT salary*12 
    INTO v_salariu_anual 
    FROM employees 
    WHERE employee_id = v_cod; 
    CASE 
        WHEN v_salariu_anual>=200001 
            THEN v_bonus:=20000; 
        WHEN v_salariu_anual BETWEEN 100001 AND 200000 
            THEN v_bonus:=10000; 
        ELSE v_bonus:=5000;
    END CASE; 
    DBMS_OUTPUT.PUT_LINE('Bonusul este ' || v_bonus); 
END; 
/
select * from employees;

select * from emp_abe;
--Exemplul 9: VARIABILE DE SUBSTITUTIE (DEFINE);  SQL%ROWCOUNT
DEFINE p_cod_sal= 200
DEFINE p_cod_dept = 80 
DEFINE p_procent = 20
DECLARE 
    v_cod_sal emp_abe.employee_id%TYPE:= &p_cod_sal; 
    v_cod_dept emp_abe.department_id%TYPE:= &p_cod_dept; 
    v_procent NUMBER(8):=&p_procent;
BEGIN 
    UPDATE emp_abe 
        SET department_id = v_cod_dept, salary=salary + (salary* v_procent/100) 
        WHERE employee_id= v_cod_sal; 
    IF SQL%ROWCOUNT =0 
        THEN DBMS_OUTPUT.PUT_LINE('Nu exista un angajat cu acest cod'); 
        ELSE DBMS_OUTPUT.PUT_LINE('Actualizare realizata');
    END IF; 
END;
/ 
ROLLBACK;



--Exemplul 10  LOOP...END LOOP
CREATE TABLE ZILE_ABE(
    id_zile     NUMBER(6)   PRIMARY KEY,
    data        DATE        NOT NULL,
    nume_zi     VARCHAR2(20)NOT NULL   
);

DECLARE 
    contor NUMBER(6) := 1; 
    v_data DATE; 
    maxim NUMBER(2) := LAST_DAY(SYSDATE)-SYSDATE; 
BEGIN 
    LOOP 
        v_data := sysdate+contor; 
        INSERT INTO zile_abe
            VALUES (contor,v_data,to_char(v_data,'Day')); 
        contor := contor + 1; 
        EXIT WHEN contor > maxim; 
    END LOOP; 
END; 
/
SELECT * FROM zile_abe;
ROLLBACK;
DROP TABLE zile_abe;

--Exemplul 11: WHILE(cond) LOOP ... END LOOP
DECLARE 
    contor NUMBER(6) := 1; 
    v_data DATE; 
    maxim NUMBER(2) := LAST_DAY(SYSDATE)-SYSDATE;
BEGIN 
    WHILE contor <= maxim LOOP 
        v_data := sysdate+contor; 
        INSERT INTO zile_abe 
            VALUES (contor,v_data,to_char(v_data,'Day')); 
        contor := contor + 1; 
    END LOOP; 
END; 
/



--Exemplul 12: FOR contor_ciclu IN lim_inf..lim_sup LOOP (...) END LOOP
DECLARE 
    v_data DATE; 
    maxim NUMBER(2) := LAST_DAY(SYSDATE)-SYSDATE; 
BEGIN 
    FOR contor IN 1..maxim LOOP 
        v_data := sysdate+contor; 
        INSERT INTO zile_abe VALUES (contor,v_data,to_char(v_data,'Day')); 
    END LOOP; 
    END; 
/
--variabila contor nu trebuie declarata (este neidentificata in afara ciclului)


--Exemplul 13
DECLARE 
    i POSITIVE:=1; 
    max_loop CONSTANT POSITIVE:=10; 
BEGIN 
    LOOP 
        i:=i+1; 
        IF i > max_loop THEN 
            DBMS_OUTPUT.PUT_LINE('in loop i=' || i); 
            GOTO urmator; 
        END IF; 
    END LOOP; 
    <<urmator>> 
    i:=1; 
    DBMS_OUTPUT.PUT_LINE('dupa loop i=' || i); 
END; 
/



--Exercitiul E3
--Defini?i un bloc anonim în care s? se determine num?rul de filme (titluri) 
--împrumutate de un membru al c?rui nume este introdus de la tastatur?.
--Afisati numarul total folosind cele doua metode prezentate la laborator. 
--Trata?i urm?toarele dou? situa?ii: nu exist? nici un membru cu nume dat;
--exist? mai mul?i membri cu acela?i nume.

SELECT * FROM member_abe;
SELECT * FROM rental;

SET ECHO OFF;
SET VERIFY OFF;
VARIABLE nr_filme NUMBER
DECLARE
    nume_membru member.last_name%TYPE:='&nume_membru';
    prenume member.first_name%TYPE;
BEGIN 
    SELECT COUNT(DISTINCT r.title_id)
    INTO :nr_filme
    FROM member_abe m
        LEFT JOIN rental r ON m.member_id = r.member_id
    WHERE m.last_name = nume_membru
    GROUP BY m.member_id;
    
    SELECT first_name INTO prenume
    FROM member_abe WHERE last_name = nume_membru;
    DBMS_OUTPUT.PUT_LINE(nume_membru || ' ' || prenume || ' a imprumutat ' || :nr_filme || ' filme');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            DBMS_OUTPUT.PUT_LINE('Nu exista niciun membru cu numele ' || nume_membru);
        WHEN TOO_MANY_ROWS THEN  
            DBMS_OUTPUT.PUT_LINE('Exista mai multi membri cu acest nume');
            :nr_filme := NULL;
END;
/
PRINT nr_filme

create table member_abe as select * from member;
insert into member_abe VALUES 
(110, 'Velasquez', 'Juan', 'Soseaua X', 'Bucuresti', '123-456-789', SYSDATE, null);
rollback;


--E4
VARIABLE nr_filme NUMBER
VARIABLE categorie NUMBER
DECLARE
    nume_membru member.last_name%TYPE:='&nume_membru';
    prenume member.first_name%TYPE;
    total_filme NUMBER(2);
BEGIN
    SELECT COUNT(DISTINCT r.title_id)
    INTO :nr_filme
    FROM member m
        LEFT JOIN rental r ON m.member_id = r.member_id
    WHERE m.last_name = nume_membru
    GROUP BY m.member_id;
    SELECT first_name INTO prenume
    FROM member WHERE last_name = nume_membru;
    
    SELECT COUNT(title_id) INTO total_filme FROM title;
    CASE  
        WHEN :nr_filme / total_filme > 0.75 THEN :categorie:= 1;
        WHEN :nr_filme / total_filme > 0.5 THEN :categorie:= 2;
        WHEN :nr_filme / total_filme > 0.25 THEN :categorie:= 3;
        ELSE :categorie := 4; 
    END CASE;
    DBMS_OUTPUT.PUT_LINE(nume_membru || ' ' || prenume || ' a imprumutat ' || :nr_filme || ' filme');
    DBMS_OUTPUT.PUT_LINE('Categoria' || ' ' || :categorie);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            DBMS_OUTPUT.PUT_LINE('Nu exista niciun membru cu numele ' || nume_membru);
        WHEN TOO_MANY_ROWS THEN  
            DBMS_OUTPUT.PUT_LINE('Exista mai multi membri cu acest nume');
END;
/
PRINT nr_filme
PRINT categorie



--E5
CREATE TABLE member_abe AS
    SELECT * FROM member;
ALTER TABLE member_abe
ADD discount NUMBER(6,2);
SELECT * FROM member_abe;


DECLARE
    --v_cod_membru member.member_id%TYPE := &cod_membru;
    filme_membru NUMBER(3);
    total_filme NUMBER(2);
    v_discount NUMBER(6,2);
    cod_minim member.member_id%TYPE;
    cod_maxim member.member_id%TYPE;
BEGIN
SELECT COUNT(title_id) INTO total_filme FROM title;

SELECT MIN(member_id) INTO cod_minim FROM member;
SELECT MAX(member_id) INTO cod_maxim FROM member;

FOR cod_curent IN cod_minim..cod_maxim LOOP 
    SELECT COUNT(DISTINCT r.title_id)
    INTO filme_membru
    FROM member m
        LEFT JOIN rental r ON m.member_id = r.member_id
    WHERE m.member_id = cod_curent
    GROUP BY m.member_id;
    
    CASE  
        WHEN filme_membru / total_filme > 0.75 THEN v_discount:= 0.1;
        WHEN filme_membru / total_filme > 0.5 THEN v_discount:= 0.05;
        WHEN filme_membru / total_filme > 0.25 THEN v_discount:= 0.03;
        ELSE v_discount := 0; 
    END CASE;
    
    UPDATE member_abe
        SET discount = v_discount
        WHERE member_id = cod_curent;
        
    IF SQL%ROWCOUNT =0 
        THEN DBMS_OUTPUT.PUT_LINE('Nu exista un membru cu acest cod'); 
        ELSE DBMS_OUTPUT.PUT_LINE('Actualizare realizata');
    END IF; 
    
END LOOP;
END;
/
ROLLBACK;

--E2 - a)
WITH octombrie AS(
    SELECT TO_DATE('01-OCT-2024', 'DD-MM-YYYY') + rownum - 1 "Ziua1", 0 "Numar"
    FROM DUAL
    CONNECT BY rownum <= TO_DATE('01-NOV-2024', 'DD-MM-YYYY') - TO_DATE('01-OCT-2024', 'DD-MM-YYYY') 
),
imprumuturi_pe_zi AS(
    SELECT TRUNC(book_date) "Ziua2", COUNT(book_date) "Numar imprumuturi"
    FROM rental
    GROUP BY TRUNC(book_date)
    ORDER BY "Ziua2"
)
SELECT TABEL."Ziua1" "Data", SUM(TABEL."Numar") "Numar imprumuturi" FROM
    (SELECT o."Ziua1", o."Numar" FROM octombrie o
    UNION
    SELECT ipz."Ziua2", ipz."Numar imprumuturi" FROM imprumuturi_pe_zi ipz) 
TABEL 
GROUP BY TABEL."Ziua1"
ORDER BY TO_DATE(TABEL."Ziua1", 'DD-MM-YYYY');

--2b)
CREATE TABLE octombrie_abe(
    id_zi NUMBER(2) PRIMARY KEY,
    data DATE NOT NULL
);
DECLARE
    data_crt DATE := TRUNC(SYSDATE, 'mm');
    maxim_luna NUMBER := TO_CHAR(LAST_DAY(SYSDATE), 'dd');
BEGIN
    FOR contor IN 1..maxim_luna LOOP
        INSERT INTO octombrie_abe (id_zi, data) 
        VALUES (contor, data_crt);
        data_crt := data_crt + 1;
    END LOOP;
END;
/

WITH oct_rentals AS (
(SELECT TRUNC(book_date) "Ziua", COUNT(book_date) "Numar imprumuturi"
    FROM rental
    GROUP BY TRUNC(book_date)
)
UNION
(SELECT data, 0
    FROM octombrie_abe)
)
SELECT "Ziua", SUM("Numar imprumuturi") Numar
FROM oct_rentals
GROUP BY "Ziua"
ORDER BY "Ziua";
