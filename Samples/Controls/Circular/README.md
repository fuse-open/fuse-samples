# Circular layout and range controls

This example creates a time picker using the `CircleLayout` and `RangeControl2d`. It includes an `Attractor` and an interaction transition to show how to combine these elements together.

Click on a hour/minute to select, or click and drag. Once you select an hour it will transition to the minutes screen. Click on the hour in the top display to go back to the hour selection.

The control `RangeControl2D` is a pure semantic control, and does nothing on its own. The standard `CircularRangeBehavior` maps a section of circle onto the two values of that control. For normal `RangeControl` it maps only one value.  For the hour hands note the use of `UserStep="1,1"` to quantize the selection on both axis.

On `CircleLayout` even though we have a full 360° we're using `StartAngleDegrees` and `EndAngleDegrees`. This allows us to specify the children in normal clock order, and gives an example of those properties.