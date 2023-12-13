SET SERVEROUTPUT ON

-- 미리 정의된 ORACLE SERVER 예외사항
DECLARE
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT last_name
    INTO v_ename
    FROM employees
    WHERE department_id = &부서번호;
    DBMS_OUTPUT.PUT_LINE(v_ename);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('결과 없음');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('결과가 많음');
END;
/

-- 미리 정의하지 않은 ORACLE SERVER 예외사항
DECLARE
    e_pk_remain EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_pk_remain, -2292);
BEGIN
    DELETE FROM departments
    WHERE department_id = &부서번호;
EXCEPTION
    WHEN e_pk_remain THEN
        DBMS_OUTPUT.PUT_LINE('PK/FK');
END;
/

-- 사용자 정의 예외사항
DECLARE
    e_no_deptno EXCEPTION;
BEGIN
    DELETE FROM departments
    WHERE department_id = &부서번호;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_no_deptno;
    END IF;
    DBMS_OUTPUT.PUT_LINE('삭제 완료');
EXCEPTION
    WHEN e_no_deptno THEN
        DBMS_OUTPUT.PUT_LINE('데이터 없음');
END;
/

select * from test;

-- 예외 트랩 함수 
DECLARE
    v_ename employees.last_name%TYPE;
    v_error_code NUMBER;
    v_error_message VARCHAR2(255);
BEGIN
    SELECT last_name
    INTO v_ename
    FROM employees
    WHERE department_id = &부서번호;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('데이터 없음');
    WHEN OTHERS THEN
        ROLLBACK;
        v_error_code := SQLCODE;
        v_error_message := SQLERRM;
        INSERT INTO test
        VALUES (v_error_code, v_error_message);
        -- COMMIT;
END;
/

CREATE TABLE test_employee
AS
    SELECT *
    FROM employees;
/

SELECT * FROM test_employee;
/

-- 치환 변수를 사용한 특정 사원 삭제
DECLARE
    e_no_empno EXCEPTION;
    v_delno employees.employee_id%TYPE := &사원번호;
BEGIN
    DELETE FROM test_employee
    WHERE employee_id = v_delno;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_no_empno;
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_delno || '번 삭제 완료');
EXCEPTION
    WHEN e_no_empno THEN
        DBMS_OUTPUT.PUT_LINE('입력 번호: ' || v_delno);
        DBMS_OUTPUT.PUT_LINE('해당 사원이 존재하지 않습니다.');
END;
/