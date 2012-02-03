//
//  Created by davec on 01/28/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <PreferencePanes/PreferencePanes.h>
#import "Preferences.h"
#import "Prefs.h"

@interface Preferences ()

- (void)setFromUserDefaults;
- (void)setUserDefaultsWithDictionry:(NSDictionary *)defaultDict;

@end

@implementation Preferences

//@synthesize showStatus;
@synthesize prefsVersion;
@synthesize lastCheck;
@synthesize shouldRun;
@synthesize keyCombo;
@synthesize userDefaults;

- (NSString *)loadDefaultsPath:(id)loader {
    NSString *loaderPath;
    if ([loader isKindOfClass:[NSApplication class]]) {
        NSBundle *mb = [NSBundle mainBundle];
        loaderPath = [mb bundlePath];
    }
    else if ([loader isKindOfClass:[NSPreferencePane class]])
        loaderPath = [[loader bundle] bundlePath];
    else {
        NSBundle *mb = [NSBundle mainBundle];
        loaderPath = [mb bundlePath];
//        NSLog(@"Class %@ did not implement loadDefaultsPaths!", [loader class]);
    }
    return loaderPath;
}

- (NSDictionary *)getInitialDefaults:(id)loader {
    NSDictionary *defaultPrefsDict;
    NSString     *bPath;

    bPath = [self loadDefaultsPath:loader];
    NSString *plistFile = [bPath
            stringByAppendingPathComponent:@"Contents/Resources/Preferences.plist"];

    //Get the Preferences Array from the default file
    defaultPrefsDict = [NSDictionary dictionaryWithContentsOfFile:plistFile];
    NSMutableDictionary *internalDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [internalDict addEntriesFromDictionary:defaultPrefsDict];

    // Set the other defaults
    [internalDict setObject:[NSString stringWithString:PREFS_VERSION] forKey:kPrefsVersion];
    [internalDict setObject:[NSDate date] forKey:kLastCheck];
    [internalDict setObject:[NSNumber numberWithBool:YES] forKey:kShouldRun];
    [internalDict setObject:[NSNumber numberWithBool:NO] forKey:kCheckNow];

    // Return all the initial default values
    return internalDict;
}

- (void)setFromUserDefaults {
    NSDictionary *defaultPrefsDict = [userDefaults dictionaryRepresentation];
    NSLog(@"Prefs: %@", defaultPrefsDict);

    showStatus   = [userDefaults boolForKey:kShowStatus];
    _checkWeekly = [userDefaults boolForKey:kCheckWeekly];
    _anonInfo    = [userDefaults boolForKey:kAnonInfo];
    _useHotKey   = [userDefaults boolForKey:kUseHotKey];

    keyCombo.flags = (NSUInteger) [userDefaults integerForKey:kHotKeyFlags];
    keyCombo.code  = [userDefaults integerForKey:kHotKeyCode];

    prefsVersion = [userDefaults stringForKey:kPrefsVersion];
    lastCheck    = [userDefaults objectForKey:kLastCheck];
    shouldRun    = [userDefaults boolForKey:kShouldRun];

}

- (Preferences *)initPreferences:(id)sender {
//    NSString *sourcesVersion = PREFS_VERSION;
    NSString *currentVersion = nil;
//    BOOL needsUpdate = NO;
    userDefaults = [NSUserDefaults standardUserDefaults];

    // Check preferences version for change
    if (userDefaults)
        currentVersion = [userDefaults stringForKey:kPrefsVersion];

    if (currentVersion == nil) {
        [self setUserDefaultsWithDictionry:[self getInitialDefaults:sender]];
    }

//    if (!currentVersion || ![sourcesVersion isEqual:currentVersion])
//        needsUpdate = YES;
//
//    if (needsUpdate) {
//        // Remove all old entires
//        NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
//        NSArray       *keys = [NSArray arrayWithObjects:
//                                               kPrefsVersion,
//                                               kShouldRun,
//                                               kStatus,
//                                               kShowStatus,
//                                               kCheckWeekly,
//                                               kAnonInfo,
//                                               kUseHotKey,
//                                               kHotKeyFlags,
//                                               kHotKeyCode,
//                                               kLastCheck,
//                                               kCheckNow,
//                                               nil];
//        for (NSString *key in keys) {
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
//        }
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        [self loadInitialDefaults:sender];
//        BOOL result = [defaults synchronize];
//        // Do any special changes here
//        if (currentVersion == nil)
//            currentVersion = @"0.0";
//        if (result)
//            NSLog(@"Updated preferences from version %@ to version %@", currentVersion, sourcesVersion);
//        else
//            NSLog(@"Failed to syncronize defaults");
//    }

    [self setFromUserDefaults];
    return self;
}

