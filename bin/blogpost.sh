#!/usr/bin/env bash
set -euxo pipefail

NAME="plotnine-grammar-of-graphics-for-python"
SITE=~/repos/mine/dsw-com
DATE="$(date +'%Y-%m-%d')"
FILE="$SITE/content/_posts/$DATE-$NAME.md"

if [ ! -d "$SITE/" ]; then
    echo "Error: $SITE does not exist."
    exit 1
fi

rm $SITE/content/_posts/*-$NAME.md
cat output/r4ds-python-plotnine.blogpost.md |
    sed -re 's|/Users/[a-z]+/repos/datascienceworkshops/r4ds-python-plotnine|.|g' |
    sed -re "s;(figure/)|(images/);/assets/img/blog/${NAME}/;" > $FILE
echo "Wrote $FILE"
mkdir -p $SITE/assets/img/blog/$NAME/
rm -rf $SITE/assets/img/blog/$NAME/*
cp output/figure/* $SITE/assets/img/blog/$NAME/
cp input/images/* $SITE/assets/img/blog/$NAME/
