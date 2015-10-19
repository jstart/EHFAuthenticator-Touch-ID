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
        do {
            try EHFAuthenticator.canAuthenticateWithError()
        }
         catch {
            self.authenticationButton.enabled = false
            var authErrorString = "Check your Touch ID Settings."
            let nserror = error as NSError
            switch (nserror.code) {
            case LAError.TouchIDNotEnrolled.rawValue:
                authErrorString = "No Touch ID fingers enrolled.";
                break;
            case LAError.TouchIDNotAvailable.rawValue:
                authErrorString = "Touch ID not available on your device.";
                break;
            case LAError.PasscodeNotSet.rawValue:
                authErrorString = "Need a passcode set to use Touch ID.";
                break;
            default:
                authErrorString = "Check your Touch ID Settings.";
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
                case LAError.SystemCancel.rawValue:
                authErrorString = "System canceled auth request due to app coming to foreground or background.";
                break;
                case LAError.AuthenticationFailed.rawValue:
                authErrorString = "User failed after a few attempts.";
                break;
                case LAError.UserCancel.rawValue:
                authErrorString = "User cancelled.";
                break;
                
                case LAError.UserFallback.rawValue:
                authErrorString = "Fallback auth method should be implemented here.";
                break;
                case LAError.TouchIDNotEnrolled.rawValue:
                authErrorString = "No Touch ID fingers enrolled.";
                break;
                case LAError.TouchIDNotAvailable.rawValue:
                authErrorString = "Touch ID not available on your device.";
                break;
                case LAError.PasscodeNotSet.rawValue:
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
        let alertController = UIAlertController(title:"Touch ID", message:message as String, preferredStyle:.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

