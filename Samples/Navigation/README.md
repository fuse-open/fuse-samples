# Navigator Demo App

This example demonstrates how to combine several pages and components into a single application. The `Navigator` is used for routing, with external data loading being simulated in the JavaScript. _The app is non-functional beyond just navigating between pages._

The JS files in the `App` directory are part of the global application state and logic. They are listed as `Bundle` in the `.unoproj` file. Each place that requires them will get a same copy of that module, thus enabled the sharing of data.

The `state.js` file exports a `loading` property. This is used by other pages to report that they are logically loading some data. It is used in a trigger on the main page to display a loading animation. In this example the loading delays are artificial; in a real app you'd set/reset this flag will fetching external data.

The various navigator pages use a combination of standard and custom animations per page. The result in this app is a bit exaggerated as a means to show off the options.

The top-level is wrapped in an `EdgeNavigator` to provide a left swipe-in menu.
