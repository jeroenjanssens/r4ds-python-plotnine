#!/usr/bin/env bash
set -euxo pipefail

cat input/plotnine.Rmd |
sed -e '/^---$/,/^---$/d;/```{r/,/```/d;/TODO/d' |
sed -e '/<!-- START_HIDE_IPYNB -->/,/<!-- END_HIDE_IPYNB -->/d' |
sed -e '/_HIDE_NB/d' |
sed -e '/START_COMMENT/,/END_COMMENT/d' |
cat -s |
sed -re 's/\[\^([0-9+])\]: (.*)$/<span id="fn:\1">\1\. \2<\/span>\n/' |
sed -re 's/\[\^([0-9+])\]/[<sup>\1<\/sup>](#fn:\1)/g' |
jupytext --from rmarkdown --to notebook --set-kernel - --execute > output/r4ds-python-plotnine.ipynb
