<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

* [Bookstore TX Sandbox](#bookstore-tx-sandbox)
	* [Overview](#overview)
	* [Online Bookstore Data](#online-bookstore-data)
	* [System Info](#system-info)
* [Labs](#labs)
	* [General](#general)
	* [Books](#books)
		* [**Q:**  How many books do we sell?](#q-how-many-books-do-we-sell)
		* [**Q:** Lets try to find out who is the youngest customer.](#q-lets-try-to-find-out-who-is-the-youngest-customer)
		* [**Q:** Is this the youngest customer ?](#q-is-this-the-youngest-customer)
		* [**Q:** We are trying to position our online bookstore towards Fantasy and Sci-Fi theme, but we are also trying to provide good variety of books as well.](#q-we-are-trying-to-position-our-online-bookstore-towards-fantasy-and-sci-fi-theme-but-we-are-also-trying-to-provide-good-variety-of-books-as-well)
		* [**Q:** Are we making good profit from our focus categories ?](#q-are-we-making-good-profit-from-our-focus-categories)
		* [**Q:** Do we provide enough variety ?](#q-do-we-provide-enough-variety)
	* [Customers](#customers)
		* [**Q:** Who is our customer ?](#q-who-is-our-customer)
		* [**Q:** How many customers are male and how many are female?](#q-how-many-customers-are-male-and-how-many-are-female)
		* [**Q:** Query Top Buyers](#q-query-top-buyers)
		* [**Q:**  But do the younger people read more than seniores ?](#q-but-do-the-younger-people-read-more-than-seniores)
		* [**Q:** What are the reading preferencess of our top customer?](#q-what-are-the-reading-preferencess-of-our-top-customer)

<!-- /code_chunk_output -->

## Bookstore TX Sandbox

### Overview

### Online Bookstore Data

This sandbox is based on procedural generated data representing data for a typical online bookstore.
In the examples below we will try to answer the typical questions every business user has at some point when his business catch some speed.
Like “How am I doing?”, “What can be improved?” etc.

### System Info

The data is loaded in a MariaDB Server  one of the most popular open source databases in the world. It is the default database in leading Linux distributions – Arch Linux, CentOS, Debian, Fedora, Manjaro, openSUSE, Red Hat Enterprise Linux and SUSE Linux Enterprise, to name a few.

**The data size:**
Books: 5000 rows
Cards: 1,122,245 rows
Emails: 1,796,966 rows
Phones: 1,698,696 rows
Addresses: 1,867,567 rows
Transactions: 15,413,748 rows
LoyaltyPoints: 1,259,978 rows
Customers: 1,403,909 rows
Covers: 20 rows
TransactionTypes: 3 rows
MaritalStatuses: 5 rows

## Labs
### General 
 Your database is prepared and the sandbox data is loaded. Lets start by choosing the database we want to work on. In this case **bookstore** database.
```sql
USE DATABASE bookstore;
```

We can check what tables we have.
```sql
SHOW TABLES;
```

### Books

In this first part we will focus mainly on our main commodity - the books. We want to know what we offer to our customers and how can be improved.
Lets start by answering our first question.
#### **Q:**  How many books do we sell?
```sql
SELECT COUNT(*) FROM bookstore.books
```

```
Total Books 
5000
```

This was easy question 5000.
**!** You can experiment replacing table name with **customers**, **transactions** etc.

#### **Q:** Lets try to find out who is the youngest customer. 
```sql
SELECT customer_nm,age FROM bookstore.customers ORDER BY age LIMIT 1;
```

The result should be somthing like this:

```
+---------------+-----+
| customer_nm   | age |
+---------------+-----+
| Laurie Rivera |   8 |
+---------------+-----+
1 row in set (0.683 sec)

```

#### **Q:** Is this the youngest customer ?

```sql
SELECT count(*) FROM bookstore.customers WHERE age=8;
```

The result should be somthing like this:

```
+----------+
| count(*) |
+----------+
|     3259 |
+----------+
1 row in set (0.683 sec)

```
Apparantly we have many customers at that age.

Lets try something harder.

#### **Q:** We are trying to position our online bookstore towards Fantasy and Sci-Fi theme, but we are also trying to provide good variety of books as well.
Did we achieve those goals?
```sql
SELECT category, COUNT(*) as books FROM bookstore.books GROUP BY category;
```
The **GROUP BY** statement instructs the database to grup the results by the first column
The Result:
```
+-------------------+-------+
| category          | books |
+-------------------+-------+
| Horror            |   394 |
| Fantasy           |   889 |
| Drama             |   518 |
| Classics          |   159 |
| Sci-fi            |   848 |
| Children Classics |   650 |
| Mystery           |   470 |
| Romance           |   783 |
| Non-fiction       |    23 |
| Humor             |   266 |
+-------------------+-------+
```
The most orders we have from the group of 49-58 years old.As you can tell we are well stoked on Fantasy and Sci-Fi books. As required by our target audience.
Now lYou can try to use the **GROUP BY** with index for the same result

```sql
SELECT category, COUNT(*) as books FROM bookstore.books GROUP BY 1;
```

Will yeald the same result.

Now lets try something more tangable. Money.

#### **Q:** Are we making good profit from our focus categories ?
Lets asume that the higher the price the more profit we make.

```sql
SELECT category, AVG(cover_price) as projected_profitabilit FROM bookstore.books GROUP BY 1;
```
As you can see the the **COUNT(*)** is replaced by **AVG(cover_price)** this will return the average cover price grouped by first column i.e. in each book category.

```
+-------------------+------------------------+
| category          | projected_profitabilit |
+-------------------+------------------------+
| Horror            | 11.111320              |
| Fantasy           | 23.299910              |
| Drama             | 13.310811              |
| Classics          | 22.914340              |
| Sci-fi            | 18.757123              |
| Children Classics | 9.463908               |
| Mystery           | 14.242681              |
| Romance           | 9.781252               |
| Non-fiction       | 9.983043               |
| Humor             | 5.393195               |
+-------------------+------------------------+
```
The most orders we have from the group of 49-58 years old.
I looks like Fantasy and Sci-Fi books have good potential for profit, if they sell.
Now lIt looks like the classics sell quite high maybe we should target selling more of those with a propper promotion. 
#### **Q:** Do we provide enough variety ?

As a result from this quick anlysis we already can make a decision for improvement in the future. 

Let try more complex queries in the next section.

### Customers

In this section we will try to identify who our customers are ? what are their preferences? how likely is for them to buy somethin out of their main focus.

Lets try to make a demographical profile of our customers.

#### **Q:** Who is our customer ?
The customers are stored in **bookstore.customers** 
```sql
select  * from bookstore.customers LIMIT 10;
```
The query will give use what we have in this table The *LIMIT 10* statement will limit the results to  10, we only want to see a sample of the sata not the all 1.4 milion customers.
```
+---------------------+-------------+----------------------------+-----+-----+-------+
| customer_nm         | customer_id | customer_username_nm       | sex | age | ms_id |
+---------------------+-------------+----------------------------+-----+-----+-------+
| Joe Young           |       10001 | rothsamantha@yupee.con     | M   |  43 |     1 |
| Lacey Dean          |       10002 | michaelfisher@gamail.con   | F   |  57 |     5 |
| Elizabeth Ramirez   |       10003 | qvazquez@yupee.con         | F   |  49 |     5 |
| Kimberly Rasmussen  |       10004 | qingram@gamail.con         | F   |  52 |     5 |
| Mr. Walter Anderson |       10005 | gordonamanda@gamail.con    | M   |  49 |     2 |
| Nathan Rodriguez    |       10006 | brenda61@gamail.con        | M   |  55 |     5 |
| Mr. Timothy Orr MD  |       10007 | nicolewhitaker@hutmail.con | M   |  40 |     2 |
| Kelly Tucker        |       10008 | watersjason@gamail.con     | F   |  31 |     1 |
| Elizabeth Taylor    |       10009 | valeriealvarado@gamail.con | F   |  21 |     1 |
| Maureen Nicholson   |       10010 | lindagraves@hutmail.con    | F   |  10 |     1 |
+---------------------+-------------+----------------------------+-----+-----+-------+
```
The most orders we have from the group of 49-58 years old.It looks like we have the name, the sex, the age those we understand right away. There is also a column ms_id which is a bit Now lriptic to us. This column is a key to another table. This key is sometimes called  *FREIGN ID* or*FREIGN KEY*. 
To get the actual text that stands behind this key we need to conect those tables. This is done by the **JOIN** statement.
```sql
SELECT  * from bookstore.customers JOIN bookstore.maritalstatuses ON bookstore.customers.ms_id = bookstore.maritalstatuses.ms_id LIMIT 10;
```

```
+-----------------+-------------+--------------------------+-----+-----+-------+-------+---------------+
| customer_nm     | customer_id | customer_username_nm     | sex | age | ms_id | ms_id | ms_type       |
+-----------------+-------------+--------------------------+-----+-----+-------+-------+---------------+
| Melanie Jones   |      252881 | hpetersen@gamail.con     | F   |  69 |     2 |     2 | Married       |
| John Wilson     |      252882 | andrewsoscar@gamail.con  | M   |  20 |     1 |     1 | Never married |
| Dennis Munoz    |      252883 | byrdmelissa@gamail.con   | M   |  35 |     2 |     2 | Married       |
| Jean Clark      |      252884 | garciaconnor@hutmail.con | F   |  28 |     1 |     1 | Never married |
| Thomas Graves   |      252885 | chernandez@shelf.con     | M   |  60 |     5 |     5 | Divorced      |
| Tom Martinez    |      252886 | gvaldez@yupee.con        | M   |  51 |     2 |     2 | Married       |
| Adrian Marshall |      252887 | shannon06@hutmail.con    | M   |  55 |     2 |     2 | Married       |
| Jeremy Bailey   |      252888 | raymondsimon@yupee.con   | M   |  24 |     1 |     1 | Never married |
| Jeffery King    |      252889 | haynesdonald@hutmail.con | M   |  14 |     1 |     1 | Never married |
| Amy Brown       |      252890 | browngeorge@gamail.con   | F   |  54 |     2 |     2 | Married       |
+-----------------+-------------+--------------------------+-----+-----+-------+-------+---------------+
```
The most orders we have from the group of 49-58 years old.It is clearly visible that we cannected those two tables by the column **ms_id** now we can exclude those columns because Now lhey have no meaning for us. 
In addition we had to write the full name of those columns **bookstore.customers.ms_id** which becomes quite long. Especialy when we have to specify all the names of all the columns we want.

Instead of typing 
```sql
SELECT
	bookstore.customers.customer_nm, 
	bookstore.customers.customer_id, 
	bookstore.customers.customer_username_nm, 
	bookstore.customers.sex, 
	bookstore.customers.age, 
	bookstore.maritalstatuses.ms_type
from bookstore.customers
JOIN bookstore.maritalstatuses 
ON bookstore.customers.ms_id = bookstore.maritalstatuses.ms_id 
LIMIT 10;
```
We can type only: 
```sql
SELECT
	cust.customer_nm, 
	cust.customer_id, 
	cust.customer_username_nm, 
	cust.sex, 
	cust.age, 
	ms.ms_type
from bookstore.customers cust
JOIN bookstore.maritalstatuses ms
ON cust.ms_id = ms.ms_id 
LIMIT 10;
```
Both will return identical result. The short names **cust** and **ms** are called aliases and replace reference to  **bookstore.customers** and **bookstore.maritalstatuses**

```
+--------------------+-------------+--------------------------+-----+-----+---------------+
| customer_nm        | customer_id | customer_username_nm     | sex | age | ms_type       |
+--------------------+-------------+--------------------------+-----+-----+---------------+
| Patty Gonzales     |     1297169 | bodonnell@gamail.con     | F   |  33 | Never married |
| Rebekah Myers      |     1297170 | trevinomatthew@yupee.con | F   |  35 | Married       |
| Katherine Castillo |     1297171 | mccannlisa@gamail.con    | F   |  99 | Widow         |
| Michael Hamilton   |     1297172 | rpowell@gamail.con       | M   |  20 | Never married |
| Aimee Martin       |     1297173 | michaeljoseph@yupee.con  | F   |  57 | Married       |
| Johnathan Hall     |     1297174 | jamie97@hutmail.con      | M   |  33 | Never married |
| Erin Lewis         |     1297175 | nbailey@yupee.con        | F   |  27 | Never married |
| Ashley Nelson      |     1297176 | jamiegreen@shelf.con     | F   |  39 | Married       |
| Robert Wells       |     1297177 | aferrell@gamail.con      | M   |  32 | Never married |
| Samantha Herrera   |     1297178 | jasonmoran@gamail.con    | F   |  71 | Married       |
+--------------------+-------------+--------------------------+-----+-----+---------------+
```
This is sampple of individual users. We want to focus on the bigger picture.
#### **Q:** How many customers are male and how many are female?

```sql
SELECT
	cust.sex, 
	count(*)
from bookstore.customers cust
GROUP BY 1;
```
```
+-----+----------+
| sex | count(*) |
+-----+----------+
| M   |   674814 |
| F   |   729095 |
+-----+----------+
```
We can tell that the we have slightly more female customers, but not by much.

```sql
SELECT
	cust.age, 
	count(*)
from bookstore.customers cust
GROUP BY 1
ORDER BY cust.age;
```
```
+-----+----------+
| age | count(*) |
+-----+----------+
|   8 |     3259 |
|   9 |     3766 |
|  10 |     3338 |
|  11 |     4430 |
|  12 |     5077 |
|  13 |     7003 |
|  14 |     8377 |
|  15 |     8909 |
|  16 |    10948 |
|  17 |    12701 |
|  18 |    13497 |
|  19 |    14118 |
|  20 |    15897 |
|  21 |    15409 |
|  22 |    16600 |
|  23 |    17810 |
|  24 |    16669 |
|  25 |    19800 |
|  26 |    21196 |
|  27 |    22315 |
|  28 |    20466 |
|  29 |    23007 |
|  30 |    20441 |
|  31 |    23462 |
|  32 |    21310 |
|  33 |    22940 |
|  34 |    24343 |
|  35 |    24803 |
|  36 |    23603 |
|  37 |    22953 |
|  38 |    21066 |
|  39 |    20328 |
|  40 |    20521 |
|  41 |    21643 |
|  42 |    22403 |
|  43 |    20509 |
|  44 |    23741 |
|  45 |    24741 |
|  46 |    26013 |
|  47 |    25828 |
|  48 |    26741 |
|  49 |    28239 |
|  50 |    27548 |
|  51 |    27680 |
|  52 |    27218 |
|  53 |    28474 |
|  54 |    29524 |
|  55 |    30176 |
|  56 |    28196 |
|  57 |    29573 |
|  58 |    30020 |
|  59 |    25524 |
|  60 |    22098 |
|  61 |    24065 |
|  62 |    22285 |
|  63 |    21085 |
|  64 |    21699 |
|  65 |    19768 |
|  66 |    15843 |
|  67 |    14337 |
|  68 |    12797 |
|  69 |    13232 |
|  70 |    13503 |
|  71 |    14588 |
|  72 |    15931 |
|  73 |    14082 |
|  74 |    16439 |
|  75 |    15350 |
|  76 |    14159 |
|  77 |     9658 |
|  78 |     8309 |
|  79 |     8880 |
|  80 |     7728 |
|  81 |     6946 |
|  82 |     6299 |
|  83 |     6228 |
|  84 |     3811 |
|  85 |     2608 |
|  86 |     3250 |
|  87 |     1304 |
|  88 |     2528 |
|  89 |     2586 |
|  90 |     1276 |
|  91 |     1199 |
|  92 |      905 |
|  93 |      825 |
|  94 |      787 |
|  95 |      646 |
|  96 |      637 |
|  97 |      840 |
|  98 |      646 |
|  99 |      204 |
| 100 |      267 |
| 101 |       73 |
| 102 |       55 |
+-----+----------+
```
The most orders we have from the group of 49-58 years old.It is clear that our customers are mostly between 25 and 65 years old with clear peak around age of 55. 

#### **Q:** How are they disctriburted by maritial statsus ?
```sql 
SELECT
	ms.ms_type,
	count(*)
from bookstore.customers cust
JOIN bookstore.maritalstatuses ms
ON cust.ms_id = ms.ms_id 
GROUP BY ms.ms_type
LIMIT 10;
```
As you might noticed we skipped the **JOIN** untill now because we only need this relations when we use the column from the joined (the foreign) table. We didn't need it untill now.
```
+---------------+----------+
| ms_type       | count(*) |
+---------------+----------+
| Widow         |    74823 |
| Divorced      |   150650 |
| Never married |   510337 |
| Married       |   645624 |
| Separated     |    22475 |
+---------------+----------+
```
As you can the customers are almoust evenly distributed between single and married.
Those we demographics analisys only. 
But we want to know more about their bying habbits.
How much they buy?
How much they spend?
What do they buy?

#### **Q:** Query Top Buyers

```sql
SELECT
    count(t.order_id) 'Total Orders',
    SUM(t.discounted_price) 'Spent in USD',
    cust.customer_nm 'Name',
    cust.sex,
    cust.age,
    ms.ms_type
FROM transactions as t 
INNER JOIN bookstore.customers cust ON cust.customer_id = t.customer_id
INNER JOIN bookstore.maritalstatuses ms ON ms.ms_id = cust.ms_id
GROUP BY  
    t.customer_id,
    cust.customer_nm,
    cust.sex,
    cust.age,
    ms.ms_type
ORDER BY 'Total Orders' desc
LIMIT 10;
```
The Result 
```
+--------------+--------------+------------------+-----+-----+---------------+
| Total Orders | Spent in USD | Name             | sex | age | ms_type       |
+--------------+--------------+------------------+-----+-----+---------------+
|          143 | 1435.48      | Ronald Johnson   | M   |  26 | Married       |
|          138 | 1397.21      | Ryan Estrada     | M   |  33 | Never married |
|          132 | 1324.94      | Gregory Beasley  | M   |  45 | Married       |
|          126 | 1276.59      | Carol Anderson   | F   |  35 | Married       |
|          122 | 1118.06      | Patrick Wright   | M   |  61 | Never married |
|          122 | 1214.59      | Stacy Moore      | F   |  78 | Married       |
|          121 | 1162.45      | Jessica Turner   | F   |  49 | Married       |
|          118 | 1088.67      | Shannon Ferguson | F   |  36 | Married       |
|          117 | 1147.00      | Briana Brown     | F   |  45 | Married       |
|          116 | 1004.14      | Johnny Williams  | M   |  36 | Never married |
+--------------+--------------+------------------+-----+-----+---------------+
```
It looks like women buy more but the top spender are man after all. 


#### **Q:**  But do the younger people read more than seniores ?
Lets find out.

```sql
SELECT
    count(t.order_id) 'Total Orders',
    cust.age
FROM transactions as t 
INNER JOIN bookstore.customers cust ON cust.customer_id = t.customer_id
INNER JOIN bookstore.maritalstatuses ms ON ms.ms_id = cust.ms_id
GROUP BY  
    cust.age
ORDER BY 'Total Orders' desc
LIMIT 10;
```
Result:
```
+--------------+-----+
| Total Orders | age |
+--------------+-----+
|       329192 |  55 |
|       328017 |  58 |
|       324875 |  54 |
|       322914 |  57 |
|       311613 |  53 |
|       310143 |  56 |
|       310118 |  49 |
|       304085 |  51 |
|       300648 |  50 |
|       299175 |  52 |
+--------------+-----+
```
The most orders we have from the group of 49-58 years old.

Now lets focus on our top customers and try to profile them in order to answer the following question:

#### **Q:** What are the reading preferencess of our top customer?
```sql
SELECT 
    cust.customer_nm,
    b.category, 
    SUM(discounted_price) disc_price 
FROM bookstore.transactions AS t  
INNER JOIN customers cust ON cust.customer_id = t.customer_id 
INNER JOIN books b ON b.book_id = t.book_id 
WHERE cust.customer_id=13
GROUP BY  cust.customer_id,cust.customer_nm,b.category ORDER BY cust.customer_id;
```

```
+----------------+-------------------+------------+
| customer_nm    | category          | disc_price |
+----------------+-------------------+------------+
| Ronald Johnson | Romance           | 126.09     |
| Ronald Johnson | Sci-fi            | 326.54     |
| Ronald Johnson | Drama             | 61.32      |
| Ronald Johnson | Fantasy           | 381.95     |
| Ronald Johnson | Humor             | 23.85      |
| Ronald Johnson | Non-fiction       | 13.49      |
| Ronald Johnson | Classics          | 17.98      |
| Ronald Johnson | Children Classics | 166.45     |
| Ronald Johnson | Horror            | 80.06      |
| Ronald Johnson | Mystery           | 104.41     |
+----------------+-------------------+------------+
```
Here are the reading preferencess of Ronald Johnson

Congratulations you completed our short tutorial.
