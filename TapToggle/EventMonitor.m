#import <ShortcutRecorder/ShortcutRecorder.h>
#import "AppDelegate.h"
#import "Preferences.h"
#import "EventMonitor.h"
#import "Prefs.h"

@interface EventMonitor ()

@property (assign, readwrite) Preferences  *prefs;
@property (assign, readwrite) NSStatusItem *statusItem;
@property (assign, readwrite) NSMenuItem   *tapClickItem;
@property (assign, readwrite) NSMenuItem   *tapQuitItem;
@end

@implementation EventMonitor

@synthesize prefs;
@synthesize statusItem;
@synthesize tapClickItem;
@synthesize tapQuitItem;

- (EventMonitor *)initWithPreference:(Preferences *)preferences {
    self = [super init];
    if (self) {
        prefs = preferences;
    }
    return self;
}

- (BOOL)isClicking {
    // Check the current state
    NSFileManager *fm    = [NSFileManager defaultManager];
    NSArray       *paths = [fm URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask];
    NSURL         *dPath = [paths objectAtIndex:0];
    dPath = [dPath URLByAppendingPathComponent:[NSString stringWithFormat:@"Preferences/%@", kTrackPadPref]];
    NSDictionary *tpDict = [NSDictionary dictionaryWithContentsOfFile:[dPath path]];
    NSNumber     *click  = [tpDict objectForKey:@"Clicking"];
    BOOL clicking = [click boolValue];
    return clicking;
}

- (NSImage *)getClickingImage:(BOOL)clicking {
    // Determine the image to use
    NSBundle *myBundle = [NSBundle mainBundle];
    NSString *onPath   = [myBundle pathForImageResource:@"TapToggleOn-32.png"];
    NSString *offPath  = [myBundle pathForImageResource:@"TapToggleOff-32.png"];
    NSImage  *tapImage = [[NSImage alloc] initWithContentsOfFile:offPath];

    if (clicking) {
        tapImage = [[NSImage alloc] initWithContentsOfFile:onPath];
    }
    return tapImage;
}

- (void)toggleClicking {
    NSDictionary  *dict;
    NSBundle      *myBundle = [NSBundle mainBundle];
    NSURL         *asURL    = [myBundle URLForResource:@"SysPref" withExtension:@"scpt"];
    NSAppleScript *as       = [[NSAppleScript alloc] initWithContentsOfURL:asURL error:&dict];
    [as executeAndReturnError:&dict];

    BOOL clicking = [self isClicking];
    NSImage *clickImage = [self getClickingImage:clicking];
    [statusItem setImage:clickImage];
    if (clicking)
        [tapClickItem setTitle:@"Tap Click Off"];
    else
        [tapClickItem setTitle:@"Tap Click On"];
}

- (void)tapClickOff {
    [self toggleClicking];
}

- (void)tapQuit {
    [[NSApplication sharedApplication] terminate:self];
}

