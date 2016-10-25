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

    override func viewWillAppear(_ animated: Bool) {
        do {
            try EHFAuthenticator.canAuthenticateWithError()
        }
         catch {
            self.authenticationButton.isEnabled = false
            var authErrorString = "Check your Touch ID Settings."
            let nserror = error as NSError
            switch (nserror.code) {
            case LAError.Code.touchIDNotEnrolled.rawValue:
                authErrorString = "No Touch ID fingers enrolled.";
                break;
            case LAError.Code.touchIDNotAvailable.rawValue:
                authErrorString = "Touch ID not available on your device.";
                break;
            case LAError.Code.passcodeNotSet.rawValue:
                authErrorString = "Need a passcode set to use Touch ID.";
                break;
            default:
                authErrorString = "Check your Touch ID Settings.";
            }
            self.authenticationButton.setTitle(authErrorString, for: .disabled)
        }
    }
    
    @IBAction func authenticate(_ sender: UIButton) {
        EHFAuthenticator.sharedInstance.authenticateWithSuccess({
            self.presentAlertControllerWithMessage("Successfully Authenticated!")
            }, failure:{ errorCode in
                var authErrorString : NSString
                switch (errorCode) {
                case LAError.systemCancel.rawValue:
                authErrorString = "System canceled auth request due to app coming to foreground or background.";
                break;
                case LAError.authenticationFailed.rawValue:
                authErrorString = "User failed after a few attempts.";
                break;
                case LAError.userCancel.rawValue:
                authErrorString = "User cancelled.";
                break;
                
                case LAError.userFallback.rawValue:
                authErrorString = "Fallback auth method should be implemented here.";
                break;
                case LAError.touchIDNotEnrolled.rawValue:
                authErrorString = "No Touch ID fingers enrolled.";
                break;
                case LAError.touchIDNotAvailable.rawValue:
                authErrorString = "Touch ID not available on your device.";
                break;
                case LAError.passcodeNotSet.rawValue:
                authErrorString = "Need a passcode set to use Touch ID.";
                break;
                default:
                authErrorString = "Check your Touch ID Settings.";
                break;
                }
                self.presentAlertControllerWithMessage(authErrorString)
            })
//        print(LAError.touchIDNotEnrolled.rawValue
    }
    
    func presentAlertControllerWithMessage(_ message : NSString) {
        let alertController = UIAlertController(title:"Touch ID", message:message as String, preferredStyle:.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

