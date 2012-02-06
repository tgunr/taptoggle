//
//  Created by davec on 01/28/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <ShortcutRecorder/ShortcutRecorder.h>

@interface Preferences : NSObject {
}

@property (retain) NSUserDefaults *userDefaults;

// These are set by the Preferences.plist for default values
@property (assign, setter=setShowStatus:, getter=showStatus, readonly) BOOL   _showStatus;
@property (assign, setter=setCheckWeekly:, getter=checkWeekly) BOOL _checkWeekly;
@property (assign, setter=setAnonInfo:, getter=anonInfo) BOOL       _anonInfo;
@property (assign, setter=setUseHotKey:, getter=useHotKey) BOOL     _useHotKey;
@property (retain, setter=setPrefsVersion:, getter=prefsVersion) NSString *_prefsVersion;
@property (retain, setter=setLastCheck:, getter=lastCheck) NSDate       *_lastCheck;
@property (assign, setter=setShouldRun:, getter=shouldRun) BOOL              _shouldRun;
@property (nonatomic, assign, setter=setKeyCombo:, getter=keyCombo) KeyCombo _keyCombo;


+ (id)instance;
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
- (void)setKeyCombo:(KeyCombo)aHotKeyCombo;
- (KeyCombo)keyCombo;
- (void)setPrefsVersion:(NSString *)aPrefsVersion;
- (NSString *)prefsVersion;
@end