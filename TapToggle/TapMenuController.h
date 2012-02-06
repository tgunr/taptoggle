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

@interface TapMenuController : NSObject        {
}
@property (retain) Preferences  *prefs;
@property (retain) NSStatusItem *statusItem;
@property (strong) IBOutlet NSMenu *tapMenu;
@property (weak) IBOutlet NSMenuItem *tapClickItem;
@property (weak) IBOutlet NSMenuItem *tapPrefItem;
@property (weak) IBOutlet NSMenuItem *tapQuitItem;
@property (weak) IBOutlet AppDelegate *appDelegate;

+ (id)instance;
//- (void)initWithPreferences:(__unsafe_unretained Preferences *)preferences;
- (void)checkForChanges;

- (IBAction)tapToggleClick:(id)sender;
- (IBAction)tapPrefClick:(id)sender;
- (IBAction)tapQuitClick:(id)sender;

void processEvent(NSEvent *event);

@end
