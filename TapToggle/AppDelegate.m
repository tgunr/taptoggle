//
//  AppDelegate.m
//  TrackPadTapMon
//
//  Created by Dave Carlton on 01/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <ServiceManagement/ServiceManagement.h>
#import "AppDelegate.h"
#import "EventMonitor.h"
#import "Preferences.h"
#import "Prefs.h"

@implementation AppDelegate {
}

@synthesize window = _window;
@synthesize monitor = _monitor;
@synthesize prefs = _prefs;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _prefs   = [[Preferences alloc] initPreferences:NSApp];
    _monitor = [[EventMonitor alloc] initWithPreferences:_prefs];
    [_monitor setupUsingPrefs];


    [[NSDistributedNotificationCenter defaultCenter]
                                      addObserver:_monitor selector:@selector(observeNotification:) name:kNotifyName
                                           object:nil];

    [NSEvent addGlobalMonitorForEventsMatchingMask:(NSKeyDownMask | NSLeftMouseUpMask) handler:^(NSEvent *event) {
        processEvent(event);
    }];

    NSBundle *myBundle = [NSBundle mainBundle];
    NSURL    *myURL    = [myBundle bundleURL];
    LSRegisterURL((__bridge CFURLRef) myURL, TRUE);
    SMLoginItemSetEnabled((CFStringRef) tptmenuextra, true);
}

@end
