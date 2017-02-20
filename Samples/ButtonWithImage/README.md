# Creating a custom button with an image

This example shows two different ways to create a custom button that has an image and text as properties. Which approach you use depends on what is most convenient in your application.

## Using a File property

`MyButtonFile` shows how to expose a `FileImage` property. This works just like the `Image.File` property and a filename is provided directly.

	<MyButtonFile FileImage="cancel.png" Text="Cancel"/>
	
This approach is perhaps the easier to understand, but is less versatile.
	
## Using a ImageSource property

The `MyButtonSource` shows how to expose a `Image` property. This works just like the `Image.Source` property, thus supporting a variety use-cases.

You can create free `ImageSource` objects and use them:

	<FileImageSource File="cancel.png" ux:Name="iconCancel" ux:AutoBind="false"/>
	<MyButtonSource Image="iconCancel" Text="Cancel"/>
	
You can use the resource system:

	<FileImageSource File="cancel.png" ux:Key="IconCancel"/>
	<MyButtonSource Image="{Resource IconCancel}" Text="Cancel"/>
	
The resource system is also useful if you want to specify the button in JavaScript:

	<FileImageSource File="cancel.png" ux:Key="IconCancel"/>
	<JavaScript>
		var Observable = require("FuseJS/Observable")
		exports.useIcon = Observable("IconCancel")
		exports.useText = "Cancel"
	</JavaScript>
	<MyButtonSource Image="{DataToResource useIcon}" Text="{useText}"/>
	
You can also use global's if you want:

	<FileImageSource File="cancel.png" ux:Global="GlobalCancel"/>
	<MyButtonSource Image="GlobalCancel" Text="Cancel"/>
