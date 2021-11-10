zika_report: Rmd/Zika_Report.Rmd Output/maternal_table.png Output/infant_table.png
	Rscript -e "rmarkdown::render('Rmd/Zika_Report.Rmd')"

Output/maternal_table.png: R/Zika_Tables.R
	Rscript R/Zika_Tables.R

Output/infant_table.png: R/Zika_Tables.R
	Rscript R/Zika_Tables.R

.PHONY: zika_report