# Swipe Gesture

This demo uses the `SwipeGesture` to produce actions typical of an item list on mobile. Swipe left and right to reveal actions.

On a left swipe the delete action is exposed. Note the use of `WhileSwipeActive` to display the dynamite icon when the right action panel is open. We also use `Swiped` with `How="ToInactive"` to modify the background color of the item when this panel is closed.

On a right swipe a "Mystery" icon is revealed. In this demo this icon performs no action, but should pulse and change color when revealed: that is done by the `Swiped` trigger.
