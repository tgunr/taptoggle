//
//  AppDelegate.m
//  TrackPadTapMon
//
//  Created by Dave Carlton on 01/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <ServiceManagement/ServiceManagement.h>
#import <CoreServices/CoreServices.h>
#import "AppDelegate.h"
#import "Preferences.h"
#import "Prefs.h"
#import "TapToggleMenu.h"

@interface AppDelegate ()

- (void)setPrefs:(Preferences *)preferences;
- (void)tapShowPreferences;


@property (nonatomic, retain, readwrite) Preferences *prefs;


@end

@implementation AppDelegate {
}

@synthesize window;
@synthesize prefs = _prefs;


- (void)setPrefs:(Preferences *)preferences {
    _prefs = preferences;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSBundle *myBundle = [NSBundle mainBundle];
    NSURL    *myURL    = [myBundle bundleURL];
    LSRegisterURL((__bridge CFURLRef) myURL, TRUE);
    SMLoginItemSetEnabled((CFStringRef) tptmenuextra, true);
}

- (void)checkWeekly:(NSDictionary *)appDict {
    BOOL value = [[appDict objectForKey:kCheckWeekly] boolValue];
    if (value)
        NSLog(@"Starting Weekly check timer");
    else
        NSLog(@"Stopping Weekly check timer");
}

- (void)checkAnonInfo:(NSDictionary *)appDict {
    BOOL value = [[appDict objectForKey:kAnonInfo] boolValue];
    if (value)
        NSLog(@"Will inlcude anon info");
    else
        NSLog(@"Anon info disabled");
}

- (void)checkUseHotKey {
    BOOL value = [_prefs useHotKey];
    if (value)
        NSLog(@"Hot key enabled");
    else
        NSLog(@"Hot key disabled");
}

- (void)checkHotKey:(NSDictionary *)appDict {
    NSInteger hkCode  = [[appDict objectForKey:kHotKeyCode] integerValue];
    NSInteger hkFlags = [[appDict objectForKey:kHotKeyFlags] integerValue];
    KeyCombo  hotkey  = {(NSUInteger) hkCode, hkFlags};
}

- (void)checkForUpdate {
    NSTimeInterval oneWeek = 60 * 60 * 24 * 7;
    NSDate *checkDate = [NSDate dateWithTimeInterval:oneWeek sinceDate:[_prefs lastCheck]];
    NSDate *today     = [NSDate date];
    NSComparisonResult checkResult = [today compare:checkDate];
    if (checkResult == NSOrderedDescending) {
        // TODO: checkin code
    }
}

- (void)tapShowPreferences {
    [window orderFrontRegardless];
}
@end
