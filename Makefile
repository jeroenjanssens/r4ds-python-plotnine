.PHONY: clean active test

install: venv requirements.txt
	. venv/bin/activate; pip install -U pip
	. venv/bin/activate; pip install -Ur requirements.txt

clean:
	rm -rf venv

venv:
	virtualenv --python=python3.7 venv

active:
	. venv/bin/activate

test:
	. venv/bin/activate; python -c 'import plotnine; print(plotnine.__version__)'
