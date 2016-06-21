# Taking pictures from JavaScript

This example uses the FuseJS Camera, ImageTools and CameraRoll APIs to acquire and manipulate images from JavaScript.

Basic Camera use is simple:
```
var Camera = require('FuseJS/Camera');
Camera.takePicture(/* target width */ 1080, /* target height */ 1920}).then(function(newImage){
    image.value = newImage.path;
});
```
`takePicture` returns a `Promise` that will resolve to an object of image info once the picture has been taken.
We can then get the `path` property of that object and use it to display the image.

* Note: The target width and target height in this scenario are used to determine bounds for an aspect-corrected resize.
The dimensions of the returned image can differ if the original aspect is different.

The sample js is extensively commented and goes through some somewhat arbitrary use cases.

You can find the official Camera API documentation [here](https://www.fusetools.com/learn/fusejs#camera).
