use sqlasnt;
create table city(
Id int,
Name varchar(17),
country_code varchar(3),
District varchar(20),
Population int,
primary key(Id)
);
# first step - Copy Exel data in new excelsheet
# second step convert the excel data in csv formate
# Third step- import the csv data into the city table
# Q1. Query all columns for all American cities in the CITY table with populations larger than 100000.
# The CountryCode for America is USA.
# The CITY table is described as follows:
SELECT * FROM sqlasnt.city;
describe city;

select Id,Name,country_code,District,Population
from city
where country_code = 'USA' and Population > 100000;
describe city;
# Q2. Query the NAME field for all American cities in the CITY table with populations larger than 120000.
# The CountryCode for America is USA.
# The CITY table is described as follows
# Ans

SELECT Name,Population
FROM city
WHERE country_code = 'USA' and Population > 120000;

# Q3. Query all columns (attributes) for every row in the CITY table.
# The CITY table is described as follows:
# Ans
select Id,Name,country_code,District,Population
from city;

# Q4. Query all columns for a city in CITY with the ID 1661.
# Ans
select Id,Name,country_code,District,Population
from city
where id=1661

# Q5. Query all attributes of every Japanese city in the CITY table. The COUNTRYCODE for Japan is JPN.
# Ans
select Id,Name,country_code,District,Population
from city
where country_code = 'JPN';

# Q6. Query the names of all the Japanese cities in the CITY table. The COUNTRYCODE for Japan is JPN.

select District
from city
where country_code = 'JPN';


# The STATION table is described as follows:

create table station(
Id int,
City varchar(21),
State varchar(2),
LAT_N int,
LAT_W int,
primary key(Id)
);
SELECT * FROM sqlasnt.station;
describe station;

# Q7. Query a list of CITY and STATE from the STATION table.
# Ans
select City,State
from station;

# Q8. Query a list of CITY names from STATION for cities that have an even ID number. 
# Print the results in any order, but exclude duplicates from the answer.
# Ans
select distinct City,Id
from station
where Id%2=0
order by Id;

# Q9. Find the difference between the total number of CITY entries in the table and the number of
# distinct CITY entries in the table
# Ans
# -- Calculate the total number of cities
SELECT COUNT(DISTINCT City) AS total_cities
FROM station;

# -- Calculate the total number of duplicate cities
SELECT COUNT(City) AS total_duplicates
FROM (
    SELECT City
    FROM station
    GROUP BY City
    HAVING COUNT(City) > 1
) AS duplicate_cities;

# -- Find the difference between total cities and total duplicate cities
SELECT 
    (SELECT COUNT(DISTINCT City) FROM station) - 
    (SELECT COUNT(City) FROM (
        SELECT City
        FROM station
        GROUP BY City
        HAVING COUNT(City) > 1
    ) AS duplicate_cities) AS difference;
 # Q.10 Query the two cities in STATION with the shortest and longest CITY names,
 # as well as their respective lengths (i.e.: number of characters in the name). 
 # If there is more than one smallest or largest city, 
 # choose the one that comes first when ordered alphabetically.
 # The STATION table is described as follows:
# Ans

# -- City with the shortest name and its length
SELECT City, LENGTH(City)
FROM station
WHERE LENGTH(City) = (SELECT MIN(LENGTH(City)) FROM station)
ORDER BY City
LIMIT 1;

# -- City with the longest name and its length
SELECT City, LENGTH(City)
FROM station
WHERE LENGTH(City) = (SELECT MAX(LENGTH(City)) FROM station)
ORDER BY City
LIMIT 1;


# Q11. Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION.
# Your result cannot contain duplicates
# Ans

SELECT DISTINCT City
FROM station
WHERE City REGEXP '^[aeiouAEIOU]'
ORDER BY City;

# Q12. Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION.
# Your result cannot contain duplicates
# Ans
SELECT DISTINCT City
FROM station
WHERE City REGEXP '[aeiouAEIOU]$'
ORDER BY City;

# Q13. Query the list of CITY names from STATION that do not start with vowels. 
# Your result cannot contain duplicates
# Ans

SELECT DISTINCT City
FROM station
WHERE City NOT REGEXP '^[aeiouAEIOU]'
ORDER BY City;

# Q14. Query the list of CITY names from STATION that do not end with vowels.
# Your result cannot contain duplicates.
# Ans

SELECT DISTINCT City
FROM station
WHERE City NOT REGEXP '[aeiouAEIOU]$'
ORDER BY City;

# Q15. Query the list of CITY names from STATION that either do not start with vowels or do not end with vowels.
# Your result cannot contain duplicates.
# Ans

SELECT DISTINCT city
FROM station
WHERE City NOT REGEXP '^[aeiouAEIOU]' OR City NOT REGEXP '[aeiouAEIOU]$'
ORDER BY City;

# Q16. Query the list of CITY names from STATION that do not start with vowels and do not end with vowels. 
# Your result cannot contain duplicates.
# Ans

SELECT DISTINCT City
FROM station
WHERE City NOT REGEXP '^[aeiouAEIOU]'
      AND City NOT REGEXP '[aeiouAEIOU]$'
ORDER BY City;

# Q17-Table: Product
# product_id is the primary key of this table.
# Each row of this table indicates the name and the price of each product.
# This table has no primary key, it can have repeated rows
# product_id is a foreign key to the Product table.
# Each row of this table contains some information about one sale.
# Write an SQL query that reports the products that were only sold in the first quarter of 2019. That is,
# between 2019-01-01 and 2019-03-31 inclusive.
# Return the result table in any order.
# The query result format is in the following example.

# Explanation:
# The product with id 1 was only sold in the spring of 2019.
# The product with id 2 was sold in the spring of 2019 but was also sold after the spring of 2019.
# The product with id 3 was sold after spring 2019.
# We return only product 1 as it is the product that was only sold in the spring of 2019

# Ans
CREATE TABLE product(
product_id int,
product_name varchar(20),
unit_price int,
primary key(product_id)
);

