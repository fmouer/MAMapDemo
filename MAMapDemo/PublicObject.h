//
//  PublicObject.h
//  MAMapDemo
//
//  Created by fmouer on 15/10/22.
//  Copyright © 2015年 fmouer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicObject : NSObject
#pragma  mark - 异步执行
+(void)dispatchAsyncBlock:(void(^)(void))block;

//主线程 执行
+(void)dispatchMainQueueBlock:(void(^)(void))block;

//延时执行
+ (void)dispatchQueueDelayTime:(float)delayTime block:(void(^)(void))block;

@end
