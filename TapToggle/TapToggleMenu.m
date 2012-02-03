#import <ShortcutRecorder/ShortcutRecorder.h>
#import "AppDelegate.h"
#import "Preferences.h"
#import "TapToggleMenu.h"
#import "Prefs.h"

@interface TapToggleMenu () {
@private

}

- (void)setupUsingPrefs;
@property (retain, readwrite) NSMenuItem *statusItem;
@property (retain, readwrite) NSMenuItem *tapPrefItem;
@property (retain, readwrite) NSMenuItem *tapQuitItem;


@end

@implementation TapToggleMenu {
    Preferences *prefs;
    NSMenuItem  *tapPrefItem;
@private
    NSMenuItem *_tapPrefItem;
}

@synthesize prefs;
@synthesize statusItem;
@synthesize tapClickItem;
@synthesize tapQuitItem;
@synthesize tapPrefItem = _tapPrefItem;


+ (TapToggleMenu *)instance {
    static TapToggleMenu *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

- (void)initWithPreferences:(__unsafe_unretained Preferences *)preferences {
    prefs = preferences;
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
    NSString *onPath   = [myBundle pathForImageResource:@"TapToggleOn-24.png"];
    NSString *offPath  = [myBundle pathForImageResource:@"TapToggleOff-24.png"];
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
    NSString *clickState = clicking ? @"ON" : @"OFF";
    NSLog(@"Tap CLick is: %@", clickState);
}

- (void)tapClickOff {
    [self toggleClicking];
}

- (void)tapQuit {
    [[NSApplication sharedApplication] terminate:self];
}

- (void)tapPreferences {
    [[NSApp delegate] tapShowPreferences];
}

- (void)activate {
    if (!statusItem) {
        NSStatusBar  *bar           = [NSStatusBar systemStatusBar];
        NSStatusItem *newStatusItem = [bar statusItemWithLength:NSVariableStatusItemLength];
        statusItem = newStatusItem;
//        [self initWithTitle:@"TapToggle"];
        [self setAutoenablesItems:YES];

        // Build the menu items
        tapClickItem = [[NSMenuItem alloc]
                                    initWithTitle:@"Tap Click Off" action:@selector(tapClickOff) keyEquivalent:@""];
        [tapClickItem setTarget:self];
        [tapClickItem setEnabled:YES];
        [self addItem:tapClickItem];

        tapPrefItem = [[NSMenuItem alloc]
                                   initWithTitle:@"Preferences" action:@selector(tapPreferences) keyEquivalent:@""];
        [tapPrefItem setTarget:self];
        [tapPrefItem setEnabled:YES];
        [self addItem:tapPrefItem];

        tapQuitItem = [[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(tapQuit) keyEquivalent:@""];
        [tapQuitItem setEnabled:YES];
        [tapQuitItem setTarget:self];
        [self addItem:tapQuitItem];

        // Install the item
        [statusItem setMenu:self];
    }
    BOOL clicking = [self isClicking];
    NSImage *theImage = [self getClickingImage:clicking];
    [statusItem setImage:theImage];
}

- (void)deactivate {
    NSStatusBar *bar = [NSStatusBar systemStatusBar];
    if (statusItem) {
        [bar removeStatusItem:statusItem];
        statusItem = nil;
    }
}

- (void)checkShowStatusMenu {
    BOOL show = [prefs showStatus];
    BOOL run  = [prefs shouldRun];
    if (run) if (show)
        [self activate];
    else
        [self deactivate];
    else
        [self deactivate];
}

- (void)checkForChanges {
    [self checkShowStatusMenu];
}

- (void)setupUsingPrefs {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

    BOOL value = [ud boolForKey:kShowStatus];
    if (value)
        [self activate];
    else
        [self deactivate];
}

void processEvent(NSEvent *event) {
    if ([event type] == NSKeyDown) {
        NSUInteger     modifiers = ([event modifierFlags] & NSDeviceIndependentModifierFlagsMask);
        unsigned short keycode   = [event keyCode];

        TapToggleMenu *menu        = [TapToggleMenu instance];
        Preferences   *preferences = [menu prefs];
        KeyCombo combo = [preferences keyCombo];

        if ([preferences useHotKey]) {
            if (keycode == combo.code) if (modifiers == combo.flags)
                [menu toggleClicking];
            NSString *lookingFor = SRReadableStringForCocoaModifierFlagsAndKeyCode(combo.flags, combo.code);
            NSLog(@"Looking for: %@", lookingFor);
            NSString *results = SRReadableStringForCocoaModifierFlagsAndKeyCode(modifiers, keycode);
            NSLog(@"Got: %@", results);
        }
    }
    if ([event type] == NSLeftMouseUp) {
        NSLog(@"click event: %@", NSStringFromPoint([event locationInWindow]));
    }
}

@end


