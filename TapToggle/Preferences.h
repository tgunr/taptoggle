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
    BOOL     checkNow;
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
@property (retain) NSDate   *lastCheck;
@property (assign) BOOL                                           shouldRun;
@property (assign) BOOL                                           checkNow;
@property (assign, setter=setKeyCombo:, getter=keyCombo) KeyCombo keyCombo;

- (void)notify;
- (Preferences *)initPreferences:(id)sender;
- (void)setWith:(NSDictionary *)prefDictionary;
- (NSDictionary *)dictionary;
- (BOOL)showStatus;
- (void)setShowStatus:(BOOL)aShowStatus;
- (void)setUseHotKey:(BOOL)anUseHotKey;
- (void)setAnonInfo:(BOOL)anAnonInfo;
- (void)setCheckWeekly:(BOOL)aCheckWeekly;


@end