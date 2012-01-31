@class Preferences;

#define kTrackPadPref @"com.apple.driver.AppleBluetoothMultitouch.trackpad.plist"

@interface EventMonitor : NSObject

@property (assign, readonly) Preferences  *prefs;
@property (assign, readonly) NSStatusItem *statusItem;
@property (assign, readonly) NSMenuItem   *tapClickItem;
@property (assign, readonly) NSMenuItem   *tapQuitItem;

- (EventMonitor *)initWithPreference:(Preferences *)preferences;
- (NSImage *)getClickingImage:(BOOL)clicking;
- (void)observeNotification:(NSNotification *)note;
- (void)checkForUpdate;
- (void)setupUsingPrefs;

void processEvent(NSEvent *event);

@end


