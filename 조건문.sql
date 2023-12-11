SET SERVEROUTPUT ON

BEGIN
    DELETE FROM employees
    WHERE  employee_id = &사원번호;
    
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('정상적으로 실행되지 않았습니다.');
        DBMS_OUTPUT.PUT_LINE('없는 사원번호입니다.');
    END IF;
END;
/

DECLARE
    v_count NUMBER;
    eid employees.employee_id%TYPE;
BEGIN
    SELECT COUNT(employee_id)
    INTO v_count
    FROM employees
    WHERE manager_id = &eid;
    
    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('일반 사원입니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('파트장입니다.');
    END IF;
END;
/

DECLARE
    v_hdate NUMBER;
BEGIN
    SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date)/12)
    INTO v_hdate
    FROM employees
    WHERE employee_id = &사원번호;
    
    IF v_hdate < 5 THEN -- 5년 미만
        DBMS_OUTPUT.PUT_LINE('입사한지 5년 미만입니다.');
        DBMS_OUTPUT.PUT_LINE('근속 ' || v_hdate || '년');
    ELSIF v_hdate < 10 THEN -- 5년 이상 10년 미만
        DBMS_OUTPUT.PUT_LINE('입사한지 10년 미만입니다.');
        DBMS_OUTPUT.PUT_LINE('근속 ' || v_hdate || '년');
    ELSIF v_hdate < 15 THEN -- 10년 이상 15년 미만
        DBMS_OUTPUT.PUT_LINE('입사한지 15년 미만입니다.');
        DBMS_OUTPUT.PUT_LINE('근속 ' || v_hdate || '년');
    ELSIF v_hdate < 20 THEN -- 15년 이상 20년 미만
        DBMS_OUTPUT.PUT_LINE('입사한지 20년 미만입니다.');
        DBMS_OUTPUT.PUT_LINE('근속 ' || v_hdate || '년');
    ELSE
        DBMS_OUTPUT.PUT_LINE('회사에 뼈를 묻었습니다.'); 
        DBMS_OUTPUT.PUT_LINE('근속 ' || v_hdate || '년');
    END IF;
END;
/

-- 입사년도 05년을 기준으로 분류
DECLARE
    v_hyear CHAR(2 char);
BEGIN
    -- SELECT TO_CHAR(hire_date, 'yyyy')
    SELECT SUBSTR(TO_CHAR(hire_date), 0, 2)
    INTO v_hyear
    FROM employees
    WHERE employee_id = &사원번호;
    
    IF v_hyear >= '05' THEN
        DBMS_OUTPUT.PUT_LINE('New employee');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Career employee');
    END IF;
END;
/

-- DBMS_OUTPUT.PUT_LINE() 한번만 사용
DECLARE
    v_hyear CHAR(2 char);
    v_str   VARCHAR2(10) := 'career employee';
BEGIN
    -- SELECT TO_CHAR(hire_date, 'yyyy')
    SELECT SUBSTR(TO_CHAR(hire_date), 0, 2)
    INTO v_hyear
    FROM employees
    WHERE employee_id = &사원번호;
    
    IF v_hyear >= '05' THEN
        v_str := 'new employee';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(v_str);
END;
/

-- 급여 구간별 인상 급여 구하기
DECLARE
    v_ename employees.last_name%TYPE;
    v_sal employees.salary%TYPE;
    v_newsal v_sal%TYPE;
BEGIN
    SELECT last_name, salary
    INTO v_ename, v_sal
    FROM employees
    WHERE employee_id = &사원번호;
    /*
    IF v_sal <= 5000 THEN
        v_newsal := 20;
    ELSIF v_sal <= 10000 THEN
        v_newsal := 15;
    ELSIF v_sal <= 15000 THEN
        v_newsal := 10;
    ELSE
        v_newsal := 0;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('인상급여: ' || v_sal * (1 + v_newsal/100));
    */
    IF v_sal <= 5000 THEN
        v_newsal := v_sal * 1.2;
    ELSIF v_sal <= 10000 THEN
        v_newsal := v_sal * 1.15;
    ELSIF v_sal <= 15000 THEN
        v_newsal := v_sal * 1.1;
    ELSE
        v_newsal := v_sal;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('사원이름: ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('급여: ' || v_sal);
    DBMS_OUTPUT.PUT_LINE('인상급여: ' || v_newsal);
END;
/