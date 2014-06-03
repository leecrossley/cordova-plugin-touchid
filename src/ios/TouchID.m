//
//  TouchID.m
//  Copyright (c) 2014 Lee Crossley - http://ilee.co.uk
//

#import "TouchID.h"

@implementation TouchID

- (void) authenticate:(CDVInvokedUrlCommand*)command;
{
    NSMutableDictionary *args = [command.arguments objectAtIndex:0];
    NSString *text = [args objectForKey:@"text"];

    LAContext *laContext = [[LAContext alloc] init];
    NSError *authError = nil;

    __block CDVPluginResult* pluginResult = nil;

    if ([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [laContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
            localizedReason:text reply:^(BOOL success, NSError *error) {
                if (success) {
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                } else {
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
                }
            }];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[authError localizedDescription]];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) checkSupport:(CDVInvokedUrlCommand*)command;
{
    LAContext *laContext = [[LAContext alloc] init];
    NSError *authError = nil;

    __block CDVPluginResult* pluginResult = nil;

    if ([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[authError localizedDescription]];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
