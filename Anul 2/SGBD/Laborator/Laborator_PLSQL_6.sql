CREATE OR REPLACE TRIGGER trig1_*** 
BEFORE INSERT OR UPDATE OR DELETE ON emp_*** 
BEGIN 
    IF (TO_CHAR(SYSDATE,'D') = 1) OR (TO_CHAR(SYSDATE,'HH24') NOT BETWEEN 8 AND 20) THEN 
    RAISE_APPLICATION_ERROR(-20001,'tabelul nu poate fi actualizat'); 
    END IF; 
END; 
/ 
DROP TRIGGER trig1_***;


--4
CREATE TABLE info_dept(
    id              NUMBER(3)          PRIMARY KEY,
    nume_dept       VARCHAR2(32),
    plati           NUMBER
);


DECLARE
    CURSOR depts IS
        SELECT d.department_id, d.department_name, NVL(SUM(e.salary), 0)
        FROM departments d
            LEFT JOIN employees e ON d.department_id = e.department_id
        GROUP BY d.department_id, d.department_name;
    v_cod_dep       departments.department_id%type;
    v_nume_dep      departments.department_name%type;
    v_salariu       employees.salary%type;
BEGIN
    open depts;
    FETCH depts INTO v_cod_dep, v_nume_dep, v_salariu;
    WHILE depts%found LOOP
        INSERT INTO info_dept(id, nume_dept, plati) VALUES
            (v_cod_dep, v_nume_dep, v_salariu);
        FETCH depts INTO v_cod_dep, v_nume_dep, v_salariu;
    END LOOP;
    dbms_output.put_line('Randuri inserate: ' || depts%rowcount);
    close depts;
END;
/


SELECT * FROM info_dept;
--Defini?i un declan?ator care va actualiza automat câmpul plati atunci când se introduce un nou salariat,
--respectiv se ?terge un salariat sau se modific? salariul unui angajat.

CREATE OR REPLACE PROCEDURE modific_plati
    (v_codd info_dept.id%TYPE, v_plati info_dept.plati%TYPE) 
AS 
BEGIN 
    UPDATE info_dept SET plati = NVL (plati, 0) + v_plati 
    WHERE id = v_codd; 
END; 
/


CREATE OR REPLACE TRIGGER trig4 
    AFTER 
    DELETE OR UPDATE OR INSERT OF salary ON copie_emp 
    FOR EACH ROW 
BEGIN 
    IF DELETING THEN 
        -- se sterge un angajat 
        modific_plati(:OLD.department_id, -1*:OLD.salary); 
    ELSIF UPDATING THEN 
        --se modifica salariul unui angajat 
        modific_plati(:OLD.department_id, :NEW.salary-:OLD.salary); 
    ELSE 
        -- se introduce un nou angajat 
        modific_plati(:NEW.department_id, :NEW.salary); 
    END IF; 
END; 
/

SELECT * FROM info_dept WHERE id=90; 

INSERT INTO copie_emp 
(employee_id, last_name, email, hire_date, job_id, salary, department_id)
VALUES (300, 'N1', 'n1@g.com',sysdate, 'SA_REP', 2000, 90);


CREATE TABLE
    info_emp(
id          NUMBER          PRIMARY KEY,
nume        VARCHAR2(32),
prenume     VARCHAR2(32),
salariu     NUMBER,
id_dept     NUMBER
);

ALTER TABLE info_emp
    ADD CONSTRAINT fk_info_dep FOREIGN KEY(id_dept)
        REFERENCES info_dept(id);

--SELECT * FROM user_constraints;

BEGIN
    FOR c IN (SELECT employee_id, last_name, first_name, salary, department_id FROM employees) LOOP
        INSERT INTO info_emp VALUES(c.employee_id, c.last_name, c.first_name, c.salary, c.department_id);
    END LOOP;
END;
/

SELECT * FROM info_emp;

