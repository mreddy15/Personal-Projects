--Select all values from Mental_Health_Care (table displaying those who did and did not receive mental health care in the last 4 weeks). from Mental_Health_Care
SELECT * FROM Mental_Health_Care
--Display the average percent of those who did not receive the counseling or therapy they needed in the last 4 weeks, broken out by states with the highest percent first. Oregon, with a total of 208,000 cases, was at the top of the list at 14.02%, whereas Hawaii, which has had a total of 36,000 cases as of June 2021, is lowest at 6.92%. This is likely due to the fact that fewer cases in Hawaii mean less of an overload of healthcare services, as well as more citizens being healthy enough and confident enough to receive the care they need. This is still surprising, however, considering that Oregon's cases are relatively low compared to other states. This tells me that Average Percent Affected is not solely linked to Covid cases; other factors come into play. Some quick research tells me that this might just be due to a general lack of healthcare in Oregon, especially in rural areas. I want to see if I can do a bit more digging with the data to back up my hypothesis.
SELECT States, AVG (Percent_Affected) AS Average_Percent_Affected FROM Mental_Health_Care
WHERE Groupings = 'BY STATE' AND Indicator = 'Needed Counseling or Therapy But Did Not Get It, Last 4 Weeks'
GROUP BY States
ORDER BY Average_Percent_Affected DESC
--Display the average percent of those who did not receive counseling or therapy in the last 4 weeks AFTER April 2021, when we started seeing an increase in Covid vaccinations and therefore would expect to see these average percents return to more normal values with Covid as less of a factor. This time, Vermont comes in first at 13.13%, but Oregon is second at 12.78%, still pretty high up there. While it's not a definite indicator, this tells me that Oregon probably has a Mental Health Care access issue that goes beyond Covid. In fact, Mental Health America ranks Oregon 49 out of 51 states in terms of mentall illness relative to access to care. It appears Covid isn't the reason Oregon ranks so high, but a fascinating finding nonetheless.
SELECT States, AVG (Percent_Affected) AS Average_Percent_Affected FROM Mental_Health_Care
WHERE Groupings = 'BY STATE' AND Indicator = 'Needed Counseling or Therapy But Did Not Get It, Last 4 Weeks' AND Time_Period_End_Date >= '2021-04-01 00:00:00.000'
GROUP BY States
ORDER BY Average_Percent_Affected DESC
--Display the average percent of patients without a disability who are affected for each indicator group (which shows whether or not they received treatment). Overall, only 7.95% without a disability didn't receive the care they needed, and 21.28% either took their medication and/or received therapy. 
SELECT Indicator, AVG (Percent_Affected) AS Average_Percent_Without_Disability_Affected FROM Mental_Health_Care
WHERE Groupings = 'BY Disability Status' AND Subgroups = 'Without Disability'
GROUP BY Indicator
ORDER BY Average_Percent_Without_Disability_Affected DESC
--Display the average percent of patients with a disability who are affected for each indicator group. Overall, those with a disability who did not receive the care they needed was 22.68%, almost 3 times what it was for those who don't have a disability. However, the average percent value of those who either took their medication and/or received therapy was 46.35%. This is a misleading statistic that initially looks like a lot more people with disabilities are getting access to care than those without; what that really tells me is that a higher percentage of those with disabilities need medication or therapy- it's great that so many people with disabilities are getting care, but there are many more people with disabilities who need medical care than those who don't, and a larger portion of those with disabilies are not able to get the care they need, exacerbated by Covid 19.
SELECT Indicator, AVG (Percent_Affected) AS Average_Percent_With_Disability_Affected FROM Mental_Health_Care
WHERE Groupings = 'BY Disability Status' AND Subgroups = 'With Disability'
GROUP BY Indicator
ORDER BY Average_Percent_With_Disability_Affected DESC
--Display the average percent of users affected by each indicator, grouped by indicator and subgroups. A new column displays the order of education level, with 1 being less than a High School Diploma or GED and 4 being Bachelor's Degree or Higher. We can see that there is somewhat of a trend between education level and level of care; those with less than a high school degree or GED were ranked last for percent of people who took medication and/or had therapy or counseling, and second highest for percent of people who needed therapy or counseling but did not get it. Those with some college/Associate's Degree or a Bachelor's Degree or higher received pretty good care, with the exception that those with some college/Associate's degree ranked highest for those who needed counseling or therapy but did not get it. Again, there are likely confounding factors that prevented them from getting therapy/counseling (stigma, etc.).
SELECT Indicator, Subgroups, AVG(Percent_Affected) AS Average_Percent_Affected_By_Education,
CASE
WHEN Subgroups = 'Less Than a High School Diploma' THEN '1'
WHEN Subgroups = 'High school diploma or GED' THEN '2'
WHEN Subgroups = 'Some College/Associate''s Degree' THEN '3'
WHEN Subgroups = 'Bachelor''s Degree or Higher' THEN '4'
ELSE 'N/A'
END AS 'Order_Of_Education_Level'
FROM Mental_Health_Care
WHERE Groupings = 'By Education'
GROUP BY Indicator, Subgroups
ORDER BY Indicator, Average_Percent_Affected_By_Education DESC
