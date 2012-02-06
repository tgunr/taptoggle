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
#import "TapMenuController.h"
#import <PMUtility/pm.h>

@interface AppDelegate ()

- (void)tapShowPreferences;

@end

@implementation AppDelegate {
@private
}

@synthesize window;
@synthesize prefs;
@synthesize menuExtraController;

- (id)init {
    if ( self = [super init] ) {
        // Init code
    }
    return self;
}

- (void)awakeFromNib {
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    prefs = [Preferences shared];
    
    // At this pint, our outlets to inside this nib will be properly setup. It is important to note
    // that they will get overwritten when this is called again!
    // In general, it is good practice to use a unique controller object for each nib you load.
    // You will normally pass that controller as the 'owner'. For simplicity purposes we are passing
    // in this object as the owner.
    //
//    NSArray *nibArray;
//    NSNib *nib = [[NSNib alloc]initWithNibNamed:@"MenuExtra" bundle:nil];
//    BOOL result = [nib instantiateNibWithOwner:NSApp topLevelObjects:&nibArray];
//    if (!result) {
//        PMLOG(1, @"Did NOT load MenuExtra nib file");
//        return;
//    }
    menuExtraController = [TapMenuController instance];
//    NSBundle *myBundle = [NSBundle mainBundle];
//    NSURL    *myURL    = [myBundle bundleURL];
//    LSRegisterURL((__bridge CFURLRef) myURL, TRUE);
//    SMLoginItemSetEnabled((CFStringRef) tptmenuextra, true);
}

- (void)checkWeekly:(NSDictionary *)appDict {
    BOOL value = [[appDict objectForKey:kCheckWeekly] boolValue];
    if (value)
        PMLOG(1, @"Starting Weekly check timer");
    else
        PMLOG(1, @"Stopping Weekly check timer");
}

- (void)checkAnonInfo:(NSDictionary *)appDict {
    BOOL value = [[appDict objectForKey:kAnonInfo] boolValue];
    if (value)
        PMLOG(1, @"Will inlcude anon info");
    else
        PMLOG(1, @"Anon info disabled");
}

- (void)checkUseHotKey {
    BOOL value = [prefs useHotKey];
    if (value)
        PMLOG(1, @"Hot key enabled");
    else
        PMLOG(1, @"Hot key disabled");
}

- (void)checkHotKey:(NSDictionary *)appDict {
//    NSInteger hkCode  = [[appDict objectForKey:kHotKeyCode] integerValue];
//    NSInteger hkFlags = [[appDict objectForKey:kHotKeyFlags] integerValue];
//    KeyCombo  hotkey  = {(NSUInteger) hkCode, hkFlags};
}

- (void)checkForUpdate {
    NSTimeInterval oneWeek = 60 * 60 * 24 * 7;
    NSDate *checkDate = [NSDate dateWithTimeInterval:oneWeek sinceDate:[prefs lastCheck]];
    NSDate *today     = [NSDate date];
    NSComparisonResult checkResult = [today compare:checkDate];
    if (checkResult == NSOrderedDescending) {
        // TODO: checkin code
    }
}

- (void)tapShowPreferences {
    [window makeKeyAndOrderFront: self];
}
@end
