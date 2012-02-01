//
//  Created by davec on 01/28/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <ShortcutRecorder/ShortcutRecorder.h>

@interface Preferences : NSObject {
    BOOL _showStatus;
    BOOL _checkWeekly;
    BOOL _anonInfo;
    BOOL _useHotKey;
}

@property (nonatomic, assign) NSUserDefaults *userDefaults;

// These are set by the Preferences.plist for default values
@property (assign, setter=setShowStatus:, getter=showStatus) BOOL   _showStatus;
@property (assign, setter=setCheckWeekly:, getter=checkWeekly) BOOL _checkWeekly;
@property (assign, setter=setAnonInfo:, getter=anonInfo) BOOL       _anonInfo;
@property (assign, setter=setUseHotKey:, getter=useHotKey) BOOL     _useHotKey;

// These are defaulted programatically
@property (assign, readonly) NSString *prefsVersion;
@property (assign, readonly) NSDate   *lastCheck;
@property (assign, readonly) BOOL     shouldRun;
@property (assign, readonly) BOOL     checkNow;
@property (assign, readonly) KeyCombo keyCombo;

- (void)notify;
- (Preferences *)initPreferences:(id)sender;
- (void)setWith:(NSDictionary *)prefDictionary;
- (NSDictionary *)dictionary;
- (void)setShowStatus:(BOOL)aShowStatus;
- (void)setUseHotKey:(BOOL)anUseHotKey;
- (void)setAnonInfo:(BOOL)anAnonInfo;
- (void)setCheckWeekly:(BOOL)aCheckWeekly;


@end