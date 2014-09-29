//
//  ViewController.swift
//  EHFAuthenticator-Example-Swift
//
//  Created by Christopher Truman on 9/29/14.
//  Copyright (c) 2014 truman. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet weak var authenticationButton: UIButton!

    override func viewWillAppear(animated: Bool) {
        var error : NSError?
        if (!EHFAuthenticator.canAuthenticateWithError(&error)) {
            self.authenticationButton.enabled = false
            var authErrorString = "Check your Touch ID Settings."
            if let code = error?.code {
                switch (code) {
                case LAError.TouchIDNotEnrolled.toRaw():
                    authErrorString = "No Touch ID fingers enrolled.";
                    break;
                case LAError.TouchIDNotAvailable.toRaw():
                    authErrorString = "Touch ID not available on your device.";
                    break;
                case LAError.PasscodeNotSet.toRaw():
                    authErrorString = "Need a passcode set to use Touch ID.";
                    break;
                default:
                    authErrorString = "Check your Touch ID Settings.";
                }
            }
            self.authenticationButton.setTitle(authErrorString, forState: .Disabled)
        }
    }
    
    @IBAction func authenticate(sender: UIButton) {
        EHFAuthenticator.sharedInstance.authenticateWithSuccess({
            self.presentAlertControllerWithMessage("Successfully Authenticated!")
            }, failure:{ errorCode in
                var authErrorString : NSString
                switch (errorCode) {
                case LAError.SystemCancel.toRaw():
                authErrorString = "System canceled auth request due to app coming to foreground or background.";
                break;
                case LAError.AuthenticationFailed.toRaw():
                authErrorString = "User failed after a few attempts.";
                break;
                case LAError.UserCancel.toRaw():
                authErrorString = "User cancelled.";
                break;
                
                case LAError.UserFallback.toRaw():
                authErrorString = "Fallback auth method should be implemented here.";
                break;
                case LAError.TouchIDNotEnrolled.toRaw():
                authErrorString = "No Touch ID fingers enrolled.";
                break;
                case LAError.TouchIDNotAvailable.toRaw():
                authErrorString = "Touch ID not available on your device.";
                break;
                case LAError.PasscodeNotSet.toRaw():
                authErrorString = "Need a passcode set to use Touch ID.";
                break;
                default:
                authErrorString = "Check your Touch ID Settings.";
                break;
                }
                self.presentAlertControllerWithMessage(authErrorString)
            })
    }
    
    func presentAlertControllerWithMessage(message : NSString) {
        var alertController = UIAlertController(title:"Touch ID", message:message, preferredStyle:.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

