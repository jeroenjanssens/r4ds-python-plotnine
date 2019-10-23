<!-- START_HIDE_IPYNB -->
```{python, eval=FALSE}

```

<div class="flex flex-wrap md:flex-row mb-4">
<div class="mx-auto md:w-1/2 px-8">
```{python, echo=FALSE, out.extra = ""}

```
</div>
<div class="mx-auto md:w-1/2 px-8">
```{python, echo=FALSE, out.extra = ""}

```
</div>
</div>
<!-- END_HIDE_IPYNB -->
<!-- START_HIDE_MD -->
```{python}
```
<!-- END_HIDE_MD -->



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
