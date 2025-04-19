use maven_toys;

-- top 3 products by sales 

select p.Product_Name ,round(sum(replace(Product_Price,"$","")*60*(s.Units))) sales
from products p inner join sales s on p.Product_ID=s.Product_ID 
group by p.Product_Name
order by sales desc limit 5;

-- --------------------------------------------------------------------------------------------------------
-- stores with min sale
select ss.Store_Name, p.Product_Name ,round(sum(replace(Product_Price,"$","")*60*(s.Units))) sales
from products p inner join sales s on p.Product_ID=s.Product_ID 
inner join stores ss on s.Store_ID=ss.Store_ID 
group by p.Product_Name,ss.store_Name
order by sales asc limit 5;

-- --------------------------------------------------------------------------------------------------------
-- Most selling product with store name
with inventorty as (
select ss.Store_Name,p.Product_Name,count(s.Units), row_number() over(
partition by ss.Store_Name 
order by count(s.Units) desc ) sallleee from products p
inner join sales s on s.Product_ID=p.Product_ID
inner join  stores ss on ss.Store_ID=s.Store_ID
group by p.Product_Name,ss.Store_Name)
select * from inventorty  where sallleee=1;

-- --------------------------------------------------------------------------------------------------------
-- sale per month on the basis of 
 SELECT 
    monthname(Date) AS sale_month,
    SUM(REPLACE(Product_Price, '$', '') * 60 * s.Units) AS total_sales
FROM 
    sales s
    INNER JOIN 
    products p ON s.Product_ID = p.Product_ID 
GROUP BY 
    monthname(Date)
ORDER BY 
    sale_month;
-- --------------------------------------------------------------------------------------------------------
-- sale per year

with inventory as (
   SELECT 
   monthname(Date) AS sale_month,year(Date) as yr,
   SUM(REPLACE(Product_Price, '$', '') * 60 * s.Units),row_number() over(
   partition by year(Date))
 FROM 
   sales s
    INNER JOIN 
    products p ON s.Product_ID = p.Product_ID
 GROUP BY 
monthname(Date),year(Date)
ORDER BY 
   sale_month)
   select * from inventory order by yr;
-- --------------------------------------------------------------------------------------------------------
-- store names with their product names having min stock

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

with inventory as(
select st.Store_Name,p.Product_Name,sum(i.Stock_On_Hand) ,
row_number() over(partition by i.Product_ID 
order by sum(i.Stock_On_Hand)  asc) row_num
from inventory i
inner join stores st on i.Store_ID=st.Store_ID
inner join products p on i.Product_ID=p.Product_ID
group by st.Store_ID,p.Product_ID)
select * from inventory where row_num<6;


-- --------------------------------------------------------------------------------------------------------
-- store with max sales according to location
with inventory as(
 select ss.Store_Name,ss.Store_Location,round(sum(replace(Product_Price,"$","")*60*(s.Units))) ,
 row_number() over(
 partition by ss.Store_Location order by round(sum(replace(Product_Price,"$","")*60*(s.Units))) desc ) row_num
from products p inner join sales s on p.Product_ID=s.Product_ID 
inner join stores ss on s.Store_ID=ss.Store_ID 
group by ss.Store_Name)
select * from inventory where row_num=1;
-- --------------------------------------------------------------------------------------------------------

