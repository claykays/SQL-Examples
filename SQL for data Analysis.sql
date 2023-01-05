
--Questions

   -- Provide a table that provides the region for each sales_rep along with their associated accounts. 
  -- This time only for the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name.
  -- Sort the accounts alphabetically (A-Z) according to account name.

SELECT r.name as RegionName,s.name as Salesperson,a.name as AccountName
from region r
JOIN sales_reps s
On s.region_id = r.id
JOIN accounts a
ON s.id = a.sales_rep_id
where r.name ='Midwest'
Order BY  a.name

Questions
  -- Provide a table that provides the region for each sales_rep along with their associated accounts. 
 -- This time only for accounts where the sales rep has a first name starting with S and in the Midwest region. 
  --Your final table should include three columns: the region name, the sales rep name, and the account name.
  --Sort the accounts alphabetically (A-Z) according to account name.

SELECT r.name as RegionName,s.name as Salesperson,a.name as AccountName
from region r
JOIN sales_reps s
On s.region_id = r.id
JOIN accounts a
ON s.id = a.sales_rep_id
where r.name ='Midwest' 
and s.name like'S%'
Order BY  a.name

-- Provide a table that provides the region for each sales_rep along with their associated accounts. 
--This time only for accounts where the sales rep has a last name starting with K and in the Midwest region. 
--Your final table should include three columns: the region name, the sales rep name, and the account name. 
--Sort the accounts alphabetically (A-Z) according to account name.

SELECT r.name as RegionName,s.name as Salesperson,a.name as AccountName,
from region r
JOIN sales_reps s
On s.region_id = r.id
JOIN accounts a
ON s.id = a.sales_rep_id
where r.name ='Midwest' 
and s.name like'% K%'
Order BY  a.name

-- Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order.
--However, you should only provide the results if the standard order quantity exceeds 100.
--Your final table should have 3 columns: region name, account name, and unit price.
--In order to avoid a division by zero error, adding .01 to the denominator here is helpful total_amt_usd/(total+0.01).

SELECT r.name as RegionName,a.name as AccountName, (o.total_amt_usd/(o.total+0.01))  as unitprice
from region r
JOIN sales_reps s
On s.region_id = r.id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id =o.account_id
where o.standard_qty >100

 -- Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order.
 --However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50.
 --Your final table should have 3 columns: region name, account name, and unit price. 
 --Sort for the smallest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).

SELECT r.name as RegionName,a.name as AccountName, (o.total_amt_usd/(o.total+0.01))  as unitprice
from region r
JOIN sales_reps s
On s.region_id = r.id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id =o.account_id
where o.standard_qty >100
and o.poster_qty >50
ORDER BY unitprice 

 -- Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
 --However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. 
 --Your final table should have 3 columns: region name, account name, and unit price. Sort for the largest unit price first.
 --In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).

SELECT r.name as RegionName,a.name as AccountName, (o.total_amt_usd/(o.total+0.01))  as unitprice
from region r
JOIN sales_reps s
On s.region_id = r.id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id =o.account_id
where o.standard_qty >100
and o.poster_qty >50
ORDER BY unitprice desc

 -- What are the different channels used by account id 1001? Your final table should have only 2 columns: account name and the different channels. 
 --You can try SELECT DISTINCT to narrow down the results to only the unique values.

SELECT distinct a.name as AccountName,w.channel as Channel
from web_events w
JOIN accounts a
ON w.account_id = a.id

where a.id =1001

  --  Find all the orders that occurred in 2015. Your final table should have 4 columns: occurred_at, account name, order total, and order total_amt_usd.
  
SELECT o.occurred_at, a.name as AccountName, o.total, o.total_amt_usd
FROM
orders o
JOIN  accounts a
ON o.account_id =a.id
where date_part('year',o.occurred_at) = 2015


--to get the median amount
with tt as (
SELECT total_amt_usd,
row_number() over(order by total_amt_usd desc ) as rn_desc,
row_number() over(order by total_amt_usd asc ) as rn_asc
from orders where total_amt_usd >0 )

