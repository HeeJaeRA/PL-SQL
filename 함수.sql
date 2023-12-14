SET SERVEROUTPUT ON

-- Function
CREATE OR REPLACE FUNCTION plus
-- 매개 변수 IN만 가능 
(p_x IN NUMBER,
 p_y NUMBER)
-- RETURN 구문 반드시 필요
RETURN NUMBER
IS
    v_result NUMBER;
BEGIN
    v_result := p_x + p_y;
    RETURN v_result;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
    WHEN TOO_MANY_ROWS THEN
        RETURN -1;
END;
/

-- 블록 내부에서 호출
DECLARE
    v_sum NUMBER;
BEGIN
    v_sum := plus(10, 20);
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/

-- EXECUTE 호출
EXECUTE DBMS_OUTPUT.PUT_LINE(plus(10 ,20));
/

-- SQL문에서 호출
SELECT plus(10, 20) FROM DUAL;

-- 1에서 n까지의 합
CREATE OR REPLACE FUNCTION y_sum
(p_n NUMBER)
RETURN NUMBER
IS
    v_sum NUMBER := 0;
BEGIN
    FOR idx IN 1 .. p_n LOOP
        v_sum := v_sum + idx;
    END LOOP;
    
    RETURN v_sum;
END;
/

EXECUTE DBMS_OUTPUT.PUT_LINE(y_sum(10));

-- 사원 번호 입력시 이름 출력하는 함수
CREATE OR REPLACE FUNCTION y_yedam
(p_n NUMBER)
RETURN VARCHAR2
IS
    v_name VARCHAR2(50);
BEGIN
    SELECT last_name || ' ' || first_name 
    INTO v_name
    FROM employees
    WHERE employee_id = p_n; 
    
    RETURN v_name;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '입력한 사원번호는 존재하지 않습니다.';
END;
/

EXECUTE DBMS_OUTPUT.PUT_LINE(y_yedam(100));

-- 급여 구간별 인상 급여 구하기
CREATE OR REPLACE FUNCTION ydinc
(p_n NUMBER)
RETURN employees.salary%TYPE
IS
    v_ename employees.last_name%TYPE;
    v_sal employees.salary%TYPE;
    v_newsal v_sal%TYPE;
BEGIN
    SELECT last_name, salary
    INTO v_ename, v_sal
    FROM employees
    WHERE employee_id = p_n;

    IF v_sal <= 5000 THEN
        v_newsal := v_sal * 1.2;
    ELSIF v_sal <= 10000 THEN
        v_newsal := v_sal * 1.15;
    ELSIF v_sal <= 15000 THEN
        v_newsal := v_sal * 1.1;
    ELSE
        v_newsal := v_sal;
    END IF;
    
    RETURN (v_newsal);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '입력한 사원번호는 존재하지 않습니다.';
END;
/

EXECUTE DBMS_OUTPUT.PUT_LINE(ydinc(100));

-- 사원 연봉
CREATE OR REPLACE FUNCTION yd_func
(p_n NUMBER)
RETURN employees.salary%TYPE
IS
    v_annual employees.salary%TYPE;
BEGIN
    SELECT (salary + (NVL(salary, 0) * NVL(commission_pct, 0))) * 12
    INTO v_annual
    FROM employees
    WHERE employee_id = p_n;
    
    RETURN v_annual;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '입력한 사원번호는 존재하지 않습니다.';
END;
/

SELECT last_name, salary, YD_FUNC(employee_id)
FROM employees;

-- 이름 마스킹
CREATE OR REPLACE FUNCTION subname
(p_name employees.last_name%TYPE)
RETURN VARCHAR2
IS
    v_result VARCHAR2(30);
BEGIN
    v_result := RPAD(SUBSTR(p_name, 1, 1), length(p_name) , '*');
    RETURN v_result;
END;
/
SELECT last_name, subname(last_name)
FROM   employees;

-- 부서 번호 입력시 담당자
CREATE OR REPLACE FUNCTION y_dept
(p_dno employees.department_id%TYPE)
RETURN VARCHAR2
IS
    v_name employees.last_name%TYPE;
    e_no_deptno EXCEPTION;
BEGIN
    SELECT e.last_name
    INTO v_name
    FROM departments d LEFT OUTER JOIN employees e ON d.manager_id = e.employee_id
    WHERE d.department_id = p_dno;
    
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
EXECUTE DBMS_OUTPUT.PUT_LINE(y_dept(100));

SELECT department_id, y_dept(department_id)
FROM   departments;


-- 모든 계정의 객체
SELECT *
FROM all_source;

-- 현재 계정의 객체
SELECT *
FROM user_source;

-- 특정 객체의 정보
SELECT name, text
FROM user_source
WHERE type IN ('PROCEDURE', 'FUCTION', 'PACKAGE', 'PACKAGE BODY');