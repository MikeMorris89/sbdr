FROM rocker/r-ver:3.1.0

MAINTAINER mike morris "mike.morris89@github.com"

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0x219BD9C9
RUN echo "deb http://repos.azulsystems.com/ubuntu `lsb_release -cs` main" >> /etc/apt/sources.list.d/zulu.list
RUN apt-get update
RUN apt-get -y install zulu-7=7.4.0.5

RUN apt-get install -y --no-install-recommends --allow-downgrades \
	apt-utils \
	libssl-dev \
	libxml2-dev \
	libcurl3=7.50.1-1 \
	libcurl4-openssl-dev \
	&& rm -rf /var/lib/apt/lists/*

# basic shiny functionality
RUN R -e "install.packages(c('shiny','rmarkdown' ,'stringr','googleVis','rJava','shinyAce','RJDBC','RJSONIO','RSQLite','devtools','testthat','shinyGoogleCharts'),dep=T)" \
    && R -e 'devtools::install_github("mikemorris89/shinyMCE")' \
    && R -e 'devtools::install_github("mikemorris89/shinyGridster")' \
    && R -e 'devtools::install_github("mikemorris89/ShinyBuilder")' \
    && R -e 'remove.packages("devtools")'



# copy the app to the image
RUN mkdir /root/sb
COPY ShinyBuilder /root/sb

COPY Rprofile.site /usr/lib/R/etc/

RUN mkdir /srv/shiny-server
RUN mkdir /srv/shiny-server/ShinyBuilder
VOLUME /srv/shiny-server/ShinyBuilder

EXPOSE 3838

CMD ["R", "-e ShinyBuilder::runShinyBuilder()"]
#CMD ["R", "-e deployShinyBuilder(dir = '/srv/shiny-server/ShinyBuilder')"]



