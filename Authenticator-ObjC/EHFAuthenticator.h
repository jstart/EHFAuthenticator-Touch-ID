//
//  EHFAuthenticator.h
//  EHFoundation
//
//  Created by Christopher Truman on 7/31/14.
//  Copyright (c) 2014 eHarmony. All rights reserved.
//

#define DispatchMainThread(block, ...) if(block) dispatch_async(dispatch_get_main_queue(), ^{ block(__VA_ARGS__); })

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

typedef void(^EHFCompletionBlock)();
typedef void(^EHFAuthenticationErrorBlock)(LAError);

@interface EHFAuthenticator : NSObject

+ (EHFAuthenticator *) sharedInstance;

//reason string presented to the user in auth dialog
@property (nonatomic, copy) NSString * reason;

//Allows fallback button title customization. If set to @"", the button will be hidden. If set to nil, "Enter Password" is used.
@property (nonatomic, copy) NSString * fallbackButtonTitle;

//If set to NO it will not customize the fallback title, shows default "Enter Password".  If set to YES, title is customizable.  Default value is NO.
@property (nonatomic, assign) BOOL useDefaultFallbackTitle;

// Disable "Enter Password" fallback button. Default value is NO.
@property (nonatomic, assign) BOOL hideFallbackButton;

// Default value is LAPolicyDeviceOwnerAuthenticationWithBiometrics.  This value will be useful if LocalAuthentication.framework introduces new auth policies in future version of iOS.
@property (nonatomic, assign) LAPolicy policy;

// returns YES if device and Apple ID can use Touch ID. If there is an error, it returns NO and assigns error so that UI can respond accordingly
+ (BOOL) canAuthenticateWithError:(NSError **) error;

// Authenticate the user by showing the Touch ID dialog and calling your success or failure block.  Failure block will return an NSError with a code of enum type LAError: https://developer.apple.com/library/ios/documentation/LocalAuthentication/Reference/LAContext_Class/index.html#//apple_ref/c/tdef/LAError
// Use the error to handle different types of failure and fallback authentication.
- (void) authenticateWithSuccess:(EHFCompletionBlock) success andFailure:(EHFAuthenticationErrorBlock) failure;

@end