CREATE TABLE sales(
seller_id int,
product_id int,
buyer_id int,
sale_date date,
quantity int,
price int,
foreign key(product_id) references product (product_id)
);
# step 2 - intersing the value
INSERT INTO product values (1,'S8',1000),(2,'G4',800),(3,'iPhone',1400);
INSERT INTO sales values (1,1,1,'2019-01-21',2,2000),(1,2,2,'2019-02-17',1,800),(2,2,3,'2019-06-02',1,800),(3,3,4,'2019-05-13',2,2800);

# Write an SQL query that reports the products that were only sold in the first quarter of 2019. That is,
# between 2019-01-01 and 2019-03-31 inclusive
# as per as explanation 
# The product with id 1 was only sold in the spring of 2019.
# The product with id 2 was sold in the spring of 2019 but was also sold after the spring of 2019.
# The product with id 3 was sold after spring 2019.
# We return only product 1 as it is the product that was only sold in the spring of 2019
select product_id,product_name
from product
where product_id in 
(select product_id from sales where sale_date between '2019-01-01' and '2019-03-31') 
AND product_id NOT IN (
    SELECT product_id
    FROM sales
    WHERE sale_date > '2019-03-31'
)
ORDER BY product_name;

# The first subquery (SELECT product_id FROM sales WHERE sale_date BETWEEN '2019-01-01' AND '2019-03-31') selects product IDs that were sold in the spring of 2019.
# The second subquery (SELECT product_id FROM sales WHERE sale_date > '2019-03-31') selects product IDs that were sold after the spring of 2019.
#The NOT IN condition is used to exclude product IDs that were sold after the spring of 2019.
# The ORDER BY clause sorts the results by product_name.

# Q18
# There is no primary key for this table, it may have duplicate rows.
# Each row of this table indicates that some viewer viewed an article (written by some author) on some
# date.
# Note that equal author_id and viewer_id indicate the same person.
# Write an SQL query to find all the authors that viewed at least one of their own articles.
# Return the result table sorted by id in ascending order.
# The query result format is in the following example.
# Ans- 
# step 1 create the table
CREATE TABLE Views(
article_id int,
author_id int,
viewer_id int,
view_date date
);

# step 2 - insert the values
INSERT INTO Views 
VALUES (1,3,5,'2019-08-01'),
(1,3,6,'2019-08-02'),
(2,7,7,'2019-08-01'),
(2,7,6,'2019-08-02'),
(4,7,1,'2019-07-22'),
(3,4,4,'2019-07-21'),
(3,4,4,'2019-07-21')
;
# as per as question

SELECT DISTINCT author_id AS id
FROM Views
WHERE (author_id = viewer_id)
ORDER BY author_id asc;


# Q-19. delivery_id is the primary key of this table.
# The table holds information about food delivery to customers that make orders at some date and
# specify a preferred delivery date (on the same order date or after it).
# If the customer's preferred delivery date is the same as the order date, then the order is called
# immediately; otherwise, it is called scheduled.
# Write an SQL query to find the percentage of immediate orders in the table, rounded to 2 decimal
# places.

create table Delivery(
delivery_id int,
customer_id int,
order_date date,
customer_pref_delivery_date date,
primary key(delivery_id)
);
insert into Delivery
 values 
 (1,1,'2019-08-01','2019-08-02'),
 (2,5,'2019-08-02','2019-08-02'),
 (3,1,'2019-08-11','2019-08-11'),
 (4,3,'2019-08-24','2019-08-26'),
 (5,4,'2019-08-21','2019-08-22'),
 (6,2,'2019-08-11','2019-08-13');

SELECT ROUND(100 * (SUM(CASE WHEN order_date = customer_pref_delivery_date THEN 1 ELSE 0 END) / COUNT(*)), 2) AS immediate_percentage
FROM Delivery;

# Q-20. 
# (ad_id, user_id) is the primary key for this table.
# Each row of this table contains the ID of an Ad, the ID of a user, and the action taken by this user
# regarding this Ad.
# The action column is an ENUM type of ('Clicked', 'Viewed', 'Ignored').
# A company is running Ads and wants to calculate the performance of each Ad.
# Performance of the Ad is measured using Click-Through Rate (CTR) where:
# Write an SQL query to find the ctr of each Ad. Round ctr to two decimal points.
# Return the result table ordered by ctr in descending order and by ad_id in ascending order in case of a
# tie.
# ans-
CREATE TABLE Ads (
    ad_id int,
    user_id int,
    action enum('Clicked', 'Viewed', 'Ignored'),
    PRIMARY KEY (ad_id, user_id)
);

INSERT INTO Ads VALUES
    (1, 1, 'Clicked'),
    (2, 2, 'Clicked'),
    (3, 3, 'Viewed'),
    (5, 5, 'Ignored'),
    (1, 7, 'Ignored'),
    (2, 7, 'Viewed'),
    (3, 5, 'Clicked'),
    (1, 4, 'Viewed'),
    (2, 11, 'Viewed'),
    (1, 2, 'Clicked');

select * from ads;

