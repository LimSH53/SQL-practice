 -- DEPT_CODE 기준으로 그루핑
 SELECT
       COUNT(*)
     , DEPT_CODE
  FROM EMPLOYEE
  GROUP BY DEPT_CODE;
  
-- DEPT_CODE, JOB_CODE 기준으로 그루핑
SELECT
       DEPT_CODE
     , JOB_CODE
     , SUM(SALARY) 급여합계
     , COUNT(*) 총인원수
  FROM EMPLOYEE
 GROUP BY DEPT_CODE, JOB_CODE
 ORDER BY DEPT_CODE;
 
-- 직원 테이블에서 부서 코드별 그룹을 지정하여
-- 부서코드, 그룹별 급여의 합계, 그룹별 급여의 평균(정수처리), 인원수
-- 조회하고 부서코드 순으로 오름차순 정렬하세요
SELECT
       DEPT_CODE 부서코드
     , SUM(SALARY) 급여합계
     , FLOOR(AVG(SALARY)) 급여평균
     , COUNT(*) 인원수
  FROM EMPLOYEE
 GROUP BY DEPT_CODE
 ORDER BY 1;

-- 직원 테이블에서 직급코드별로, 보너스를 받는 사원 수를 조회하여
-- 직급코드 순으로 오름차순 정렬하세요.
SELECT
       JOB_CODE 직급코드
     , COUNT(BONUS) 보너스받는사원수
  FROM EMPLOYEE
 GROUP BY JOB_CODE
 ORDER BY 1;

-- 직원 테이블에서 직급코드, 보너스를 받는 사원 수를 조회하여
-- 직급코드 순으로 오름차순 정렬하세요.
-- 단, 보너스를 받는 사람이 없는 직급코드의 경우 RESULT SET에서 제외한다.
SELECT
       JOB_CODE
     , COUNT(BONUS)
  FROM EMPLOYEE
 WHERE BONUS IS NOT NULL
 GROUP BY JOB_CODE
 ORDER BY 1;
 
-- 직원 테이블에서 주민번호의 8번째 자리를 조회하여
-- 1이면 남, 2이면 여로 결과 조회하고
-- 성별별 급여 평균(저우처리), 급여 합계, 인원수를 조회한 뒤
-- 인원수로 내림차순 정렬하세요.
SELECT 
       DECODE(SUBSTR(EMP_NO, 8, 1), 1, '남', 2, '여') 성별
     , FLOOR(AVG(SALARY)) 급여평균
     , SUM(SALARY) 급여합계
     , COUNT(*) 인원수
  FROM EMPLOYEE
 GROUP BY DECODE(SUBSTR(EMP_NO, 8, 1), 1, '남', 2, '여')
 ORDER BY 인원수 DESC;
 
-- 300만원 이상의월급을 받는 사원들을 대상으로
-- 부서별 그룹 월급 평균 계산
SELECT
       DEPT_CODE
     , FLOOR(AVG(SALARY)) 평균
  FROM EMPLOYEE
 WHERE SALARY >= 3000000
 GROUP BY DEPT_CODE
 ORDER BY 1;
 
-- 모든 직원을 대상으로 부서별 월급 평균을 구한 뒤
-- 평균이 300만원 이상인 부서 조회
SELECT
       DEPT_CODE
     , FLOOR(AVG(SALARY)) 평균
  FROM EMPLOYEE
 GROUP BY DEPT_CODE
HAVING FLOOR(AVG(SALARY)) > 3000000
 ORDER BY 1;
 
-- 급여 합계가 가장 많은 부서의 부서코드와 급여 합계를 구하세요
SELECT
       DEPT_CODE
     , FLOOR(SUM(SALARY)) 급여합계
  FROM EMPLOYEE
 GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (SELECT
                             MAX(SUM(SALARY))
                        FROM EMPLOYEE
                       GROUP BY DEPT_CODE);
                       
-- 부서 테이블과 지역 테이블을 조인하여 테이블에 있는 모든 테이터를 조회하세요
-- ANSI 표준
SELECT
      *
  FROM DEPARTMENT D
  JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE);

-- 오라클 전용
SELECT
      *
  FROM DEPARTMENT D
     , LOCATION L
 WHERE D.LOCATION_ID = L.LOCAL_CODE;
 
-- 직급이 대리이면서 아시아 지역에 근무하는 직원 조회
-- 사번, 이름, 직급명, 부서명, 근무지역명, 급여 조회
-- (조회시에는 모든 컬럼에 테이블 별칭을 사용하는 것이 좋다)
-- ANSI 표준
SELECT
       E.EMP_ID
     , E.EMP_NAME
     , J.JOB_NAME
     , D.DEPT_TITLE
     , L.LOCAL_NAME
     , E.SALARY
  FROM EMPLOYEE E
  JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
  JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE)
 WHERE J.JOB_NAME ='대리'
   AND L.LOCAL_NAME LIKE 'ASIA%';
-- 오라클 전용

                       


     