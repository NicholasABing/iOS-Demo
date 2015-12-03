//
//  ViewController.m
//  iOS多线程Demo
//
//  Created by beijingjiayu on 15/11/26.
//  Copyright © 2015年 JiaYuHuLian. All rights reserved.
//
/**
 线程的管理: 主要包括 创建,配置,退出 三部分.
           主要包括 线程的创建成本,线程的创建,线程属性的配置,线程主体入口函数的编写,线程中断 等.
 
 */

#import "ViewController.h"
#import "NSRunLoopDemo(多线程).h"


@interface ViewController (){
    BOOL end;
}

@end

@implementation ViewController

/**
 线程的创建主要分三部分:1,主体入口点, 2,可用线程(用以启动被创建的线程) 3,线程的属性配置.
 
 常见的线程创建方式有:1,NSThread,  2,POSIX, 3,NSObject
 */


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self nsthreadCreateThread];
//    [self nsThreadCreateByPOSIX];
//    [self createThreadByNSObject];
    
//    NSRunLoopDemo_____ *runLoop = [[NSRunLoopDemo_____ alloc]init];
//    [runLoop runLoopsObservers];
    

        NSLog(@"start new thread");

        [NSThread detachNewThreadSelector:@selector(runOnNewThread) toTarget:self withObject:nil];  // 此方法创建的线程不需要释放内存,比较便利,因此NSThread创建线程大多用这种方式.
    
        while (!end) {
            NSLog(@"runloop…");
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            NSLog(@"runloop end.");
        }
        NSLog(@"ok.");
    
}

-(void)runOnNewThread{
    
    NSLog(@"run for new thread …");
    sleep(1);
//    end=YES;
    [self performSelectorOnMainThread:@selector(setEnd) withObject:nil waitUntilDone:NO];
    NSLog(@"end.");
}

-(void)setEnd{
    
    end = YES;
}

#pragma mark - NSThread创建线程举例
-(void)nsthreadCreateThread{
    //    1.通过NSThread创建线程
    [NSThread detachNewThreadSelector:@selector(myThreadMain) toTarget:self withObject:nil];
    // 线程的主体入口点是myThreadMain, 可用线程为self.  此线程的属性配置不能在线程创建前配置,只能在线程内配置.
    
    //    2,创建一个NSThread实例,然后调用它的start方法启动线程
    NSThread *myThread = [[NSThread alloc]initWithTarget:self selector:@selector(myThreadMain) object:nil];
    /**
     线程的属性配置:主要包括线程的堆栈大小,本地存储,线程的脱离状态,线程的优先级
     */
//  1.堆栈大小  [myThread setStackSize:<#(NSUInteger)#>];  cocoa线程只有通过new Thread类的方法创建的线程才能设置堆栈的大小.
//  2.本地存储   每一个线程都维护着一个字典的结构.  访问这个字典结构的方法为:
    NSDictionary *threadDic = [[NSThread currentThread] threadDictionary];
//    这样就能通过设置字典来设置线程所维护的这个字典结构.
    
//  3.线程的脱离状态     脱离线程(deatch Thread) ---- 线程完成后,由系统回收该线程所占用的内存资源.     可连接线程(joinable Thread) --- 线程完成后,可连接线程不回收.
    /*
     注:在应用程序退出时,脱离线程可以立即被中断,而可连接线程则不可以。每个可连接 线程必须在进程被允许可以退出的时候被连接。所以当线程处于周期性工作而不允许被中断的时 候,比如保存数据到硬盘,可连接线程是最佳选择。
     如果你想要创建可连接线程,唯一的办法是使用 POSIX 线程。POSIX 默认创建的 线程是可连接的。通过pthread_attr_setdetachstate函数设置是否脱离属性
     */
    
//   4.线程的优先级
    [myThread setThreadPriority:2];   //设置线程的优先级
    
    [myThread start];
    
    //线程的主体入口点是myThreadMain, 可用线程为self, 此线程的属性配置可以在创建线程之后,开始线程之前.
    
    //    注：通过NSThread创建的线程，主要通过performSelector:onThread:withObject:withUntilDone方法进行线程间通信比较便捷的方法之一。
    
/**
 *   线程主体函数  在线程的主体函数中,主要做三个工作:
 1,创建一个自动释放池.  注意:要经常主动清理释放自动释放池中的内存,提高线程的内存空间
 2,设置异常处理  ----  添加try/catch块,捕获任何未知的线程异常,并提供适当的响应.
 3,设置一个run loop  ---  对于需要动态处理到来任务请求的线程,需要给线程添加一个run loop.
 
 */
    
    
    
/**
 *   中断线程   ---   需要注意的是:尽量保证线程从主体入口函数里面退出,这样能保证线程的资源被自动释放.
 */
}


#pragma mark - POSIX创建线程
-(void)nsThreadCreateByPOSIX{
        //    纯C的东西,还是不看了吧.
    
}



#pragma mark - NSObject创建线程
-(void)createThreadByNSObject{
    //    类似于NSThread创建,先创建一个实例对象,然后用实例对象调用
    NSObject *o = [[NSObject alloc]init];
    [o performSelectorOnMainThread:@selector(myThreadMain) withObject:nil waitUntilDone:YES];  //此方法能进行线程间的通信,使用比较方便.
}

-(void)myThreadMain{
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