SELECT ad_id, 
       CASE WHEN COUNT(*) = 0 THEN 0
            ELSE ROUND(SUM(CASE WHEN action = 'Clicked' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2)
       END AS ctr
FROM Ads
WHERE action != 'Ignored'
GROUP BY ad_id
ORDER BY ctr DESC, ad_id ASC;

# Q21
# employee_id is the primary key for this table.
# Each row of this table contains the ID of each employee and their respective team.
# Write an SQL query to find the team size of each of the employees.
# Return result table in any order.


CREATE TABLE Employee (
    employee_id int PRIMARY KEY,
    team_id int
);

INSERT INTO Employee (employee_id, team_id)
VALUES
    (1, 8),
    (2, 8),
    (3, 8),
    (4, 7),
    (5, 9),
    (6, 9);
# note here e1 alis to employee table
SELECT e1.employee_id, COUNT(e2.employee_id) AS team_size
FROM Employee e1
LEFT JOIN Employee e2 ON e1.team_id = e2.team_id
GROUP BY e1.employee_id;

# Q-22
# Table: Countries
# Column Name Type
# country_id int
# country_name varchar
# country_id is the primary key for this table
# Each row of this table contains the ID and the name of one country.

# ans-
CREATE TABLE Countries (
    country_id int PRIMARY KEY,
    country_name varchar(20)
);
INSERT INTO Countries (country_id, country_name)
VALUES
    (2, 'USA'),
    (3, 'Australia'),
    (7, 'Peru'),
    (5, 'China'),
    (8, 'Morocco'),
    (9, 'Spain');

# creating another table 
# Table: Weather
# Column Name Type
# country_id int
# weather_state int
# day date
# (country_id, day) is the primary key for this table.
# Each row of this table indicates the weather state in a country for one day
CREATE TABLE Weather (
    country_id int,
    weather_state int,
    day date
);

INSERT INTO Weather (country_id, weather_state, day)
VALUES
    (2, 15, '2019-11-01'),
    (2, 12, '2019-10-28'),
    (2, 12, '2019-10-27'),
    (3, -2, '2019-11-10'),
    (3, 0, '2019-11-11'),
    (3, 3, '2019-11-12'),
    (5, 16, '2019-11-07'),
    (5, 18, '2019-11-09'),
    (5, 21, '2019-11-23'),
    (7, 25, '2019-11-28'),
    (7, 22, '2019-12-01'),
    (7, 20, '2019-12-02'),
    (8, 25, '2019-11-05'),
    (8, 27, '2019-11-15'),
    (8, 31, '2019-11-25'),
    (9, 7, '2019-10-23'),
    (9, 3, '2019-12-23');


# Write an SQL query to find the type of weather in each country for November 2019.
# The type of weather is:
# ● Cold if the average weather_state is less than or equal 15,
# ● Hot if the average weather_state is greater than or equal to 25, and
# ● Warm otherwise.

SELECT c.country_name,
       CASE 
           WHEN AVG(w.weather_state) <= 15 THEN 'Cold'
           WHEN AVG(w.weather_state) >= 25 THEN 'Hot'
           ELSE 'Warm'
       END AS weather_type
FROM Countries c
JOIN Weather w ON c.country_id = w.country_id
WHERE w.day >= '2019-11-01' AND w.day < '2019-12-01'
GROUP BY c.country_name;

# Q 23.
# ans
# STEP 1 CREATE A TABLE PRICE
CREATE TABLE Prices(
product_id int,
start_date date,
end_date date,
price int,
primary key (product_id, start_date, end_date)
);

# INSERT A DATA TO A PRICES TABLE
INSERT INTO Prices (product_id, start_date, end_date, price)
VALUES
    (1, '2019-02-17', '2019-02-28', 5),
    (1, '2019-03-01', '2019-03-22', 20),
    (2, '2019-02-01', '2019-02-20', 15),
    (2, '2019-02-21', '2019-03-31', 30);

SELECT * FROM prices
# crating another table: UnitsSold


CREATE TABLE UnitsSold (
    product_id int,
    purchase_date date,
    units int
);

# inserting data to unit this able

INSERT INTO UnitsSold (product_id, purchase_date, units)
VALUES
    (1, '2019-02-25', 100),
    (1, '2019-03-01', 15),
    (2, '2019-02-10', 200),
    (2, '2019-03-22', 30);
    
SELECT * FROM  UnitsSold

# NOW AS PER AS THE QUESTION
# Write an SQL query to find the average selling price for each product. average_price should be
# rounded to 2 decimal places.

SELECT
    u.product_id,
    ROUND(SUM(p.price * u.units) / SUM(u.units), 2) AS average_price
FROM
    UnitsSold u
JOIN
    Prices p ON u.product_id = p.product_id
        AND u.purchase_date >= p.start_date
        AND u.purchase_date <= p.end_date
GROUP BY
    u.product_id;
    
# Ques-24
# Ans-
# step 1
 CREATE TABLE Activity (
    player_id int,
    device_id int,
    event_date date,
    games_played int,
    PRIMARY KEY (player_id, event_date)
);
# insert value 
INSERT INTO Activity (player_id, device_id, event_date, games_played)
VALUES
    (1, 2, '2016-03-01', 5),
    (1, 2, '2016-05-02', 6),
    (2, 3, '2017-06-25', 1),
    (3, 1, '2016-03-02', 0),
    (3, 4, '2018-07-03', 5);

SELECT * FROM Activity

# Write an SQL query to report the first login date for each player

select player_id, MIN(event_date) AS first_login
FROM Activity
GROUP BY player_id;

# Question 25
CREATE TABLE Activity_25 (
    player_id int,
    device_id int,
    event_date date,
    games_played int,
    PRIMARY KEY (player_id, event_date)
);

INSERT INTO Activity_25 (player_id, device_id, event_date, games_played)
VALUES
    (1, 2, '2016-03-01', 5),
    (1, 2, '2016-05-02', 6),
    (2, 3, '2017-06-25', 1),
    (3, 1, '2016-03-02', 0),
    (3, 4, '2018-07-03', 5);

# Write an SQL query to report the device that is first logged in for each player.

SELECT player_id, device_id
FROM (
    SELECT
        player_id,
        device_id,
        ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY event_date) AS rn
    FROM Activity_25
) ranked
WHERE rn = 1;

# Question-26 -Ans

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    product_category VARCHAR(50)
);

