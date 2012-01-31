//
//  Created by davec on 01/28/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "HotKey.h"


@implementation HotKey

@synthesize hotKeyCombo;

- (id)initWithCombo:(KeyCombo)combo {
    [super init];
    hotKeyCombo.flags = combo.flags;
    hotKeyCombo.code  = combo.code;
    return self;
}

- (NSInteger)keyCode {
    return hotKeyCombo.code;
}

- (NSInteger)keyFlags {
    return hotKeyCombo.flags;
}

- (void)setKeyCode:(NSInteger)keycode {
    hotKeyCombo.code = keycode;
}

- (void)setKeyFlags:(NSInteger)keyflags {
    hotKeyCombo.flags = keyflags;
}

- (NSString *)description {
    NSMutableString *output = [NSMutableString string];
    [output appendFormat:@"HotKey code: %x flags: %x\n", hotKeyCombo.code, hotKeyCombo.flags];
    return output;
}

@end