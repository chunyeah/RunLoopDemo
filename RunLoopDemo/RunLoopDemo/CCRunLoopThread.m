//
//  CCRunLoopThread.m
//  RunLoopDemo
//
//  Created by Chun Ye on 10/20/14.
//  Copyright (c) 2014 Chun Tips. All rights reserved.
//

#import "CCRunLoopThread.h"

#define kUseParticularModeToStartRunLoop    0

@implementation CCRunLoopThread
{
    NSInteger _timerIndex;
}

- (void)main
{
    @autoreleasepool {
        NSLog(@"Thread Enter");
        
        NSRunLoop *currentThreadRunLoop = [NSRunLoop currentRunLoop];
        // 或者
        // CFRunLoopRef currentThreadRunLoop = CFRunLoopGetCurrent();
        
        // 创建一个 Run Loop Observer，并添加到当前Run Loop中, 设置Mode为Default
        CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
        CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &currentRunLoopObserver, &context);
        
        if (observer) {
            CFRunLoopRef runLoopRef = currentThreadRunLoop.getCFRunLoop;
            CFRunLoopAddObserver(runLoopRef, observer, kCFRunLoopDefaultMode);
        }
        
        // 创建一个Timer，重复调用来驱动Run Loop
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleTimerTask) userInfo:nil repeats:YES];
        
        NSInteger loopCount = 10;
        
        // 执行Run Loop10次后退出，每次Run Loop返回的时候检查是否有使线程退出的条件成立
        do {
            NSLog(@"LoopCount: %ld", loopCount);
            if (kUseParticularModeToStartRunLoop) {
                [currentThreadRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            } else {
                [currentThreadRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
            }
            loopCount --;
        } while (loopCount);
        
        NSLog(@"Thread Exit");
    }
}

#pragma mark - Observer CallBack

void currentRunLoopObserver(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    NSLog(@"Current thread Run Loop activity: %@", printActivity(activity));
}

static inline NSString* printActivity(CFRunLoopActivity activity)
{
    NSString *activityDescription;
    switch (activity) {
        case kCFRunLoopEntry:
            activityDescription = @"kCFRunLoopEntry";
            break;
        case kCFRunLoopBeforeTimers:
            activityDescription = @"kCFRunLoopBeforeTimers";
            break;
        case kCFRunLoopBeforeSources:
            activityDescription = @"kCFRunLoopBeforeSources";
            break;
        case kCFRunLoopBeforeWaiting:
            activityDescription = @"kCFRunLoopBeforeWaiting";
            break;
        case kCFRunLoopAfterWaiting:
            activityDescription = @"kCFRunLoopAfterWaiting";
            break;
        case kCFRunLoopExit:
            activityDescription = @"kCFRunLoopExit";
            break;
        default:
            break;
    }
    return activityDescription;
}

#pragma mark - Actions

- (void)handleTimerTask
{
    NSLog(@"handleTimerTask");
    
    // 只有在上面do while循环中使用-runMode:beforDate才有效
    if (kUseParticularModeToStartRunLoop) {
        _timerIndex ++;
        NSLog(@"timer Index : %ld", _timerIndex);
        if (_timerIndex > 5) {
            CFRunLoopStop(CFRunLoopGetCurrent()); //只有在-runMode:beforDate 和 -run 两种情况下有效
        }
    }
}

@end
