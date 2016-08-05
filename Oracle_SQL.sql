--D3P3Q1--
--A record breaking transaction is a trade that has a larger price total than any trade that happened before it. Write a query that shows all the record breaking transactions.
--Show trade_id, transaction_time & price_total in the results. Note: The first ever transaction was a record breaker.
SELECT
            first_name,
            last_name
FROM        trades t
JOIN        brokers b
ON          t.broker_id = b.broker_id
WHERE       trade_id = (SELECT
                                    MAX(trade_id)
                        FROM        trades);

--D4P2Q5--
--Use an inline view to show the time_start  with the maximum price for each share_id.
SELECT
            sp.share_id,
            sp.time_start,
            sp.price
FROM        shares_prices sp
JOIN        (SELECT
                        share_id,
                        MAX(price) AS price
             FROM       shares_prices
             GROUP BY   share_id) sp1
ON          sp.share_id = sp1.share_id
AND         sp.price = sp1.price;

--D4P2Q4--
--Use an inline view to show the trade_id of the earliest transaction for each stock_exchange. The output should have 3 columns: stock_ex_id, trade_id, transaction_time. 
SELECT
            t.stock_ex_id,
            t.trade_id,
            t.transaction_time
FROM        trades t
JOIN        (SELECT
                        stock_ex_id,
                        MIN(transaction_time) AS transaction_time
             FROM       trades
             GROUP BY   stock_ex_id) t1
ON          t.stock_ex_id = t1.stock_ex_id
AND         t.transaction_time = t1.transaction_time;

--D4P2Q3--
--Write a query which shows the date of the earliest trade for each stock exchange. The output should have 2 columns: stock_ex_id and earliest transaction_time.
SELECT
            t.stock_ex_id,
            t.transaction_time
FROM        trades t
JOIN        (SELECT
                        stock_ex_id,
                        MIN(transaction_time) AS transaction_time
             FROM       trades
             GROUP BY   stock_ex_id) t1
ON          t.transaction_time = t1.transaction_time
AND         t1.stock_ex_id = t1.stock_ex_id;

--D4P2Q2--
--Use an inline view to show the trade_id with the highest price_total for each broker. The output should have 3 columns: broker_id, trade_id, price_total.
SELECT
            t.broker_id,
            t.trade_id,
            t.price_total
FROM        trades t
JOIN        (SELECT
                        broker_id,
                        MAX(price_total) AS price_total
             FROM       trades
             GROUP BY   broker_id) t1
ON          t.broker_id = t1.broker_id
AND         t.price_total = t1.price_total;

--D4P2Q1--
--Write a query which shows the highest price_total for each broker. The output should have 2 columns: broker_id and highest price_total. Give the highest price total column an alias.
SELECT
            broker_id,
            MAX(price_total) AS "Highest Price Total"
FROM        trades
GROUP BY    broker_id;

--D4P1Q6--
--Modify the previous query to show the name of the broker instead of the broker_id.
SELECT
            TO_CHAR(transaction_time, 'MM') AS "Month",
            first_name ||' '|| last_name AS "Broker",
            share_amount
FROM        trades t1
JOIN        brokers b
ON          t1.broker_id = b.broker_id
WHERE       share_amount = (SELECT
                                       MIN(share_amount)
                            FROM       trades t2
                            WHERE      TO_CHAR(t1.transaction_time, 'MM') = TO_CHAR(t2.transaction_time, 'MM'));

--D4P1Q5--
--Use a correlated subquery to show the broker with the lowest share amount for each month. The output should have 3 columns:  month, broker_id, share_amount. 
SELECT
            TO_CHAR(transaction_time, 'MM') AS "Month",
            broker_id,
            share_amount
FROM        trades t1
WHERE       share_amount = (SELECT
                                       MIN(share_amount)
                            FROM       trades t2
                            WHERE      TO_CHAR(t1.transaction_time, 'MM') = TO_CHAR(t2.transaction_time, 'MM'));

--D4P1Q4--
--Modify your query from question 2 to show the name of the stock exchange and the name of the broker instead of their IDs.
SELECT
            name as "Stock Exchange",
            first_name ||' '|| last_name AS "Broker",
            price_total
FROM        stock_exchanges se
JOIN        trades t1
ON          se.stock_ex_id = t1.stock_ex_id
JOIN        brokers b
ON          t1.broker_id = b.broker_id
WHERE       price_total = (SELECT
                                      MAX(price_total)
                           FROM       trades t2
                           WHERE      t2.stock_ex_id = t1.stock_ex_id);

--D4P1Q3--
--Modify your query from question 1 to show the name of the stock exchange instead of the stock_ex_id.
SELECT
            name,
            trade_id,
            transaction_time
