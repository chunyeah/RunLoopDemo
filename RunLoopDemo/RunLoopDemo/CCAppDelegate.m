//
//  AppDelegate.m
//  RunLoopDemo
//
//  Created by Chun Ye on 10/20/14.
//  Copyright (c) 2014 Chun Tips. All rights reserved.
//

#import "CCAppDelegate.h"
#import "CCTestRunLoopViewController.h"
#import "CCRunLoopThread.h"
#import "CCRunLoopCustomInputSourceThread.h"

#define kTestRunLoopThread 0
#define kTestCustomInputSpurceRunLoopThread 1

@interface CCAppDelegate ()

@property (nonatomic, strong) NSMutableArray *sources;

@end

@implementation CCAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    CCTestRunLoopViewController *testViewController = [[CCTestRunLoopViewController alloc] init];
    self.window.rootViewController = testViewController;
    
    [self.window makeKeyAndVisible];
    
    if (kTestRunLoopThread) {
        [self startRunLoopThread];
    }
    
    if (kTestCustomInputSpurceRunLoopThread) {
        [self startCustomInputSpurceRunLoopThread];
    }
    
    return YES;
}

#pragma mark - Private

- (void)startRunLoopThread
{
    CCRunLoopThread *runLoopThread = [[CCRunLoopThread alloc] init];
    [runLoopThread start];
}

- (void)startCustomInputSpurceRunLoopThread
{
    CCRunLoopCustomInputSourceThread *customInputSourceThread = [[CCRunLoopCustomInputSourceThread alloc] init];
    [customInputSourceThread start];
}

@end

@implementation CCAppDelegate (RunLoop)

- (void)registerSource:(CCRunLoopContext *)sourceContext
{
    if (!self.sources) {
        self.sources = [NSMutableArray array];
    }
    [self.sources addObject:sourceContext];
}

- (void)removeSource:(CCRunLoopContext *)sourceContext
{
    [self.sources enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CCRunLoopContext *context = obj;
        if ([context isEqual:sourceContext]) {
            [self.sources removeObject:context];
            *stop = YES;
        }
    }];
}

- (void)testInputSourceEvent
{
    CCRunLoopContext *runLoopContext = [self.sources objectAtIndex:0];
    CCRunLoopInputSource *inputSource = runLoopContext.runLoopInputSource;
    [inputSource addTestPrintCommandWithString:[[NSDate date] description]];
    [inputSource fireAllCommandsOnRunLoop:runLoopContext.runLoop];
}

@end
