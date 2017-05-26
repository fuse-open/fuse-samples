# A variety of charting examples

A collection of charts built using the charting API. They all use @Plot as their core element but vary in the way they present the data.


## AttractorConfig, attract

Several of the charts use animation. Animation requires an @AttractorConfig to be assigned to an `Attractor` property. The config object is also an argument to the `attract` function. A few examples here use this to present animations not covered by an `Attractor` property.

Examples using `Attractor`:

- BarChart.ux
- DoubleBarChart.ux
- NegHorzLine.ux

Examples also using `attract`:

- MixedBarChart.ux
- MixHorzLine.ux
- PieChart.ux
- ScatterPlot.ux

The `AttractorConfig` should have a `Unit="Normalized"` for the `Attractor` property.


## PlotArea and Plot stepping

A few examples use the @PlotArea feature to create a responsive display.

These examples use a data window and step through the data:

- HorzLine.ux
- QuarterGroups.ux

These examples adjust the number of labels or axis lines, but always show the same amount of data:

- ScatterPlot.ux


## Pie chart

The `PieChart.ux` example shows how to construct a pie chart in the charting API.

The @PlotWedge is the basic object used to create the individual segments of the pie chart. The example also overlays the Z-data as an arc on those wedges. The example also shows how to use the "weight" information from the plot to construct the wedge segments.

Note the use of a `VectorLayer` on this example. Elliptical shapes are costly to draw on their own and should be collected into a group. The `VectorLayer` is for efficiency, which is important if we're animating the chart.

The `SpiderChart.ux` uses some of the same features as the pie chart. Instead of creating wedges though it uses angular point information to create a curve. Note the `Style="Angular"` and `AngularFull` on the components.


## Stacked bar chart

The `StackedBarChart.ux` example shows how to construct a stacked bar chart. The images are used to show that region of the stacked bars -- we don't recommend such a crazy visual design. You can use a plain @Panel in place of the graphics.

The @DataSeries in this chart as marked with `Metric="Add"`, to configure the calculation needed for the stacking information. It adds together the series data as well as recording the start/end ranges for each bar. The @PlotBar uses this range information when given the `Style="Range"` property.


## Selectable graph bars

The `FullBarChart.ux` example uses the Selection API to make elements of the graph selectable. 

A @Selectable is added to both the @PlotData visuals and the @PlotAxisData bits. _The duplicate `Selectable` is an experimental use of the selection API, and the exact syntax may change._


## Grouped labels

The `QuarterGroups.ux` example shows how to create X-axis labels that span several data points.

`PlotAixs` with `Group="3"` creates the actual groups. The grouping starts at the first item in the source data, but the labels only show the visible data. If we stepped to `Offset="1"` the first label would then disappear, since it's no longer part of the shown data. This is why we use `DataExtend="3,1"` on the `Plot`. It keeps additional data, outside the visible range,  for use by `PlotAxis` and `PlotData`, effectively allowing it to enumerate data that isn't in view. We must then take care to use `ClipToBounds="true"` appropriately, otherwise, plot visuals will overlap other elements.


## Scatter plot

The `ScatterPlot.ux` example provides explicit data for both the X and the Y axis. `XAxisMetric="Range"` overrides the default for the X-axis.

This example also encodes size information the Z-axis.


## Vertical Orientation

By default, @Plot is assuming a horizontal layout of the bars or line. The orientation can be adjusted using the `Orientation="Vertical"` property. This transposes the layout, putting the X-axis along the vertical and the Y-axis along the horizontal.

These examples use a vertical orientation:

- BarChart.ux
- VertRanges.ux

_Note that `VertLine.ux` also achieves a vertical orientation but in a much different way. It's not the recommended approach if a simple transpose is desired._
