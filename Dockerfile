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

# Run the script to deactivate the renv file used in the prior HW
RUN Rscript -e "renv::deactivate()"

# make R scripts executable
#RUN chmod +x /project/R/*.R

# Set entry point (make container entry point bash)
#CMD make zika_report
CMD /bin/bash