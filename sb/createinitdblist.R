db_list <- list()
save(db_list, file = paste0(sb_dir,'/data/db_list.RData'))

db <- quote({dbConnect(dbDriver('SQLite'), dbname = system.file('data/births.db', package = 'ShinyBuilder'))})
dbListAdd(db_name = 'SQLite Database', db = db, query_fn = RJDBC::dbGetQuery, default_query = 'SELECT * FROM births',sb_dir)

db <- quote({dbConnect(dbDriver('SQLite'), dbname = system.file('data/FL_insurance_sample.db', package = 'ShinyBuilder'))})
dbListAdd(db_name = 'Spatial key - FL insurance sample', db = db, query_fn = RJDBC::dbGetQuery, 
          default_query = 'SELECT * FROM FL_insurance_sample LIMIT 5',sb_dir)

db <- quote({dbConnect(dbDriver('SQLite'), dbname = system.file('data/SacramentocrimeJanuary2006.db', package = 'ShinyBuilder'))})
dbListAdd(db_name = 'Spatial key - Sacramento crime January2006', db = db, query_fn = RJDBC::dbGetQuery, 
          default_query = 'SELECT * FROM SacramentocrimeJanuary2006 LIMIT 5',sb_dir)

db <- quote({dbConnect(dbDriver('SQLite'), dbname = system.file('data/Sacramentorealestatetransactions.db', package = 'ShinyBuilder'))})
dbListAdd(db_name = 'Spatial key - Sacramento realestate transactions', db = db, query_fn = RJDBC::dbGetQuery, 
          default_query = 'SELECT * FROM Sacramentorealestatetransactions LIMIT 5',sb_dir)

db <- quote({dbConnect(dbDriver('SQLite'), dbname = system.file('data/SalesJan2009.db', package = 'ShinyBuilder'))})
dbListAdd(db_name = 'Spatial key - Sales Jan 2009', db = db, query_fn = RJDBC::dbGetQuery, 
          default_query = 'SELECT * FROM SalesJan2009 LIMIT 5',sb_dir)

db <- quote({dbConnect(dbDriver('SQLite'), dbname = system.file('data/TechCrunchcontinentalUSA.db', package = 'ShinyBuilder'))})
dbListAdd(db_name = 'Spatial key - Tech Crunchcontinental USA', db = db, query_fn = RJDBC::dbGetQuery, 
          default_query = 'SELECT * FROM TechCrunchcontinentalUSA LIMIT 5',sb_dir)

db <- quote({dbConnect(dbDriver('SQLite'), dbname = system.file('data/chinook.db', package = 'ShinyBuilder'))})
dbListAdd(db_name = 'SQLite Sample Database', db = db, query_fn = RJDBC::dbGetQuery, default_query = 'SELECT
          artists.ArtistId,
          albumId
          FROM
          artists
          LEFT JOIN albums ON albums.artistid = artists.artistid
          WHERE
          albumid IS NULL;',sb_dir)

