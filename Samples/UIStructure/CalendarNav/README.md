# Calendar Navigation

This example creates a calendar component that allows navigation between months and viewing individual days.


## CalendarView

The `CalendarView` folder is structured like a component you'd put into an existing application. It works with a global `Router` but uses relative routes during navigation.

The navigator in `MainView.ux` contains only this component. This shows how such a component might be included at a particular location in your app.


## Bookmarks

Router bookmarks are being created to point the previous and next month. This happens anytime a `MonthView` is activated, in the JavaScript code. Using a bookmark lets us construct a complex route in JavaScript and then use it simply in the UX code.

For example, the previous month button navigates to one of our stored bookmarks:

	<RouterModify Bookmark="prevMonth" Style="fromLeft"/>
	

## NavigatorSwipe

The ability to swipe to the previous and next month is provided by `NavigatorSwipe` in `CalendarView.ux`. 

For example, this is the code to go to the next month:

	<NavigatorSwipe Direction="Left" How="GotoBookmark" Bookmark="nextMonth"
		Style="fromRight" IsEnabled="false" ux:Name="swipeLeft"/>

Notice that it is disabled by default. We have a `WhilePageActive` in the same file that enables it.

	<WhilePageActive NameEquals="month" Threshold="0">
	
This ensures this swiping behaviour is only active while the user is actually in the month view. If any other page is active it will be disabled.


## Transition Style

The `RouterModify` and `NavigatorSwipe` are both using a `Style` parameter. This lets us distinguish how the user is navigating to create specific left/right animations.

The style is matched inside the `Transition` animations of `MonthView`. For example, the navigation of the next month to the active one:

	<Transition Style="fromLeft" Direction="ToActive">
		<Move X="-1" RelativeTo="ParentSize" Duration="0.4" Easing="SinusoidalInOut"/>
	</Transition>

Notice in that file we need to actually define four transitions to cover all the month-to-month navigation we have. Half of them could be avoided if `Transition` allowed for an "or" condition, but at the moment it does not.
