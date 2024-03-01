-- Queries for kleague Sample Database
-- Version 1.0

USE kleague;

DESCRIBE PLAYER;
DESCRIBE TEAM;
DESCRIBE STADIUM;
DESCRIBE SCHEDULE;


-------------------------------------------
-- 1. DML : UPDATE 문
-------------------------------------------

-------------------------------------------
-- 1.1 INSERT 문
-------------------------------------------

-- 일반 형식 1

SELECT	*
FROM 	PLAYER
WHERE 	PLAYER_NAME LIKE '박%'
ORDER 	BY PLAYER_NAME;

INSERT INTO 	PLAYER (PLAYER_ID, PLAYER_NAME, TEAM_ID, POSITION, HEIGHT, WEIGHT, BACK_NO) 
VALUES 			('2002007', '박지성', 'K07', 'MF', 178, 73, 7);

SELECT 	*
FROM 	PLAYER
WHERE 	PLAYER_NAME LIKE '박%'
ORDER 	BY PLAYER_NAME;

------------------------------

SELECT 	*
FROM 	PLAYER
WHERE 	PLAYER_NAME LIKE '이%'
ORDER 	BY PLAYER_NAME;

INSERT INTO 	PLAYER 
VALUES 			('2002010','이청용','K07','','BlueDragon','2002','MF','17',NULL,NULL,'1',180,69);

SELECT 	*
FROM 	PLAYER
WHERE 	PLAYER_NAME LIKE '이%'
ORDER 	BY PLAYER_NAME;


-- 일반 형식 2

CREATE TABLE	BLUE_DRAGON_TEAM1 (
	PLAYER_ID   CHAR(7) 		NOT NULL,       
	PLAYER_NAME VARCHAR(20) 	NOT NULL,       
	BACK_NO		TINYINT
);

INSERT INTO 	BLUE_DRAGON_TEAM1
SELECT	PLAYER_ID, PLAYER_NAME, BACK_NO
FROM	PLAYER
WHERE	TEAM_ID = 'K07';

SELECT	*
FROM	BLUE_DRAGON_TEAM1;


-- CTAS와 비교

CREATE TABLE 	BLUE_DRAGON_TEAM2 AS
SELECT	PLAYER_ID, PLAYER_NAME, BACK_NO
FROM	PLAYER
WHERE	TEAM_ID = 'K07';

SELECT	*
FROM	BLUE_DRAGON_TEAM2;
/*CTAS는 없는 테이블을 생성하는 명령어*/
/*INSERT INTO SELECT FROM은 이미 존재하는 테이블에 SELECT해서 INSERT하는 명령어*/
-------------------------------------------
-- 1.2 DELETE 문
-------------------------------------------

SELECT	*
FROM	PLAYER
WHERE	PLAYER_ID = '2002007';			/* 단 하나의 투플만 검색 */

DELETE FROM 	PLAYER
WHERE 			PLAYER_ID = '2002007';

SELECT	*
FROM	PLAYER
WHERE	PLAYER_ID = '2002007';	

-----------------------------

SELECT	*
FROM	PLAYER
WHERE	POSITION = 'GK';				/* 여러개 투플을 검색 */

DELETE FROM 	PLAYER
WHERE			POSITION = 'GK';		/* 에러 */


-- safe_update mode

DELETE FROM 	PLAYER;		/* 에러: safe_update mode로 동작하면, WHERE 절이 없는 DELETE 문은 실행되지 않음. */
							/* 메뉴의 Edit - Preferences - SQL Editor - Other 수정 */
                            
SET sql_safe_updates=0;		/* Turn off 'Safe Update Mode' */

DELETE FROM 	PLAYER
WHERE			POSITION = 'GK';

SELECT	*
FROM	PLAYER
WHERE	POSITION = 'GK';

DELETE FROM 	PLAYER;

SELECT	*
FROM	PLAYER;

SET sql_safe_updates=1;	


-------------------------------------------
-- 1.3 UPDATE 문
-------------------------------------------

-- kleague DB를 초기화한 후, 아래 질의를 실행

SELECT	*
FROM	PLAYER
WHERE	PLAYER_ID = '2000001';

UPDATE	PLAYER
SET		BACK_NO = 99
WHERE	PLAYER_ID = '2000001';

SELECT	*
FROM	PLAYER
WHERE	PLAYER_ID = '2000001';


-- safe_update mode

SELECT	*
FROM	PLAYER;

UPDATE	PLAYER
SET		BACK_NO = 99;		/* 에러 */

SET sql_safe_updates=0;		/* Turn off 'Safe Update Mode' */

UPDATE	PLAYER
SET		BACK_NO = 99;

SELECT	*
FROM	PLAYER;

SET sql_safe_updates=1;


-------------------------------------------
-- 2. DML : SELECT 문
-------------------------------------------

-------------------------------------------
-- 2.1 SELECT 절
-------------------------------------------

-- kleague DB를 초기화한 후, 아래 질의를 실행

-- SELECT 절

SELECT	PLAYER_ID, PLAYER_NAME, TEAM_ID, POSITION, BACK_NO, HEIGHT,	WEIGHT 
FROM 	PLAYER;

