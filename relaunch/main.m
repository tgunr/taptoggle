//
//  main.m
//  relaunch
//
//  Created by Dave Carlton on 02/06/12.
//  Copyright (c) 2012 PolyMicro Systems. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TerminationListener : NSObject
{
    const char *executablePath;
    pid_t parentProcessId;
}

- (void)relaunch __dead2;

@end

@implementation TerminationListener

- (void)watchdog:(NSTimer *)timer
{
	ProcessSerialNumber psn;
	if (GetProcessForPID(parentProcessId, &psn) == procNotFound)
		[self relaunch];
}

- (id) initWithExecutablePath:(const char *)execPath parentProcessId:(pid_t)ppid
{
    self = [super init];
    if (self != nil) {
        executablePath = execPath;
        parentProcessId = ppid;
        
        NSLog(@"Setting up termination watch");

        if (getppid() == 1) {
            NSLog(@"Parent already terminated");
            // ppid is launchd (1) => parent terminated already
            [self relaunch];
        }

		[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(watchdog:) userInfo:nil repeats:YES];

    }
    return self;
}

- (void) applicationDidTerminate:(NSNotification *)notification
{
    if (parentProcessId == [[[notification userInfo] valueForKey:@"NSApplicationProcessIdentifier"] intValue]) {
        // parent just terminated
        NSLog(@"Parent just terminated");
        [self relaunch];
    }
}

- (void) relaunch
{
    BOOL result = [[NSWorkspace sharedWorkspace] launchApplication:[NSString stringWithUTF8String:executablePath]];
    NSLog(@"relaunching: %s result: %d", executablePath, result);
    exit(0);
}

@end

int main(int argc, char *argv[])
{
    if (argc != 3) return EXIT_FAILURE;

    @autoreleasepool {
        NSLog(@"relaunch: %s", argv[1]);
        [NSApplication sharedApplication];
        [[[TerminationListener alloc] initWithExecutablePath:argv[1] parentProcessId:atoi(argv[2])] autorelease];
        [[NSApplication sharedApplication] run];
    }

    return EXIT_SUCCESS;
}
