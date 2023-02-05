-- Write Up---
use write_up;
SELECT * FROM write_up.corruption;
-- adding the primary key--
Alter TABLE write_up.corruption add country_number int
NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;
describe corruption;
-- droping the columns--
Alter table  corruption drop column Code;
Alter table  corruption drop column Local_government_councillors;
Alter table  corruption drop column PrimeMinister_President;
Alter table  corruption drop column Tax_officials;
Alter table  corruption drop column Traditional_leaders;
describe corruption;
-- using select, where, or, between, order by, limit commands--
SELECT  
	Country_number, 
    Entity, 
    Year, 
    Police, 
    Legislature, 
    Government_officials,
    Judges_and_magistrates, 
    Business_executives
FROM corruption
WHERE  Entity='Turkey';
SELECT  
	Country_number,
    Entity, 
    Year, 
    Police, 
    Legislature,
    Government_officials,
    Judges_and_magistrates,
    Business_executives
FROM Corruption
WHERE  Business_executives = 40;
SELECT  
	Country_number,
    Entity,
    Year, 
    Police, 
    Legislature, 
    Government_officials, 
    Judges_and_magistrates,
    Business_executives
FROM Corruption
WHERE  Business_executives >= 40;
SELECT  
	Country_number, 
    Entity, 
    Year, 
    Police, 
    Legislature, 
    Government_officials, 
    Judges_and_magistrates, 
    Business_executives
FROM Corruption
WHERE  Business_executives between '40' and '70';
SELECT  
	Country_number,
    Entity, 
    Year,
    Police,
    Legislature,
    Government_officials, 
    Judges_and_magistrates, 
    Business_executives
FROM Corruption
WHERE  Year='2013' or Year='2017' order by Year Desc;
SELECT  
	Country_number, 
    Entity, 
    Year, 
    Police, 
    Legislature,
    Government_officials, 
    Judges_and_magistrates, 
    Business_executives
FROM corruption
Limit 50;
SELECT  
	Country_number, 
    Entity,
    Year, 
    Police, 
    Legislature, 
    Government_officials, 
    Judges_and_magistrates,
    Business_executives
FROM corruption
Where Entity BETWEEN 'A' AND 'T';
SELECT  Country_number, Entity, Year, Police, Legislature, Government_officials, Judges_and_magistrates, Business_executives
FROM corruption
WHERE Government_officials IN ('40','70') order by Government_officials;
-- write up 2 --
-- adding new tables--
/* I added new tables corruption_index and bribery rate*/
describe corruption_index;
describe bribery_rates;
-- assigning  pk for new tables-- 
Alter TABLE write_up.corruption_index add index_number int
NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;
Alter TABLE write_up.bribery_rates add rate_number int
NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;
--  inner join--
-- query 1: I am joining corruption table to corruption_index table--
    select c.country_number as country_number,
    c.entity as entity, 
    ci.code,
    c.year
    from corruption c
    inner join corruption_index ci on c.entity= ci.entity
    group by country_number; 
/*query 2 shows the inner join with corruption and corruption_index 
where count of corruption_index entity less than 50*/
	select c.country_number as country_number,
    c.entity as entity, 
    ci.code,
    c.year
    from corruption c
    inner join corruption_index ci on c.entity= ci.entity
    group by country_number
    having count(ci.entity)<50;
/* query 3 shows the inner join of corruption and corruption_index 
where cpi(corruption perception index) is lower or equal to 40*/
	select distinct c.country_number as country_number,
    c.entity as entity, 
    ci.code,
    c.year,
    ci.cpi_2018 as cpi_in_precentage
    from corruption c
    inner join corruption_index ci on c.entity= ci.entity
    where ci.cpi_2018 >=40;

-- left join --
-- query 4: I am joining corruption_index table to bribery_rates where I will not get any nulls--
    select 
    b.rate_number as rate_number,
    b.entity as entity,
    b.code as country_code,
    b.br_in_precentage as BR_in_precentage,
    b.year as year
    from bribery_rates b
    left join corruption_index ci  on b.code= ci.code
    group by b.rate_number; 
