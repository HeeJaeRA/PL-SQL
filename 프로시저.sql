SET SERVEROUTPUT ON

/* 잘못된 프로시저 생성 
CREATE PROCEDURE test_pro
-- () 생략 가능
IS

-- 암시적으로 DECLARE 선언
-- 지역 변수, 레코드, 커서, EXCEPTION

BEGIN
    DBMS_OUTPUT.PUT_LINE('First Procedure');
EXCEPTION

END;
/
*/

-- 재컴파일 (수정)
CREATE OR REPLACE PROCEDURE test_pro IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('First Procedure');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('예외 처리');
END;
/

-- 블록 내부에서 호출
BEGIN
    test_pro;
END;
/

-- EXECUTE 명령어로 호출 (단독 실행 시 많이 사용)
EXECUTE test_pro;
/

-- 삭제
DROP PROCEDURE test_pro;

-- PROCEDURE IN 선언
CREATE PROCEDURE raise_salary
(p_eid IN NUMBER)
IS
BEGIN
    p_eid := 100;
    
    UPDATE employees
    SET salary = salary * 1.1
    WHERE employee_id = p_eid;
END;
/

-- PROCEDURE IN 호출
DECLARE
    v_id employees.employee_id%TYPE := &사원번호;
    v_num CONSTANT NUMBER := v_id;
BEGIN
    RAISE_SALARY(v_id);
    RAISE_SALARY(v_num);
    RAISE_SALARY(v_num + 100);
    RAISE_SALARY(200);
END;
/

-- PROCEDURE OUT 선언
CREATE PROCEDURE pro_plus
(p_x IN NUMBER,
 p_Y IN NUMBER,
 p_result OUT NUMBER)
IS
    v_sum NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE(p_x || ' + ' || p_y || ' = ' || p_result);
    
    v_sum := p_x + p_y;
END;
/

-- PROCEDURE OUT 호출
DECLARE
    v_first NUMBER := 10;
    v_second NUMBER := 12;
    v_result NUMBER := 100;
BEGIN
    DBMS_OUTPUT.PUT_LINE('before: ' || v_result);
    pro_plus(v_first, v_second, v_result);
    DBMS_OUTPUT.PUT_LINE('after: ' || v_result);
END;
/

-- PROCEDURE IN OUT 선언 (포맷 변경에 자주 쓰임 ex)01012345678 -> 010-1234-5678)
CREATE PROCEDURE format_phone
(v_phone_no IN OUT VARCHAR2)
IS
BEGIN
    v_phone_no := SUBSTR(v_phone_no, 1, 3) 
                  || '-' || SUBSTR(v_phone_no, 4, 4) 
                  || '-' || SUBSTR(v_phone_no, 8);
END;
/

-- PROCEDURE IN OUT 호출
DECLARE
    v_no VARCHAR2(50) := '01012341234';
BEGIN
    DBMS_OUTPUT.PUT_LINE('before: ' || v_no);
    format_phone(v_no);
    DBMS_OUTPUT.PUT_LINE('after: ' || v_no);
END;
/

-- 주민등록번호 포맷
CREATE OR REPLACE PROCEDURE yedam_ju
(v_human_no IN VARCHAR2)
IS
    v_result VARCHAR2(100);
    v_gender CHAR(1);
    v_date VARCHAR2(11 char);
BEGIN
    v_result := SUBSTR(v_human_no, 1, 6)|| '-' || SUBSTR(v_human_no, 7, 1) || '*******';
    DBMS_OUTPUT.PUT_LINE(v_result);
    
    v_gender := SUBSTR(v_human_no, 7, 1);
    IF v_gender IN ('1', '2') THEN
        v_date := '19'||SUBSTR(v_human_no, 1, 2)||'년'||SUBSTR(v_human_no, 3, 2)||'월'||SUBSTR(v_human_no, 5, 2)||'일';
    ELSIF v_gender IN ('3', '4') THEN
        v_date := '20'||SUBSTR(v_human_no, 1, 2)||'년'||SUBSTR(v_human_no, 3, 2)||'월'||SUBSTR(v_human_no, 5, 2)||'일';
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_date);
END;
/
EXECUTE yedam_ju('950101166777');
EXECUTE yedam_ju('1511013689977');
/

-- 사원번호 삭제하는 프로시저
CREATE OR REPLACE PROCEDURE test_pro
(v_eid IN NUMBER)
IS
    e_no_deptno EXCEPTION;
BEGIN
    DELETE 
    FROM employees
    WHERE employee_id = p_eid;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_no_deptno;
    END IF;
    DBMS_OUTPUT.PUT_LINE('삭제 완료');
EXCEPTION
    WHEN e_no_deptno THEN
        DBMS_OUTPUT.PUT_LINE('해당 사원이 없습니다.');
END;
/
EXECUTE TEST_PRO(899);

-- 사원이름 마스킹되는 프로시저
CREATE OR REPLACE PROCEDURE yedam_emp
(v_eid IN NUMBER)
IS
    v_emp_no NUMBER;
    v_name VARCHAR2(20);
    v_result VARCHAR2(20);
BEGIN
    v_emp_no := v_eid;
    SELECT last_name
    INTO v_name
    FROM employees
    WHERE employee_id = v_emp_no;
    DBMS_OUTPUT.PUT_LINE(v_name);
    
    v_result := RPAD(SUBSTR(v_name, 1, 1), length(v_name) , '*');
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/
EXECUTE yedam_emp(176);