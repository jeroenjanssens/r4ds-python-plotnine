#!/usr/bin/env bash

NAME="plotnine-grammar-of-graphics-for-python"
SITE=~/repos/mine/dsw-com
DATE="$(date +'%Y-%m-%d')"
FILE="$SITE/content/_posts/$DATE-$NAME.md"

if [ ! -d "$SITE/" ]; then
    echo "Error: $SITE does not exist."
    exit 1
fi

rm -v $SITE/content/_posts/*-$NAME.md
cat output/plotnine.md | sed -re "s;(figure/)|(images/);/assets/img/blog/${NAME}/;" > $FILE
echo "Wrote $FILE"
mkdir -p $SITE/assets/img/blog/$NAME/
cp -v output/figure/* $SITE/assets/img/blog/$NAME/
cp -v input/images/* $SITE/assets/img/blog/$NAME/
