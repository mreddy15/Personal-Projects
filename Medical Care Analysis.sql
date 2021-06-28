--Select all values from Reduced_Access (table displaying reduced access to health care due to Covid 19)
SELECT * FROM Reduced_Access
--Select all values from Reduced_Access where the grouping of patients, further distilled in the "Subgroups" column, is by age (vs. Sex, race, etc.)
SELECT * FROM Reduced_Access
WHERE GROUPINGS = 'By Age'
--Select the percent of patients who did not get the care they needed in the past 4 weeks, broken out by age group. There are 8 age groups, spanning from 18 years old to over 80 years. Ordering by the first time period end date allows us to see trends spanning from May 2020 to June 2021. However, parsing through this much data is unhelpful- I want to draw more insights from this so I'm going to find some interesting numbers in my next query.
SELECT Indicator, Subgroups, Percent_Affected, Time_Period_End_Date FROM Reduced_Access
WHERE GROUPINGS = 'By AGE' AND Indicator = 'Did not get needed care, last 4 weeks'
GROUP BY Indicator, Subgroups, Percent_Affected, Time_Period_End_Date ORDER BY Time_Period_End_Date ASC
--Display the value for the highest number of patients who did not get the care they needed in the past 4 weeks (or, conversely, the point with the lowest access to necessary care), broken out by age group. Taking the max and grouping by subgroups allows just one table displaying the max within each age group. I found that 50-59 year olds had the highest of all of the maxes at a whopping 38.7%, while 70-79 year olds had the lowest, at 30.8%. My gut reaction says that this is likely because a large group of these patients are either in a retirement home, living with family, or mobile enough to transport themselves, but I'd like to do some independent research to confirm. 
SELECT Subgroups, MAX(Percent_Affected) AS 'Lowest_Access_Point' FROM Reduced_Access
WHERE Groupings = 'BY AGE' AND Indicator = 'Did Not Get Needed Care, Last 4 Weeks'
GROUP BY Subgroups ORDER BY Lowest_Access_Point DESC
--Group the Time Period End Dates by Season based on Calendar Season start and end dates using case. This will allow us to query data by season, our new value. This requires a little bit more complex of a query, but it shows us som pretty cool data, like this one below- we can see that the highest average number of patients who did not receive care when they should have (Average_Percent_Affected filtered by "Did Not Get Needed Care, Last 4 Weeks"), was highest in Spring 2020 at 31.98%, compared to Spring 2021 at 14.98% when cases were lower, hospitals were less crowded, and people are less afraid to go to get the care they need.
SELECT Season, AVG(Percent_Affected) AS Average_Percent_Affected from (
SELECT Subgroups, Percent_Affected, Time_Period_End_Date,
CASE
WHEN Time_Period_End_Date > '2021-06-19 00:00:00.000' THEN 'Summer 2021'
WHEN Time_Period_End_Date > '2021-03-19 00:00:00.000' THEN 'Spring 2021'
WHEN Time_Period_End_Date > '2020-12-20 00:00:00.000' THEN 'Winter 2020'
WHEN Time_Period_End_Date > '2020-09-21 00:00:00.000' THEN 'Fall 2020'
WHEN Time_Period_End_Date > '2020-06-19 00:00:00.000' THEN 'Summer 2020'
WHEN Time_Period_End_Date > '2020-03-18 00:00:00.000' THEN 'Spring 2020'
ELSE 'N/A'
END as 'Season'
FROM Reduced_Access
WHERE Groupings = 'By Age' AND Indicator = 'Did Not Get Needed Care, Last 4 Weeks')
AS newone
GROUP BY Season ORDER BY Average_Percent_Affected DESC

--Just to verify, checking the same query but with "Delayed Medical Care, Last 4 Weeks". We see again that Spring 2020 is the highest value at 39.85%, and Spring 2021 is the lowest value at 18.59%, meaning that we decreased the current numbers to less than half of what we were seeing at our peak. Hooray progress!
SELECT Season, AVG(Percent_Affected) AS Average_Percent_Affected from (
SELECT Subgroups, Percent_Affected, Time_Period_End_Date,
CASE
WHEN Time_Period_End_Date > '2021-06-19 00:00:00.000' THEN 'Summer 2021'
WHEN Time_Period_End_Date > '2021-03-19 00:00:00.000' THEN 'Spring 2021'
WHEN Time_Period_End_Date > '2020-12-20 00:00:00.000' THEN 'Winter 2020'
WHEN Time_Period_End_Date > '2020-09-21 00:00:00.000' THEN 'Fall 2020'
WHEN Time_Period_End_Date > '2020-06-19 00:00:00.000' THEN 'Summer 2020'
WHEN Time_Period_End_Date > '2020-03-18 00:00:00.000' THEN 'Spring 2020'
ELSE 'N/A'
END as 'Season'
FROM Reduced_Access
WHERE Groupings = 'By Age' AND Indicator = 'Delayed Medical Care, Last 4 Weeks')
AS newone1
GROUP BY Season ORDER BY Average_Percent_Affected DESC
