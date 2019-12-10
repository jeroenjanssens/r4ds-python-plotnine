.PHONY: clean rmd ipynb blogpost lab anchors
.SUFFIXES:

.ONESHELL:
SHELL = /usr/bin/env bash -o pipefail
.SHELLFLAGS = -e

NAME = r4ds-python-plotnine

# SLUG, SITE, and POST are only used to produce the blog post at datascienceworkshops.com 
SLUG = plotnine-grammar-of-graphics-for-python
SITE = ~/repos/mine/dsw-com
POST = $(SITE)/content/_posts/$(shell date +'%Y-%m-%d')-$(SLUG).md

output:
	mkdir -p $@

venv: requirements.txt
	rm -rf venv
	virtualenv --python=python3.7 venv
	. venv/bin/activate; \
	pip install -U pip; \
	pip install -Ur requirements.txt; \
	python -m ipykernel install --user --name=$(NAME) # install kernelspec

renv/library: renv.lock
	Rscript --vanilla -e 'if (!requireNamespace("renv")) install.packages("renv"); renv::restore()' 
	touch $@
	
clean:
	rm -rf output

output/$(NAME).ipynb: input/$(NAME).ipynb.Rmd output venv # compile to a Jupyter notebook
	. venv/bin/activate; \
	< $< sed -e '/^---$$/,/^---$$/d;/```{r/,/```/d;/TODO/d' | \
	sed -e '/<!-- START_HIDE_IPYNB -->/,/<!-- END_HIDE_IPYNB -->/d' | \
	sed -e '/_HIDE_MD/d' | \
	sed -e '/START_COMMENT/,/END_COMMENT/d' | \
	awk -f input/footnotes.awk | \
	cat -s | \
	sed -re 's/\[\^([0-9+])\]: (.*)$$/<span id="fn:\1">\1\. \2<\/span>\n/' | \
	sed -re 's/\[\^([0-9+])\]/[<sup>\1<\/sup>](#fn:\1)/g' | \
	jupytext --from rmarkdown --to notebook --set-kernel $(NAME) --execute > $@

output/$(NAME).div.Rmd: input/$(NAME).ipynb.Rmd output # remove lines not meant for R markdown
	< $< sed -e '/<!-- START_HIDE_MD -->/,/<!-- END_HIDE_MD -->/d' | \
	sed -e '/_HIDE_IPYNB/d' | \
	sed -e '/START_COMMENT/,/END_COMMENT/d' | \
	awk -f input/footnotes.awk > $@

output/$(NAME).Rmd: output/$(NAME).div.Rmd # remove divs and extra yaml as they're only used by the blog post
	< $< sed -re '/^tagline:/i ---' | \
	sed -re '/^tagline:/,/^---/d;/<\/?div/d;s/ class="[^"]"//g' > $@

output/$(NAME).blog.md: output/$(NAME).div.Rmd venv renv/library
	Rscript --vanilla -e 'source("renv/activate.R"); knitr::knit("$<", "$@")'
	
$(POST): output/$(NAME).blog.md $(SITE)/content/_posts $(SITE)/assets/img/blog
	rm -f $(SITE)/content/_posts/*-$(SLUG).md
	mkdir -p $(SITE)/assets/img/blog/$(SLUG)/
	rm -rf $(SITE)/assets/img/blog/$(SLUG)/*
	cp output/figure/* $(SITE)/assets/img/blog/$(SLUG)/
	cp input/images/* $(SITE)/assets/img/blog/$(SLUG)/
	cat $< | \
	sed 's/ alt="[^"]*"//g' | \
	sed 's/ title="[^"]*"//g' | \
	sed '/<ggplot:/d' | \
	sed '/^ *```$$/{N; /^ *``` *\n *``` *$$/d}' | \
	sed -re 's|/Users/[a-z]+/repos/datascienceworkshops/$(NAME)|.|g' | \
	sed -re "s;(figure/)|(images/);/assets/img/blog/$(SLUG)/;" > $@

README.md: README.Rmd venv renv/library
	Rscript --vanilla -e 'source("renv/activate.R"); rmarkdown::render("$<")'

rmd: output/$(NAME).Rmd

ipynb: output/$(NAME).ipynb

blogpost: $(POST) # not meant to be run by mere mortals

anchors:
	curl -sL "https://r4ds.had.co.nz" | \
	grep 'data-level' | \
	awk -F\" '$$4 ~ /^(3|28)/ {print "["$$4"](https://r4ds.had.co.nz/"$$8")&nbsp;&nbsp;&nbsp;"}'

lab: venv
	. venv/bin/activate
	jupyter lab

