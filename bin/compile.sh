#!/usr/bin/env bash
set -euxo pipefail

mkdir -p output
Rscript --vanilla -e 'source("renv/activate.R"); knitr::knit("input/plotnine.Rmd", "output/plotnine.tmp.md")'
rm -rf output/figure
cp -Rv input/figure output
cat output/plotnine.tmp.md |
    sed 's/ alt="[^"]*"//g' |
    sed 's/ title="[^"]*"//g' |
    sed '/## <ggplot:/d' |
    sed '/^```$/{N; /^```\n```$/d}' > output/plotnine.md
rm output/plotnine.tmp.md

