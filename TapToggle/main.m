//
//  main.m
//  TapToggle
//
//  Created by Dave Carlton on 01/30/12.
//  Copyright (c) 2012 PolyMicro Systems. All rights reserved.
//

int main(int argc, char *argv[]) {

    // If debug is set, level is at least 1
#ifdef DEBUG
    int debuglevel = 1;
#else
    int debuglevel = 0;
#endif
    @autoreleasepool {
        NSArray *arguments = [[NSProcessInfo processInfo] arguments];
        for (int i = 1; i < [arguments count]; i++) {
            NSString *argument = [arguments objectAtIndex:i];
            if ([argument isEqualToString:@"--nodebug"])
                debuglevel = 0;
            if ([argument hasPrefix:@"--debug-level="]) {
                NSArray *dl = [argument componentsSeparatedByString:@"="];
                // Make sure there is a level value
                if ([dl count] == 2) {
                    debuglevel = [[dl objectAtIndex:1] intValue];
                }
                else
                    debuglevel++;
            }
            if ([argument isEqualToString:@"--kill-pref"] ||
                    [argument isEqualToString:@"--killpref"]) {
                system("rm $HOME/Library/Preferences/com.polymicrosystems.taptoggle.plist");
            }
        }
        pmLOGSetVerbose(debuglevel);

        return NSApplicationMain(argc, (const char **) argv);
    }
}
