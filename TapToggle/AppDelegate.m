//
//  AppDelegate.m
//  TrackPadTapMon
//
//  Created by Dave Carlton on 01/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "Preferences.h"
#import "Prefs.h"
#import "TapMenuController.h"
#import "LaunchAtLoginController.h"

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

- (void) buildDockMenu {
    _dockMenu = [[NSMenu alloc]
                         initWithTitle:@"TapToggle"];
    [_dockMenu setAutoenablesItems:NO];
    NSMenuItem *item;

    dockClickItem = [[NSMenuItem alloc]
                                 initWithTitle:@"Tap Click Off" action:@selector(tapToggleClick) keyEquivalent:@""];
    [item setEnabled:YES];
    [item setTarget:self];
    [_dockMenu addItem:dockClickItem];

    dockPrefItem = [[NSMenuItem alloc]
                                initWithTitle:@"Preferences" action:@selector(tapPrefClick) keyEquivalent:@""];
    [item setTarget:self];
    [item setEnabled:YES];
    [_dockMenu addItem:dockPrefItem];

}

- (void) toggleClicking {
    NSDictionary  *dict;
    NSBundle      *myBundle = [NSBundle mainBundle];
    NSURL         *asURL    = [myBundle URLForResource:@"SysPref" withExtension:@"scpt"];
    NSAppleScript *as       = [[NSAppleScript alloc] initWithContentsOfURL:asURL error:&dict];
    [as executeAndReturnError:&dict];
    BOOL clicking = [menuExtraController isClicking];
    if (clicking) {
        [dockClickItem setTitle:@"Tap Click Off"];
    }
    else {
        [dockClickItem setTitle:@"Tap Click On"];
    }
    NSString *clickState = clicking ? @"ON" : @"OFF";
    PMLOG(1, @"Tap Click is: %@", clickState);
}

- (void) tapToggleClick {
    PMHERE;
    [self toggleClicking];
}

- (void) tapPrefClick {
    PMHERE;
    [self tapShowPreferences];
}


- (NSMenu *) applicationDockMenu:(NSApplication *) sender {
    PMHERE;
    return _dockMenu;
}

- (void) applicationDidFinishLaunching:(NSNotification *) aNotification {
    prefs               = [Preferences instance];
    menuExtraController = [TapMenuController instance];
    _dockMenu           = [menuExtraController dockMenu];
    loginController     = [[LaunchAtLoginController alloc] init];
}

- (void) checkWeekly:(NSDictionary *) appDict {
    BOOL value = [[appDict objectForKey:kCheckWeekly] boolValue];
    if (value)
    PMLOG(1, @"Starting Weekly check timer");
    else
          PMLOG(1, @"Stopping Weekly check timer");
}

- (void) checkAnonInfo:(NSDictionary *) appDict {
    BOOL value = [[appDict objectForKey:kAnonInfo] boolValue];
    if (value)
    PMLOG(1, @"Will inlcude anon info");
    else
          PMLOG(1, @"Anon info disabled");
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
    PMHERE;
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
