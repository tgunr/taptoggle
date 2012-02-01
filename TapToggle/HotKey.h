//
//  Created by davec on 01/28/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <ShortcutRecorder/ShortcutRecorder.h>

@interface HotKey : NSObject

@property (assign) KeyCombo hotKeyCombo;

- (id)initWithCombo:(KeyCombo)combo;
- (NSInteger)keyCode;
- (NSInteger)keyFlags;
- (void)setKeyCode:(NSInteger)keycode;
- (void)setKeyFlags:(NSInteger)keyflags;
@end

