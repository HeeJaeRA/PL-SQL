/* 환경설정 
sqldeveloper\sqldeveloper\bin\sqldeveloper.conf
AddVMOption -Duser.language=en 추가
*/

SET SERVEROUTPUT ON

-- 변수 선언
DECLARE
    v_today     DATE;
    v_literal   CONSTANT NUMBER := 10;
    v_count     NUMBER := v_literal + 100;
    v_msg       VARCHAR2(100 char) NOT NULL := 'Hello, PL/SQL';
BEGIN
    DBMS_OUTPUT.PUT_LINE(v_count);
END;
/

BEGIN
-- 한글 사용할때는 ""
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'yyyy"년" MM"월" dd"일"'));
END;
/

BEGIN
-- DML 사용 시 COMMIT, ROLLBACK, SAVEPOINT 명시
    INSERT INTO employee(empid, empname)
    VALUES (1000, 'Hong');
    ROLLBACK;
END;
/

/* 중첩 함수에 여러개의 DML 있어도 하나의 트랜젝션으로 처리됨
   각각 COMMIT, ROLLBACK 필요 */
DECLARE
    v_sal   NUMBER := 1000;
    v_comm  NUMBER := v_sal * 0.1;
    v_msg   VARCHAR2(1000) := '초기화 || ';
BEGIN
    DECLARE
        v_sal       NUMBER := 9999;
        v_comm      NUMBER := v_sal * 0.2;
        v_annual    NUMBER;
    BEGIN
        v_annual := (v_sal + v_comm) * 12;
        v_msg := v_msg || '내부 블록 || ';
        DBMS_OUTPUT.PUT_LINE('연봉:' || v_annual);
    END;
    v_msg := v_msg || '바깥 블록';
    DBMS_OUTPUT.PUT_LINE(v_msg);
END;
/