FROM        trades t1
JOIN        stock_exchanges se
ON          se.stock_ex_id = t1.stock_ex_id
WHERE       transaction_time = (SELECT
                                           MIN(transaction_time)
                                FROM       trades t2
                                WHERE      t2.stock_ex_id = t1.stock_ex_id);

--D4P1Q2--
--Use a correlated subquery to show the broker with the highest price total for each stock_exchange. The output should have 3 columns: stock_ex_id, broker_id, price_total.
SELECT
            stock_ex_id,
            broker_id,
            price_total
FROM        trades t1
WHERE       price_total = (SELECT
                                      MAX(price_total)
                           FROM       trades t2
                           WHERE      t2.stock_ex_id = t1.stock_ex_id);

--D4P1Q1--
--Use a correlated subquery to show the trade_id of the earliest transaction_time for each stock_exchange. The output should have 3 columns: stock_ex_id, trade_id, transaction_time.
SELECT
            stock_ex_id,
            trade_id,
            transaction_time
FROM        trades t1
WHERE       transaction_time = (SELECT
                                           MIN(transaction_time)
                                FROM       trades t2
                                WHERE      t2.stock_ex_id = t1.stock_ex_id);

--D3P3Q5--
--Show the names of any companies with an average price_total which is less than the average price total for all companies.
SELECT
            name
FROM        companies c
JOIN        shares s
ON          c.company_id = s.company_id
JOIN        trades t
ON          t.share_id = s.share_id
GROUP BY    name
HAVING      AVG(price_total) < (SELECT
                                              AVG(AVG(price_total))
                                  FROM        trades
                                  GROUP BY    share_id);

--D3P3Q4--
--Show the name of the stock exchange where the most trades have taken place.
SELECT
            name
FROM        stock_exchanges 
WHERE       stock_ex_id = (SELECT
                                       MAX(COUNT(stock_ex_id))
                           FROM        trades
                           GROUP BY    trade_id);

--D3P3Q3--
--Show the name of the currency which is used to price the most shares.
SELECT
            name
FROM        currencies 
WHERE       currency_id = (SELECT
                                       MAX(COUNT(currency_id))
                           FROM        shares
                           GROUP BY    share_id);

--D3P3Q2--
--Show the name of the stock exchange which is traded on by the most brokers.
SELECT
            name
FROM        broker_stock_ex bse
JOIN        stock_exchanges se
ON          bse.stock_ex_id = se.stock_ex_id
GROUP BY    name
HAVING      COUNT(bse.stock_ex_id) = (SELECT
                                                  MAX(COUNT(stock_ex_id))
                                      FROM        broker_stock_ex
                                      GROUP BY    stock_ex_id);

--D3P3Q1--
--Show the name of the broker who made the trade with the highest trade_id.
SELECT
            first_name,
            last_name
FROM        trades t
JOIN        brokers b
ON          t.broker_id = b.broker_id
WHERE       trade_id = (SELECT
                                    MAX(trade_id)
                        FROM        trades);

--D3P2Q5--
--List share_ids of shares whose average share price is greater than the average share price for all shares.
SELECT
            share_id
FROM        shares_prices
GROUP BY    share_id
HAVING      AVG(price) >= (SELECT
                                             AVG(AVG(price))
                                  FROM       shares_prices
                                  GROUP BY   share_id);

--D3P2Q4--
--List share_ids of shares whose average share amount is greater than the average share amount for all shares.
SELECT
            share_id
FROM        trades
GROUP BY    share_id
HAVING      AVG(share_amount) >= (SELECT
                                             AVG(AVG(share_amount))
                                  FROM       trades
                                  GROUP BY   share_id);

--D3P2Q3--
--Show the share_id of the share which has been traded the most times.
SELECT
            share_id
FROM        trades
GROUP BY    share_id
HAVING      COUNT(trade_id) = (SELECT
                                          MAX(COUNT(trade_id))
                               FROM       trades
                               GROUP BY   share_id);

--D3P2Q2--
--Show the broker_id of the broker who trades on the most stock exchanges. 
SELECT
            broker_id
FROM        broker_stock_ex
GROUP BY    broker_id
HAVING      COUNT(DISTINCT stock_ex_id) = (SELECT
                                                      MAX(COUNT(DISTINCT stock_ex_id))
                                           FROM       broker_stock_ex
                                           GROUP BY   broker_id);

--D3P2Q1--
--Show the stock_ex_id of the stock exchange which is traded on by the most brokers.
SELECT
            stock_ex_id,
            COUNT(broker_id)
