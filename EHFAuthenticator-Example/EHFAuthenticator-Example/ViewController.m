//
//  ViewController.m
//  EHFAuthenticator-Example
//
//  Created by Christopher Truman on 9/29/14.
//  Copyright (c) 2014 truman. All rights reserved.
//

#import "ViewController.h"
#import "EHFAuthenticator.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *authenticationButton;

@end

@implementation ViewController

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSError * error = nil;

    [[EHFAuthenticator sharedInstance] setReason:@"Because i can"];
    [[EHFAuthenticator sharedInstance] setFallbackButtonTitle:@"Enter Password"];
    [[EHFAuthenticator sharedInstance] setUseDefaultFallbackTitle:YES];
    
    if (![EHFAuthenticator canAuthenticateWithError:&error]) {
        [self.authenticationButton setEnabled:NO];
        NSString * authErrorString = @"Check your Touch ID Settings.";

        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
                authErrorString = @"No Touch ID fingers enrolled.";
                break;
            case LAErrorTouchIDNotAvailable:
                authErrorString = @"Touch ID not available on your device.";
                break;
            case LAErrorPasscodeNotSet:
                authErrorString = @"Need a passcode set to use Touch ID.";
                break;
            default:
                authErrorString = @"Check your Touch ID Settings.";
                break;
        }
        [self.authenticationButton setTitle:authErrorString forState:UIControlStateDisabled];
    }
}

- (IBAction)authenticate:(id)sender {
    [[EHFAuthenticator sharedInstance] authenticateWithSuccess:^(){
        [self presentAlertControllerWithMessage:@"Successfully Authenticated!"];
    } andFailure:^(LAError errorCode){
        NSString * authErrorString;
        switch (errorCode) {
            case LAErrorSystemCancel:
                authErrorString = @"System canceled auth request due to app coming to foreground or background.";
                break;
            case LAErrorAuthenticationFailed:
                authErrorString = @"User failed after a few attempts.";
                break;
            case LAErrorUserCancel:
                authErrorString = @"User cancelled.";
                break;
                
            case LAErrorUserFallback:
                authErrorString = @"Fallback auth method should be implemented here.";
                break;
            case LAErrorTouchIDNotEnrolled:
                authErrorString = @"No Touch ID fingers enrolled.";
                break;
            case LAErrorTouchIDNotAvailable:
                authErrorString = @"Touch ID not available on your device.";
                break;
            case LAErrorPasscodeNotSet:
                authErrorString = @"Need a passcode set to use Touch ID.";
                break;
            default:
                authErrorString = @"Check your Touch ID Settings.";
                break;
        }
        [self presentAlertControllerWithMessage:authErrorString];
    }];
}

-(void) presentAlertControllerWithMessage:(NSString *) message{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Touch ID" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
