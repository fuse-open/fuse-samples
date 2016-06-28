# Facebook login using foreign code

This sample shows how we can get Facebook login working with Fuse using the
Facebook Android and iOS SDKs.
It is part of the tutorial over at [https://www.fusetools.com/docs/native-interop/facebook-login](Fuse's docs page),
so head over there if that's not where you came from!

The main login functionality is implemented in the `FacebookLogin` Uno project
in the `FacebookLogin` folder.

## Setup

You will need to [register for a Facebook App ID](https://developers.facebook.com/docs/apps/register)
and fill it in as `Facebook.AppID` in `FacebookAppId.uxl`.

## Building

To build for Android, we need to enable Gradle. The Facebook SDK for Android
dependency will then be handled automatically by Gradle.

Use e.g. `uno build --target=Android -DGRADLE --run`.

To build for iOS, you currently have to download the Facebook SDK for iOS
manually. It needs to be extracted in `FacebookSDKs-iOS` in the current folder.
