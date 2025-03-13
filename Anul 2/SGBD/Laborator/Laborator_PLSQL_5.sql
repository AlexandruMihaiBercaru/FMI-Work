CREATE SEQUENCE seq_pk_emp 
INCREMENT BY 1
START WITH 207
MAXVALUE 999999
NOCYCLE NOCACHE;

DESCRIBE EMPLOYEES;
--EXERCITIUL E1

CREATE OR REPLACE PACKAGE pachet_hr AS
    PROCEDURE add_employee
    (   prenume employees.first_name%type,
        nume employees.last_name%type,
        telefon employees.phone_number%type,
        v_email employees.email%type,
        prenume_manager employees.first_name%type,
        nume_manager employees.last_name%type,
        nume_dep departments.department_name%type,
        nume_job jobs.job_title%type
    );
    FUNCTION get_manager(prenume_man employees.first_name%type, nume_man employees.last_name%type)
        RETURN NUMBER;
    FUNCTION get_dep(nume_dep departments.department_name%type)
        RETURN NUMBER;
    FUNCTION get_job(nume_job jobs.job_title%type)
        RETURN NUMBER;
    FUNCTION get_salary(cod_dept departments.department_id%type, cod_job jobs.job_id%type)
        RETURN NUMBER;
    
END pachet_hr;
/

CREATE OR REPLACE PACKAGE BODY pachet_hr AS

    FUNCTION get_manager( prenume_man employees.first_name%type, 
                          nume_man employees.last_name%type)
        RETURN NUMBER
    IS cod_manager employees.employee_id%type;
    BEGIN
        SELECT employee_id INTO cod_manager 
        FROM employees WHERE first_name = INITCAP(prenume_man) AND last_name = INITCAP(nume_man);
        RETURN cod_manager;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            raise_application_error(-20000, 'Nu exista manageri cu numele dat!');
    END get_manager;
    
    
    FUNCTION get_dep(nume_dep departments.department_name%type)
        RETURN NUMBER
    IS cod_dept departments.department_id%type;
    BEGIN
        SELECT department_id INTO cod_dept FROM departments WHERE department_name = nume_dep;
        RETURN cod_dept;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            raise_application_error(-20000, 'Nu exista departament cu numele dat!');
    END get_dep;
    
    
    FUNCTION get_job(nume_job jobs.job_title%type)
        RETURN jobs.job_id%type
    IS cod_job jobs.job_id%type;
    BEGIN
        SELECT job_id INTO cod_job FROM jobs WHERE job_title = nume_job;
        RETURN cod_job;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            raise_application_error(-20000, 'Nu exista job cu numele dat!');
    END get_job;
    
    
    FUNCTION get_salary(cod_dept departments.department_id%type, cod_job jobs.job_id%type)
        RETURN NUMBER
    IS salariu     employees.salary%type;
    BEGIN     
        SELECT MIN(salary) INTO salariu 
            FROM employees
            WHERE department_id = cod_dept AND job_id = cod_job;
        RETURN salariu;         
    END get_salary;
    
    
    PROCEDURE add_employee
    (   prenume employees.first_name%type,
        nume employees.last_name%type,
        telefon employees.phone_number%type,
        v_email employees.email%type,
        prenume_manager employees.first_name%type,
        nume_manager employees.last_name%type,
        nume_dep departments.department_name%type,
        nume_job jobs.job_title%type
    )
    AS
        v_cod_man       employees.manager_id%type;
        v_cod_dept      departments.department_id%type;
        v_cod_job       jobs.job_id%type;
        v_salariu       employees.salary%type;
    BEGIN
        v_cod_man := pachet_hr.get_manager(prenume_manager, nume_manager);
        v_cod_dept := pachet_hr.get_dep(nume_dep);
        v_cod_job := pachet_hr.get_job(nume_job);
        v_salariu := pachet_hr.get_salary(v_cod_dept, v_cod_job);
        
        INSERT INTO employees(employee_id, first_name, last_name, email, phone_number, hire_date, 
        job_id, salary, commission_pct, manager_id, department_id)
        VALUES
        (seq_pk_emp.nextval, prenume, nume, v_email, telefon, SYSDATE, v_cod_job, v_salariu, null, v_cod_man, v_cod_dept);  
    END add_employee;
END pachet_hr;
/   
    
    
DESCRIBE EMPLOYEES;
BEGIN
    pachet_hr.add_employee('Saul', 'Goodman', 'SGOODMAN', '650.123.5234', 'Nancy', 'Greenberg', 'Finance', 'Accountant');
END;
/
    
DROP PACKAGE pachet_hr;
    
SELECT * FROM jobs;
SELECT * FROM employees;
SELECT * FROM departments;