SELECT	* 
FROM	PLAYER;

-----------------------------

SELECT DISTINCT	POSITION /*SELECT문 조건: ALL(중복 허용, 디폴트값) ,DISTINT(중복 제거) */
FROM			PLAYER; 

SELECT ALL 		POSITION 
FROM			PLAYER; 

SELECT	POSITION /* DEFAULT = ALL */
FROM	PLAYER; 


-- Column alias

SELECT	PLAYER_NAME AS 선수명, POSITION AS 위치, HEIGHT AS 키, WEIGHT AS 몸무게  /* 출력 시 COLUMN명이 ALIAS로 보임*/
FROM 	PLAYER;  

SELECT	PLAYER_NAME 선수명, POSITION 위치, HEIGHT 키, WEIGHT 몸무게 /* AS 생략 가능 */
FROM 	PLAYER;  

SELECT	PLAYER_NAME AS 선수명, POSITION AS 위치, HEIGHT AS 키, WEIGHT AS 몸무게 
FROM 	PLAYER
WHERE	선수명 = '김태호';						/* 에러: PLAYER_NAME = '김태호' */
/*WHERE절에는 alias사용 불가능*/
-----------------------------

SELECT	PLAYER_NAME '선수 이름', POSITION '그라운드 포지션', HEIGHT 키, WEIGHT 몸무게 
FROM 	PLAYER;


-- 산술연산자

SELECT 	PLAYER_NAME 이름, ROUND(WEIGHT/((HEIGHT/100)*(HEIGHT/100)),2) 'BMI 비만지수' 
FROM 	PLAYER;


-- 스트링 합성연산자

SELECT	'MySQL' 'String' 'Concatenation';  /* 'MySQL String Concat' */

SELECT	'MySQL' PLAYER_NAME 'String' 'Concatenation'
FROM	PLAYER;  										/* 에러: 컬럼명은 ''로 이어붙일 수 없음*/

SELECT 	CONCAT('MySQL', PLAYER_NAME, 'String', 'Concatenation')
FROM 	PLAYER;

SELECT 	CONCAT(PLAYER_NAME, '선수,', HEIGHT, 'cm,', WEIGHT, 'kg') AS 체격정보 
FROM 	PLAYER;


-------------------------------------------
-- 2.2 WHERE 절
-------------------------------------------

-- 비교연산자
        
SELECT 	TEAM_ID, PLAYER_NAME 선수이름, POSITION 포지션, BACK_NO 백넘버, HEIGHT 키 
FROM 	PLAYER 
WHERE 	(TEAM_ID = 'K02' OR TEAM_ID = 'K07') AND 
		POSITION <> 'MF' AND 
		HEIGHT >= 170 AND HEIGHT <= 180;


-- IN 연산자 

SELECT 	TEAM_ID, PLAYER_NAME 선수이름, POSITION 포지션, BACK_NO 백넘버, HEIGHT 키 
FROM 	PLAYER 
WHERE 	TEAM_ID IN ('K02','K07'); 		/* TEAM_ID = 'K02' OR TEAM_ID = 'K07' */

SELECT 	PLAYER_NAME, TEAM_ID, POSITION, NATION
FROM 	PLAYER 
WHERE 	(POSITION, NATION) IN (('MF','브라질'), ('FW', '러시아')); 

SELECT 	PLAYER_NAME, TEAM_ID, POSITION, NATION
FROM 	PLAYER 
WHERE 	POSITION IN ('MF', 'FW') AND NATION IN ('브라질', '러시아');


-- LIKE 연산자

SELECT 	PLAYER_NAME 선수이름, POSITION 포지션, BACK_NO 백넘버, HEIGHT 키 
FROM 	PLAYER 
WHERE 	POSITION LIKE 'MF';	

SELECT 	PLAYER_NAME 선수이름, POSITION 포지션, BACK_NO 백넘버, HEIGHT 키 
FROM 	PLAYER 
WHERE 	PLAYER_NAME LIKE '장%';


-- BETWEEN a AND b 연산자

SELECT 	PLAYER_NAME 선수이름, POSITION 포지션, BACK_NO 백넘버, HEIGHT 키 
FROM 	PLAYER 
WHERE 	HEIGHT BETWEEN 170 AND 180;			/* HEIGHT >= 170 AND HEIGHT <= 180 */


-- IS NULL 연산자

SELECT 	PLAYER_NAME 선수이름, POSITION 포지션, TEAM_ID 
FROM 	PLAYER 
WHERE 	POSITION = NULL;		/* 'POSITION = NULL'은 항상 FALSE를 리턴함 (NULL과의 비교는 항상 FALSE)*/ 

SELECT 	PLAYER_NAME 선수이름, POSITION 포지션, TEAM_ID 
FROM 	PLAYER 
WHERE 	POSITION IS NULL;


-- 논리연산자

SELECT 	PLAYER_NAME 선수이름, POSITION 포지션, BACK_NO 백넘버, HEIGHT 키 
FROM 	PLAYER 
WHERE 	(TEAM_ID = 'K02' OR TEAM_ID = 'K07') AND
		POSITION = 'MF' AND 
		HEIGHT >= 170 AND HEIGHT <= 180;  

