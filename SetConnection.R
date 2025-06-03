"
Program: SetConnection.R
Purpose: Establish connection to WRDS database and load libraries needed

brds@hbs.edu
"


# ---- Libraries ----
library(dplyr)
library(janitor)
library(writexl)
library(readxl)
library(RPostgres)
library(glue)
library(readr)
library(openxlsx)


# ---- Log into WRDS ----
## Load Passwords from text file 
# Read the file
creds <- read.csv(r"(LogOn/Credentials.csv)", stringsAsFactors = FALSE)
username <- creds$username[1]
password <- creds$password[1]

##Note: your file should contain two columns, username and password.  The first row should be your user name and password.


# Log On
wrds <- dbConnect(Postgres(),
                  host='wrds-pgdata.wharton.upenn.edu',
                  port=9737,
                  dbname='wrds',
                  sslmode='require',
                  user= creds$username[1],  
                  password=creds$password[1]) 



