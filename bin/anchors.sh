#!/usr/bin/env bash
curl -sL "https://r4ds.had.co.nz" |
grep 'data-level' |
awk -F\" '$4 ~ /^(3|28)/  {print "["$4"](https://r4ds.had.co.nz/"$8")&nbsp;&nbsp;&nbsp;"}'