CREATE TABLE Orders (
    product_id INT,
    order_date DATE,
    unit INT,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

# step 2- insert the values

INSERT INTO Products (product_id, product_name, product_category)
VALUES
    (1, 'Leetcode Solutions Book', 'Book'),
    (2, 'Jewels of Stringology Book', 'Book'),
    (3, 'HP Laptop', 'Electronics'),
    (4, 'Lenovo Laptop', 'Electronics'),
    (5, 'Leetcode Kit T-shirt', 'Clothing');

INSERT INTO orders (product_id, order_date, unit)
VALUES
    (1, '2020-02-05', 60),
    (1, '2020-02-10', 70),
    (2, '2020-01-18', 30),
    (2, '2020-02-11', 80),
    (3, '2020-02-17', 2),
    (3, '2020-02-24', 3),
    (4, '2020-03-01', 20),
    (4, '2020-03-04', 30),
    (4, '2020-03-04', 60),
    (5, '2020-02-25', 50),
    (5, '2020-02-27', 50),
    (5, '2020-03-01', 50);

# Write an SQL query to get the names of products that have at least 100 units ordered in February 2020
# and their amount

SELECT p.product_name, SUM(o.unit) AS unit
FROM Products p
JOIN Orders o ON p.product_id = o.product_id
WHERE o.order_date >= '2020-02-01' AND o.order_date <= '2020-02-29'
GROUP BY p.product_name
HAVING SUM(o.unit) >= 100;

# question 27

create table Users(
user_id int primary key,
name varchar(50),
mail varchar(100)
);
-- Insert into Users table
INSERT INTO Users (user_id, name, mail)
VALUES
    (1, 'Winston', 'winston@leetcode.com'),
    (2, 'Jonathan', 'jonathanisgreat'),
    (3, 'Annabelle', 'bella-@leetcode.com'),
    (4, 'Sally', 'sally.come@leetcode.com'),
    (5, 'Marwan', 'quarz#2020@leetcode.com'),
    (6, 'David', 'david69@gmail.com'),
    (7, 'Shapiro', '.shapo@leetcode.com');

-- Display Users table with valid email addresses
# Write an SQL query to find the users who have valid emails.
# A valid e-mail has a prefix name and a domain where:
# ●	The prefix name is a string that may contain letters (upper or lower case), digits, underscore '_', period '.', and/or dash '-'. The prefix name must start with a letter.
# ●	The domain is '@leetcode.com'.

SELECT user_id, name, mail
FROM Users
WHERE mail REGEXP '^[A-Za-z][A-Za-z0-9_.-]*@leetcode\.com$';

# We use the REGEXP operator to match the email addresses based on the specified pattern.
# ^[A-Za-z] ensures that the prefix name starts with a letter.
# [A-Za-z0-9_.-]* allows for letters (upper or lower case), digits, underscore '_', period '.', and dash '-' in the prefix name.
# @leetcode\.com$ matches the domain '@leetcode.com' at the end of the email address.

# question 28

create table Customers(
customer_id int primary key,
name varchar(50),
country varchar(20)
);

INSERT INTO Customers (customer_id, name, country)
VALUES
    (1, 'Winston', 'USA'),
    (2, 'Jonathan', 'Peru'),
    (3, 'Moustafa', 'Egypt');

CREATE TABLE Product_2 (
    product_id INT PRIMARY KEY,
    customer_id INT,
    name VARCHAR(25),
    country VARCHAR(25)
);

INSERT INTO Product_2 (product_id, customer_id, name, country)
VALUES
    (10, 1, 'LC Phone', 'USA'),
    (20, 2, 'LC T-Shirt', 'Peru'),
    (30, 3, 'LC Book', 'Egypt'),
    (40, 1, 'LC Keychain', 'USA');

CREATE TABLE Orders_2 (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    order_date DATE,
    quantity INT
);

INSERT INTO Orders_2 (order_id, customer_id, product_id, order_date, quantity)
VALUES
    (1, 1, 10, '2020-06-10', 1),
    (2, 1, 20, '2020-07-01', 1),
    (3, 1, 30, '2020-07-08', 2),
    (4, 2, 10, '2020-06-15', 2),
    (5, 2, 40, '2020-07-01', 10),
    (6, 3, 20, '2020-06-24', 2),
    (7, 3, 30, '2020-06-25', 2),
    (9, 3, 30, '2020-05-08', 3);

WITH MonthlySpending AS (
    SELECT
        o.customer_id,
        c.name AS customer_name,
        MONTH(o.order_date) AS order_month,
        SUM(o.quantity *
            CASE
                WHEN o.order_date BETWEEN '2020-06-01' AND '2020-06-30' THEN
                    CASE o.product_id
                        WHEN 10 THEN 300
                        WHEN 20 THEN 10
                        WHEN 30 THEN 45
                        WHEN 40 THEN 2
                        ELSE 0
                    END
                WHEN o.order_date BETWEEN '2020-07-01' AND '2020-07-31' THEN
                    CASE o.product_id
                        WHEN 10 THEN 300
                        WHEN 20 THEN 10
                        WHEN 30 THEN 45
                        WHEN 40 THEN 2
                        ELSE 0
                    END
                ELSE 0
            END
        ) AS total_spending
    FROM Orders_2 o
    JOIN Customers c ON o.customer_id = c.customer_id
    WHERE o.order_date BETWEEN '2020-06-01' AND '2020-07-31'
    GROUP BY o.customer_id, order_month, customer_name
)

SELECT customer_id, customer_name
FROM MonthlySpending
WHERE (order_month = 6 AND total_spending >= 100)
    OR (order_month = 7 AND total_spending >= 100)
GROUP BY customer_id, customer_name
HAVING COUNT(DISTINCT order_month) = 2;


# question 29

CREATE TABLE TVProgram (
    program_date DATE,
    content_id INT,
    channel VARCHAR(255),
    PRIMARY KEY (program_date, content_id)
);
INSERT INTO TVProgram (program_date, content_id, channel)
VALUES
    ('2020-06-10 08:00', 1, 'LC-Channel'),
    ('2020-05-11 12:00', 2, 'LC-Channel'),
    ('2020-05-12 12:00', 3, 'LC-Channel'),
    ('2020-05-13 14:00', 4, 'Disney Ch'),
    ('2020-06-18 14:00', 4, 'Disney Ch'),
    ('2020-07-15 16:00', 5, 'Disney Ch');

CREATE TABLE Content (
    content_id VARCHAR(25) PRIMARY KEY,
    title VARCHAR(25),
    Kids_content ENUM('Y', 'N'),
    content_type VARCHAR(25)
);

INSERT INTO Content (content_id, title, Kids_content, content_type)
VALUES
    ('1', 'Leetcode Movie', 'N', 'Movies'),
    ('2', 'Alg. for Kids', 'Y', 'Series'),
    ('3', 'Database Sols', 'N', 'Series'),
    ('4', 'Aladdin', 'Y', 'Movies'),
    ('5', 'Cinderella', 'Y', 'Movies');

SELECT DISTINCT c.title
FROM Content c
JOIN TVProgram p ON c.content_id = p.content_id
WHERE c.Kids_content = 'Y'
    AND c.content_type = 'Movies'
    AND DATE_FORMAT(p.program_date, '%Y-%m') = '2020-06';

# Question 30
CREATE TABLE NPV (
    id INT,
    year INT,
    npv INT,
    PRIMARY KEY (id, year)
);

INSERT INTO NPV (id, year, npv)
VALUES
    (1, 2018, 100),
    (7, 2020, 30),
    (13, 2019, 40),
    (1, 2019, 113),
    (2, 2008, 121),
    (3, 2009, 12),
    (11, 2020, 99),
    (7, 2019, 0);

CREATE TABLE Queries (
    id INT,
    year INT,
    PRIMARY KEY (id, year)
);

INSERT INTO Queries (id, year)
VALUES
    (1, 2019),
    (2, 2008),
    (3, 2009),
    (7, 2018),
    (7, 2019),
    (7, 2020),
    (13, 2019);

SELECT
    q.id,
    q.year,
    COALESCE(n.npv, 0) AS npv
FROM Queries q
LEFT JOIN NPV n ON q.id = n.id AND q.year = n.year;

# Question 31

SELECT
    q.id,
    q.year,
    COALESCE(n.npv, 0) AS npv
FROM Queries q
LEFT JOIN NPV n ON q.id = n.id AND q.year = n.year
ORDER BY q.id, q.year;

# Question 32.

-- Create the Employees table
CREATE TABLE Employees (
    id INT,
    name VARCHAR(50),
    PRIMARY KEY (id)
);

# Insert values into the Employees table
INSERT INTO Employees (id, name)
VALUES
    (1, 'Alice'),
    (7, 'Bob'),
    (11, 'Meir'),
    (90, 'Winston'),
    (3, 'Jonathan');

-- Create the EmployeeUNI table
CREATE TABLE EmployeeUNI (
    id INT,
    unique_id INT,
    PRIMARY KEY (id, unique_id)
);
-- Insert values into the EmployeeUNI table
INSERT INTO EmployeeUNI (id, unique_id)
VALUES
    (3, 1),
    (11, 2),
    (90, 3);
# ans
SELECT E.name, EU.unique_id
FROM Employees E
LEFT JOIN EmployeeUNI EU ON E.id = EU.id;

# question 33

-- Create the Users table
CREATE TABLE _Users (
    id INT,
    name VARCHAR(50),
    PRIMARY KEY (id)
);
-- Insert values into the Users table
INSERT INTO _Users (id, name)
VALUES
    (1, 'Alice'),
    (2, 'Bob'),
    (3, 'Alex'),
    (4, 'Donald'),
    (7, 'Lee'),
    (13, 'Jonathan'),
    (19, 'Elvis');

-- Create the Rides table
CREATE TABLE Rides (
    id INT,
    user_id INT,
    distance INT,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES _Users(id)
);
-- Insert values into the Rides table
INSERT INTO Rides (id, user_id, distance)
VALUES
    (1, 1, 120),
    (2, 2, 317),
    (3, 3, 222),
    (4, 7, 100),
    (5, 13, 312),
    (6, 19, 50),
    (7, 7, 120),
    (8, 19, 400),
    (9, 7, 230);

# ans
SELECT
    U.name,
    COALESCE(SUM(R.distance), 0) AS travelled_distance
FROM _Users U
LEFT JOIN Rides R ON U.id = R.user_id
GROUP BY U.name
ORDER BY travelled_distance DESC, U.name ASC;

# question 34
-- Create the Products table
CREATE TABLE _Products (
    product_id INT,
    product_name VARCHAR(255),
    product_category VARCHAR(255),
    PRIMARY KEY (product_id)
);

-- Insert values into the Products table
INSERT INTO _Products (product_id, product_name, product_category)
VALUES
    (1, 'Leetcode Solutions Book', 'Book'),
    (2, 'Jewels of Stringology Book', 'Book'),
    (3, 'HP Laptop', 'Laptop'),
    (4, 'Lenovo Laptop', 'Laptop'),
    (5, 'Leetcode Kit T-shirt', 'T-shirt');

-- Create the Orders table
CREATE TABLE _Orders (
    product_id INT,
    order_date DATE,
    unit INT,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
SELECT P.product_name, SUM(O.unit) AS amount
FROM _Products P
INNER JOIN _Orders O ON P.product_id = O.product_id
WHERE MONTH(O.order_date) = 2 AND YEAR(O.order_date) = 2020
GROUP BY P.product_name
HAVING SUM(O.unit) >= 100;

# question 35

-- Create the Movies table
CREATE TABLE Movies (
    movie_id INT,
    title VARCHAR(255),
    PRIMARY KEY (movie_id)
);
-- Insert values into the Movies table
INSERT INTO Movies (movie_id, title)
VALUES
    (1, 'Avengers'),
    (2, 'Frozen 2'),
    (3, 'Joker');

-- Create the Users table
CREATE TABLE __Users (
    user_id INT,
    name VARCHAR(255),
    PRIMARY KEY (user_id)
);
-- Insert values into the Users table
INSERT INTO __Users (user_id, name)
VALUES
    (1, 'Daniel'),
    (2, 'Monica'),
    (3, 'Maria'),
    (4, 'James');

-- Create the MovieRating table
CREATE TABLE MovieRating (
    movie_id INT,
    user_id INT,
    rating INT,
    created_at DATE,
    PRIMARY KEY (movie_id, user_id),
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
-- Insert values into the MovieRating table
INSERT INTO MovieRating (movie_id, user_id, rating, created_at)
VALUES
    (1, 1, 3, '2020-01-12'),
    (1, 2, 4, '2020-02-11'),
    (1, 3, 2, '2020-02-12'),
    (1, 4, 1, '2020-01-01'),
    (2, 1, 5, '2020-02-17'),
    (2, 2, 2, '2020-02-01'),
    (2, 3, 2, '2020-03-01'),
    (3, 1, 3, '2020-02-22'),
    (3, 2, 4, '2020-02-25');
# ans
WITH UserRatings AS (
    SELECT
        U.name AS user_name,
        COUNT(MR.movie_id) AS num_rated_movies
    FROM __Users U
    LEFT JOIN MovieRating MR ON U.user_id = MR.user_id
    GROUP BY U.name
),
MovieAverageRatings AS (
    SELECT
        M.title AS movie_name,
        AVG(MR.rating) AS avg_rating
    FROM Movies M
    LEFT JOIN MovieRating MR ON M.movie_id = MR.movie_id
    WHERE MONTH(MR.created_at) = 2 AND YEAR(MR.created_at) = 2020
    GROUP BY M.title
)
SELECT
    user_name AS results
FROM UserRatings
WHERE num_rated_movies = (
    SELECT MAX(num_rated_movies)
    FROM UserRatings
)
ORDER BY user_name
LIMIT 1
UNION
SELECT
    movie_name AS results
FROM MovieAverageRatings
WHERE avg_rating = (
    SELECT MAX(avg_rating)
    FROM MovieAverageRatings
)
ORDER BY movie_name
LIMIT 1;

# question 36

-- Create the Users table
CREATE TABLE Users_1 (
    id INT,
    name VARCHAR(255),
    PRIMARY KEY (id)
);
-- Insert values into the Users table
INSERT INTO Users_1 (id, name)
VALUES
    (1, 'Alice'),
    (2, 'Bob'),
    (3, 'Alex'),
    (4, 'Donald'),
    (7, 'Lee'),
    (13, 'Jonathan'),
    (19, 'Elvis');



-- Create the Rides table
CREATE TABLE Rides_1 (
    id INT,
    user_id INT,
    distance INT,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES Users_1(id)
);
-- Insert values into the Rides table
INSERT INTO Rides_1 (id, user_id, distance)
VALUES
    (1, 1, 120),
    (2, 2, 317),
    (3, 3, 222),
    (4, 7, 100),
    (5, 13, 312),
    (6, 19, 50),
    (7, 7, 120),
    (8, 19, 400),
    (9, 7, 230);

# ans
WITH UserRides AS (
    SELECT U.name AS user_name, COALESCE(SUM(R.distance), 0) AS travelled_distance
    FROM Users_1 U
    LEFT JOIN Rides_1 R ON U.id = R.user_id
    GROUP BY U.name
)
SELECT user_name AS name, travelled_distance
FROM UserRides
ORDER BY travelled_distance DESC, name ASC;

# question 37
-- Create the Employees table
CREATE TABLE Employees_1 (
    id INT,
    name VARCHAR(255),
    PRIMARY KEY (id)
);
-- Insert values into the Employees table
INSERT INTO Employees_1 (id, name)
VALUES
    (1, 'Alice'),
    (7, 'Bob'),
    (11, 'Meir'),
    (90, 'Winston'),
    (3, 'Jonathan');

-- Create the EmployeeUNI table
CREATE TABLE EmployeeUNI_1 (
    id INT,
    unique_id INT,
    PRIMARY KEY (id, unique_id)
);

-- Insert values into the EmployeeUNI table
INSERT INTO EmployeeUNI_1 (id, unique_id)
VALUES
    (3, 1),
    (11, 2),
    (90, 3);

SELECT E.name, EU.unique_id
FROM Employees_1 E
LEFT JOIN EmployeeUNI_1 EU ON E.id = EU.id;

# question 38

-- Create the Departments table
CREATE TABLE Departments_2 (
    id INT,
    name VARCHAR(30),
    PRIMARY KEY (id)
);
-- Insert values into the Departments table
INSERT INTO Departments_2 (id, name)
VALUES
    (1, 'Electrical Engineering'),
    (7, 'Computer Engineering'),
    (13, 'Business Administration');
drop table Departments_2;

-- Create the Students table
CREATE TABLE Students_2 (
    id INT,
    name VARCHAR(40),
    department_id INT,
    PRIMARY KEY (id)
);
drop table Students_2;
-- Insert values into the Students table
INSERT INTO Students_2 (id, name, department_id)
VALUES
    (23, 'Alice', 1),
    (1, 'Bob', 7),
    (5, 'Jennifer', 13),
    (2, 'John', 14),
    (4, 'Jasmine', 77),
    (3, 'Steve', 74),
    (6, 'Luis', 1),
    (8, 'Jonathan', 7),
    (7, 'Daiana', 33),
    (11, 'Madelynn', 1);
    
# ans
SELECT id, name
FROM Students_2
WHERE id IN (2, 7, 4, 3);

# question 39

-- Create the Calls table
CREATE TABLE Calls (
    from_id INT,
    to_id INT,
    duration INT
);
-- Insert values into the Calls table
INSERT INTO Calls (from_id, to_id, duration)
VALUES
    (1, 2, 59),
    (2, 1, 11),
    (1, 3, 20),
    (3, 4, 100),
    (3, 4, 200),
    (3, 4, 200),
    (4, 3, 499);
    
# ans
SELECT 
    LEAST(from_id, to_id) AS person1,
    GREATEST(from_id, to_id) AS person2,
    COUNT(*) AS call_count,
    SUM(duration) AS total_duration
FROM Calls
GROUP BY LEAST(from_id, to_id), GREATEST(from_id, to_id)
ORDER BY person1, person2;

# question 40

-- Create the Prices table
CREATE TABLE Prices_1 (
    product_id INT,
    start_date DATE,
    end_date DATE,
    price INT,
    PRIMARY KEY (product_id, start_date, end_date)
);
-- Insert values into the Prices table
INSERT INTO Prices_1 (product_id, start_date, end_date, price)
VALUES
    (1, '2019-02-17', '2019-02-28', 5),
    (1, '2019-03-01', '2019-03-22', 20),
    (2, '2019-02-01', '2019-02-20', 15),
    (2, '2019-02-21', '2019-03-31', 30);

-- Create the UnitsSold table
CREATE TABLE UnitsSold_1 (
    product_id INT,
    purchase_date DATE,
    units INT
);
-- Insert values into the UnitsSold table
INSERT INTO UnitsSold_1 (product_id, purchase_date, units)
VALUES
    (1, '2019-02-25', 100),
    (1, '2019-03-01', 15),
    (2, '2019-02-10', 200),
    (2, '2019-03-22', 30);
# ans
SELECT
    product_id,
    ROUND(SUM(price * units) / SUM(units), 2) AS average_price
FROM Prices
JOIN UnitsSold ON Prices.product_id = UnitsSold.product_id
GROUP BY product_id;

# question 41

CREATE TABLE Warehouse_3 (
    name VARCHAR(50) NOT NULL,
    product_id INT NOT NULL,
    units INT NOT NULL,
    PRIMARY KEY (name, product_id)
);

INSERT INTO Warehouse_3 (name, product_id, units) VALUES
('LCHouse1', 1, 1),
('LCHouse1', 2, 10),
('LCHouse1', 3, 5),
('LCHouse2', 1, 2),
('LCHouse2', 2, 2),
('LCHouse3', 4, 1);


CREATE TABLE Products_3 (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    Width INT,
    Length INT,
    Height INT
);

INSERT INTO Products_3 (product_id, product_name, Width, Length, Height) VALUES
(1, 'LC-TV', 5, 50, 40),
(2, 'LC-KeyChain', 5, 5, 5),
(3, 'LC-Phone', 2, 10, 10),
(4, 'LC-T-Shirt', 4, 10, 20);

# ans
SELECT
    w.name AS warehouse_name,
    SUM(p.Width * p.Length * p.Height * w.units) AS volume
FROM
    Warehouse_3 w
JOIN
    Products_3 p ON w.product_id = p.product_id
GROUP BY
    w.name;
    
# Question 42

-- Create Sales table
CREATE TABLE Sales_2 (
    sale_date DATE,
    fruit ENUM('apples', 'oranges'),
    sold_num INT,
    PRIMARY KEY (sale_date, fruit)
);

-- Insert values into Sales table
INSERT INTO Sales_2 (sale_date, fruit, sold_num) VALUES
('2020-05-01', 'apples', 10),
('2020-05-01', 'oranges', 8),
('2020-05-02', 'apples', 15),
('2020-05-02', 'oranges', 15),
('2020-05-03', 'apples', 20),
('2020-05-03', 'oranges', 0),
('2020-05-04', 'apples', 15),
('2020-05-04', 'oranges', 16);

# Ans
SELECT
    sale_date,
    SUM(CASE WHEN fruit = 'apples' THEN sold_num ELSE -sold_num END) AS diff
FROM
    Sales_2
GROUP BY
    sale_date
ORDER BY
    sale_date;

# Question 43

-- Create Activity table
CREATE TABLE Activity_2 (
    player_id INT,
    device_id INT,
    event_date DATE,
    games_played INT,
    PRIMARY KEY (player_id, event_date)
);

-- Insert values into Activity table
INSERT INTO Activity_2 (player_id, device_id, event_date, games_played) VALUES
(1, 2, '2016-03-01', 5),
(1, 2, '2016-03-02', 6),
(2, 3, '2017-06-25', 1),
(3, 1, '2016-03-02', 0),
(3, 4, '2018-07-03', 5);

# ans
SELECT
    ROUND(
        SUM(CASE WHEN first_login_date IS NOT NULL AND second_login_date IS NOT NULL THEN 1 ELSE 0 END) /
        COUNT(DISTINCT player_id),
        2
    ) AS fraction
FROM (
    SELECT
        player_id,
        MIN(event_date) AS first_login_date,
        LEAD(event_date) OVER (PARTITION BY player_id ORDER BY event_date) AS second_login_date
    FROM
        Activity_2
    GROUP BY
        player_id
) AS player_login_dates;

# question 44
CREATE TABLE Employee_2 (
    id INT PRIMARY KEY,
    name VARCHAR(50), 
    department VARCHAR(50),
    managerId INT
);
-- Insert values into Employee table
INSERT INTO Employee_2 (id, name, department, managerId) VALUES
(101, 'John', 'A', NULL),
(102, 'Dan', 'A', 101),
(103, 'James', 'A', 101),
(104, 'Amy', 'A', 101),
(105, 'Anne', 'A', 101),
(106, 'Ron', 'B', 101);

# ans
SELECT e1.name
FROM Employee_2 e1
JOIN (
    SELECT managerId, COUNT(*) as directReportsCount
    FROM Employee_2
    GROUP BY managerId
    HAVING COUNT(*) >= 5
) e2 ON e1.id = e2.managerId;

# question 45
-- Create Department table
CREATE TABLE Department_3 (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) 
);

-- Create Student table
CREATE TABLE Student_3 (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    gender VARCHAR(10), 
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department_3(dept_id)
);
-- Insert values into Department table
INSERT INTO Department_3 (dept_id, dept_name) VALUES
(1, 'Engineering'),
(2, 'Science'),
(3, 'Law');

-- Insert values into Student table
INSERT INTO Student_3 (student_id, student_name, gender, dept_id) VALUES
(1, 'Jack', 'M', 1),
(2, 'Jane', 'F', 1),
(3, 'Mark', 'M', 2);

SELECT
    d.dept_name AS dept_name,
    COUNT(s.student_id) AS student_number
FROM
    Department_3 d
LEFT JOIN
    Student_3 s ON d.dept_id = s.dept_id
GROUP BY
    d.dept_id, d.dept_name
ORDER BY
    student_number DESC, d.dept_name;
    
# question 46

-- Create Product table
CREATE TABLE Product_4 (
    product_key INT PRIMARY KEY
    -- Add other columns as needed
);

-- Create Customer table
CREATE TABLE Customer_4 (
    customer_id INT,
    product_key INT,
    FOREIGN KEY (product_key) REFERENCES Product_4(product_key)  
);

-- Insert values into Product table
INSERT INTO Product_4 (product_key) VALUES
(5),
(6);

-- Insert values into Customer table
INSERT INTO Customer_4 (customer_id, product_key) VALUES
(1, 5),
(2, 6),
(3, 5),
(3, 6),
(1, 6);

SELECT DISTINCT c.customer_id
FROM Customer_4 c
WHERE NOT EXISTS (
    SELECT p.product_key
    FROM Product_4 p
    WHERE NOT EXISTS (
        SELECT 1
        FROM Customer_4 c1
        WHERE c1.customer_id = c.customer_id AND c1.product_key = p.product_key
    )
);

# question 47

-- Create Employee table
CREATE TABLE Employee_4 (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50), 
    experience_years INT
    
);

-- Create Project table
CREATE TABLE Project_4 (
    project_id INT,
    employee_id INT,
    PRIMARY KEY (project_id, employee_id),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)

);

