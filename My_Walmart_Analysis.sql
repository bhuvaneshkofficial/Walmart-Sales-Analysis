Create database Walmartsalesanalysis;
Use Walmartsalesanalysis;


Create table Salesdata (
	Invoice_ID Varchar(11) Not Null Primary key,
	Branch Varchar(1) Not Null,
	City Varchar(10) Not Null,
	Customer_type Varchar(13) Not Null,
	Gender Varchar(6) Not Null,
	Product_line Varchar(22) Not Null,
	Unit_price Decimal(10,2) Not Null,
	Quantity int Not Null,
	Tax Float(6,4) Not Null,
	Total Decimal(10,2) Not Null,
	`Date` date Not Null,
	`Time` timestamp Not Null,
	Payment Varchar(15) Not Null,
	cogs Decimal(10,2) Not Null,
	gross_margin_percentage Float(11,9) Not Null,
	gross_income Decimal(10,2) Not Null,
	Rating Float(2,1) Not Null
    );
;
Describe Salesdata;
Select * from salesdata;

ALTER TABLE salesdata MODIFY COLUMN `Date` Varchar(255);
Alter table salesdata modify column `Time` Varchar(10);

UPDATE salesdata
SET `time` = STR_TO_DATE(`time`, '%H:%i:%s');

Select Count(*) from Salesdata;

Select * from Salesdata;

-- Timeofday
Select Time, 
		(Case
		When `time` between "00:00:00" and "12:00:00" then "Morning"
        When `time` between "12:01:00" and "16:00:00" then "Afternoon"
        Else "Evening"
        End) As Time_of_day
from Salesdata;
Alter Table Salesdata add Time_of_day Varchar(30);
Update Salesdata Set Time_of_day = (Case
		When `time` between "00:00:00" and "12:00:00" then "Morning"
        When `time` between "12:01:00" and "16:00:00" then "Afternoon"
        Else "Evening"
        End);
   
   Select * from Salesdata;
   
-- Day_name
Select Date, dayname(`date`) from Salesdata;
Alter Table Salesdata add Day_name Varchar(30);
Update Salesdata set Day_name = Dayname(`date`);

Select * from Salesdata;

-- Month Name
Select Date, monthname(`date`) from Salesdata;
Alter Table Salesdata add Month_name Varchar(30);
Update Salesdata set Month_name = monthname(`date`);
Select * from Salesdata;
-- Generic Questions
-- 1. How many unique cities does the data have? 
Select Distinct(City) from salesdata;
Select count(Distinct(City)) from salesdata;

-- 2. In which city is each branch?
Select * from Salesdata;
SELECT DISTINCT city, branch FROM salesdata;

-- Product Questions
-- 1. How many unique product lines does the data have?
Select * From Salesdata;
Select count(Distinct Product_line) from salesdata;
Select Distinct Product_line from salesdata;

-- 2. What is the most common payment method?
Select Payment, Count(Payment) as Common_Payment from salesdata
Group by Payment
order by 2 desc;

-- 3. What is the most selling product line?
Select * From Salesdata;
Select product_line, sum(Quantity) as Most_selling_productline from Salesdata
Group by Product_line
Order by Most_selling_productline desc;

-- 4. What is the total revenue by month?
Select Month_name, Sum(Total) as Total_Revenue from salesdata
group by Month_name
Order by Total_Revenue Desc;

-- 5. What month had the largest COGS
Select * from Salesdata;

Select Month_name, sum(cogs) as Largest_cogs from salesdata 
group by month_name
order by Largest_cogs Desc
limit 1;

-- 6. What product line had the largest revenue?
Select * from Salesdata;

Select Product_line, Sum(Total) as Total_Revenue from salesdata
group by Product_line
order by Total_Revenue desc
limit 1;

-- 7. What is the city with the largest revenue?

Select city, Sum(Total) as Total_Revenue from salesdata
group by city
order by Total_Revenue desc;

--  8. What product line had the largest VAT?

Select Product_line, AVG(tax) AS larg_vat from salesdata
group by product_line
order by larg_vat desc
limit 1;

-- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
Select * from Salesdata;
Select Avg(Quantity) as Avg_Quantity from Salesdata;
Select Product_line,
(Case 
	When avg(Quantity) > 5.4995 Then "Good"
    Else "Bad"
    End ) as Status
from salesdata
Group by Product_line;

-- 10. Which branch sold more products than average product sold?
Select * from Salesdata;
Select branch, sum(Quantity) as Qnty 
from Salesdata
group by Branch
Having Sum(Quantity) > (Select Avg(Quantity) from salesdata);

-- 11. What is the most common product line by gender?

SELECT gender, product_line,
    COUNT(gender) AS total_cnt
FROM salesdata
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- 12. What is the average rating of each product line?
Select * from Salesdata;

Select Product_line, Round(Avg(Rating), 1) as avge_rat from salesdata
group by Product_line 
Order by  avge_rat desc;


-- Sales
-- 1. Number of sales made in each time of the day per weekday
Select * from Salesdata;

Select sum(Quantity) as no_of_sales, Time_of_day from Salesdata
Group by Time_of_day 
Order by no_of_sales desc;

SELECT Time_of_day, COUNT(*) AS total_sales FROM salesdata
WHERE day_name = "Tuesday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;

-- 2. Which of the customer types brings the most revenue?

Select Distinct Customer_type from salesdata;
Select * from Salesdata;

Select Customer_type, Sum(Total) as Total_Revenue from Salesdata
group by Customer_type
order by 2 desc;

-- 3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?
Select * from Salesdata;

Select City, Round(avg(Tax), 1) as Larg_Tax from salesdata 
Group by city
order by 2 desc;

-- 4. Which customer type pays the most in VAT?

Select * from Salesdata;

Select Customer_type, avg(Tax) as Larg_Tax from salesdata 
Group by Customer_type
order by 2 desc;

-- ### Customer
-- 1. How many unique customer types does the data have?

Select * from Salesdata;

Select distinct Customer_type from salesdata;

-- 2. How many unique payment methods does the data have?

Select distinct Payment from salesdata;

-- 3. What is the most common customer type?

Select Customer_type, Count(Customer_type) as Common_customer_type from salesdata
group by Customer_type
order by 2 desc
limit 1;

-- 4. Which customer type buys the most?
Select * from Salesdata;

Select Customer_type, Sum(Quantity) as Total_Bought from salesdata
group by customer_type
order by 2 desc;

-- 5. What is the gender of most of the customers?
Select Gender, count(Gender) as Count from salesdata
Group by Gender
order by 2 desc;

-- 6. What is the gender distribution per branch?

Select Gender, Count(Gender) as Gender_cnt from salesdata
where Branch = 'B'
Group by Gender
Order by 2 desc;

-- 7. Which time of the day do customers give most ratings?
Select * from Salesdata;

Select Time_of_day, avg(Rating) as Most_rat from salesdata
group by Time_of_day 
order by 2 desc;

-- 8. Which time of the day do customers give most ratings per branch?
Select * from Salesdata;

Select Time_of_day, Avg(Rating) as Avg_rat from salesdata
where branch = 'A'
group by Time_of_day
order by Avg_rat desc;

-- 9. Which day fo the week has the best avg ratings?
Select * from Salesdata;

Select Day_name, avg(Rating) as Most_rat from salesdata
group by Day_name 
order by 2 desc;

-- 10. Which day of the week has the best average ratings per branch?

Select Day_name, avg(Rating) as Most_rat from salesdata
where branch = 'A'
group by Day_name 
order by 2 desc;














