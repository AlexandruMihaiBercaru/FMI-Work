--exercitiul 1: cursor explicit

DECLARE 
    v_nr number(4); 
    v_nume departments.department_name%TYPE; 
    CURSOR c IS 
        SELECT department_name nume, COUNT(employee_id) nr 
        FROM departments d, employees e 
        WHERE d.department_id = e.department_id(+) 
        GROUP BY department_name; 
BEGIN 
    OPEN c; 
    LOOP 
        FETCH c INTO v_nume,v_nr; 
        EXIT WHEN c%NOTFOUND; 
        IF v_nr=0 
            THEN DBMS_OUTPUT.PUT_LINE('In departamentul '|| v_nume|| ' nu lucreaza angajati'); 
            ELSIF v_nr=1 
                THEN DBMS_OUTPUT.PUT_LINE('In departamentul '|| v_nume|| ' lucreaza un angajat'); 
                ELSE DBMS_OUTPUT.PUT_LINE('In departamentul '|| v_nume|| ' lucreaza '|| v_nr||' angajati'); 
        END IF; 
    END LOOP; 
    CLOSE c; 
END;
/

DROP table emp_abe;
CREATE TABLE emp_abe AS SELECT * FROM employees;
DELETE FROM emp_abe WHERE employee_id = 206;
select * from emp_abe;


--Exercitiul 1
--Pentru fiecare job (titlu – care va fi afisat o singura data) obtineti lista angajatilor 
--(nume si salariu) care lucreaza în prezent pe jobul respectiv. 
--Tratati cazul în care nu exista angajati care sa lucreze în prezent pe un anumit job. 
--Rezolvati problema folosind: a. cursoare clasice


--Exercitiul 2
DECLARE
    v_titlu_job     jobs.job_title%TYPE;
    v_id_job        jobs.job_id%TYPE;
    v_nume          VARCHAR2(64);
    v_salariu       employees.salary%TYPE; 
    v_nr_ang        NUMBER;
    v_venit_job   NUMBER;
    v_venit_mediu   NUMBER;
    v_nr_crt        NUMBER;
    total_ang       NUMBER := 0;
    total_venit     NUMBER := 0;
    CURSOR joburi IS
        SELECT job_title, job_id FROM jobs; 
    CURSOR ang_pe_job(param_job jobs.job_id%TYPE) IS
        SELECT e.first_name || ' ' || e.last_name, e.salary, ROWNUM, 
        stats_job.numar, stats_job.total, stats_job.medie
        FROM emp_abe e
        JOIN
        (
            SELECT e2.job_id, COUNT(e2.employee_id) numar, 
                    SUM(salary + NVL(e2.commission_pct, 0) * salary) total, 
                    ROUND(SUM(salary + NVL(e2.commission_pct, 0) * salary)/ COUNT(e2.employee_id), 2) medie
                FROM emp_abe e2
                GROUP BY e2.job_id
        ) stats_job
        ON e.job_id = stats_job.job_id
        WHERE e.job_id = param_job;
BEGIN
    OPEN joburi;
    LOOP
        FETCH joburi INTO v_titlu_job, v_id_job;
        EXIT WHEN joburi%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('--------------------------');
        DBMS_OUTPUT.PUT_LINE('DENUMIRE JOB: ' || v_titlu_job);
        OPEN ang_pe_job(v_id_job);
        LOOP
            FETCH ang_pe_job INTO v_nume, v_salariu, v_nr_crt, v_nr_ang, v_venit_job, v_venit_mediu;
            EXIT WHEN ang_pe_job%NOTFOUND;
            IF v_nr_crt = 1 THEN
                total_ang := total_ang + v_nr_ang;
                total_venit := total_venit + v_venit_job;
                DBMS_OUTPUT.PUT_LINE('--------STATISTICI JOB:--------');
                DBMS_OUTPUT.PUT_LINE('- numar total angajati -> ' || v_nr_ang);
                DBMS_OUTPUT.PUT_LINE('- suma totala venituri -> ' || v_venit_job);
                DBMS_OUTPUT.PUT_LINE('- venitul mediu -> ' || v_venit_mediu);
            END IF;
            DBMS_OUTPUT.PUT_LINE('      ' || v_nr_crt || '. ' || v_nume || ' - salariu: ' || v_salariu);
        END LOOP;
        IF ang_pe_job%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('      Nu exista niciun angajat pe acest job');
        END IF;
        CLOSE ang_pe_job;
        
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('-----------------------------------');
    DBMS_OUTPUT.PUT_LINE('--------STATISTICI COMPANIE:--------');
    DBMS_OUTPUT.PUT_LINE('- numar total angajati -> ' || total_ang);
    DBMS_OUTPUT.PUT_LINE('- suma totala venituri -> ' || total_venit);
    DBMS_OUTPUT.PUT_LINE('- venitul mediu -> ' || ROUND(total_venit / total_ang, 2));
    CLOSE joburi;