SELECT 	PLAYER_NAME 선수이름, POSITION 포지션, BACK_NO 백넘버, HEIGHT 키 
FROM 	PLAYER 
WHERE 	TEAM_ID IN ('K02','K07') AND
		POSITION = 'MF' AND 
		HEIGHT BETWEEN 170 AND 180;


-------------------------------------------
-- 2.3 내장함수
-------------------------------------------

-------------------------------------------
-- 2.3.1 문자형 내장함수
-------------------------------------------

SELECT 	LENGTH('SQL Expert') AS ColumnLength; 

SELECT 	PLAYER_ID, CONCAT(PLAYER_NAME, ' 선수') AS 선수명 
FROM 	PLAYER;


-------------------------------------------
-- 2.3.2 숫자형 내장함수
-------------------------------------------

SELECT 	ROUND(SUM(HEIGHT)/COUNT(HEIGHT),1) AS '평균키(소수 둘째자리 올림)', 
		TRUNCATE(SUM(HEIGHT)/COUNT(HEIGHT),1) AS '평균키(소수 둘째자리 버림)'
FROM 	PLAYER;


-------------------------------------------
-- 2.3.3 날짜형 내장함수
-------------------------------------------

SELECT 	SYSDATE() AS CurrentTime;		/* 현재 시간 */

SELECT 	NOW() AS CurrentTime;			/* 명령어가 실행된 시작 시간 */

-----------------------------

SELECT 	SYSDATE(), SLEEP(5), SYSDATE();
 
SELECT 	NOW(), SLEEP(5), NOW();			/* SELECT 명령어가 실행된 시작 시간 */

-----------------------------

CREATE TABLE movie ( 
	id 			INT 			PRIMARY KEY AUTO_INCREMENT, 	/* surrogate */
	title 		VARCHAR(255) 	NOT NULL, 
	created_on 	DATETIME 		NOT NULL DEFAULT NOW() 		/* 투플이 삽입된 시간(INSERT 문이 실해된 시간)을 기록 */
); 

INSERT INTO movie (title)
VALUES		('Top Gun');

INSERT INTO movie (title)
VALUES		('Money Ball');

SELECT	*
FROM	movie;

-----------------------------

SELECT 	TIMESTAMP(NOW()) AS CurrentTimestamp,
		DATE(NOW()) AS CurrentDate,
		YEAR(NOW()) AS Year, 
		MONTH(NOW()) AS Month, 
        DAY(NOW()) AS Day,
        MONTHNAME(NOW()) AS MonthName,
        DAYNAME(NOW()) AS DayName,
        WEEKDAY(NOW()) AS WeekIndex,
		TIME(NOW()) AS CurrentTime,
        HOUR(NOW()) AS Hour,
        MINUTE(NOW()) AS Minute,
        SECOND(NOW()) AS Second;

-----------------------------

SELECT EXTRACT(DAY FROM '2017-07-14 09:04:44') DAY;
SELECT EXTRACT(DAY_HOUR FROM '2017-07-14 09:04:44') DAYHOUR;
SELECT EXTRACT(DAY_MICROSECOND FROM '2017-07-14 09:04:44') DAY_MS;
SELECT EXTRACT(DAY_SECOND FROM '2017-07-14 09:04:44') DAY_S;
SELECT EXTRACT(HOUR_SECOND FROM '2017-07-14 09:04:44') HOUR_S;
SELECT EXTRACT(MINUTE_SECOND FROM '2017-07-14 09:04:44') MINUTE_S;
SELECT EXTRACT(WEEK FROM '2017-07-14 09:04:44') WEEK;

-----------------------------

/* 아래 두 명령어의 결과는 동일함. */

SELECT	PLAYER_NAME, 
		YEAR(BIRTH_DATE) 출생년도, 
		MONTH(BIRTH_DATE) 출생월, 
        DAY(BIRTH_DATE) 출생일 
FROM	PLAYER;

SELECT	PLAYER_NAME, 
		EXTRACT(YEAR FROM BIRTH_DATE) 출생년도, 
		EXTRACT(MONTH FROM BIRTH_DATE) 출생월, 
        EXTRACT(DAY FROM BIRTH_DATE) 출생일
FROM	PLAYER;

-----------------------------

SELECT	DATEDIFF('2009-03-01', '2009-01-01') diff; 

SELECT	TIMEDIFF('2009-02-01 00:00:00', '2009-01-01 00:00:00') diff; 	/* 최대값 838:59:59 (TIME은 3 바이드) */ 
SHOW WARNINGS;

SELECT	TIMEDIFF('2009-03-01 00:00:00', '2009-01-01 00:00:00') diff;	/* 범위 에러, 정답은 1416:00:00 */
SHOW WARNINGS;

SELECT	TIMESTAMPDIFF(HOUR, '2009-01-01 00:00:00', '2009-03-01 00:00:00') diff; 

SELECT	TIMESTAMPDIFF(MINUTE, '2010-01-01 10:00:00', '2010-01-01 10:45:59') diff;

