var Observable = require("FuseJS/Observable");

function Message(from, time, text, dock) {
	this.from = from;
	this.time = time;
	this.text = text;
	this.dock = dock;
}

var messages = Observable(
	new Message("Pet", "3:55pm", "Meow", "Right"),
	new Message("Pet", "3:55pm", "Meow", "Right"),
	new Message("You", "3:55pm", "Hi buddy! You're so cuuute :)", "Left"),
	new Message("Pet", "3:58pm", "*inquisitive head tilt*", "Right"));

var message = Observable("");

function sendMessage() {
	if (message.value !== "")
	{
		messages.add(new Message("You", "4:00pm", message.value, "Left"));
		message.value = "";
	}
}

module.exports = {
	messages: messages.map(function(message) {
		return {
			info: message.from + " at " + message.time,
			text: message.text,
			dock: message.dock
		};
	}),

	message: message,
	sendMessage: sendMessage,
	canSendMessage: message.map(function(value) {
		return value !== "";
	})
};