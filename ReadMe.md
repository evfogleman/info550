## Directions to successfully run project code

The data used in this project were simulated from an observational Zika virus study.

All packages required to run the program successfully are found within the docker container, and do not need to installed by you separately. They will install once you execute the analysis. R packages include sas7bdat, dplyr, table1 and ggplot2. _Please note, you will not need to fork anything from GitHub._

In order to execute the analysis, first navigate to a local directory empty folder of your choosing (ensure there are no other Dockerfiles or renv files) within wsl. Then you will need to pull my docker image by running the following code (being sure to use the V6 tag):

```bash
docker pull evfogleman/info550_project:V6
```
Then create a folder titled 'Output' in your local directory using the following code:

```bash
mkdir Output
```
Next, excute the following code to compile the analysis and output:

```bash
docker run -v /_local_path_/Output:/project/Output evfogleman/info550_project:V6
```
# Please include your full absolute path (instead of relative path ~/Output) since only the full path will mount correctly.

You should expect to see an html markdown file as your output titled 'Zika_Report.html' in the Output folder, which will contain two tables.
