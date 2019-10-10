
```{python out.width="50%", fig.align='default', warning=FALSE, fig.asp=1/2, fig.cap =""}
# Left
ggplot(data=mpg) +\
geom_point(mapping=aes(x="displ", y="hwy", alpha="class"))

# Right
ggplot(data=mpg) +\
geom_point(mapping=aes(x="displ", y="hwy", shape="class"))
```

What happened to the SUVs? plotnine will only use six shapes at a time. By default, additional groups will go unplotted when you use the shape aesthetic.

For each aesthetic, you use `aes()` to associate the name of the aesthetic with a variable to display. The `aes()` function gathers together each of the aesthetic mappings used by a layer and passes them to the layer's mapping argument. The syntax highlights a useful insight about `x` and `y`: the x and y locations of a point are themselves aesthetics, visual properties that you can map to variables to display information about the data.

Once you map an aesthetic, plotnine takes care of the rest. It selects a reasonable scale to use with the aesthetic, and it constructs a legend that explains the mapping between levels and values. For x and y aesthetics, plotnine does not create a legend, but it creates an axis line with tick marks and a label. The axis line acts as a legend; it explains the mapping between locations and values.

You can also _set_ the aesthetic properties of your geom manually. For example, we can make all of the points in our plot blue:

```{python}
ggplot(data=mpg) +\
geom_point(mapping=aes(x="displ", y="hwy"), color="blue")
```

Here, the color doesn't convey information about a variable, but only changes the appearance of the plot. To set an aesthetic manually, set the aesthetic by name as an argument of your geom function; i.e. it goes _outside_ of `aes()`. You'll need to pick a level that makes sense for that aesthetic:

* The name of a color as a character string.

* The size of a point in mm.

* The shape of a point as a number, as shown in Figure \@ref(fig:shapes).

<!-- ```{python shapes, echo=FALSE, out.width="75%", fig.asp=1/3, fig.cap="R has 25 built in shapes that are identified by numbers. There are some seeming duplicates: for example, 0, 15, and 22 are all squares. The difference comes from the interaction of the `colour` and `fill` aesthetics. The hollow shapes (0--14) have a border determined by `colour`; the solid shapes (15--18) are filled with `colour`; the filled shapes (21--24) have a border of `colour` and are filled with `fill`.", warning=FALSE} -->
shapes = tibble(
shape=c(0, 1, 2, 5, 3, 4, 6:19, 22, 21, 24, 23, 20),
x=(0:24 %/% 5) / 2,
y=(-(0:24 %% 5)) / 4
)
ggplot(shapes, aes("x", "y")) +\
geom_point(aes(shape=shape), size=5, fill="red") +\
geom_text(aes(label=shape), hjust=0, nudge_x=0.15) +\
scale_shape_identity() +\
expand_limits(x=4.1) +\
scale_x_continuous(None, breaks=None) +\
scale_y_continuous(None, breaks=None, limits=c(-1.2, 0.2)) +\
theme_minimal() +\
theme(aspect_ratio=1/2.75)
<!-- ``` -->

### Exercises

1.  Which variables in `mpg` are categorical? Which variables are continuous?
    (Hint: type `?mpg` to read the documentation for the dataset). How
    can you see this information when you run `mpg`?

1.  Map a continuous variable to `color`, `size`, and `shape`. How do
    these aesthetics behave differently for categorical vs. continuous
    variables?

1.  What happens if you map the same variable to multiple aesthetics?

1.  What does the `stroke` aesthetic do? What shapes does it work with?
    (Hint: use `?geom_point`)

1.  What happens if you map an aesthetic to something other than a variable
    name, like `aes(colour=displ < 5)`?  Note, you'll also need to specify x and y.

## Common problems

As you start to run Python code, you're likely to run into problems. Don't worry --- it happens to everyone. I have been writing Python code for years, and every day I still write code that doesn't work!

Start by carefully comparing the code that you're running to the code in the book. Python is extremely picky, and a misplaced character can make all the difference. Make sure that every `(` is matched with a `)` and every `"` is paired with another `"`. Sometimes you'll run the code and nothing happens. Check the left-hand of your console: if it's a `+`, it means that Python doesn't think you've typed a complete expression and it's waiting for you to finish it. In this case, it's usually easy to start from scratch again by pressing ESCAPE to abort processing the current command.

One common problem when creating plotnine graphics is to put the `+` in the wrong place: it has to come at the end of the line, not the start. In other words, make sure you haven't accidentally written code like this:

```{python, eval=FALSE}
ggplot(data=mpg)
+ geom_point(mapping=aes(x=displ, y=hwy))
```

If you're still stuck, try the help. You can get help about any Python function by running `?function_name` in the console, or selecting the function name and pressing F1 in RStudio. Don't worry if the help doesn't seem that helpful - instead skip down to the examples and look for code that matches what you're trying to do.

If that doesn't help, carefully read the error message. Sometimes the answer will be buried there! But when you're new to Python, the answer might be in the error message but you don't yet know how to understand it. Another great tool is Google: try googling the error message, as it's likely someone else has had the same problem, and has gotten help online.

## Facets

One way to add additional variables is with aesthetics. Another way, particularly useful for categorical variables, is to split your plot into __facets__, subplots that each display one subset of the data.

To facet your plot by a single variable, use `facet_wrap()`. The first argument of `facet_wrap()` should be a formula, which you create with `~` followed by a variable name (here "formula" is the name of a data structure in Python, not a synonym for "equation"). The variable that you pass to `facet_wrap()` should be discrete.

```{python}
ggplot(data=mpg) +\
geom_point(mapping=aes(x="displ", y="hwy")) +\
facet_wrap("class", nrow=2)
```

To facet your plot on the combination of two variables, add `facet_grid()` to your plot call. The first argument of `facet_grid()` is also a formula. This time the formula should contain two variable names separated by a `~`.

```{python}
ggplot(data=mpg) +\
geom_point(mapping=aes(x="displ", y="hwy")) +\
facet_grid("drv ~ cyl")
```

If you prefer to not facet in the rows or columns dimension, use a `.` instead of a variable name, e.g. `+ facet_grid(". ~ cyl")`.

### Exercises

1.  What happens if you facet on a continuous variable?

1.  What do the empty cells in plot with `facet_grid("drv ~ cyl")` mean?
    How do they relate to this plot?

    ```{python, eval=FALSE}
    ggplot(data=mpg) +\
    geom_point(mapping=aes(x="drv", y="cyl"))
    ```

1.  What plots does the following code make? What does `.` do?

    ```{python eval=FALSE}
    ggplot(data=mpg) +\
    geom_point(mapping=aes(x="displ", y="hwy")) +\
    facet_grid("drv ~ .")

    ggplot(data=mpg) +\
    geom_point(mapping=aes(x="displ", y="hwy")) +\
    facet_grid(". ~ cyl")
    ```

1.  Take the first faceted plot in this section:

    ```{python, eval=FALSE}
    ggplot(data=mpg) +\
    geom_point(mapping=aes(x="displ", y="hwy")) +\
    facet_wrap("class", nrow=2)
    ```

    What are the advantages to using faceting instead of the colour aesthetic?
    What are the disadvantages? How might the balance change if you had a
    larger dataset?

