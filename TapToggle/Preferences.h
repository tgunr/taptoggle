//
//  Created by davec on 01/28/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <ShortcutRecorder/ShortcutRecorder.h>

@interface Preferences : NSObject {
@private
    NSUserDefaults *userDefaults;
    BOOL _showStatus;
    BOOL _checkWeekly;
    BOOL _anonInfo;
    BOOL _useHotKey;
    NSString *_prefsVersion;
    NSDate   *lastCheck;
    KeyCombo hotKeyCombo;
    BOOL     _showDock;
    BOOL     _shouldRun;
    BOOL     _loginItem;
}

@property (retain) NSUserDefaults *userDefaults;

// These are set by the Preferences.plist for default values
@property (nonatomic, assign, setter=setShowStatus:, getter=showStatus, readonly) BOOL _showStatus;
@property (nonatomic, assign, setter=setCheckWeekly:, getter=checkWeekly) BOOL         _checkWeekly;
@property (nonatomic, assign, setter=setAnonInfo:, getter=anonInfo) BOOL               _anonInfo;
@property (nonatomic, assign, setter=setUseHotKey:, getter=useHotKey) BOOL             _useHotKey;
@property (nonatomic, strong, setter=setPrefsVersion:, getter=prefsVersion) NSString *_prefsVersion;
@property (nonatomic, strong, setter=setLastCheck:, getter=lastCheck) NSDate         *_lastCheck;
@property (nonatomic, assign, setter=setKeyCombo:, getter=keyCombo) KeyCombo hotKeyCombo;
@property (nonatomic, assign, setter=setShowDock:, getter=showDock) BOOL     _showDock;
@property (nonatomic, assign, setter=setShouldRun:, getter=shouldRun) BOOL   _shouldRun;
@property (nonatomic, assign, setter=setLoginItem:, getter=loginItem) BOOL   _loginItem;

+ (id) instance;
- (void) notify;
- (Preferences *) initPreferences;
- (void) setWithDictionary:(NSDictionary *) prefDictionary;
- (NSDictionary *) dictionary;
// Property Accessors
- (void) setShowStatus:(BOOL) aShowStatus;
- (BOOL) showStatus;
- (void) setCheckWeekly:(BOOL) aCheckWeekly;
- (BOOL) checkWeekly;
- (void) setAnonInfo:(BOOL) anAnonInfo;
- (BOOL) anonInfo;
- (void) setUseHotKey:(BOOL) anUseHotKey;
- (BOOL) useHotKey;
- (void) setPrefsVersion:(NSString *) aPrefsVersion;
- (NSString *)prefsVersion;
- (void) setLastCheck:(NSDate *) aDate;
- (NSDate *) lastCheck;
- (void) setKeyCombo:(KeyCombo) aHotKeyCombo;
- (KeyCombo) keyCombo;
- (void) setShowDock:(BOOL) aShowDock;
- (BOOL) showDock;
- (void) setShouldRun:(BOOL) aShouldRun;
- (BOOL) shouldRun;
@end