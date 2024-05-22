# Week 6 Who Are the Winners

# Load important libraries 
library(DBI)
library(duckdb)
library(dplyr)
library(dbplyr)

# Conencting to duckdb
conn <- DBI::dbConnect(duckdb::duckdb(), dbdir = "/Users/katebecker/Documents/Bren/Spring/213-relational/week3/bren-meds213-spring-2024-class-data/week3/database.db")

# Loading tables
DBI::dbListTables(conn)

# Loading the Bird_eggs, Bird_nests, and Personnel 
egg_table <- tbl(conn, "Bird_eggs")
nest_table <- tbl(conn, "Bird_nests")
personnel_table <- tbl(conn, "Personnel")

# Checking the column names
colnames(egg_table)
colnames(nest_table)
colnames(personnel_table)

# Joining Bird_eggs with Bird_nests 
eggs_with_observers <- egg_table %>%
  inner_join(nest_table, by = "Nest_ID")

# Computed eggs measured by each observer and retrieving the top three using head(n =3)
top_observers <- eggs_with_observers %>%
  group_by(Observer) %>%
  summarize(total_eggs = n(), .groups = 'drop') %>%
  inner_join(personnel_table, by = c("Observer" = "Abbreviation")) %>%
  select(Name, total_eggs) %>%
  arrange(desc(total_eggs)) %>%
  head(n = 3)

# Results
top_observers %>%
  show_query()

# Dbplyr did everything in one SQL query
# Using head(n =3) translates this to an SQL LIMIT clause

# Disconnected
dbDisconnect(conn, shutdown = TRUE)
