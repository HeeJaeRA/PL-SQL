SET SERVEROUTPUT ON

DECLARE
    v_eid       NUMBER;
    v_ename     employees.first_name%TYPE;
    v_job       VARCHAR2(1000);
BEGIN
-- SELECT 결과는 반드시 하나만
    SELECT employee_id, first_name, job_id
    INTO v_eid, v_ename, v_job
    FROM employees
    WHERE employee_id = 100;
    
    DBMS_OUTPUT.PUT_LINE('사원 번호: ' || v_eid);
    DBMS_OUTPUT.PUT_LINE('사원 이름: ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('업무: ' || v_job);
END;
/

DECLARE
-- & 치환 변수
    v_eid   employees.employee_id%TYPE := &사원번호;
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT first_name || ', ' || last_name
    INTO v_ename
    FROM employees
    WHERE employee_id = v_eid;

    DBMS_OUTPUT.PUT_LINE('사원 번호: ' || v_eid);
    DBMS_OUTPUT.PUT_LINE('사원 이름: ' || v_ename);
END;
/

DECLARE
    v_deptno    departments.department_id%TYPE;
    v_comn      employees.commission_pct%TYPE := 0.3;
BEGIN
    SELECT department_id
    INTO v_deptno
    FROM employees
    WHERE employee_id = &사원번호;
    
    INSERT INTO employees(employee_id, last_name, email, hire_date, job_id, department_id)
    VALUES (1000, 'Hong', 'hkd@google.com', SYSDATE, 'IT_PROG', v_deptno);
    DBMS_OUTPUT.PUT_LINE('등록 결과: ' || SQL%ROWCOUNT);
    
    UPDATE employees
    SET salary = (NVL(salary, 0) + 10000) * v_comn
    WHERE employee_id = 1000;
    DBMS_OUTPUT.PUT_LINE('실행 결과: ' || SQL%ROWCOUNT);    
END;
/

SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID = 1000;

BEGIN
    DELETE FROM employees
    WHERE employee_id = &사원번호;
    
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('해당 사원은 존재하지 않습니다.');
    END IF;
END;
/

-- 치환 변수로 입력받은 사원의 매니저 번호
DECLARE
    v_eid   employees.employee_id%TYPE := &사원번호;
    v_mid   employees.manager_id%TYPE;
BEGIN
    SELECT manager_id
    INTO v_mid
    FROM employees
    WHERE employee_id = v_eid;
    
    DBMS_OUTPUT.PUT_LINE(v_eid || '의 매니저 사원 번호: ' || v_mid);
END;
/

-- 치환 변수로 입력받은 사원의 번호, 이름, 부서 이름
DECLARE
    v_eid   employees.employee_id%TYPE := &사원번호;
    v_ename employees.last_name%TYPE;
    v_did   employees.department_id%TYPE;
    v_dname departments.department_name%TYPE;
BEGIN
    SELECT employee_id, last_name, department_id
    INTO v_eid, v_ename, v_did
    FROM employees
    WHERE employee_id = v_eid;
    
    SELECT department_name
    INTO v_dname
    FROM departments
    WHERE department_id = v_did;
    
    DBMS_OUTPUT.PUT_LINE('사원번호: ' || v_eid || ' 사원이름: ' || v_ename || ' 부서이름: ' || v_dname);
END;
/
/*
DECLARE
    v_eid   employees.employee_id%TYPE := &사원번호;
    v_ename employees.last_name%TYPE;
    v_dname departments.department_name%TYPE;
BEGIN
    SELECT employee_id, last_name, (SELECT department_name FROM departments WHERE department_id = (SELECT department_id FROM employees WHERE employee_id = v_eid))
    INTO v_eid, v_ename, v_dname
    FROM employees
    WHERE employee_id = v_eid;
    
    DBMS_OUTPUT.PUT_LINE('사원번호: ' || v_eid || ' 사원이름: ' || v_ename || ' 부서이름: ' || v_dname);
END;
/
*/

-- 치환 변수로 입력받은 사원의 이름, 급여, 연봉
DECLARE
    v_ename employees.last_name%TYPE;
    v_sal   employees.salary%TYPE;
    v_annual v_sal%TYPE;
BEGIN
    SELECT last_name, salary, (salary * 12 + ( NVL(salary, 0) * NVL(commission_pct, 0) * 12 ))
    INTO v_ename, v_sal, v_annual
    FROM employees
    WHERE employee_id = &사원번호;
    
    DBMS_OUTPUT.PUT_LINE('사원이름: ' || v_ename || ' 급여: ' || v_sal || ' 연봉: ' || v_annual);
END;
/