select total_amt_usd from tt
where rn_asc = (select count(*)/2 from  tt);

##or use this
select total_amt_usd from orders where total_amt_usd > 0 
and id = (select count(*)/2 from  orders where total_amt_usd > 0)


--Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.


select ac.name,o.occurred_at
FROM accounts ac
JOIN orders o
ON ac.id = o.account_id
order by o.occurred_at limit 1

--Find the total sales in usd for each account. You should include two columns - 
--the total sales for each company's orders in usd and the company name.

select ac.name,sum(o.total_amt_usd)
FROM accounts ac
JOIN orders o
ON ac.id = o.account_id
group by ac.name

--Via what channel did the most recent (latest) web_event occur,
--which account was associated with this web_event? Your query should return only three values - 
--the date, channel, and account name.


select w.channel,w.occurred_at,ac.name
FROM accounts ac
JOIN web_events w
ON ac.id = w.account_id
order by w.occurred_at desc limit 1



--Find the total number of times each type of channel from the web_events was used. 
--Your final table should have two columns - the channel and the number of times the channel was used.


select w.channel,count(w.channel)
FROM accounts ac
JOIN web_events w
ON ac.id = w.account_id
JOIN orders o 
ON ac.id =o.account_id
GROUP by w.channel


--Solutions: Working With DATEs

  --  Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. Do you notice any trends in the yearly sales totals?

     SELECT DATE_PART('year', occurred_at) ord_year,  SUM(total_amt_usd) total_spent
     FROM orders
     GROUP BY 1
     ORDER BY 2 DESC;

  --  When we look at the yearly totals, you might notice that 2013 and 2017 have much smaller totals than all other years. If we look further at the monthly data, we see that for 2013 and 2017 there is only one month of sales for each of these years (12 for 2013 and 1 for 2017). Therefore, neither of these are evenly represented. Sales have been increasing year over year, with 2016 being the largest sales to date. At this rate, we might expect 2017 to have the largest sales.

  --  Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset?

  --  In order for this to be 'fair', we should remove the sales from 2013 and 2017. For the same reasons as discussed above.

    SELECT DATE_PART('month', occurred_at) ord_month, SUM(total_amt_usd) total_spent
    FROM orders
    WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
    GROUP BY 1
    ORDER BY 2 DESC; 

  --  The greatest sales amounts occur in December (12).

  --  Which year did Parch & Posey have the greatest sales in terms of total number of orders? Are all years evenly represented by the dataset?

    SELECT DATE_PART('year', occurred_at) ord_year,  COUNT(*) total_sales
    FROM orders
    GROUP BY 1
    ORDER BY 2 DESC;

   -- Again, 2016 by far has the most amount of orders, but again 2013 and 2017 are not evenly represented to the other years in the dataset.

  --  Which month did Parch & Posey have the greatest sales in terms of total number of orders? Are all months evenly represented by the dataset?

    SELECT DATE_PART('month', occurred_at) ord_month, COUNT(*) total_sales
    FROM orders
    WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
    GROUP BY 1
    ORDER BY 2 DESC; 

   -- December still has the most sales, but interestingly, November has the second most sales (but not the most dollar sales. To make a fair comparison from one month to another 2017 and 2013 data were removed.

    In which month of which year did Walmart spend the most on gloss paper in terms of dollars?

    SELECT DATE_TRUNC('month', o.occurred_at) ord_date, SUM(o.gloss_amt_usd) tot_spent
    FROM orders o 
    JOIN accounts a
    ON a.id = o.account_id
    WHERE a.name = 'Walmart'
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 1;

   -- May 2016 was when Walmart spent the most on gloss paper.
	
	--Solutions: CASE

   -- Write a query to display for each order, the account ID, total amount of the order, and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or less than $3000.

    SELECT account_id, total_amt_usd,
    CASE WHEN total_amt_usd > 3000 THEN 'Large'
    ELSE 'Small' END AS order_level
    FROM orders;

   -- Write a query to display the number of orders in each of three categories, based on the total number of items in each order. The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.

    SELECT CASE WHEN total >= 2000 THEN 'At Least 2000'
       WHEN total >= 1000 AND total < 2000 THEN 'Between 1000 and 2000'
       ELSE 'Less than 1000' END AS order_category,
    COUNT(*) AS order_count
    FROM orders
    GROUP BY 1;

   -- We would like to understand 3 different branches of customers based on the amount associated with their purchases. The top branch includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. The second branch is between 200,000 and 100,000 usd. The lowest branch is anyone under 100,000 usd. Provide a table that includes the level associated with each account. You should provide the account name, the total sales of all orders for the customer, and the level. Order with the top spending customers listed first.

    SELECT a.name, SUM(total_amt_usd) total_spent, 
         CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
         WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
         ELSE 'low' END AS customer_level
    FROM orders o
    JOIN accounts a
    ON o.account_id = a.id 
    GROUP BY a.name
    ORDER BY 2 DESC;

  --  We would now like to perform a similar calculation to the first, but we want to obtain the total amount spent by customers only in 2016 and 2017. Keep the same levels as in the previous question. Order with the top spending customers listed first.

    SELECT a.name, SUM(total_amt_usd) total_spent, 
         CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
         WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
         ELSE 'low' END AS customer_level
    FROM orders o
    JOIN accounts a
    ON o.account_id = a.id
    WHERE occurred_at > '2015-12-31' 
    GROUP BY 1
    ORDER BY 2 DESC;

  --  We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders. Create a table with the sales rep name, the total number of orders, and a column with top or not depending on if they have more than 200 orders. Place the top sales people first in your final table.

    SELECT s.name, COUNT(*) num_ords,
         CASE WHEN COUNT(*) > 200 THEN 'top'
         ELSE 'not' END AS sales_rep_level
    FROM orders o
    JOIN accounts a
    ON o.account_id = a.id 
    JOIN sales_reps s
    ON s.id = a.sales_rep_id
    GROUP BY s.name
    ORDER BY 2 DESC;

  --  It is worth mentioning that this assumes each name is unique - which has been done a few times. We otherwise would want to break by the name and the id of the table.

   -- The previous didn't account for the middle, nor the dollar amount associated with the sales. Management decides they want to see these characteristics represented as well. We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders or more than 750000 in total sales. The middle group has any rep with more than 150 orders or 500000 in sales. Create a table with the sales rep name, the total number of orders, total sales across all orders, and a column with top, middle, or low depending on this criteria. Place the top sales people based on dollar amount of sales first in your final table.

    SELECT s.name, COUNT(*), SUM(o.total_amt_usd) total_spent, 
         CASE WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'top'
         WHEN COUNT(*) > 150 OR SUM(o.total_amt_usd) > 500000 THEN 'middle'
         ELSE 'low' END AS sales_rep_level
    FROM orders o
    JOIN accounts a
    ON o.account_id = a.id 
    JOIN sales_reps s
    ON s.id = a.sales_rep_id
    GROUP BY s.name
    ORDER BY 3 DESC;

   -- You might see a few upset sales people by this criteria!

--Solutions: HAVING

  --  How many of the sales reps have more than 5 accounts that they manage?

    SELECT s.id, s.name, COUNT(*) num_accounts
    FROM accounts a
    JOIN sales_reps s
    ON s.id = a.sales_rep_id
    GROUP BY s.id, s.name
    HAVING COUNT(*) > 5
    ORDER BY num_accounts;

  --  and technically, we can get this using a SUBQUERY as shown below. This same logic can be used for the other queries, but this will not be shown.

    SELECT COUNT(*) num_reps_above5
    FROM(SELECT s.id, s.name, COUNT(*) num_accounts
         FROM accounts a
         JOIN sales_reps s
         ON s.id = a.sales_rep_id
         GROUP BY s.id, s.name
         HAVING COUNT(*) > 5
         ORDER BY num_accounts) AS Table1;

 --   How many accounts have more than 20 orders?

    SELECT a.id, a.name, COUNT(*) num_orders
    FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY a.id, a.name
    HAVING COUNT(*) > 20
    ORDER BY num_orders;

 --   Which account has the most orders?

    SELECT a.id, a.name, COUNT(*) num_orders
    FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY a.id, a.name
    ORDER BY num_orders DESC
    LIMIT 1;

  --  How many accounts spent more than 30,000 usd total across all orders?

    SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
    FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY a.id, a.name
    HAVING SUM(o.total_amt_usd) > 30000
    ORDER BY total_spent;

  --  How many accounts spent less than 1,000 usd total across all orders?

    SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
    FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY a.id, a.name
    HAVING SUM(o.total_amt_usd) < 1000
    ORDER BY total_spent;

  --  Which account has spent the most with us?

    SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
    FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY a.id, a.name
    ORDER BY total_spent DESC
    LIMIT 1;

  --  Which account has spent the least with us?

    SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
    FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY a.id, a.name
    ORDER BY total_spent
    LIMIT 1;

   -- Which accounts used facebook as a channel to contact customers more than 6 times?

    SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
    FROM accounts a
    JOIN web_events w
    ON a.id = w.account_id
    GROUP BY a.id, a.name, w.channel
    HAVING COUNT(*) > 6 AND w.channel = 'facebook'
    ORDER BY use_of_channel;

  --  Which account used facebook most as a channel?

    SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
    FROM accounts a
    JOIN web_events w
    ON a.id = w.account_id
    WHERE w.channel = 'facebook'
    GROUP BY a.id, a.name, w.channel
    ORDER BY use_of_channel DESC
    LIMIT 1;

   -- Note: This query above only works if there are no ties for the account that used facebook the most. It is a best practice to use a larger limit number first such as 3 or 5 to see if there are ties before using LIMIT 1.

   -- Which channel was most frequently used by most accounts?

    SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
    FROM accounts a
    JOIN web_events w
    ON a.id = w.account_id
    GROUP BY a.id, a.name, w.channel
    ORDER BY use_of_channel DESC
    LIMIT 10;

  --  All of the top 10 are direct.

--SQL Subqueries & Temporary Tables


--Solutions to Your First Subquery

   -- First, we needed to group by the day and channel. Then ordering by the number of events (the third column) gave us a quick way to answer the first question.

    SELECT DATE_TRUNC('day',occurred_at) AS day,
       channel, COUNT(*) as events
    FROM web_events
    GROUP BY 1,2
    ORDER BY 3 DESC;

 --   Here you can see that to get the entire table in question 1 back, we included an * in our SELECT statement. You will need to be sure to alias your table.

    SELECT *
    FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
               channel, COUNT(*) as events
         FROM web_events 
         GROUP BY 1,2
         ORDER BY 3 DESC) sub;

  --  Finally, here we are able to get a table that shows the average number of events a day for each channel.

    SELECT channel, AVG(events) AS average_events
    FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
                 channel, COUNT(*) as events
          FROM web_events 
          GROUP BY 1,2) sub
    GROUP BY channel
    ORDER BY 2 DESC;
