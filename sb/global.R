# Copyright (c) 2014 Clear Channel Broadcasting, Inc. 
# https://github.com/iheartradio/ShinyBuilder
# Licensed under the MIT License (MIT)
#install.packages('shinybootstrap2')
#install.packages('googleVis')
#remove.packages('googleVis')
options(shiny.fullstacktrace = TRUE)
#---------
#Libraries
#---------
library(stringr)
#library(googleVis)
#library(RJDBC)
library(RJSONIO)
library(RSQLite)
library(shinyAce)
library(shinyMCE)
library(shinyGridster)
#library(ShinyBuilder)

#source(system.file('googleChart.R', package = 'ShinyBuilder'))
source('googleChart.R')
source('ShinyBuilder.R')

#Shinybuilder directory
sb_dir <- system.file('', package = 'ShinyBuilder')
sb_dir<- paste(getwd(),'/',sep='')

#DB list
db_list <- dbListInit(sb_dir)

#Available dashboards
available_dashboards <- str_replace(list.files(path = str_c(sb_dir,'dashboards')), '.RData', '')