FROM        broker_stock_ex
GROUP BY    stock_ex_id
HAVING      COUNT(stock_ex_id) = (SELECT
                                              MAX(COUNT(stock_ex_id))
                                  FROM        broker_stock_ex
                                  GROUP BY    stock_ex_id);

--D3P1Q7--
--List the trade_ids which have an above average share_amount.
SELECT
            trade_id
FROM        trades
WHERE       share_amount > (SELECT
                                        AVG(share_amount)
                            FROM        trades);

--D3P1Q6--
--Show the broker_id of the broker who made the trade with the highest trade_id.
SELECT
            broker_id
FROM        trades
WHERE       trade_id = (SELECT
                                    MAX(trade_id)
                        FROM        trades);

--D3P1Q5--
--Show the stock_ex_id of the stock exchange where the most recent trade took place.
SELECT
            stock_ex_id
FROM        trades
WHERE       transaction_time = (SELECT
                                            MAX(transaction_time)
                                FROM        trades);

--D3P1Q4--
--List the names of cities which don’t have a stock exchange.
SELECT
            city
FROM        places p
LEFT JOIN   stock_exchanges se
ON          p.place_id = se.place_id
WHERE       se.place_id IS null;

--D3P1Q3--
--List the names of cities which have a stock exchange.
SELECT
            city
FROM        places p
JOIN        stock_exchanges se
ON          p.place_id = se.place_id;

--D3P1Q2--
--List the names of companies which have not issued shares.
SELECT
            name
FROM        companies c
LEFT JOIN   shares s
ON          c.company_id = s.company_id
WHERE       s.share_id IS null;

--D3P1Q1--
--List the names of companies which have issued shares.
SELECT
            name
FROM        companies c
JOIN        shares s
ON          c.company_id = s.company_id;

--D2P3Q6--
--Modify your query from question five to show months when British Airways has had an average share price above 200. The result should have one column: month.
SELECT  
          TO_CHAR(time_start, 'MM') AS "Month"
FROM      shares_prices sp
JOIN      shares s
ON        sp.share_id = s.share_id
JOIN      companies c
ON        c.company_id = s.company_id
WHERE     name = 'British Airways'
GROUP BY  name, TO_CHAR(time_start, 'MM')
HAVING    AVG(price) > 200
ORDER BY  name, TO_CHAR(time_start, 'MM');

--D2P3Q5--
--Create a list showing the average of share price per month per company. The result should have three columns: company name, month and average price (rounded to 2 decimal places). Make sure the results are ordered by the company name and the month.
SELECT  
          name,
          TO_CHAR(time_start, 'MM') AS "Month",
          ROUND(AVG(price), 2) AS "Average Price"
FROM      shares_prices sp
JOIN      shares s
ON        sp.share_id = s.share_id
JOIN      companies c
ON        c.company_id = s.company_id
GROUP BY  name, TO_CHAR(time_start, 'MM')
ORDER BY  name, TO_CHAR(time_start, 'MM');

--D2P3Q4--
--Find the names of brokers who’ve made more than 5 trades in the last 90 days. The result should have one column: broker name. 
SELECT  
          first_name ||' '|| last_name Broker
FROM      brokers b
JOIN      trades t
ON        b.broker_id = t.broker_id
WHERE     transaction_time > (sysdate - 90)
GROUP BY  first_name,last_name
HAVING    COUNT(t.broker_id) > 5;

--D2P3Q3--
--Find the average price total for each company. The results should have two columns: company name and average price total.
SELECT  
          name,
          AVG(price_total)
FROM      companies c
JOIN      shares s
ON        c.company_id = s.company_id
JOIN      trades t
ON        s.share_id = t.share_id
GROUP BY  name;

--D2P3Q2--
--Modify your query from question one to show all the cities that have three or more companies located in them. The result should have one column: city.
SELECT  
          city
FROM      places p
JOIN      companies c
ON        p.place_id = c.place_id
GROUP BY  city
HAVING    COUNT(c.place_id) >= 3;

--D2P3Q1--
--Create a list showing the number of companies per city. The result should have two columns: City and number of companies.
SELECT  
          city,
          COUNT(c.place_id) 
FROM      places p
JOIN      companies c
ON        p.place_id = c.place_id
GROUP BY  city;

--D2P2Q7--
--Show shares traded more than 10 times on the New York Stock Exchange (stock_ex_id = 3). The result should have one column: share_id.
SELECT  
            share_id
FROM        trades
WHERE       stock_ex_id = 3
GROUP BY    share_id
HAVING      COUNT(share_amount) >= 10;

--D2P2Q6--
--Show currencies used to price 4 or more shares. The results should have 1 column: currency_id. 
SELECT  
        c.currency_id
  FROM  currencies c
  JOIN  shares s
    ON  c.currency_id = s.currency_id
