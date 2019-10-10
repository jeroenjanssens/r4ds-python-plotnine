#!/usr/bin/env bash

NAME="plotnine-grammar-of-graphics-for-python"

cat output/plotnine.md | sed -re "s;(figure/)|(images/);/assets/img/blog/${NAME}/;" > ~/repos/mine/dsw-com/content/_posts/2019-09-01-$NAME.md
mkdir -p ~/repos/mine/dsw-com/assets/img/blog/$NAME/
cp output/figure/* ~/repos/mine/dsw-com/assets/img/blog/$NAME/
cp input/images/* ~/repos/mine/dsw-com/assets/img/blog/$NAME/
