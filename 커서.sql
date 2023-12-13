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

DECLARE
    CURSOR emp_info_cursor IS
        SELECT employee_id, last_name, hire_date hdate
        FROM employees
        WHERE department_id = &부서번호
        ORDER BY hire_date DESC;
    
    emp_rec emp_info_cursor%ROWTYPE;
BEGIN
    OPEN emp_info_cursor;

    LOOP
        FETCH emp_info_cursor INTO emp_rec;
        EXIT WHEN emp_info_cursor%NOTFOUND;
        --EXIT WHEN emp_info_cursor%ROWCOUNT > 10 OR emp_info_cursor%NOTFOUND;
    
        DBMS_OUTPUT.PUT_LINE(emp_info_cursor%ROWCOUNT);
        DBMS_OUTPUT.PUT(emp_rec.employee_id || ', ');
        DBMS_OUTPUT.PUT(emp_rec.last_name || ', ');
        DBMS_OUTPUT.PUT_LINE(emp_rec.hdate);
    END LOOP;
    
    IF emp_info_cursor%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('데이터 없음');
    END IF;
    
    CLOSE emp_info_cursor;
END;
/

-- 사원 정보 출력
DECLARE
    CURSOR emp_info_cursor IS
        SELECT e.employee_id, e.last_name, d.department_name
        FROM employees e LEFT JOIN departments d ON e.department_id = d.department_id;
        
    emp_rec emp_info_cursor%ROWTYPE;
BEGIN
    OPEN emp_info_cursor;
    
    LOOP
        FETCH emp_info_cursor INTO emp_rec;
        EXIT WHEN emp_info_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(emp_info_cursor%ROWCOUNT || ': ' || emp_rec.employee_id || ', ' || emp_rec.last_name || ', ' || emp_rec.department_name);
    END LOOP;
    
    CLOSE emp_info_cursor;
END;
/

-- 연봉 출력
DECLARE
    CURSOR emp_cursor IS
        SELECT last_name, salary, salary * 12 + ( NVL(salary, 0) * NVL(commission_pct, 0) * 12 ) AS annual
        FROM employees
        WHERE department_id IN (50, 80);
        
    emp_rec emp_cursor%ROWTYPE;
BEGIN
    IF NOT emp_cursor%ISOPEN THEN
        OPEN emp_cursor;
    END IF;
    
    LOOP
        FETCH emp_cursor INTO emp_rec;
        EXIT WHEN emp_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(emp_cursor%ROWCOUNT || ': ' || emp_rec.last_name || ', ' || emp_rec.salary || ', ' || emp_rec.annual);
    END LOOP;
    
    CLOSE emp_cursor;
END;
/

-- CURSOR FOR LOOP
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, job_id
        FROM employees
        WHERE department_id = &부서번호;
BEGIN
    -- 암시적으로 RECORD 선언 & CURSOR OPEN, FETCH, CLOSE 발생
    FOR emp_rec IN emp_cursor LOOP
        DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT || '. ');
        DBMS_OUTPUT.PUT(emp_rec.employee_id || ', ');
        DBMS_OUTPUT.PUT(emp_rec.last_name || ', ');
        DBMS_OUTPUT.PUT_LINE(emp_rec.job_id);
    END LOOP;
END;
/

-- 서브 쿼리 CURSOR
BEGIN
    -- CURSOR 속성은 사용 못함
    FOR emp_rec IN (SELECT employee_id, last_name
                    FROM employees
                    WHERE department_id = &부서번호) LOOP
        DBMS_OUTPUT.PUT(emp_rec.employee_id || ', ');
        DBMS_OUTPUT.PUT_LINE(emp_rec.last_name);
    END LOOP;
END;
/

-- 사원 정보 출력 CURSOR FOR LOOP
DECLARE
    CURSOR emp_info_cursor IS
        SELECT e.employee_id, e.last_name, d.department_name
        FROM employees e LEFT JOIN departments d ON e.department_id = d.department_id;
BEGIN
    FOR emp_rec IN emp_info_cursor LOOP 
        DBMS_OUTPUT.PUT_LINE(emp_info_cursor%ROWCOUNT || '. ' || emp_rec.employee_id || ', ' || emp_rec.last_name || ', ' || emp_rec.department_name);
    END LOOP;
END;
/

-- 연봉 출력 CURSOR FOR LOOP
DECLARE
    CURSOR emp_cursor IS
        SELECT last_name, salary, salary * 12 + ( NVL(salary, 0) * NVL(commission_pct, 0) * 12 ) AS annual
        FROM employees
        WHERE department_id IN (50, 80);
BEGIN
    FOR emp_rec IN emp_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(emp_cursor%ROWCOUNT || '. ' || emp_rec.last_name || ', ' || emp_rec.salary || ', ' || emp_rec.annual);
    END LOOP;
END;
/

-- 매개변수 사용 CURSOR
DECLARE
    CURSOR dep_cursor IS
        SELECT department_id, department_name
        FROM departments;
    
    CURSOR emp_cursor 
        (p_dept_id NUMBER) IS
        SELECT employee_id, last_name, hire_date, job_id
        FROM employees
        WHERE department_id = p_dept_id;
        
    emp_rec emp_cursor%ROWTYPE;
BEGIN
    FOR dep_rec IN dep_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('==== 부서명: ' || dep_rec.department_name);
        OPEN emp_cursor(dep_rec.department_id);
        LOOP
            FETCH emp_cursor INTO emp_rec;
            EXIT WHEN emp_cursor%NOTFOUND;
            
            DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT || '. ');
            DBMS_OUTPUT.PUT_LINE(emp_rec.employee_id || ', ' || emp_rec.last_name || ', ' || emp_rec.hire_date);
        END LOOP;
        IF emp_cursor%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('소속된 사원이 없습니다');
        END IF;
        CLOSE emp_cursor;
    END LOOP;
END;
/

-- FOR IN LOOP 에서 매개변수 사용
DECLARE
    CURSOR emp_cursor 
        (p_dept_id NUMBER) IS
        SELECT employee_id, last_name, hire_date, job_id
        FROM employees
        WHERE department_id = p_dept_id;
BEGIN
    FOR emp_rec IN emp_cursor(60) LOOP
        DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT || '. ');
        DBMS_OUTPUT.PUT_LINE(emp_rec.employee_id || ', ' || emp_rec.last_name || ', ' || emp_rec.hire_date);
    END LOOP;
END;
/

-- FOR OF / WHERE CURRENT OF
DECLARE
    CURSOR emp_cursor IS 
        SELECT salary
        FROM employees
        WHERE department_id = 60
        FOR UPDATE OF salary, commission_pct NOWAIT;
BEGIN
    FOR emp_rec IN emp_cursor LOOP
        UPDATE employees
        SET salary = emp_rec.salary * 1.10
        WHERE CURRENT OF emp_cursor;
    END LOOP;
    COMMIT;
END;
/

