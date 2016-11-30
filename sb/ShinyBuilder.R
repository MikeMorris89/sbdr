# Copyright (c) 2014 Clear Channel Broadcasting, Inc. 
# https://github.com/iheartradio/ShinyBuilder
# Licensed under the MIT License (MIT)

#` Run ShinyBuilder
#'
#' Run an instance of ShinyBuilder
#' @export
runShinyBuilder <- function(sb_dir){
  #sb_dir <- system.file(package = 'ShinyBuilder')
  
  #Check/set permissions
  dir_mode <- as.numeric(as.character(file.info(paste0(sb_dir, '/dashboards'))$mode))
  if(dir_mode < 755) Sys.chmod(sb_dir, mode = "0755")
  
  shiny::runApp(sb_dir)
}

#' Deploy ShinyBuilder to a specified directory
#' 
#' Deploy ShinyBuilder app (ui.R, server.R, global.R) to a specified directory. 
#' Useful for copying ShinyBuilder to a Shiny Server directory from which it will be served.
#' Note that regardless of its deploy location, the app will use the ShinyBuilder library
#' location for saving/loading dashboards, databases, and config files.
#' @param dir directory to which ShinyBuilder app is deployed
#' @param update logical value indicating whether ShinyBuilder dashboards should be periodically updated by re-running the queries.  True by default.
#' @param times vector specifying update schedule in crontab format (i.e., minute (0-59), hour (0-23), day of month (1-31), month (1-12), day of week (0-6, Sun = 6)).  Defaults to daily updates at 12:00 AM.
#' @examples
#' \dontrun{deployShinyBuilder(dir = '/srv/shiny-server/ShinyBuilder')}
#' @export
deployShinyBuilder <- function(dir, update = T, times = c(0, 0, '*', '*', '*'),sb_dir){
  #Copy files
  #sb_dir <- system.file(package = 'ShinyBuilder')
  if(!file.exists(dir)) dir.create(dir, mode = '0755')
  if(substr(dir, nchar(dir), nchar(dir)) != '/') dir <- paste0(dir, '/')
  file.copy(from = paste0(sb_dir, '/', c('server.R', 'ui.R', 'global.R')), to = paste0(dir, c('server.R', 'ui.R', 'global.R')), overwrite = T)
  
  #Check/set permissions
  dir_mode <- as.numeric(as.character(file.info(paste0(sb_dir, '/dashboards'))$mode))
  if(dir_mode < 755) Sys.chmod(sb_dir, mode = "0755")
  
  #Crontabs
  cron_script   <- paste("Rscript -e 'ShinyBuilder::updateDashboards(",sb_dir,")'",sep='')
  crontabs      <- try(system('crontab -l', intern = T), silent = T)
  script_index  <- grep(cron_script, crontabs, fixed = T)
  if(length(script_index) == 0) script_index <- length(crontabs) + 1
  ifelse(update,
         crontabs[script_index] <- paste(paste(times, collapse = ' '), cron_script),
         crontabs <- crontabs[-script_index])
  
  #Write out crontabs
  write.table(crontabs, '/tmp/sb_crontabs.csv', row.names = F, col.names = F, quote = F)
  system('crontab < /tmp/sb_crontabs.csv')
  
  message(paste0('ShinyBuilder deployed successfully. Autoupdate: ', ifelse(update, 'ON', 'OFF')))
}

# Copyright (c) 2014 Clear Channel Broadcasting, Inc. 
# https://github.com/iheartradio/ShinyBuilder
# Licensed under the MIT License (MIT)

#' Initialize connections in db list
#' 
#' Load db list from file, initializing connections to all included databases.
#' @return an initialized db_list object
#' @examples
#' \dontrun{db_list <- dbListInit()}
#' @export
dbListInit <- function(sb_dir){
  #sb_dir <- system.file(package = 'ShinyBuilder')
  load(file = paste0(sb_dir,'/data/db_list.RData'))
  lapply(db_list, function(x){x$db <- eval(x$db); x})
}

