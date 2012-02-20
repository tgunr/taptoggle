//
//  TapMenuController.m
//  TapToggle
//
//  Created by Dave Carlton on 02/03/12.
//  Copyright (c) 2012 PolyMicro Systems. All rights reserved.
//

#import "TapMenuController.h"
#import "Preferences.h"
#import "AppDelegate.h"
#import "Prefs.h"
#import "HID.h"
#import "PMLog.h"

@interface TapMenuController () {
}

- (void) buildMenuExtra;
- (void) buildDockMenu;
- (void) getMenuImages;
- (void) getDockImages;


@end

@implementation TapMenuController {
@private
}

@synthesize prefs;
@synthesize statusItem;
@synthesize tapMenu;
@synthesize menuToggleItem;
@synthesize menuPrefItem;
@synthesize menuQuitItem;
@synthesize appDelegate;
@synthesize dockMenu;
@synthesize dockClickItem;
@synthesize dockPrefItem;
@synthesize dockOffImage;
@synthesize dockOnImage;
@synthesize menuOffImage;
@synthesize menuOnImage;

static TapMenuController *sharedTapMenuContollerInstance = nil;

+ (TapMenuController *) instance {
    @synchronized (self) {
        if (sharedTapMenuContollerInstance == nil) {
            sharedTapMenuContollerInstance = [[self alloc] init];
        }
        return sharedTapMenuContollerInstance;
    }
}

- (id) init {
    self = [super init];
    if (self) {
        if (!statusItem) {
            [self buildMenuExtra];
            [self getMenuImages];
            [self buildDockMenu];
            [self getDockImages];
            prefs = [Preferences instance];
        }
    }
    return self;
}