1.  Read `?facet_wrap`. What does `nrow` do? What does `ncol` do? What other
    options control the layout of the individual panels? Why doesn't
`facet_grid()` have `nrow` and `ncol` arguments?

  1.  When using `facet_grid()` you should usually put the variable with more
unique levels in the columns. Why?

  ## Geometric objects

  How are these two plots similar?

  ```{python echo=FALSE, out.width="50%", fig.align="default", message=FALSE}
ggplot(data=mpg) +\
geom_point(mapping=aes(x="displ", y="hwy"))

ggplot(data=mpg) +\
geom_smooth(mapping=aes(x="displ", y="hwy"))
```

Both plots contain the same x variable, the same y variable, and both describe the same data. But the plots are not identical. Each plot uses a different visual object to represent the data. In plotnine syntax, we say that they use different __geoms__.

A __geom__ is the geometrical object that a plot uses to represent data. People often describe plots by the type of geom that the plot uses. For example, bar charts use bar geoms, line charts use line geoms, boxplots use boxplot geoms, and so on. Scatterplots break the trend; they use the point geom. As we see above, you can use different geoms to plot the same data. The plot on the left uses the point geom, and the plot on the right uses the smooth geom, a smooth line fitted to the data.

To change the geom in your plot, change the geom function that you add to `ggplot()`. For instance, to make the plots above, you can use this code:

  ```{python eval=FALSE}
# left
ggplot(data=mpg) +\
geom_point(mapping=aes(x="displ", y="hwy"))

# right
ggplot(data=mpg) +\
geom_smooth(mapping=aes(x="displ", y="hwy"))
```

Every geom function in plotnine takes a `mapping` argument. However, not every aesthetic works with every geom. You could set the shape of a point, but you couldn't set the "shape" of a line. On the other hand, you _could_ set the linetype of a line. `geom_smooth()` will draw a different line, with a different linetype, for each unique value of the variable that you map to linetype.

```{python message=FALSE}
ggplot(data=mpg) +\
geom_smooth(mapping=aes(x="displ", y="hwy", linetype="drv"))
```

Here `geom_smooth()` separates the cars into three lines based on their `drv` value, which describes a car's drivetrain. One line describes all of the points with a `4` value, one line describes all of the points with an `f` value, and one line describes all of the points with an `r` value. Here, `4` stands for four-wheel drive, `f` for front-wheel drive, and `r` for rear-wheel drive.

If this sounds strange, we can make it more clear by overlaying the lines on top of the raw data and then coloring everything according to `drv`.

```{python echo=FALSE, message=FALSE}
ggplot(data=mpg, mapping=aes(x="displ", y="hwy", color="drv")) +\
geom_point() +\
geom_smooth(mapping=aes(linetype="drv"))
```

Notice that this plot contains two geoms in the same graph! If this makes you excited, buckle up. We will learn how to place multiple geoms in the same plot very soon.

