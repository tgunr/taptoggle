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

@interface TapMenuController () {
}

- (void) buildMenuExtra;
- (void) buildDockMenu;

@end

@implementation TapMenuController {
@private
}

@synthesize prefs;
@synthesize statusItem;
@synthesize tapMenu;
@synthesize tapClickItem;
@synthesize tapPrefItem;
@synthesize tapQuitItem;
@synthesize appDelegate;
@synthesize dockMenu;
@synthesize dockClickItem;
@synthesize dockPrefItem;

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
            [self buildDockMenu];
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
    tapClickItem = [[NSMenuItem alloc]
                                initWithTitle:@"Tap Click Off" action:@selector(tapToggleClick) keyEquivalent:@""];
    [tapClickItem setTarget:self];
    [tapClickItem setEnabled:YES];
    [tapMenu addItem:tapClickItem];

    tapPrefItem = [[NSMenuItem alloc] initWithTitle:@"Preferences…" action:@selector(tapPrefClick) keyEquivalent:@""];
    [tapPrefItem setEnabled:YES];
    [tapPrefItem setTarget:self];
    [tapMenu addItem:tapPrefItem];

    tapQuitItem = [[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(tapQuitClick) keyEquivalent:@""];
    [tapQuitItem setEnabled:YES];
    [tapQuitItem setTarget:self];
    [tapMenu addItem:tapQuitItem];
}

- (void) buildDockMenu {
    dockMenu = [[NSMenu alloc]
                        initWithTitle:@"TapToggle"];
    [dockMenu setAutoenablesItems:NO];
    NSMenuItem *item;

    dockClickItem = [[NSMenuItem alloc]
                                 initWithTitle:@"Tap Click Off" action:@selector(tapToggleClick) keyEquivalent:@""];
    [item setEnabled:YES];
    [item setTarget:self];
    [dockMenu addItem:dockClickItem];

    dockPrefItem = [[NSMenuItem alloc]
                                initWithTitle:@"Preferences" action:@selector(tapPrefClick) keyEquivalent:@""];
    [item setTarget:self];
    [item setEnabled:YES];
    [dockMenu addItem:dockPrefItem];

}


- (BOOL) isClicking {
    // Check the current state
    NSFileManager *fm    = [NSFileManager defaultManager];
    NSArray       *paths = [fm URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask];
    NSURL         *dPath = [paths objectAtIndex:0];
    dPath = [dPath URLByAppendingPathComponent:[NSString stringWithFormat:@"Preferences/%@", kTrackPadPref]];
    NSDictionary *tpDict = [NSDictionary dictionaryWithContentsOfFile:[dPath path]];
    NSNumber     *click  = [tpDict objectForKey:@"Clicking"];
    BOOL clicking = [click boolValue];
    return clicking;
}

- (NSImage *) getClickingImage:(BOOL) clicking {
    // Determine the image to use
    NSBundle *myBundle = [NSBundle mainBundle];
    NSString *onPath   = [myBundle pathForImageResource:@"TapToggleOn-24.png"];
    NSString *offPath  = [myBundle pathForImageResource:@"TapToggleOff-24.png"];
    NSImage  *tapImage = [[NSImage alloc] initWithContentsOfFile:offPath];

    if (clicking) {
        tapImage = [[NSImage alloc] initWithContentsOfFile:onPath];
    }
    return tapImage;
}

- (void) toggleClicking {
    NSDictionary  *dict;
    NSBundle      *myBundle = [NSBundle mainBundle];
    NSURL         *asURL    = [myBundle URLForResource:@"SysPref" withExtension:@"scpt"];
    NSAppleScript *as       = [[NSAppleScript alloc] initWithContentsOfURL:asURL error:&dict];
    [as executeAndReturnError:&dict];

    BOOL clicking = [self isClicking];
    NSImage *clickImage = [self getClickingImage:clicking];
    [statusItem setImage:clickImage];
    if (clicking) {
        [tapClickItem setTitle:@"Tap Click Off"];
        [dockClickItem setTitle:@"Tap Click Off"];
    }
    else {
        [tapClickItem setTitle:@"Tap Click On"];
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
    [[NSApp delegate] tapShowPreferences];
}

- (void) tapQuitClick {
    [[NSApplication sharedApplication] terminate:self];
}

- (void) activate {
    if (!statusItem) {
        NSStatusBar  *bar           = [NSStatusBar systemStatusBar];
        NSStatusItem *newStatusItem = [bar statusItemWithLength:NSVariableStatusItemLength];
        statusItem = newStatusItem;

        [statusItem setMenu:tapMenu];
    }
    BOOL clicking = [self isClicking];
    NSImage *theImage = [self getClickingImage:clicking];
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
    BOOL show = [prefs showStatus];
    BOOL run  = [prefs shouldRun];
    if (run) if (show)
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

void processEvent(NSEvent *event) {
    if ([event type] == NSKeyDown) {
        NSUInteger     modifiers = ([event modifierFlags] & NSDeviceIndependentModifierFlagsMask);
        unsigned short keycode   = [event keyCode];

        TapMenuController *menu        = [TapMenuController instance];
        Preferences       *preferences = [menu prefs];
        KeyCombo combo = [preferences keyCombo];

        if ([preferences useHotKey]) {
            if (keycode == combo.code) if (modifiers == combo.flags)
                [menu toggleClicking];
//            NSString *lookingFor = SRReadableStringForCocoaModifierFlagsAndKeyCode(combo.flags, combo.code);
//            PMLOG(1, @"Looking for: %@", lookingFor);
//            NSString *results = SRReadableStringForCocoaModifierFlagsAndKeyCode(modifiers, keycode);
//            PMLOG(1, @"Got: %@", results);
        }
    }
//    if ([event type] == NSLeftMouseUp) {
//        PMLOG(2, @"click event: %@", NSStringFromPoint([event locationInWindow]));
//    }
}

@end
