SELECT
       EMP_ID
     , EMP_NAME
     , HIRE_DATE
  FROM EMPLOYEE
 WHERE EMP_NAME LIKE '김%';
 
 SELECT
       EMP_ID
     , EMP_NAME
     , HIRE_DATE
  FROM EMPLOYEE
 WHERE EMP_NAME NOT LIKE '김%';
 
 SELECT
        EMP_NAME
      , EMP_NO
      , DEPT_CODE
  FROM EMPLOYEE
 WHERE EMP_NAME LIKE '%하%';
 
 SELECT
        EMP_ID
      , EMP_NAME
      , PHONE
  FROM EMPLOYEE
 WHERE PHONE LIKE '___9%';
 
 SELECT
        EMP_ID
      , EMP_NAME
      , PHONE
  FROM EMPLOYEE
 WHERE PHONE LIKE '___9_______';
 
 SELECT
        EMP_ID
      , EMP_NAME
      , EMAIL
  FROM EMPLOYEE 
 WHERE EMAIL LIKE '___$_%' ESCAPE '$';
 
 SELECT
        EMP_ID
      , EMP_NAME
      , EMAIL
  FROM EMPLOYEE
 WHERE EMP_NAME NOT LIKE '이%';
 
 SELECT
        EMP_NAME
      , DEPT_CODE
      , SALARY
  FROM EMPLOYEE
 WHERE DEPT_CODE IN('D6', 'D8');
 
 SELECT
        EMP_NAME
      , DEPT_CODE
      , SALARY
  FROM EMPLOYEE
 WHERE DEPT_CODE NOT IN('D6','D8');
 
 SELECT
        EMP_NAME
      , SALARY
      , JOB_CODE
   FROM EMPLOYEE
  WHERE JOB_CODE = 'J2' 
    AND SALARY >= 2000000
     OR JOB_CODE = 'J7';
     
SELECT
       EMP_NAME
     , SALARY
     , JOB_CODE
  FROM EMPLOYEE
 WHERE (JOB_CODE = 'J7'
    OR JOB_CODE = 'J2')
   AND SALARY >= 2000000; 
   
SELECT
       COUNT(*)
     , COUNT(DEPT_CODE)
     , COUNT(DISTINCT DEPT_CODE)
  FROM EMPLOYEE;
  
SELECT
       EMAIL
     , INSTR(EMAIL, '@', -1)
  FROM EMPLOYEE;
  
SELECT INSTR('AABAACAAB', 'B', 1) FROM DUAL;
SELECT INSTR('AABAACAAB', 'B', 1, 2) FROM DUAL;
SELECT INSTR('AABAACAAB', 'B', -1) FROM DUAL;
SELECT INSTR('BABAABAACAAB', 'B', -2, 3) FROM DUAL;

SELECT
       LPAD(EMAIL, 20, '#')
  FROM EMPLOYEE;
 
SELECT
       RPAD(EMAIL, 20, '$')
  FROM EMPLOYEE;
  
SELECT RTRIM('123123GREDDY123', '123') FROM DUAL;

SELECT TRIM('1' FROM '11231654') FROM DUAL;
SELECT TRIM(LEADING 'G' FROM 'GBGBACX') FROM DUAL;
SELECT TRIM(TRAILING 'X' FROM 'GBGBACX') FROM DUAL;

SELECT SUBSTR('SHOWMETHEMONEY', 5, 2) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', 8) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', -3, 3) FROM DUAL;

SELECT
       EMP_NAME 사원명
     , SUBSTR(EMP_NO, 1, 2) 생년
     , SUBSTR(EMP_NO, 3, 2) 생월
     , SUBSTR(EMP_NO, 5, 2) 생일
  FROM EMPLOYEE;

SELECT
       HIRE_DATE
     , SUBSTR(HIRE_DATE, 1, 2) 입사년도
     , SUBSTR(HIRE_DATE, 4, 2) 입사월
     , SUBSTR(HIRE_DATE, 7, 2) 입사일
  FROM EMPLOYEE;
  
SELECT
      *
  FROM EMPLOYEE
 WHERE SUBSTR(EMP_NO, 8, 1) = 2; 
 
SELECT
       EMP_NAME
     , RPAD(SUBSTR(EMP_NO, 1, 7), 14, '*')
  FROM EMPLOYEE;
  
SELECT
       EMP_NAME
     , EMAIL
     , SUBSTR(EMAIL, 1, INSTR(EMAIL, '@', 1)-1)
  FROM EMPLOYEE;
  
SELECT
       EMP_NAME
     , EMAIL
     , SUBSTR(EMAIL, 1, INSTR(EMAIL, '@', 1)-1)
  FROM EMPLOYEE;
  
SELECT
       SUBSTR('오라클', 2, 2)
     , SUBSTRB('오라클', 4, 6)
  FROM DUAL; 

