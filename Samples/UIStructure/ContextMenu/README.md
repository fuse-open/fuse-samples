# Context sensitive status indicators

This examples shows how to add context-sensitive elements to a title bar and status bar. Each `Page` in the navigation uses `AlternateRoot` to add an item local to that page.

The first page uses a `WhileActive` trigger to add a button to the title bar while that page is active. This could be used for a share menu, or other context sensitive activity.

The second page adds an indicator to the status bar if the `Switch` is on. This persists outside of this page, remaining on the status bar so long as the switch remains on.