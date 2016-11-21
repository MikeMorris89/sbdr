version 

remove.packages('shiny')
remove.packages('devtools')
install.packages('devtools',dep=T)
install.packages('shiny',dep=T)
install.packages('stringr',dep=T)
install.packages('googleVis',dep=T)
install.packages('shinyGoogleCharts',dep=T)
install.packages('rJava',dep=T)
install.packages('RJDBC',dep=T)
install.packages('RJSONIO',dep=T)
install.packages('RSQLite',dep=T)
install.packages('shinyAce',dep=T)

remove.packages('ShinyBuilder')

devtools::install_github("mikemorris89/shinyMCE")
devtools::install_github("shinyGoogleCharts", "mul118")
devtools::install_github("mikemorris89/shinyGridster")
devtools::install_github("mikemorris89/ShinyBuilder")

str(db_list$SQLite$db)

head(db_list)

#getwd()
#setwd('/home/rstudio/ShinyApps/ShinyBuilder')
dbListInit <- function(){
  sb_dir <- system.file(package = 'ShinyBuilder')
  load(file = '/home/rstudio/ShinyApps/ShinyBuilder/inst/data/db_list-orig.RData')
  lapply(db_list, function(x){x$db <- eval(x$db); x})
}
db_list <- dbListInit()

dbListAdd <- function(db_name, db, query_fn, default_query){
  load(file = '/home/rstudio/ShinyApps/ShinyBuilder/inst/data/db_list.RData')
  db_list[[db_name]] <- list(
    db = db,
    query_fn = query_fn,
    default_query = default_query)
  save(db_list, file = '/home/rstudio/ShinyApps/ShinyBuilder/inst/data/db_list.RData')
}


###################################################
#Code to Initialize sample_db
###################################################
births    <- read.csv(paste0(getwd(),'/data/births.csv'))
sample_db <- dbConnect(dbDriver('SQLite'), dbname = paste0(getwd(),'/data/births.db'))
dbWriteTable(sample_db, 'births', births)
dbGetQuery(sample_db, 'SELECT * FROM births LIMIT 5')
dbDisconnect(sample_db)

SacramentocrimeJanuary2006    <- read.csv(paste0(getwd(),'/data/SacramentocrimeJanuary2006.csv'))
sample_db <- dbConnect(dbDriver('SQLite'), dbname = paste0(getwd(),'/data/SacramentocrimeJanuary2006.db'))
dbWriteTable(sample_db, 'SacramentocrimeJanuary2006', SacramentocrimeJanuary2006)
dbGetQuery(sample_db, 'SELECT * FROM SacramentocrimeJanuary2006 LIMIT 5')
dbDisconnect(sample_db)

Sacramentorealestatetransactions    <- read.csv(paste0(getwd(),'/data/Sacramentorealestatetransactions.csv'))
sample_db <- dbConnect(dbDriver('SQLite'), dbname = paste0(getwd(),'/data/Sacramentorealestatetransactions.db'))
dbWriteTable(sample_db, 'Sacramentorealestatetransactions', Sacramentorealestatetransactions)
dbGetQuery(sample_db, 'SELECT * FROM Sacramentorealestatetransactions LIMIT 5')
dbDisconnect(sample_db)

SalesJan2009    <- read.csv(paste0(getwd(),'/data/SalesJan2009.csv'))
sample_db <- dbConnect(dbDriver('SQLite'), dbname = paste0(getwd(),'/data/SalesJan2009.db'))
dbWriteTable(sample_db, 'SalesJan2009', SalesJan2009)
dbGetQuery(sample_db, 'SELECT * FROM SalesJan2009 LIMIT 5')
dbDisconnect(sample_db)


TechCrunchcontinentalUSA    <- read.csv(paste0(getwd(),'/data/TechCrunchcontinentalUSA.csv'))
sample_db <- dbConnect(dbDriver('SQLite'), dbname = paste0(getwd(),'/data/TechCrunchcontinentalUSA.db'))
dbWriteTable(sample_db, 'TechCrunchcontinentalUSA', TechCrunchcontinentalUSA)
dbGetQuery(sample_db, 'SELECT * FROM TechCrunchcontinentalUSA LIMIT 5')
dbDisconnect(sample_db)


FL_insurance_sample
FL_insurance_sample    <- read.csv(paste0(getwd(),'/data/FL_insurance_sample.csv'))
sample_db <- dbConnect(dbDriver('SQLite'), dbname = paste0(getwd(),'/data/FL_insurance_sample.db'))
dbWriteTable(sample_db, 'FL_insurance_sample', FL_insurance_sample)
dbGetQuery(sample_db, 'SELECT * FROM FL_insurance_sample LIMIT 5')
dbDisconnect(sample_db)

###################################################
#Create db list
###################################################


#db <- quote({dbConnect(dbDriver('SQLite'), dbname = system.file('data/births.db', package = 'ShinyBuilder'))})
#dbListAdd1(db_name = 'SQLite Database', db = db, query_fn = RJDBC::dbGetQuery, default_query = 'SELECT * FROM births')

db_list <- dbListInit()

db <- quote({dbConnect(dbDriver('SQLite'), dbname = system.file('data/FL_insurance_sample.db', package = 'ShinyBuilder'))})
dbListAdd(db_name = 'Spatial key - FL insurance sample', db = db, query_fn = RJDBC::dbGetQuery, 
default_query = 'SELECT * FROM FL_insurance_sample LIMIT 5')

db <- quote({dbConnect(dbDriver('SQLite'), dbname = system.file('data/SacramentocrimeJanuary2006.db', package = 'ShinyBuilder'))})
dbListAdd(db_name = 'Spatial key - Sacramento crime January2006', db = db, query_fn = RJDBC::dbGetQuery, 
          default_query = 'SELECT * FROM SacramentocrimeJanuary2006 LIMIT 5')

db <- quote({dbConnect(dbDriver('SQLite'), dbname = system.file('data/Sacramentorealestatetransactions', package = 'ShinyBuilder'))})
dbListAdd(db_name = 'Spatial key - Sacramento realestate transactions', db = db, query_fn = RJDBC::dbGetQuery, 
          default_query = 'SELECT * FROM Sacramentorealestatetransactions LIMIT 5')

db <- quote({dbConnect(dbDriver('SQLite'), dbname = system.file('data/SalesJan2009', package = 'ShinyBuilder'))})
dbListAdd(db_name = 'Spatial key - Sales Jan 2009', db = db, query_fn = RJDBC::dbGetQuery, 
          default_query = 'SELECT * FROM SalesJan2009 LIMIT 5')

db <- quote({dbConnect(dbDriver('SQLite'), dbname = system.file('data/TechCrunchcontinentalUSA', package = 'ShinyBuilder'))})
dbListAdd(db_name = 'Spatial key - Tech Crunchcontinental USA', db = db, query_fn = RJDBC::dbGetQuery, 
          default_query = 'SELECT * FROM TechCrunchcontinentalUSA LIMIT 5')

db <- quote({dbConnect(dbDriver('SQLite'), dbname = system.file('data/chinook.db', package = 'ShinyBuilder'))})
dbListAdd(db_name = 'SQLite Sample Database', db = db, query_fn = RJDBC::dbGetQuery, default_query = 'SELECT
          artists.ArtistId,
          albumId
          FROM
          artists
          LEFT JOIN albums ON albums.artistid = artists.artistid
          WHERE
          albumid IS NULL;')

