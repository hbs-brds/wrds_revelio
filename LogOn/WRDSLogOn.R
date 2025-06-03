## Log into WRDS
wrds <- dbConnect(Postgres(),
                  host='wrds-pgdata.wharton.upenn.edu',
                  port=9737,
                  dbname='wrds',
                  sslmode='require',
                  user='YOUR_USERNAME',  #Update to your username
                  password='YOUR_PASSWORD') #Update to your password