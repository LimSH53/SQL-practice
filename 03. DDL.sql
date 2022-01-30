--[DDL]
--1. 계열 정보를 저장할 카테고리 테이블을 맊들려고 한다.
CREATE TABLE TB_CATAGORY(
    NAME VARCHAR2(10),
    USE_YN CHAR(1) DEFAULT 'Y'
);

--2. 과목 구분을 저장핛 테이블을 만들려고 한다. 다음과 같은 테이블을 작성하시오.
CREATE TABLE TB_CLASS_TYPE(
    NO VARCHAR2(5) PRIMARY KEY,
    NAME VARCHAR2(10)
);

--3. TB_CATAGORY 테이블의 NAME 컬럼에 PRIMARY KEY 를 생성하시오.
--(KEY 이름을 생성하지 않아도 무방함. 만일 KEY 이를 지정하고자 한다면 이름은 본인이
--알아서 적당한 이름을 사용한다.)
ALTER TABLE TB_CATAGORY ADD PRIMARY KEY (NAME);

--4. TB_CLASS_TYPE 테이블의 NAME 컬럼에 NULL 값이 들어가지 않도록 속성을 변경하시오.
ALTER TABLE TB_CLASS_TYPE MODIFY NAME NOT NULL;

--5. 두 테이블에서 컬럼 명이 NO 인 것은 기존 타입을 유지하면서 크기는 10 으로, 컬럼명이
--NAME 인 것은 마찬가지로 기존 타입을 유지하면서 크기 20 으로 변경하시오.
ALTER TABLE TB_CATAGORY
MODIFY NAME VARCHAR2(20);
ALTER TABLE TB_CLASS_TYPE
MODIFY NAME VARCHAR2(20)
MODIFY NO VARCHAR2(10);

--6. 두 테이블의 NO 컬럼과 NAME 컬럼의 이름을 각 각 TB_ 를 제외한 테이블 이름이 앞에
--붙은 형태로 변경한다.
ALTER TABLE TB_CATAGORY
RENAME COLUMN NAME TO CATAGORY_NAME;
ALTER TABLE TB_CLASS_TYPE
RENAME COLUMN NO TO CLASS_TYPE_NO;
ALTER TABLE TB_CLASS_TYPE
RENAME COLUMN NAME TO CLASS_TYPE_NAME;

--7. TB_CATAGORY 테이블과 TB_CLASS_TYPE 테이블의 PRIMARY KEY 이름을 다음과 같이 변경하시오.
ALTER TABLE TB_CATAGORY
RENAME CONSTRAINT SYS_C008531 TO PK_CATAGORY_NAME;
ALTER TABLE TB_CLASS_TYPE
RENAME CONSTRAINT SYS_C008530 TO PK_NO;

--8.다음과 같은 INSERT 문을 수행한다.
INSERT INTO TB_CATAGORY VALUES ('공학', 'Y');
INSERT INTO TB_CATAGORY VALUES ('자연과학', 'Y');
INSERT INTO TB_CATAGORY VALUES ('의학', 'Y');
INSERT INTO TB_CATAGORY VALUES ('예체능', 'Y');
INSERT INTO TB_CATAGORY VALUES ('인문사회', 'Y');
COMMIT;

--9.TB_DEPARTMENT 의 CATEGORY 컬럼이 TB_CATEGORY 테이블의 CATEGORY_NAME 컬럼을 부모
--값으로 참조하도록 FOREIGN KEY 를 지정하시오. 
--이 때 KEY 이름은 FK_테이블이름_컬럼이름으로 지정한다. (ex. FK_DEPARTMENT_CATEGORY )
ALTER TABLE TB_DEPARTMENT
  ADD CONSTRAINT FK_DEPARTMENT_CATEGORY FOREIGN KEY (CATEGORY) REFERENCES TB_CATAGORY;

