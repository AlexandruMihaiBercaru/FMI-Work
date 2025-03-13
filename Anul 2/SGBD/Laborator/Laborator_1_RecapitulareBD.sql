SELECT * FROM employees;
SELECT COUNT(manager_id) FROM employees;

CREATE TABLE angajati_abe (
employee_id number(4) PRIMARY KEY, 
first_name varchar2(20), 
last_name varchar2(20), 
department_id number(4)
)

CREATE TABLE emp_abe AS
(SELECT * FROM employees);
SELECT * FROM emp_abe;


--ex. 11
--Ad?uga?i un comentariu tabelei emp_***.
COMMENT ON TABLE emp_abe IS 'Informatii despre angajati';
COMMENT ON COLUMN emp_abe.salary IS 'Salariul angajatilor';


--ex. 12
--Folosind vizualizarea user_tab_comments afi?a?i comentariul ad?ugat tabelului emp_***.
SELECT * FROM user_tab_comments WHERE TABLE_NAME LIKE 'EMP_ABE';
SELECT * FROM user_col_comments WHERE TABLE_NAME LIKE 'DEP_ABE';

CREATE TABLE dep_abe AS
SELECT * FROM departments;
truncate table dep_abe;
select * from dep_abe;


--ex. 13
--Modifica?i formatul datei calendaristice setat la nivel de sesiune astfel încât datele calendaristice 
--s? respecte urm?toarea form?: 01.10.2011 16:10:05.
ALTER SESSION SET NLS_DATE_FORMAT = 'DD.MM.YYYY HH24:MI:SS';


--ex. 14
--Rulati cererea SQL:
SELECT EXTRACT(YEAR FROM SYSDATE)
FROM dual;



--ex. 15
--Modifica?i cererea anterioar? astfel încât s? ob?ine?i ziua, respectiv luna datei curente.
SELECT EXTRACT(DAY FROM SYSDATE) || '.' || EXTRACT(MONTH FROM SYSDATE)
FROM dual;


--ex. 16
--Afi?a?i numele tuturor tabelelor personale create (nume_tabel_***) 
--Indica?ie: Folositi vizualizarea user_tables
SELECT table_name FROM user_tables where upper(table_name) like '%ABE';


--ex. 17
--Genera?i automat un script SQL care s? con?in? comenzi de ?tergere 
--a tuturor tabelelor personale create.
SPOOL sterge_tabele_2.sql
SELECT 'DROP TABLE ' || table_name || ';' FROM USER_TABLES WHERE UPPER(table_name) LIKE '%ABE';
SPOOL OFF;



--ex. 20
SET FEEDBACK OFF
SET PAGESIZE 0
SPOOL sterg_tabele.sql
SELECT 'DROP TABLE ' || table_name || ';' FROM USER_TABLES WHERE UPPER(table_name) LIKE '%ABE';
SPOOL OFF;


--ex. 23
--Folosind tabelul departments genera?i automat script-ul SQL
--de inserare a înregistr?rilor în acest tabel.

SPOOL inserare_dept.sql
SELECT 'INSERT INTO DEP_ABE(DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID) VALUES ('
|| department_id || ', ' || CONCAT(CONCAT('_', department_name), '_') || ', ' || COALESCE(manager_id, 0) || ', ' || location_id || ');' 
FROM departments;
SPOOL OFF;

select * from departments;
