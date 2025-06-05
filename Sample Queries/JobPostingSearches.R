"
Program: JobPostingSearches
Purpose: This program demonstrates how to look up job postings based off different criteria 
         The following is covered
              I.   Job postings from a specific company in a specified date range
              II.   Obtain the original, raw job title from a job posting
           
Contact: BRDS@hbs.edu, https://www.library.hbs.edu/services/research-data-faculty-doctoral
June 2025
"

# ---- 0. Set Up ----
## Run the Set Up Program
source("SetConnection.R")

# ---- 1. Filter by Company/Date  -----
"
The postings_linkedin table contains job postings to LinkedIn.
Using the rcid column we can search job postings by company.
The post_date column allows us to narrow down the date of the job posting
"
## Pull job postings from Ford Motor Company (rcid = 860320) in May 2024
res <- dbSendQuery(wrds, glue(
  "SELECT job_id, company, country, state, metro_area, role_k1500, job_category, salary, post_date
  FROM revelio.postings_linkedin
  WHERE post_date > '05-01-2024' 
    AND post_date < '05-31-2024'
    AND rcid = '860320'
  LIMIT 25"))

postings <- dbFetch(res, n=-1)
dbClearResult(res)
postings


# ---- 2. Obtain Basic Information and Original Title -----
"
The role variables (role_k1500 etc.) are Revelio's classificaitons of a job role.
The original role title posted on LinkedIn in stored in the postings_linkedin_raw table.

This query pulls basic informaiton on job postings from the postings_linkedin table
It also pulls the original job title and description from the postings_linkedin_raw table.

The two tables are joined together by job_id.
"

## Pull Basic job info 
### Look up the company by LinkedIn URL:
res <- dbSendQuery(wrds, glue(
     "SELECT p.job_id, p.company, p.country, p.state, p.metro_area, p.role_k1500, p.job_category, p.salary,
            r.title_raw, r.description 
      FROM revelio.postings_linkedin as p
      LEFT JOIN revelio.postings_linkedin_raw as r
        ON p.job_id = r.job_id
      LIMIT 25"))

postings_rawtitle <- dbFetch(res, n=-1)
dbClearResult(res)
postings_rawtitle


