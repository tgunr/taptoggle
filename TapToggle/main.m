//
//  main.m
//  TapToggle
//
//  Created by Dave Carlton on 01/30/12.
//  Copyright (c) 2012 PolyMicro Systems. All rights reserved.
//

#import "PMLog.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"

int main(int argc, char *argv[]) {
    @autoreleasepool {
        [DDLog addLogger:[DDASLLogger sharedInstance]];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        NSArray *arguments = [[NSProcessInfo processInfo] arguments];
        for (int i = 1; i < [arguments count]; i++) {
            NSString *argument = [arguments objectAtIndex:i];
            if ([argument isEqualToString:@"--kill-pref"] ||
                    [argument isEqualToString:@"--killpref"]) {
                system("rm $HOME/Library/Preferences/com.polymicrosystems.taptoggle.plist");
            }
            if ([argument isEqualToString:@"--debug"]) {
                pmLogLevel = LOG_LEVEL_DEBUG;
            }
        }
    return NSApplicationMain(argc, (const char **) argv);
    }
}