-------------------------------------------------
SELECT AVG(standard_qty) avg_std, AVG(gloss_qty) avg_gls, AVG(poster_qty) avg_pst
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
     (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);
	 
	-- same as 
	 
	 SELECT AVG(standard_qty) avg_std, AVG(gloss_qty) avg_gls, AVG(poster_qty) avg_pst
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
     (SELECT DATE_TRUNC('month', occurred_at) 
FROM orders 
 order by occurred_at desc limit 1) ;
 
 
 --WITH Solutions

--Below, you will see each of the previous solutions restructured using the WITH clause. This is often an easier way to read a query.

   -- Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.

    WITH t1 AS (
      SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
       FROM sales_reps s
       JOIN accounts a
       ON a.sales_rep_id = s.id
       JOIN orders o
       ON o.account_id = a.id
       JOIN region r
       ON r.id = s.region_id
       GROUP BY 1,2
       ORDER BY 3 DESC), 
    t2 AS (
       SELECT region_name, MAX(total_amt) total_amt
       FROM t1
       GROUP BY 1)
    SELECT t1.rep_name, t1.region_name, t1.total_amt
    FROM t1
    JOIN t2
    ON t1.region_name = t2.region_name AND t1.total_amt = t2.total_amt;

  --  For the region with the largest sales total_amt_usd, how many total orders were placed?

    WITH t1 AS (
       SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
       FROM sales_reps s
       JOIN accounts a
       ON a.sales_rep_id = s.id
       JOIN orders o
       ON o.account_id = a.id
       JOIN region r
       ON r.id = s.region_id
       GROUP BY r.name), 
    t2 AS (
       SELECT MAX(total_amt)
       FROM t1)
    SELECT r.name, COUNT(o.total) total_orders
    FROM sales_reps s
    JOIN accounts a
    ON a.sales_rep_id = s.id
    JOIN orders o
    ON o.account_id = a.id
    JOIN region r
    ON r.id = s.region_id
    GROUP BY r.name
    HAVING SUM(o.total_amt_usd) = (SELECT * FROM t2);

 --   For the account that purchased the most (in total over their lifetime as a customer) standard_qty paper, how many accounts still had more in total purchases?

    WITH t1 AS (
      SELECT a.name account_name, SUM(o.standard_qty) total_std, SUM(o.total) total
      FROM accounts a
      JOIN orders o
      ON o.account_id = a.id
      GROUP BY 1
      ORDER BY 2 DESC
      LIMIT 1), 
    t2 AS (
      SELECT a.name
      FROM orders o
      JOIN accounts a
      ON a.id = o.account_id
      GROUP BY 1
      HAVING SUM(o.total) > (SELECT total FROM t1))
    SELECT COUNT(*)
    FROM t2;

  --  For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?

    WITH t1 AS (
       SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
       FROM orders o
       JOIN accounts a
       ON a.id = o.account_id
       GROUP BY a.id, a.name
       ORDER BY 3 DESC
       LIMIT 1)
    SELECT a.name, w.channel, COUNT(*)
    FROM accounts a
    JOIN web_events w
    ON a.id = w.account_id AND a.id =  (SELECT id FROM t1)
    GROUP BY 1, 2
    ORDER BY 3 DESC;

   -- What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?

    WITH t1 AS (
       SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
       FROM orders o
       JOIN accounts a
       ON a.id = o.account_id
       GROUP BY a.id, a.name
       ORDER BY 3 DESC
       LIMIT 10)
    SELECT AVG(tot_spent)
    FROM t1;


   -- What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders.

    WITH t1 AS (
       SELECT AVG(o.total_amt_usd) avg_all
       FROM orders o
       JOIN accounts a
       ON a.id = o.account_id),
    t2 AS (
       SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
       FROM orders o
       GROUP BY 1
       HAVING AVG(o.total_amt_usd) > (SELECT * FROM t1))
    SELECT AVG(avg_amt)
    FROM t2;


