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

@interface AppDelegate ()

@property(assign, readwrite) Preferences       *prefs;
@property(assign, readwrite) EventMonitor      *monitor;
@property(assign, readwrite) IBOutlet NSWindow *window;

@end

@implementation AppDelegate

@synthesize window;
@synthesize prefs;
@synthesize monitor;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    NSApplication *app = [NSApplication sharedApplication];
    
    prefs   = [[Preferences alloc] initPreferences:app];
    monitor = [[EventMonitor alloc] initWithPreference:prefs];
    [monitor setupUsingPrefs];
    
    [[NSDistributedNotificationCenter defaultCenter]
     addObserver:monitor selector:@selector(observeNotification:) name:kNotifyName
     object:nil];
    
    [NSEvent addGlobalMonitorForEventsMatchingMask:(NSKeyDownMask | NSLeftMouseUpMask) handler:^(NSEvent *event) {
        processEvent(event);
    }];
    
    NSBundle *myBundle = [NSBundle mainBundle];
    NSURL *myURL = [myBundle bundleURL];
    LSRegisterURL((__bridge CFURLRef)myURL, TRUE);
    SMLoginItemSetEnabled((CFStringRef)tptmenuextra, true);
}

@end
