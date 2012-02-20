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
    NSMenuItem   *menuToggleItem;
    NSMenuItem   *menuPrefItem;
    NSMenuItem   *menuQuitItem;
    NSMenuItem   *dockClickItem;
    NSMenuItem   *dockPrefItem;
    NSImage      *menuOnImage;
    NSImage      *menuOffImage;
    NSImage      *dockOnImage;
    NSImage      *dockOffImage;
    AppDelegate  *appDelegate;
}

@property (nonatomic, retain) Preferences  *prefs;
@property (nonatomic, retain) NSStatusItem *statusItem;
@property (nonatomic, strong) NSMenu       *tapMenu;
@property (nonatomic, strong) NSMenu       *dockMenu;
@property (nonatomic, strong) NSMenuItem   *menuToggleItem;
@property (nonatomic, strong) NSMenuItem   *menuPrefItem;
@property (nonatomic, strong) NSMenuItem   *menuQuitItem;
@property (nonatomic, strong) AppDelegate  *appDelegate;
@property (nonatomic, strong) NSMenuItem   *dockClickItem;
@property (nonatomic, strong) NSMenuItem   *dockPrefItem;
@property (nonatomic, strong) NSImage      *dockOffImage;
@property (nonatomic, strong) NSImage      *dockOnImage;
@property (nonatomic, strong) NSImage      *menuOffImage;
@property (nonatomic, strong) NSImage      *menuOnImage;


+ (id) instance;
- (BOOL) getTapClickState;
- (NSImage *) getMenuImage:(BOOL) state;
- (void) checkForChanges;

- (void) setMenus;
- (void) menuToggleClick;
- (void) menuPrefClick;
- (void) menuQuitClick;

void processRemoteEvent(NSEvent *event);
NSEvent * processLocalEvent(NSEvent *event);
- (BOOL)haveTrackPad;
@end
