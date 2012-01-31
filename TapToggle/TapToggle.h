//
//  TapToggle.h
//  TapToggle
//
//  Created by Dave Carlton on 01/25/12.
//  Copyright (c) 2012 PolyMicro Systems. All rights reserved.
//

//
//  TapToggle.h
//  TapToggle
//
//  Created by Dave Carlton on 01/22/12.
//  Copyright (c) 2012 PolyMicro Systems. All rights reserved.
//

#import <ShortcutRecorder/ShortcutRecorder.h>

@class SRRecorderControl;
@class Preferences;

@interface TapToggle : NSViewController

@property (assign) Preferences              *prefs;
@property (weak) IBOutlet NSView            *prefView;
@property (weak) IBOutlet NSTextField       *statusTextField;
@property (weak) IBOutlet NSButton          *showStatusCheckBox;
@property (weak) IBOutlet NSButton          *startButton;
@property (weak) IBOutlet NSButton          *weeklyCheckBox;
@property (weak) IBOutlet NSButton          *anonInfoCheckBox;
@property (weak) IBOutlet NSButton          *checkNowButton;
@property (weak) IBOutlet NSButton          *moreInfoButton;
@property (weak) IBOutlet NSButton          *installButton;
@property (weak) IBOutlet NSTextField       *versionTextField;
@property (weak) IBOutlet NSButton          *websiteButton;
@property (weak) IBOutlet NSTextField       *licensedToTextField;
@property (weak) IBOutlet NSButton          *useHotkeyCheckbox;
@property (weak) IBOutlet SRRecorderControl *hotKeyControl;
@property (strong) IBOutlet NSPanel         *infoPanel;
@property (assign) NSTimer                  *monitorCheck;

- (IBAction)showStatus:(id)sender;
- (IBAction)startClicked:(id)sender;
- (IBAction)checkWeeklyClicked:(id)sender;
- (IBAction)checkNowClicked:(id)sender;
- (IBAction)moreInfoClicked:(id)sender;
- (IBAction)installClicked:(id)sender;
- (IBAction)websiteClicked:(id)sender;
- (IBAction)testClick:(id)sender;
- (IBAction)infoDoneClicked:(id)sender;
- (IBAction)useHotkeyClicked:(id)sender;
- (IBAction)anonInfoClicked:(id)sender;
@end
