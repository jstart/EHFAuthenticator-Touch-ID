//
//  EHFAuthenticator.swift
//  EHFAuthenticator-Example
//
//  Created by Christopher Truman on 9/29/14.
//  Copyright (c) 2014 truman. All rights reserved.
//

import Foundation
import LocalAuthentication

typealias EHFCompletionBlock = (Void) ->()
typealias EHFAuthenticationErrorBlock = (Int) -> ()

class EHFAuthenticator : NSObject {
    
    fileprivate var context : LAContext
    
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
        self.policy = .deviceOwnerAuthenticationWithBiometrics
        self.reason = ""
    }
    
    class func canAuthenticateWithError() throws{
        let error: NSError! = NSError(domain: "Migrator", code: 0, userInfo: nil)
        if ((NSClassFromString("LAContext")) != nil){
            if (EHFAuthenticator.sharedInstance.context.canEvaluatePolicy(EHFAuthenticator.sharedInstance.policy, error: nil)){
                return
            }
            throw error
        }
        throw error
    }
    
    func authenticateWithSuccess(_ success: @escaping EHFCompletionBlock, failure: @escaping EHFAuthenticationErrorBlock){
        self.context = LAContext()
        if (self.useDefaultFallbackTitle) {
            self.context.localizedFallbackTitle = self.fallbackButtonTitle as String;
        }else if (self.hideFallbackButton){
            self.context.localizedFallbackTitle = "";
        }
        if (self.context.canEvaluatePolicy(policy, error: nil)) {
            self.context.evaluatePolicy(policy, localizedReason:
                reason as String, reply:{ authenticated, error in
                if (authenticated) {
                    DispatchQueue.main.async(execute: {success()})
                } else {
                    DispatchQueue.main.async(execute: {failure(error!._code)})
                }
            })
        } else {
            failure(0)
        }
    }
}
