#!/usr/bin/env bash
cat input/plotnine.Rmd |
sed -e '/^---$/,/^---$/d;/```{r/,/```/d;/TODO/d' |
cat -s |
sed -re 's/\[\^([0-9+])\]: (.*)$/<span id="fn:\1">\1\. \2<\/span>\n/' |
sed -re 's/\[\^([0-9+])\]/[<sup>\1<\/sup>](#fn:\1)/g' |
jupytext --from rmarkdown --to notebook --execute > notebook/r4ds-python-plotnine.ipynb
