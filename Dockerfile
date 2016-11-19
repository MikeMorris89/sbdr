FROM rocker/r-base

MAINTAINER mike morris "mike.morris89@github.com"

# system libraries of general use
RUN apt-get update && apt-get install -y \
	default-jdk 
RUN apt-get update && apt-get -f install -y \
        sudo 
RUN apt-get update && apt-get -f install -y \
	pandoc 
RUN apt-get update && apt-get -f install -y \
	pandoc-citeproc  
RUN apt-get update && apt-get -f install -y \
	libssl-dev 
RUN apt-get update && apt-get -f install -y \
	libxml2-dev	
RUN apt-get update && apt-get -f install -y \
	libcurl4-openssl-dev 

# basic shiny functionality
RUN R -e "install.packages('shiny', repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('rmarkdown',repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('stringr',dep=T, repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('googleVis',dep=T, repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('RJDBC',dep=T, repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('RJSONIO',dep=T, repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('RSQLite',dep=T, repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('devtools', dep=T, repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('testthat',dep=T, repos='https://cloud.r-project.org/')"
RUN R -e 'devtools::install_github("mul118/shinyMCE")'
RUN R -e 'devtools::install_github("mul118/shinyGridster")'
RUN R -e 'devtools::install_github("iheartradio/ShinyBuilder")'


# copy the app to the image
RUN mkdir /root/sb
COPY ShinyBuilder /root/sb

COPY Rprofile.site /usr/lib/R/etc/

RUN mkdir /srv/shiny-server/ShinyBuilder
VOLUME /srv/shiny-server/ShinyBuilder

EXPOSE 3838

#CMD ["R", "-e ShinyBuilder::runShinyBuilder()"]
CMD ["R", "-e deployShinyBuilder(dir = '/srv/shiny-server/ShinyBuilder')"]



