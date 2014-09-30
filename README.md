EHFAuthenticator
================

Simple class for handling Local Authentication using Touch ID. Used in eHarmony iOS App.

Article describing the feature [on medium].
(https://medium.com/ios-os-x-development/getting-started-with-touch-id-local-authentication-5264b4c256b9)

Our mockup of the feature in eHarmony is below:
![mockup](https://d262ilb51hltx0.cloudfront.net/max/2000/1*ngtPaxXdEjGrNpb759-T3A.png)

##Example Usage
    [[EHFAuthenticator sharedInstance] setReason:@"Authenticate with Touch ID to access secure data"]
    [[EHFAuthenticator sharedInstance] authenticateWithSuccess:^(){
        [self presentAlertControllerWithMessage:@"Successfully Authenticated!"];
    } andFailure:^(LAError errorCode){
      //Handle LAError codes.  See example project for the different errors that can occur.
    }];
