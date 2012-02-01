//
//  TapToggle.m
//  TapToggle
//
//  Created by Dave Carlton on 01/22/12.
//  Copyright (c) 2012 PolyMicro Systems. All rights reserved.
//

#import <ShortcutRecorder/ShortcutRecorder.h>
#import "TapToggle.h"
#import "Prefs.h"
#import "Preferences.h"

#define TapToggle_VERSION @"1.0"

@implementation TapToggle

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

#pragma mark - Startup

- (void)awakeFromNib {
    NSInteger prefState;
    prefs = [[Preferences alloc] initPreferences:self];
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
}

- (IBAction)startClicked:(id)sender {
    BOOL titleIsStart = [[startButton title] isEqualToString:@"Start"] ? YES : NO;
    if (titleIsStart) {
        [startButton setTitle:@"Stop"];
    }
    if (!titleIsStart) {
        [startButton setTitle:@"Start"];
    }
}

#pragma mark - Monitor effect methods
- (IBAction)showStatus:(id)sender {
    BOOL use = [showStatusCheckBox state] == NSOnState ? YES : NO;
    [prefs setShowStatus:use];
}

- (IBAction)useHotkeyClicked:(id)sender {
    BOOL use = [useHotkeyCheckbox state] == NSOnState ? YES : NO;
    [prefs setUseHotKey:use];
}

- (IBAction)checkNowClicked:(id)sender {
    BOOL use = [checkNowButton state] == NSOnState ? YES : NO;
    // TODO: make checkin code
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
}

#pragma mark - Shortcut delegate methods
- (BOOL)shortcutRecorder:(SRRecorderControl *)aRecorder isKeyCode:(signed short)keyCode andFlagsTaken:(unsigned int)flags reason:(NSString **)aReason {
    return NO;
}

- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo {
//    [prefs setKeyCombo:newKeyCombo];
}

@end
