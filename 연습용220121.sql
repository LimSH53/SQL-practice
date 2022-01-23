-- 사원명이 노옹철인 사람의 부서 조회
SELECT
       DEPT_CODE
  FROM EMPLOYEE
 WHERE EMP_NAME = '노옹철';
 
-- 부서코드가 D9인 직원을 조회
SELECT
       EMP_NAME
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D9';
 
-- 위의 두 쿼리를 하나로
-- 부서코드가 노옹철 사원과 같은 소속의 직원 명단 조회
SELECT
       EMP_NAME
  FROM EMPLOYEE
 WHERE DEPT_CODE = (SELECT DEPT_CODE
                      FROM EMPLOYEE
                     WHERE EMP_NAME = '노옹철');
                     
-- 전 직원의 평균 급여보다 많은 급여를 받고 있는 직원의
-- 사번, 이름, 직급코드, 급여를 조회하세요
SELECT
       EMP_ID
     , EMP_NAME
     , JOB_CODE
     , SALARY
  FROM EMPLOYEE
 WHERE SALARY >= (SELECT AVG(SALARY)
                     FROM EMPLOYEE
                    );

-- 노옹철 사원의 급여보다 많이 받는 직원의
-- 사번, 이름, 부서, 직급, 급여를 조회하세요
SELECT
       EMP_ID
     , EMP_NAME
     , DEPT_CODE
     , JOB_CODE
     , SALARY
  FROM EMPLOYEE
 WHERE SALARY > (SELECT SALARY
                   FROM EMPLOYEE
                  WHERE EMP_NAME = '노옹철');

-- 가장 적은 급여를 받는 직원의
-- 사번, 이름, 직급, 부서, 급여, 입사일을 조회하세요
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , E.JOB_CODE
     , E.DEPT_CODE
     , E.SALARY
     , E.HIRE_DATE
  FROM EMPLOYEE E
 WHERE E.SALARY = (SELECT MIN(E2.SALARY)
                     FROM EMPLOYEE E2);
                     
-- 부서별 급여의 합계 중 가장 큰 부서의 부서명, 급여 합계를 구하세요 (HAVAING 절 이용)
SELECT
       D.DEPT_TITLE 부서명
     , SUM(E.SALARY) 급여합계
  FROM EMPLOYEE E
  LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
 GROUP BY D.DEPT_TITLE
HAVING SUM(E.SALARY) IN (SELECT MAX(SUM(E2.SALARY))
                           FROM EMPLOYEE E2
                          GROUP BY DEPT_CODE);

-- 부서별 최고 급여를 받는 직원의 이름, 직급, 부서, 급여 조회
SELECT
       E.EMP_NAME
     , E.JOB_CODE
     , E.DEPT_CODE
     , E.SALARY
  FROM EMPLOYEE E
 WHERE E.SALARY IN(SELECT MAX(E2.SALARY)
                     FROM EMPLOYEE E2
                    GROUP BY E2.DEPT_CODE
                   );

-- 관리자에 해당하는 직원에 대한 정보와 관리자가 아닌 직원의
-- 정보를 추출하여 조회
-- 사번, 이름, 부서명, 직급, '관리자' AS 구분 / '직원' AS 구분
SELECT
       E.EMP_ID 사번
     , E.EMP_NAME 이름
     , D.DEPT_TITLE 부서명
     , J.JOB_NAME 직급
     , '관리자' AS 구분
  FROM EMPLOYEE E
  LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
 WHERE E.EMP_ID IN (SELECT DISTINCT(E2.MANAGER_ID)
                      FROM EMPLOYEE E2
                     WHERE E2.MANAGER_ID IS NOT NULL);
             
SELECT
       E.EMP_ID 사번
     , E.EMP_NAME 이름
     , D.DEPT_TITLE 부서명
     , J.JOB_NAME 직급
     , '직원' AS 구분
  FROM EMPLOYEE E
  LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  LEFT JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
 WHERE E.EMP_ID NOT IN (SELECT DISTINCT(E2.MANAGER_ID)
                      FROM EMPLOYEE E2
                     WHERE E2.MANAGER_ID IS NOT NULL);

