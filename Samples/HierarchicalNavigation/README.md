# HierarchicalNavigation

HierarchicalNavigation creates a navigation which has a history. As new pages are added to the navigation history (through the `NavigateTo` action), we can use the `GoBack` action to go back one navigation step.

Pages has a Title property which we can use to name each page. We can then use a page-binding ({Page property}), so get the `Title` property from the current page.
Notice that we set the `Navigation` property of the top bar to the `DirectNavigation` which we define further down.


It is important to notice that we set `ux:AutoBind="false"`, for all pages but the first. This is because they should be added later as we navigate. If we didn't to this, they would all be added to the navigation, and we would start out with a non-empty navigation history.
