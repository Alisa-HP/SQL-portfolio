--Dataset: McDonalds Nutrition
--Source: Kaggle https://www.kaggle.com/datasets/joebeachcapital/mcdonalds-nutrition
--Queried using: Microsoft SQL Server Management Studio


--Question 1: How many food items in each categories?

SELECT [Category],
       COUNT([Item]) AS Number_Items
FROM [dbo].[McDonaldsMenu$]
GROUP BY [Category]
ORDER BY Number_Items DESC;

--Question 2:What are the top ten maximun calories for food items, and what are their nutritions?
SELECT TOP 10 * FROM [dbo].[McDonaldsMenu$]
ORDER BY  [Calories] DESC

--Question 3: Which top 10 food items contain the maximum sodium amount?
SELECT TOP 10 
     [Item],
	 [Category],
     [Sodium _(mg)]
FROM [dbo].[McDonaldsMenu$]
ORDER BY  [Sodium _(mg)] DESC;

--Question 4: Which category  and which item contains maximum fiber?

SELECT TOP 1
       [Category],
       [Item],
       [Fiber_(g)]
FROM [dbo].[McDonaldsMenu$]
ORDER BY [Fiber_(g)] DESC;

--Question 5:What is the average calories by category? 

SELECT [Category],
       round(avg([Calories]),2) AS avg_calories
FROM   [dbo].[McDonaldsMenu$]
GROUP BY [Category]
ORDER BY avg_calories DESC;


--Question 6: Which category has a high amount of protein and what is the amount of fat? 
SELECT  [Category],
        MAX(Median_Protein) AS Median_Protein,
		MAX(Median_Fat) AS Median_Fat
FROM   (
         SELECT 
           [Category],
              PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY [Protein_(g)]) 
		        OVER(PARTITION BY [Category]) AS Median_Protein,
		      PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY [Total Fat_(g)])
		        OVER(PARTITION BY [Category])  AS Median_Fat
		FROM [dbo].[McDonaldsMenu$]
		) AS SubQuery
GROUP BY [Category]
ORDER BY Median_Protein DESC, Median_Fat ASC;



--Question 7: How many food items and what item that have less calories than 400 and what are their average protein? Only main dish
DECLARE @Calories varchar(100)
SET @Calories = '400'

SELECT [Category],
       COUNT([Item]) AS Item__less_400cals,
	   ROUND(AVG([Protein_(g)]),2) AS Average_Protein
FROM [dbo].[McDonaldsMenu$]
WHERE [Calories] <= @Calories 
      AND [Category] not in ('Coffees, Teas and Hot Chocolate', 'Smoothies', 'Desserts', 'Soft Drinks', 'Other', 'Dressing'  )
GROUP BY [Category]
ORDER BY Average_Protein DESC;



--Question 8: Are there any relationships between category and the level of  of Cholesterol?

SELECT 
     [Category],  
	 count([Item]) AS Number_Items,
     ROUND(AVG([Cholesterol_(mg)]),2) AS Average_Cholestorol,
	 CASE
       WHEN AVG([Cholesterol_(mg)]) > 300 THEN 'High'
	   END AS 'Level'
 FROM [dbo].[McDonaldsMenu$]
 WHERE ([Cholesterol_(mg)]) >300
 GROUP BY  [Category]
 UNION
 SELECT 
     [Category],
	 count([Item]) AS Number_Items,
     ROUND(AVG([Cholesterol_(mg)]),2) AS Average_Cholestorol ,
	  CASE
       WHEN AVG([Cholesterol_(mg)]) BETWEEN 200 AND 299 THEN 'Moderate'
	   END AS 'Level'
 FROM [dbo].[McDonaldsMenu$]
 WHERE ([Cholesterol_(mg)]) BETWEEN 200 AND 299
 GROUP BY  [Category]
 UNION
  SELECT 
     [Category],  
	 count([Item]) AS Number_Items,
     ROUND(AVG([Cholesterol_(mg)]),2) AS Average_Cholestorol ,
	 CASE
       WHEN AVG([Cholesterol_(mg)]) BETWEEN 0 AND 200 THEN 'Low'
	   END AS 'Level'
 FROM [dbo].[McDonaldsMenu$]
 WHERE ([Cholesterol_(mg)]) BETWEEN 0 AND 200
 GROUP BY  [Category]
 ORDER BY Average_Cholestorol DESC;
 



