--DEBUG, DD
SELECT username FROM all_users;
DESCRIBE all_users;
SELECT USER FRom dual;

--select * from SESSION;

SELECT *
FROM user_objects
WHERE object_type IN ( 'PROCEDURE', 'FUNCTION' );

DESCRIBE user_source;
SELECT text FROM user_source WHERE name = upper('f2_abe');

/*
select sesion.sid,
sql_text
from sys.v$sqltext sqltext, sys.v$session sesion
where sesion.sql_hash_value = sqltext.hash_value
and sesion.sql_address = sqltext.address
and sesion.username is not null
order by sqltext.piece;
  
select inst_id, program, module, SQL_ID, machine
from gv$session
where type!='BACKGROUND'
and status='ACTIVE'
and sql_id is not null;
*/

SELECT line, position, text
FROM user_errors
WHERE name = upper('f2_abe');
--

--EXERCITIUL E1
CREATE TABLE info_abe (
    utilizator      VARCHAR2(128),
    data_comanda    DATE,
    comanda         VARCHAR2(128),
    nr_linii        NUMBER(10),
    eroare          VARCHAR2(128)
);
ALTER TABLE info_abe MODIFY comanda VARCHAR2(4000);
ALTER TABLE info_abe MODIFY eroare VARCHAR2(500);
DESCRIBE INFO_ABE;

--EXERCITIUL E2
CREATE OR REPLACE FUNCTION f2_abe 
(v_nume employees.last_name%TYPE DEFAULT 'Bell') 
RETURN NUMBER IS
    salariu employees.salary%TYPE;
    TYPE t_text_proc           IS TABLE OF VARCHAR2(1000);
    nume_user       VARCHAR2(128);
    tabl_text_proc         t_text_proc;
    text_proc              VARCHAR2(4000);
    v_comanda         VARCHAR2(4000) := '';
    numar               NUMBER;
BEGIN
    SELECT salary INTO salariu
    FROM employees WHERE last_name = v_nume;
    
    numar := SQL%ROWCOUNT;
    
    SELECT user INTO nume_user FROM DUAL;
    SELECT text BULK COLLECT INTO tabl_text_proc FROM user_source WHERE name = upper('f2_abe');
    FOR i IN tabl_text_proc.FIRST..tabl_text_proc.LAST LOOP
        text_proc := CONCAT(text_proc, tabl_text_proc(i));
    END LOOP;
    SELECT SUBSTR(text_proc, INSTR(text_proc, 'SELECT'), 
        INSTR(text_proc, '=', INSTR(text_proc, 'SELECT')) - INSTR(text_proc, 'SELECT')) INTO v_comanda FROM dual;
    v_comanda := CONCAT(v_comanda, ' = ') || v_nume;
    
    
    -- cazul fara erori
    INSERT INTO info_abe(utilizator, data_comanda, comanda, nr_linii, eroare) 
            VALUES(nume_user, SYSDATE, v_comanda, numar, 'Status ok');
    
    RETURN salariu;
    
