EHFAuthenticator
================

Simple class for handling Local Authentication using Touch ID. Used in eHarmony iOS App. EHF stands for eHarmony Foundation which is our library of utilities built off Apple Frameworks. iOS 8 only because it requires the LocalAuthentication framework. Only functional on devices equipped with a Touch ID sensor (iPhone 5S, 6, 6+).  Will not work in simulator.

Currently supports Swift 1.2 syntax.  Will update to Swift 2.0 when Xcode 7 is officially released.

Article describing the feature [on medium]
(https://medium.com/ios-os-x-development/getting-started-with-touch-id-local-authentication-5264b4c256b9).

Our mockup of the feature in eHarmony is below:
![mockup](https://d262ilb51hltx0.cloudfront.net/max/2000/1*ngtPaxXdEjGrNpb759-T3A.png)

##Example Usage

Install with Cocoapods:

    pod 'EHFAuthenticator-Touch-ID', '0.0.3'

Set a reason to show to your users, then authenticate to verify identity.
### ObjC
    [[EHFAuthenticator sharedInstance] setReason:@"Authenticate with Touch ID to access secure data"]
    [[EHFAuthenticator sharedInstance] authenticateWithSuccess:^(){
        // Success
    } andFailure:^(LAError errorCode){
      //Handle LAError codes.  See example project for the different errors that can occur.
    }];

### Swift
    EHFAuthenticator.sharedInstance.reason = "Authenticate with Touch ID to access secure data"
    EHFAuthenticator.sharedInstance.authenticateWithSuccess({
        // Success
    }, failure:{ errorCode in
      //Handle LAError codes.  See example project for the different errors that can occur.
    })
