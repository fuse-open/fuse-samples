# Transition Example

This example shows a variety of page transitions during navigation using the `Transition` behaviour.


## MainPage

The MainPage is used for the navigation in the top, left, bottom, and right directions. Each one has a matching transition, such as:

	<Transition To="Left">
		<Move X="1" RelativeTo="ParentSize" Duration="0.4" Easing="CubicInOut"/>
	</Transition>
	
The `To="Left"` limits this transition to being used when going to the "Left" page. Note that this transition will also be used if we are going back from the "Left" page. This additional matching on the backward direction allows us to write only the one direction and have a useful result.

The `Left` page itself adds a default transition:

	<Transition>
		<Move X="-1" RelativeTo="ParentSize" Duration="0.4" Easing="CubicInOut"/>
	</Transition>

When the page first appears no other `Transition` matches so this one will be used. It's good to always have a final default `Transition`. If you don't have one and no other `Transition` matches, the default one from the `Navigator` will be used.


## BottomRight

The `MainPage` has a simple rotation transition to the `BottomRight`.  The different animations to and from this page are simply different `Easing` and `EasingBack` properties. For example the `BottomRight` itself has this `Transition`:

	<Transition>
		<Rotate Degrees="90" DurationBack="1.4" EasingBack="BounceIn"
			Duration="0.4" Easing="CubicOut"/>
	</Transition>


## TopLeft

The `TopLeft` has distinct transitions to and from the page. This creates the effect of rotating only in one direction. 

For `MainPage` this is specified as:

	<Transition To="TopLeft" Direction="ToInactive">
		<Change this.ExplicitTransformOrigin="0%,0%"/>
		<Rotate Degrees="90" Duration="0.4" Easing="CubicOut"/>
	</Transition>
	<Transition To="TopLeft" Direction="ToActive">
		<Change this.ExplicitTransformOrigin="0%,0%"/>
		<Rotate Degrees="-90" Duration="0.4" Easing="CubicIn"/>
	</Transition>

`Direction="ToInactive"` limits the transition to being used only when the main page is becoming inactive (and also going to the `TopLeft` in this case). The `ToInactive` direction limit means this transition will only ever play forward, never backward. Similarily, the second transition with `Direction="ToActive"` will never be played forward, only backward. `Transition` always specifies the change to the inactive state; the direction it plays thus depends on whether a page is becoming active or inactive.


## PopupBottom

The `PopupBottom` leaves the main navigation visible. To make this work we need to adjust the default release behavior of the page.

	<Transition To="PopupBottom" AutoRelease="false">

Normally a `Transition` will release the page when it reaches completion (the 100% progress). The `AutoRelease="false"` here turns off this behaviour when transitioning to the `PopupBottom` page.

What happens to released pages depends on the `Navigator` settings. Ours has `Remove="Released"` that means released pages will be removed as children. This keeps the number of rooted pages quite low to improve performance.


## PopupTop

The `PopupBottom` in turn uses `AutoRelease="false"` when transitioning to the `PopupTop` page:

	<Transition To="PopupTop" AutoRelease="false"/>

Note that this `Transition` doesn't define any animators, it will leave the page exactly as is. The `PopupTop` pages will occupy the space at the top of the app, and the `PopupBottom` remains functional. Be aware this is an advanced layout: getting the layering, Z-ordering, and hit testing working correctly can be complex.

The `PopupTop` page  uses a combination of three transitions. When a new one is created it slides from the right. It is pushed left when going forward. When popped off the top of the history it expands and disappears.

The key to this behaviour are these two transitions:

	<Transition Direction="FromFront">
		<Move X="1" RelativeTo="ParentSize" Duration="0.4" Easing="SinusoidalInOut"/>
	</Transition>
	<Transition Direction="ToFront">
		<Scale Factor="2" Duration="0.4"/>
		<Change PopupTop.Opacity="0" Duration="0.4"/>
	</Transition>

The `Direction="FromFront"` transition will only match when the page is coming from in front of the current page. This direction only ever plays backward. The `ToFront` trigger in contrast only plays when moving in front of the current page, which happens with `router.goBack()`.

Sliding to the left is done as a fallback transition:

	<Transition AutoRelease="false">
		<Move X="-0.25" RelativeTo="ParentSize" Duration="0.4" Easing="SinusoidalInOut"/>
	</Transition>

Note the use of `AutoRelease="false"` again. Since these pages should remain visible when inactive we need to prevent them from being released.

Despite having many pages on-screen, only one is ever actually the active page. The title bar uses a `{Page Title}` binding to show the title of the active page.


## SlideTop

The `SlideTop` page doesn't have a fallback `Transition` specified. It only specifies what happens when it comes from the `Main,Left, Right,Top,Bottom` pages.

	<Transition From="Main,Left,Right,Top,Bottom">
		<Move Y="-1" Duration="0.3" RelativeTo="ParentSize" Easing="SinusoidalInOut"/>
	</Transition>

The `Next SlideTop` button creates a new `SlideTop` pages coming from the current one. This doesn't match the above trigger. In such a case the default `Navigator.Transition` will be used.
