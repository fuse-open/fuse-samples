# Vector Components

An example of several ways to use the various vector components.

## Jagged Line

A simple use a @Curve to draw straight line segments. The points are created in JavaScript as `x,y` pairs.

## Decorated Curve

Creates a @Curve with several @Circle elements overlaid on top. The data points are represented by a small object in JavaScript added to an @Observable.

## Tangent Line

Use the `CurvePoint.Tangent` property to adjust the shape a simple curve.

The sliders control the direction of the tangent and its strength.

## Elliptical Progress

Creates a speed gauge style progress control using @Arc and @Ellipse.

The slider controls the progress.

## Path Logo

Uses @Path to display the Fuse logo. The `Path.Data` for this was taken from an SVG file. This allows simple shapes to be drawn in a standard vector tool and then used in Fuse.

`Path` has the same sizing options as `Image`. It can be stretched to fill, or retain aspect ratio, based on the natural size of the path data.

## JavaScript Path

Assembles a `Path.Data` string in JavaScript, creating a checkerboard pattern. To display dynamic, or complex data, it may be desired to construct a path at runtime. We don't have an API abstraction for this quite yet, but that doesn't stop you from assembling the SVG data string for a @Path.

This example takes advantage of the stroke winding: it draws the cells in opposite direction to have them removed from the rectangle.