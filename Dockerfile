FROM rocker/r-base

MAINTAINER mike morris "mike.morris89@github.com"

# system libraries of general use
RUN apt-get update #&& apt-get install -y \

# basic shiny functionality
RUN R -e "install.packages('shiny', repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('rmarkdown', repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('rmarkdown', repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('rmarkdown', repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('rmarkdown', repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('devtools', repos='https://cloud.r-project.org/')"
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