- (void) buildMenuExtra {
    tapMenu = [[NSMenu alloc] init];

    // Build the menu items
//    [tapMenu initWithTitle:@"TapToggle"];
    [tapMenu setAutoenablesItems:NO];
    menuToggleItem = [[NSMenuItem alloc]
                                  initWithTitle:@"Set Tap Click Off" action:@selector(menuToggleClick) keyEquivalent:@""];
    [menuToggleItem setTarget:self];
    [menuToggleItem setEnabled:YES];
    [tapMenu addItem:menuToggleItem];

    menuPrefItem = [[NSMenuItem alloc] initWithTitle:@"Preferences…" action:@selector(menuPrefClick) keyEquivalent:@""];
    [menuPrefItem setEnabled:YES];
    [menuPrefItem setTarget:self];
    [tapMenu addItem:menuPrefItem];

    menuQuitItem = [[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(menuQuitClick) keyEquivalent:@""];
    [menuQuitItem setEnabled:YES];
    [menuQuitItem setTarget:self];
    [tapMenu addItem:menuQuitItem];
}

- (void) buildDockMenu {
    dockMenu = [[NSMenu alloc]
                        initWithTitle:@"TapToggle"];
    [dockMenu setAutoenablesItems:NO];
    NSMenuItem *item;

    dockClickItem = [[NSMenuItem alloc]
                                 initWithTitle:@"Set Tap Click Off" action:@selector(menuToggleClick) keyEquivalent:@""];
    [dockClickItem setEnabled:YES];
    [dockClickItem setTarget:self];
    [dockMenu addItem:dockClickItem];

    dockPrefItem = [[NSMenuItem alloc]
                                initWithTitle:@"Preferences" action:@selector(menuPrefClick) keyEquivalent:@""];
    [dockPrefItem setTarget:self];
    [dockPrefItem setEnabled:YES];
    [dockMenu addItem:dockPrefItem];

}

- (BOOL)haveTrackPad {
    long count = IOBluetoothFindNumberOfRegistryEntriesOfClassName("AppleUSBTCButtons");
    count += IOBluetoothFindNumberOfRegistryEntriesOfClassName("BNBTrackpadDevice");
    BOOL haveTrackPad = (count != 0) ? YES : NO;
    if (!haveTrackPad) {
        PMLogWarn(@"No trackpad detected with AppleUSBTCButtons");
    }
    return haveTrackPad;
}

- (BOOL) getTapClickState {
    BOOL clicking = NO;
    if ([self haveTrackPad]) {
        // Check the current state
        NSFileManager *fm    = [NSFileManager defaultManager];
        NSArray       *paths = [fm URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask];
        NSURL         *dPath = [paths objectAtIndex:0];
        dPath                = [dPath URLByAppendingPathComponent:[NSString stringWithFormat:@"Preferences/%@", kTrackPadPref]];
        NSDictionary *tpDict = [NSDictionary dictionaryWithContentsOfFile:[dPath path]];
        NSNumber     *click  = [tpDict objectForKey:@"Clicking"];
        clicking = [click boolValue];
    }
    return clicking;
}

- (void) getMenuImages {
    NSBundle *myBundle = [NSBundle mainBundle];
    NSString *onPath   = [myBundle pathForImageResource:@"TapToggleOn-24.png"];
    NSString *offPath  = [myBundle pathForImageResource:@"TapToggleOff-24.png"];
    menuOnImage  = [[NSImage alloc] initWithContentsOfFile:onPath];
    menuOffImage = [[NSImage alloc] initWithContentsOfFile:offPath];
}

- (void) getDockImages {
    NSBundle *myBundle = [NSBundle mainBundle];
    NSString *onPath   = [myBundle pathForImageResource:@"TapToggleOn-256.png"];
    NSString *offPath  = [myBundle pathForImageResource:@"TapToggleOff-256.png"];
    dockOnImage  = [[NSImage alloc] initWithContentsOfFile:onPath];
    dockOffImage = [[NSImage alloc] initWithContentsOfFile:offPath];
}

- (NSImage *) getMenuImage:(BOOL) state {
    // Determine the image to use
    if (state) {
        return menuOnImage;
    }
    else
        return menuOffImage;
}

- (NSImage *) getDockImage:(BOOL) state {
    // Determine the image to use
    if (state) {
        return dockOnImage;
    }
    else
        return dockOffImage;
}

- (void) setMenuTitle:(BOOL) state {
    if (state) {
        [menuToggleItem setTitle:@"Set Tap Click Off"];
        [dockClickItem setTitle:@"Set Tap Click Off"];
    }
    else {
        [menuToggleItem setTitle:@"Set Tap Click On"];
        [dockClickItem setTitle:@"Set Tap Click On"];
    }
}

- (void) setMenuImage:(BOOL) state {
    NSImage *menuImage = [self getMenuImage:state];
    [statusItem setImage:menuImage];
    NSImage *dockImage = [self getDockImage:state];
    [NSApp setApplicationIconImage:dockImage];
}

- (void) setMenus {
    BOOL clickState = [self getTapClickState];
    PMLogWarn(@"Tap Click is: %@", clickState ? @"ON" : @"OFF");
    [self setMenuTitle:clickState];
    [self setMenuImage:clickState];
}

- (void) toggleClicking {
    NSDictionary  *dict;
    NSBundle      *myBundle = [NSBundle mainBundle];
    NSURL         *asURL    = [myBundle URLForResource:@"SysPref" withExtension:@"scpt"];
    NSAppleScript *as       = [[NSAppleScript alloc] initWithContentsOfURL:asURL error:&dict];
    [as executeAndReturnError:&dict];
    [self setMenus];
}

- (void) menuToggleClick {
    [self toggleClicking];
}

- (void) menuPrefClick {
    [[NSApp delegate] tapShowPreferences];
}

- (void) menuQuitClick {
    [[NSApplication sharedApplication] terminate:self];
}

- (void) activate {
    if (!statusItem) {
        NSStatusBar  *bar           = [NSStatusBar systemStatusBar];
        NSStatusItem *newStatusItem = [bar statusItemWithLength:NSVariableStatusItemLength];
        statusItem = newStatusItem;

        [statusItem setMenu:tapMenu];
    }
    BOOL clickState = [self getTapClickState];
    NSImage *theImage = [self getMenuImage:clickState];
    [statusItem setImage:theImage];
}

- (void) deactivate {
    NSStatusBar *bar = [NSStatusBar systemStatusBar];
    if (statusItem) {
        [bar removeStatusItem:statusItem];
        statusItem = nil;
    }
}

- (void) checkShowStatusMenu {
    PMHERE;
    BOOL show = [prefs showStatus];
    BOOL run  = [prefs shouldRun];
    if (run) 
        if (show)
        [self activate];
    else
        [self deactivate];
    else
        [self deactivate];
}

- (void) checkShowDockMenu {
    BOOL showDock = [prefs showDock];
    if (showDock) {
        ProcessSerialNumber psn = {0, kCurrentProcess};
        TransformProcessType(&psn, kProcessTransformToForegroundApplication);
    }
}

- (void) checkForChanges {
    [self checkShowStatusMenu];
    [self checkShowDockMenu];
}

- (void) setupUsingPrefs {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

    BOOL value = [ud boolForKey:kShowStatus];
    if (value)
        [self activate];
    else
        [self deactivate];
}

void processRemoteEvent(NSEvent *event) {
    if ([event type] == NSKeyDown) {
        NSUInteger     modifiers = ([event modifierFlags] & NSDeviceIndependentModifierFlagsMask);
        unsigned short keycode   = [event keyCode];

        TapMenuController *menu        = [TapMenuController instance];
        Preferences       *preferences = [menu prefs];
        KeyCombo combo = [preferences keyCombo];

        if ([preferences useHotKey]) {
            NSString *lookingFor = SRReadableStringForCocoaModifierFlagsAndKeyCode(combo.flags, combo.code);
            PMLOGC(PM_LEVEL_DEBUG, @"Looking for: %@", lookingFor);
            NSString *results = SRReadableStringForCocoaModifierFlagsAndKeyCode(modifiers, keycode);
            PMLOGC(PM_LEVEL_DEBUG, @"Got: %@", results);
            if (keycode == combo.code) if (modifiers == combo.flags)
                [menu toggleClicking];
        }
    }
    
    if ([event type] == NSLeftMouseUp) {
        NSString *aPoint = NSStringFromPoint([event locationInWindow]);
        PMLOGC(PM_LEVEL_DEBUG, @"click event: %@", aPoint);
    }

}

NSEvent * processLocalEvent(NSEvent *event) {
    if ([event type] == NSKeyDown) {
        NSUInteger     modifiers = ([event modifierFlags] & NSDeviceIndependentModifierFlagsMask);
        unsigned short keycode   = [event keyCode];
        
        TapMenuController *menu        = [TapMenuController instance];
        Preferences       *preferences = [menu prefs];
        KeyCombo combo = [preferences keyCombo];
        
        if ([preferences useHotKey]) {
            NSString *lookingFor = SRReadableStringForCocoaModifierFlagsAndKeyCode(combo.flags, combo.code);
            PMLOGC(PM_LEVEL_DEBUG, @"Looking for: %@", lookingFor);
            NSString *results = SRReadableStringForCocoaModifierFlagsAndKeyCode(modifiers, keycode);
            PMLOGC(PM_LEVEL_DEBUG, @"Got: %@", results);
            if (keycode == combo.code) if (modifiers == combo.flags)
                [menu toggleClicking];
        }
    }
    
    if ([event type] == NSLeftMouseUp) {
        NSString *aPoint = NSStringFromPoint([event locationInWindow]);
        PMLOGC(PM_LEVEL_DEBUG, @"click event: %@", aPoint);
    }
    return event;
}

@end
