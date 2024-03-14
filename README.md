___


<div style="text-align: center; padding:10px">
    <img style="padding:10px" src="https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white" />
    <img style="padding:10px" src="https://img.shields.io/badge/Microsoft_Excel-217346?style=for-the-badge&logo=microsoft-excel&logoColor=white" />
    <img style="padding:10px" src="https://img.shields.io/badge/VSCode-0078D4?style=for-the-badge&logo=visual%20studio%20code&logoColor=white" />
    <img style="padding:10px" src="https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white" />
</div>

___
# Introduction
There are many roles in the field of data 📊 ranging from **Data Analyst** 📈, **Business Analyst** 🏦, **Data Scientist** 👨🏽‍🔬, **Data Engineer** ⚙️ and if you are just breaking into this field, the multitude of choice in terms of which role to focus on or which skill to learn can be overwhelming. In that light, this SQL project aims to lighten the burden of choice by answering some crucial questions.

🔎 Check out the queries here: [Project_SQL Folder](/Project_SQL/)

---
# Background
Inspired by [Luke Barousse's SQL Course](https://lukebarousse.com/sql)

I first heard of the role Data Analyst in 2022 when a friend of mine to a conference held in Unilag. After the conference, I was a bit confused on what to do or what to learn. I reached out to him on what to do. He told me I had to learn Excel as it was a very important skill to have as a data analyst but after that I had no data to back my choice of which skill should I learn next. So I'm glad I'm able to put this project out here for people to use. 

Here is the Entity Relationship Diagram (Data Model)

The data can be found on [Luke Barousse's SQL Course](https://lukebarousse.com/sql)


![ER Diagram](/ER%20Diagram.png)

### Here are the questions the SQL queries answered:
    1. What are the top-paying data analyst jobs?
    2. What skills are required for these top-paying jobs? 
    3. What skills are most in demand for data analysts?
    4. Which skills are associated with higher salaries?
    5. What are the most optimal skills to learn?
    6. What are in the in-demand skills for data analyst in Nigeria?
    7. What are the in-demand roles in Nigeria?

----
# Tools I Used
For my in-depth exploration of the data analyst job market, I utilized several essential tools:

- **SQL:** Crucial for querying the database and uncovering vital insights.
- **PostgreSQL:** The chosen flavor of SQL for managing job posting data efficiently.
    - **SQLTools:** Essential for database connections and visualizing SQL queries.
- **Visual Studio Code:** Used for database management and executing SQL queries.
- **Git & GitHub:** Crucial for version control and sharing SQL scripts and analysis, and project tracking.
- **Excel:** For visualizing some of the results of the queries.

---
# The Analysis
The queries within this project were crafted with the goal of providing insights into the job market in the data field.


### 1. Top paying jobs
Top paying jobs is a bit misleading as the roles where filtered to show only data analyst jobs. The data analyst roles were filtered by average yearly salary and location.     
```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name

FROM 
    job_postings_fact

LEFT JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id

WHERE 
    job_title_short = 'Data Analyst' AND 
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL


ORDER BY salary_year_avg DESC
LIMIT  10;
```
Here are the results of the query.
- Among the top 10 remote data analyst jobs, there is a wide range of salaries for data analyst positions, ranging from **$184,000** to **$650,000**.
- The job title were diverse showcasing there is a place for domain knowledge.

![Top Paying Jobs](/Assets/1_Top_paying_jobs.png)
***Bar graph visualizing the salary for the top 10 salaries for data analysts***


---
### 2. Skills for top paying jobs
It's often people's dreams to land high paying jobs, so this query answers what skills are required for high paying data analyst roles

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        job_location,
        job_schedule_type,
        salary_year_avg,
        job_posted_date,
        name AS company_name

    FROM 
        job_postings_fact

    LEFT JOIN company_dim
        ON job_postings_fact.company_id = company_dim.company_id

    WHERE 
        job_title_short = 'Data Analyst' AND 
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL

    ORDER BY salary_year_avg DESC
    LIMIT  10
)

SELECT 
    top_paying_jobs.*,
    skills_dim.skills

FROM top_paying_jobs

INNER JOIN skills_job_dim
    ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
```

Here are the results of the query
- SQL takes the lead with a noticeable count of 8.
- Python closely follows with a substantial count of 7.
- Tableau is also in high demand, registering a solid count of 6. 
- Other skills such as R, Snowflake, Pandas, and Excel exhibit different levels of demand.

![Top Paying Jobs Skills](/Assets/2_Top_Paying_Jobs.png)
***Bar graph visualizing the count of skills for the top 10 paying jobs for data analysts***

#### Challenges
The query will return skills associated with each high paying job but I wanted to count the number of times it appeared in the list and not for each job but I couldn't. So, for example SQL will appear multiple times under different jobs.

---
### 3. Skills currently in-demand
What skills are in-demand for data analyst is what this query answered.
```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count

FROM job_postings_fact



INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id

WHERE job_title_short = 'Data Analyst' AND
    job_work_from_home = TRUE
GROUP BY skills

ORDER BY demand_count DESC

LIMIT 5;
```
Here are the results of the query 


This table provides a clear overview of the most in-demand skills for data analysts, presenting the skills alongside their corresponding demand counts. It highlights SQL as the most sought-after skill, followed by Excel, Python, Tableau, and Power BI, offering valuable insights into the skills that are highly desirable in the field of data analysis.

| Skills | Demand Count |
| ------ | ------------ |
| SQL    | 7291         |
| Excel  | 4611         |
| Python | 4330         |
| Tableau| 3745         |
| Power BI| 2609        |

***Table of the demand for the top 5 skills in data analyst job postings***

### 4. Skills based on salary
What are the top paying skills based on salary? To answer the question, this query looks at the average salary associated with each skill for data analyst position regardless location.


```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM job_postings_fact

INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id

WHERE job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND 
    job_work_from_home = TRUE
GROUP BY 
    skills
ORDER BY 
    avg_salary DESC
LIMIT 25;
```

Here are the results of the query 
- **Variety of Skills:** The list encompasses a variety of skills, ranging from specific software tools like **"bitbucket"** and **"watson"** to programming libraries like **"pyspark"** and **"pandas.**
- **Specialized Tools:** Some skills, such as **"bitbucket"** and **"gitlab"** are related to version control systems, indicating the importance of software development practices in the data analyst role.
- **Top Paying Skills:** The top-paying skills for data analysts, as indicated by the highest average salaries, include **"pyspark"** with an average salary of $208,172, followed by **"bitbucket"** with $189,155, and **"couchbase"** and **"watson"** both with an average salary of $160,515.

| Skills | Average Salary ($) |
| ------ | ------------------ |
| pyspark | 208,172         |
| bitbucket | 189,155         |
| couchbase | 160,515         |
| watson | 160,515         |
| datarobot| 155,486        |
| gitlab  | 154,500         |
| swift | 153,750         |
| jupyter| 152,777         |
| pandas| 151,821        |
| elasticsearch | 145,000 |

***Table of the average salary for the top 10 paying skills for data analysts***

### 5. Optimal skills to learn (High demand and High Salary)
This search attempted to identify skills that are highly paid and in high demand, providing a strategic focus for skill development by combining insights from salary and demand.


```sql
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact

INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = TRUE

GROUP BY 
    skills_dim.skill_id

HAVING 
    COUNT(skills_job_dim.job_id) >= 10

ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 20;
```
| Skill Id | Skills	   | Demand Count | Average Salary ($) |
| -------- | ------    | ------------ | ------------------ |
| 8        |Go	       | 27	          | 115,320            |
| 234      |Confluence | 11	          | 114,210            |
| 97       |Hadoop	   | 22	          | 113,193            |
| 80       |Snowflake  | 37	          | 112,948            |
| 74       |Azure      | 34	          | 111,225            |
| 77       |Bigquery   | 13	          | 109,654            |
| 76       |AWS        | 32	          | 108,317            |
| 4        |Java	   | 17	          | 106,906            |
| 194      |SSIS	   | 12	          | 106,683            |
| 233      |Jira 	   | 20	          | 104,918            |

***Table of the most optimal skills for data analyst sorted by salary***

Here is what I discovered:
- Go Programming Language: Go emerges as the most optimal skill for Data Analyst roles in terms of both salary and demand. It has a demand count of 27 and an average salary of $115,320, making it a lucrative skill for professionals in the field.

- Confluence: Confluence, a collaboration software tool, also stands out with a demand count of 11 and an average salary of $114,210. This indicates that proficiency in Confluence is highly valued by employers seeking Data Analysts.

- Big Data Technologies: Skills related to big data technologies such as Hadoop and Snowflake are in demand and offer attractive salaries. Hadoop has a demand count of 22 and an average salary of $113,193, while Snowflake has a demand count of 37 and an average salary of $112,948.

- Cloud Platforms: Skills related to cloud platforms like Azure and AWS are also highly sought after. Azure has a demand count of 34 and an average salary of $111,225, while AWS has a demand count of 32 and an average salary of $108,317.

### 6. Top 20 skills for data analyst in Nigeria
As a data analyst in Nigeria what skills are required of me? This query dives into the data to explore necessary data analysis skills.

```sql
SELECT
    skills_job_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.skill_id) AS skill_count