/* query 5: I am joining corruption_index table to bribery_rates 
where avg of BR(bribery rate)_in_precentage and average of CPI_in precentage per rate_number
returning it without any nulls*/
	select  b.rate_number as rate_number,
    b.entity as entity,
    b.code as country_code,
    round(avg(b.br_in_precentage)) as BR_in_precentage,
    round(avg(ci.cpi_2018)) as CPI_in_precentage,
    b.year as year
    from bribery_rates b
    left join corruption_index ci  on b.code= ci.code
    group by b.rate_number;
    /* query 6: I am joining corruption_index table to bribery_rates 
where avg of BR(bribery rate)_in_precentage and average of CPI_in precentage per rate_number
and decending ordering by br_in_precentage
returning it without any nulls*/
	select  b.rate_number as rate_number,
    b.entity as entity,
    b.code as country_code,
    round(avg(b.br_in_precentage)) as BR_in_precentage,
    round(avg(ci.cpi_2018)) as CPI_in_precentage,
    b.year as year
    from bribery_rates b
    left join corruption_index ci  on b.code= ci.code
    group by b.rate_number
    having avg(b.br_in_precentage)>50
    order by avg(b.br_in_precentage) Desc;    
  
  -- case--
  /* query 7 shows case analysis to find which country is over 50% or under50% or =50% based on br_in_precentage and commenting,
  order by lowesr bribery rate to highest*/
  SELECT *,
	CASE WHEN BR_in_precentage > 50 THEN'The bribery rate is high'
	WHEN Br_in_precentage < 50 THEN'The bribery rate is low'
	ELSE'The bribery rate is in average'
	END AS Comment_on_BR
	FROM bribery_rates
	order by br_in_precentage;

/* query 8 shows case analysis to find which country has low CPI, high CPI, or thet equals to 70 based on cpi_2018 and commenting
ordering by from the highest CPI to lowers CPI*/
select* ,
	CASE WHEN CPI_2018 > 70 THEN'The CPI is high'
	WHEN CPI_2018 < 70 THEN'The CPI rate is low'
	ELSE'The CPI in the middle'
	END AS Comment_on_CPI
	FROM corruption_index 
    order by CPI_2018 Desc;
-- locate--
/* query 9 shows the how I located countries who has sufffix-'stan'*/
select distinct *,
locate('stan', entity) as MatchPosition
from corruption_index; 
/*query 10 shows the countries who has suffix 'stan' starts after 5th letter*/
select distinct *,
locate('stan', entity) as MatchPosition
from corruption_index
where locate('stan', entity)>5;

-- position--
/* query 11 shows simmilar output of query 9*/
select distinct *,
position("stan" in entity)as MatchPostion
from bribery_rates;
/*query 12 shows similar output of query 10*/
select distinct *,
position('stan' in entity) as MatchPosition
from bribery_rates
where position('stan' in entity)>5;

-- insert function in case insensitiv--
/* query 13 shows different value insertion that sepretaes 'stan' from countries*/
select *, Insert( entity, locate ("Stan",entity), 0, "-")  as countries_ends_stan 
from bribery_rates
where locate ("stan", entity)>0;

-- aggregate function-- 
/* query 14 shows the max, min, and avg of CPI*
order by from the highes to lowest of max of CPI*/ 
SELECT distinct *,
  MAX(CPI_2018) max_CPI,
  MIN(CPI_2018) min_CPI,
  round(AVG(CPI_2018)) avg_CPI
FROM corruption_index
group by index_number
order by max_CPI desc;
/* query 15 shows the max, min, avg of bribery rate
ordered by from the highes to lowes of avg of bribery rate*/
SELECT distinct *,
  MAX(BR_in_precentage) max_BR,
  MIN(BR_in_precentage) min_BR,
  round(AVG(BR_in_precentage)) avg_BR
FROM bribery_rates
group by rate_number
order by avg_BR;