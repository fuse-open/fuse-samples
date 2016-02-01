# Taking pictures from JavaScript

In this example, we will take a photo by using the device camera from JavaScript. We will then display the captured image in an `Image` element.

To take a picture, require the FuseJS/Camera API, and call Camera.takePicture like so:

```
var Camera = require('FuseJS/Camera');
Camera.takePicture({targetWidth: 1080, targetHeight: 1920}).then(function(file){
    image.value = file;
});
```
`takePicture` returns an `Observable` that will contain a file object once the picture is taken. When this happens, we can bind the `File` property of an `Image` in ux to an `Observable` we export from JS, called `image`.

* Note: The targetWidth and targetHeight are just hints, the returned image can be any size.

You can find the official Camera API documentation [here](https://www.fusetools.com/learn/fusejs#camera).

## The UX

```
<App Theme="Basic">
	<DockPanel>
		<Style>
			<Text TextAlignment="Center" />
		</Style>
		<JavaScript File="MainView.js" />
		<StatusBarBackground Dock="Top"/>
		<StackPanel Dock="Fill">
			<Text FontSize="32">Camera example</Text>
			<Button Text="Take picture" Clicked="{takePicture}" />
			<Image File="{image}"/>
		</StackPanel>
	</DockPanel>
</App>
```

## The JavaScript

```
var Camera = require('FuseJS/Camera');
var Observable = require('FuseJS/Observable');

var image = Observable();
function takePicture() {
    Camera.takePicture({targetWidth: 1080, targetHeight: 1920}).then(function(file){
	image.value = file;
    });
}

module.exports = {
    takePicture: takePicture,
    image: image
};
```