--Data Cleaning

--LEFT & RIGHT Solutions

    SELECT RIGHT(website, 3) AS domain, COUNT(*) num_companies
    FROM accounts
    GROUP BY 1
    ORDER BY 2 DESC;

    SELECT LEFT(UPPER(name), 1) AS first_letter, COUNT(*) num_companies
    FROM accounts
    GROUP BY 1
    ORDER BY 2 DESC;

   -- There are 350 company names that start with a letter and 1 that starts with a number. This gives a ratio of 350/351 that are company names that start with a letter or 99.7%.

    SELECT SUM(num) nums, SUM(letter) letters
    FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                           THEN 1 ELSE 0 END AS num, 
             CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                           THEN 0 ELSE 1 END AS letter
          FROM accounts) t1;

   -- There are 80 company names that start with a vowel and 271 that start with other characters. Therefore 80/351 are vowels or 22.8%. Therefore, 77.2% of company names do not start with vowels.

    SELECT SUM(vowels) vowels, SUM(other) other
    FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') 
                            THEN 1 ELSE 0 END AS vowels, 
              CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') 
                           THEN 0 ELSE 1 END AS other
             FROM accounts) t1;

--POSITION, STRPOS, & SUBSTR Solutions
--Use the accounts table to create first and last name columns that
--hold the first and last names for the primary_poc
    SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) first_name, 
    RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name
    FROM accounts;

    SELECT LEFT(name, STRPOS(name, ' ') -1 ) first_name, 
           RIGHT(name, LENGTH(name) - STRPOS(name, ' ')) last_name
    FROM sales_reps;
	--do same for sales rep
	SELECT name,
