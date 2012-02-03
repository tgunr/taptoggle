@class Preferences;

#define kTrackPadPref @"com.apple.driver.AppleBluetoothMultitouch.trackpad.plist"

@interface TapToggleMenu : NSMenu

@property (assign, readonly) Preferences  *prefs;
@property (retain, readonly) NSStatusItem *statusItem;
@property (retain, readonly) NSMenuItem   *tapClickItem;
@property (retain, readonly) NSMenuItem   *tapQuitItem;

+ (TapToggleMenu *)instance;
- (void)initWithPreferences:(__unsafe_unretained Preferences *)preferences;
//- (NSImage *)getClickingImage:(BOOL)clicking;
//- (void)observeNotification:(NSNotification *)note;
//- (void)checkForUpdate;
- (void)checkForChanges;

void processEvent(NSEvent *event);

@end


