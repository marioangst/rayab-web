# Base R Shiny image
FROM rocker/shiny

# Make a directory in the container
RUN mkdir /home/shiny-app

# Install magick dependency
RUN apt-get update && apt-get install -y libmagick++-dev
RUN R -e "install.packages('magick')"

# Install libarchive dependency
RUN apt-get install -y libarchive-dev

# Install R dependencies
# RUN R -e "install.packages(c('dplyr', 'ggplot2', 'gapminder'))"
## manage packages via renv ------------
ENV RENV_VERSION 1.0.11
RUN R -e "install.packages('renv')"
ENV RENV_PATHS_LIBRARY renv/library
WORKDIR /home/shiny-app
# copy over the renv.lock file
COPY renv.lock renv.lock
# use the copied renv.lock file to set up the correct R libraries in the directory
RUN R -e "renv::init();renv::restore()"

# Copy the Shiny app code
COPY app/app.R /home/shiny-app/app.R

# Expose the application port
EXPOSE 3000

# Run the R Shiny app
CMD Rscript /home/shiny-app/app.R
