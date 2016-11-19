FROM rocker/r-base

MAINTAINER mike morris "mike.morris89@github.com"

# system libraries of general use
RUN apt-get update
#RUN apt-get install -y aptitude
RUN apt-get install -y apt-utils
#RUN aptitude update
RUN apt-get install -y	default-jdk
#RUN aptitude install -y sudo 
#RUN aptitude install -y	gdebi-core	 
#RUN aptitude install -y	pandoc 
#RUN aptitude install -y	pandoc-citeproc  
#RUN apt-get install -y	software-properties-common
#RUN apt-get install -y	curl/Stable
RUN apt-get install -y	libssl-dev 
RUN apt-get install -y	libxml2-dev	
RUN apt-get install -y libcurl3-gnutls=7.50.1-1
RUN apt-get install -y	libcurl4-openssl-dev 

# basic shiny functionality
RUN R -e "install.packages('shiny', repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('rmarkdown',repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('stringr', repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('googleVis', repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('RJDBC', repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('RJSONIO', repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('RSQLite', repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('devtools', repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('testthat', repos='https://cloud.r-project.org/')"
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



