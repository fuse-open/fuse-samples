# Accounting for the status bar and keyboard

While it might seem as a simple thing to make an app that runs on mobile devices, there are some considerations to be made, as the available screen real estate often changes as the user interacts with the app.

On Android and iOS, the OS will typically provide an on-screen status bar that limits how and where you can render your app. On Android, a lot of devices also use some of the area on the screen for navigation, such as back button, easy access to the home screen, and so on.

Also, the on-screen keyboard will be summoned when the user wants to interact with certain input fields.

Fuse has a number of ways to make it easy to create a responsive UI.

The main strategies are:

- Insert a `StatusBarBackground`; a control that will adopt the size of the status bar as needed
- Insert a `BottomBarBackground`; a control that will adopt whatever size the bottom of the screen the OS takes up, including navigation and on-screen keyboard
- Explicitly move controls in response to the on-screen keyboard explicitly by using the `KeyboardVisible`-trigger, and moving with `RelativeTo="Keyboard"`
- Use other strategies in response to the `KeyboardVisible`-trigger, like hiding controls, shrinking them and moving them

We'll look at all these approaches here.

## StatusBarBackground/BottomBarBackground

`StatusBarBackground` and `BottomBarBackground` are controls that responsively size themselves to match the areas occupied by OS on-screen controls. This means that you can easily influence your layout using them.

Looking at this example will make it easier to understand the effect of these controls.

<table>
    <tr>
		<td>
		    <img src="/Samples/OSUI/OS_UI/no_response.png" />
		</td>
		<td>
			<img src="/Samples/OSUI/OS_UI/respond.png" />
		</td>
		<td>
			<img src="/Samples/OSUI/OS_UI/response_with_keyboard.png" />
		</td>
	</tr>
</table>

As you can see, this has been captured on an Android device that uses on-screen navigation controls. In the first picture, the controls have been set to `Collapsed`, and the OS controls are obscuring the "Hello World!"-labels in the top and the bottom of the screen. Depending on where this code is run, only the bottom might be obscured (because the device has hardware navigation controls instead of on-screen) or nothing is obscured (because you are running it as a desktop application).

Toggling the "Change layout in response to OS?"-switch immediately makes the controls visible as seen in the second picture, as the switch makes the respective backgrounds go from `Collapsed` (which means "take up no space") to `Visible`, which means that they will take up the space needed to match the areas the OS has taken over.

In the third image, you can see that the bottom content is correctly responding to the summoning of the on-screen keyboard.

The code needed to get this effect is easy to describe with a single `.ux`-file:

```
<App Theme="Basic" ux:Class="OsUiMinimalExample">

	<DockPanel>
		<Style>
			<Text Margin="15,0,15,0" Alignment="HorizontalCenter" />
		</Style>

		<!-- The top section of the app -->
		<StatusBarBackground ux:Name="sbb" DockPanel.Dock="Top" Visibility="Collapsed" />
		<Text DockPanel.Dock="Top">Hello, world! I'm on the top of you.</Text>

		<!-- This is the main client area -->
		<ScrollViewer DockPanel.Dock="Fill">
			<StackPanel>
				<DockPanel>
					<Text Alignment="VerticalCenter"
					   DockPanel.Dock="Left">Type here:</Text>
					<TextInput Alignment="VerticalCenter" />
				</DockPanel>

				<StackPanel Alignment="HorizontalCenter" Orientation="Horizontal">
					<Text
					   Alignment="VerticalCenter">Change layout in response to OS?</Text>
					<Switch Alignment="VerticalCenter">
						<!-- Turn on all of our OS responsive controls -->
						<WhileToggled>
							<Change Target="sbb.Visibility" Value="Visible" />
							<Change Target="bbb1.Visibility" Value="Visible" />
							<Change Target="bbb2.Visibility" Value="Visible" />
						</WhileToggled>
					</Switch>
				</StackPanel>
				<Panel Height="50" />
				<Text TextWrapping="Wrap" ux:Name="Description">This example shows
				controls that are hidden by OS adornments, such as the status bar,
				navigation and keyboard. To make the app respond to these entities,
				toggle the "respond to OS switch". You can also try the text input
				field to see how it makes the app respond to the onscreen keyboard
				if your device has one.</Text>

				<!-- Fade out the description of the app when the keyboard is visible -->
				<KeyboardVisible>
					<Change Target="Description.Opacity" Value="0" Duration="0.5" />
				</KeyboardVisible>
			</StackPanel>
		</ScrollViewer>

		<!-- The bottom section of the app -->
		<Grid ColumnCount="2" Background="White" DockPanel.Dock="Bottom" >
			<StackPanel Alignment="Bottom">
				<Text TextWrapping="Wrap">Bottom 1</Text>
				<BottomBarBackground ux:Name="bbb1" Visibility="Collapsed" />
			</StackPanel>
			<StackPanel Alignment="Bottom">
				<Text TextWrapping="Wrap">Bottom 2</Text>
				<BottomBarBackground ux:Name="bbb2"
					Visibility="Collapsed" IncludesKeyboard="false" />
			</StackPanel>
		</Grid>
	</DockPanel>

</App>
```

