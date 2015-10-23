//
//  PublicObject.m
//  MAMapDemo
//
//  Created by fmouer on 15/10/22.
//  Copyright © 2015年 fmouer. All rights reserved.
//

#import "PublicObject.h"

@implementation PublicObject

#pragma  mark - 异步执行
+(void)dispatchAsyncBlock:(void(^)(void))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),block);
}
//主线程 执行
+(void)dispatchMainQueueBlock:(void(^)(void))block
{
    dispatch_async(dispatch_get_main_queue(),block);
}
//延时执行
+ (void)dispatchQueueDelayTime:(float)delayTime block:(void(^)(void))block
{
    double delayInSeconds = delayTime;
    //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
    dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    //推迟两纳秒执行
    dispatch_queue_t concurrentQueue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_after(delayInNanoSeconds, concurrentQueue, ^{
        [self dispatchMainQueueBlock:block];
    });
}

@end
