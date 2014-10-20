//
//  AppDelegate.h
//  RunLoopDemo
//
//  Created by Chun Ye on 10/20/14.
//  Copyright (c) 2014 Chun Tips. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCRunLoopInputSource.h"

@interface CCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

@interface CCAppDelegate (RunLoop)

- (void)registerSource:(CCRunLoopContext *)sourceContext;

- (void)removeSource:(CCRunLoopContext *)sourceContext;

- (void)testInputSourceEvent;

@end