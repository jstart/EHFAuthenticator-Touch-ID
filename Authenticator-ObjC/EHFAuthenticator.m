//
//  EHFAuthenticator.m
//  EHFoundation
//
//  Created by Christopher Truman on 7/31/14.
//  Copyright (c) 2014 eHarmony. All rights reserved.
//

#import "EHFAuthenticator.h"

@interface EHFAuthenticator ()

@property (nonatomic, strong) LAContext * context;

@end

@implementation EHFAuthenticator

+ (BOOL) canAuthenticateWithError:(NSError **) error
{
    if ([NSClassFromString(@"LAContext") class]) {
        if ([[EHFAuthenticator sharedInstance].context canEvaluatePolicy:[EHFAuthenticator sharedInstance].policy error:error]) {
            return YES;
        }
        return NO;
    }
    return NO;
}

static EHFAuthenticator *sharedInstance;

+ (EHFAuthenticator *) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[EHFAuthenticator alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init{
    if (self = [super init]) {
        self.context = [[LAContext alloc] init];
        self.useDefaultFallbackTitle = NO;
        self.hideFallbackButton = NO;
        self.policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    }
    return self;
}

- (void) authenticateWithSuccess:(EHFCompletionBlock) success andFailure:(EHFAuthenticationErrorBlock) failure
{
    self.context = [[LAContext alloc] init];
    NSError *authError = nil;
    if (self.useDefaultFallbackTitle) {
        self.context.localizedFallbackTitle = self.fallbackButtonTitle;
    }else if (self.hideFallbackButton){
        self.context.localizedFallbackTitle = @"";
    }
    if ([self.context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [self.context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                     localizedReason:self.reason
                               reply:^(BOOL authenticated, NSError *error) {
                                   if (authenticated) {
                                       DispatchMainThread(^(){success();});
                                   } else {
                                       DispatchMainThread(^(){failure((LAError) error.code);});
                                   }
                               }];
    } else {
        failure((LAError) authError.code);
    }
}

@end
