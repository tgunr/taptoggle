//
//  main.m
//  relaunch
//
//  Created by Dave Carlton on 02/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TerminationListener : NSObject
{
    const char *executablePath;
    pid_t parentProcessId;
}

- (void) relaunch;

@end

@implementation TerminationListener

- (id) initWithExecutablePath:(const char *)execPath parentProcessId:(pid_t)ppid
{
    self = [super init];
    if (self != nil) {
        executablePath = execPath;
        parentProcessId = ppid;
        
        // This adds the input source required by the run loop
        [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(applicationDidTerminate:) name:NSWorkspaceDidTerminateApplicationNotification object:nil];
        if (getppid() == 1) {
            NSLog(@"Parent already terminated");
            // ppid is launchd (1) => parent terminated already
            [self relaunch];
        }
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
    [[NSWorkspace sharedWorkspace] launchApplication:[NSString stringWithUTF8String:executablePath]];
    exit(0);
}

@end

int main(int argc, char *argv[])
{
    BOOL success;
    @autoreleasepool {
        
        pid_t parentPID = atoi(argv[2]);
        ProcessSerialNumber psn;
        while (GetProcessForPID(parentPID, &psn) != procNotFound) {
            NSLog(@"Waiting for TapToggle to quit");
            sleep(3);
        }        
        NSString *appPath = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
        NSLog(@"Starting relaunch");
        success = [[NSWorkspace sharedWorkspace] openFile:[appPath stringByExpandingTildeInPath]];
        
        if (!success)
            NSLog(@"Error: could not relaunch application at %@", appPath);
        
    }
    return (success) ? 0 : 1;
}