--10. 춘 기술대학교 학생들의 정보만이 포함되어 있는 학생일반정보 VIEW 를 만들고자 한다.
--아래 내용을 참고하여 적절한 SQL 문을 작성하시오.
CREATE OR REPLACE VIEW VW_학생일반정보
( 학번,
  학생이름,
  주소
)
AS
SELECT STUDENT_NO
     , STUDENT_NAME
     , STUDENT_ADDRESS
  FROM TB_STUDENT;

--권한생성
GRANT CREATE VIEW TO C##HOMEWORK;

--11. 춘 기술대학교는 1 년에 두 번씩 학과별로 학생과 지도교수가 지도 면담을 진행핚다.
--이를 위해 사용할 학생이름, 학과이름, 담당교수이름 으로 구성되어 있는 VIEW 를 만드시오.
--이때 지도 교수가 없는 학생이 있을 수 있음을 고려하시오 (단, 이 VIEW 는 단순 SELECT
--만을 할 경우 학과별로 정렬되어 화면에 보여지게 만드시오.)
CREATE OR REPLACE VIEW VW_지도면담
( 학생이름,
  학과이름,
  지도교수이름
)
AS
SELECT S.STUDENT_NAME
     , D.DEPARTMENT_NAME
     , NVL(P.PROFESSOR_NAME, '지도교수 없음')
  FROM TB_STUDENT S
  LEFT JOIN TB_DEPARTMENT D ON(S.DEPARTMENT_NO = D.DEPARTMENT_NO)
  LEFT JOIN TB_PROFESSOR P ON(S.COACH_PROFESSOR_NO = P.PROFESSOR_NO)
  ORDER BY D.DEPARTMENT_NAME;

--12. 모든 학과의 학과별 학생 수를 확인할 수 있도록 적절한 VIEW 를 작성해 보자.
CREATE OR REPLACE VIEW VW_학과별학생수
( DEPARTNEMT_NAME,
  STUDENT_COUNT
)
AS
SELECT D.DEPARTMENT_NAME
     , COUNT(S.STUDENT_NO)
  FROM TB_DEPARTMENT D
  JOIN TB_STUDENT S ON (D.DEPARTMENT_NO = S.DEPARTMENT_NO)
 GROUP BY D.DEPARTMENT_NAME;

--13. 위에서 생성한 학생일반정보 View 를 통해서 학번이 A213046 인 학생의 이름을 본인
--이름으로 변경하는 SQL 문을 작성하시오
UPDATE VW_학생일반정보
   SET 학생이름 = '임연유'
 WHERE 학번 = 'A213046';

SELECT V.* FROM VW_학생일반정보 V WHERE 학번 = 'A213046';

--14.13 번에서와 같이 VIEW 를 통해서 데이터가 변경될 수 있는 상황을 막으려면 VIEW 를
--어떻게 생성해야 하는지 작성하시오.
CREATE OR REPLACE VIEW VW_학생일반정보
( 학번,
  학생이름,
  주소
)
AS
SELECT STUDENT_NO
     , STUDENT_NAME
     , STUDENT_ADDRESS
  FROM TB_STUDENT
  WITH READ ONLY;

--15. 춘 기술대학교는 매년 수강신청 기간만 되면 특정 인기 과목들에 수강 신청이 몰려
--문제가 되고 있다. (2005~2009) 기준으로 수강인원이 가장 많았던 3 과목을 찾는 구문을
--작성해보시오.
SELECT V.과목번호
     , V.과목이름
     , V."누적수강생수(명)"
  FROM (SELECT C.CLASS_NO 과목번호
             , C.CLASS_NAME 과목이름
             , COUNT(*) "누적수강생수(명)"
          FROM TB_CLASS C
          JOIN TB_GRADE G ON(C.CLASS_NO = G.CLASS_NO)
         WHERE SUBSTR(G.TERM_NO, 1, 4) IN ('2005', '2006', '2007', '2008', '2009')
         GROUP BY C.CLASS_NO, C.CLASS_NAME
         ORDER BY 3 DESC) V
 WHERE ROWNUM < 4;