-- Insert values into Employee table
INSERT INTO Employee_4 (employee_id, name, experience_years) VALUES
(1, 'Khaled', 3),
(2, 'Ali', 2),
(3, 'John', 3),
(4, 'Doe', 2);

-- Insert values into Project table
INSERT INTO Project_4 (project_id, employee_id) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 1),
(2, 4);

WITH RankedEmployees AS (
    SELECT
        project_id,
        employee_id,
        RANK() OVER (PARTITION BY project_id ORDER BY experience_years DESC) AS experience_rank
    FROM
        Project_4
        JOIN Employee_4 ON Project_4.employee_id = Employee_4.employee_id
)

SELECT
    project_id,
    employee_id
FROM
    RankedEmployees
WHERE
    experience_rank = 1;
    
# question 48

-- Create Books table
CREATE TABLE Books_4 (
    book_id INT PRIMARY KEY,
    name VARCHAR(255), 
    available_from DATE
);

-- Create Orders table
CREATE TABLE Orders_4 (
    order_id INT PRIMARY KEY,
    book_id INT,
    quantity INT,
    dispatch_date DATE,
    FOREIGN KEY (book_id) REFERENCES Books_4(book_id)
);

-- Insert values into Books table
INSERT INTO Books_4 (book_id, name, available_from) VALUES
(1, 'The Great Gatsby', '2022-01-01'),
(2, 'To Kill a Mockingbird', '2022-02-01'),
(3, '1984', '2022-03-01');

