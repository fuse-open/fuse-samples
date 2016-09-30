# Storing local data

In this example, we will write a simple app that stores a user-entered string, and fetches it on the next startup, displaying it for the user.

To get started, we need to import the `Storage` module using `require`. Then, you can read a file using `Storage.read`:

```
var Storage = require("FuseJS/Storage");
Storage.read(SAVENAME).then(function(content) {
    var data = JSON.parse(content);
    welcomeText.value = "Stored data: "  + data.message;
}, function(error) {
    welcomeText.value = "There is currently no local data stored";
});
```
If the read is a success, the first function will be called with the result of the read. In this example, we update the value of a `Text` so it contains our message. However, if something goes wrong, the second function will be called with an error message.

To save, we call `Storage.write` with a file name and a string to save. Note that this operation overwrites whatever is already in the file.


```
function saveMessage() {
    var storeObject = {message: message.value};
    Storage.write(SAVENAME, JSON.stringify(storeObject));
}
```

We use JSON because it is a very handy method of serializing data in a way that is quick and easy for us to reach in our JavaScript code, as we can simply parse JSON objects to JavaScript objects. While this example could of stored the message directly to a file, using JSON gives us a lot more flexibility in terms of what we store.


## Download example

## The JavaScript

```
var Observable = require("FuseJS/Observable");
var Storage = require("FuseJS/Storage");

var SAVENAME = "localStorage.json";

var welcomeText = Observable("Loading...");
var message = Observable("");
var hasStored = Observable(false);
debug_log("Js initialized");

Storage.read(SAVENAME).then(function(content) {
    var data = JSON.parse(content);
    welcomeText.value = "Stored data: "  + data.message;
}, function(error) {
    //For now, let's expect the error to be because of the file not being found.
    welcomeText.value = "There is currently no local data stored";
});

function saveMessage() {
    var storeObject = {message: message.value};
    Storage.write(SAVENAME, JSON.stringify(storeObject));
    hasStored.value = true;
}

module.exports = {
    welcomeText: welcomeText,
    message: message,
    saveMessage: saveMessage,
    hasStored: hasStored
};

```

## The UX

```
<App>
    <StackPanel>
		<JavaScript File="MainView.js" />
		<Text FontSize="42" Value="Hello!" TextAlignment="Center"/>
		<Text FontSize="24" Value="{welcomeText}" TextAlignment="Center" TextWrapping="Wrap" />
		<Panel>
			<StackPanel ux:Name="enterTextArea" Opacity="0">
				<Text FontSize="20" TextAlignment="Center" Margin="0, 20, 0, 0">Store a message?</Text>
				<TextInput Value="{message}"/>
				<Button Clicked="{saveMessage}" Text="Save" />
				<WhileFalse Value="{hasStored}">
					<Change enterTextArea.Opacity="1" Duration="0.2" />
				</WhileFalse>
			</StackPanel>
			<StackPanel ux:Name="textSubmittedArea" Opacity="0">
				<Text TextAlignment="Center" FontSize="24" Margin="0, 20, 0, 0" TextWrapping="Wrap">The string has been saved</Text>
				<WhileTrue Value="{hasStored}">
					<Change textSubmittedArea.Opacity="1" Duration="0.2" Delay="0.2"/>
				</WhileTrue>
			</StackPanel>
			</Panel>
    </StackPanel>
</App>

```
