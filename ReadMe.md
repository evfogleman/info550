##Directions to successfully run project code

The data used in this project were simulated from an observational Zika virus study.

All packages required to run the program successfully are found at the top of the R script, but do not need to installed by you separately. They will install once you execute the analysis if not already installed. R packages include sas7bdat, dplyr, table1 and ggplot2.

In order to execute the analysis, please first fork my repository within GitHub at the following link: https://github.com/evfogleman/info550. Then open WLS and clone your own version of my repository by running the following example code:

```bash
git clone https://github.com/_yourusername_/peerreview
```

Then you can execute the analysis by running the following code:

```bash
make zika_report
```

You should expect to see an html markdown file as your output titled 'Zika_Report.html', which will contain two tables.
