//
//  AppDelegate.h
//  TrackPadTapMon
//
//  Created by Dave Carlton on 01/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Preferences;
@class EventMonitor;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property(assign, readonly) Preferences       *prefs;
@property(assign, readonly) EventMonitor      *monitor;
@property(assign, readonly) IBOutlet NSWindow *window;

@end
