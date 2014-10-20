//
//  CCRunLoopCustomInputSourceThread.m
//  RunLoopDemo
//
//  Created by Chun Ye on 10/20/14.
//  Copyright (c) 2014 Chun Tips. All rights reserved.
//

#import "CCRunLoopCustomInputSourceThread.h"
#import "CCRunLoopInputSource.h"

@interface CCRunLoopCustomInputSourceThread () <CCRunLoopInputSourceTestDelegate>

@property (nonatomic, strong) CCRunLoopInputSource *customInputSource;

@end

@implementation CCRunLoopCustomInputSourceThread

- (void)main
{
    @autoreleasepool {
        NSLog(@"CCRunLoopCustomInputSourceThread Enter");
        
        NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
        
        self.customInputSource = [[CCRunLoopInputSource alloc] init];
        self.customInputSource.delegate = self;
        [self.customInputSource addToCurrentRunLoop];
        
        while (!self.cancelled) {
            NSLog(@"Enter Run Loop");
            
            // print test string;
            [self finishOtherTask];
            
            [currentRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            
            NSLog(@"Exit Run Loop");
        }
        
        NSLog(@"CCRunLoopCustomInputSourceThread Exit");
    }
}

- (void)finishOtherTask
{
    NSLog(@"Begin finishOtherTask");
    NSLog(@"🌹🌹🌹🌹🌹🌹🌹🌹🌹🌹🌹");
    NSLog(@"🌹🌹🌹🌹🌹🌹🌹🌹🌹🌹🌹");
    NSLog(@"End finishOtherTask");
}

#pragma mark - CCRunLoopInputSourceTestDelegate

- (void)activeInputSourceForTestPrintStringEvent:(NSString *)string
{
    NSLog(@"activeInputSourceForTestPrintStringEvent : %@", string);
}

@end