SELECT	TIMESTAMPDIFF(SECOND, '2010-01-01 10:00:00', '2010-01-01 10:45:59') diff;

-----------------------------

SELECT	TIMESTAMPDIFF(YEAR, '2000-08-02', '2020-05-15'),
		YEAR('2020-05-15') - YEAR('2000-08-02');

SELECT	PLAYER_NAME AS 선수명, BIRTH_DATE AS 생일,
		TIMESTAMPDIFF(YEAR, BIRTH_DATE, DATE(NOW())) AS 나이,
        FLOOR(DATEDIFF(DATE(NOW()), BIRTH_DATE) / 365) AS 나이
FROM	PLAYER;

-----------------------------

SELECT	DATE_ADD('1999-12-31 00:00:01', INTERVAL 1 DAY) result;
SELECT	DATE_ADD('1999-12-31 23:59:59',	INTERVAL '1:1' MINUTE_SECOND) result;
SELECT	DATE_ADD('2000-01-01 00:00:00', INTERVAL '-1 5' DAY_HOUR) result;
SELECT	DATE_ADD('1999-12-31 23:59:59.000002', INTERVAL '1.999999' SECOND_MICROSECOND) result;

SELECT	DATE_ADD('2000-01-01', INTERVAL 12 HOUR) result;	/* 자동 타입 변환: DATE -> DATETIME */

SELECT	DATE_ADD('2010-01-30', INTERVAL 1 MONTH) result;	/* 2010-02-28 */
SELECT	DATE_ADD('2012-01-30', INTERVAL 1 MONTH) result;	/* 2012-02-29 */

-----------------------------

SELECT	PLAYER_NAME, 
		DATE_FORMAT(BIRTH_DATE, '%Y-%m-%d'),
		DATE_FORMAT(BIRTH_DATE, '%D %M %Y')
FROM	PLAYER;

SELECT 	DATE_FORMAT('2003-03-31', GET_FORMAT(DATE, 'ISO')) AS ISO, 
		DATE_FORMAT('2003-03-31', GET_FORMAT(DATE, 'JIS')) AS JIS,
		DATE_FORMAT('2003-03-31', GET_FORMAT(DATE, 'USA')) AS USA, 
		DATE_FORMAT('2003-03-31', GET_FORMAT(DATE, 'EUR')) AS EUR, 
		DATE_FORMAT('2003-03-31', GET_FORMAT(DATE, 'INTERNAL')) AS INTERNAL; 

SELECT	PLAYER_NAME, POSITION,
		DATE_FORMAT(BIRTH_DATE, GET_FORMAT(DATE, 'ISO')) BIRTH_DATE
FROM	PLAYER;

-----------------------------

SELECT	STR_TO_DATE('21,5,2013', '%d,%m,%Y');	/* 2013-05-21 */
SELECT	STR_TO_DATE('2013', '%Y');				/* 2013-00-00 */
SELECT	STR_TO_DATE('113005', '%h%i%s');		/* 11:30:05 */
SELECT	STR_TO_DATE('11', '%h');				/* 11:00:00 */
SELECT	STR_TO_DATE('20130101 1130', '%Y%m%d %h%i');	/* 2013-01-01 11:30:00*/
SELECT	STR_TO_DATE('21,5,2013 extra characters', '%d,%m,%Y');	/* 2013-05-21 */


-------------------------------------------
-- 2.3.4 변환형 내장함수
-------------------------------------------

SELECT	CONCAT('Date: ', CAST(NOW() AS DATE));

SELECT 	TEAM_ID, ZIP_CODE1, ZIP_CODE2,
		CONCAT(ZIP_CODE1, '-', ZIP_CODE2) AS 우편번호,
		CAST(ZIP_CODE1 AS UNSIGNED) + CAST(ZIP_CODE2 AS UNSIGNED) 우편번호합 
FROM 	TEAM;

SELECT CONVERT('test' USING utf8);


-------------------------------------------
-- 2.3.5 NULL 관련 함수 : 표준 함수
-------------------------------------------

-- COALESCE() 함수

SELECT	COALESCE(NULL, 1);

SELECT	COALESCE(NULL, NULL, NULL);

SELECT	PLAYER_NAME, 
		COALESCE(POSITION, '*****') AS POSITION, 	/* 문자형 데이타가 널일 때, '*****'로 대치 */
		COALESCE(HEIGHT, 0) AS HEIGHT				/* 숫자형 데이타가 널일 때, 0으로 대치 */
FROM	PLAYER
WHERE	TEAM_ID = 'K08';

-----------------------------

SELECT	PLAYER_NAME, E_PLAYER_NAME, NICKNAME, 
		COALESCE(E_PLAYER_NAME, NICKNAME) AS 별칭
FROM	PLAYER;

SELECT	PLAYER_NAME, E_PLAYER_NAME, NICKNAME,
		CASE	
				WHEN 	E_PLAYER_NAME IS NOT NULL 	THEN E_PLAYER_NAME
                ELSE	(
						CASE	
								WHEN NICKNAME IS NOT NULL	THEN NICKNAME
								ELSE NULL
						END) 
		END AS 별칭
FROM	PLAYER;