FROM job_postings_fact

INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id

WHERE 
    job_location = 'Nigeria' AND
    job_title_short = 'Data Analyst'

GROUP BY 
    skills_dim.skills, 
    skills_job_dim.skill_id
ORDER BY skill_count DESC
LIMIT 20;
```

| Skill Id    | Skill    | Skill Count | 
| ----------- | -------- | --------    |
| 181         |	Excel    | 41          |
| 0           |	SQL	     | 35          |
| 1           |	Python	 | 22          |
| 183         |	Power BI | 16          |   
| 182         |	Tableau	 | 15          |
| 5           |	R	     | 13          |
| 188         |	Word	 | 12          |
| 199         |	SPSS	 | 6           |
| 7           |	SAS      | 5           |
| 186         |	SAS      | 5           |


***Table of the most in-demand skills for data analyst in Nigeria***

Here is what I discovered:

- Excel Proficiency: Excel emerges as the most in-demand skill for Data Analyst roles in Nigeria, with 41 occurrences. This highlights the continued importance of Excel in data analysis tasks, including data manipulation, visualization, and reporting.

- SQL Skills: SQL follows closely behind Excel in demand, with 35 occurrences. Proficiency in SQL is crucial for querying databases and extracting relevant data, indicating the importance of database management and querying skills for Data Analyst roles.

- Python Programming: Python ranks third in demand, with 22 occurrences. Python's popularity in the data analysis field is evident, as it offers powerful libraries and tools for data manipulation, analysis, and machine learning tasks.

- Visualization Tools: Power BI and Tableau are also among the top in-demand skills, with 16 and 15 occurrences, respectively. Proficiency in visualization tools like these is essential for creating insightful data visualizations and dashboards.

### 7. Jobs that are in-demand in Nigeria
Data analyst roles aren't the only Data roles available and for Nigerian data enthusiasts, there are other in-demand roles and this query dives into data highlight those roles

```sql
SELECT
    job_title_short,
    COUNT(job_title_short) AS job_demand

