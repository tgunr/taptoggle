//
//  Created by davec on 01/28/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <ShortcutRecorder/ShortcutRecorder.h>

@interface Preferences : NSObject {
    NSUserDefaults *userDefaults;
    BOOL showStatus;
    BOOL _checkWeekly;
    BOOL _anonInfo;
    BOOL _useHotKey;
    NSString *prefsVersion;
    NSDate   *lastCheck;
    BOOL     shouldRun;
    KeyCombo keyCombo;
}

@property (retain) NSUserDefaults *userDefaults;

// These are set by the Preferences.plist for default values
//@property (assign, setter=setShowStatus:, getter=showStatus, readonly) BOOL   _showStatus;
@property (assign, setter=setCheckWeekly:, getter=checkWeekly) BOOL _checkWeekly;
@property (assign, setter=setAnonInfo:, getter=anonInfo) BOOL       _anonInfo;
@property (assign, setter=setUseHotKey:, getter=useHotKey) BOOL     _useHotKey;

// These are defaulted programatically
@property (retain) NSString *prefsVersion;
@property (retain, setter = setLastCheck:, getter=lastCheck) NSDate   *lastCheck;
@property (assign, setter=setshouldRun:, getter=shouldRun) BOOL shouldRun;
@property (assign, setter=setKeyCombo:, getter=keyCombo) KeyCombo keyCombo;

+ (id)shared;
- (void)notify;
- (Preferences *)initPreferences;
- (void)setWithDictionary:(NSDictionary *)prefDictionary;
- (NSDictionary *)dictionary;
- (void)setShowStatus:(BOOL)aShowStatus;
- (BOOL)showStatus;
- (void)setUseHotKey:(BOOL)anUseHotKey;
- (BOOL)useHotKey;
- (void)setAnonInfo:(BOOL)anAnonInfo;
- (BOOL)anonInfo;
- (void)setCheckWeekly:(BOOL)aCheckWeekly;
- (BOOL)checkWeekly;
- (void)setShouldRun:(BOOL)aShouldRun;
- (BOOL)shouldRun;

@end