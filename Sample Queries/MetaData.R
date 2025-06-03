"
Program: MetaDataQuery
Purpose: Pull Information on Tables in the WRDS Revelio Database, save to excel file.
          This program creates a codebook where the first sheet is a list of tables
          in the database and the following sheets are sample rows from each table. 
          
          The code also shows how to pull information about tables from WRDS.
          
          For instructions on querying WRDS data using R see: 
          https://wrds-www.wharton.upenn.edu/pages/support/programming-wrds/programming-r/advanced-topics-in-r/querying-wrds-data-r/


Contact: BRDS@hbs.edu, https://www.library.hbs.edu/services/research-data-faculty-doctoral
June 2025
"
# --- I. Set Up ----
getwd()
source("SetConnection.R")


# --- II. Basic Meta Data Queries ---
## --- List of tables ----
res <- dbSendQuery(wrds, "SELECT distinct table_name
                   FROM information_schema.columns
                   WHERE table_schema='revelio'
                   ORDER by table_name")
tables <- dbFetch(res, n=-1)
dbClearResult(res)

tables


## --- See the variables (i.e column headers) within a given table ----
res <- dbSendQuery(wrds, "SELECT column_name 
                   FROM information_schema.columns
                   WHERE table_schema = 'revelio'
                   AND table_name = 'individual_user' 
                   ORDER BY column_name")
colheaders <- dbFetch(res, n=-1)
dbClearResult(res)
colheaders


## ---- Pull Sample rows from a table ----
res <- dbSendQuery(wrds, "SELECT * 
                   FROM revelio.individual_user
                   LIMIT 20")
samplerows <- dbFetch(res, n=-1)
dbClearResult(res)
samplerows



# ---- III. Create an Excel "Codebook" for this database ----
#(Pull Tables names and sample 10 rows from each table)

## ---- Pull sample rows from each table ----
for (table in tables$table_name) {
  res <- dbSendQuery(wrds, glue("SELECT * 
                   FROM revelio.{table}
                   LIMIT 20"))
  newtab <- dbFetch(res, n=-1)
  dbClearResult(res)
  
  assign(table, newtab)
}

## ---- Save List of Tables and sample rows to Excel Workbook ----
# Create a new workbook
wb <- createWorkbook()

# Add list of tables 
addWorksheet(wb, "List of Tables")
writeData(wb, "List of Tables", tables)

# Add each data frame as a new sheet with truncated names if needed
for (table in tables$table_name) {
  sheet_name <- substr(table, 1, 31)  # Truncate to max 31 chars
  addWorksheet(wb, sheet_name)
  writeData(wb, sheet_name, get(table))
}

# Save workbook
saveWorkbook(wb, "Output/Revelio_TableList.xlsx", overwrite = TRUE)