- (void)activateStatusMenu {
    // Setup the status item
    if (!statusItem) {
        NSStatusBar *bar = [NSStatusBar systemStatusBar];
        statusItem = [bar statusItemWithLength:NSVariableStatusItemLength];

        // Build the menu items
        NSMenu *newMenu = [[NSMenu alloc] initWithTitle:@"Tapper"];
        [newMenu setAutoenablesItems:YES];
        tapClickItem = [[NSMenuItem alloc]
                                    initWithTitle:@"Tap Click Off" action:@selector(tapClickOff) keyEquivalent:@""];
        [tapClickItem setTarget:self];
        [tapClickItem setEnabled:YES];
        [newMenu addItem:tapClickItem];

        tapQuitItem = [[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(tapQuit) keyEquivalent:@""];
        [tapQuitItem setEnabled:YES];
        [tapQuitItem setTarget:self];
        [newMenu addItem:tapQuitItem];
        // Install the item
        [statusItem setMenu:newMenu];
    }
    BOOL clicking = [self isClicking];
    NSImage *theImage = [self getClickingImage:clicking];
    [statusItem setImage:theImage];
}

- (void)deactivateStatusMenu {
    NSStatusBar *bar = [NSStatusBar systemStatusBar];
    [bar removeStatusItem:statusItem];
}

- (void)checkShowStatusMenu:(NSDictionary *)appDict {
    BOOL value = [[appDict objectForKey:kShowStatus] boolValue];
    if (value)
        [self activateStatusMenu];
    else
        [self deactivateStatusMenu];
}

- (void)checkWeekly:(NSDictionary *)appDict {
    BOOL value = [[appDict objectForKey:kCheckWeekly] boolValue];
    if (value)
        NSLog(@"Starting Weekly check timer");
    else
        NSLog(@"Stopping Weekly check timer");
}

- (void)checkAnonInfo:(NSDictionary *)appDict {
    BOOL value = [[appDict objectForKey:kAnonInfo] boolValue];
    if (value)
        NSLog(@"Will inlcude anon info");
    else
        NSLog(@"Anon info disabled");
}

- (void)checkUseHotKey:(NSDictionary *)appDict {
    BOOL value = [[appDict objectForKey:kUseHotKey] boolValue];
    if (value)
        NSLog(@"Hot key enabled");
    else
        NSLog(@"Hot key disabled");
}

- (void)checkHotKey:(NSDictionary *)appDict {
    NSInteger hkCode  = [[appDict objectForKey:kHotKeyCode] integerValue];
    NSInteger hkFlags = [[appDict objectForKey:kHotKeyFlags] integerValue];
    KeyCombo  hotkey  = {(NSUInteger) hkCode, hkFlags};
}

- (void)checkForChanges:(NSDictionary *)fromApp {
    if (fromApp) {
        BOOL value = [[fromApp objectForKey:kShouldRun] boolValue];
        if (!value) {
            [self tapQuit];
        }
        [self checkShowStatusMenu:fromApp];
        [self checkWeekly:fromApp];
        [self checkAnonInfo:fromApp];
        [self checkUseHotKey:fromApp];
    }
    else
        NSLog(@"No data from app");
}

- (void)observeNotification:(NSNotification *)note {
    NSString *name = [note name];
    if ([name isEqualToString:kNotifyName]) {
//        NSLog(@"Got: %@", (NSDictionary *) [note userInfo]);
        [self checkForChanges:(NSDictionary *) [note userInfo]];
    }
//    NSLog(@"Got Notification: %@", note);
}

- (void)checkForUpdate {
    NSTimeInterval oneWeek = 60 * 60 * 24 * 7;
    NSDate *checkDate = [NSDate dateWithTimeInterval:oneWeek sinceDate:[prefs lastCheck]];
    NSDate *today     = [NSDate date];
    NSComparisonResult checkResult = [today compare:checkDate];
    if (checkResult == NSOrderedDescending) {
        // TODO: checkin code
    }
}

- (void)setupUsingPrefs {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

    BOOL value = [ud boolForKey:kShowStatus];
    if (value)
        [self activateStatusMenu];
    else
        [self deactivateStatusMenu];

    [self checkForUpdate];
}

void processEvent(NSEvent *event) {
    if ([event type] == NSKeyDown) {
        NSUInteger     modifiers = ([event modifierFlags] & NSDeviceIndependentModifierFlagsMask);
        unsigned short keycode   = [event keyCode];
        NSApplication *app         = [NSApplication sharedApplication];
        AppDelegate   *appD        = (AppDelegate *) [app delegate];
        EventMonitor  *monitor     = [appD monitor];
        Preferences   *preferences = [monitor prefs];
        KeyCombo      combo        = [preferences keyCombo];

        if ([preferences useHotKey]) {
            if (keycode == combo.code) if (modifiers == combo.flags)
                [monitor toggleClicking];
//            NSString *lookingFor = SRReadableStringForCocoaModifierFlagsAndKeyCode(combo.flags, combo.code);
//            NSLog(@"Looking for: %@", lookingFor);
//            NSString *results = SRReadableStringForCocoaModifierFlagsAndKeyCode(modifiers, keycode);
//            NSLog(@"Got: %@", results);
        }
    }
//    if ([event type] == NSLeftMouseUp) {
//        NSLog(@"click event: %@", NSStringFromPoint([event locationInWindow]));
//    }
}

@end


