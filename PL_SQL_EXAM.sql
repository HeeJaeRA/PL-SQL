SET SERVEROUTPUT ON

-- 2번
DECLARE
    v_num employees.employee_id%TYPE := &사원번호;
    v_dname departments.department_name%TYPE;
    v_jid employees.job_id%TYPE;
    v_sal   employees.salary%TYPE;
    v_annual v_sal%TYPE;
BEGIN
    SELECT d.department_name, e.job_id, NVL(salary, 0), (NVL(salary, 0) + (NVL(salary, 0) * NVL(commission_pct, 0))) * 12
    INTO v_dname, v_jid, v_sal, v_annual
    FROM employees e JOIN departments d ON e.department_id = d.department_id
    WHERE employee_id = v_num;
    
    DBMS_OUTPUT.PUT_LINE('부서 이름: ' || v_dname || ' job_id: ' || v_jid || ' 급여: ' || v_sal || ' 연간 총수입: ' || v_annual);
END;
/

-- 3번
DECLARE
    v_hyear CHAR(2 char);
BEGIN
    SELECT SUBSTR(TO_CHAR(hire_date), 0, 2)
    INTO v_hyear
    FROM employees
    WHERE employee_id = &사원번호;
    
    IF v_hyear > '15' THEN
        DBMS_OUTPUT.PUT_LINE('New employee');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Career employee');
    END IF;
END;
/

-- 4번
BEGIN
    FOR i IN 1 .. 9 LOOP
        FOR j IN 1 .. 9 LOOP
            IF MOD(j, 2) <> 0 THEN
                DBMS_OUTPUT.PUT(j || ' X ' || i || ' = ' || LPAD(i * j, 2) || '    ');
            END IF;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

-- 5번
DECLARE
    CURSOR emp_dept_cursor IS
        SELECT employee_id, last_name, salary
        FROM employees
        WHERE department_id = &부서번호;
        
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_sal employees.salary%TYPE;
BEGIN
    OPEN emp_dept_cursor;
    
    LOOP
        FETCH emp_dept_cursor INTO v_eid, v_ename, v_sal;
        EXIT WHEN emp_dept_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('사번: ' || v_eid || ' 이름: ' || v_ename || ' 급여 : ' || v_sal);
    END LOOP;
    
    CLOSE emp_dept_cursor;
END;
/

-- 6번
CREATE OR REPLACE PROCEDURE sal_update
(v_eid IN NUMBER,
 v_rate IN NUMBER)
IS
    v_emp_no NUMBER;
    v_increase NUMBER;
    e_no_deptno EXCEPTION;
BEGIN
    v_emp_no := v_eid;
    v_increase := v_rate;
    
    UPDATE employees
    SET salary = salary + (salary * v_increase / 100)
    WHERE employee_id = v_emp_no;
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_no_deptno;
    END IF;
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('사원 번호 ' || v_emp_no || '번 급여 ' || v_increase || '% 인상');
EXCEPTION
    WHEN e_no_deptno THEN
        DBMS_OUTPUT.PUT_LINE('No search employee!!');
END;
/

-- 7번
CREATE OR REPLACE PROCEDURE y_jumin
(v_human_no IN VARCHAR2)
IS
    v_gender CHAR(1);
    v_date VARCHAR2(10);
    v_year v_date%TYPE;
    v_age NUMBER;
BEGIN
    v_gender := SUBSTR(v_human_no, 7, 1);
    IF v_gender IN ('1', '3') THEN
        DBMS_OUTPUT.PUT_LINE('남자');
    ELSIF v_gender IN ('2', '4') THEN
        DBMS_OUTPUT.PUT_LINE('여자');
    END IF;
    
    IF v_gender IN ('1', '2') THEN
        v_date := '19'||SUBSTR(v_human_no, 1, 2);
        v_year := '20'||TO_CHAR(SYSDATE, 'YY');
    ELSIF v_gender IN ('3', '4') THEN
        v_date := '20'||SUBSTR(v_human_no, 1, 2);
        v_year := '20'||TO_CHAR(SYSDATE, 'YY');
    END IF;
    v_age := v_year - v_date;
    DBMS_OUTPUT.PUT_LINE('만 나이: ' || v_age);
END;
/
EXEC y_jumin('0211023234567');

-- 8번
CREATE OR REPLACE FUNCTION y_hyear
(p_n NUMBER)
RETURN VARCHAR2
IS
    v_hdate employees.hire_date%TYPE;
BEGIN
    SELECT hire_date
    INTO v_hdate
    FROM employees
    WHERE employee_id = p_n; 
    
    RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, v_hdate) / 12) || '년';
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '입력한 사원번호는 존재하지 않습니다.';
END;
/
EXECUTE DBMS_OUTPUT.PUT_LINE(y_hyear(100));

-- 9번
CREATE OR REPLACE FUNCTION y_dept
(p_dname departments.department_name%TYPE)
RETURN VARCHAR2
IS
    v_name employees.last_name%TYPE;
    e_no_deptno EXCEPTION;
BEGIN
    SELECT last_name
    INTO v_name
    FROM employees
    WHERE employee_id = (SELECT manager_id FROM departments WHERE department_name = p_dname);

    IF v_name IS NULL THEN
        RAISE e_no_deptno;
    END IF;
    
    RETURN v_name;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '해당 부서가 존재하지 않습니다.';
    WHEN e_no_deptno THEN
        RETURN '해당 부서의 책임자가 존재하지 않습니다.';
END;
/
EXECUTE DBMS_OUTPUT.PUT_LINE(y_dept('Finance'));

-- 10번
SELECT name, text
FROM all_source
WHERE OWNER = 'HR'
AND type IN ('PROCEDURE', 'FUCTION', 'PACKAGE', 'PACKAGE BODY');

-- 11번
DECLARE
    v_num NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(RPAD(LPAD('-', 10 - v_num, '-'), 10, '*'));
        v_num := v_num + 1;
        EXIT WHEN v_num > 10;
    END LOOP;
END;