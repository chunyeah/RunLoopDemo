//
//  CCRunLoopInputSource.h
//  RunLoopDemo
//
//  Created by Chun Ye on 10/20/14.
//  Copyright (c) 2014 Chun Tips. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CCRunLoopInputSourceTestDelegate <NSObject>

- (void)activeInputSourceForTestPrintStringEvent:(NSString *)string;

@end

@interface CCRunLoopInputSource : NSObject


@property (nonatomic, weak) id <CCRunLoopInputSourceTestDelegate> delegate;

// 初始化和销毁
- (instancetype)init;
- (void)addToCurrentRunLoop;
- (void)invalidate;

// 处理事件
- (void)inputSourceFired;

// 其他线程注册事件
- (void)addCommand:(NSInteger)command data:(NSData *)data;
- (void)addTestPrintCommandWithString:(NSString *)string;

- (void)fireAllCommandsOnRunLoop:(CFRunLoopRef)runLoop;

@end

// 容器类，用来保存和传递数据
@interface CCRunLoopContext : NSObject

@property (nonatomic, readonly) CFRunLoopRef runLoop;
@property (nonatomic, readonly) CCRunLoopInputSource *runLoopInputSource;

- (instancetype)initWithSource:(CCRunLoopInputSource *)runLoopInputSource runLoop:(CFRunLoopRef)runLoop;

@end