//
//  TapMenuController.h
//  TapToggle
//
//  Created by Dave Carlton on 02/03/12.
//  Copyright (c) 2012 PolyMicro Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Preferences;
@class AppDelegate;

@interface TapMenuController : NSObject {
@private
    NSMenu       *dockMenu;
    Preferences  *prefs;
    NSStatusItem *statusItem;
    NSMenu       *tapMenu;
    NSMenuItem   *tapClickItem;
    NSMenuItem   *tapPrefItem;
    NSMenuItem   *tapQuitItem;
    AppDelegate  *appDelegate;
}

@property (retain) Preferences  *prefs;
@property (retain) NSStatusItem *statusItem;
@property (strong) NSMenu       *tapMenu;
@property (strong) NSMenu       *dockMenu;
@property (strong) NSMenuItem   *tapClickItem;
@property (strong) NSMenuItem   *tapPrefItem;
@property (strong) NSMenuItem   *tapQuitItem;
@property (strong) AppDelegate  *appDelegate;
@property (strong) NSMenuItem   *dockClickItem;
@property (strong) NSMenuItem   *dockPrefItem;

+ (id) instance;
- (BOOL) isClicking;
- (void) checkForChanges;

- (void) tapToggleClick;
- (void) tapPrefClick;
- (void) tapQuitClick;

void processEvent(NSEvent *event);

@end
