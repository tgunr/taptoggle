
//
//  TapToggleViewController.m
//  TapToggle
//
//  Created by Dave Carlton on 01/22/12.
//  Copyright (c) 2012 PolyMicro Systems. All rights reserved.
//

#import <ShortcutRecorder/ShortcutRecorder.h>
#import "TapToggleViewController.h"
#import "Prefs.h"
#import "Preferences.h"
#import "TapMenuController.h"

#define TapToggle_VERSION @"1.0"

@implementation TapToggleViewController

@synthesize hotKeyControl;
@synthesize infoPanel;
@synthesize mainView;
@synthesize statusTextField;
@synthesize showStatusCheckBox;
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
- (id)init {
    if ( self = [super init] ) {
        // Init code
    }
    return self;
}

- (void)setState {
    BOOL status = [prefs shouldRun];
    if (status) {
        [statusTextField setStringValue:@"Running"];
        [statusTextField setTextColor:[NSColor greenColor]];
        [startButton setTitle:@"Stop"];
        eventMonitor = [NSEvent addGlobalMonitorForEventsMatchingMask:(NSKeyDownMask | NSLeftMouseUpMask) handler:^(NSEvent *event) {
            processEvent(event);
        }];
    } else {
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

- (void)awakeFromNib {
    NSInteger prefState;
    prefs = [Preferences shared];
    [versionTextField setStringValue:TapToggle_VERSION];
    prefState = [prefs showStatus] ? NSOnState : NSOffState;
    [showStatusCheckBox setState:prefState];
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
    menuExtraController = [TapMenuController instance];
}

 - (IBAction)startClicked:(id)sender {
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
- (IBAction)showStatus:(id)sender {
    BOOL use = [showStatusCheckBox state] == NSOnState ? YES : NO;
    [prefs setShowStatus:use];
    [menuExtraController checkForChanges];
}

- (IBAction)useHotkeyClicked:(id)sender {
    BOOL use = [useHotkeyCheckbox state] == NSOnState ? YES : NO;
    [prefs setUseHotKey:use];
    [menuExtraController checkForChanges];
}

- (IBAction)anonInfoClicked:(id)sender {
    BOOL use = [anonInfoCheckBox state] == NSOnState ? YES : NO;
    [prefs setAnonInfo:use];
}

- (IBAction)checkWeeklyClicked:(id)sender {
    BOOL use = [weeklyCheckBox state] == NSOnState ? YES : NO;
    [prefs setCheckWeekly:use];
}

#pragma mark - Update code
- (IBAction)checkNowClicked:(id)sender {
//    BOOL use = [checkNowButton state] == NSOnState ? YES : NO;
    // TODO: make checkin code
}

- (void)didEndinfoPanel:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    [sheet orderOut:self];
}

- (IBAction)infoDoneClicked:(id)sender {
    [NSApp endSheet:infoPanel];
}

- (IBAction)moreInfoClicked:(id)sender {
    [NSApp beginSheet:infoPanel
       modalForWindow:[[NSApp delegate] window]
        modalDelegate:self
       didEndSelector:@selector(didEndinfoPanel:returnCode:contextInfo:)
          contextInfo:nil];
}

#pragma mark - Install
- (IBAction)installClicked:(id)sender {
    NSString *title = [installButton title];
    if ([title isEqualToString:@"Install"]) {
        [installButton setTitle:@"Uninstall"];
    }
    else {
        [installButton setTitle:@"Install"];
    }

}

#pragma mark - Misc
- (IBAction)websiteClicked:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString: @"http://TapToggle.polymicro.net"]];
}

#pragma mark - Shortcut delegate methods
- (BOOL)shortcutRecorder:(SRRecorderControl *)aRecorder isKeyCode:(signed short)keyCode andFlagsTaken:(unsigned int)flags reason:(NSString **)aReason {
    return NO;
}

- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo {
    [prefs setKeyCombo:newKeyCombo];
}

@end