-----------------------------

SELECT	PLAYER_ID, PLAYER_NAME, HEIGHT, WEIGHT, (HEIGHT * 10) + WEIGHT
FROM	PLAYER;

SELECT	PLAYER_ID, PLAYER_NAME, HEIGHT, WEIGHT, 
		(HEIGHT * 10) + WEIGHT AS TEST1, 
        (HEIGHT * 10) + COALESCE(WEIGHT,0) AS TEST2,
        (COALESCE(HEIGHT,0) * 10) + WEIGHT AS TEST3,
        (COALESCE(HEIGHT,0) * 10) + COALESCE(WEIGHT,0) AS TEST4
FROM	PLAYER;

-----------------------------

SELECT	PLAYER_ID, PLAYER_NAME, HEIGHT, WEIGHT
FROM	PLAYER;

SELECT	HEIGHT
FROM	PLAYER
WHERE	PLAYER_NAME = '김태호';

SELECT	COALESCE(HEIGHT,0) AS HEIGHT
FROM	PLAYER
WHERE	PLAYER_NAME = '김태호';

SELECT	HEIGHT
FROM	PLAYER
WHERE	PLAYER_NAME = '손흥민';

SELECT	COALESCE(HEIGHT,99999) AS HEIGHT
FROM	PLAYER
WHERE	PLAYER_NAME = '손흥민';		/* COALESCE() 함수의 잘 못된 사용 */

SELECT	MAX(HEIGHT)					/* 집단 함수는 널을 추력함 */
FROM	PLAYER
WHERE	PLAYER_NAME = '손흥민';

SELECT	COALESCE(MAX(HEIGHT),99999) AS HEIGHT
FROM	PLAYER
WHERE	PLAYER_NAME = '손흥민';


-- NULLIF() 함수

SELECT	TEAM_NAME, ORIG_YYYY, NULLIF(ORIG_YYYY, 1983) AS NULLIF_1983
FROM	TEAM;

SELECT	TEAM_NAME, ORIG_YYYY, 
		CASE	
				WHEN ORIG_YYYY = '1983'		THEN NULL
                ELSE ORIG_YYYY
		END AS NULLIF_1983
FROM	TEAM;

-----------------------------

-- NULL 관련 함수 : 비표준 함수

-- IFNULL() 함수 (COALESCE() 함수와 동일한 MySQL의 비표준 함수임)

SELECT	PLAYER_NAME, 
		IFNULL(POSITION, '*****') AS POSITION,
		IFNULL(HEIGHT, 0) AS HEIGHT
FROM	PLAYER
WHERE	TEAM_ID = 'K08';


-- ISNULL() 함수 (IS NULL 연산자를 함수로 표현한 것)

SELECT 	PLAYER_NAME 선수명, POSITION, 
		CASE 	
				WHEN ISNULL(POSITION)	THEN '없음'
				ELSE POSITION 
		END AS 포지션 
FROM 	PLAYER 
WHERE 	TEAM_ID = 'K08';


-------------------------------------------
-- 2.3.6 조건절 관련 함수와 CASE 절
-------------------------------------------

-- Simple case expression과 & searched case expression

SELECT	PLAYER_NAME,
		CASE	POSITION
				WHEN 'FW'	THEN 'Forward'
                WHEN 'DF'	THEN 'Defense'
                WHEN 'MF'	THEN 'Mid-field'
                WHEN 'GK'	THEN 'Goal keeper'
                ELSE 'Undefined'
		END AS 포지션
FROM 	PLAYER;

SELECT	PLAYER_NAME,
		CASE	
				WHEN POSITION = 'FW'	THEN 'Forward'
                WHEN POSITION = 'DF'	THEN 'Defense'
                WHEN POSITION = 'MF'	THEN 'Mid-field'
                WHEN POSITION = 'GK'	THEN 'Goal keeper'
                ELSE 'Undefined'
		END AS 포지션
FROM 	PLAYER;


-- 중첩된 case expressions

SELECT	PLAYER_NAME, HEIGHT,
		CASE
				WHEN    HEIGHT >= 185		THEN 'A'
				ELSE 	(
							CASE
									WHEN HEIGHT >= 175		THEN 'B'
									WHEN HEIGHT < 175		THEN 'C'
									WHEN HEIGHT IS NULL		THEN 'Undecided'
							END
                        )
		END AS '신장 그룹'
FROM	PLAYER;


-- IF() 함수

SELECT	PLAYER_NAME,
		IF(POSITION = 'FW', 'Forward', 
			IF(POSITION = 'DF', 'Defense', 
				IF(POSITION = 'MF', 'Mid-field', 
					IF(POSITION = 'GK', 'Goal keeper', 'Undefined')
				)
			)
		) AS 포지션
FROM 	PLAYER;


-------------------------------------------
-- 2.4 GROUP BY / HAVING 절
-------------------------------------------

-- 집단 함수: COUNT() 함수

SELECT	COUNT(PLAYER_ID), COUNT(*)			/* 널이 아닌 값의 갯수를 세는 함수 */
FROM	PLAYER;