GROUP BY  c.currency_id
HAVING COUNT(share_id) >= 4;

--D2P2Q5--
--Show brokers with an average price total greater than 4,000,000. The result should have one column: broker_id. 
SELECT  
        broker_id
  FROM  trades
  GROUP BY broker_id
  HAVING AVG(price_total) > 4e6;

--D2P2Q4--
--Show the total share amount for each share. The results should have two columns: share_id and total share amount.
SELECT  
        share_id,
        SUM(share_amount)
  FROM  trades
GROUP BY  share_id;

--D2P2Q3--
--Show the number of shares priced in each currency. The results should have two columns: currency_id and number of shares priced in that currency.
SELECT  
        c.currency_id,
        COUNT(share_id)
  FROM  currencies c
  JOIN  shares s
    ON  c.currency_id = s.currency_id
GROUP BY  c.currency_id;

--D2P2Q2--
--Find the date of the earliest trade for each stock exchange. The results should have two columns: stock_ex_id and transaction_time.
SELECT  
        stock_ex_id,
        MIN(transaction_time)
  FROM  trades
GROUP BY  stock_ex_id;

--D2P2Q1--
--Show the average price total for each broker. The results should have two columns: broker_id and average price total.
SELECT  
        broker_id,
        AVG(price_total)
  FROM  trades
GROUP BY  broker_id;

--D2P1Q7--
--Create a list of the brokers with the stock exchanges assigned to them. The results should have two columns – broker’s name & stock exchange name.
SELECT  
        b.first_name ||' '|| b.last_name AS "Broker",
        se.name AS "Stock Exchange"
  FROM  brokers b
  JOIN  broker_stock_ex bse
    ON  b.broker_id = bse.broker_id
  JOIN  stock_exchanges se
    ON  bse.stock_ex_id = se.stock_ex_id;

--D2P1Q6--
--Write a query that will give you the name of each company and the name of the currency their shares are traded in. 
SELECT  
        co.name AS "Company Name",
        cu.name AS "Currency"
  FROM  companies co
  JOIN  shares s
    ON  co.company_id = s.company_id
  JOIN  currencies cu
    ON  s.currency_id = cu.currency_id;

--D2P1Q5--
--Find the name of any currencies that are not used to price any share.
SELECT  
        name,
        share_id
  FROM  shares s
  RIGHT JOIN  currencies c
    ON  s.currency_id = c.currency_id
WHERE share_id IS null;

--D2P1Q4--
--Create a list of all currency names and any shares they’re used to price. The list should include currencies which are not used to price any share. The results should show two columns: currency name and share_id. 
SELECT  
        name,
        share_id
  FROM  shares s
  RIGHT JOIN  currencies c
    ON  s.currency_id = c.currency_id;

--D2P1Q3--
--Create a list of shares and the currencies they’re priced in. The results should have two columns – share_id and currency name.
SELECT  share_id,
        name
  FROM  shares s
  JOIN  currencies c
    ON  s.currency_id = c.currency_id;

--D2P1Q2--
--Create a list of the companies and the stock exchanges they’re traded on. The results should show company name and stock exchange name.
SELECT  c.name,
        se.name AS "Stock Exchange Name"
  FROM  companies c
  JOIN  stock_exchanges se
    ON  se.place_id = c.place_id;

--D2P1Q1--
--Create a list of companies and their locations. The results should have three columns - company name, city & country.
SELECT  name,
        city,
        country
  FROM  companies c
  JOIN  places p
    ON  p.place_id = c.place_id;

--D1P3Q7--v2
--What trades have been made in the last 7 days?
  SELECT *                        
  FROM trades
  WHERE transaction_time > (sysdate - 7);

--D1P3Q6--
--There are two brokers called John, what are their last names?
SELECT last_name                        
  FROM brokers
  WHERE first_name = 'John';

--D1P3Q5--
--What cities are associated with France?
SELECT city                        
  FROM places
  WHERE country = 'France';
  
--D1P3Q4--
--What is the Symbol used for the London Stock Exchange?
SELECT symbol                        
  FROM stock_exchanges
  WHERE name = 'London Stock Exchange';
  
--D1P3Q3--
--What companies have their head quarters in New York (place_id 3)?
SELECT name
  FROM companies
  WHERE place_id = '3';
  
--D1P3Q2--
--What trades have been made this month?
SELECT trade_id
  FROM trades
  WHERE to_char(transaction_time,'MM') = to_char(SYSDATE,'MM');
  
--D1P3Q1--
--What currencies are available to price shares in?
SELECT name
  FROM currencies;