- (void)setUserDefaultsWithDictionry:(NSDictionary *)defaultDict {
    [userDefaults registerDefaults:defaultDict];
//        [defaults synchronize];
    NSLog(@"Prefs: %@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
}

- (void)setWithDictionary:(NSDictionary *)prefDictionary {
    showStatus   = [[prefDictionary objectForKey:kShowStatus] boolValue];
    _checkWeekly = [[prefDictionary objectForKey:kCheckWeekly] boolValue];
    _anonInfo    = [[prefDictionary objectForKey:kAnonInfo] boolValue];
    _useHotKey   = [[prefDictionary objectForKey:kUseHotKey] boolValue];
    keyCombo.code  = [[prefDictionary objectForKey:kHotKeyCode] integerValue];
    keyCombo.flags = (NSUInteger) [[prefDictionary objectForKey:kHotKeyFlags] integerValue];
}

- (NSDictionary *)dictionary {
    NSDictionary *prefsAsDict = 
    [NSDictionary dictionaryWithObjectsAndKeys:
     [NSNumber numberWithBool:showStatus], kShowStatus,
     [NSNumber numberWithBool:_checkWeekly], kCheckWeekly,
     [NSNumber numberWithBool:_anonInfo], kAnonInfo,
     [NSNumber numberWithBool:_useHotKey], kUseHotKey,
     [NSNumber numberWithInteger:keyCombo.code], kHotKeyCode,
     [NSNumber numberWithInteger:keyCombo.flags], kHotKeyFlags,
     prefsVersion, kPrefsVersion,
     [NSNumber numberWithBool:shouldRun], kShouldRun,
     nil];
    return prefsAsDict;
}

- (void)setUseHotKey:(BOOL)anUseHotKey {
    _useHotKey = anUseHotKey;
    [userDefaults setBool:anUseHotKey forKey:kUseHotKey];
}

- (BOOL)useHotKey {
    return _useHotKey;
}

- (void)setAnonInfo:(BOOL)anAnonInfo {
    _anonInfo = anAnonInfo;
    [userDefaults setBool:anAnonInfo forKey:kAnonInfo];
}

- (BOOL)anonInfo {
    return _anonInfo;
}

- (void)setCheckWeekly:(BOOL)aCheckWeekly {
    _checkWeekly = aCheckWeekly;
    [userDefaults setBool:aCheckWeekly forKey:kCheckWeekly];
}

- (BOOL)checkWeekly {
    return _checkWeekly;
}

- (void)setShowStatus:(BOOL)status {
    showStatus = status;
    [userDefaults setBool:status forKey:kShowStatus];
}

- (BOOL)showStatus {
    return showStatus;
}

- (void)setShouldRun:(BOOL)status {
    shouldRun = status;
    [userDefaults setBool:status forKey:kShouldRun];
}

- (BOOL)showShouldRun {
    return shouldRun;
}

- (void)setKeyCombo:(KeyCombo)aKeyCombo {
    keyCombo = aKeyCombo;
    [userDefaults setInteger:keyCombo.code forKey:kHotKeyCode];
    [userDefaults setInteger:keyCombo.flags forKey:kHotKeyFlags];
}

- (void)notify {
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    [defaults synchronize];
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:kNotifyName object:@"TapToggle"
                                                                 userInfo:[self dictionary] deliverImmediately:YES];
}

@end
