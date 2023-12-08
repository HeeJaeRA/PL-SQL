// 서브쿼리(페이징)
SELECT r.*
FROM (  SELECT ROWNUM rn, e.*
        FROM (  SELECT *
                FROM employees
                ORDER BY employee_id) e
                ) r
WHERE rn BETWEEN 1 AND 10;


// DDL
CREATE TABLE department (
    deptid      NUMBER(10)  NOT NULL,
    deptname    VARCHAR2(10),
    loacation    VARCHAR2(10),
    tel         VARCHAR2(15),
    CONSTRAINT pk_dept PRIMARY KEY (deptid)
);

CREATE TABLE employee (
    empid       NUMBER(10)  NOT NULL,
    empname     VARCHAR2(10),
    hiredate    DATE,
    addr        VARCHAR2(12),
    tel         VARCHAR2(15),
    deptid      NUMBER(10),
    CONSTRAINT pk_emp PRIMARY KEY (empid),
    CONSTRAINT fk_emp FOREIGN KEY (deptid) REFERENCES department(deptid)
);

ALTER TABLE employee ADD birthday DATE;

ALTER TABLE employee MODIFY empname NOT NULL;

// DML
INSERT INTO department
VALUES (1001, '총무팀', '본101호', '053-777-8777');
INSERT INTO department
VALUES (1002, '회계팀', '본102호', '053-888-9999');
INSERT INTO department
VALUES (1003, '영업팀', '본103호', '053-222-3333');

INSERT INTO employee ( EMPID, EMPNAME, HIREDATE, ADDR, TEL, DEPTID)
VALUES (20121945, '박민수', TO_DATE('2012/03/02', 'YY/MM/DD'), '대구', '010-1111-1234', 1001);
INSERT INTO employee ( EMPID, EMPNAME, HIREDATE, ADDR, TEL, DEPTID)
VALUES (20101817, '박준식', TO_DATE('2010-09-01', 'YY/MM/DD'), '경산', '010-2222-1234', 1003);
INSERT INTO employee ( EMPID, EMPNAME, HIREDATE, ADDR, TEL, DEPTID)
VALUES (20122245, '선아라', TO_DATE('2012-03-02', 'YY/MM/DD'), '대구', '010-3333-1222', 1002);
INSERT INTO employee ( EMPID, EMPNAME, HIREDATE, ADDR, TEL, DEPTID)
VALUES (20121729, '이범수', TO_DATE('2011-03-02', 'YY/MM/DD'), '서울', '010-3333-4444', 1001);
INSERT INTO employee ( EMPID, EMPNAME, HIREDATE, ADDR, TEL, DEPTID)
VALUES (20121646, '이융희', TO_DATE('2012-09-01', 'YY/MM/DD'), '부산', '010-1234-2222', 1003);

SELECT e.empname, e.hiredate, d.deptname FROM employee e JOIN department d ON e.deptid = d.deptid WHERE d.deptname = '총무팀';

DELETE FROM employee WHERE ADDR = '대구';

UPDATE employee
SET deptid = (
    SELECT deptid
    FROM department
    WHERE deptname = '회계팀')
WHERE deptid = (
    SELECT deptid
    FROM department
    WHERE deptname = '영업팀');

SELECT e.empid, e.empname, e.birthday, d.deptname 
FROM employee e join department d on e.deptid = d.deptid 
WHERE e.hiredate > (SELECT hiredate FROM employee WHERE empid = 20121729);

CREATE OR REPLACE VIEW v_chong
AS
   SELECT e.empname, e.addr, d.deptname 
   FROM employee e JOIN department d ON e.deptid = d.deptid 
   WHERE d.deptname = '총무팀'
;
SELECT * FROM v_chong;