//
//  AppDelegate.h
//  TrackPadTapMon
//
//  Created by Dave Carlton on 01/28/12.
//  Copyright (c) 2012 PolyMicro Systems. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Preferences;
@class EventMonitor;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, retain) Preferences       *prefs;
@property (nonatomic, retain) EventMonitor      *monitor;
@property (nonatomic, retain) IBOutlet NSWindow *window;

@end
