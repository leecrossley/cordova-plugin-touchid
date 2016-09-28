//
//  TouchID.m
//  Copyright (c) 2014 Lee Crossley - http://ilee.co.uk
//

#import "TouchID.h"

#import <LocalAuthentication/LocalAuthentication.h>

@implementation TouchID

- (void) authenticate:(CDVInvokedUrlCommand*)command;
{
    NSString *text = [command.arguments objectAtIndex:0];
    LAPolicy authPolicy = [self determineLAPolicyFromCommand:command flagIndex:1];

    __block CDVPluginResult* pluginResult = nil;

    if (NSClassFromString(@"LAContext") != nil)
    {
        LAContext *laContext = [[LAContext alloc] init];
        NSError *authError = nil;

        if ([laContext canEvaluatePolicy:authPolicy error:&authError])
        {
            [laContext evaluatePolicy:authPolicy localizedReason:text reply:^(BOOL success, NSError *error)
             {
                 if (success)
                 {
                     pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                 }
                 else
                 {
                     NSString *errorCode = nil;
                     switch (error.code) {
                         case LAErrorAuthenticationFailed:
                             errorCode = @"authenticationFailed";
                             break;
                         case LAErrorUserCancel:
                             errorCode = @"userCancel";
                             break;
                         case LAErrorUserFallback:
                             errorCode = @"userFallback";
                             break;
                         case LAErrorSystemCancel:
                             errorCode = @"systemCancel";
                             break;
                         case LAErrorPasscodeNotSet:
                             errorCode = @"passcodeNotSet";
                             break;
                         case LAErrorTouchIDNotAvailable:
                             errorCode = @"touchIDNotAvailable";
                             break;
                         case LAErrorTouchIDNotEnrolled:
                             errorCode = @"touchIDNotEnrolled";
                             break;
                         default:
                             errorCode = @"unknown";
                             break;
                     }
                     
                     pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorCode];
                 }

                 [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
             }];
        }
        else
        {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[authError localizedDescription]];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }
    else
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void) checkSupport:(CDVInvokedUrlCommand*)command;
{
    LAPolicy authPolicy = [self determineLAPolicyFromCommand:command flagIndex:1];
    __block CDVPluginResult* pluginResult = nil;

    if (NSClassFromString(@"LAContext") != nil)
    {
        LAContext *laContext = [[LAContext alloc] init];
        NSError *authError = nil;

        if ([laContext canEvaluatePolicy:authPolicy error:&authError])
        {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        }
        else
        {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[authError localizedDescription]];
        }
    }
    else
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (LAPolicy) determineLAPolicyFromCommand:(CDVInvokedUrlCommand *)command flagIndex:(int)idx
{
    BOOL canFallbackToPasscode = NO;
    if (command.arguments.count >= idx+1) {
        NSString *txtFallbackToPasscode =
            [command argumentAtIndex:(idx) withDefault:@"false" andClass:[NSString class]];
        if ([txtFallbackToPasscode isEqualToString:@"true"]) {
            canFallbackToPasscode = true;
        }
    }
    LAPolicy policy = canFallbackToPasscode ? LAPolicyDeviceOwnerAuthentication : LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    return policy;
}

@end