SELECT	COUNT(PLAYER_ID), COUNT(TEAM_ID), COUNT(POSITION), COUNT(BACK_NO), COUNT(HEIGHT)
FROM	PLAYER;

SELECT	COUNT(PLAYER_ID), COUNT(DISTINCT TEAM_ID), COUNT(DISTINCT POSITION), COUNT(DISTINCT BACK_NO), COUNT(DISTINCT HEIGHT)
FROM	PLAYER;


-- 집단 함수

SELECT 	ROUND(SUM(HEIGHT)/COUNT(*),1) AS '잘못된 평균키', 
		ROUND(SUM(HEIGHT)/COUNT(HEIGHT),1) AS '올바른 평균키', 
        ROUND(AVG(HEIGHT),1) AS 'AVG 함수'
FROM 	PLAYER;


-- GROUP BY 절

SELECT 	*
FROM 	PLAYER;

SELECT 	POSITION 포지션, COUNT(*) 인원수, COUNT(HEIGHT) 키대상,			/* COUNT(HEIGHT)는 0 */
		MAX(HEIGHT) 최대키, MIN(HEIGHT) 최소키,
		ROUND(AVG(HEIGHT),2) 평균키 
FROM 	PLAYER 
GROUP 	BY POSITION;

SELECT 	POSITION, HEIGHT	/* 위 질의 실행시 DBMS가 내부적으로 유지하는 임시 PLAYER 테이블의 모습 */
FROM 	PLAYER;

-----------------------------

SELECT 	POSITION 포지션, COUNT(*) 인원수, COUNT(HEIGHT) 키대상,
		MAX(HEIGHT) 최대키, MIN(HEIGHT) 최소키,
		ROUND(AVG(HEIGHT),2) 평균키, TEAM_ID		/* 그루핑 기준 컬럼과 집단함수의 컬럼 이외의 컬럼이 있음 (TEAM_ID) */
FROM 	PLAYER 
GROUP 	BY POSITION;		/* 이  문장은 표준 SQL에서는 에러이나, MySQL에서는 에러가 아님. */


-- HAVING 절

/* 그룹핑 기준 컬럼을 사용하여 그룹_조건식 서술 */

SELECT 	TEAM_ID 팀아이디, COUNT(*) 인원수 
FROM 	PLAYER
GROUP 	BY TEAM_ID;

SELECT 	TEAM_ID 팀아이디, COUNT(*) 인원수 
FROM 	PLAYER 
GROUP 	BY TEAM_ID  HAVING TEAM_ID IN ('K09', 'K02');	/* 그룹_조건식 */

SELECT 	TEAM_ID 팀ID, COUNT(*) 인원수 
FROM 	PLAYER 
WHERE 	TEAM_ID IN ('K09', 'K02') 		/* 투플_조건식 */
GROUP 	BY TEAM_ID;						/* 같은 결과이나, 성능이 더 좋음 */

-----------------------------

/* 그룹핑 기준 컬럼을 사용하여 그룹_조건식 서술 */

SELECT	PLAYER_NAME AS '선수 이름', COUNT(PLAYER_NAME) AS '동명이인의 인원수'
FROM	PLAYER
GROUP 	BY PLAYER_NAME 	HAVING	COUNT(PLAYER_NAME) >= 2;

-----------------------------

/* 집단함수에서 사용한 컬럼을 사용하여 그룹_조건식 서술 */

SELECT	POSITION 포지션, ROUND(AVG(HEIGHT),2) 평균키 
FROM 	PLAYER 
GROUP 	BY POSITION   HAVING AVG(HEIGHT) >= 180;

SELECT	POSITION 포지션, ROUND(AVG(HEIGHT),2) 평균키 
FROM 	PLAYER
WHERE 	AVG(HEIGHT) >= 180							/* 에러: WHERE 절에는 집단 함수를 사욜할 수 없음. */
GROUP 	BY POSITION;

-----------------------------

/* 아래 두 명령어의 결과는 동일함. */    
    
SELECT POSITION, AVG(HEIGHT)
FROM   PLAYER
GROUP BY POSITION HAVING AVG(HEIGHT) > 180;			/* AVG 함수가 두 번 실행되나, 선택된 그룹에 대해서만 실행됨. */

WITH TEMP AS (
	SELECT POSITION, AVG(HEIGHT) AS AVG_HEIGHT
	FROM   PLAYER
	GROUP BY POSITION
)
SELECT	POSITION, AVG_HEIGHT
FROM	TEMP
WHERE	AVG_HEIGHT > 180;							/* AVG 함수가 한 번 실행되나, 모든 그룹에 대해 실행됨 */

-----------------------------

-- CASE 절과 GROUP BY 절의 활용 1 (팀별로 각 생년월의 선수 평균 키를 구하라.)

SELECT	PLAYER_NAME, TEAM_ID, BIRTH_DATE, MONTH(BIRTH_DATE) AS MONTH, HEIGHT	/* 1단계 */
FROM	PLAYER;