-- Insert values into Orders table
INSERT INTO Orders_4 (order_id, book_id, quantity, dispatch_date) VALUES
(101, 1, 2, '2022-01-15'),
(102, 2, 1, '2022-02-10'),
(103, 3, 3, '2022-03-20');

SELECT DISTINCT b.book_id, b.name
FROM Books_4 b
JOIN Orders_4 o ON b.book_id = o.book_id
WHERE 
    o.dispatch_date >= DATE_SUB('2019-06-23', INTERVAL 1 YEAR) AND
    o.dispatch_date <= '2019-06-23' AND
    o.quantity < 10 AND
    b.available_from <= DATE_SUB('2019-06-23', INTERVAL 1 MONTH);
# question 49

-- Create Enrollments table
CREATE TABLE Enrollments_4 (
    student_id INT,
    course_id INT,
    grade INT,
    PRIMARY KEY (student_id, course_id)
);

-- Insert values into Enrollments table
INSERT INTO Enrollments_4 (student_id, course_id, grade) VALUES
(2, 2, 95),
(2, 3, 95),
(1, 1, 90),
(1, 2, 99),
(3, 1, 80),
(3, 2, 75),
(3, 3, 82);

WITH RankedEnrollments AS (
    SELECT
        student_id,
        course_id,
        grade,
        ROW_NUMBER() OVER (PARTITION BY student_id ORDER BY grade DESC, course_id ASC) AS rank
    FROM
        Enrollments_4
)

