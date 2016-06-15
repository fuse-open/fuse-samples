# A component with custom events

This example creates a number pad entry component showing how to define and raise user events. It builds a second higher level component showing how to structure components into usable high-level controls.

## NumberPad

The core control is the `NumberPad` which defines a simple panel of 10 digits and two control actions. A user of this control will listen to the various events that it publishes. One such event is the `NumberSelected` event:

	<UserEvent ux:Name="NumberSelected"/>
	
When the user presses one of the numbers the JS code raises the event:

	NumberSelected.raise({ 
		number: args.data,
	})
	
The `number` is provided as a named argument. A listener to the event gets this value as an argument. For example, in the `MainView.ux` use it sets a text value to the number and pulses it's display.

	exports.selected = function(args) {
		exports.current.value = args.number
		OneShot.pulseBackward()
	}
	
### Convenience Triggers

For convenience the `NumberPad.ux` also defines a trigger for each of the events it raises. For example:

	<OnUserEvent ux:Class="NumberSelected" Name="NumberSelected"/>
	
This allows these events to be responded to in UX with a nice name instead of just having `OnUserEvent` everywhere. In `MainView.ux` the demo respnds to this event:

	<NumberPad>
		<NumberSelected Handler="{selected}"/>
	</NumberPad>
	
There is no need to define these custom triggers. You can use `OnUserEvent` directly with the appropriate `Name`. This may be more desirable if you have only one responder to a particular event.	

## NumberEntry

`NumberEntry` is a component that connects the `NumberPad` to a `Text` control. It demonstrates the `ux:Dependency` feature and shows how to handle all the messages from the `NumberPad`.
