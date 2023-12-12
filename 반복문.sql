SET SERVEROUTPUT ON

-- 1에서 10까지 정수값을 더한 결과
-- 기본 LOOP
DECLARE
    v_num   NUMBER := 1;
    v_sum   NUMBER := 0;
BEGIN
    LOOP
        v_sum := v_sum + v_num;
        v_num := v_num + 1;
        EXIT WHEN v_num > 10;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/

-- WHILE LOOP
DECLARE
    v_num   NUMBER := 1;
    v_sum   NUMBER := 0;
BEGIN
    WHILE v_num <= 10 LOOP
        v_sum := v_sum + v_num;
        v_num := v_num + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/

-- FOR LOOP
DECLARE
    v_sum   NUMBER := 0;
BEGIN
    FOR num in 1 .. 10 LOOP
        v_sum := v_sum + num;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/

-- 기본 LOOP 별 찍기
DECLARE
    v_star VARCHAR2(10) := '*';
    v_count NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(v_star);
        v_star := v_star || '*';
        v_count := v_count + 1;
        EXIT WHEN v_count > 5;
    END LOOP;
END;
/

-- WHILE LOOP 별 찍기
DECLARE
    v_star VARCHAR2(10) := '*';
BEGIN
    WHILE LENGTH(v_star) <= 5 LOOP
        DBMS_OUTPUT.PUT_LINE(v_star);
        v_star := v_star || '*';
    END LOOP;
END;
/

-- FOR LOOP 별 찍기
DECLARE
    v_star VARCHAR2(10) := '*';
    v_count NUMBER := 1;
BEGIN
    FOR i in 1 .. 5 LOOP
        DBMS_OUTPUT.PUT_LINE(v_star);
        v_star := v_star || '*';
    END LOOP;
END;
/

-- 중첩 FOR LOOP 별 찍기
BEGIN
    FOR i in 1 .. 5 LOOP
        FOR j in 1 .. i LOOP
            DBMS_OUTPUT.PUT('*');
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

-- 중첩 기본 LOOP 별 찍기
DECLARE
    v_star NUMBER := 1;
    v_count NUMBER := 1;
BEGIN
    LOOP
        v_star := 1;
        LOOP
            DBMS_OUTPUT.PUT('*');
            v_star := v_star + 1;
            EXIT WHEN v_star > v_count;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
        v_count := v_count + 1;
        EXIT WHEN v_count > 5;
    END LOOP;
END;
/

-- 구구단 기본 LOOP
DECLARE
    v_input NUMBER := &단;
    v_count NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(v_input || ' X ' || v_count || ' = ' || v_input * v_count);
        v_count := v_count + 1;
        EXIT WHEN v_count > 9;
    END LOOP;
END;

-- 구구단 WHILE LOOP
DECLARE
    v_input NUMBER := &단;
    v_count NUMBER := 1;
BEGIN
    WHILE v_count < 10 LOOP
        DBMS_OUTPUT.PUT_LINE(v_input || ' X ' || v_count || ' = ' || v_input * v_count);
        v_count := v_count + 1;
    END LOOP;
END;

-- 구구단 FOR LOOP
DECLARE
    v_input NUMBER := &단;
BEGIN
    FOR i IN v_input .. v_input LOOP
        FOR j IN 1 .. 9 LOOP
        DBMS_OUTPUT.PUT_LINE(i || ' X ' || j || ' = ' || i*j);
        END LOOP;
    END LOOP;
END;
/
/*
DECLARE
    v_input NUMBER := &단;
BEGIN
    FOR i IN 1 .. 9 LOOP
        DBMS_OUTPUT.PUT_LINE(v_input || ' X ' || i || ' = ' || v_input * i);
    END LOOP;
END;
/
*/

-- 구구단 출력
BEGIN
    FOR i IN 1 .. 9 LOOP
        FOR j IN 2 .. 9 LOOP
            DBMS_OUTPUT.PUT(j || ' X ' || i || ' = ' || LPAD(i * j, 2) || '    ');
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

-- 구구단 홀수만 출력
BEGIN
    FOR i IN 1 .. 9 LOOP
        FOR j IN 1 .. 9 LOOP
            -- <>, !=
            IF MOD(j, 2) <> 0 THEN
                DBMS_OUTPUT.PUT(j || ' X ' || i || ' = ' || LPAD(i * j, 2) || '    ');
            END IF;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/