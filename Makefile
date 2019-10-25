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

venv: requirements.txt
	rm -rf venv
	virtualenv --python=python3.7 venv
	. venv/bin/activate
	pip install -U pip
	pip install -Ur requirements.txt
	python -m ipykernel install --user --name=$(NAME) # install kernelspec

renv/library: renv.lock
	Rscript --vanilla -e 'if (!requireNamespace("remotes")) install.packages("remotes"); remotes::install_github("rstudio/renv"); renv::restore()' 
	touch $@
	
output:
	mkdir -p $@

clean:
	rm -rf output

output/$(NAME).ipynb: input/$(NAME).ipynb.Rmd output venv
	. venv/bin/activate
	< $< sed -e '/^---$$/,/^---$$/d;/```{r/,/```/d;/TODO/d' | \                                 # remove YAML header and R chunks
	sed -e '/<!-- START_HIDE_IPYNB -->/,/<!-- END_HIDE_IPYNB -->/d' | \                         # remove lines not meant for Jupyter notebook
	sed -e '/_HIDE_MD/d' | \
	sed -e '/START_COMMENT/,/END_COMMENT/d' | \
	cat -s | \
	sed -re 's/\[\^([0-9+])\]: (.*)$$/<span id="fn:\1">\1\. \2<\/span>\n/' | \                  # fix footnotes
	sed -re 's/\[\^([0-9+])\]/[<sup>\1<\/sup>](#fn:\1)/g' | \
	jupytext --from rmarkdown --to notebook --set-kernel r4ds-python-plotnine --execute > $@    # compile Jupyter notebook

output/$(NAME).div.Rmd: input/$(NAME).ipynb.Rmd output                                          # remove lines not meant for R markdown
	< $< sed -e '/<!-- START_HIDE_MD -->/,/<!-- END_HIDE_MD -->/d' | \
    sed -e '/_HIDE_IPYNB/d' | \
    sed -e '/START_COMMENT/,/END_COMMENT/d' > $@

output/$(NAME).Rmd: output/$(NAME).div.Rmd
	< $< sed -re '/<\/?div/d;s/ class="[^"]"//g' > $@                                           # remove div elements; these are only used by the blog post

output/$(NAME).blog.md: output/$(NAME).div.Rmd renv/library
	Rscript --vanilla -e 'source("renv/activate.R"); knitr::knit("$<", "$@")'
	
rmd: output/$(NAME).Rmd
ipynb: output/$(NAME).ipynb

$(POST): output/$(NAME).blog.md $(SITE)/content/_posts $(SITE)/assets/img/blog
	rm -f $(SITE)/content/_posts/*-$(SLUG).md                                                   # copy static and generated images
	mkdir -p $(SITE)/assets/img/blog/$(SLUG)/
	rm -rf $(SITE)/assets/img/blog/$(SLUG)/*
	cp output/figure/* $(SITE)/assets/img/blog/$(SLUG)/
	cp input/images/* $(SITE)/assets/img/blog/$(SLUG)/
	cat $< | \
	sed 's/ alt="[^"]*"//g' | \                                                                 # remove alt and title attributes
	sed 's/ title="[^"]*"//g' | \
    sed '/## *$$/d' | \                                                                         # remove empty output and image reference
	sed '/## <ggplot:/d' | \
    sed '/^ *```$$/{N; /^ *``` *\n *``` *$$/d}' | \                                             # can't remember what this does
	sed -re 's|/Users/[a-z]+/repos/datascienceworkshops/r4ds-python-plotnine|.|g' | \           # hide personal directory
	sed -re "s;(figure/)|(images/);/assets/img/blog/$(SLUG)/;" > $@                             # fix path to images

blogpost: $(POST)

anchors:                                                                                        # these anchors are used to link to the corresponding R4DS sections
	curl -sL "https://r4ds.had.co.nz" | \
	grep 'data-level' | \
	awk -F\" '$$4 ~ /^(3|28)/ {print "["$$4"](https://r4ds.had.co.nz/"$$8")&nbsp;&nbsp;&nbsp;"}'

lab:
	. venv/bin/activate
	jupyter lab

