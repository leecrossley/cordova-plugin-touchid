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

    __block CDVPluginResult* pluginResult = nil;

    if (NSClassFromString(@"LAContext") != nil)
    {
        LAContext *laContext = [[LAContext alloc] init];
        NSError *authError = nil;

        if ([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError])
        {
            [laContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:text reply:^(BOOL success, NSError *error)
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

    __block CDVPluginResult* pluginResult = nil;

    if (NSClassFromString(@"LAContext") != nil)
    {
        LAContext *laContext = [[LAContext alloc] init];
        NSError *authError = nil;

        if ([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError])
        {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        }
        else
        {
            NSString *errorCode = nil;
            switch (authError.code) {
                case LAErrorPasscodeNotSet:
                    errorCode = @"passcodeNotSet";
                    break;
                case LAErrorTouchIDNotEnrolled:
                    errorCode = @"touchIDNotEnrolled";
                    break;
                default:
                    errorCode = @"touchIDNotAvailable";
                    break;
            }
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorCode];
        }
    }
    else
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
