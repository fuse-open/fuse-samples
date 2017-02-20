# A modal confirmation screen

This example shows how to create a modal confirmation screen by using the `AlternateRoot` feature.

The basic concept is to declare where you'd like to add a modal child. In this example we declare the `FullWindow` panel that occupies the full screen space of the app. Then we attach it to a resource named the same using `ResourceObject`.

On the `OtherPage.ux` the `AlternateRoot` has a `ParentNode="{Resource FullWindow}"`. This says the child of this `AlternateRoot` will become children of the `FullWindow` panel. This allows us to keep our confirmation code local to where it's used, but place the actual UI elsewhere in the tree.
