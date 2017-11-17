# Camera

This example uses the Fuse.Controls.Camera premium package

Basic Camera use is simple:
```xml
<CameraView ux:Name="_camera" />
<JavaScript>
	var Camera = _camera;
	Camera.capturePhoto()
		.then(function(photo) {
			photo.save()
				.then(function(filePath) {
					console.log("Photo saved to: " + filePath);
					photo.release();
				})
				.catch(function(error) {
					console.log("Failed to save photo: " + error);
					photo.release();
				});
		})
		.catch(function(error) {
			console.log("Failed to capture photo: " + error);
		});
</JavaScript>
```
`capturePhoto` returns a `Promise` that will resolve to an object representing the captured photo.
We can then save the photo to a file on disk. `save()` will return a `Promise` that resolves to a filepath.

#### Camera features implemented in this example
- Photo capture
- Capture preview with the special ImageSource provided by in the Camera API
- Video recording and preview.
- Changing capture mode
- Changing flash mode
- Dealing with Android specific photo settings

Please have a look at the official docs for complete API reference [here](https://www.fusetools.com/docs/fuse/controls/cameraviewbase).
