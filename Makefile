.PHONY: install clean version compile blog notebook

install: requirements.txt
	virtualenv --python=python3.7 venv
	. venv/bin/activate; pip install -U pip
	. venv/bin/activate; pip install -Ur requirements.txt

clean:
	rm -rf venv

version:
	. venv/bin/activate; python -c 'import plotnine; print(plotnine.__version__)'

compile:
	bin/compile.sh

blog:
	bin/blog.sh

notebook:
	. venv/bin/activate; bin/notebook.sh
