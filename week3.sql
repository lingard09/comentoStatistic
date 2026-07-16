-- 요청 코드
INSERT INTO request_code VALUES ('L001', '일반 로그인');
INSERT INTO request_code VALUES ('L002', 'OTP 로그인');

-- 사용자
INSERT INTO user VALUES ('U001', 'HR01', '홍길동');
INSERT INTO user VALUES ('U002', 'HR02', '김철수');
INSERT INTO user VALUES ('U003', 'HR01', '이영희');

-- 로그인 기록
INSERT INTO request_info VALUES (1, 'L001', 'U001', '2024-04-01');
INSERT INTO request_info VALUES (2, 'L001', 'U001', '2024-04-01');
INSERT INTO request_info VALUES (3, 'L001', 'U002', '2024-04-01');
INSERT INTO request_info VALUES (4, 'L002', 'U003', '2024-04-02');
INSERT INTO request_info VALUES (5, 'L001', 'U003', '2024-04-03');
INSERT INTO request_info VALUES (6, 'L002', 'U001', '2024-04-03');
INSERT INTO request_info VALUES (7, 'L001', 'U002', '2024-05-01');
INSERT INTO request_info VALUES (8, 'L001', 'U003', '2024-05-01');
INSERT INTO request_info VALUES (9, 'L002', 'U003', '2024-05-02');


/* 월별 접속자 수 */
SELECT
    DATE_FORMAT(createdate, '%Y-%m') AS login_month,
    COUNT(DISTINCT user_id) AS user_count
FROM request_info
GROUP BY DATE_FORMAT(createdate, '%Y-%m')
ORDER BY login_month;

/* 일자별 접속자 수 */
SELECT
    createdate,
    COUNT(DISTINCT user_id) AS user_count
FROM request_info
GROUP BY createdate
ORDER BY createdate;

/* 평균 하루 로그인 수 */
SELECT
    ROUND(COUNT(*) / COUNT(DISTINCT createdate), 2) AS avg_daily_login
FROM request_info;

/* 휴일 제외 로그인 수 */
-- 휴일 테이블 예시
CREATE TABLE holidays (
    holiday_date DATE PRIMARY KEY,
    holiday_name VARCHAR(50)
);

-- 제외한 로그인 수
SELECT COUNT(*)
FROM request_info
WHERE createdate NOT IN (SELECT holiday_date FROM holidays);


/* 부서별 월별 로그인 수 */
SELECT
    u.hr_organ,
    DATE_FORMAT(r.createdate, '%Y-%m') AS login_month,
    COUNT(*) AS login_count
FROM request_info r
JOIN user u ON r.user_id = u.user_id
GROUP BY u.hr_organ, DATE_FORMAT(r.createdate, '%Y-%m')
ORDER BY u.hr_organ, login_month;


/* 기타 */
/* 일자별 접속자 수: 번외 */
/* 시작일자와 종료일자를 입력받아 비어있는 일자 포함 */

-- 아래 변수에 시작일자와 종료일자를 설정하세요
SET @start_date = '2024-04-01';
SET @end_date = '2024-04-07';

-- 날짜 시퀀스를 생성하고 일자별 사용자 수를 LEFT JOIN으로 집계
WITH RECURSIVE date_sequence AS (
    SELECT @start_date AS dt
    UNION ALL
    SELECT DATE_ADD(dt, INTERVAL 1 DAY)
    FROM date_sequence
    WHERE dt < @end_date
)
SELECT
    ds.dt AS login_date,
    COUNT(DISTINCT ri.user_id) AS user_count
FROM
    date_sequence ds
LEFT JOIN
    request_info ri ON ri.createdate = ds.dt
GROUP BY
    ds.dt
ORDER BY
    ds.dt;
