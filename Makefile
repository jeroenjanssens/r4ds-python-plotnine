.PHONY: install clean version knit notebook blogpost

RMD = input/plotnine.Rmd
MD = output/plotnine.md
IPYNB = notebook/r4ds-python-plotnine.ipynb

install: venv

venv: requirements.txt
	rm -rf venv
	virtualenv --python=python3.7 venv
	. venv/bin/activate; pip install -U pip
	. venv/bin/activate; pip install -Ur requirements.txt

clean:
	rm -rf venv

version:
	. venv/bin/activate; python -c 'import plotnine; print(plotnine.__version__)'

output/plotnine.md: $(RMD)
	bin/compile.sh

notebook/r4ds-python-plotnine.ipynb: $(RMD)
	. venv/bin/activate; bin/notebook.sh

knit: $(MD)

notebook: $(IPYNB)

blogpost: knit
	bin/blogpost.sh

