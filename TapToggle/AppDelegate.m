//
//  AppDelegate.m
//  TrackPadTapMon
//
//  Created by Dave Carlton on 01/28/12.
//  Copyright (c) 2012 PolyMicro Systems. All rights reserved.
//

#import "AppDelegate.h"
#import "Preferences.h"
#import "Prefs.h"
#import "TapMenuController.h"
#import "LaunchAtLoginController.h"
#import "MYLog.h"
#import "DDLog.h"

@implementation NSApplication (Relaunch)

- (void) relaunch:(id) sender {
    NSString *daemonPath = [[NSBundle mainBundle] pathForResource:NSApplicationRelaunchDaemon ofType:nil];
    NSString *path       = [[NSBundle mainBundle] bundlePath];
    NSString *pid        = [NSString stringWithFormat:@"%d", [[NSProcessInfo processInfo] processIdentifier]];
    NSArray  *args       = [NSArray arrayWithObjects:path, pid, nil];
    [NSTask launchedTaskWithLaunchPath:daemonPath arguments:args];
    [self terminate:sender];
}

@end

@interface AppDelegate ()

- (void) tapShowPreferences;

@end

@implementation AppDelegate

@synthesize window;
@synthesize prefs;
@synthesize menuExtraController;
@synthesize dockMenu = _dockMenu;

- (NSMenu *) applicationDockMenu:(NSApplication *) sender {
    return _dockMenu;
}

- (void) applicationDidFinishLaunching:(NSNotification *) aNotification {	
    prefs               = [Preferences instance];
    menuExtraController = [TapMenuController instance];
    _dockMenu           = [menuExtraController dockMenu];
    [menuExtraController setMenus];
    loginController = [[LaunchAtLoginController alloc] init];
}

- (void) checkWeekly:(NSDictionary *) appDict {
    BOOL value = [[appDict objectForKey:kCheckWeekly] boolValue];
    if (value)
        DDLogInfo(@"Starting Weekly check timer");
    else
        DDLogInfo(@"Stopping Weekly check timer");
}

- (void) checkAnonInfo:(NSDictionary *) appDict {
    BOOL value = [[appDict objectForKey:kAnonInfo] boolValue];
    if (value)
        DDLogInfo(@"Will inlcude anon info");
    else
        DDLogInfo(@"Anon info disabled");
}

- (void) checkForUpdate {
    NSTimeInterval oneWeek = 60 * 60 * 24 * 7;
    NSDate *checkDate = [NSDate dateWithTimeInterval:oneWeek sinceDate:[prefs lastCheck]];
    NSDate *today     = [NSDate date];
    NSComparisonResult checkResult = [today compare:checkDate];
    if (checkResult == NSOrderedDescending) {
        // TODO: checkin code
    }
}

- (void) tapShowPreferences {
    [NSApp activateIgnoringOtherApps:YES];
}

- (NSMenu *) applicationDockMenu {
    _dockMenu = [[NSMenu alloc] initWithTitle:@"TapToggle"];
    return _dockMenu;
}

- (void) setLogin:(BOOL) install {
    [loginController setLaunchAtLogin:install];
}

@end
