//
//  TapToggleViewController.m
//  TapToggle
//
//  Created by Dave Carlton on 01/22/12.
//  Copyright (c) 2012 PolyMicro Systems. All rights reserved.
//

#import <ShortcutRecorder/ShortcutRecorder.h>
#import "TapToggleViewController.h"
#import "Preferences.h"
#import "TapMenuController.h"
#import "AppDelegate.h"

#define TapToggle_VERSION @"1.0"

@interface TapToggleViewController () {
    Preferences              *prefs;
    __weak NSView            *mainView;
    __weak NSTextField       *statusTextField;
    __weak NSButton          *showStatusCheckBox;
    __weak NSButton          *showDockCheckBox;
    __weak NSButton          *loginItemCheckBox;
    __weak NSButton          *startButton;
    __weak NSButton          *weeklyCheckBox;
    __weak NSButton          *anonInfoCheckBox;
    __weak NSButton          *checkNowButton;
    __weak NSButton          *moreInfoButton;
    __weak NSButton          *installButton;
    __weak NSTextField       *versionTextField;
    __weak NSButton          *websiteButton;
    __weak NSTextField       *licensedToTextField;
    __weak NSButton          *useHotkeyCheckbox;
    __weak SRRecorderControl *hotKeyControl;
    NSPanel                  *infoPanel;
    NSTimer                  *monitorCheck;
    NSEvent                  *eventMonitor;
    TapMenuController        *menuExtraController;
}

@end

@implementation TapToggleViewController

@synthesize hotKeyControl;
@synthesize infoPanel;
@synthesize mainView;
@synthesize statusTextField;
@synthesize showStatusCheckBox;
@synthesize showDockCheckBox;
@synthesize loginItemCheckBox;
@synthesize startButton;
@synthesize weeklyCheckBox;
@synthesize anonInfoCheckBox;
@synthesize checkNowButton;
@synthesize moreInfoButton;
@synthesize installButton;
@synthesize versionTextField;
@synthesize websiteButton;
@synthesize licensedToTextField;
@synthesize useHotkeyCheckbox;
@synthesize monitorCheck;
@synthesize prefs;
@synthesize eventMonitor;
@synthesize menuExtraController;

#pragma mark - Startup

- (void) setState {
    BOOL status = [prefs shouldRun];
    if (status) {
        [statusTextField setStringValue:@"Running"];
        [statusTextField setTextColor:[NSColor greenColor]];
        [startButton setTitle:@"Stop"];
        eventMonitor = [NSEvent
                addGlobalMonitorForEventsMatchingMask:(NSKeyDownMask | NSLeftMouseUpMask) handler:^(NSEvent *event) {
                    processEvent(event);
                }];
    }
    else {
        [startButton setTitle:@"Start"];
        [statusTextField setStringValue:@"Not Running"];
        [statusTextField setTextColor:[NSColor redColor]];
//        [prefs setShouldRun:NO];
        if (eventMonitor) {
            [NSEvent removeMonitor:eventMonitor];
            eventMonitor = nil;
        }
    }
    [menuExtraController checkForChanges];
}

- (void) awakeFromNib {
    NSInteger prefState;
    prefs = [Preferences instance];

    [versionTextField setStringValue:TapToggle_VERSION];

    prefState = [prefs showStatus] ? NSOnState : NSOffState;
    [showStatusCheckBox setState:prefState];
//    [showDockCheckBox setEnabled:[prefs showStatus]];

    prefState = [prefs checkWeekly] ? NSOnState : NSOffState;
    [weeklyCheckBox setState:prefState];
    if (prefState == NSOnState) {
        [anonInfoCheckBox setEnabled:YES];
    }
    else
        [anonInfoCheckBox setEnabled:NO];

    prefState = [prefs anonInfo] ? NSOnState : NSOffState;
    [anonInfoCheckBox setState:prefState];

    prefState = [prefs useHotKey] ? NSOnState : NSOffState;
    [useHotkeyCheckbox setState:prefState];
    [hotKeyControl setKeyCombo:[prefs keyCombo]];
    if (prefState == NSOnState) {
        [hotKeyControl setHidden:NO];
    }
    else
        [hotKeyControl setHidden:YES];

    prefState = [prefs showDock] ? NSOnState : NSOffState;
    [showDockCheckBox setState:prefState];
//    [showStatusCheckBox setEnabled:[prefs showDock]];


    prefState = [prefs loginItem] ? NSOnState : NSOffState;
    [loginItemCheckBox setState:prefState];

    menuExtraController = [TapMenuController instance];

    [self setState];

}