LEFT(name,STRPOS(name,' ')-1) as Firstname,
Right(name, (LENGTH(name) - STRPOS(name,' '))) as Lastname
FROM sales_reps
		  
--CONCAT Solutions
Quizzes CONCAT

   -- Each company in the accounts table wants to create an email address for each primary_poc. The email address should be the first name of the primary_poc . last name primary_poc @ company name .com.

  --  You may have noticed that in the previous solution some of the company names include spaces, which will certainly not work in an email address. See if you can create an email address that will work by removing all of the spaces in the account name, but otherwise your solution should be just as in question 1. Some helpful documentation is here.

   -- We would also like to create an initial password, which they will change after their first log in. The first password will be the first letter of the primary_poc's first name (lowercase), then the last letter of their first name (lowercase), the first letter of their last name (lowercase), the last letter of their last name (lowercase), the number of letters in their first name, the number of letters in their last name, and then the name of the company they are working with, all capitalized with no spaces.


    WITH t1 AS (
     SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name,  RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
     FROM accounts)
    SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', name, '.com')
    FROM t1;

    WITH t1 AS (
     SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name,  RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
     FROM accounts)
    SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', REPLACE(name, ' ', ''), '.com')
    FROM  t1;

    WITH t1 AS (
     SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name,  RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
     FROM accounts)
    SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', name, '.com'), LEFT(LOWER(first_name), 1) || RIGHT(LOWER(first_name), 1) || LEFT(LOWER(last_name), 1) || RIGHT(LOWER(last_name), 1) || LENGTH(first_name) || LENGTH(last_name) || REPLACE(UPPER(name), ' ', '')
    FROM t1;

