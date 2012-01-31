//
//  Created by davec on 01/28/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <ShortcutRecorder/ShortcutRecorder.h>

@interface Preferences : NSObject
// These are set by the Preferences.plist for default values
@property(assign, readonly) BOOL showStatus;
@property(assign, readonly) BOOL checkWeekly;
@property(assign, readonly) BOOL anonInfo;
@property(assign, readonly) BOOL useHotKey;

// These are defaulted programatically
@property(assign, readonly) NSString *prefsVersion;
@property(assign, readonly) NSDate   *lastCheck;
@property(assign, readonly) BOOL shouldRun;
@property(assign, readonly) BOOL checkNow;
@property(assign, readonly) KeyCombo keyCombo;

- (void)notify;
- (Preferences *)initPreferences:(id)sender;
- (void)setWith:(NSDictionary *)prefDictionary;
- (NSDictionary *)dictionary;
@end