FROM rocker/r-base

MAINTAINER mike morris "mike.morris89@github.com"

# system libraries of general use
RUN apt-get update  -qq \
 && apt-get upgrade -y

RUN apt-get install -y --no-install-recommends --allow-downgrades \
	apt-utils \
	default-jdk \
	libssl-dev \
	libxml2-dev \
	libcurl3=7.50.1-1 \
	libcurl4-openssl-dev \
	&& rm -rf /var/lib/apt/lists/*

# basic shiny functionality
RUN R -e "install.packages('shiny' \
	,'rmarkdown' \
	,'stringr' \
	,'googleVis' \
	,'RJDBC' \
	,'RJSONIO' \
	,'RSQLite' \
	,'devtools' \
	,'testthat', repos='https://cloud.r-project.org/')" \
    && R -e 'devtools::install_github("mul118/shinyMCE")' \
    && R -e 'devtools::install_github("mul118/shinyGridster")' \
    && R -e 'devtools::install_github("iheartradio/ShinyBuilder")' \
    && R -e 'remove.packages("devtools")'

# copy the app to the image
RUN mkdir /root/sb
COPY ShinyBuilder /root/sb

COPY Rprofile.site /usr/lib/R/etc/

RUN mkdir /srv/shiny-server
RUN mkdir /srv/shiny-server/ShinyBuilder
VOLUME /srv/shiny-server/ShinyBuilder

EXPOSE 3838

#CMD ["R", "-e ShinyBuilder::runShinyBuilder()"]
CMD ["R", "-e deployShinyBuilder(dir = '/srv/shiny-server/ShinyBuilder')"]



