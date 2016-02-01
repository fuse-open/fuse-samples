# Fuse User Events

Fuse User Events are intended for sending messages between components of your application. They may be sent and received from UX, Uno, and JavaScript.

## Declaring an event

User events are attached to the node from where they are raised. For example:

	<App>
		<UserEvent Name="Chatty.GotoContacts"/>
		...

This creates an even with the name `Chatty.GotoContacts`. By putting this `UserEvent` in `App` we are essentially making it an app-wide event, since every child of `App` can raise and respond to this event.

## Raising and responding to the event

To raise an event from UX use the `RaiseUserEvent` action. You might for example put this in a `Clicked` handler on a button.

```
<Button Text="Contacts">
	<Clicked>
		<RaiseUserEvent Name="Chatty.GotoContacts"/>
	</Clicked>
</Button>
```

In another UX file you can then respond to this event using the `OnUserEvent` trigger. To continue our example we'll set a new active page for navigation.

```
<OnUserEvent Name="Chatty.GotoContacts">
	<Set Navi.Active="PageContacts"/>
</OnUserEvent>
```

## Arguments

Arguments can be added to the messages using `UserEventArg`.

```
<RaiseUserEvent Name="Chatty.GotoChat">
	<UserEventArg Name="user" StringValue="Tom"/>
</RaiseUserEvent>
```

The receiving side can read these values in JavaScript (or Uno) by attaching a handler. This is a simple JavaScript handler:

```
<OnUserEvent Name="Chatty.GotoChat" Handler="{gotoChat}"/>
```

```
var gotoChat = function(args, o) {
	console.log(args.user)
}
```

## Raising from JavaScript

Events can be raised from JavaScript by using the `FuseJS/UserEvents` module.

```
var UserEvents = require("FuseJS/UserEvents")

UserEvents.raise( "Chatty.JSGotoContacts" )

UserEvents.raise( "Chatty.JSGotoChat", {
	user: "Tom"
})
```

### Global filter

At the moment events raised from JavaScript are global only, and not associated with a node (we have an issue to correct this). Thus to respond to an event from JavaScript you need to put a global filter on the handler:

```
<OnUserEvent Name="Chatty.JSGotoContact" Filter="Global">
	...
</OnUserEvent>
```

This filtering can be used anyway. It allows an event listener to hear events that do not belong to one of its ancestor Nodes. Placing events at the `App` level is preferred when possible.
