//
//  Created by davec on 01/28/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <PreferencePanes/PreferencePanes.h>
#import "Preferences.h"
#import "Prefs.h"

@interface Preferences ()

@property (assign, readwrite) BOOL checkWeekly;
@property (assign, readwrite) BOOL anonInfo;
@property (assign, readwrite) BOOL useHotKey;

// These are defaulted programatically
@property (assign, readwrite) NSString *prefsVersion;
@property (assign, readwrite) NSDate   *lastCheck;
@property (assign, readwrite) BOOL     shouldRun;
@property (assign, readwrite) BOOL     checkNow;
@property (assign, readwrite) KeyCombo keyCombo;

- (void)setFromUserDefaults;
- (void)setUserDefaultsWithDictionry:(NSDictionary *)defaultDict;
@end

@implementation Preferences

@synthesize prefsVersion;
@synthesize lastCheck;
@synthesize shouldRun;
@synthesize checkNow;
@synthesize keyCombo;
@synthesize userDefaults = _userDefaults;

- (NSString *)loadDefaultsPath:(id)loader {
    NSString *loaderPath;
    if ([loader isKindOfClass:[NSApplication class]]) {
        NSBundle *mb = [NSBundle mainBundle];
        loaderPath = [mb bundlePath];
    }
    else if ([loader isKindOfClass:[NSPreferencePane class]])
        loaderPath = [[loader bundle] bundlePath];
    else
        NSLog(@"Class %@ did not implement loadDefaultsPaths!", [loader class]);
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSDictionary   *defaultPrefsDict = [defaults dictionaryRepresentation];
//    NSLog(@"Prefs: %@", defaultPrefsDict);

    _showStatus  = [defaults boolForKey:kShowStatus];
    _checkWeekly = [defaults boolForKey:kCheckWeekly];
    _anonInfo    = [defaults boolForKey:kAnonInfo];
    _useHotKey   = [defaults boolForKey:kUseHotKey];

    keyCombo.flags = (NSUInteger) [defaults integerForKey:kHotKeyFlags];
    keyCombo.code  = [defaults integerForKey:kHotKeyCode];

    prefsVersion = [defaults stringForKey:kPrefsVersion];
    lastCheck    = [defaults objectForKey:kLastCheck];
    shouldRun    = [defaults boolForKey:kShouldRun];
    checkNow     = [defaults boolForKey:kCheckNow];

}

- (Preferences *)initPreferences:(id)sender {
//    NSString *sourcesVersion = PREFS_VERSION;
    NSString *currentVersion = nil;
//    BOOL needsUpdate = NO;
    _userDefaults = [NSUserDefaults standardUserDefaults];

    // Check preferences version for change
    if (_userDefaults)
        currentVersion = [_userDefaults stringForKey:kPrefsVersion];

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
    [_userDefaults registerDefaults:defaultDict];
//        [defaults synchronize];
    NSLog(@"Prefs: %@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
}

- (void)setWith:(NSDictionary *)prefDictionary {
    _showStatus  = [[prefDictionary objectForKey:kShowStatus] boolValue];
    _checkWeekly = [[prefDictionary objectForKey:kCheckWeekly] boolValue];
    _anonInfo    = [[prefDictionary objectForKey:kAnonInfo] boolValue];
    _useHotKey   = [[prefDictionary objectForKey:kUseHotKey] boolValue];
    keyCombo.code  = [[prefDictionary objectForKey:kHotKeyCode] integerValue];
    keyCombo.flags = (NSUInteger) [[prefDictionary objectForKey:kHotKeyFlags] integerValue];
}

- (NSDictionary *)dictionary {
    NSDictionary *prefsAsDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      [NSNumber numberWithBool:_showStatus], kShowStatus,
                                                      [NSNumber numberWithBool:_checkWeekly], kCheckWeekly,
                                                      [NSNumber numberWithBool:_anonInfo], kAnonInfo,
                                                      [NSNumber numberWithBool:_useHotKey], kUseHotKey,
                                                      [NSNumber numberWithInteger:keyCombo.code], kHotKeyCode,
                                                      [NSNumber numberWithInteger:keyCombo.flags], kHotKeyFlags,
                                                      prefsVersion, kPrefsVersion,
                                                      [NSNumber numberWithBool:shouldRun], kShouldRun,
                                                      [NSNumber numberWithBool:checkNow], kCheckNow,
                                                      nil];
    return prefsAsDict;
}

- (void)setUseHotKey:(BOOL)anUseHotKey {
    _useHotKey = anUseHotKey;
    [_userDefaults setBool:anUseHotKey forKey:kUseHotKey];
}

- (void)setAnonInfo:(BOOL)anAnonInfo {
    _anonInfo = anAnonInfo;
    [_userDefaults setBool:anAnonInfo forKey:kAnonInfo];
}

- (void)setCheckWeekly:(BOOL)aCheckWeekly {
    _checkWeekly = aCheckWeekly;
    [_userDefaults setBool:aCheckWeekly forKey:kAnonInfo];
}

- (BOOL)showStatus {
    return _showStatus;
}

- (BOOL)checkWeekly {
    return _checkWeekly;
}

- (BOOL)anonInfo {
    return _anonInfo;
}

- (BOOL)useHotKey {
    return _useHotKey;
}

- (void)setShowStatus:(BOOL)status {
    _showStatus = status;
    [_userDefaults setBool:status forKey:kShowStatus];
}

- (void)notify {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults synchronize];
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:kNotifyName object:@"TapToggle"
                                                                 userInfo:[self dictionary] deliverImmediately:YES];
}


@end