SELECT 
       LOWER('ABC')
  FROM DUAL;

SELECT
      UPPER('abc')
 FROM DUAL;
 
 SELECT
      INITCAP('abc')
 FROM DUAL;
 
SELECT
      CONCAT('가나다라','ABCD')
 FROM DUAL;
 
 SELECT
        REPLACE('서울특별시 서대문구 신사동', '서대문구', '강남구')
   FROM DUAL;
       
SELECT
       ABS(-23)
     , ABS(23)
  FROM DUAL;

SELECT
       MOD(3, 2)
  FROM DUAL;

SELECT ROUND(123.456) FROM DUAL;
SELECT ROUND(123.456, 1) FROM DUAL;
SELECT ROUND(123.456, 2) FROM DUAL;
SELECT ROUND(123.456, 0) FROM DUAL;
SELECT ROUND(123.456, -2) FROM DUAL;
SELECT ROUND(123.456, -1) FROM DUAL;

SELECT FLOOR(123.456) FROM DUAL;
SELECT FLOOR(123.678) FROM DUAL;

SELECT TRUNC(123.456) FROM DUAL;
SELECT TRUNC(123.456, 0) FROM DUAL;
SELECT TRUNC(123.456, 1) FROM DUAL;
SELECT TRUNC(123.456, -1) FROM DUAL;

SELECT CEIL(123.456) FROM DUAL;
SELECT CEIL(123.567) FROM DUAL;

SELECT SYSDATE FROM DUAL;

SELECT
      EMP_NAME
    , HIRE_DATE
    , CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE))
 FROM EMPLOYEE;

SELECT
       ADD_MONTHS(SYSDATE, 3)
  FROM DUAL;

SELECT
       EMP_NAME
     , HIRE_DATE
     , ADD_MONTHS(HIRE_DATE, 6)
  FROM EMPLOYEE;
  
SELECT
      *
  FROM EMPLOYEE
 WHERE MONTHS_BETWEEN(SYSDATE, HIRE_DATE) >= 240;
 
SELECT SYSDATE, NEXT_DAY(SYSDATE, '목요일') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 5) FROM DUAL;

SELECT
       EMP_NAME
     , CEIL(HIRE_DATE - SYSDATE)
     , CEIL(SYSDATE - HIRE_DATE)
  FROM EMPLOYEE;
  
SELECT
       EMP_NAME 사원명
     , HIRE_DATE 입사일
     , LAST_DAY(HIRE_DATE) - HIRE_DATE +1 "입사한 월의 근무일수"
 FROM EMPLOYEE;
 
SELECT
       EXTRACT(YEAR FROM SYSDATE)
     , EXTRACT(MONTH FROM SYSDATE)
     , EXTRACT(DAY FROM SYSDATE)
  FROM DUAL;
  
SELECT
       EMP_NAME 사원이름
     , EXTRACT(YEAR FROM HIRE_DATE) 입사년
     , EXTRACT(MONTH FROM HIRE_DATE) 입사월
     , EXTRACT(DAY FROM HIRE_DATE) 입사일
  FROM EMPLOYEE
ORDER BY 2;

SELECT
       EMP_NAME 직원이름
     , HIRE_DATE 입사일
     , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) 근무년수
  FROM EMPLOYEE
ORDER BY 근무년수 DESC;

SELECT
       EMP_NAME 직원이름
     , HIRE_DATE 입사일
     , FLOOR(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)/12) 근무년수
  FROM EMPLOYEE; 
  
SELECT
       EMP_NAME
     , TO_CHAR(SALARY, 'L99,999,999')
  FROM EMPLOYEE;
  
SELECT TO_CHAR(SYSDATE, 'PM HH24:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'AM HH:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'MON DY, YYYY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YYYY-fmMM-DD DAY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YEAR, Q') FROM DUAL;

SELECT
       EMP_NAME
     , TO_CHAR(HIRE_DATE, 'YYYY-fmMM-DD') 입사일
  FROM EMPLOYEE;
  
SELECT
       EMP_NAME
     , TO_CHAR(HIRE_DATE, 'RRRR"년" fmMM"월" DD"일" "("DY")"')
  FROM EMPLOYEE;
  
SELECT
       EMP_ID
     , EMP_NAME
     , HIRE_DATE
  FROM EMPLOYEE
 WHERE HIRE_DATE >= TO_DATE(20000101, 'RRRRMMDD');
 
SELECT
       EMP_NAME 이름
     , SUBSTR(EMP_NO, 1, 6) "주민번호 앞자리"
     , SUBSTR(EMP_NO, 8, 14) "주민번호 뒷자리"
     , TO_NUMBER(SUBSTR(EMP_NO, 1, 6)) + TO_NUMBER(SUBSTR(EMP_NO, 8, 14)) 합
  FROM EMPLOYEE
 WHERE EMP_ID = 201;
 
