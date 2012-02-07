//
//  AppDelegate.h
//  TrackPadTapMon
//
//  Created by Dave Carlton on 01/28/12.
//  Copyright (c) 2012 PolyMicro Systems. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Preferences;
@class TapMenuController;
@class LaunchAtLoginController;

#define NSApplicationRelaunchDaemon @"relaunch"

@interface NSApplication (Relaunch)

- (void) relaunch:(id) sender;

@end

@interface AppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSMenu     *_dockMenu;
    NSMenuItem *dockClickItem;
    NSMenuItem *dockPrefItem;

    LaunchAtLoginController *loginController;
}


@property (nonatomic, retain) Preferences       *prefs;
@property (nonatomic, retain) IBOutlet NSWindow *window;
@property (nonatomic, retain) TapMenuController *menuExtraController;
@property (nonatomic, retain) NSMenu            *dockMenu;

- (void) tapShowPreferences;
- (void) setLogin:(BOOL) install;
@end
