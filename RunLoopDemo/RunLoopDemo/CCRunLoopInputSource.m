//
//  CCRunLoopInputSource.m
//  RunLoopDemo
//
//  Created by Chun Ye on 10/20/14.
//  Copyright (c) 2014 Chun Tips. All rights reserved.
//

#import "CCRunLoopInputSource.h"
#import "CCAppDelegate.h"

@interface CCRunLoopInputSource ()
{
    CFRunLoopSourceRef _runLoopSource;
    NSMutableArray *_commands;
    NSString *_testPrintString;
}

@end

// Run Loop Source Context的三个回调方法
void runLoopSourceScheduleRoutine (void *info, CFRunLoopRef runLoopRef, CFStringRef mode)
{
    CCRunLoopInputSource *runLoopInputSource = (__bridge CCRunLoopInputSource *)info;
    CCAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    CCRunLoopContext *runLoopContext = [[CCRunLoopContext alloc] initWithSource:runLoopInputSource runLoop:runLoopRef];
    [appDelegate registerSource:runLoopContext];
}

void runLoopSourcePerformRoutine (void *info)
{
    CCRunLoopInputSource *runLoopInputSource = (__bridge CCRunLoopInputSource *)info;
    [runLoopInputSource inputSourceFired];
}

void runLoopSourceCancelRoutine (void *info, CFRunLoopRef runLoopRef, CFStringRef mode)
{
    CCRunLoopInputSource *runLoopInputSource = (__bridge CCRunLoopInputSource *)info;
    CCAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    CCRunLoopContext *runLoopContext = [[CCRunLoopContext alloc] initWithSource:runLoopInputSource runLoop:runLoopRef];
    [appDelegate removeSource:runLoopContext];
}

@implementation CCRunLoopInputSource

#pragma mark - Public

- (instancetype)init
{
    self = [super init];
    if (self) {
        CFRunLoopSourceContext context = {0, (__bridge void *)(self), NULL, NULL, NULL, NULL, NULL,
            &runLoopSourceScheduleRoutine,
            &runLoopSourceCancelRoutine,
            &runLoopSourcePerformRoutine};
        
        _runLoopSource = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
        
        _commands = [NSMutableArray array];
    }
    return self;
}

- (void)addToCurrentRunLoop
{
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopAddSource(runLoop, _runLoopSource, kCFRunLoopDefaultMode);
}

- (void)invalidate
{
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopRemoveSource(runLoop, _runLoopSource, kCFRunLoopDefaultMode);
}

- (void)inputSourceFired
{
    NSLog(@"Enter inputSourceFired");
    
    // Test
    if (_testPrintString) {
        if ([self.delegate respondsToSelector:@selector(activeInputSourceForTestPrintStringEvent:)]) {
            [self.delegate activeInputSourceForTestPrintStringEvent:_testPrintString];
        }
    }
    
    NSLog(@"Exit inputSourceFired");
}

- (void)addCommand:(NSInteger)command data:(NSData *)data
{
    
}

- (void)addTestPrintCommandWithString:(NSString *)string
{
    _testPrintString = string;
}

- (void)fireAllCommandsOnRunLoop:(CFRunLoopRef)runLoop
{
    CFRunLoopSourceSignal(_runLoopSource);
    CFRunLoopWakeUp(runLoop);
}

@end

@implementation CCRunLoopContext

- (instancetype)initWithSource:(CCRunLoopInputSource *)runLoopInputSource runLoop:(CFRunLoopRef)runLoop
{
    self = [super init];
    if (self) {
        _runLoopInputSource = runLoopInputSource;
        _runLoop = runLoop;
    }
    return self;
}

@end