EXCEPTION
    
    WHEN no_data_found THEN
        numar := SQL%ROWCOUNT;
        SELECT user INTO nume_user FROM DUAL;
        SELECT text BULK COLLECT INTO tabl_text_proc FROM user_source WHERE name = upper('f2_abe');
        FOR i IN tabl_text_proc.FIRST..tabl_text_proc.LAST LOOP
            text_proc := CONCAT(text_proc, tabl_text_proc(i));
        END LOOP;
        SELECT SUBSTR(text_proc, INSTR(text_proc, 'SELECT'), 
            INSTR(text_proc, '=', INSTR(text_proc, 'SELECT')) - INSTR(text_proc, 'SELECT')) INTO v_comanda FROM dual;
        v_comanda := CONCAT(v_comanda, ' = ') || v_nume;
        INSERT INTO info_abe(utilizator, data_comanda, comanda, nr_linii, eroare) 
            VALUES(nume_user, SYSDATE, v_comanda, numar, 'Nu sunt angajati cu numele dat');
        DBMS_OUTPUT.PUT_LINE('Nu exista angajati cu numele dat');
        RETURN -1;
        
    WHEN too_many_rows THEN 
        SELECT COUNT(*) INTO numar FROM employees WHERE last_name = v_nume;
        SELECT user INTO nume_user FROM DUAL;
        SELECT text BULK COLLECT INTO tabl_text_proc FROM user_source WHERE name = upper('f2_abe');
        FOR i IN tabl_text_proc.FIRST..tabl_text_proc.LAST LOOP
            text_proc := CONCAT(text_proc, tabl_text_proc(i));
        END LOOP;
        SELECT SUBSTR(text_proc, INSTR(text_proc, 'SELECT'), 
            INSTR(text_proc, '=', INSTR(text_proc, 'SELECT')) - INSTR(text_proc, 'SELECT')) INTO v_comanda FROM dual;
        v_comanda := CONCAT(v_comanda, ' = ') || v_nume;
        INSERT INTO info_abe(utilizator, data_comanda, comanda, nr_linii, eroare) 
            VALUES(nume_user, SYSDATE, v_comanda, numar, 'Exista mai multi angajati cu acelasi nume');
        DBMS_OUTPUT.PUT_LINE('Exista mai multi angajati cu numele dat');
        RETURN -1;
        
    WHEN OTHERS THEN       
        numar := SQL%ROWCOUNT;
        INSERT INTO info_abe(utilizator, data_comanda, comanda, nr_linii, eroare) 
            VALUES(nume_user, SYSDATE, v_comanda, numar, 'Alta eroare...');
        DBMS_OUTPUT.PUT_LINE('Alta eroare!');
        RETURN -1;   
END f2_abe;
/

SELECT last_name FROM employees;
--exemplu apel
BEGIN
    dbms_output.put_line('Salariul este ' || f2_abe('Kimball'));
END;
/


SELECT utilizator, to_char(data_comanda, 'DD-MM-YYYY hh24:mi:ss') AS Data_comanda, 
comanda, nr_linii, eroare 
FROM info_abe;






SELECT jh.employee_id,  e.department_id, d.location_id, l.city, jh.start_date, jh.end_date
    FROM job_history jh JOIN employees e ON jh.employee_id = e.employee_id
                        JOIN departments d ON e.department_id = d.department_id
                        JOIN locations l ON l.location_id = d.location_id;
    --WHERE l.city = 'Seattle';
SELECT * FROM employees;
SELECT * FROM job_history;

            
-- EXERCITIUL E3
CREATE OR REPLACE FUNCTION ang_abe
    (v_oras locations.city%TYPE)
RETURN NUMBER IS
    nr_ang NUMBER;
    nume_oras locations.city%TYPE;
    nume_user VARCHAR2(128);
    nr_linii    NUMBER;
