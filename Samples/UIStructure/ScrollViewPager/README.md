# Endless scrolling list

An example of an endless list of items in a @ScrollView that is efficiently paged by a @ScrollViewPager.

As you scroll down new items will be loaded to keep the list populated. If you scroll fast enough you will see the placeholder loading symbol (you've reached the end before more could be loaded).


## ScrollViewPager

The @ScrollViewPager takes care of the paging of data and requesting more be loaded:

	<ScrollViewPager Each="theEach" ReachedEnd="{loadMore}" ux:Name="svp"/>

This behavior continually modifies the `Offset` and `Limit` properties of the `Each` in order to keep a limited number of items active but also allow normal user scrolling.

It also provides a way to load more data via the `ReachedEnd` function, which is called when the user scrolls near enough to the end of the item list. A `ReachedStart` is also provided if loading should happen in the other direction. It's possible to use this control without these events: it still provides an efficient paging of large static lists.


## The Placeholder

When you scroll to the bottom fast enough you'll reach the `Placeholder` element. This is enabled so long as the `isLoading` variable from JavaScript is `true`, indicating that more data is currently loading.

	<WhileTrue Value="{isLoading}">
		<Panel LayoutRole="Placeholder" Height="100" Color="#AFA">

The `LayoutRole="Placeholder"` works with the `LayoutMode="PreserveVisual"` on the @ScrollView. This layout mode allows items to be added/removed without the visible items moving around. This works by automatically picking an item that should remain visible. Placeholder items are never picked -- this ensures that this isn't the element that stays in place.


## Each.Reuse

Because the @ScrollViewPager will continually added and remove items from the @Each we add the `Reuse="Frame"` property. When an old item is removed from the list and a new item is added in the same frame it will reuse the same @Visual. This avoids the destruction of the old visual and rooting of a new one.