In this example, we have two pieces of text in the bottom part of the screen, both affected by a `BottomBarBackground`. The one on the left will honor both on-screen navigation and move when the keyboard appears. The one on the right will honor anything _but_ the on-screen keyboard, because the `IncludesKeyboard`-property is set to false. This is very helpful in situations where the on-screen real estate becomes so small you need to cherry pick which controls are to be shown when there is less room.

## Using KeyboardVisible

In addition to changing layout with `StatusBarBackground` and `BottomBarBackground`, this example also fades out the description text by using a `KeyboardVisible`-trigger.

Note that it is possible to move contents in relation to keyboard size as a response to the `KeyboardVisible`-trigger. Typical usage of this is:

```
<KeyboardVisible>
	<Move RelativeTo="KeyboardSize" Y="-1" />
</KeyboardVisible>
```

This approach allows you to target more finely which elements you want to move as the keyboard appears.

As shown in the example, you can obviously fire off any trigger actions as the keyboard becomes visible, you are not limited to movement alone.

To make this possible, there is a trigger called `KeyboardVisible` which allows you to explicitly react to the summoning of the on-screen keyboard. As you can see, we can also move elements relative to the keyboard using `RelativeTo="Keyboard"`. In this example, we use the `BottomBarBackground` with `IncludeKeyboard` set to `false` on the terms and conditions string; this makes it honor the navigation panel but not act on the on-screen keyboard. Instead, we set the login-button to react to the `KeyboardVisible`-trigger, and simultaneously make the terms and conditions invisible:


As an added bonus, we've made the company logo fade out in concert with the onset of the on-screen keyboard for an added visual effect.

## Quickly fix existing code

If you notice that your app doesn't respond well to the facilities the OS provides on screen, the quickest way to fix this is to create a `DockPanel` that holds your current controls. Typically, your UX-file looks like this:

```
<App Theme="Basic" ux:Class="MyApp">
	<!-- Your app markup -->
</App>
```

You can change this to:

```
<App Theme="Basic" ux:Class="MyApp">
	<DockPanel>
		<StatusBarBackground DockPanel.Dock="Top" />
		<BottomBarBackground DockPanel.Dock="Bottom" />
		<!-- Your app markup -->

	</DockPanel>
</App>
```

This will insert these controls around your current app. If you already have a `DockPanel`, you can obviously insert the controls into the existing controls.

## Summary

Using the controls `StatusBarBackground`, `BottomBarBackground` and the trigger `KeyboardVisible` gives you fine grained control over how your UI responds to OS intrusions in the app real estate. We have also looked at how you can quickly make your app respond to on-screen keyboard in the common case.