-- 관리자에 해당하는 직원에 대한 정보와 관리자가 아닌 직원의
-- 정보를 추출하여 조회
-- 사번, 이름, 부서명, 직급, '관리자' AS 구분 / '직원' AS 구분 (SELECT절에서 서브쿼리사용)
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , D.DEPT_TITLE
     , J.JOB_NAME
     , CASE
         WHEN E.EMP_ID IN ( SELECT
                                   DISTINCT(E2.MANAGER_ID)
                              FROM EMPLOYEE E2
                             WHERE E2.MANAGER_ID IS NOT NULL
                             )
         THEN '관리자'
         ELSE '직원'
       END AS 구분
  FROM EMPLOYEE E
  LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  LEFT JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE);

-- 대리 직급의 직원들 중에서 과장 직급의 최소 급여보다 많이 받는
-- 직원의 사번, 이름, 직급명, 급여를 조회하세요
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , J.JOB_NAME
     , E.SALARY
  FROM EMPLOYEE E
  JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
 WHERE J.JOB_NAME = '대리'
   AND E.SALARY > ANY(SELECT E2.SALARY
                         FROM EMPLOYEE E2
                         JOIN JOB J2 ON(E2.JOB_CODE = J2.JOB_CODE)
                        WHERE J2.JOB_NAME = '과장');

-- 차장 직급의 급여의 가장 큰 값보다 많이 받는 과장 직급의
-- 사번, 이름, 직급, 급여를 조회하세요
-- 단, > ALL 혹은 < ALL 연사자를 사용
SELECT 
       EMP_ID
     , EMP_NAME
     , J.JOB_NAME
     , E.SALARY
  FROM EMPLOYEE E
  JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
 WHERE J.JOB_NAME = '과장'
   AND E.SALARY > ALL (SELECT E2.SALARY
                         FROM EMPLOYEE E2
                         JOIN JOB J2 ON(E2.JOB_CODE = J2.JOB_CODE)
                        WHERE J2.JOB_NAME = '차장');

-- 자기 직급의 평균 급여를 받고 있는 직원의
-- 사번, 이름, 직급코드, 급여를 조회하세요
-- 단, 급여와 급여 평균은 만원 단위로 계산하세요 TRUNC(컬럼명, -5)
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , E.JOB_CODE
     , E.SALARY
  FROM EMPLOYEE E
 WHERE (E.JOB_CODE ,E.SALARY) IN (SELECT E2.JOB_CODE
                                       , TRUNC(AVG(E2.SALARY), -5)
                                    FROM EMPLOYEE E2
                                   GROUP BY E2.JOB_CODE);

-- 다중열 서브쿼리
-- 퇴사한 여직원과 같은 부서, 같은 직급에 해당하는
-- 사원의 이름, 직급, 부서, 입사일을 조회

SELECT
       E.EMP_NAME
     , E.JOB_CODE
     , E.DEPT_CODE
     , E.HIRE_DATE
  FROM EMPLOYEE E
 WHERE (E.DEPT_CODE, E.JOB_CODE) IN (SELECT E2.DEPT_CODE
                                          , E2.JOB_CODE
                                       FROM EMPLOYEE E2
                                      WHERE SUBSTR(E2.EMP_NO, 8, 1) = 2
                                        AND E2.ENT_YN = 'Y')
    AND E.EMP_ID != (SELECT E3.EMP_ID
                       FROM EMPLOYEE E3
                      WHERE SUBSTR(E3.EMP_NO, 8, 1) = 2
                        AND E3.ENT_YN = 'Y'
                        );
