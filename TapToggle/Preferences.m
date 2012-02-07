//
//  Created by davec on 01/28/12.
//


#import <PreferencePanes/PreferencePanes.h>
#import "Preferences.h"
#import "Prefs.h"

@interface Preferences ()

- (void) setFromUserDefaults;
- (void) setUserDefaultsWithDictionry:(NSDictionary *) defaultDict;

@end

@implementation Preferences

@synthesize userDefaults;

+ (id) instance {
    static dispatch_once_t onceQueue;
    static Preferences *preferences = nil;

    dispatch_once(&onceQueue, ^{
        preferences = [[self alloc] initPreferences];
    });
    return preferences;
}

- (NSString *) loadDefaultsPath:(id) loader {
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

- (NSDictionary *) getInitialDefaults {
    NSDictionary *defaultPrefsDict;
    NSString     *bPath;
    NSBundle     *mb = [NSBundle mainBundle];
    bPath = [mb bundlePath];

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

- (void) setFromUserDefaults {
    NSDictionary *defaultPrefsDict = [userDefaults dictionaryRepresentation];
    PMLOG(2, @"Prefs: %@", defaultPrefsDict);

    _showStatus   = [userDefaults boolForKey:kShowStatus];
    _checkWeekly  = [userDefaults boolForKey:kCheckWeekly];
    _anonInfo     = [userDefaults boolForKey:kAnonInfo];
    _useHotKey    = [userDefaults boolForKey:kUseHotKey];
    _prefsVersion = [userDefaults stringForKey:kPrefsVersion];
    lastCheck     = [userDefaults objectForKey:kLastCheck];

    hotKeyCombo.flags = (NSUInteger) [userDefaults integerForKey:kHotKeyFlags];
    hotKeyCombo.code  = [userDefaults integerForKey:kHotKeyCode];

    _showDock  = [userDefaults boolForKey:kShowDock];
    _shouldRun = [userDefaults boolForKey:kShouldRun];
    _loginItem = [userDefaults boolForKey:kLoginItem];
}

- (Preferences *) initPreferences {
    self = [super init];
    if (self) {
        NSString *currentVersion = nil;
        userDefaults             = [NSUserDefaults standardUserDefaults];

        // Check preferences version for change
        if (userDefaults)
            currentVersion = [userDefaults stringForKey:kPrefsVersion];

        if (currentVersion == nil) {
            [self setUserDefaultsWithDictionry:[self getInitialDefaults]];
        }

        NSString *sourcesVersion = PREFS_VERSION;
        BOOL needsUpdate = NO;
        if (![currentVersion isEqualToString:sourcesVersion])
            needsUpdate = YES;

        if (needsUpdate) {
            // Do need preference conversion here
            [self setPrefsVersion:sourcesVersion];
        }

        [self setFromUserDefaults];
    }
    return self;
}

- (void) setUserDefaultsWithDictionry:(NSDictionary *) defaultDict {
    [userDefaults registerDefaults:defaultDict];
//        [defaults synchronize];
    PMLOG(1, @"Prefs: %@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
}

- (void) setWithDictionary:(NSDictionary *) prefDictionary {
    _showStatus  = [[prefDictionary objectForKey:kShowStatus] boolValue];
    _checkWeekly = [[prefDictionary objectForKey:kCheckWeekly] boolValue];
    _anonInfo    = [[prefDictionary objectForKey:kAnonInfo] boolValue];
    _useHotKey   = [[prefDictionary objectForKey:kUseHotKey] boolValue];
    hotKeyCombo.code  = [[prefDictionary objectForKey:kHotKeyCode] integerValue];
    hotKeyCombo.flags = (NSUInteger) [[prefDictionary objectForKey:kHotKeyFlags] integerValue];
}

- (NSDictionary *) dictionary {
    NSDictionary *prefsAsDict =
                         [NSDictionary dictionaryWithObjectsAndKeys:
                                               [NSNumber numberWithBool:_showStatus], kShowStatus,
                                               [NSNumber numberWithBool:_checkWeekly], kCheckWeekly,
                                               [NSNumber numberWithBool:_anonInfo], kAnonInfo,
                                               [NSNumber numberWithBool:_useHotKey], kUseHotKey,
                                               [NSNumber numberWithInteger:hotKeyCombo.code], kHotKeyCode,
                                               [NSNumber numberWithInteger:hotKeyCombo.flags], kHotKeyFlags,
                                               _prefsVersion, kPrefsVersion,
                                               [NSNumber numberWithBool:_shouldRun], kShouldRun,
                                               nil];
    return prefsAsDict;
}

- (void) setUseHotKey:(BOOL) anUseHotKey {
    _useHotKey = anUseHotKey;
    [userDefaults setBool:anUseHotKey forKey:kUseHotKey];
}

- (BOOL) useHotKey {
    return _useHotKey;
}

- (void) setAnonInfo:(BOOL) anAnonInfo {
    _anonInfo = anAnonInfo;
    [userDefaults setBool:anAnonInfo forKey:kAnonInfo];
}

- (BOOL) anonInfo {
    return _anonInfo;
}

- (void) setCheckWeekly:(BOOL) aCheckWeekly {
    _checkWeekly = aCheckWeekly;
    [userDefaults setBool:aCheckWeekly forKey:kCheckWeekly];
}

- (BOOL) checkWeekly {
    return _checkWeekly;
}

- (void) setShowStatus:(BOOL) status {
    _showStatus = status;
    [userDefaults setBool:status forKey:kShowStatus];
}

- (BOOL) showStatus {
    return _showStatus;
}

- (void) setShouldRun:(BOOL) status {
    _shouldRun = status;
    [userDefaults setBool:status forKey:kShouldRun];
}

- (BOOL) shouldRun {
    return _shouldRun;
}

- (KeyCombo) keyCombo {
    return hotKeyCombo;
}

- (void) setKeyCombo:(KeyCombo) aHotKeyCombo {
    hotKeyCombo = aHotKeyCombo;
    [userDefaults setInteger:aHotKeyCombo.code forKey:kHotKeyCode];
    [userDefaults setInteger:aHotKeyCombo.flags forKey:kHotKeyFlags];
}

- (void) setShowDock:(BOOL) aShowDock {
    _showDock = aShowDock;
    [userDefaults setBool:aShowDock forKey:kShowDock];
}

- (BOOL) showDock {
    return _showDock;
}

- (NSString *) prefsVersion {
    return _prefsVersion;
}

- (void) setPrefsVersion:(NSString *) aPrefsVersion {
    _prefsVersion = aPrefsVersion;
    [userDefaults setObject:aPrefsVersion forKey:kPrefsVersion];
}

- (NSDate *) lastCheck {
    return lastCheck;
}

- (void) setLastCheck:(NSDate *) aLastCheck {
    lastCheck = aLastCheck;
    [userDefaults setObject:aLastCheck forKey:kLastCheck];
}

- (void) setLoginItem:(BOOL) aLoginItem {
    _loginItem = aLoginItem;
    [userDefaults setBool:aLoginItem forKey:kLoginItem];
}

- (BOOL) loginItem {
    return _loginItem;
}

- (void) notify {
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    [defaults synchronize];
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:kNotifyName object:@"TapToggle"
                                                                 userInfo:[self dictionary] deliverImmediately:YES];
}


@end
