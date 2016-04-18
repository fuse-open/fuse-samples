# Pan, Zoom, and Rotate gestures

This demo creates a simple image viewer that uses `ZoomGesture`, `RotateGesture` and `PanGesture`. It shows how to combine these with an `InteractiveTransform`.

The central type to these gestures is the `InteractiveTransform`. This contains the values that the gestures will actually be modifying. It also works as an actual transform on the element. The properties of `InteractiveTransform` are two-way bindable and thus can be used in multiple locations and read/written from JavaScript as well (not done in this demo).

Beside each gesture we also use an `Attractor`. This allows a fluid animation on the image when it needs to reset it's viewing size. This is used in two places: in the `DoubleTapped` trigger which resets the transform properties; and in the `WhileTrue ux:Name="ViewerVisible`, which resets when leaving the full-screen view.

`WhileFloat` is used to implement a shrink-to-dismiss mechanism. Note the use of `CancelInteractions` here. This is a special action with limited purpose. Here it is used because we know the user will be in the middle of a zooming operation when this trigger applies, thus we need to cancel the active gestures.

A gallery to full-screen animation effect is achieved with the `Timeline` trigger and `PulseBackward` action. Notice the two `Set` actions just prior to the `PulseBackward` which configure the transition.

The `WhileWindowPortrait` adjusts the layout based on the device's orientation. Note the sizing of the images int his demo are targetted towards a phone device -- the layout may appear crowded with a large display area.