CREATE OR REPLACE VIEW v_info
    AS
    SELECT e.id, nume, prenume, salariu, id_dept, nume_dept, plati
    FROM info_emp e
    JOIN info_dept d ON e.id_dept = d.id;
    
SELECT * FROM v_info;
SELECT * FROM user_updatable_columns WHERE table_name = UPPER('v_info');


CREATE OR REPLACE TRIGGER trig5
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_info
FOR EACH ROW 
BEGIN 
    IF INSERTING THEN 
        -- inserarea in vizualizare determina inserarea 
        -- in info_emp si reactualizarea in info_dept
        -- se presupune ca departamentul exista 
        INSERT INTO info_emp VALUES (:NEW.id, :NEW.nume, :NEW.prenume, :NEW.salariu, :NEW.id_dept); 
        UPDATE info_dept 
            SET plati = plati + :NEW.salariu 
            WHERE id = :NEW.id_dept; 
            
    ELSIF DELETING THEN 
        -- stergerea unui salariat din vizualizare determina 
        -- stergerea din info_emp 
        --si reactualizarea in info_dept 
        DELETE FROM info_emp 
            WHERE id = :OLD.id; 
        UPDATE info_dept 
            SET plati = plati - :OLD.salariu 
        WHERE id = :OLD.id_dept; 
        
    ELSIF UPDATING('salariu') THEN 
        /* modificarea unui salariu din vizualizare determina modificarea salariului in info_emp
        si reactualizarea in info_dept */ 
        UPDATE info_emp 
            SET salariu = :NEW.salariu 
        WHERE id = :OLD.id; 
        UPDATE info_dept
            SET plati = plati - :OLD.salariu + :NEW.salariu 
        WHERE id = :OLD.id_dept; 
    
    ELSIF UPDATING ('id_dept') THEN 
        /* modificarea unui cod de departament din vizualizare 
        determina modificarea codului in info_emp si reactualizarea in info_dept 
        */
        UPDATE info_emp 
            SET id_dept = :NEW.id_dept 
            WHERE id = :OLD.id; 
        UPDATE info_dept 
            SET plati = plati - :OLD.salariu 
            WHERE id = :OLD.id_dept; 
        UPDATE info_dept 
            SET plati = plati + :NEW.salariu
            WHERE id = :NEW.id_dept; 
    END IF; 
END; 
/



SELECT * FROM info_dept WHERE id=10;
--de declansat triggerul


SELECT * FROM v_info;
--E3
--introduceti in info_dept coloana numar (semnifica numarul de angajati care lucreaza intr-un departament)

ALTER TABLE info_dept
ADD numar NUMBER;

SELECT * FROM info_dept;
SELECT * FROM info_emp;
BEGIN
    FOR c IN (SELECT d.department_id dep_id, COUNT(e.employee_id) nr
                FROM departments d
                LEFT JOIN employees e ON e.department_id = d.department_id
                GROUP BY d.department_id) LOOP
        UPDATE info_dept
        SET numar = c.nr
        WHERE id = c.dep_id;
    END LOOP;
END;
/
ROLLBACK;


--definiti un trigger care actualizeaza automat aceasta coloana 
--in functie de actualizarile realizate asupra tabelului info_emp

CREATE OR REPLACE TRIGGER trigg_update_numar_ang
    AFTER INSERT OR DELETE ON info_emp
    FOR EACH ROW
BEGIN
    IF DELETING THEN
        -- sterg un angajat din info_emp
        -- numar = numar - 1 in info_dept
        -- scad salariul aferent din plati
        UPDATE info_dept
        SET numar = numar - 1,
            --plati = modific_plati()
        WHERE id = :OLD.id_dept;
        
    ELSIF INSERTING THEN
        UPDATE info_dept
        SET numar = numar + 1
        WHERE id = :OLD.id_dept;   
        
    END IF;
END;
/
    
SELECT * FROM info_emp WHERE id_dept = 90;

SELECT * FROM info_dept;

DELETE FROM info_emp WHERE id = 102;

ROLLBACK;

ALTER FUNCTION ang_abe COMPILE;
