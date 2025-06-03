"
Program: CompanyLookUp
Purpose: This program demonstrates how to look up a company in Revelio to find its RCID.  
         The following ways of searching for companies are shown:
              I.    Company Name
              II.   Company LinkedIn URL
              III.  Company Name and naics code
           


Contact: BRDS@hbs.edu, https://www.library.hbs.edu/services/research-data-faculty-doctoral
June 2025
"
# --- 0. Set Up ----
source("SetConnection.R")


# ---- I. Company Name ----
## Pull all companies with "Harvard Business" in the name:
res <- dbSendQuery(wrds, "SELECT * 
                   FROM revelio.company_mapping
                   WHERE company LIKE  '%Harvard Business%'")
companies_name <- dbFetch(res, n=-1)
dbClearResult(res)

## This pulls many companies such as "Harvard Business School Club of New York" or "Harvard Business Review France"
companies_name %>% 
  select(company, rcid) %>% 
  head(10)

## After determining which company listed is the one you are interested in, you can identify it with the "rcid"



# ---- II. Company LinkedIn ----
## Locate One Company: ----
### Locate the company on LinkedIn and edit the URL to fit the way it appears in Revelio:
linkedin_url <- gsub("https", "http", "https://www.linkedin.com/company/microsoft/") # Remove "s" from http
linkedin_url <- gsub("www.", "", linkedin_url) #Remove www.
linkedin_url <- gsub("/$", "", linkedin_url) #Remove ending /


### Look up the company by LinkedIn URL:
res <- dbSendQuery(wrds, glue("SELECT * 
                   FROM revelio.company_mapping
                   WHERE linkedin_url = '{linkedin_url}'"))
companies_linkedin <- dbFetch(res, n=-1)
dbClearResult(res)
companies_linkedin


## Locate Multiple Companies: ---- 
### Create Data Frame with sample URLs
linkedin_urls <- data.frame(
  name = c("Microsoft", "Google", "IBM", "Ford", "Harvard Business School"),
  url = c("https://www.linkedin.com/company/microsoft/", "https://www.linkedin.com/company/google/",
                    "https://www.linkedin.com/company/ibm/", "https://www.linkedin.com/company/ford-motor-company/",
                    "https://www.linkedin.com/school/harvard-business-school/"))

### Clean URLs by taking 
linkedin_urls <- linkedin_urls %>% 
  mutate(url_core = sub(".*/([^/]+)/$", "\\1", url)) %>% 
  mutate(url_clean = glue("http://linkedin.com/company/{url_core}")) 

### Note that in the example above, the original URL for HBS had the word "school" in it instead of company
### By extracting only the ending of the url and placing it in the standard url format above, we are able to find HBS through the LinkedIn url


### Create SQL Code and Query Data 
inlist_code <-  paste0("('", paste0(linkedin_urls$url_clean, collapse = "', '"), "')")

res <- dbSendQuery(wrds, glue("SELECT * 
                   FROM revelio.company_mapping
                   WHERE linkedin_url IN {inlist_code} "))
companies_linkedin <- dbFetch(res, n=-1)
dbClearResult(res)
companies_linkedin




# ---- III. Company Name and Naics Code ----
## When looking for companies with "Harvard" in the name, we get many results: 
res <- dbSendQuery(wrds, "SELECT * 
                   FROM revelio.company_mapping
                   WHERE company LIKE  '%Harvard%'")
companies_harvard <- dbFetch(res, n=-1)
dbClearResult(res)

nrow(companies_harvard)

## Looking for companies with "Harvard" in the name returns over 1,000 results
## We can limit the reuslts to only include universities by specifying the naics_code (611310 is for universities)
res <- dbSendQuery(wrds, "SELECT * 
                   FROM revelio.company_mapping
                   WHERE company LIKE  '%Harvard%'
                   AND naics_code = '611310'")

universities_harvard <- dbFetch(res, n=-1)
dbClearResult(res)

nrow(universities_harvard)