END;
/
        

--EXERCITIUL 3
DECLARE
    v_titlu_job     jobs.job_title%TYPE;
    v_id_job        jobs.job_id%TYPE;
    v_nume          VARCHAR2(64);
    v_salariu       employees.salary%TYPE; 
    v_nr_ang        NUMBER;
    v_venit_job   NUMBER;
    v_venit_mediu   NUMBER;
    v_nr_crt        NUMBER;
    total_salarii_comp      NUMBER := 0;
    total_comision_comp     NUMBER := 0;
    procent         NUMBER;
    tot             NUMBER;
    afis_stats      BOOLEAN := FALSE;
    CURSOR joburi IS
        SELECT job_title, job_id FROM jobs; 
    CURSOR ang_pe_job(param_job jobs.job_id%TYPE) IS
        SELECT e.first_name || ' ' || e.last_name, e.salary, ROWNUM, 
        stats_job.numar, stats_job.total, stats_job.medie,  
        (SELECT  SUM(salary) FROM emp_abe) total_sal_comp,
        (SELECT  SUM(NVL(commission_pct, 0) * salary) FROM emp_abe) total_com_comp
        FROM emp_abe e
        JOIN
        (
            SELECT e2.job_id, COUNT(e2.employee_id) numar, 
                    SUM(salary + NVL(e2.commission_pct, 0) * salary) total, 
                    ROUND(SUM(salary + NVL(e2.commission_pct, 0) * salary)/ COUNT(e2.employee_id), 2) medie
                FROM emp_abe e2
                GROUP BY e2.job_id
        ) stats_job
        ON e.job_id = stats_job.job_id
        WHERE e.job_id = param_job;
BEGIN
    OPEN joburi;
    LOOP
        FETCH joburi INTO v_titlu_job, v_id_job;
        EXIT WHEN joburi%NOTFOUND;
        
        OPEN ang_pe_job(v_id_job);
        FETCH ang_pe_job INTO v_nume, v_salariu, v_nr_crt, v_nr_ang, v_venit_job, v_venit_mediu, total_salarii_comp, total_comision_comp;
        IF afis_stats = FALSE THEN
            tot := total_salarii_comp + total_comision_comp;
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('--------STATISTICI COMPANIE:--------');
            DBMS_OUTPUT.PUT_LINE('- total salarii -> ' || total_salarii_comp);
            DBMS_OUTPUT.PUT_LINE('- total comisioane -> ' || total_comision_comp);
            DBMS_OUTPUT.PUT_LINE('- total venituri -> ' || tot);
            afis_stats := TRUE;
        END IF;
        DBMS_OUTPUT.PUT_LINE('--------------------------');
        DBMS_OUTPUT.PUT_LINE('DENUMIRE JOB: ' || v_titlu_job);
        WHILE ang_pe_job%FOUND LOOP
            IF v_nr_crt = 1 THEN
                DBMS_OUTPUT.PUT_LINE('--------STATISTICI JOB:--------');
                DBMS_OUTPUT.PUT_LINE('- numar total angajati -> ' || v_nr_ang);
                DBMS_OUTPUT.PUT_LINE('- suma totala venituri -> ' || v_venit_job);
                DBMS_OUTPUT.PUT_LINE('- venitul mediu -> ' || v_venit_mediu);
            END IF;
            procent := v_salariu / tot * 100;
            DBMS_OUTPUT.PUT_LINE('      ' || v_nr_crt || '. ' || v_nume || ' - salariu: ' || v_salariu || '/ procent: ' || ROUND(procent, 4) || '%');
            FETCH ang_pe_job INTO v_nume, v_salariu, v_nr_crt, v_nr_ang, v_venit_job, v_venit_mediu, total_salarii_comp, total_comision_comp;
        END LOOP;
        IF ang_pe_job%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('      Nu exista niciun angajat pe acest job');
        END IF;
        CLOSE ang_pe_job;       
    END LOOP;
    CLOSE joburi;
