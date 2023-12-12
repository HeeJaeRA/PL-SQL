SET SERVEROUTPUT ON

-- RECORD
DECLARE
    TYPE info_rec_type IS RECORD(
    no      NUMBER NOT NULL := 1,
    name    VARCHAR2(1000) := 'No Name',
    birth   DATE
    );
    user_info info_rec_type;
BEGIN
    DBMS_OUTPUT.PUT_LINE(user_info.no || '. ' || user_info.name);
    user_info.birth := SYSDATE;
    DBMS_OUTPUT.PUT_LINE(user_info.birth);
END;
/

DECLARE
    emp_info_rec employees%ROWTYPE;
BEGIN
    SELECT *
    INTO emp_info_rec
    FROM employees
    WHERE employee_id = &사원번호;
    
    DBMS_OUTPUT.PUT_LINE(emp_info_rec.employee_id);
    DBMS_OUTPUT.PUT_LINE(emp_info_rec.last_name);
    DBMS_OUTPUT.PUT_LINE(emp_info_rec.job_id);
END;
/

DECLARE
    TYPE emp_rec_type IS RECORD (
    eid         employees.employee_id%TYPE,
    ename       employees.last_name%TYPE,
    deptname    departments.department_name%TYPE
    );
    emp_rec emp_rec_type;
BEGIN
    SELECT e.employee_id, e.last_name, d.department_name
    INTO emp_rec
    FROM employees e JOIN departments d ON e.department_id = d.department_id
    WHERE employee_id = &사원번호;
    
    DBMS_OUTPUT.PUT_LINE(emp_rec.eid);
    DBMS_OUTPUT.PUT_LINE(emp_rec.ename);
    DBMS_OUTPUT.PUT_LINE(emp_rec.deptname);
END;
/

DECLARE
    TYPE num_table_type IS TABLE OF NUMBER
        INDEX BY BINARY_INTEGER;
    num_table num_table_type;
BEGIN
    num_table(-1) := 1;
    num_table(100) := 2;
    num_table(9999) := 3;
    
    DBMS_OUTPUT.PUT_LINE(num_table.COUNT);
    DBMS_OUTPUT.PUT_LINE(num_table(100));
END;
/


DECLARE
    TYPE num_table_type IS TABLE OF NUMBER
        INDEX BY BINARY_INTEGER;
    num_table num_table_type;
    emp_rec employees%ROWTYPE;
BEGIN
    FOR i IN 1 .. 9 LOOP
        num_table(i) := 2 * 1;
    END LOOP;
    
    FOR idx IN num_table.FIRST .. num_table.LAST LOOP
        IF num_table.EXISTS(idx) THEN
            DBMS_OUTPUT.PUT_LINE(num_table(idx));
        END IF;
    END LOOP;
END;
/

DECLARE
    TYPE emp_table_type IS TABLE OF employees%ROWTYPE
         INDEX BY BINARY_INTEGER;
    emp_table emp_table_type;
    emp_rec employees%ROWTYPE;
BEGIN
    FOR eid IN 100 .. 110 LOOP
        SELECT *
        INTO emp_rec
        FROM employees
        WHERE employee_id = eid;
        
        emp_table(eid) := emp_rec;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(emp_table(100).employee_id);
    DBMS_OUTPUT.PUT_LINE(emp_table(100).last_name);
END;
/

-- 전체 사원정보 저장 RECORD
DECLARE
    v_min employees.employee_id%TYPE; -- 최소 사원번호
    v_MAX employees.employee_id%TYPE; -- 최대 사원번호
    v_result NUMBER(1,0);             -- 사원의 존재유무를 확인
    emp_record employees%ROWTYPE;     -- Employees 테이블의 한 행에 대응
    
    TYPE emp_table_type IS TABLE OF emp_record%TYPE
        INDEX BY PLS_INTEGER;
    
    emp_table emp_table_type;
BEGIN
    -- 최소 사원번호, 최대 사원번호
    SELECT MIN(employee_id), MAX(employee_id)
    INTO v_min, v_max
    FROM employees;
    
    FOR eid IN v_min .. v_max LOOP
        SELECT COUNT(*)
        INTO v_result
        FROM employees
        WHERE employee_id = eid;
        
        IF v_result = 0 THEN
            CONTINUE;
        END IF;
        
        SELECT *
        INTO emp_record
        FROM employees
        WHERE employee_id = eid;
        
        emp_table(eid) := emp_record;     
    END LOOP;
    
    FOR eid IN emp_table.FIRST .. emp_table.LAST LOOP
        IF emp_table.EXISTS(eid) THEN
            DBMS_OUTPUT.PUT(emp_table(eid).employee_id || ', ');
            DBMS_OUTPUT.PUT_LINE(emp_table(eid).last_name);
        END IF;
    END LOOP;    
END;
/