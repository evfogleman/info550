# Use docker container for R environment
FROM rocker/tidyverse

# Install R packages needed for analysis
RUN Rscript -e "install.packages('sas7bdat')"
RUN Rscript -e "install.packages('table1')"
RUN Rscript -e "install.packages('here')"

# Make a project directory in the container to use to mount local directory to
RUN mkdir /project

# Copy contents of local folder to project folder in container (. means copy everything)
COPY ./ /project/

# Set the working directory
WORKDIR /project

# Set entry point (make container entry point bash)
CMD make zika_report
