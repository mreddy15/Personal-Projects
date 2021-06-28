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


--Select all values from Mental_Health_Care (table displaying those who did and did not receive mental health care in the last 4 weeks). from Mental_Health_Care
SELECT * FROM Mental_Health_Care
--Display the average percent of those who did not receive the counseling or therapy they needed in the last 4 weeks, broken out by states with the highest percent first. Oregon, with a total of 208,000 cases, was at the top of the list at 14.02%, whereas Hawaii, which has had a total of 36,000 cases as of June 2021, is lowest at 6.92%. This is likely due to the fact that fewer cases in Hawaii mean less of an overload of healthcare services, as well as more citizens being healthy enough and confident enough to receive the care they need. This is still surprising, however, considering that Oregon's cases are relatively low compared to other states. This tells me that Average Percent Affected is not solely linked to Covid cases; other factors come into play. Some quick research tells me that this might just be due to a general lack of healthcare in Oregon, especially in rural areas. I want to see if I can do a bit more digging with the data to back up my hypothesis.
SELECT States, AVG (Percent_Affected) AS Average_Percent_Affected FROM Mental_Health_Care WHERE Groupings = 'BY STATE' AND Indicator = 'Needed Counseling or Therapy But Did Not Get It, Last 4 Weeks' GROUP BY States ORDER BY Average_Percent_Affected DESC
--Display the average percent of those who did not receive counseling or therapy in the last 4 weeks AFTER April 2021, when we started seeing an increase in Covid vaccinations and therefore would expect to see these average percents return to more normal values with Covid as less of a factor. This time, Vermont comes in first at 13.13%, but Oregon is second at 12.78%, still pretty high up there. While it's not a definite indicator, this tells me that Oregon probably has a Mental Health Care access issue that goes beyond Covid. In fact, Mental Health America ranks Oregon 49 out of 51 states in terms of mentall illness relative to access to care. It appears Covid isn't the reason Oregon ranks so high, but a fascinating finding nonetheless.
SELECT States, AVG (Percent_Affected) AS Average_Percent_Affected FROM Mental_Health_Care WHERE Groupings = 'BY STATE' AND Indicator = 'Needed Counseling or Therapy But Did Not Get It, Last 4 Weeks' AND Time_Period_End_Date >= '2021-04-01 00:00:00.000' GROUP BY States ORDER BY Average_Percent_Affected DESC
--Display the average percent of patients without a disability who are affected for each indicator group (which shows whether or not they received treatment). Overall, only 7.95% without a disability didn't receive the care they needed, and 21.28% either took their medication and/or received therapy. 
SELECT Indicator, AVG (Percent_Affected) AS Average_Percent_Without_Disability_Affected FROM Mental_Health_Care WHERE Groupings = 'BY Disability Status' AND Subgroups = 'Without Disability' GROUP BY Indicator ORDER BY Average_Percent_Without_Disability_Affected DESC
--Display the average percent of patients with a disability who are affected for each indicator group. Overall, those with a disability who did not receive the care they needed was 22.68%, almost 3 times what it was for those who don't have a disability. However, the average percent value of those who either took their medication and/or received therapy was 46.35%. This is a misleading statistic that initially looks like a lot more people with disabilities are getting access to care than those without; what that really tells me is that a higher percentage of those with disabilities need medication or therapy- it's great that so many people with disabilities are getting care, but there are many more people with disabilities who need medical care than those who don't, and a larger portion of those with disabilies are not able to get the care they need, exacerbated by Covid 19.
SELECT Indicator, AVG (Percent_Affected) AS Average_Percent_With_Disability_Affected FROM Mental_Health_Care WHERE Groupings = 'BY Disability Status' AND Subgroups = 'With Disability' GROUP BY Indicator ORDER BY Average_Percent_With_Disability_Affected DESC
SELECT Indicator, Subgroups, AVG(Percent_Affected) AS Average_Percent_Affected_By_Education FROM Mental_Health_Care WHERE Groupings = 'By Education' GROUP BY Indicator, Subgroups
SELECT 

SELECT Indicator, Subgroups, Order_Of_Indicators, AVG(Percent_Affected) As Average_Percent from (
SELECT Indicator, Subgroups, Percent_Affected,
CASE
WHEN Indicator = 'Needed Counseling or Therapy But Did Not Get It, Last 4 Weeks' THEN '1'
WHEN Indicator = 'Received Counseling or Therapy, Last 4 Weeks' THEN '2'
WHEN Indicator = 'Took Prescription Medication for Mental Health And/Or Received Counseling or Therapy, Last 4 Weeks' THEN '3'
WHEN Indicator = 'Took Prescription Medication for Mental Health, Last 4 Weeks' THEN '4'
ELSE 'N/A'
END AS 'Order_Of_Indicators'
FROM Mental_Health_Care
WHERE Groupings = 'By Education'
GROUP BY Indicator, Subgroups, Percent_Affected)
AS newtwo
GROUP BY Indicator, Subgroups, Percent_Affected, Order_Of_Indicators
ORDER BY Order_Of_Indicators DESC

SELECT Indicator, Subgroups, AVG(Percent_Affected),
CASE
WHEN Subgroups = 'Needed Counseling or Therapy But Did Not Get It, Last 4 Weeks' THEN '1'
WHEN Indicator = 'Received Counseling or Therapy, Last 4 Weeks' THEN '2'
WHEN Indicator = 'Took Prescription Medication for Mental Health And/Or Received Counseling or Therapy, Last 4 Weeks' THEN '3'
WHEN Indicator = 'Took Prescription Medication for Mental Health, Last 4 Weeks' THEN '4'
ELSE 'N/A'
END AS 'Order_Of_Indicators'
FROM Mental_Health_Care
WHERE Groupings = 'By Education'
GROUP BY Indicator, Subgroups
ORDER BY Order_Of_Indicators DESC