plotnine provides over 30 geoms, and extension packages provide even more (see <https://www.plotnine-exts.org> for a sampling). The best way to get a comprehensive overview is the plotnine cheatsheet, which you can find at <http://rstudio.com/cheatsheets>. To learn more about any single geom, use help: `?geom_smooth`.

Many geoms, like `geom_smooth()`, use a single geometric object to display multiple rows of data. For these geoms, you can set the `group` aesthetic to a categorical variable to draw multiple objects. plotnine will draw a separate object for each unique value of the grouping variable. In practice, plotnine will automatically group the data for these geoms whenever you map an aesthetic to a discrete variable (as in the `linetype` example). It is convenient to rely on this feature because the group aesthetic by itself does not add a legend or distinguishing features to the geoms.

```{python, fig.width=3, fig.align='default', out.width="33%", message=FALSE}
ggplot(data=mpg) +\
geom_smooth(mapping=aes(x="displ", y="hwy"))

ggplot(data=mpg) +\
geom_smooth(mapping=aes(x="displ", y="hwy", group="drv"))

ggplot(data=mpg) +\
geom_smooth(mapping=aes(x="displ", y="hwy", color="drv"), show_legend=False)
```

To display multiple geoms in the same plot, add multiple geom functions to `ggplot()`:

  ```{python, message=FALSE}
ggplot(data=mpg) +\
geom_point(mapping=aes(x="displ", y="hwy")) +\
geom_smooth(mapping=aes(x="displ", y="hwy"))
```

This, however, introduces some duplication in our code. Imagine if you wanted to change the y-axis to display `cty` instead of `hwy`. You'd need to change the variable in two places, and you might forget to update one. You can avoid this type of repetition by passing a set of mappings to `ggplot()`. plotnine will treat these mappings as global mappings that apply to each geom in the graph.  In other words, this code will produce the same plot as the previous code:

```{python, eval=FALSE}
ggplot(data=mpg, mapping=aes(x="displ", y="hwy")) +\
geom_point() +\
geom_smooth()
```

If you place mappings in a geom function, plotnine will treat them as local mappings for the layer. It will use these mappings to extend or overwrite the global mappings _for that layer only_. This makes it possible to display different aesthetics in different layers.

```{python, message=FALSE}
ggplot(data=mpg, mapping=aes(x="displ", y="hwy")) +\
geom_point(mapping=aes(color="class")) +\
geom_smooth()
```

You can use the same idea to specify different `data` for each layer. Here, our smooth line displays just a subset of the `mpg` dataset, the subcompact cars. The local data argument in `geom_smooth()` overrides the global data argument in `ggplot()` for that layer only.

```{python, message=FALSE}
ggplot(data=mpg, mapping=aes(x="displ", y="hwy")) +\
geom_point(mapping=aes(color="class")) +\
geom_smooth(data=mpg.loc[mpg["class"] == "subcompact"], se=False)
```

(You'll learn how `filter()` works in the chapter on data transformations: for now, just know that this command selects only the subcompact cars.)

### Exercises

1.  What geom would you use to draw a line chart? A boxplot?
  A histogram? An area chart?

  1.  Run this code in your head and predict what the output will look like.
Then, run the code in Python and check your predictions.

```{python, eval=FALSE}
ggplot(data=mpg, mapping=aes(x="displ", y="hwy", color="drv")) +\
geom_point() +\
geom_smooth(se=False)
```

1.  What does `show.legend=False` do?  What happens if you remove it?
  Why do you think I used it earlier in the chapter?

  1.  What does the `se` argument to `geom_smooth()` do?


  1.  Will these two graphs look different? Why/why not?

  ```{python, eval=FALSE}
ggplot(data=mpg, mapping=aes(x="displ", y="hwy")) +\
geom_point() +\
geom_smooth()

ggplot() +\
geom_point(data=mpg, mapping=aes(x="displ", y="hwy")) +\
geom_smooth(data=mpg, mapping=aes(x="displ", y="hwy"))
```

1.  Recreate the Python code necessary to generate the following graphs.

```{python echo=FALSE, fig.width=3, out.width="50%", fig.align="default", message=FALSE}
ggplot(data=mpg, mapping=aes(x="displ", y="hwy")) +\
geom_point() +\
geom_smooth(se=False)
ggplot(data=mpg, mapping=aes(x="displ", y="hwy")) +\
geom_smooth(aes(group="drv"), se=False) +\
geom_point()
ggplot(data=mpg, mapping=aes(x="displ", y="hwy", color="drv")) +\
geom_point() +\
geom_smooth(se=False)
ggplot(data=mpg, mapping=aes(x="displ", y="hwy")) +\
geom_point(aes(color="drv")) +\
geom_smooth(se=False)
ggplot(data=mpg, mapping=aes(x="displ", y="hwy")) +\
geom_point(aes(color="drv")) +\
geom_smooth(aes(linetype="drv"), se=False)
ggplot(data=mpg, mapping=aes(x="displ", y="hwy")) +\
geom_point(size=4, colour="white") +\
geom_point(aes(colour="drv"))
```

## Statistical transformations

Next, let's take a look at a bar chart. Bar charts seem simple, but they are interesting because they reveal something subtle about plots. Consider a basic bar chart, as drawn with `geom_bar()`. The following chart displays the total number of diamonds in the `diamonds` dataset, grouped by `cut`. The `diamonds` dataset comes in plotnine and contains information about ~54,000 diamonds, including the `price`, `carat`, `color`, `clarity`, and `cut` of each diamond. The chart shows that more diamonds are available with high quality cuts than with low quality cuts.

```{python}
ggplot(data=diamonds) +\
geom_bar(mapping=aes(x="cut"))
```

On the x-axis, the chart displays `cut`, a variable from `diamonds`. On the y-axis, it displays count, but count is not a variable in `diamonds`! Where does count come from? Many graphs, like scatterplots, plot the raw values of your dataset. Other graphs, like bar charts, calculate new values to plot:

* bar charts, histograms, and frequency polygons bin your data
  and then plot bin counts, the number of points that fall in each bin.

* smoothers fit a model to your data and then plot predictions from the
  model.

* boxplots compute a robust summary of the distribution and then display a
  specially formatted box.

The algorithm used to calculate new values for a graph is called a __stat__, short for statistical transformation. The figure below describes how this process works with `geom_bar()`.

<!-- ```{python, echo=FALSE, out.width="100%"} -->
knitr::include_graphics("images/visualization-stat-bar_png")
<!-- ``` -->

You can learn which stat a geom uses by inspecting the default value for the `stat` argument. For example, `?geom_bar` shows that the default value for `stat` is "count", which means that `geom_bar()` uses `stat_count()`. `stat_count()` is documented on the same page as `geom_bar()`, and if you scroll down you can find a section called "Computed variables". That describes how it computes two new variables: `count` and `prop`.

You can generally use geoms and stats interchangeably. For example, you can recreate the previous plot using `stat_count()` instead of `geom_bar()`:

```{python}
ggplot(data=diamonds) +\
stat_count(mapping=aes(x="cut"))
```

This works because every geom has a default stat; and every stat has a default geom. This means that you can typically use geoms without worrying about the underlying statistical transformation. There are three reasons you might need to use a stat explicitly:

1.  You might want to override the default stat. In the code below, I change
    the stat of `geom_bar()` from count (the default) to identity. This lets
    me map the height of the bars to the raw values of a $y$ variable.
    Unfortunately when people talk about bar charts casually, they might be
    referring to this type of bar chart, where the height of the bar is already
    present in the data, or the previous bar chart where the height of the bar
    is generated by counting rows.

    ```{python}
demo = pd.DataFrame({"cut": ["Fair", "Good", "Very Good", "Premium", "Ideal"],
                     "freq": [1610, 4906, 12082, 13791, 21551]})
ggplot(data=demo) +\
geom_bar(mapping=aes(x="cut", y="freq"), stat="identity")
    ```

    (Don't worry that you haven't seen `=` or `tribble()` before. You might be
    able to guess at their meaning from the context, and you'll learn exactly
what they do soon!)

1.  You might want to override the default mapping from transformed variables
to aesthetics. For example, you might want to display a bar chart of
proportion, rather than count:

  ```{python}
ggplot(data=diamonds) +\
geom_bar(mapping=aes(x="cut", y="..prop..", group=1))
```

To find the variables computed by the stat, look for the help section
titled "computed variables".

1.  You might want to draw greater attention to the statistical transformation
in your code. For example, you might use `stat_summary()`, which
summarises the y values for each unique x value, to draw
attention to the summary that you're computing:

    ```{python}
ggplot(data=diamonds) +\
stat_summary(
  mapping=aes(x="cut", y="depth"),
  fun_ymin=np.min,
  fun_ymax=np.max,
  fun_y=np.median
)
    ```

<!-- TODO: cheatsheet? -->
plotnine provides over 20 stats for you to use. Each stat is a function, so you can get help in the usual way, e.g. `?stat_bin`. To see a complete list of stats, try the plotnine cheatsheet.

### Exercises

1.  What is the default geom associated with `stat_summary()`? How could
    you rewrite the previous plot to use that geom function instead of the
    stat function?

1.  What does `geom_col()` do? How is it different to `geom_bar()`?

1.  Most geoms and stats come in pairs that are almost always used in
    concert. Read through the documentation and make a list of all the
    pairs. What do they have in common?

1.  What variables does `stat_smooth()` compute? What parameters control
    its behaviour?

1.  In our proportion bar chart, we need to set `group=1`. Why? In other
    words what is the problem with these two graphs?

    ```{python, eval=FALSE}
ggplot(data=diamonds) +\
geom_bar(mapping=aes(x="cut", y="..prop.."))
ggplot(data=diamonds) +\
geom_bar(mapping=aes(x="cut", fill="color", y="..prop.."))
    ```


## Position adjustments

There's one more piece of magic associated with bar charts. You can colour a bar chart using either the `colour` aesthetic, or, more usefully, `fill`:

  ```{python out.width="50%", fig.align="default"}
ggplot(data=diamonds) +\
geom_bar(mapping=aes(x="cut", colour="cut"))
ggplot(data=diamonds) +\
geom_bar(mapping=aes(x="cut", fill="cut"))
```

Note what happens if you map the fill aesthetic to another variable, like `clarity`: the bars are automatically stacked. Each colored rectangle represents a combination of `cut` and `clarity`.

```{python}
ggplot(data=diamonds) +\
geom_bar(mapping=aes(x="cut", fill="clarity"))
```

The stacking is performed automatically by the __position adjustment__ specified by the `position` argument. If you don't want a stacked bar chart, you can use one of three other options: `"identity"`, `"dodge"` or `"fill"`.

*   `position="identity"` will place each object exactly where it falls in
    the context of the graph. This is not very useful for bars, because it
    overlaps them. To see that overlapping we either need to make the bars
    slightly transparent by setting `alpha` to a small value, or completely
    transparent by setting `fill=NA`.

    ```{python out.width="50%", fig.align="default"}
ggplot(data=diamonds, mapping=aes(x="cut", fill="clarity")) +\
geom_bar(alpha=1/5, position="identity")
ggplot(data=diamonds, mapping=aes(x="cut", colour="clarity")) +\
geom_bar(fill=None, position="identity")
    ```

    The identity position adjustment is more useful for 2d geoms, like points,
    where it is the default.

*   `position="fill"` works like stacking, but makes each set of stacked bars
    the same height. This makes it easier to compare proportions across
    groups.

    ```{python}
ggplot(data=diamonds) +\
geom_bar(mapping=aes(x="cut", fill="clarity"), position="fill")
    ```

*   `position="dodge"` places overlapping objects directly _beside_ one
    another. This makes it easier to compare individual values.

    ```{python}
ggplot(data=diamonds) +\
geom_bar(mapping=aes(x="cut", fill="clarity"), position="dodge")
    ```

There's one other type of adjustment that's not useful for bar charts, but it can be very useful for scatterplots. Recall our first scatterplot. Did you notice that the plot displays only 126 points, even though there are 234 observations in the dataset?

```{python echo=FALSE}
ggplot(data=mpg) +\
geom_point(mapping=aes(x="displ", y="hwy"))
```

The values of `hwy` and `displ` are rounded so the points appear on a grid and many points overlap each other. This problem is known as __overplotting__. This arrangement makes it hard to see where the mass of the data is. Are the data points spread equally throughout the graph, or is there one special combination of `hwy` and `displ` that contains 109 values?

You can avoid this gridding by setting the position adjustment to "jitter".  `position="jitter"` adds a small amount of random noise to each point. This spreads the points out because no two points are likely to receive the same amount of random noise.

```{python}
ggplot(data=mpg) +\
geom_point(mapping=aes(x="displ", y="hwy"), position="jitter")
```

Adding randomness seems like a strange way to improve your plot, but while it makes your graph less accurate at small scales, it makes your graph _more_ revealing at large scales. Because this is such a useful operation, plotnine comes with a shorthand for `geom_point(position="jitter")`: `geom_jitter()`.

To learn more about a position adjustment, look up the help page associated with each adjustment: `?position_dodge`, `?position_fill`, `?position_identity`, `?position_jitter`, and `?position_stack`.

### Exercises

1.  What is the problem with this plot? How could you improve it?

    ```{python}
ggplot(data=mpg, mapping=aes(x="cty", y="hwy")) +\
geom_point()
    ```

1.  What parameters to `geom_jitter()` control the amount of jittering?

1.  Compare and contrast `geom_jitter()` with `geom_count()`.

1.  What's the default position adjustment for `geom_boxplot()`? Create
a visualisation of the `mpg` dataset that demonstrates it.

## Coordinate systems

Coordinate systems are probably the most complicated part of plotnine. The default coordinate system is the Cartesian coordinate system where the x and y positions act independently to determine the location of each point. There are a number of other coordinate systems that are occasionally helpful.

*   `coord_flip()` switches the x and y axes. This is useful (for example),
if you want horizontal boxplots. It's also useful for long labels: it's
hard to get them to fit without overlapping on the x-axis.

```{python fig.width=3, out.width="50%", fig.align="default"}
ggplot(data=mpg, mapping=aes(x="class", y="hwy")) +\
geom_boxplot()
ggplot(data=mpg, mapping=aes(x="class", y="hwy")) +\
geom_boxplot() +\
coord_flip()
```

<!-- TODO: Add note about coord_quickmap and coord_polar -->

  ### Exercises

  1.  What does `labs()` do? Read the documentation.

1.  What does the plot below tell you about the relationship between city
and highway mpg? Why is `coord_fixed()` important? What does
`geom_abline()` do?

  ```{python, fig.asp=1, out.width="50%"}
ggplot(data=mpg, mapping=aes(x="cty", y="hwy")) +\
geom_point() +\
geom_abline() +\
coord_fixed()
```

## The layered grammar of graphics

In the previous sections, you learned much more than how to make scatterplots, bar charts, and boxplots. You learned a foundation that you can use to make _any_ type of plot with plotnine. To see this, let's add position adjustments, stats, coordinate systems, and faceting to our code template:

```
ggplot(data=<DATA>) +\
<GEOM_FUNCTION>(
   mapping=aes(<MAPPINGS>),
   stat=<STAT>,
   position=<POSITION>
) +\
<COORDINATE_FUNCTION> +\
<FACET_FUNCTION>
```

Our new template takes seven parameters, the bracketed words that appear in the template. In practice, you rarely need to supply all seven parameters to make a graph because plotnine will provide useful defaults for everything except the data, the mappings, and the geom function.

The seven parameters in the template compose the grammar of graphics, a formal system for building plots. The grammar of graphics is based on the insight that you can uniquely describe _any_ plot as a combination of a dataset, a geom, a set of mappings, a stat, a position adjustment, a coordinate system, and a faceting scheme.

To see how this works, consider how you could build a basic plot from scratch: you could start with a dataset and then transform it into the information that you want to display (with a stat).

```{r, echo=FALSE, out.width="100%"}
knitr::include_graphics("images/visualization-grammar-1.png")
```

Next, you could choose a geometric object to represent each observation in the transformed data. You could then use the aesthetic properties of the geoms to represent variables in the data. You would map the values of each variable to the levels of an aesthetic.

```{r, echo=FALSE, out.width="100%"}
knitr::include_graphics("images/visualization-grammar-2.png")
```

You'd then select a coordinate system to place the geoms into. You'd use the location of the objects (which is itself an aesthetic property) to display the values of the x and y variables. At that point, you would have a complete graph, but you could further adjust the positions of the geoms within the coordinate system (a position adjustment) or split the graph into subplots (faceting). You could also extend the plot by adding one or more additional layers, where each additional layer uses a dataset, a geom, a set of mappings, a stat, and a position adjustment.

```{r, echo=FALSE, out.width="100%"}
knitr::include_graphics("images/visualization-grammar-3.png")
```

You could use this method to build _any_ plot that you imagine. In other words, you can use the code template that you've learned in this chapter to build hundreds of thousands of unique plots.









# 28. Graphics for communication

## Introduction

Now that you understand your data, you need to _communicate_ your understanding to others. Your audience will likely not share your background knowledge and will not be deeply invested in the data. To help others quickly build up a good mental model of the data, you will need to invest considerable effort in making your plots as self-explanatory as possible. In this chapter, you'll learn some of the tools that plotnine provides to do so.

This chapter focuses on the tools you need to create good graphics. I assume that you know what you want, and just need to know how to do it. For that reason, I highly recommend pairing this chapter with a good general visualisation book. I particularly like [_The Truthful Art_](https://amzn.com/0321934075), by Albert Cairo. It doesn't teach the mechanics of creating visualisations, but instead focuses on what you need to think about in order to create effective graphics.

<!-- ### Prerequisites -->

  <!-- TODO: ggrepel and viridis? -->

  <!-- In this chapter, we'll focus once again on plotnine. We'll also use a little pandas for data manipulation.  -->

  <!-- ```{python, message=FALSE} -->
  <!-- library(tidyverse) -->
  <!-- ``` -->

  ## Label

  The easiest place to start when turning an exploratory graphic into an expository graphic is with good labels. You add labels with the `labs()` function. This example adds a plot title:

  ```{python, message=FALSE}
ggplot(mpg, aes("displ", "hwy")) +\
geom_point(aes(color="class")) +\
geom_smooth(se=False) +\
labs(title="Fuel efficiency generally decreases with engine size")
```

The purpose of a plot title is to summarise the main finding. Avoid titles that just describe what the plot is, e.g. "A scatterplot of engine displacement vs. fuel economy".


<!-- TODO: missing: subtitle and caption -->


  <!-- If you need to add more text, there are two other useful labels that you can use in plotnine 2.2.0 and above (which should be available by the time you're reading this book): -->

<!-- *   `subtitle` adds additional detail in a smaller font beneath the title. -->

<!-- *   `caption` adds text at the bottom right of the plot, often used to describe -->
<!--     the source of the data. -->

<!-- ```{python, message=FALSE} -->
<!-- ggplot(mpg, aes("displ", "hwy")) +\ -->
<!-- geom_point(aes(color="class")) +\ -->
<!-- geom_smooth(se=False) +\ -->
<!-- labs( -->
<!--   title="Fuel efficiency generally decreases with engine size", -->
<!--   subtitle="Two seaters (sports cars) are an exception because of their light weight", -->
<!--   caption="Data from fueleconomy_gov" -->
<!-- ) -->
<!-- ``` -->

You can also use `labs()` to replace the axis and legend titles. It's usually a good idea to replace short variable names with more detailed descriptions, and to include the units.

                                                                                                                     ```{python, message=FALSE}
                                                                                                                     ggplot(mpg, aes("displ", "hwy")) +\
                                                                                                                     geom_point(aes(colour="class")) +\
                                                                                                                     geom_smooth(se=False) +\
                                                                                                                     labs(
                                                                                                                       x="Engine displacement (L)",
                                                                                                                       y="Highway fuel economy (mpg)",
                                                                                                                       colour="Car type"
                                                                                                                     )
                                                                                                                     ```

                                                                                                                     <!-- TODO: explain how to use latex in plotnine and matplotlib -->

                                                                                                                       It's possible to use mathematical equations instead of text strings. Just switch `""` out for `quote()` and read about the available options in `?plotmath`:

```{python}
df = pd.DataFrame({"x": np.random.uniform(size=10),
                   "y": np.random.uniform(size=10)})

ggplot(df, aes("x", "y")) +\
geom_point() +\
labs(
  x="$$\\sum_{i = 1}^n{x_i^2}$$",
  y="$$\\alpha + \\beta + \\frac{\\delta}{\\theta}$$"
)
```


### Exercises

1.  Create one plot on the fuel economy data with customised `title`, `x`, `y`, and `colour` labels.

1.  The `geom_smooth()` is somewhat misleading because the `hwy` for
    large engines is skewed upwards due to the inclusion of lightweight
    sports cars with big engines. Use your modelling tools to fit and display
    a better model.

1.  Take an exploratory graphic that you've created in the last month, and add
an informative title to make it easier for others to understand.

## Annotations

In addition to labelling major components of your plot, it's often useful to label individual observations or groups of observations. The first tool you have at your disposal is `geom_text()`. `geom_text()` is similar to `geom_point()`, but it has an additional aesthetic: `label`. This makes it possible to add textual labels to your plots.

There are two possible sources of labels. First, you might have a tibble that provides labels. The plot below isn't terribly useful, but it illustrates a useful approach: pull out the most efficient car in each class with dplyr, and then label it on the plot:

  ```{python}
best_in_class = mpg\
.sort_values(by="hwy", ascending=False)\
.groupby("class")\
.first()

ggplot(mpg, aes("displ", "hwy")) +\
geom_point(aes(colour="class")) +\
geom_text(aes(label="model"), data=best_in_class)
```


This is hard to read because the labels overlap with each other, and with the points. We can make things a little better by switching to `geom_label()` which draws a rectangle behind the text. We also use the `nudge_y` parameter to move the labels slightly above the corresponding points:

  ```{python}
ggplot(mpg, aes("displ", "hwy")) +\
geom_point(aes(colour="class")) +\
geom_label(aes(label="model"), data=best_in_class, nudge_y=2, alpha=0.5)
```

<!-- TODO: replace ggrepel with adjustText -->

  That helps a bit, but if you look closely in the top-left hand corner, you'll notice that there are two labels practically on top of each other. This happens because the highway mileage and displacement for the best cars in the compact and subcompact categories are exactly the same. There's no way that we can fix these by applying the same transformation for every label. Instead, we can use the __ggrepel__ package by Kamil Slowikowski. This useful package will automatically adjust labels so that they don't overlap:


```{python}
ggplot(mpg, aes("displ", "hwy")) +\
geom_point(aes(colour="class")) +\
geom_point(data=best_in_class, fill='none') +\
geom_label(aes(label="model"), data=best_in_class, adjust_text={
    'expand_points': (1.5, 1.5),
    'arrowprops': {
        'arrowstyle': '-'
    }})
```

Note another handy technique used here: I added a second layer of large, hollow points to highlight the points that I've labelled.

You can sometimes use the same idea to replace the legend with labels placed directly on the plot. It's not wonderful for this plot, but it isn't too bad. (`theme(legend.position="none"`) turns the legend off --- we'll talk about it more shortly.)

<!-- ```{python} -->
<!-- class_avg = mpg %>% -->
<!-- group_by("class") %>% -->
<!-- summarise( -->
<!--   displ=median("displ"), -->
<!--   hwy=median("hwy") -->
<!-- ) -->

<!-- ggplot(mpg, aes("displ", "hwy", colour="class")) +\ -->
<!-- ggrepel::geom_label_repel(aes(label="class"), -->
<!--   data=class_avg, -->
<!--   size=6, -->
<!--   label_size=0, -->
<!--   segment_color=NA -->
<!-- ) +\ -->
<!-- geom_point() +\ -->
<!-- theme(legend_position="none") -->
<!-- ``` -->

Alternatively, you might just want to add a single label to the plot, but you'll still need to create a DataFrame. Often, you want the label in the corner of the plot, so it's convenient to create a new DataFrame using `summarise()` to compute the maximum values of x and y.

<!-- ```{python} -->
<!-- label = mpg %>% -->
<!-- summarise( -->
<!--   displ=max("displ"), -->
<!--   hwy=max("hwy"), -->
<!--   label="Increasing engine size is \nrelated to decreasing fuel economy." -->
<!-- ) -->

<!-- ggplot(mpg, aes("displ", "hwy")) +\ -->
<!-- geom_point() +\ -->
<!-- geom_text(aes(label=label), data=label, vjust="top", hjust="right") -->
<!-- ``` -->

If you want to place the text exactly on the borders of the plot, you can use `+Inf` and `-Inf`. Since we're no longer computing the positions from `mpg`, we can use `tibble()` to create the DataFrame:

  <!-- ```{python} -->
  <!-- label = tibble( -->
                         <!-- displ=Inf, -->
                         <!-- hwy=Inf, -->
                         <!-- label="Increasing engine size is \nrelated to decreasing fuel economy." -->
                         <!-- ) -->

  <!-- ggplot(mpg, aes("displ", "hwy")) +\ -->
  <!-- geom_point() +\ -->
  <!-- geom_text(aes(label=label), data=label, vjust="top", hjust="right") -->
  <!-- ``` -->

  In these examples, I manually broke the label up into lines using `"\n"`. Another approach is to use `stringr::str_wrap()` to automatically add line breaks, given the number of characters you want per line:

  <!-- ```{python} -->
  <!-- "Increasing engine size is related to decreasing fuel economy." %>% -->
  <!-- stringr::str_wrap(width=40) %>% -->
  <!-- writeLines() -->
  <!-- ``` -->

  Note the use of `hjust` and `vjust` to control the alignment of the label. Figure \@ref(fig:just) shows all nine possible combinations.

<!-- ```{python just, echo=FALSE, fig.cap="All nine combinations of `hjust` and `vjust`.", fig.asp=0.5, fig.width=4.5, out.width="60%"} -->
<!-- vjust = c(bottom=0, center=0.5, top=1) -->
<!-- hjust = c(left=0, center=0.5, right=1) -->

<!-- df = tidyr::crossing(hj=names(hjust), vj=names(vjust)) %>% -->
<!-- mutate( -->
<!--   y=vjust[vj], -->
<!--   x=hjust[hj], -->
<!--   label=paste0("hjust='", hj, "'\n", "vjust='", vj, "'") -->
<!-- ) -->

<!-- ggplot(df, aes("x", "y")) +\ -->
<!-- geom_point(colour="grey70", size=5) +\ -->
<!-- geom_point(size=0.5, colour="red") +\ -->
<!-- geom_text(aes(label=label, hjust=hj, vjust=vj), size=4) +\ -->
<!-- labs(x=None, y=None)  -->
<!-- ``` -->

Remember, in addition to `geom_text()`, you have many other geoms in plotnine available to help annotate your plot. A few ideas:

*   Use `geom_hline()` and `geom_vline()` to add reference lines. I often make
    them thick (`size=2`) and white (`colour=white`), and draw them
    underneath the primary data layer. That makes them easy to see, without
    drawing attention away from the data.

*   Use `geom_rect()` to draw a rectangle around points of interest. The
    boundaries of the rectangle are defined by aesthetics `xmin`, `xmax`,
    `ymin`, `ymax`.

*   Use `geom_segment()` with the `arrow` argument to draw attention
    to a point with an arrow. Use aesthetics `x` and `y` to define the
    starting location, and `xend` and `yend` to define the end location.

The only limit is your imagination (and your patience with positioning annotations to be aesthetically pleasing)!

### Exercises

1.  Use `geom_text()` with infinite positions to place text at the
    four corners of the plot.

1.  Read the documentation for `annotate()`. How can you use it to add a text
    label to a plot without having to create a tibble?

1.  How do labels with `geom_text()` interact with faceting? How can you
    add a label to a single facet? How can you put a different label in
    each facet? (Hint: think about the underlying data.)

1.  What arguments to `geom_label()` control the appearance of the background
    box?

1.  What are the four arguments to `arrow()`? How do they work? Create a series
    of plots that demonstrate the most important options.

## Scales

The third way you can make your plot better for communication is to adjust the scales. Scales control the mapping from data values to things that you can perceive. Normally, plotnine automatically adds scales for you. For example, when you type:

```{python default-scales, fig.show="hide"}
ggplot(mpg, aes("displ", "hwy")) +\
geom_point(aes(colour="class"))
```

plotnine automatically adds default scales behind the scenes:

```{python, fig.show="hide"}
ggplot(mpg, aes("displ", "hwy")) +\
geom_point(aes(colour="class")) +\
scale_x_continuous() +\
scale_y_continuous() +\
scale_colour_discrete()
```

Note the naming scheme for scales: `scale_` followed by the name of the aesthetic, then `_`, then the name of the scale. The default scales are named according to the type of variable they align with: continuous, discrete, datetime, or date. There are lots of non-default scales which you'll learn about below.

The default scales have been carefully chosen to do a good job for a wide range of inputs. Nevertheless, you might want to override the defaults for two reasons:

*   You might want to tweak some of the parameters of the default scale.
    This allows you to do things like change the breaks on the axes, or the
    key labels on the legend.

*   You might want to replace the scale altogether, and use a completely
    different algorithm. Often you can do better than the default because
    you know more about the data.

### Axis ticks and legend keys

There are two primary arguments that affect the appearance of the ticks on the axes and the keys on the legend: `breaks` and `labels`. Breaks controls the position of the ticks, or the values associated with the keys. Labels controls the text label associated with each tick/key. The most common use of `breaks` is to override the default choice:

<!-- ```{python} -->
<!-- ggplot(mpg, aes("displ", "hwy")) +\ -->
<!-- geom_point() +\ -->
<!-- scale_y_continuous(breaks=seq(15, 40, by=5)) -->
<!-- ``` -->

You can use `labels` in the same way (a character vector the same length as `breaks`), but you can also set it to `None` to suppress the labels altogether. This is useful for maps, or for publishing plots where you can't share the absolute numbers.

<!-- ```{python} -->
<!-- ggplot(mpg, aes("displ", "hwy")) +\ -->
<!-- geom_point() +\ -->
<!-- scale_x_continuous(labels=None) +\ -->
<!-- scale_y_continuous(labels=None) -->
<!-- ``` -->

You can also use `breaks` and `labels` to control the appearance of legends. Collectively axes and legends are called __guides__. Axes are used for x and y aesthetics; legends are used for everything else.

Another use of `breaks` is when you have relatively few data points and want to highlight exactly where the observations occur. For example, take this plot that shows when each US president started and ended their term.

<!-- ```{python} -->
<!-- presidential %>% -->
<!-- mutate(id=33 + row_number()) %>% -->
<!--   ggplot(aes(start, id)) +\ -->
<!--   geom_point() +\ -->
<!--   geom_segment(aes(xend=end, yend=id)) +\ -->
<!--   scale_x_date(None, breaks=presidential$start, date_labels="'%y") -->
<!-- ``` -->

Note that the specification of breaks and labels for date and datetime scales is a little different:

* `date_labels` takes a format specification, in the same form as
  `parse_datetime()`.

* `date_breaks` (not shown here), takes a string like "2 days" or "1 month".

### Legend layout

You will most often use `breaks` and `labels` to tweak the axes. While they both also work for legends, there are a few other techniques you are more likely to use.

To control the overall position of the legend, you need to use a `theme()` setting. We'll come back to themes at the end of the chapter, but in brief, they control the non-data parts of the plot. The theme setting `legend.position` controls where the legend is drawn:

  ```{python fig.asp=1, fig.align="default", out.width="50%", fig.width=4}
base = ggplot(mpg, aes("displ", "hwy")) +\
geom_point(aes(colour="class"))

base + theme(legend_position="left")
base + theme(legend_position="top")
base + theme(legend_position="bottom")
base + theme(legend_position="right") # the default
```

You can also use `legend.position="none"` to suppress the display of the legend altogether.

To control the display of individual legends, use `guides()` along with `guide_legend()` or `guide_colourbar()`. The following example shows two important settings: controlling the number of rows the legend uses with `nrow`, and overriding one of the aesthetics to make the points bigger. This is particularly useful if you have used a low `alpha` to display many points on a plot.

```{python}
ggplot(mpg, aes("displ", "hwy")) +\
geom_point(aes(colour="class")) +\
geom_smooth(se=False) +\
theme(legend_position="bottom") +\
guides(colour=guide_legend(nrow=1, override_aes={"size": 4}))
```

### Replacing a scale

Instead of just tweaking the details a little, you can instead replace the scale altogether. There are two types of scales you're mostly likely to want to switch out: continuous position scales and colour scales. Fortunately, the same principles apply to all the other aesthetics, so once you've mastered position and colour, you'll be able to quickly pick up other scale replacements.

It's very useful to plot transformations of your variable. For example, as we've seen in [diamond prices](diamond-prices) it's easier to see the precise relationship between `carat` and `price` if we log transform them:

  <!-- ```{python, fig.align="default", out.width="50%"} -->
  <!-- ggplot(diamonds, aes(carat, price)) +\ -->
  <!-- geom_bin2d() -->

  <!-- ggplot(diamonds, aes(log10(carat), log10(price))) +\ -->
  <!-- geom_bin2d() -->
  <!-- ``` -->

  However, the disadvantage of this transformation is that the axes are now labelled with the transformed values, making it hard to interpret the plot. Instead of doing the transformation in the aesthetic mapping, we can instead do it with the scale. This is visually identical, except the axes are labelled on the original data scale.

```{python}
ggplot(diamonds, aes("carat", "price")) +\
geom_bin2d() +\
scale_x_log10() +\
scale_y_log10()
```

Another scale that is frequently customised is colour. The default categorical scale picks colours that are evenly spaced around the colour wheel. Useful alternatives are the ColorBrewer scales which have been hand tuned to work better for people with common types of colour blindness. The two plots below look similar, but there is enough difference in the shades of red and green that the dots on the right can be distinguished even by people with red-green colour blindness.

```{python, fig.align="default", out.width="50%"}
ggplot(mpg, aes("displ", "hwy")) +\
geom_point(aes(color="drv"))

ggplot(mpg, aes("displ", "hwy")) +\
geom_point(aes(color="drv")) +\
scale_colour_brewer(palette="Set1")
```

Don't forget simpler techniques. If there are just a few colours, you can add a redundant shape mapping. This will also help ensure your plot is interpretable in black and white.

```{python}
ggplot(mpg, aes("displ", "hwy")) +\
geom_point(aes(color="drv", shape="drv")) +\
scale_colour_brewer(palette="Set1")
```

The ColorBrewer scales are documented online at <http://colorbrewer2.org/> and made available in Python via the __RColorBrewer__ package, by Erich Neuwirth. Figure \@ref(fig:brewer) shows the complete list of all palettes. The sequential (top) and diverging (bottom) palettes are particularly useful if your categorical values are ordered, or have a "middle". This often arises if you've used `cut()` to make a continuous variable into a categorical variable.

<!-- ```{python brewer, fig.asp=2.5, echo=FALSE, fig.cap="All ColourBrewer scales."} -->
  <!-- par(mar=c(0, 3, 0, 0)) -->
  <!-- RColorBrewer::display_brewer.all() -->
  <!-- ``` -->

  When you have a predefined mapping between values and colours, use `scale_colour_manual()`. For example, if we map presidential party to colour, we want to use the standard mapping of red for Republicans and blue for Democrats:

  <!-- ```{python} -->
  <!-- presidential %>% -->
  <!-- mutate(id=33 + row_number()) %>% -->
  <!--   ggplot(aes(start, id, colour=party)) +\ -->
  <!--   geom_point() +\ -->
  <!--   geom_segment(aes(xend=end, yend=id)) +\ -->
  <!--   scale_colour_manual(values=c(Republican="red", Democratic="blue")) -->
  <!-- ``` -->

  For continuous colour, you can use the built-in `scale_colour_gradient()` or `scale_fill_gradient()`. If you have a diverging scale, you can use `scale_colour_gradient2()`. That allows you to give, for example, positive and negative values different colours. That's sometimes also useful if you want to distinguish points above or below the mean.

Another option is `scale_colour_viridis()` provided by the __viridis__ package. It's a continuous analog of the categorical ColorBrewer scales. The designers, Nathaniel Smith and Stéfan van der Walt, carefully tailored a continuous colour scheme that has good perceptual properties. Here's an example from the viridis vignette.

<!-- ```{python, fig.align="default", fig.asp=1, out.width="50%", fig.width=4} -->
<!-- df = tibble( -->
<!-- x=rnorm(10000), -->
<!-- y=rnorm(10000) -->
<!-- ) -->
<!-- ggplot(df, aes("x", "y")) +\ -->
<!-- geom_hex() +\ -->
<!-- coord_fixed() -->

<!-- ggplot(df, aes("x", "y")) +\ -->
<!-- geom_hex() +\ -->
<!-- viridis::scale_fill_viridis() +\ -->
<!-- coord_fixed() -->
<!-- ``` -->

Note that all colour scales come in two variety: `scale_colour_x()` and `scale_fill_x()` for the `colour` and `fill` aesthetics respectively (the colour scales are available in both UK and US spellings).

### Exercises

1.  Why doesn't the following code override the default scale?

  <!-- ```{python fig.show="hide"} -->
  <!-- ggplot(df, aes("x", "y")) +\ -->
  <!-- geom_hex() +\ -->
  <!-- scale_colour_gradient(low="white", high="red") +\ -->
  <!-- coord_fixed() -->
  <!-- ``` -->

  1.  What is the first argument to every scale? How does it compare to `labs()`?

  1.  Change the display of the presidential terms by:

  1. Combining the two variants shown above.
1. Improving the display of the y axis.
1. Labelling each term with the name of the president.
1. Adding informative plot labels.
1. Placing breaks every 4 years (this is trickier than it seems!).

1.  Use `override.aes` to make the legend on the following plot easier to see.

```{python, out.width="50%"}
ggplot(diamonds, aes("carat", "price")) +\
geom_point(aes(colour="cut"), alpha=1/20)
```

## Zooming

There are three ways to control the plot limits:

  1. Adjusting what data are plotted
1. Setting the limits in each scale
1. Setting `xlim` and `ylim` in `coord_cartesian()`

To zoom in on a region of the plot, it's generally best to use `coord_cartesian()`. Compare the following two plots:

<!-- ```{python out.width="50%", fig.align="default", message=FALSE} -->
<!-- ggplot(mpg, mapping=aes("displ", "hwy")) +\ -->
<!-- geom_point(aes(color="class")) +\ -->
<!-- geom_smooth() +\ -->
<!-- coord_cartesian(xlim=(5, 7), ylim=(10, 30)) -->

<!-- mpg %>% -->
<!-- filter(displ >= 5, displ <= 7, hwy >= 10, hwy <= 30) %>% -->
<!--   ggplot(aes("displ", "hwy")) +\ -->
<!-- geom_point(aes(color="class")) +\ -->
<!-- geom_smooth() -->
<!-- ``` -->

You can also set the `limits` on individual scales. Reducing the limits is basically equivalent to subsetting the data. It is generally more useful if you want _expand_ the limits, for example, to match scales across different plots. For example, if we extract two classes of cars and plot them separately, it's difficult to compare the plots because all three scales (the x-axis, the y-axis, and the colour aesthetic) have different ranges.

<!-- ```{python out.width="50%", fig.align="default", fig.width=4} -->
  <!-- suv = mpg %>% filter(class == "suv") -->
  <!-- compact = mpg %>% filter(class == "compact") -->

  <!-- ggplot(suv, aes("displ", "hwy", colour="drv")) +\ -->
  <!-- geom_point() -->

  <!-- ggplot(compact, aes("displ", "hwy", colour="drv")) +\ -->
  <!-- geom_point() -->
  <!-- ``` -->

  One way to overcome this problem is to share scales across multiple plots, training the scales with the `limits` of the full data.

<!-- ```{python out.width="50%", fig.align="default", fig.width=4} -->
  <!-- x_scale = scale_x_continuous(limits=range(mpg$displ)) -->
  <!-- y_scale = scale_y_continuous(limits=range(mpg$hwy)) -->
  <!-- col_scale = scale_colour_discrete(limits=unique(mpg$drv)) -->

  <!-- ggplot(suv, aes("displ", "hwy", colour="drv")) +\ -->
  <!-- geom_point() +\ -->
  <!-- x_scale +\ -->
  <!-- y_scale +\ -->
  <!-- col_scale -->

  <!-- ggplot(compact, aes("displ", "hwy", colour="drv")) +\ -->
  <!-- geom_point() +\ -->
  <!-- x_scale +\ -->
  <!-- y_scale +\ -->
  <!-- col_scale -->
  <!-- ``` -->

  In this particular case, you could have simply used faceting, but this technique is useful more generally, if for instance, you want spread plots over multiple pages of a report.

## Themes

Finally, you can customise the non-data elements of your plot with a theme:

  <!-- ```{python, message=FALSE} -->
  <!-- ggplot(mpg, aes("displ", "hwy")) +\ -->
  <!-- geom_point(aes(color="class")) +\ -->
  <!-- geom_smooth(se=False) +\ -->
  <!-- theme_bw() -->
  <!-- ``` -->

  plotnine includes eight themes by default, as shown in Figure \@ref(fig:themes). Many more are included in add-on packages like __ggthemes__ (<https://github.com/jrnold/ggthemes>), by Jeffrey Arnold.

<!-- ```{python themes, echo=FALSE, fig.cap="The eight themes built-in to ggplot2."} -->
  <!-- knitr::include_graphics("images/visualization-themes_png") -->
  <!-- ``` -->

  Many people wonder why the default theme has a grey background. This was a deliberate choice because it puts the data forward while still making the grid lines visible. The white grid lines are visible (which is important because they significantly aid position judgements), but they have little visual impact and we can easily tune them out. The grey background gives the plot a similar typographic colour to the text, ensuring that the graphics fit in with the flow of a document without jumping out with a bright white background. Finally, the grey background creates a continuous field of colour which ensures that the plot is perceived as a single visual entity.

It's also possible to control individual components of each theme, like the size and colour of the font used for the y axis. Unfortunately, this level of detail is outside the scope of this book, so you'll need to read the [plotnine book](https://amzn.com/331924275X) for the full details. You can also create your own themes, if you are trying to match a particular corporate or journal style.

## Saving your plots

There are two main ways to get your plots out of Python and into your final write-up: `ggsave()` and knitr. `ggsave()` will save the most recent plot to disk:

  <!-- ```{python, fig.show="none"} -->
  <!-- ggplot(mpg, aes("displ", "hwy")) + geom_point() -->
  <!-- ggsave("my-plot_pdf") -->
  <!-- ``` -->
  <!-- ```{python, include=FALSE} -->
  <!-- file_remove("my-plot_pdf") -->
  <!-- ``` -->

  If you don't specify the `width` and `height` they will be taken from the dimensions of the current plotting device. For reproducible code, you'll want to specify them.

Generally, however, I think you should be assembling your final reports using R Markdown, so I want to focus on the important code chunk options that you should know about for graphics. You can learn more about `ggsave()` in the documentation.

### Figure sizing

The biggest challenge of graphics in R Markdown is getting your figures the right size and shape. There are five main options that control figure sizing: `fig.width`, `fig.height`, `fig.asp`, `out.width` and `out.height`. Image sizing is challenging because there are two sizes (the size of the figure created by Python and the size at which it is inserted in the output document), and multiple ways of specifying the size (i.e., height, width, and aspect ratio: pick two of three).

I only ever use three of the five options:

  * I find it most aesthetically pleasing for plots to have a consistent
width. To enforce this, I set `fig.width=6` (6") and `fig.asp=0.618`
  (the golden ratio) in the defaults. Then in individual chunks, I only
  adjust `fig.asp`.

* I control the output size with `out.width` and set it to a percentage
  of the line width. I default to `out.width="70%"`
  and `fig.align="center"`. That give plots room to breathe, without taking
  up too much space.

* To put multiple plots in a single row I set the `out.width` to
  `50%` for two plots, `33%` for 3 plots, or `25%` to 4 plots, and set
  `fig.align="default"`. Depending on what I'm trying to illustrate (e.g.
  show data or show plot variations), I'll also tweak `fig.width`, as
  discussed below.

If you find that you're having to squint to read the text in your plot, you need to tweak `fig.width`. If `fig.width` is larger than the size the figure is rendered in the final doc, the text will be too small; if `fig.width` is smaller, the text will be too big. You'll often need to do a little experimentation to figure out the right ratio between the `fig.width` and the eventual width in your document. To illustrate the principle, the following three plots have `fig.width` of 4, 6, and 8 respectively:

```{python, include=FALSE}
plot = ggplot(mpg, aes("displ", "hwy")) + geom_point()
```
```{python, fig.width=4, echo=FALSE}
plot
```
```{python, fig.width=6, echo=FALSE}
plot
```
```{python, fig.width=8, echo=FALSE}
plot
```

If you want to make sure the font size is consistent across all your figures, whenever you set `out.width`, you'll also need to adjust `fig.width` to maintain the same ratio with your default `out.width`. For example, if your default `fig.width` is 6 and `out.width` is 0.7, when you set `out.width="50%"` you'll need to set `fig.width` to 4.3 (6 * 0.5 / 0.7).

### Other important options

When mingling code and text, like I do in this book, I recommend setting `fig.show="hold"` so that plots are shown after the code. This has the pleasant side effect of forcing you to break up large blocks of code with their explanations.

To add a caption to the plot, use `fig.cap`. In R Markdown this will change the figure from inline to "floating".

If you're producing PDF output, the default graphics type is PDF. This is a good default because PDFs are high quality vector graphics. However, they can produce very large and slow plots if you are displaying thousands of points. In that case, set `dev="png"` to force the use of PNGs. They are slightly lower quality, but will be much more compact.

It's a good idea to name code chunks that produce figures, even if you don't routinely label other chunks. The chunk label is used to generate the file name of the graphic on disk, so naming your chunks makes it much easier to pick out plots and reuse in other circumstances (i.e. if you want to quickly drop a single plot into an email or a tweet).

## Learning more

The absolute best place to learn more is the plotnine book: [_plotnine: Elegant graphics for data analysis_](https://amzn.com/331924275X). It goes into much more depth about the underlying theory, and has many more examples of how to combine the individual pieces to solve practical problems. Unfortunately, the book is not available online for free, although you can find the source code at <https://github.com/hadley/plotnine-book>.

Another great resource is the plotnine extensions guide <http://www.plotnine-exts.org/>. This site lists many of the packages that extend plotnine with new geoms and scales. It's a great place to start if you're trying to do something that seems hard with plotnine.
