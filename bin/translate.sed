#!/usr/bin/env -S sed -rf

# Basic replacements
/```/!{
  s/FALSE/False/g
  s/TRUE/True/g
  s/NULL/None/g
  s/\bR\b/Python/g
  s/ggplot2/plotnine/g
  s/data frame/DataFrame/g                             
}

# Apply the following only inside code chunks
/```\{/,/```/{
  # Change language to Python
  s/```\{r/```\{python/
    
  # Add slashes after plusses
  s/\+\s*$/+\\/

  # Quote column names
  s/([\ \(])(x|y|cty|hwy|displ|class|drv|cut|clarity|depth|carat|price)([\),])/\1"\2"\3/g

  # Replace dots with underscores in function names
  /```/!s/([a-z]{2,})\.([a-z]+)/\1_\2/g

  # Remove indentation
  /(```|ggplot)/!{
    s/^((    )*)  /\1/
  }
}

# Remove whitespace around equal signs
s/ = /=/g

# Change assignment operator
s/<-/=/g

# No such thing as Python Markdown
s/Python Markdown/R Markdown/g