END;
/


--EXERCITIUL 4
DECLARE
    v_titlu_job     jobs.job_title%TYPE;
    v_id_job        jobs.job_id%TYPE;
    v_nume          VARCHAR2(64);
    v_salariu       employees.salary%TYPE; 
    v_nr_ang        NUMBER;
    v_venit_job   NUMBER;
    v_venit_mediu   NUMBER;
    v_nr_crt        NUMBER;
    total_salarii_comp      NUMBER := 0;
    total_comision_comp     NUMBER := 0;
    procent         NUMBER;
    tot             NUMBER;
    afis_stats      BOOLEAN := FALSE;
    CURSOR joburi IS
        SELECT job_title, job_id FROM jobs; 
    CURSOR ang_pe_job(param_job jobs.job_id%TYPE) IS
        SELECT e.first_name || ' ' || e.last_name, e.salary, ROWNUM, 
        stats_job.numar, stats_job.total, stats_job.medie,  
        (SELECT  SUM(salary) FROM emp_abe) total_sal_comp,
        (SELECT  SUM(NVL(commission_pct, 0) * salary) FROM emp_abe) total_com_comp
        FROM emp_abe e
        JOIN
        (
            SELECT e2.job_id, COUNT(e2.employee_id) numar, 
                    SUM(salary + NVL(e2.commission_pct, 0) * salary) total, 
                    ROUND(SUM(salary + NVL(e2.commission_pct, 0) * salary)/ COUNT(e2.employee_id), 2) medie
                FROM emp_abe e2
                GROUP BY e2.job_id
        ) stats_job
        ON e.job_id = stats_job.job_id
        WHERE e.job_id = param_job
        ORDER BY e.salary DESC;
BEGIN
    OPEN joburi;
    LOOP
        FETCH joburi INTO v_titlu_job, v_id_job;
        EXIT WHEN joburi%NOTFOUND;
        
        OPEN ang_pe_job(v_id_job);
        FETCH ang_pe_job INTO v_nume, v_salariu, v_nr_crt, v_nr_ang, v_venit_job, v_venit_mediu, total_salarii_comp, total_comision_comp;
        IF afis_stats = FALSE THEN
            tot := total_salarii_comp + total_comision_comp;
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('--------STATISTICI COMPANIE:--------');
            DBMS_OUTPUT.PUT_LINE('- total salarii -> ' || total_salarii_comp);
            DBMS_OUTPUT.PUT_LINE('- total comisioane -> ' || total_comision_comp);
            DBMS_OUTPUT.PUT_LINE('- total venituri -> ' || tot);
            afis_stats := TRUE;
        END IF;
        
        --afisez pentru fiecare job
        DBMS_OUTPUT.PUT_LINE('--------------------------');
        DBMS_OUTPUT.PUT_LINE('DENUMIRE JOB: ' || v_titlu_job);
         
        --afisez doar daca exista cel putin un angajat  
        IF ang_pe_job%FOUND THEN   
            DBMS_OUTPUT.PUT_LINE('--------STATISTICI JOB:--------');
            DBMS_OUTPUT.PUT_LINE('- numar total angajati -> ' || v_nr_ang);
            DBMS_OUTPUT.PUT_LINE('- suma totala venituri -> ' || v_venit_job);
            DBMS_OUTPUT.PUT_LINE('- venitul mediu -> ' || v_venit_mediu);
        END IF;
    
        WHILE ang_pe_job%FOUND AND ang_pe_job%ROWCOUNT <= 5 LOOP   
            procent := v_salariu / tot * 100;
            DBMS_OUTPUT.PUT_LINE('      ' || v_nr_crt || '. ' || v_nume || ' - salariu: ' || v_salariu || '/ procent: ' || ROUND(procent, 4) || '%');
            FETCH ang_pe_job INTO v_nume, v_salariu, v_nr_crt, v_nr_ang, v_venit_job, v_venit_mediu, total_salarii_comp, total_comision_comp;
        END LOOP;
        
        IF ang_pe_job%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('      Nu exista niciun angajat pe acest jobb');
        ELSIF ang_pe_job%ROWCOUNT = 1 THEN
            DBMS_OUTPUT.PUT_LINE('      Exista un singur angajat pe acest job.');
        ELSIF ang_pe_job%ROWCOUNT <= 5 THEN
            DBMS_OUTPUT.PUT_LINE('      Sunt ' || ang_pe_job%ROWCOUNT || ' angajati pe acest job.');
        END IF;
        CLOSE ang_pe_job;       
    END LOOP;
    CLOSE joburi;