BEGIN
    SELECT user INTO nume_user FROM DUAL;
    SELECT city INTO nume_oras FROM locations WHERE city = INITCAP(v_oras);

    SELECT COUNT(*)
    INTO nr_ang
    FROM 
    (
        SELECT jh.employee_id 
        FROM job_history jh JOIN employees e ON jh.employee_id = e.employee_id
                            JOIN departments d ON e.department_id = d.department_id
                            JOIN locations l ON l.location_id = d.location_id
        WHERE l.city = nume_oras
        GROUP BY jh.employee_id
            HAVING COUNT(DISTINCT jh.job_id) >= 2
    ) tabela;
        
    IF nr_ang = 0 THEN
        INSERT INTO info_abe(utilizator, data_comanda, comanda, nr_linii, eroare)
        VALUES(nume_user, SYSDATE,
        'SELECT COUNT(*)
            INTO nr_ang
            FROM 
            (
                SELECT jh.employee_id 
                FROM job_history jh JOIN employees e ON jh.employee_id = e.employee_id
                                    JOIN departments d ON e.department_id = d.department_id
                                    JOIN locations l ON l.location_id = d.location_id
                WHERE l.city =' || ' ' || INITCAP(v_oras) ||
                'GROUP BY jh.employee_id
                    HAVING COUNT(DISTINCT jh.job_id) >= 2
            ) tabela;',1,'Nu exista angajati care sa respecte conditiile');
    ELSE
        INSERT INTO info_abe(utilizator, data_comanda, comanda, nr_linii, eroare)
        VALUES(nume_user, SYSDATE,
        'SELECT COUNT(*) INTO nr_ang FROM (SELECT jh.employee_id  FROM job_history jh JOIN employees e ON jh.employee_id = e.employee_id' ||
        ' JOIN departments d ON e.department_id = d.department_id JOIN locations l ON l.location_id = d.location_id WHERE l.city =' || ' ' || INITCAP(v_oras) ||
                ' GROUP BY jh.employee_id HAVING COUNT(DISTINCT jh.job_id) >= 2 ) tabela;',
        1,'S-au gasit ' || nr_ang || ' angajati.');
    END IF;
    RETURN nr_ang;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        INSERT INTO info_abe(utilizator, data_comanda, comanda, nr_linii, eroare)
        VALUES(nume_user, SYSDATE, 
                'SELECT city INTO nume_oras FROM locations WHERE city =' || INITCAP(v_oras),
                0,'Nu exista orasul!');
        RETURN 0;
        
END ang_abe;
/

ALTER FUNCTION ang_abe COMPILE;

BEGIN
    dbms_output.put_line('Nr ang este ' || ang_abe('Oxford'));
END;
/

SELECT utilizator, to_char(data_comanda, 'DD-MM-YYYY hh24:mi:ss') AS Data_comanda, 
comanda, nr_linii, eroare FROM info_abe;

SELECT line, position, text
FROM
    user_errors
WHERE name = upper('mareste_salariu_abe');

CREATE TABLE copie_emp AS SELECT * FROM employees;
SELECT * FROM copie_emp;
DROP TABLE copie_emp;

--EXERCITIUL E4
CREATE OR REPLACE PROCEDURE mareste_salariu_abe
    (cod_manager employees.manager_id%TYPE)
IS
    TYPE t_ang IS TABLE OF employees%ROWTYPE;
    TYPE t_coduri_manageri IS TABLE OF employees.manager_id%TYPE;
    subalterni      t_ang    := t_ang();
    salariu         employees.salary%TYPE;
    v_coduri_man    t_coduri_manageri;
    --cod manager curent
    cmc             NUMBER          := 1;
    --numarul curent de manageri
    nr_man          NUMBER;
    nu_exista       EXCEPTION;
    mesaj_info      VARCHAR2(4096) := 'S-a actualizat salariul pentru angajatii:';
    nume_user       VARCHAR2(128);
BEGIN
    --prima data verific pentru codul dat daca exista un manager cu acest cod
    SELECT * BULK COLLECT INTO subalterni
        FROM copie_emp
        WHERE manager_id = cod_manager;
    IF subalterni.count = 0 THEN
        raise nu_exista;
    END IF;
    v_coduri_man := t_coduri_manageri(cod_manager);
    nr_man := v_coduri_man.count;
    --la fiecare iteratie, actualizez salariul subalternilor managerului curent
    --adaug in v_coduri_man codurile subalternilor (care pot fi la randul lor manageri)
    LOOP   
        IF subalterni.count <> 0 THEN
            v_coduri_man.extend(subalterni.count);
            FOR i IN subalterni.first..subalterni.last LOOP
                salariu := subalterni(i).salary;
                salariu := salariu + 0.1 * salariu;
                UPDATE copie_emp
                    SET salary = salariu
                    WHERE employee_id = subalterni(i).employee_id;
                --adaug codurile subalternilor in colectia cu codurile maangerilor
                v_coduri_man(nr_man + i) := subalterni(i).employee_id;
                mesaj_info := mesaj_info || ' ' || subalterni(i).employee_id;
            END LOOP;  
            subalterni.delete;
            nr_man := v_coduri_man.count;
        END IF;
        
        --trec la urmatorul manager
        cmc := cmc + 1;
        SELECT * BULK COLLECT INTO subalterni
            FROM copie_emp
            WHERE manager_id = v_coduri_man(cmc);
        dbms_output.put_line('Managerul curent: ' || cmc || ' Total: ' || nr_man);
        EXIT WHEN cmc = nr_man AND subalterni.count = 0;
    END LOOP;
    
    SELECT user INTO nume_user FROM DUAL;
    INSERT INTO info_abe(utilizator, data_comanda, comanda, nr_linii, eroare) 
    VALUES(nume_user, SYSDATE,
            'UPDATE copie_emp SET salary = salariu WHERE employee_id = subalterni(i).employee_id;',
            nr_man - 1, mesaj_info); 
EXCEPTION
    WHEN nu_exista THEN
        SELECT user INTO nume_user FROM DUAL;
        INSERT INTO info_abe(utilizator, data_comanda, comanda, nr_linii, eroare) 
        VALUES(nume_user, SYSDATE, 
                'SELECT * BULK COLLECT INTO subalterni FROM copie_emp WHERE manager_id = ' || cod_manager,
                0, 'Codul nu este al unui manager');
        --RAISE_APPLICATION_ERROR(-20000, 'Codul introdus nu corespunde cu codul niciunui manager!!');
END mareste_salariu_abe;
/

--101, 300
BEGIN
    mareste_salariu_abe(300);
END;
/
ROLLBACK;

SELECT * FROM info_abe;
SELECT utilizator, to_char(data_comanda, 'DD-MM-YYYY hh24:mi:ss') AS Data_comanda, 
nr_linii, eroare AS mesaj, comanda FROM info_abe;

SELECT employee_id, salary 
FROM copie_emp 
WHERE employee_id IN (101, 108, 109, 110, 111, 112, 113, 200, 203, 204, 205, 206);


--EXERCITIUL E5
CREATE OR REPLACE PROCEDURE ang_pe_zile
IS
    TYPE rec_zile IS RECORD
        (nume      VARCHAR2(100),
         vech      VARCHAR2(15),
         zi        VARCHAR2(10),
         venit     employees.salary%type,
         nr_pe_zi  NUMBER(2));
    TYPE t_zile IS TABLE OF rec_zile;
    TYPE hashmap IS TABLE OF NUMBER(2) INDEX BY VARCHAR2(10);
    v_ang_zi    t_zile  := t_zile();
    nr_zile     hashmap := hashmap();
    CURSOR deps IS
        SELECT department_id, department_name FROM departments;
        
    CURSOR emp_per_day(param_dep departments.department_id%type) IS
        SELECT  first_name || ' ' || last_name AS nume, 
                    FLOOR((SYSDATE - hire_date) / 365) || ' ani ' || FLOOR(MOD(SYSDATE - hire_date, 365) / 30) || ' luni' AS vechime,
                    TO_CHAR(hire_date, 'DAY') AS zi,
                    salary + NVL(0, commission_pct) * salary AS venit,
                    numar_pe_zi.numar
            FROM employees 
            JOIN
                (SELECT TO_CHAR(e2.hire_date, 'DAY') ziua, COUNT(e2.employee_id) AS numar FROM employees e2 
                    WHERE e2.department_id = param_dep  
                    GROUP BY TO_CHAR(e2.hire_date, 'DAY')
                ) numar_pe_zi
            ON TO_CHAR(employees.hire_date, 'DAY') = numar_pe_zi.ziua
            WHERE employees.department_id = param_dep
            ORDER BY numar desc;
            
    cod_dep           departments.department_id%type;
    nume_dep          departments.department_name%type;
    max_ang           NUMBER(2);
    zi_fara_ang       BOOLEAN;
    buf               VARCHAR2(1000);
    
BEGIN
    OPEN deps;
    LOOP
        FETCH deps INTO cod_dep, nume_dep;
        EXIT WHEN deps%NOTFOUND;
        
        OPEN emp_per_day(cod_dep);
        FETCH emp_per_day BULK COLLECT INTO v_ang_zi;
        
        dbms_output.put_line('--------------------------------');
        dbms_output.put_line('Departamentul ' || nume_dep);
        IF v_ang_zi.count = 0 THEN
            dbms_output.put_line('Nu are angajati.');
        ELSE
            max_ang := v_ang_zi(1).nr_pe_zi;
            zi_fara_ang := FALSE;
            --initializare tablou(dictionar) in care tin minte numarul de angajati per zi
            --cheile sunt zilele din saptamana, valorile corespund numarului de angajati
            FOR i IN 0..6 LOOP
                nr_zile(TO_CHAR(SYSDATE + i, 'DAY')) := 0;
            END LOOP;
            
            --initializare buffer (pentru afisarea zilelor in care nu s-au facut angajari)
            buf := 'Zile fara angajari: ';
            
            
            dbms_output.put_line('Ziua cu cele mai multe angajari: ' || v_ang_zi(1).zi);
            FOR i IN 1..v_ang_zi.last LOOP
                --pentru ca ordonez descrecator dupa numarul de angajari per zi,
                --primele max_ang inregistrari din tablou vor fi ale angajatilor
                --care au hire_date in ziua in care s-au facut cele mai multe angajari
                IF i <= max_ang THEN
                    dbms_output.put_line(i || '. ' || v_ang_zi(i).nume ||
                    ' /vechime: ' || v_ang_zi(i).vech || ' /venit: ' || v_ang_zi(i).venit);  
                END IF;
                --actualizez dictionarul
                nr_zile(v_ang_zi(i).zi) := nr_zile(v_ang_zi(i).zi) + 1;
            END LOOP;
            dbms_output.new_line;
            
            FOR i IN 0..6 LOOP
            --verific daca exista cel putin o zi din saptamana in care nu s-au facut angajari
                IF nr_zile(TO_CHAR(SYSDATE + i, 'DAY')) = 0 THEN
                    zi_fara_ang := TRUE;
                    buf := buf || TO_CHAR(SYSDATE + i, 'DAY') || ' ';
                END IF;
            END LOOP;
            --a existat cel putin o zi din saptamana in care nu s-au facut angajari
            IF zi_fara_ang = TRUE THEN
                dbms_output.put_line(buf);
            END IF;
        END IF;     
        CLOSE emp_per_day;
    END LOOP;
    CLOSE deps;
END ang_pe_zile;
/


BEGIN
    ang_pe_zile;
END;
/


SELECT line, position, text
FROM
    user_errors
WHERE name = upper('ang_pe_zile');

SELECT TO_CHAR(hire_date, 'DAY'), COUNT(e2.employee_id) AS numar 
FROM employees e2 
JOIN job_history jh ON e2.department_id = jh.department_id
             WHERE e2.department_id = 110  
             GROUP BY TO_CHAR(hire_date, 'DAY');
SELECT * FROM departments WHERE department_id = 110;         
SELECT TO_CHAR(SYSDATE + 1, 'DAY') FROM DUAL;
SELECT * FROM job_history where department_id = 110;
SELECT * FROM employees where department_id = 110;


SELECT stats.nume, stats.vechime, stats.zi, stats.venit, 
COUNT(*) OVER (PARTITION BY stats.zi) AS numar_pe_zi
FROM(
SELECT  first_name || ' ' || last_name AS nume, 
                    FLOOR((SYSDATE - hire_date) / 365) || ' ani ' || FLOOR(MOD(SYSDATE - hire_date, 365) / 30) || ' luni' AS vechime,
                    TO_CHAR(hire_date, 'DAY') AS zi,
                    salary + NVL(0, commission_pct) * salary AS venit
            FROM employees 
            WHERE employees.department_id = 30
            
UNION ALL
SELECT emp.first_name || ' ' || emp.last_name AS nume, 
        FLOOR((SYSDATE - emp.hire_date) / 365) || ' ani ' || FLOOR(MOD(SYSDATE - emp.hire_date, 365) / 30) || ' luni' AS vechime,
        TO_CHAR(jh.start_date, 'DAY') AS zi,
        emp.salary + NVL(0, emp.commission_pct) * emp.salary AS venit
        
        FROM job_history jh
            JOIN employees emp on emp.employee_id = jh.employee_id
        WHERE jh.department_id = 30    
ORDER BY zi 
) stats
ORDER BY numar_pe_zi DESC, zi;



CREATE OR REPLACE PROCEDURE ang_pe_zile_2
IS
    TYPE rec_zile IS RECORD
        (nume      VARCHAR2(100),
         vech      VARCHAR2(15),
         zi        VARCHAR2(10),
         venit     employees.salary%type,
         nr_pe_zi  NUMBER(2));
    TYPE t_zile IS TABLE OF rec_zile;
    TYPE hashmap IS TABLE OF NUMBER(2) INDEX BY VARCHAR2(10);
    v_ang_zi    t_zile  := t_zile();
    nr_zile     hashmap := hashmap();
    CURSOR deps IS
        SELECT department_id, department_name FROM departments;
        
    CURSOR emp_per_day(param_dep departments.department_id%type) IS
        SELECT stats.nume, stats.vechime, stats.zi, stats.venit, 
            COUNT(*) OVER (PARTITION BY stats.zi) AS numar_pe_zi
            FROM(
            SELECT  first_name || ' ' || last_name AS nume, 
                                FLOOR((SYSDATE - hire_date) / 365) || ' ani ' || FLOOR(MOD(SYSDATE - hire_date, 365) / 30) || ' luni' AS vechime,
                                TO_CHAR(hire_date, 'DAY') AS zi,
                                salary + NVL(0, commission_pct) * salary AS venit
                        FROM employees 
                        WHERE employees.department_id = param_dep             
            UNION
            SELECT emp.first_name || ' ' || emp.last_name AS nume, 
                    FLOOR((SYSDATE - emp.hire_date) / 365) || ' ani ' || FLOOR(MOD(SYSDATE - emp.hire_date, 365) / 30) || ' luni' AS vechime,
                    TO_CHAR(jh.start_date, 'DAY') AS zi,
                    emp.salary + NVL(0, emp.commission_pct) * emp.salary AS venit
                    FROM job_history jh
                        JOIN employees emp on emp.employee_id = jh.employee_id
                    WHERE jh.department_id = param_dep    
            ORDER BY zi
            ) stats
            ORDER BY numar_pe_zi DESC, zi;
            
    cod_dep           departments.department_id%type;
    nume_dep          departments.department_name%type;
    max_ang           NUMBER(2);
    zi_fara_ang       BOOLEAN;
    buf               VARCHAR2(1000);
    
BEGIN
    OPEN deps;
    LOOP
        FETCH deps INTO cod_dep, nume_dep;
        EXIT WHEN deps%NOTFOUND;
        
        OPEN emp_per_day(cod_dep);
        FETCH emp_per_day BULK COLLECT INTO v_ang_zi;
        
        dbms_output.put_line('--------------------------------');
        dbms_output.put_line('Departamentul ' || nume_dep);
        IF v_ang_zi.count = 0 THEN
            dbms_output.put_line('Nu are angajati.');
        ELSE
            max_ang := v_ang_zi(1).nr_pe_zi;
            zi_fara_ang := FALSE;
            --initializare tablou(dictionar) in care tin minte numarul de angajati per zi
            --cheile sunt zilele din saptamana, valorile corespund numarului de angajati
            FOR i IN 0..6 LOOP
                nr_zile(TO_CHAR(SYSDATE + i, 'DAY')) := 0;
            END LOOP;
            
            --initializare buffer (pentru afisarea zilelor in care nu s-au facut angajari)
            buf := 'Zile fara angajari: ';
            
            
            dbms_output.put_line('Ziua cu cele mai multe angajari: ' || v_ang_zi(1).zi);
            FOR i IN 1..v_ang_zi.last LOOP
                --pentru ca ordonez descrecator dupa numarul de angajari per zi,
                --primele max_ang inregistrari din tablou vor fi ale angajatilor
                --care au hire_date in ziua in care s-au facut cele mai multe angajari
                IF i <= max_ang THEN
                    dbms_output.put_line(i || '. ' || v_ang_zi(i).nume ||
                    ' /vechime: ' || v_ang_zi(i).vech || ' /venit: ' || v_ang_zi(i).venit);  
                END IF;
                --actualizez dictionarul
                nr_zile(v_ang_zi(i).zi) := nr_zile(v_ang_zi(i).zi) + 1;
            END LOOP;
            dbms_output.new_line;
            
            FOR i IN 0..6 LOOP
            --verific daca exista cel putin o zi din saptamana in care nu s-au facut angajari
                IF nr_zile(TO_CHAR(SYSDATE + i, 'DAY')) = 0 THEN
                    zi_fara_ang := TRUE;
                    buf := buf || TO_CHAR(SYSDATE + i, 'DAY') || ' ';
                END IF;
            END LOOP;
            --a existat cel putin o zi din saptamana in care nu s-au facut angajari
            IF zi_fara_ang = TRUE THEN
                dbms_output.put_line(buf);
            END IF;
        END IF;     
        CLOSE emp_per_day;
    END LOOP;
    CLOSE deps;
END ang_pe_zile_2;
/

BEGIN
    ang_pe_zile_rank;
END;
/



--E6
CREATE OR REPLACE PROCEDURE ang_pe_zile_rank
IS
    TYPE rec_zile IS RECORD
        (nume           VARCHAR2(100),
         vech           VARCHAR2(15),
         zi             VARCHAR2(10),
         venit          employees.salary%type,
         nr_pe_zi       NUMBER(2),
         zile_vechime   NUMBER(6));
    TYPE t_zile IS TABLE OF rec_zile;
    TYPE hashmap IS TABLE OF NUMBER(2) INDEX BY VARCHAR2(10);
    v_ang_zi    t_zile  := t_zile();
    nr_zile     hashmap := hashmap();
    CURSOR deps IS
        SELECT department_id, department_name FROM departments;
        
    CURSOR emp_per_day(param_dep departments.department_id%type) IS
        SELECT  first_name || ' ' || last_name AS nume, 
                    FLOOR((SYSDATE - hire_date) / 365) || ' ani ' || FLOOR(MOD(SYSDATE - hire_date, 365) / 30) || ' luni' AS vechime,
                    TO_CHAR(hire_date, 'DAY') AS zi,
                    salary + NVL(0, commission_pct) * salary AS venit,
                    numar_pe_zi.numar,
                    SYSDATE - hire_date AS vechime_zile
            FROM employees 
            JOIN
                (SELECT TO_CHAR(e2.hire_date, 'DAY') ziua, COUNT(e2.employee_id) AS numar FROM employees e2 
                    WHERE e2.department_id = param_dep  
                    GROUP BY TO_CHAR(e2.hire_date, 'DAY')
                ) numar_pe_zi
            ON TO_CHAR(employees.hire_date, 'DAY') = numar_pe_zi.ziua
            WHERE employees.department_id = param_dep
            ORDER BY numar desc, vechime_zile desc;
            
    cod_dep           departments.department_id%type;
    nume_dep          departments.department_name%type;
    max_ang           NUMBER(2);
    zi_fara_ang       BOOLEAN;
    buf               VARCHAR2(1000);
    pozitie           NUMBER;
    
BEGIN
    OPEN deps;
    LOOP
        FETCH deps INTO cod_dep, nume_dep;
        EXIT WHEN deps%NOTFOUND;        
        OPEN emp_per_day(cod_dep);
        FETCH emp_per_day BULK COLLECT INTO v_ang_zi;      
        dbms_output.put_line('--------------------------------');
        dbms_output.put_line('Departamentul ' || nume_dep);
        IF v_ang_zi.count = 0 THEN
            dbms_output.put_line('Nu are angajati.');
        ELSE
            max_ang := v_ang_zi(1).nr_pe_zi;
            zi_fara_ang := FALSE;
            pozitie := 1;
            FOR i IN 0..6 LOOP
                nr_zile(TO_CHAR(SYSDATE + i, 'DAY')) := 0;
            END LOOP;
            buf := 'Zile fara angajari: ';
            dbms_output.put_line('Ziua cu cele mai multe angajari: ' || v_ang_zi(1).zi);
            dbms_output.put_line('POZITIA: ' || pozitie);
            dbms_output.put_line(v_ang_zi(1).nume || ' -> ' || v_ang_zi(1).zile_vechime || ' zile'); 
            FOR i IN 2..v_ang_zi.last LOOP
                IF i <= max_ang THEN
                    IF v_ang_zi(i).zile_vechime <> v_ang_zi(i - 1).zile_vechime THEN
                        pozitie := pozitie + 1;
                        dbms_output.put_line('POZITIA: ' || pozitie);
                    END IF;
                    dbms_output.put_line(v_ang_zi(i).nume || ' -> ' || v_ang_zi(i).zile_vechime || ' zile'); 
                END IF;
                nr_zile(v_ang_zi(i).zi) := nr_zile(v_ang_zi(i).zi) + 1;
            END LOOP;
            dbms_output.new_line;           
            FOR i IN 0..6 LOOP
                IF nr_zile(TO_CHAR(SYSDATE + i, 'DAY')) = 0 THEN
                    zi_fara_ang := TRUE;
                    buf := buf || TO_CHAR(SYSDATE + i, 'DAY') || ' ';
                END IF;
            END LOOP;
            IF zi_fara_ang = TRUE THEN
                dbms_output.put_line(buf);
            END IF;
        END IF;     
        CLOSE emp_per_day;
    END LOOP;
    CLOSE deps;
END ang_pe_zile_rank;
/



--CURSOR emp_per_day(param_dep departments.department_id%type) IS
        SELECT  first_name || ' ' || last_name AS nume, 
                    FLOOR((SYSDATE - hire_date) / 365) || ' ani ' || FLOOR(MOD(SYSDATE - hire_date, 365) / 30) || ' luni' AS vechime,
                    TO_CHAR(hire_date, 'DAY') AS zi,
                    salary + NVL(0, commission_pct) * salary AS venit,
                    numar_pe_zi.numar
            FROM employees 
            JOIN
                (SELECT TO_CHAR(e2.hire_date, 'DAY') ziua, COUNT(e2.employee_id) AS numar FROM employees e2 
                    WHERE e2.department_id = 30  
                    GROUP BY TO_CHAR(e2.hire_date, 'DAY')
                ) numar_pe_zi
            ON TO_CHAR(employees.hire_date, 'DAY') = numar_pe_zi.ziua
            WHERE employees.department_id = 30
            ORDER BY numar desc, zi;
            
        SELECT * FROM departments d JOIN employees e ON d.department_id = e.department_id ORDER BY d.department_id;
            
            
            

