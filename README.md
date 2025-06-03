# Querying Data from Revelio in WRDS Using R

## I. Overview
### About
Subscribers to Revelio Labs on WRDS can extract data on user profiles, companies, and job postings to LinkedIn both through the WRDS website and programatically through R.
This repository contains sample code and explanations on how to extract Revelio data. 

### Useful Overview Sources
[Querying data from WRDS in R](https://wrds-www.wharton.upenn.edu/pages/support/programming-wrds/programming-r/advanced-topics-in-r/querying-wrds-data-r/)

[Information about Revelio on WRDS](https://wrds-www.wharton.upenn.edu/pages/about/data-vendors/revelio-labs/)

[General Information about Revelio](https://www.data-dictionary.reveliolabs.com/data.html)

[Revelio Data Dictionary](https://www.data-dictionary.reveliolabs.com/)


# II. Connecting to WRDS and Set Up 
The file SetConnection.R loads required libraries and establishes a connection with WRDS to allow you to extract data using SQL queries. 
SetConnection pulls username and password data from the file LogOn/Credentials.csv.  Make sure to update this file with your username and password.
For more information, see the [LogOn folder] (https://github.com/hbs-brds/wrds_revelio/tree/main/LogOn)


# III. Queries 
The [Sample Queries](https://github.com/hbs-brds/wrds_revelio/tree/main/Sample%20Queries) folder contains sample scripts for pulling data from WRDS. They all being by calling the SetConnection.R file. 
The file [MetaData](https://github.com/hbs-brds/wrds_revelio/blob/main/Sample%20Queries/MetaData.R] is a good starting point. It demonstrates how to pull names of tables in the Revelio database in WRDS and creates an Excel codebook that lists table names and provides 20 sample rows for each table in the database. 



