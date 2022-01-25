  -- INSERT시에 VALUES 대신 서브쿼리를 이용할 수 있다.
  CREATE TABLE TEST_01(
  EMP_ID NUMBER,
  EMP_NAME VARCHAR2(30),
  DEPT_TITLE VARCHAR2(20)
);

SELECT
       T1.*
  FROM TEST_01 T1;

-- 실험! INSERT 시에 서브쿼리를 사용할 때는 SELECT 구문의 컬럼명과 INTO 안의 컬럼명이 달라도 괜찮고 자료형이 일치하면 된다
-- SELECT 문에 넣은 내용이 순서대로 넣어지는걸 확인할 수 있었다!
INSERT
  INTO TEST_01
( 
  EMP_ID, EMP_NAME, DEPT_TITLE
)
(
  SELECT
         E.EMP_ID
       , D.DEPT_TITLE
       , D.LOCATION_ID
    FROM EMPLOYEE E
    LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
);

SELECT
        T1.*
  FROM TEST_01 T1;
  
-- 다시 서브쿼리를 이용해서 정확한 값을 넣어보기
  CREATE TABLE TEST_02(
  EMP_ID NUMBER,
  EMP_NAME VARCHAR2(30),
  DEPT_TITLE VARCHAR2(20)
);

INSERT
  INTO TEST_02
(
  EMP_ID, EMP_NAME, DEPT_TITLE
)
( SELECT
         E.EMP_ID
       , E.EMP_NAME
       , D.DEPT_TITLE
    FROM EMPLOYEE E
    LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
);

--넣어진 행 확인
SELECT
       T2.*
  FROM TEST_02 T2;

CREATE TABLE TEST_DEPT_D1
AS
SELECT E.EMP_ID
     , E.EMP_NAME
     , E.DEPT_CODE
     , E.HIRE_DATE
  FROM EMPLOYEE E
 WHERE 1 = 0;
 
SELECT TD.* FROM TEST_DEPT_D1 TD;

CREATE TABLE TEST_MANAGER
AS
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , E.MANAGER_ID
  FROM EMPLOYEE E
 WHERE 1 =0 ;
 
SELECT TM.* FROM TEST_MANAGER TM;

-- TEST_DEPT_D1 테이블에 EMPLOYEE 테이블에 있는 부서 코드가 D1인 직원을
-- 조회해서 사번, 이름, 소속부서, 입사일을 삽입하고,
-- TEST_MANAGER 테이블에 EMPLOYEE 테이블에 있는 부서 코드가 D1인 직원을
-- 조회해서 사번, 이름, 관리자 사번을 삽입하세요
INSERT ALL
  INTO TEST_DEPT_D1
VALUES
(
  EMP_ID
, EMP_NAME
, DEPT_CODE
, HIRE_DATE
)
  INTO TEST_MANAGER
VALUES
(
  EMP_ID
, EMP_NAME
, MANAGER_ID
)
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , E.DEPT_CODE
     , E.HIRE_DATE
     , E.MANAGER_ID
  FROM EMPLOYEE E
 WHERE E.DEPT_CODE = 'D1';

-- 들어간 값 확인
SELECT TD.* FROM TEST_DEPT_D1 TD;

SELECT TM.* FROM TEST_MANAGER TM;

-- EMPLOYEE 테이블에서 입사일 기준으로 2000년 1월 1일 이전에 입사한
-- 사원의 사번, 이름, 입사일, 급여를 조회하여
-- TEST_OLD 테이블에 삽입하고
-- 그 이후에 입사한 사원은 TEST_NEW 테이블에 삽입하세요.
CREATE TABLE TEST_OLD
AS
SELECT
       E.EMP_NO
     , E.EMP_NAME
     , E.HIRE_DATE
     , E.SALARY
  FROM EMPLOYEE E
 WHERE 1 = 0;
 
CREATE TABLE TEST_NEW
AS
SELECT
       E.EMP_NO
     , E.EMP_NAME
     , E.HIRE_DATE
     , E.SALARY
  FROM EMPLOYEE E
 WHERE 1 = 0;
  
INSERT ALL
  WHEN HIRE_DATE < '2000/01/01'
  THEN 
  INTO TEST_OLD
VALUES
(
  EMP_NO, EMP_NAME, HIRE_DATE, SALARY
)
  WHEN HIRE_DATE >= '2000/01/01'
  THEN
  INTO TEST_NEW
VALUES
(
  EMP_NO, EMP_NAME, HIRE_DATE, SALARY
)
SELECT E.EMP_NO
     , E.EMP_NAME
     , E.HIRE_DATE
     , E.SALARY
  FROM EMPLOYEE E;
  
-- 만들어진 값 확인
SELECT 
       O.* 
  FROM TEST_OLD O;

SELECT
       N.*
  FROM TEST_NEW N;

CREATE TABLE TEST_SALARY
AS
SELECT E.EMP_ID
     , E.EMP_NAME
     , E.DEPT_CODE
     , E.SALARY
     , E.BONUS
  FROM EMPLOYEE E;

-- 평상시 유재식 사원을 부러워하던 방명수 사원의
-- 급여와 보너스율을 유재식 사원과 동일하게 변경해 주기로 했다.
-- 이를 반영하는 UPDATE문을 작성해보세요 (TEST_SLARY 테이블이용)
UPDATE TEST_SALARY TS
   SET TS.SALARY = (SELECT
                          E.SALARY
                     FROM EMPLOYEE E
                    WHERE E.EMP_NAME = '유재식')
     , TS.BONUS = (SELECT E.BONUS
                     FROM EMPLOYEE E
                    WHERE E.EMP_NAME = '유재식')
 WHERE TS.EMP_NAME = '방명수';

-- 방명수 사원의 급여 인상 소식을 전해들은 다른 직원들이
-- 단체로 파업을 진행했다
-- 노옹철, 전형돈, 정중하, 하동운 사원의 급여와 보너스를
-- 유재식 사원의 급여와 보너스와 같게 변경하는 UPDATE문 작성
UPDATE TEST_SALARY TS
   SET (TS.SALARY, TS.BONUS) = (SELECT E.SALARY, E.BONUS
                                  FROM EMPLOYEE E
                                 WHERE E.EMP_NAME = '유재식')
 WHERE TS.EMP_NAME IN ('노옹철', '전형돈', '정중하', '하동운');
 

-- TEST_SALARY 테이블에서 아시아 근무 지역에 근무하는 직원의
-- 보너스를 0.5로 변경하세요
UPDATE TEST_SALARY TS
   SET TS.BONUS = 0.5
 WHERE TS.EMP_ID IN (SELECT E.EMP_ID
                       FROM EMPLOYEE E
                       LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
                       JOIN LOCATION L ON(D.LOCATION_ID = LOCAL_CODE)
                      WHERE L.LOCAL_NAME LIKE 'ASIA%');