FROM job_postings_fact

WHERE
    job_location = 'Nigeria'

GROUP BY  job_title_short

ORDER BY job_demand DESC;
```
| Job Title                 | Job Demand | 
| ------------------------- | ---------- |
| Data Analyst              |	94       |
| Business Analyst          |	37	     |
| Data Scientist            |	20	     |
| Data Engineer             |	17	     | 
| Software Engineer         |	14	     | 
| Senior Data Analyst       |	6	     | 
| Senior Data Scientist     |	6	     | 
| Machine Learning Engineer |	5	     |
| Cloud Engineer            |	4	     | 
| Senior Data Engineer      |	1	     |

***Table of jobs in Nigeria that are in high demand***

Here is what I discovered:
- Data Analyst Dominance: Data Analyst roles are the most prevalent among data-related job postings in Nigeria, with a total demand of 94 postings. This suggests a significant need for professionals skilled in data analysis techniques and tools in the Nigerian job market.

- Business Analyst Demand: Following Data Analyst roles, Business Analyst positions are the second most in-demand, with 37 job postings. This indicates a notable requirement for individuals who can bridge the gap between data insights and business decision-making.

- Emerging Roles: While roles like Data Scientist and Data Engineer also have considerable demand, there is a noticeable presence of emerging roles such as Machine Learning Engineer and Cloud Engineer, which suggests a growing interest and investment in advanced data technologies and infrastructure.

- Senior Positions: Senior-level roles such as Senior Data Analyst, Senior Data Scientist, and Senior Data Engineer are also present in the job market, although their demand is comparatively lower, indicating a need for experienced professionals in these roles but perhaps not as prevalent as entry or mid-level positions.

# What I Learned
Throughout this project, I've engaged with various SQL concepts, enhancing my understanding along the way.
- ⚙️ **Writing Complex Queries:** Some questions I asked couldn't be answered by one simple query so concepts like Common Table Expressions were used. 
- ❌ **Debugging:** Throughout the life span of this project I experienced many errors and was able to fix most.
- ➕ **Utilizing Aggregation Functions:** Aggregation functions were really key to answering a lot of my questions. By utilizing them, I was able to summarize data.
# Conclusions

### Insights
1. **Top-paying jobs:** A diverse range of high-paying remote data analyst jobs exists, with salaries ranging from $184,000 to $650,000.
   
2. **Skills for top-paying jobs:** SQL leads in demand, followed by Python and Tableau, among other skills, indicating varied skill requirements for top-paying data analyst roles.

3. **Skills currently in demand:** SQL, Excel, Python, Tableau, and Power BI are the most sought-after skills for data analysts, with SQL being the most in demand.

4. **Skills based on salary:** Skills like pyspark, bitbucket, and couchbase are associated with the highest average salaries for data analysts, emphasizing the importance of specialized technical skills.

5. **Optimal skills to learn (High demand and high salary):** Proficiency in Go, Confluence, Hadoop, and cloud platforms like Azure and AWS are associated with high demand and attractive salaries for data analysts.

6. **Top 20 skills for data analyst in Nigeria:** Excel and SQL are the most in-demand skills for data analysts in Nigeria, followed by Python and visualization tools like Power BI and Tableau.

7. **Jobs that are in-demand in Nigeria:** Data Analyst roles dominate the Nigerian job market, followed by Business Analyst positions, indicating a significant demand for data-related skills in the country.

### Closing Thoughts

###### ***NOTE:  If you find errors in my queries, please reach out to me.***
This project was an eye opener to what can be achieved through SQL. I was afraid to do any SQL project but after this, I can say I will definitely be doing more. It wasn't easy but it was rewarding.


### Socials


- [![Twitter Follow](https://img.shields.io/twitter/follow/wolathedataguy?style=social)](https://twitter.com/your-twitter-username)

- [![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue)](https://www.linkedin.com/in/samuel-adekoya/)
- [![Tableau](https://img.shields.io/badge/Tableau-Follow-informational)](https://public.tableau.com/app/profile/samuel.adekoya/vizzes)


