#!/usr/bin/env bash
set -euxo pipefail

mkdir -p output

cat input/plotnine.Rmd |
    sed -e '/<!-- START_HIDE_MD -->/,/<!-- END_HIDE_MD -->/d' |
    sed -e '/_HIDE_IPYNB/d' |
    sed -e '/START_COMMENT/,/END_COMMENT/d' > input/plotnine.tmp.Rmd

Rscript --vanilla -e 'source("renv/activate.R"); knitr::knit("input/plotnine.tmp.Rmd", "output/plotnine.tmp.md")'
rm -rf output/figure
cp -R input/figure output

cat output/plotnine.tmp.md |
    sed 's/ alt="[^"]*"//g' |
    sed 's/ title="[^"]*"//g' |
    sed '/## *$/d' |
    sed '/## <ggplot:/d' |
    sed '/^ *```$/{N; /^ *``` *\n *``` *$/d}' > output/plotnine.md

rm input/plotnine.tmp.Rmd output/plotnine.tmp.md
