# Navigation

Multi-level application navigation using an edge menu, a title area, an action bar.


## Structure

The first navigation level is created by a `EdgeNavigator` in `MainView.ux` to control the side menu. This doesn't participate in the `Router` navigation but instead uses signals.

`ApplicationTop.ux` creates the next levels of animation, it is the root level for the `Router`. All pages have a title bar; those in `home` have an additional action bar at the bottom.

The application uses `goto` to get to any page within `home` and `push` to get to all others. This limits the overall application depth to avoid confusing the user.


## Flights Page sub-navigation

The `FlightsPage.ux` has another level of navigation for "arrivals" and "departures". This is controlled via the router but exposed as more of a filter to the user at the top of the page. By making this proper router paths the side menu is able to navigate directly to either sub-page.


## Bookings sub-pages

The `BookingsPage.ux` displays a list of bookings (in a real app you'd obviously want to load this list). A top-right corner icon uses the router to `push` the `createBooking` page. Clicking on individual items will `push` the `booking` page for that item.

Note that only the `id` is passed to the `booking` page. That page is responsible for looking up information based on that id, usually via a common JavaScript module.
