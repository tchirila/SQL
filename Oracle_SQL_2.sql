--E3Q1
--Write a query which shows the share_holder_id which made the trade with the largest price_total.
SELECT
            share_holder_id
FROM        trades
WHERE       price_total = (SELECT
                                      MAX(price_total)
                          FROM        trades);

--E3Q2
--Write a query showing the name of the broker who made the trade with the smallest share_amount.
SELECT
            DISTINCT first_name ||' '|| last_name AS Broker            
FROM        trades t
JOIN        brokers b
ON          b.broker_id = t.broker_id
WHERE       share_amount = (SELECT
                                       MIN(share_amount)
                           FROM        trades);

--E3Q3
--Write a query which lists each share_holder_id and the share_id which they own the most of as well as the amount they own of that share.
SELECT
            share_holder_id,
            share_id,
            amount
FROM        share_holder_shares s1
WHERE       amount = (SELECT
                                  MAX(amount)
                     FROM         share_holder_shares s2
                     WHERE        s1.share_holder_id = s2.share_holder_id);

--E3Q4
--Write a query which shows the highest number of trades made by a single shareholder.
SELECT
            MAX(trades)
FROM        (SELECT
                        share_holder_id,
                        COUNT(price_total) AS trades
             FROM       trades
             GROUP BY   share_holder_id);

--Mock Exam 3Q1
--Write a query which shows the trainee_id of the trainee with the lowest score in the exam_results table.
SELECT
        trainee_id  
FROM    exam_results
WHERE   score = (SELECT
                            MIN(score)
                 FROM       exam_results);

--Mock Exam 3Q2
--Write a query showing the name of the trainee who has been in the academy the longest.
SELECT
            name
FROM        trainees
WHERE       start_date = (SELECT
                                    MIN(start_date)
                         FROM       trainees);

--Mock Exam 3Q3
--Write a query which lists the longest serving trainer in each academy. There should be 3 columns - academny_id, trainer name and start date.
SELECT
            academy_id,
            name AS "trainer name",
            start_date AS "start date"
FROM        trainers t
WHERE       start_date = (SELECT
                                    MIN(start_date)
                         FROM       trainers t1
                         WHERE      t.academy_id = t1.academy_id);

--Mock Exam 3Q4
--Write a query which shows the highest number of exams taken by a single trainee.
SELECT
            MAX(exams)
FROM        (SELECT
                        trainee_id,
                        COUNT(score) AS exams
             FROM       exam_results
             GROUP BY   trainee_id);

--E2Q1
--Write a query which shows the highest price total.
SELECT
            MAX(price_total)
FROM        trades;

--E2Q2
--Write a query which shows the highest and lowest price totals in the trades table.
SELECT
            MAX(price_total)
FROM        trades
UNION
SELECT
            MIN(price_total)
FROM        trades;

--E2Q3
--Write a query which shows the average share price for each share ID - use the shares_prices table. Round the averages to zero decimal places and order by the share_id.
SELECT
            ROUND(AVG(price))
FROM        shares_prices
GROUP BY    share_id
ORDER BY    share_id;

--E2Q4
--Write a query which shows share IDs with a maximum price total above £1 million.
SELECT
            share_id
FROM        trades
GROUP BY    share_id
HAVING      MAX(price_total) > 1e6;

--E2Q5
--Write a query which shows any share IDs where broker 1 has made more than 2 trades.
SELECT
            share_id,
            COUNT(trade_id)
FROM        trades
WHERE       broker_id = 1
GROUP BY    share_id
HAVING      COUNT(trade_id) > 2;

--Mock Exam 2Q1
--Write a query which shows the shortest stream duration.
SELECT 
            MIN(duration_weeks)
FROM        streams;

--Mock Exam 2Q2
--Write a query which shows the longest and shortest stream duration.
SELECT 
            MAX(duration_weeks)
FROM        streams
UNION
SELECT
            MIN(duration_weeks)
FROM        streams;

--Mock Exam 2Q3
--Write a query which shows the average score for each course_id - use the exam_results table. Round the aaverages to zero decimal places and order by the average score.
SELECT
            course_id,
            ROUND(AVG(score))
FROM        exam_results
GROUP BY    course_id
ORDER BY    AVG(score);

--Mock Exam 2Q4
--Write a query which shows trainer_ids of trainers who teach 4 or more courses.
SELECT
            trainer_id
FROM        trainers_courses
GROUP BY    trainer_id
HAVING      COUNT(course_id) >= 4;

--Mock Exam 2Q5
--Write a query which shows the trainee_ids of any trainee who has taken 3 or more exams in the last 7 days.
SELECT
            trainee_id
FROM        exam_results
WHERE       exam_date >= (sysdate - 7)
GROUP BY    trainee_id
HAVING      COUNT(exam_date) >= 3;

--E1Q1
--Write a query which shows full details of any trade made by the broker with broker ID 4.
--Got 3 rows
SELECT
            *
FROM        trades
WHERE       broker_id = 4;

--E1Q2
--Write a query showing the share_id, trade_id, price_total & share_amount for any trades where the price total is more than £2 million and the share amount is more than 20,000.
--Got 11 rows
SELECT
            share_id,
            trade_id,
            price_total,
            share_amount
FROM        trades
WHERE       price_total > 2e6
AND         share_amount > 2e4;

--E1Q3
--Write a query which shows the broker IDs of any brokers who've made a trade today.
--Got 1 row
SELECT
            broker_id
FROM        trades
WHERE       transaction_time > sysdate - 1;

--E1Q4
--Write a query which shows the following columns for each trade: shareholder name (first and last name concatenated), trade_id, share_id, share_amount and price_total.
--Got 53 rows
SELECT
            first_name ||' '|| last_name AS "Shareholder Name",
            trade_id,
            share_id,
            share_amount,
            price_total
FROM        trades t
JOIN        share_holders sh
ON          t.share_holder_id = sh.share_holder_id;

--E1Q5
--Write a query which shows any share IDs which never been traded.
--Got 1 row
SELECT
            s.share_id
FROM        shares s
LEFT JOIN   trades t
ON          s.share_id = t.share_id
WHERE       t.share_id IS null;

--Mock Exam Q1
--Write a query which shows the names of any trainees in the academy with academy_id 3.
--Got 10 rows
SELECT
            name
FROM        trainees
WHERE       academy_id = 3;

--Mock Exam Q2
--Write a query showing the trainee_ids of anyone scoring 100% in course_id 2.
--Got 3 rows
SELECT
            trainee_id
FROM        exam_results
WHERE       score = 100
AND         course_id = 2;

--Mock Exam Q3
--Write a query which shows the names of any trainees with start dates in the last 7 days.
--Got 4 rows (because someone starts on 01-Aug)
SELECT
            name
FROM        trainees
WHERE       start_date >= (sysdate - 7);

--Mock Exam Q4
--Write a query which shows the name of each trainee and the name of their stream.
--Got 60 rows
SELECT
            t.name Trainee,
            s.name Stream
FROM        trainees t
LEFT JOIN   streams s
ON          t.stream_id = s.stream_id;

--Mock Exam Q5
--Write a query which shows the names of each trainer and the names of any course they teach.
--Got 44 rows
SELECT
            t.name Trainer,
            c.name Course
FROM        trainers t
JOIN        trainers_courses tc
ON          t.trainer_id = tc.trainer_id
JOIN        courses c
ON          tc.course_id = c.course_id;
