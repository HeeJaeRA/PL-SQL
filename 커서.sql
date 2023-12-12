SET SERVEROUTPUT ON

-- CURSOR
DECLARE
    CURSOR emp_dept_cursor IS
        SELECT employee_id, last_name
        FROM employees
        WHERE department_id = &부서번호;
        
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
BEGIN
    OPEN emp_dept_cursor;
    
    LOOP
    FETCH emp_dept_cursor INTO v_eid, v_ename;
    EXIT WHEN emp_dept_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_eid);
    DBMS_OUTPUT.PUT_LINE(v_ename);
    END LOOP;
    CLOSE emp_dept_cursor;
END;
/