--COALESCE Solutions

    SELECT *
    FROM accounts a
    LEFT JOIN orders o
    ON a.id = o.account_id
    WHERE o.total IS NULL; 

    SELECT COALESCE(o.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, o.*
    FROM accounts a
    LEFT JOIN orders o
    ON a.id = o.account_id
    WHERE o.total IS NULL;

    SELECT COALESCE(o.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, o.standard_qty, o.gloss_qty, o.poster_qty, o.total, o.standard_amt_usd, o.gloss_amt_usd, o.poster_amt_usd, o.total_amt_usd
    FROM accounts a
    LEFT JOIN orders o
    ON a.id = o.account_id
    WHERE o.total IS NULL;

    SELECT COALESCE(o.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, COALESCE(o.standard_qty, 0) standard_qty, COALESCE(o.gloss_qty,0) gloss_qty, COALESCE(o.poster_qty,0) poster_qty, COALESCE(o.total,0) total, COALESCE(o.standard_amt_usd,0) standard_amt_usd, COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, COALESCE(o.poster_amt_usd,0) poster_amt_usd, COALESCE(o.total_amt_usd,0) total_amt_usd
    FROM accounts a
    LEFT JOIN orders o
    ON a.id = o.account_id
    WHERE o.total IS NULL;

    SELECT COUNT(*)
    FROM accounts a
    LEFT JOIN orders o
    ON a.id = o.account_id;

    SELECT COALESCE(o.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, COALESCE(o.standard_qty, 0) standard_qty, COALESCE(o.gloss_qty,0) gloss_qty, COALESCE(o.poster_qty,0) poster_qty, COALESCE(o.total,0) total, COALESCE(o.standard_amt_usd,0) standard_amt_usd, COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, COALESCE(o.poster_amt_usd,0) poster_amt_usd, COALESCE(o.total_amt_usd,0) total_amt_usd
    FROM accounts a
    LEFT JOIN orders o
    ON a.id = o.account_id;

--windows functions
--Creating a Partitioned Running Total Using Window Functions

--Now, modify your query from the previous quiz to include partitions. Still create a running total of standard_amt_usd (in the orders table) over order time, but this time, date truncate occurred_at by year and partition by that same year-truncated occurred_at variable. Your final table should have three columns: One with the amount being added for each row, one for the truncated date, and a final column with the running total within each year.

SELECT standard_amt_usd,
       DATE_TRUNC('year', occurred_at) as year,
       SUM(standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year', occurred_at) ORDER BY occurred_at) AS running_total
FROM orders

--Aggregates in Window Functions with and without ORDER BY

--Run the query that Derek wrote in the previous video in the first SQL Explorer below. Keep the query results in mind; you'll be comparing them to the results of another query next.

SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS max_std_qty
FROM orders


Aliases for Multiple Window Functions

SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER account_year_window AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER account_year_window AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER account_year_window AS count_total_amt_usd,
       AVG(total_amt_usd) OVER account_year_window AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER account_year_window AS min_total_amt_usd,
       MAX(total_amt_usd) OVER account_year_window AS max_total_amt_usd
FROM orders 
WINDOW account_year_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at))

--Comparing a Row to Previous Row

--In the previous video, Derek outlines how to compare a row to a previous or subsequent row. This technique can be useful when analyzing time-based events. Imagine you're an analyst at Parch & Posey and you want to determine how the current order's total revenue ("total" meaning from sales of all types of paper) compares to the next order's total revenue.

--Modify Derek's query from the previous video in the SQL Explorer below to perform this analysis. You'll need to use occurred_at and total_amt_usd in the orders table along with LEAD to do so. In your query results, there should be four columns: occurred_at, total_amt_usd, lead, and lead_difference.

SELECT account_id,
       standard_sum,
       LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag,
       LEAD(standard_sum) OVER (ORDER BY standard_sum) AS lead,
       standard_sum - LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag_difference,
       LEAD(standard_sum) OVER (ORDER BY standard_sum) - standard_sum AS lead_difference
FROM (
SELECT account_id,
       SUM(standard_qty) AS standard_sum
  FROM orders 
 GROUP BY 1
 ) sub
--Comparing a Row to a Previous Row

SELECT occurred_at,
       total_amt_usd,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) AS lead,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) - total_amt_usd AS lead_difference
FROM (
SELECT occurred_at,
       SUM(total_amt_usd) AS total_amt_usd
  FROM orders 
 GROUP BY 1
) sub


--Percentiles with Partitions


SELECT
       account_id,
       occurred_at,
       standard_qty,
       NTILE(4) OVER (PARTITION BY account_id ORDER BY standard_qty) AS standard_quartile
  FROM orders 
 ORDER BY account_id DESC

--2.

SELECT
       account_id,
       occurred_at,
       gloss_qty,
       NTILE(2) OVER (PARTITION BY account_id ORDER BY gloss_qty) AS gloss_half
  FROM orders 
 ORDER BY account_id DESC

--3.

SELECT
       account_id,
       occurred_at,
       total_amt_usd,
       NTILE(100) OVER (PARTITION BY account_id ORDER BY total_amt_usd) AS total_percentile
  FROM orders 
 ORDER BY account_id DESC
