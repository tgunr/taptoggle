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

@implementation TapMenuController {
@private
}

@synthesize prefs;
@synthesize statusItem;
@synthesize tapMenu;
@synthesize tapClickItem;
@synthesize tapPrefItem;
@synthesize tapQuitItem;

+ (id)instance {
    static dispatch_once_t onceQueue;
    static TapMenuController *tapMenuController = nil;

    dispatch_once(&onceQueue, ^{
        tapMenuController = [[self alloc] init];
    });
    return tapMenuController;
}

- (IBAction)tapToggleClick:(id)sender {
}

- (IBAction)tapPrefClick:(id)sender {
}

- (IBAction)tapQuitClick:(id)sender {
}

- (id)init {
    self = [super init];
    if (self) {
        tapMenu = [[NSMenu alloc] init];
        prefs = [Preferences shared];
    }
    return self;
}

- (void)awakeFromNib {
    if (![NSBundle loadNibNamed:@"MenuExtra" owner:self])
        NSLog(@"Failed to load MenuExtra.xib");
}

- (BOOL)isClicking {
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

- (NSImage *)getClickingImage:(BOOL)clicking {
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

- (void)toggleClicking {
    NSDictionary  *dict;
    NSBundle      *myBundle = [NSBundle mainBundle];
    NSURL         *asURL    = [myBundle URLForResource:@"SysPref" withExtension:@"scpt"];
    NSAppleScript *as       = [[NSAppleScript alloc] initWithContentsOfURL:asURL error:&dict];
    [as executeAndReturnError:&dict];
    
    BOOL clicking = [self isClicking];
    NSImage *clickImage = [self getClickingImage:clicking];
    [statusItem setImage:clickImage];
    if (clicking)
        [tapClickItem setTitle:@"Tap Click Off"];
    else
        [tapClickItem setTitle:@"Tap Click On"];
    NSString *clickState = clicking ? @"ON" : @"OFF";
    NSLog(@"Tap CLick is: %@", clickState);
}

- (void)tapClickOff {
    [self toggleClicking];
}

- (void)tapQuit {
    [[NSApplication sharedApplication] terminate:self];
}

- (void)tapPreferences {
    [[NSApp delegate] tapShowPreferences];
}

- (void)activate {
    if (!statusItem) {
        NSStatusBar  *bar           = [NSStatusBar systemStatusBar];
        NSStatusItem *newStatusItem = [bar statusItemWithLength:NSVariableStatusItemLength];
        statusItem = newStatusItem;
        // Install the item
        [statusItem setMenu:tapMenu];
    }
    BOOL clicking = [self isClicking];
    NSImage *theImage = [self getClickingImage:clicking];
    [statusItem setImage:theImage];
}

- (void)deactivate {
    NSStatusBar *bar = [NSStatusBar systemStatusBar];
    if (statusItem) {
        [bar removeStatusItem:statusItem];
        statusItem = nil;
    }
}

- (void)checkShowStatusMenu {
    BOOL show = [prefs showStatus];
    BOOL run  = [prefs shouldRun];
    if (run) if (show)
        [self activate];
    else
        [self deactivate];
    else
        [self deactivate];
}

- (void)checkForChanges {
    [self checkShowStatusMenu];
}

- (void)setupUsingPrefs {
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
        Preferences   *preferences = [menu prefs];
        KeyCombo combo = [preferences keyCombo];
        
        if ([preferences useHotKey]) {
            if (keycode == combo.code) if (modifiers == combo.flags)
                [menu toggleClicking];
            NSString *lookingFor = SRReadableStringForCocoaModifierFlagsAndKeyCode(combo.flags, combo.code);
            NSLog(@"Looking for: %@", lookingFor);
            NSString *results = SRReadableStringForCocoaModifierFlagsAndKeyCode(modifiers, keycode);
            NSLog(@"Got: %@", results);
        }
    }
    if ([event type] == NSLeftMouseUp) {
        NSLog(@"click event: %@", NSStringFromPoint([event locationInWindow]));
    }
}

@end
