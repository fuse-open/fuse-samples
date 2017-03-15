# Important info

This app do not work in preview on desktop since it require FuseJS/InterApp to launch a webbrowser.

# Azure Active Directory B2C OAuth login

This sample show how you can use the FuseJS/InterApp package to log in with Azure AD B2C Account.

For more information about Azure AD B2C check out this link:

https://docs.microsoft.com/en-us/azure/active-directory-b2c/

## Setup

To run the sample, you first need to create an Azure Active Directory B2C tentant in the azure.com portal. Then copy required information to their spots in Auth.js.

The redirect_url used in this sample is the default OAuth 2.0 uri: 'urn:ietf:wg:oauth:2.0:oob'. Since the UriScheme is not unique this can lead to conflicts with other applications. You can change this to a unique uri by allowing this in the Azure portal and updating the redirect_url in Auth.js

## Azure Active Directory B2C: Extensible policy framework

Azure extend the OAuth flow with Extensible policies. For more information check out this link:

https://docs.microsoft.com/en-us/azure/active-directory-b2c/active-directory-b2c-reference-policies

## Azure Active Directory B2C: Customize the Azure AD B2C user interface (UI)

If you want to customize the login experience check out this link:

https://docs.microsoft.com/en-us/azure/active-directory-b2c/active-directory-b2c-reference-ui-customization

## Running the app

When the app starts, click the "Sign Up" / "Sign In" button. It will open a web browser prompting you to register/login to your Azure AD B2C account. After successfully registering/logging in to your Azure AD B2C account, the web browser will redirect back to the app with the OAuth JWT Payload. Clicking the "OAuthInfo" button will dump the current JWT payload to the debug console as JSON.

* Note: In this example the client secret is in the Auth.js file. This might not be a good idea for a production app, but is done here for simplicity.
