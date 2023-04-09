FROM rocker/shiny-verse:latest
USER root

RUN R -e 'install.packages("devtools")'
RUN R -e 'devtools::install_version("shiny", version = "1.6.0", dependencies= T)'  
RUN R -e 'devtools::install_version("ggplot2", version = "3.3.2", dependencies= T)'
RUN R -e 'devtools::install_version("plotly")' 
RUN R -e 'devtools::install_version("dplyr", version = "1.0.0", dependencies= T)'

COPY ./www/ /shiny/dashboard/www/
COPY app.R /shiny/dashboard/

EXPOSE 3838

CMD R -e 'shiny::runApp("/shiny/dashboard", port = 3838, host = "127.0.0.1")'