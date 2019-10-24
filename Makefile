.PHONY: install install-python install-r

INPUT = input/plotnine.Rmd
MD = output/r4ds-python-plotnine.blogpost.md
IPYNB = output/r4ds-python-plotnine.ipynb

install: install-python install-r

install-python: venv

install-r: renv

venv: requirements.txt
	rm -rf venv
	virtualenv --python=python3.7 venv
	. venv/bin/activate; pip install -U pip
	. venv/bin/activate; pip install -Ur requirements.txt
	. venv/bin/activate; python -m ipykernel install --user --name=r4ds-python-plotnine

renv: renv.lock
	Rscript --no-restore --no-save -e 'if (!requireNamespace("remotes")) install.packages("remotes"); remotes::install_github("rstudio/renv"); renv::restore()' 
	touch renv

$(MD): install-r $(INPUT)
	bin/compile.sh

$(IPYNB): install-python $(INPUT)
	. venv/bin/activate; bin/notebook.sh

lab:
	. venv/bin/activate; jupyter lab

knit: $(MD)

notebook: $(IPYNB)

blogpost: knit
	bin/blogpost.sh

