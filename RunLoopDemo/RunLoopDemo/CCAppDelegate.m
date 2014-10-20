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

#define kTestRunLoopThread 0

@interface CCAppDelegate ()

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
    
    return YES;
}

#pragma mark - Private

- (void)startRunLoopThread
{
    CCRunLoopThread *runLoopThread = [[CCRunLoopThread alloc] init];
    [runLoopThread start];
}

@end
