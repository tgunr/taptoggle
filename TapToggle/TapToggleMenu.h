@class Preferences;

#define kTrackPadPref @"com.apple.driver.AppleBluetoothMultitouch.trackpad.plist"

@interface TapToggleMenu : NSMenu

@property (retain, readonly) Preferences  *prefs;
@property (retain, readonly) NSStatusItem *statusItem;
@property (retain, readonly) NSMenuItem   *tapClickItem;
@property (retain, readonly) NSMenuItem   *tapPrefItem;
@property (retain, readonly) NSMenuItem   *tapQuitItem;

+ (TapToggleMenu *)instance;
- (void)initWithPreferences:(__unsafe_unretained Preferences *)preferences;
- (void)checkForChanges;

void processEvent(NSEvent *event);

@end


