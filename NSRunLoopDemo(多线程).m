//
//  NSRunLoopDemo(多线程).m
//  iOS多线程Demo
//
//  Created by beijingjiayu on 15/11/27.
//  Copyright © 2015年 JiaYuHuLian. All rights reserved.
//

/**
 *  线程经典处理事件图示.
 
 *  由图可以看到:run loop的输入源有:  
    1,基于端口的输入源 -- port sources
    2,自定义的输入源  --  custom sources
    3,cocoa执行的selector源 -- "performselector..." 方法
    4.定时源   --  timer sources
 *  run loop处理不同输入源的机制有:
    1,处理端口的输入源  --  handleport
    2,处理用户自定义输入源 -- customSrc
    3,处理selector的源  --  myselector
    4,处理定时源  -- timerFired
 
 * 注: 线程除了处理输入源,runloops也会生成关于run loop行为的通知(notification),run loop观察者(run loop observers)可以接受到这些通知,并在线程上面使用它们来做额外的处理.
 
 */

#import "NSRunLoopDemo(多线程).h"

@interface NSRunLoopDemo_____ (){
    
    NSRunLoop *runLoop;
}

@end

@implementation NSRunLoopDemo_____

//编写一个带有观察者的线程加载程序

-(void)runLoopsObservers{
    
        //    建立自动释放池
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init]; 非arc下可用
        //    拿到当前线程的run loop
     runLoop = [NSRunLoop currentRunLoop];
        //    设置runloopobserver的运行环境
    NSLog(@"currentRunLoopMode = %@",runLoop.currentMode);
    // 打印结果:  currentRunLoopMode = UIInitializationRunLoopMode

    
    /*
     
     typedef struct {
     CFIndex	version;
     void *	info;
     const void *(*retain)(const void *info);
     void	(*release)(const void *info);
     CFStringRef	(*copyDescription)(const void *info);
     } CFRunLoopObserverContext;
     
     */
    
    CFRunLoopObserverContext observerContext = {0,(__bridge void *)(self),NULL,NULL,NULL};
    
        //   创建runloopobserver对象
    /*
     
     // 第一个参数用于分配该observer对象的内存
     // 第二个参数用以设置该observer所要关注的的事件，详见回调函数myRunLoopObserver中注释
     // 第三个参数用于标识该observer是在第一次进入run loop时执行还是每次进入run loop处理时均执行
     // 第四个参数用于设置该observer的优先级
     // 第五个参数用于设置该observer的回调函数
     // 第六个参数用于设置该observer的运行环境

     */
    CFRunLoopObserverRef runLoopObserverRef = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &myRunLoopObserver, &observerContext);
    if (runLoopObserverRef) {
            //        将cocoa的NSRunLoop类型转换成Core Foundation的CFRunLoopRef类型
        CFRunLoopRef c = [runLoop getCFRunLoop];
            //        将新建的observer添加到当前线程的runloop
        CFRunLoopAddObserver(c, runLoopObserverRef, kCFRunLoopDefaultMode);
    }
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(doFireTimer:) userInfo:nil repeats:YES];
    NSInteger loopCount = 10;
    do {
        
        // 启动当前thread的run loop直到所指定的时间到达，在run loop运行时，run loop会处理所有来自与该run loop联系的input sources的数据
        // 对于本例与当前run loop联系的input source只有Timer类型的source
        // 该Timer每隔0.1秒发送触发时间给run loop，run loop检测到该事件时会调用相应的处理方法（doFireTimer:）
        // 由于在run loop添加了observer，且设置observer对所有的run loop行为感兴趣
        // 当调用runUntilDate方法时，observer检测到run loop启动并进入循环，observer会调用其回调函数，第二个参数所传递的行为时kCFRunLoopEntry
        // observer检测到run loop的其他行为并调用回调函数的操作与上面的描述相类似

        [runLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
        --loopCount;
        
        // 当run loop的运行时间到达时，会退出当前的run loop，observer同样会检测到run loop的退出行为，并调用其回调函数，第二个参数传递的行为是kCFRunLoopExit.
        
    } while (loopCount);
    
    //    释放自动释放池   [pool release];
}

-(void)doFireTimer:(int)a{
    [runLoop runMode:NSRunLoopCommonModes beforeDate:[NSDate dateWithTimeIntervalSinceNow:100]];
}

void myRunLoopObserver(CFRunLoopObserverRef observer,CFRunLoopActivity activity,void *info){
    
    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"runloop entry");
            break;
        case kCFRunLoopBeforeTimers:
            NSLog(@"runloop before timers");
            break;
        case kCFRunLoopBeforeSources:
            NSLog(@"runloop before Sources");
            break;
        case kCFRunLoopBeforeWaiting:
            NSLog(@"runloop before waiting");
            break;
        case kCFRunLoopAfterWaiting:
            NSLog(@"runloop after waiting");
            break;
        case kCFRunLoopExit:
            NSLog(@"runloop exit");
            break;
            
            
        default:
            break;
    }
    
}



@end
