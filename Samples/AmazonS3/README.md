# Amazon Web Services Simple Storage Service download

This sample shows how to use Amazon Web Services (AWS) SDK through Foreign Code
to download an image file from Amazon Simple Storage Service (S3) on both Android and
iOS.

## Setup

This sample will automatically download the AWS SDK for the platform it's built
on.

You will need to configure S3 by following [Amazon's getting started guide](http://docs.aws.amazon.com/mobile/sdkforios/developerguide/s3transfermanager.html).

Once you have done that, you can fill in the details of your configuration in
`MainView.uno`, where it says `<MY-POOLID>`, `<MY-BUCKET>`, and `<MY-FILEKEY>`.
`<MY-FILEKEY>` refers to an image file that you want to download, which will be
displayed in the app.

## Further reading

For more details on Foreign Code, see [the documentation](https://www.fusetools.com/learn/uno#working-with-foreign-code). For
more details on AWS and S3, see [the S3 documentation for iOS](http://docs.aws.amazon.com/mobile/sdkforios/developerguide/s3transfermanager.html)
and [the S3 documentation for Android](http://docs.aws.amazon.com/mobile/sdkforandroid/developerguide/s3transferutility.html).
The code in this sample follows the S3 documentation closely.
