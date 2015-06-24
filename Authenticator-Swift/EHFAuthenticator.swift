//
//  EHFAuthenticator.swift
//  EHFAuthenticator-Example
//
//  Created by Christopher Truman on 9/29/14.
//  Copyright (c) 2014 truman. All rights reserved.
//

import Foundation
import LocalAuthentication

typealias EHFCompletionBlock = Void ->()
typealias EHFAuthenticationErrorBlock = Int -> ()

class EHFAuthenticator : NSObject {
    
    private var context : LAContext
    
    // reason string presented to the user in auth dialog
    var reason : NSString
    
    // Allows fallback button title customization. If set to nil, "Enter Password" is used.
    var fallbackButtonTitle : NSString
    
    // If set to NO it will not customize the fallback title, shows default "Enter Password".  If set to YES, title is customizable.  Default value is NO.
    var useDefaultFallbackTitle : Bool
    
    // Disable "Enter Password" fallback button. Default value is NO.
    var hideFallbackButton : Bool
    
    // Default value is LAPolicyDeviceOwnerAuthenticationWithBiometrics.  This value will be useful if LocalAuthentication.framework introduces new auth policies in future version of iOS.
    var policy : LAPolicy
    
    
    class var sharedInstance : EHFAuthenticator {
        struct Static {
            static let instance : EHFAuthenticator = EHFAuthenticator()
        }
        return Static.instance
    }
    
    override init(){
        self.context = LAContext()
        self.fallbackButtonTitle = ""
        self.useDefaultFallbackTitle = false
        self.hideFallbackButton = false
        self.policy = .DeviceOwnerAuthenticationWithBiometrics
        self.reason = ""
    }
    
    class func canAuthenticateWithError(error: NSErrorPointer) -> Bool{
        if ((NSClassFromString("LAContext")) != nil){
            if (EHFAuthenticator.sharedInstance.context .canEvaluatePolicy(EHFAuthenticator.sharedInstance.policy, error: NSErrorPointer())){
                return true
            }
            return false
        }
        return false
    }
    
    func authenticateWithSuccess(success: EHFCompletionBlock, failure: EHFAuthenticationErrorBlock){
        self.context = LAContext()
        var authError : NSError?
        if (self.useDefaultFallbackTitle) {
            self.context.localizedFallbackTitle = self.fallbackButtonTitle as String;
        }else if (self.hideFallbackButton){
            self.context.localizedFallbackTitle = "";
        }
        if (self.context.canEvaluatePolicy(policy, error: &authError)) {
            self.context.evaluatePolicy(policy, localizedReason:
                reason as String, reply:{ authenticated, error in
                if (authenticated) {
                    dispatch_async(dispatch_get_main_queue(), {success()})
                } else {
                    dispatch_async(dispatch_get_main_queue(), {failure(error!.code)})
                }
            })
        } else {
            failure(authError!.code)
        }
    }
}