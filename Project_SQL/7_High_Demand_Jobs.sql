SELECT
    job_title_short,
    COUNT(job_title_short) AS job_demand

FROM job_postings_fact

WHERE
    job_location = 'Nigeria'

GROUP BY  job_title_short

ORDER BY job_demand DESC;