-- 인사관리부인 직원명, 부서명, 직급이름을 조회하시오 (단, FROM 부분은 인라인뷰를 사용한다)
SELECT
       V.EMP_NAME
     , V.부서명
     , V.직급이름
  FROM (SELECT E.EMP_NAME
             , D.DEPT_TITLE 부서명
             , J.JOB_NAME 직급이름
          FROM EMPLOYEE E
          LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
          JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
          ) V 
 WHERE V.부서명 = '인사관리부';
 
--급여 순위의 6~10위의 RNUM(ROWNUM)와 직원이름 급여를 인라인뷰를 활용하여 조회해보자

SELECT
       V2.RNUM
     , V2.EMP_NAME
     , V2.SALARY
  FROM (SELECT 
                ROWNUM AS RNUM
              , V.EMP_NAME
              , V.SALARY
           FROM (SELECT E.*
                   FROM EMPLOYEE E
                  ORDER BY E.SALARY DESC
                 ) V 
        ) V2
 WHERE RNUM BETWEEN 6 AND 10;
       
-- 급여 평균 3위 안에 드는 부서의
-- 부서 코드와 부서명, 평균 급여를 조회하세요 (ROWNUM사용)
SELECT
       V.부서코드
     , V.부서명
     , V.평균급여
  FROM (SELECT 
              E.DEPT_CODE 부서코드
            , D.DEPT_TITLE 부서명
            , AVG(E.SALARY) 평균급여
          FROM EMPLOYEE E
          JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
         GROUP BY E.DEPT_CODE, D.DEPT_TITLE
         ORDER BY AVG(E.SALARY) DESC) V
 WHERE ROWNUM < 4;
 
-- 직원 테이블에서 보너스를 포함한 연봉이 높은 5명의
-- 사번, 이름, 부서명, 직급명, 입사일을 조회하세요
SELECT
       V.사번
     , V.이름
     , V.부서명
     , V.직급명
     , V.입사일
  FROM (SELECT
                E.EMP_ID 사번
              , E.EMP_NAME 이름
              , D.DEPT_TITLE 부서명
              , J.JOB_NAME 직급명
              , E.HIRE_DATE 입사일
              , E.SALARY 
              , RANK() OVER(ORDER BY(E.SALARY + (E.SALARY * NVL(E.BONUS,0))) * 12 DESC) 순위
           FROM EMPLOYEE E
           LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
           JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
        ) V
 WHERE V.순위 < 6 ;
 
-- 부서별 급여 합계가 전체 급여의 총 합의 20%보다 많은
-- 부서의 부서명과, 부서별 급여 합계 조회
WITH
     TOTAL_SAL
  AS (SELECT D.DEPT_TITLE
           , SUM(E.SALARY) SSAL
        FROM EMPLOYEE E
        LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
       GROUP BY D.DEPT_TITLE
      )
SELECT
       T.DEPT_TITLE
     , T.SSAL
  FROM TOTAL_SAL T
 WHERE T.SSAL > (SELECT SUM(E2.SALARY)* 0.2
                   FROM EMPLOYEE E2);
                   
-- 관리자 사번이 EMPLOYEE 테이블에 존재하는 직원에 대한 조회
-- 직원번호, 이름, 부서코드, 담당관리자번호
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , E.DEPT_CODE
     , E.MANAGER_ID
  FROM EMPLOYEE E
 WHERE EXISTS (SELECT E2.EMP_ID
                 FROM EMPLOYEE E2
                WHERE E.MANAGER_ID = E2.EMP_ID
               );
           
-- OREDER BY 절에서 스칼라 서브쿼리 이용
-- 모든 직원의 사번, 이름, 소속부서 조회
-- 단, 부서명 내림차순 정렬
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , E.DEPT_CODE
  FROM EMPLOYEE E
 ORDER BY ( SELECT D.DEPT_TITLE
              FROM DEPARTMENT D
             WHERE E.DEPT_CODE = D.DEPT_ID
           ) DESC NULLS LAST; 

 

               
  