END;
/


DECLARE
    v_titlu_job     jobs.job_title%TYPE;
    v_nume          employees.last_name%TYPE;
    v_prenume       employees.first_name%TYPE;
    v_numar_ang     NUMBER(2);
    v_salariu       employees.salary%TYPE; 
    nr_iteratii_job     NUMBER(4) := 0;
    v_linie         NUMBER;
    CURSOR job_cursor IS
        SELECT ROWNUM, j.job_title, e.first_name, e.last_name, e.salary, 
            (SELECT COUNT(e2.first_name)
                FROM emp_abe e2
                FULL OUTER JOIN jobs j2 on e2.job_id = j2.job_id
                WHERE j2.job_id = j.job_id
                GROUP BY j2.job_title)
        FROM jobs j 
        FULL OUTER JOIN emp_abe e ON e.job_id = j.job_id;
BEGIN
    OPEN job_cursor;
    LOOP
        FETCH job_cursor INTO v_linie, v_titlu_job, v_nume, v_prenume, v_salariu, v_numar_ang;
        EXIT WHEN job_cursor%NOTFOUND;
        IF nr_iteratii_job = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Denumire job: ' || v_titlu_job);
        END IF;
        IF v_numar_ang != 0 THEN
            DBMS_OUTPUT.PUT_LINE('      ' || v_linie || '. ' || v_nume || ' ' || v_prenume || ' are salariul ' || v_salariu);
        ELSE
            DBMS_OUTPUT.PUT_LINE('    Nu exista niciun angajat pe acest job');
        END IF;
        nr_iteratii_job := nr_iteratii_job + 1;
        IF nr_iteratii_job >= v_numar_ang THEN
            nr_iteratii_job := 0;
        END IF;
    END LOOP;
    CLOSE job_cursor;     
END;
/

--c. ciclu cursoare cu subcereri
DECLARE
    nr_iteratii_job     NUMBER(4) := 0;
BEGIN
    FOR i IN (SELECT j.job_title titlu, e.first_name nume, e.last_name prenume, e.salary salariu, 
            (SELECT COUNT(e2.first_name) 
                FROM emp_abe e2
                FULL OUTER JOIN jobs j2 on e2.job_id = j2.job_id
                WHERE j2.job_id = j.job_id
                GROUP BY j2.job_title) nr_ang_job
        FROM jobs j 
        FULL OUTER JOIN emp_abe e ON e.job_id = j.job_id)
    LOOP
        IF nr_iteratii_job = 0 THEN 
            DBMS_OUTPUT.PUT_LINE('Denumire job: ' || i.titlu);
        END IF;
        IF i.nr_ang_job != 0 THEN
            DBMS_OUTPUT.PUT_LINE('      ' || i.nume || ' ' || i.prenume || ' are salariul ' || i.salariu);
        ELSE
            DBMS_OUTPUT.PUT_LINE('      Nu exista niciun angajat pe acest job');
            --CONTINUE;
        END IF;
        nr_iteratii_job := nr_iteratii_job + 1;
        IF nr_iteratii_job >= i.nr_ang_job THEN
            nr_iteratii_job := 0;
        END IF;
    END LOOP;
END;
/


      
        
SELECT e.first_name || ' ' || e.last_name, e.salary, ROWNUM, 
        stats_job.numar, stats_job.total, stats_job.medie,  
        (SELECT  SUM(salary + NVL(commission_pct, 0) * salary) FROM emp_abe) total_sal_comp,
        (SELECT  SUM(NVL(commission_pct, 0) * salary) FROM emp_abe) total_com_comp
        FROM emp_abe e
        JOIN
        (
            SELECT e2.job_id, COUNT(e2.employee_id) numar, 
                    SUM(salary + NVL(e2.commission_pct, 0) * salary) total, 
                    ROUND(SUM(salary + NVL(e2.commission_pct, 0) * salary)/ COUNT(e2.employee_id), 2) medie
                FROM emp_abe e2
                GROUP BY e2.job_id
        ) stats_job
        ON e.job_id = stats_job.job_id
        WHERE e.job_id LIKE '%CLERK%';