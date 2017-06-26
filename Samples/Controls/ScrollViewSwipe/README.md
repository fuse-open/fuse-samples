# Scroll swipe to reveal header

Creates a swipe-to-reveal header in a ScrollView. The header is visible both when the user scrolls down and when the ScrollView is scrolled to the top.


## Combining gestures 

A `SwipeGesture` is added directly in a `ScrollView` to provide an active drawer for the header. This works because the implicit gesture controlling the scrolling and the `SwipeGesture` are both on the same node and are allowed to share input. 

A `SwipingAnimation`, named `swipeAnim`, is added to monitor the gesture. This is normally where the reveal part oft he gesture would be done, but it won't be enough, so we leave it as an empty gesture. We want the header to be visible also if the user scrolls to the top without invoking the gesture, such as by pressing the scroll to top button.

We add a `ScrollingAnimation`, named `scrollAnim`, that covers the region occupied by the header view. It again is left empty. Ttriggers have progress even if they don't contain any animators or actions.

The `headerPanel` has a `Translation` controlling whether it is revealed or hidden. We want this to be revealed when the users swipes down or when the `ScrollView` is at the top. We use a `max` expression that takes the higher progress of `swipeAnim` and `scrollAnim`.


## Header spacing

At the top of the `StackPanel` we have a `Panel` reserving height for the `headerPanel`. It uses an expression to assign itself height, leaving a bit of space for the divider.

By reserving the space we simplify the task of hiding/revealing the header. It allows the small `headerPanel` to be an overlay on the `ScrollView` at any scroll position, but also to appear above the scroll contents when scrolled to the top.