SELECT	PLAYER_NAME, TEAM_ID, BIRTH_DATE,									/* 2단계 */
		CASE MONTH(BIRTH_DATE) WHEN 1 THEN HEIGHT END M01,
        CASE MONTH(BIRTH_DATE) WHEN 2 THEN HEIGHT END M02,
		CASE MONTH(BIRTH_DATE) WHEN 3 THEN HEIGHT END M03,
        CASE MONTH(BIRTH_DATE) WHEN 4 THEN HEIGHT END M04,
        CASE MONTH(BIRTH_DATE) WHEN 5 THEN HEIGHT END M05,
        CASE MONTH(BIRTH_DATE) WHEN 6 THEN HEIGHT END M06,
        CASE MONTH(BIRTH_DATE) WHEN 7 THEN HEIGHT END M07,
        CASE MONTH(BIRTH_DATE) WHEN 8 THEN HEIGHT END M08,
        CASE MONTH(BIRTH_DATE) WHEN 9 THEN HEIGHT END M09,
        CASE MONTH(BIRTH_DATE) WHEN 10 THEN HEIGHT END M10,
        CASE MONTH(BIRTH_DATE) WHEN 11 THEN HEIGHT END M11,
        CASE MONTH(BIRTH_DATE) WHEN 12 THEN HEIGHT END M12,
        CASE WHEN MONTH(BIRTH_DATE) IS NULL THEN HEIGHT END 생일모름
FROM	PLAYER;    

SELECT	TEAM_ID, COUNT(*) AS 선수수,												/* 3단계 */
		ROUND(AVG(CASE MONTH(BIRTH_DATE) WHEN 1 THEN HEIGHT END),2) M01,
        ROUND(AVG(CASE MONTH(BIRTH_DATE) WHEN 2 THEN HEIGHT END),2) M02,
		ROUND(AVG(CASE MONTH(BIRTH_DATE) WHEN 3 THEN HEIGHT END),2) M03,
        ROUND(AVG(CASE MONTH(BIRTH_DATE) WHEN 4 THEN HEIGHT END),2) M04,
        ROUND(AVG(CASE MONTH(BIRTH_DATE) WHEN 5 THEN HEIGHT END),2) M05,
        ROUND(AVG(CASE MONTH(BIRTH_DATE) WHEN 6 THEN HEIGHT END),2) M06,
        ROUND(AVG(CASE MONTH(BIRTH_DATE) WHEN 7 THEN HEIGHT END),2) M07,
        ROUND(AVG(CASE MONTH(BIRTH_DATE) WHEN 8 THEN HEIGHT END),2) M08,
        ROUND(AVG(CASE MONTH(BIRTH_DATE) WHEN 9 THEN HEIGHT END),2) M09,
        ROUND(AVG(CASE MONTH(BIRTH_DATE) WHEN 10 THEN HEIGHT END),2) M10,
        ROUND(AVG(CASE MONTH(BIRTH_DATE) WHEN 11 THEN HEIGHT END),2) M11,
        ROUND(AVG(CASE MONTH(BIRTH_DATE) WHEN 12 THEN HEIGHT END),2) M12,
        ROUND(AVG(CASE WHEN MONTH(BIRTH_DATE) IS NULL THEN HEIGHT END),2) 생일모름
FROM	PLAYER
GROUP	BY TEAM_ID;
 
------------------------------
-- CASE 절과 GROUP BY 절의 활용 2 (팀별로 각 포지션의 인원수, 그리고 팀의 전체 인원수를 구하라.) 

SELECT	PLAYER_NAME, TEAM_ID, 										/* 1단계 */
		CASE POSITION WHEN 'FW' THEN 1 ELSE 0 END FW, 
		CASE POSITION WHEN 'MF' THEN 1 ELSE 0 END MF,
		CASE POSITION WHEN 'DF' THEN 1 ELSE 0 END DF,
		CASE POSITION WHEN 'GK' THEN 1 ELSE 0 END GK,
        CASE WHEN POSITION IS NULL THEN 1 ELSE 0 END UNDECIDED
FROM 	PLAYER
ORDER   BY TEAM_ID, PLAYER_NAME;

SELECT	TEAM_ID, 													/* 2단계 */
		SUM(CASE POSITION WHEN 'FW' THEN 1 ELSE 0 END) FW, 
		SUM(CASE POSITION WHEN 'MF' THEN 1 ELSE 0 END) MF,
		SUM(CASE POSITION WHEN 'DF' THEN 1 ELSE 0 END) DF,
		SUM(CASE POSITION WHEN 'GK' THEN 1 ELSE 0 END) GK,
        SUM(CASE WHEN POSITION IS NULL THEN 1 ELSE 0 END) UNDECIDED,	/* K08 팀을 확인할 것 */
        COUNT(*) SUM
FROM 	PLAYER
GROUP	BY TEAM_ID;

-----------------------------

SELECT	TEAM_ID, 
		SUM(CASE POSITION WHEN 'FW' THEN 1 ELSE 0 END) FW, 
		SUM(CASE POSITION WHEN 'MF' THEN 1 ELSE 0 END) MF,
		SUM(CASE POSITION WHEN 'DF' THEN 1 ELSE 0 END) DF,
		SUM(CASE POSITION WHEN 'GK' THEN 1 ELSE 0 END) GK,
        SUM(CASE POSITION WHEN NULL THEN 1 ELSE 0 END) UNDECIDED,		/* 에러가 발생하지는 않으나, POSITION = NULL 은 항상 false */
        COUNT(*) SUM
