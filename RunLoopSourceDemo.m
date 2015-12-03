//
//  RunLoopSourceDemo.m
//  iOS多线程Demo
//
//  Created by beijingjiayu on 15/11/27.
//  Copyright © 2015年 JiaYuHuLian. All rights reserved.
//

/**

 *  何时使用run loop?  当辅助线程与线程有较多交互时使用.  
 比如:
    * 1,使用端口或其他自定义源与其他线程进行通讯.
    * 2,线程(非主线程)使用定时器时使用.
    * 3,Cocoa中使用任何的"performSelector..."方法时
    * 4,使用线程周期性的工作.
 */

/**
    * runLoop源的配置:  runLoop源的配置主要包括四个方面:  定义/创建源 ---> 安装(将源安装到runLoop) ---> 注册(将安装的源注册到客户端) ----> 调用(通知输入源,开始工作)
 */

#import "RunLoopSourceDemo.h"
#import <CoreFoundation/CoreFoundation.h>
#import "AppDelegate.h"
#import <Foundation/Foundation.h>
#import "RunLoopContextDemo.h"




@implementation RunLoopSourceDemo
    
    
@end
