# Pizza Selection Examples

This example demonstrates the various aspects of the selection API by means of a pseudo-pizza delivery app.

## Radio Buttons

![Radio buttons](https://github.com/fusetools/fuse-samples/blob/master/Samples/Controls/Selection/gifs/radio-buttons.gif)

`PizzaPage.ux` is a radio button style control: only one pizza can be selected at a time. This basic behaviours is created by setting both `MinCount` and `MaxCount` on the selection to `1`:

	<Selection ux:Name="pizzaSel" MinCount="1" MaxCount="1" />

A `PizzaType` class is created to make it easier to create all the items in the selection. The `Selectable` behavior is what makes the item selectable:

	<Selectable Value="{ReadProperty Title}" />
	
`Selection` and `Selectable` are the two key types that work together in creating a selection control.

The button to go to the next page doesn't appear until an item is selected. This simple behavior is done by using the `Selection.Value` in a `WhileString` trigger.

	<WhileString Value="{ReadProperty pizzaSel.Value}" Test="IsNotEmpty">
	
	
## Multiple Selection	

![Multiple selection](https://github.com/fusetools/fuse-samples/blob/master/Samples/Controls/Selection/gifs/multiple.gif)

`ToppingsPage.ux` allows the user to select up to 3 additional ingredients. This basic behavior is a `MaxCount` on the `Selection`:

	<Selection Values="{sel}" MaxCount="3" />
	
You can also see that we are binding `Values` to the `sel` JavaScript observable. This creates a two-way binding for all the selection values. This example code simple monitors for changes and updates the `current` observable with the current list of items.

`Selected` and `Deselected` are used to create animations when items are added or removed from the selection.


## Dropdown Selection

![Dropdown](https://github.com/fusetools/fuse-samples/blob/master/Samples/Controls/Selection/gifs/dropdown.gif)

`PaymentPage.ux` shows how to create a dropdown list of options from a JavaScript array.

`PaymentPage.js` defines the high-level JavaScript array `paymentOpts`. This is your state-level, or model, data associated with the payment options. It uses the `mapOptions` to convert the list to something suitable for our `ComboBox` class.

The `payment` observable is the currently selected payment item. Since we created this value from the key in the `paymentOpts` structre we can use it directly as a lookup to get our original data structure: `var q = paymentOpts[payment.value].desc`.