FROM 	PLAYER
GROUP	BY TEAM_ID;


-------------------------------------------
-- 2.5 ORDER BY 절
-------------------------------------------

SELECT 	PLAYER_NAME 선수명, POSITION 포지션, BACK_NO 백넘버 
FROM 	PLAYER 
ORDER 	BY 포지션 ASC; 				/** NULL이 처음에 위치함. */

SELECT 	PLAYER_NAME 선수이름, POSITION 포지션, BACK_NO 백넘버, HEIGHT 키 
FROM 	PLAYER 
WHERE 	HEIGHT IS NOT NULL 			/* '키 IS NOT NULL'은 에러 */
ORDER 	BY 키 DESC, BACK_NO; 

SELECT 	PLAYER_NAME 선수명, POSITION 포지션, BACK_NO 백넘버
FROM 	PLAYER 
WHERE 	BACK_NO IS NOT NULL 
ORDER 	BY 3 DESC, 2, 1; 

-----------------------------

SELECT 	POSITION 포지션, BACK_NO, PLAYER_NAME 			/* 아래 세 문장은 모두 동일함 질의 */
FROM 	PLAYER
ORDER 	BY POSITION, BACK_NO, PLAYER_NAME DESC; 

SELECT 	POSITION 포지션, BACK_NO, PLAYER_NAME 
FROM 	PLAYER
ORDER 	BY 포지션, BACK_NO, PLAYER_NAME DESC; 

SELECT 	POSITION 포지션, BACK_NO, PLAYER_NAME 
FROM 	PLAYER
ORDER 	BY 포지션, 2, 3 DESC; 

-----------------------------

SELECT	PLAYER_ID, POSITION
FROM	PLAYER
ORDER	BY PLAYER_NAME;			/* SELECT 절에 없는 컬럼으로 정렬 가능함 */

SELECT	POSITION, COALESCE(AVG(HEIGHT),0), COALESCE(AVG(WEIGHT),0)
FROM	PLAYER
GROUP 	BY POSITION	
ORDER	BY PLAYER_NAME;			/* GROUP BY에 의해 에러가 발생해야 하나, MySQL에서는 실행됨. */


-------------------------------------------
-- 2.6 LIMIT 절
-------------------------------------------

-- LIMIT 절

SELECT	STADIUM_ID, STADIUM_NAME, SEAT_COUNT
FROM	STADIUM
ORDER	BY SEAT_COUNT DESC, STADIUM_NAME;

SELECT	STADIUM_ID, STADIUM_NAME, SEAT_COUNT
FROM	STADIUM
ORDER	BY SEAT_COUNT DESC, STADIUM_NAME
LIMIT	3;								/* LIMIT 0, 3; 과 같은 결과, 0번째 부터 최대 3개*/

SELECT	STADIUM_ID, STADIUM_NAME, SEAT_COUNT
FROM	STADIUM
ORDER	BY SEAT_COUNT DESC, STADIUM_NAME
LIMIT	10, 5;							/* 11번째 부터 최대 5개 */

-----------------------------

SELECT	STADIUM_ID, STADIUM_NAME, SEAT_COUNT		/* 다음 두 질의는 동일한 결과 */
FROM	STADIUM
ORDER	BY SEAT_COUNT DESC
LIMIT	3;

SELECT 	STADIUM_ID, STADIUM_NAME, SEAT_COUNT
FROM 	(
			SELECT	STADIUM_ID, STADIUM_NAME, SEAT_COUNT
            FROM	STADIUM
            ORDER	BY SEAT_COUNT DESC
		) AS TEMP									/* table alias를 꼭 사요애야 함 */
LIMIT	3;


-- Top-n query

SELECT 	ROW_NUMBER() OVER (ORDER BY SEAT_COUNT DESC) AS ROW_NUM, 	/* alias로 ROW_NUMBER를 사용할 수 없음 */
		STADIUM_ID, STADIUM_NAME, SEAT_COUNT, 
		RANK() OVER (ORDER BY SEAT_COUNT DESC) AS SEAT_RANK			/* alias로 RANK를 사용할 수 없음 */ 
FROM 	STADIUM;

-----------------------------

/* 아래 두 명령어의 결과는 동일함. */

SELECT	STADIUM_ID, STADIUM_NAME, SEAT_COUNT
FROM	STADIUM
ORDER	BY SEAT_COUNT DESC, STADIUM_NAME
LIMIT	10, 5;							/* 11번째 부터 최대 5개 */

WITH TEMP AS (
	SELECT	ROW_NUMBER() OVER (ORDER BY SEAT_COUNT DESC, STADIUM_NAME ASC) AS ROW_NUM, 
			STADIUM_ID, STADIUM_NAME, SEAT_COUNT
	FROM	STADIUM
)
SELECT	STADIUM_ID, STADIUM_NAME, SEAT_COUNT
FROM	TEMP
WHERE	ROW_NUM BETWEEN 11 AND 15;
	