SELECT
    student_id,
    course_id,
    grade
FROM
    RankedEnrollments
WHERE
    rank = 1
ORDER BY
    student_id ASC;

# question 50

CREATE TABLE Teams (
  team_id INT PRIMARY KEY,
  team_name VARCHAR(50)
);
CREATE TABLE Matches (
    match_id INT PRIMARY KEY,
    host_team INT,
    guest_team INT,
    host_goals INT,
    guest_goals INT
);
CREATE TABLE Players (
    player_id INT,
    group_id INT
);

INSERT INTO Players (player_id, group_id)
VALUES
(15, 1),
(25, 1),
(30, 1),
(45, 1),
(10, 2),
(35, 2),
(50, 2),
(20, 3),
(40, 3);

CREATE TABLE Matches_1 (
    match_id INT,
    first_player INT,
    second_player INT,
    first_score INT,
    second_score INT
);


INSERT INTO Matches_1 (match_id, first_player, second_player, first_score, second_score)
VALUES
(1, 1, 5, 4, 5),
(2, 3, 0, 2, 3),
(3, 0, 2, 5, 1),
(4, 2, 3, 3, 0),
(5, 1, 5, 2, 0),
(6, 4, 4, 0, 2),
(7, 0, 5, 2, 5),
(8, 3, 5, 3, 5),
(9, 0, 1, 1, 5);

WITH MatchResults AS (
    SELECT
        group_id,
        CASE
            WHEN first_score > second_score THEN first_player
            WHEN second_score > first_score THEN second_player
            ELSE NULL -- Handle ties as needed
        END AS winner
    FROM Matches_1
)

SELECT DISTINCT
    group_id,
    winner AS player_id
FROM MatchResults
WHERE winner IS NOT NULL;