#' Add new database to db list
#' 
#' Adds a new database to db list.
#' @param db_name name of the database to be added
#' @param db an expression yielding a db connection object
#' @param query_fn function used to query the database. 
#' @param default_query the default query to use for this connection.  
#' @examples
#' \dontrun{
#' db <- quote({dbConnect(dbDriver('SQLite'), dbname = system.file('data/births.db', package = 'ShinyBuilder'))})
#' dbListAdd(db_name = 'SQLite Database', db = db, query_fn = RJDBC::dbGetQuery, default_query = 'SELECT * FROM births')}
#' @export
dbListAdd <- function(db_name, db, query_fn, default_query,sb_dir){
  #sb_dir <- system.file(package = 'ShinyBuilder')
  load(file = paste0(sb_dir, '/data/db_list.RData'))
  db_list[[db_name]] <- list(
    db = db,
    query_fn = query_fn,
    default_query = default_query)
  save(db_list, file = paste0(sb_dir,'/data/db_list.RData'))
}

#' Remove a database from db list
#' 
#' Removes a database from db_list.
#' @param db_name name of the database to be removed
#' @export
dbListRemove <- function(db_name,sb_dir){
  #sb_dir <- system.file(package = 'ShinyBuilder')
  load(file = paste0(sb_dir, '/data/db_list.RData'))
  db_list[[db_name]] <- NULL
  save(db_list, file = paste0(sb_dir,'/data/db_list.RData'))
}

#' Print the current contents of db list
#' 
#' Print the current contents of db list.
#' @export
dbListPrint <- function(sb_dir){
  #sb_dir <- system.file(package = 'ShinyBuilder')
  load(file = paste0(sb_dir, '/data/db_list.RData'))
  print(db_list)
}

#Code to Initialize sample_db
# births    <- read.csv(paste0(getwd(),'/data/births.csv'))
# sample_db <- dbConnect(dbDriver('SQLite'), dbname = paste0(getwd(),'/data/births.db'))
# dbWriteTable(sample_db, 'births', births)
# dbGetQuery(sample_db, 'SELECT * FROM births LIMIT 5')
# dbDisconnect(sample_db)

# Copyright (c) 2014 Clear Channel Broadcasting, Inc. 
# https://github.com/iheartradio/ShinyBuilder
# Licensed under the MIT License (MIT)

#' Update All Dashboards
#' 
#' @param dashboards a vector of dashboard names.  By default, all dashboards in the dashboards directory are updated
#' @export 
#' @examples
#' \dontrun{
#' #All Dashboards
#' updateDashboards()
#' #Selected dashboards
#' updeateDashboards(c('dashboard_1', 'dashboard_2'))
#' }
updateDashboards <- function(dashboards = NULL,sb_dir){
  
  #sb_dir <- system.file('dashboards', package = 'ShinyBuilder')
  
  #Check/set permissions
  Sys.chmod(sb_dir, mode = "0755")
  
  if(is.null(dashboards)) 
    dashboards <- list.files(path = sb_dir, full.names = T)
  
  db_list <- dbListInit()
  print(db_list)
  
  for (dashboard_file in dashboards){
    #Load current dashboard
    load(dashboard_file)
    print(paste0('Updating: ', dashboard_file))
    
    #Update chart data
    for (i in 1:length(dashboard_state)){
      if(grepl('gItemPlot', dashboard_state[[i]]$id)){
        input_query               <- dashboard_state[[i]]$query
        db_obj                    <- db_list[[dashboard_state[[i]]$db_name]]
        tryCatch(
          {
            dashboard_state[[i]]$data <- do.call(db_obj$query_fn, list(db_obj$db, input_query))
          },
          error=function(cond) {
            message("Dashboard threw an error updating:")
            message(cond)
          },
          warnng=function(cond) {
            message("Dashboard threw a warning updating:")
            message(cond)
          }
        )
        #dashboard_state[[i]]$data <- do.call(db_obj$query_fn, list(db_obj$db, input_query))
      }
    }
    #Save current dashboard
    save(dashboard_state, file = dashboard_file)
  }
}