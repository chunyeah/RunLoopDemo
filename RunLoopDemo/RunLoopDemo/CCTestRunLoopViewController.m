//
//  CCViewController.m
//  RunLoopDemo
//
//  Created by Chun Ye on 10/20/14.
//  Copyright (c) 2014 Chun Tips. All rights reserved.
//

#import "CCTestRunLoopViewController.h"
#import "CCAppDelegate.h"

@interface CCTestRunLoopViewController ()

@property (nonatomic) BOOL normalThreadDidFinishFlag;
@property (nonatomic) BOOL runLoopThreadDidFinishFlag;

@end

@implementation CCTestRunLoopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIButton appearance] setBackgroundColor:[UIColor blueColor]];
    
    /* 点击之后 产生一个普通的Thread执行任务,线程完成之后再继续运行。 在这个过程中 会阻塞UI线程。点击下面的Normal按钮没有输出。 */
    UIButton *normalThreadButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 200, 50)];
    [normalThreadButton setTitle:@"Normal Thread" forState:UIControlStateNormal];
    [normalThreadButton addTarget:self action:@selector(handleNormalThreadButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:normalThreadButton];
    
    /* 点击之后 启动一个线程，使用Run Loop，等待线程完成后再继续执行任务。 在这个过程中 不会阻塞UI线程。点击下面的Normal按钮会正常输出。 */
    UIButton *runLoopThreadButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 200, 50)];
    [runLoopThreadButton setTitle:@"Run Loop Thread" forState:UIControlStateNormal];
    [runLoopThreadButton addTarget:self action:@selector(handleRunLoopThreadButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:runLoopThreadButton];
    
    /* 测试Button 看UI是否能正常响应 */
    UIButton *normalButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 170, 200, 50)];
    [normalButton setTitle:@"Normal" forState:UIControlStateNormal];
    [normalButton addTarget:self action:@selector(handleNormalButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:normalButton];
    
    /* Test Run Loop Custom Source Thread Button */
    {
        UIButton *testCustomSourceButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 300, 300, 50)];
        [testCustomSourceButton setTitle:@"Test Custom Source" forState:UIControlStateNormal];
        [testCustomSourceButton addTarget:self action:@selector(handleTestCustomSourceButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:testCustomSourceButton];
    }
 }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Handler

- (void)handleNormalThreadButtonTouchUpInside
{
    NSLog(@"Enter handleNormalThreadButtonTouchUpInside");
    
    self.normalThreadDidFinishFlag = NO;

    NSLog(@"Start a New Normal Thread");
    NSThread *normalThread = [[NSThread alloc] initWithTarget:self selector:@selector(handleNormalThreadTask) object:nil];
    [normalThread start];
    
    //等待线程完成再执行以下任务，在这种情况下会阻塞UI线程
    while (!self.normalThreadDidFinishFlag) {
        [NSThread sleepForTimeInterval:0.5];
    }
    
    //直到线程执行完成，才会打印handleNormalButtonTouchUpInside中的输出信息
    NSLog(@"Exit handleNormalThreadButtonTouchUpInside");
}

- (void)handleRunLoopThreadButtonTouchUpInside
{
    NSLog(@"Enter handleRunLoopThreadButtonTouchUpInside");
    
    self.runLoopThreadDidFinishFlag = NO;
    
    NSLog(@"Start a New Run Loop Thread");
    NSThread *runLoopThread = [[NSThread alloc] initWithTarget:self selector:@selector(handleRunLoopThreadTask) object:nil];
    [runLoopThread start];
    
    //使用Run Loop，在线程执行期间，handleNormalButtonTouchUpInside能够正常输入信息
    while (!self.runLoopThreadDidFinishFlag) {
        NSLog(@"Begin RunLoop");
        
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        
        NSLog(@"End RunLoop");
    }
    
    //Run Loop 真神奇
    NSLog(@"Exit handleRunLoopThreadButtonTouchUpInside");

}

- (void)handleNormalButtonTouchUpInside
{
    NSLog(@"Enter handleNormalButtonTouchUpInside");

    NSLog(@"Exit handleNormalButtonTouchUpInside");
}

- (void)handleTestCustomSourceButtonTouchUpInside
{
    CCAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate testInputSourceEvent];
}

#pragma mark - Private

- (void)handleNormalThreadTask
{
    NSLog(@"Enter Normal Thread");
    
    for (NSInteger i = 0; i < 5; i ++) {
        NSLog(@"In Normal Thread, count = %ld", i);
        sleep(1);
    }
    
    _normalThreadDidFinishFlag = YES;
    
    NSLog(@"Exit Normal Thread");
}

- (void)handleRunLoopThreadTask
{
    NSLog(@"Enter Run Loop Thread");
    
    for (NSInteger i = 0; i < 5; i ++) {
        NSLog(@"In Run Loop Thread, count = %ld", i);
        sleep(1);
    }
    
#if 0
    // 错误示范
    _runLoopThreadDidFinishFlag = YES;
    // 这个时候并不能执行线程完成之后的任务，因为Run Loop所在的线程并不知道runLoopThreadDidFinishFlag被重新赋值。Run Loop这个时候没有被任务事件源唤醒。
    // 你会发现这个时候点击屏幕中的UI，线程将会继续执行。 因为Run Loop被UI事件唤醒。
    // 正确的做法是使用 "selector"方法唤醒Run Loop。 即如下:
#else
    [self performSelectorOnMainThread:@selector(updateRunLoopThreadDidFinishFlag) withObject:nil waitUntilDone:NO];
#endif
    
    NSLog(@"Exit Run Loop Thread");
}

- (void)updateRunLoopThreadDidFinishFlag
{
    _runLoopThreadDidFinishFlag = YES;
}

@end