- (IBAction) startClicked:(id) sender {
    BOOL titleIsStart = [[startButton title] isEqualToString:@"Start"] ? YES : NO;
    if (titleIsStart) {
        [prefs setShouldRun:YES];
    }
    if (!titleIsStart) {
        [prefs setShouldRun:NO];
    }
    [self setState];
    [menuExtraController checkForChanges];
}

#pragma mark - Monitor effect methods
- (IBAction) showStatus:(id) sender {
    BOOL use = [showStatusCheckBox state] == NSOnState ? YES : NO;
    [prefs setShowStatus:use];
    if (use) {
        [showDockCheckBox setEnabled:YES];
    }
    else
        [showDockCheckBox setEnabled:NO];
    [menuExtraController checkForChanges];
}

- (IBAction) loginItemClicked:(id) sender {
    BOOL use = [loginItemCheckBox state] == NSOnState ? YES : NO;
    [prefs setLoginItem:use];
    [[NSApp delegate] setLogin:use];
}

- (void) notifyQuitNeeded {
    NSAlert *alert = [NSAlert
            alertWithMessageText:@"Restart TapToggle?" defaultButton:@"Restart" alternateButton:@"Later"
                     otherButton:@"Cancel"
       informativeTextWithFormat:@"The application must be restarted to disable the dock icon"];
    [alert setAlertStyle:NSInformationalAlertStyle];
    NSInteger clicked = [alert runModal];
    switch (clicked) {
        case NSAlertDefaultReturn:
        {
            [NSApp relaunch:self];
            break;
        }
        case NSAlertAlternateReturn:
        {
            break;
        }
        case NSAlertOtherReturn:
        {
            [prefs setShowDock:YES];
            [showDockCheckBox setState:NSOnState];
            [showStatusCheckBox setEnabled:YES];
            break;
        }
    }
}


- (IBAction) showDockClicked:(id) sender {
    BOOL use      = [showDockCheckBox state] == NSOnState ? YES : NO;
    BOOL previous = [prefs showDock];
    [prefs setShowDock:use];

    BOOL proceedWIthRestart = NO;
    if (previous == YES && use == NO) {
        [self notifyQuitNeeded];
    }
    [menuExtraController checkForChanges];
}

- (IBAction) useHotkeyClicked:(id) sender {
    BOOL use = [useHotkeyCheckbox state] == NSOnState ? YES : NO;
    [prefs setUseHotKey:use];
    [menuExtraController checkForChanges];
}

- (IBAction) anonInfoClicked:(id) sender {
    BOOL use = [anonInfoCheckBox state] == NSOnState ? YES : NO;
    [prefs setAnonInfo:use];
}

- (IBAction) checkWeeklyClicked:(id) sender {
    BOOL use = [weeklyCheckBox state] == NSOnState ? YES : NO;
    [prefs setCheckWeekly:use];
}

#pragma mark - Update code
- (IBAction) checkNowClicked:(id) sender {
//    BOOL use = [checkNowButton state] == NSOnState ? YES : NO;
    // TODO: make checkin code
}

- (void) didEndinfoPanel:(NSWindow *) sheet returnCode:(NSInteger) returnCode contextInfo:(void *) contextInfo {
    [sheet orderOut:self];
}

- (IBAction) infoDoneClicked:(id) sender {
    [NSApp endSheet:infoPanel];
}

- (IBAction) moreInfoClicked:(id) sender {
    [NSApp beginSheet:infoPanel
       modalForWindow:[[NSApp delegate] window]
        modalDelegate:self
       didEndSelector:@selector(didEndinfoPanel:returnCode:contextInfo:)
          contextInfo:nil];
}

#pragma mark - Install
- (IBAction) installClicked:(id) sender {
    NSString *title = [installButton title];
    if ([title isEqualToString:@"Install"]) {
        [installButton setTitle:@"Uninstall"];
    }
    else {
        [installButton setTitle:@"Install"];
    }

}

#pragma mark - Misc
- (IBAction) websiteClicked:(id) sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://TapToggle.polymicro.net"]];
}

#pragma mark - Shortcut delegate methods
- (BOOL) shortcutRecorder:(SRRecorderControl *) aRecorder isKeyCode:(signed short) keyCode andFlagsTaken:(unsigned int) flags reason:(NSString **) aReason {
    return NO;
}

- (void) shortcutRecorder:(SRRecorderControl *) aRecorder keyComboDidChange:(KeyCombo) newKeyCombo {
    [prefs setKeyCombo:newKeyCombo];
}

@end
