# GitHub login

This sample shows how you can use the FuseJS/InterApp package to log in with GitHub. Make sure you follow the setup step described below.

## Setup

To run the sample, you first need to create an application at github.com/settings/applications. Then copy your Client ID and Client Secret to their spots in Auth.js.

## Running the app

When the app starts, click the login button. It will open a web browser prompting you to authorize your GitHub account. After successfully logging into GitHub, the web browser will redirect back to the app with the access token. Press the "Get repos" button to load your repositories.

* Note: In this example we actually embed the client secret in the Auth.js file. This might not be a good idea for a production app, but is done here for simplicity.
